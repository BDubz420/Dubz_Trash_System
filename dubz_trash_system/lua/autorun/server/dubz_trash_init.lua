AddCSLuaFile("dubz_config.lua")

local meta = FindMetaTable("Player")
local config = include("dubz_config.lua")

local maxcompactorweight = config.Limits.MaxCompactorWeight
local maxplyweight = config.Limits.MaxPlayerWeight

function meta:CollectTrash(ent)

	local binWeight = ent:GetNWInt("TrashWeightInBin", 0)
	local plyWeight = self:GetNWInt("TrashWeight", 0)

	if plyWeight >= maxplyweight then return end
	if binWeight > 0 then

		local remainingWeight = maxplyweight - plyWeight
		local weightToAdd = math.min(binWeight, remainingWeight)

		self:SetNWInt("TrashWeight", plyWeight + weightToAdd)
		ent:SetNWInt("TrashWeightInBin", math.max(binWeight - weightToAdd, 0))
		self:SendLua([[chat.AddText( Color(255,50,0), "]] .. config.General.ChatPrefix .. [[ ", Color(255,255,255), "You have collected ]] .. weightToAdd .. [[kg of trash.")]])
	end
end

function meta:DepositTrash(ent)

	local plyWeight = self:GetNWInt("TrashWeight", 0)
	local compactorWeight = ent:GetNWInt("TrashWeightInCompactor", 0)

	if compactorWeight >= maxcompactorweight then return end
	if plyWeight > 0 then

		local remainingWeight = maxcompactorweight - compactorWeight
		local weightToMove = math.min(plyWeight, remainingWeight)

		ent:SetNWInt("TrashWeightInCompactor", compactorWeight + weightToMove)
		self:SetNWInt("TrashWeight", math.max(plyWeight - weightToMove, 0))
		self:SendLua([[chat.AddText( Color(255,50,0), "]] .. config.General.ChatPrefix .. [[ ", Color(255,255,255), "You put ]] .. weightToMove .. [[kg into the compactor.")]])
	end
end

local function IsVisibleToPlayer(ply, pos)
	local eyePos = ply:EyePos()
	local dir = (pos - eyePos):GetNormalized()
	local dot = dir:Dot(ply:GetAimVector())
	local fov = ply:GetFOV()
	if dot < math.cos(math.rad(fov * 0.5)) then return false end

	local trace = util.TraceLine({
		start = eyePos,
		endpos = pos,
		filter = ply,
		mask = MASK_SOLID_BRUSHONLY,
	})

	return trace.Fraction == 1
end

local function IsVisibleToAnyPlayer(pos)
	for _, ply in ipairs(player.GetAll()) do
		if IsValid(ply) and ply:Alive() then
			if IsVisibleToPlayer(ply, pos) then
				return true
			end
		end
	end
	return false
end

local function FindSpawnPositionForPlayer(ply)
	local attempts = config.Spawns.Attempts
	local minDistance = config.Spawns.MinDistance
	local maxDistance = config.Spawns.MaxDistance
	local blindSpotDot = config.Spawns.BlindSpotDot

	for _ = 1, attempts do
		local baseAng = ply:EyeAngles()
		local yawOffset = math.Rand(140, 220)
		local spawnAng = Angle(0, baseAng.y + yawOffset, 0)
		local distance = math.Rand(minDistance, maxDistance)
		local candidate = ply:GetPos() + spawnAng:Forward() * distance

		local downTrace = util.TraceLine({
			start = candidate + Vector(0, 0, 64),
			endpos = candidate - Vector(0, 0, 256),
			filter = ply,
			mask = MASK_SOLID_BRUSHONLY,
		})

		if not downTrace.Hit then continue end

		local spawnPos = downTrace.HitPos + Vector(0, 0, 5)
		local dir = (spawnPos - ply:EyePos()):GetNormalized()
		if dir:Dot(ply:GetAimVector()) > blindSpotDot then continue end
		if IsVisibleToAnyPlayer(spawnPos) then continue end

		return spawnPos
	end

	return nil
end

local function RegisterSpawnedTrash(ent, owner)
	ent.DubzTrashOwner = owner
	ent:CallOnRemove("DubzTrashCleanup", function(removed)
		if not removed.DubzTrashOwner or not IsValid(removed.DubzTrashOwner) then return end
		local list = removed.DubzTrashOwner.DubzTrashSpawned
		if not list then return end
		for index, stored in ipairs(list) do
			if stored == removed then
				table.remove(list, index)
				break
			end
		end
	end)
end

local function CleanupPlayerTrash(ply)
	if not ply.DubzTrashSpawned then return end
	for _, ent in ipairs(ply.DubzTrashSpawned) do
		if IsValid(ent) then
			ent:Remove()
		end
	end
	ply.DubzTrashSpawned = nil
end

hook.Add("PlayerDisconnected", "DubzTrashCleanupPlayer", CleanupPlayerTrash)

timer.Create("DubzTrashSpawnSystem", config.Spawns.Interval, 0, function()
	if not config.Spawns.Enabled then return end

	local globalCount = 0
	for _, ply in ipairs(player.GetAll()) do
		if ply.DubzTrashSpawned then
			for _, ent in ipairs(ply.DubzTrashSpawned) do
				if IsValid(ent) then
					globalCount = globalCount + 1
				end
			end
		end
	end

	for _, ply in ipairs(player.GetAll()) do
		if not IsValid(ply) or not ply:Alive() then continue end

		ply.DubzTrashSpawned = ply.DubzTrashSpawned or {}

		for index = #ply.DubzTrashSpawned, 1, -1 do
			local ent = ply.DubzTrashSpawned[index]
			if not IsValid(ent) then
				table.remove(ply.DubzTrashSpawned, index)
			elseif ent:GetPos():Distance(ply:GetPos()) > config.Spawns.CleanupDistance then
				ent:Remove()
				table.remove(ply.DubzTrashSpawned, index)
			end
		end

		while #ply.DubzTrashSpawned < config.Spawns.MaxTrashPerPlayer and globalCount < config.Spawns.MaxTrashGlobal do
			local spawnPos = FindSpawnPositionForPlayer(ply)
			if not spawnPos then break end

			local trash = ents.Create("dubz_trash")
			trash:SetPos(spawnPos)
			trash:Spawn()

			table.insert(ply.DubzTrashSpawned, trash)
			RegisterSpawnedTrash(trash, ply)
			globalCount = globalCount + 1
		end
	end
end)
