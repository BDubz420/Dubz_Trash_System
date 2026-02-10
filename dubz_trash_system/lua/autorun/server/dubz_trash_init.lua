AddCSLuaFile("dubz_config.lua")

local meta = FindMetaTable("Player")
local config = include("dubz_config.lua")

local maxcompactortrash = config.Limits.MaxCompactorTrash
local maxplytrash = config.Limits.MaxPlayerTrash
local maxplyweight = config.Limits.MaxPlayerWeight

function meta:CollectTrash(ent)

	local trash = ent:GetNWInt("TrashBeingHeld", 0)
	local plytrash = self:GetNWInt("TrashAmount", 0)
	local binWeight = ent:GetNWInt("TrashWeightInBin", 0)
	local plyWeight = self:GetNWInt("TrashWeight", 0)

	if plytrash == maxplytrash then return end
	if trash > 0 then

		local remainingtrash = maxplytrash -plytrash
		if remainingtrash == 0 then return end
		if trash >= remainingtrash then

			self:SetNWInt("TrashAmount", self:GetNWInt("TrashAmount") + remainingtrash ) -- add remaining trash to ply
			ent:SetNWInt("TrashBeingHeld", ent:GetNWInt("TrashBeingHeld") -remainingtrash) -- subtract remaining trash from ent
			local weightPerItem = binWeight / math.max(trash, 1)
			local weightToAdd = math.floor(weightPerItem * remainingtrash)
			if plyWeight + weightToAdd > maxplyweight then
				weightToAdd = math.max(maxplyweight - plyWeight, 0)
			end
			self:SetNWInt("TrashWeight", plyWeight + weightToAdd)
			ent:SetNWInt("TrashWeightInBin", math.max(binWeight - weightToAdd, 0))
			self:SendLua([[chat.AddText( Color(255,50,0), "]] .. config.General.ChatPrefix .. [[ ", Color(255,255,255), "You have collected ]] .. remainingtrash .. [[ trash.")]])
		else

			self:SetNWInt("TrashAmount", self:GetNWInt("TrashAmount") + trash ) -- withdraw all trash 
			ent:SetNWInt("TrashBeingHeld", 0) -- set ent trash to 0
			local weightToAdd = binWeight
			if plyWeight + weightToAdd > maxplyweight then
				weightToAdd = math.max(maxplyweight - plyWeight, 0)
			end
			self:SetNWInt("TrashWeight", plyWeight + weightToAdd)
			ent:SetNWInt("TrashWeightInBin", math.max(binWeight - weightToAdd, 0))
			self:SendLua([[chat.AddText( Color(255,50,0), "]] .. config.General.ChatPrefix .. [[ ", Color(255,255,255), "You have collected ]] .. trash .. [[ trash.")]])
		end
	end
end

function meta:DepositTrash(ent)

	local trash = ent:GetNWInt("TrashHeldInCompactor", 0)
	local plytrash = self:GetNWInt("TrashAmount", 0)
	local plyWeight = self:GetNWInt("TrashWeight", 0)

	if trash == maxcompactortrash then return end
	if plytrash > 0 then

		local remainingtrash = maxcompactortrash -trash
		if remainingtrash == 0 then return end
		
		if plytrash >= remainingtrash then
 
			ent:SetNWInt("TrashHeldInCompactor", ent:GetNWInt("TrashHeldInCompactor") + remainingtrash) -- add remaining trash to ent
			self:SetNWInt("TrashAmount", self:GetNWInt("TrashAmount") - remainingtrash ) -- subtract remaining trash to ply
			local weightPerItem = plyWeight / math.max(plytrash, 1)
			local weightToMove = math.floor(weightPerItem * remainingtrash)
			ent:SetNWInt("TrashWeightInCompactor", ent:GetNWInt("TrashWeightInCompactor") + weightToMove)
			self:SetNWInt("TrashWeight", math.max(plyWeight - weightToMove, 0))
			self:SendLua([[chat.AddText( Color(255,50,0), "]] .. config.General.ChatPrefix .. [[ ", Color(255,255,255), "You put ]] .. remainingtrash .. [[ trash into the compactor.")]])
		else

			ent:SetNWInt("TrashHeldInCompactor", ent:GetNWInt("TrashHeldInCompactor") + plytrash ) -- add all ply trash to ent
			self:SetNWInt("TrashAmount", 0) -- set ply trash to 0
			ent:SetNWInt("TrashWeightInCompactor", ent:GetNWInt("TrashWeightInCompactor") + plyWeight)
			self:SetNWInt("TrashWeight", 0)
			self:SendLua([[chat.AddText( Color(255,50,0), "]] .. config.General.ChatPrefix .. [[ ", Color(255,255,255), "You put ]] .. plytrash .. [[ trash into the compactor.")]])
		end
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
