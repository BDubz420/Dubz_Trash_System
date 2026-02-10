AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
local config = include("dubz_config.lua")

function ENT:Initialize()
	self:SetModel(config.Models.Vendor)
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)	
	self:CapabilitiesAdd( CAP_ANIMATEDFACE || CAP_TURN_HEAD )

	self:DropToFloor()
	self:SetTrigger(true)

	self:SetNWInt("HoldingTrashBlocks", 0)
	self:SetNWInt("HoldingTrashWeight", 0)
	self.LastVoiceTime = 0

	local idleSequence = self:LookupSequence("idle_subtle")
	if idleSequence <= 0 then
		idleSequence = self:LookupSequence("idle_all_01")
	end
	if idleSequence > 0 then
		self:SetSequence(idleSequence)
		self:SetPlaybackRate(1)
	end
end

function ENT:StartTouch(ent)
	if ent:GetClass() == "dubz_trash_block" then
		self:SetNWInt("HoldingTrashBlocks", self:GetNWInt("HoldingTrashBlocks") + 1)
		self:SetNWInt("HoldingTrashWeight", self:GetNWInt("HoldingTrashWeight") + ent:GetNWInt("TrashWeight", 0))
		ent:Remove()
	end
end

function ENT:Use(ply)
	if config.Vendor.VoiceLines and #config.Vendor.VoiceLines > 0 then
		local now = CurTime()
		if now - (self.LastVoiceTime or 0) >= config.Vendor.VoiceCooldown then
			self:EmitSound(config.Vendor.VoiceLines[math.random(1, #config.Vendor.VoiceLines)])
			self.LastVoiceTime = now
		end
	end

	if self:GetNWInt("HoldingTrashBlocks") > 0 then
		local blockCount = self:GetNWInt("HoldingTrashBlocks", 0)
		local weight = self:GetNWInt("HoldingTrashWeight", 0)
		local payout = (weight * config.Economy.PricePerKg) + (blockCount * config.Economy.BlockBonus)
		payout = math.max(payout, config.Economy.MinimumPayout)

		if config.Economy.RoundTo and config.Economy.RoundTo > 0 then
			payout = math.Round(payout / config.Economy.RoundTo) * config.Economy.RoundTo
		else
			payout = math.Round(payout)
		end

		ply:addMoney(payout)
		ply:SendLua([[chat.AddText( Color(255,50,0), "]] .. config.General.ChatPrefix .. [[ ", Color(255,255,255), " You have sold your trash for $]] .. payout .. [[.")]])
		self:SetNWInt("HoldingTrashBlocks", 0)
		self:SetNWInt("HoldingTrashWeight", 0)
	end
end

function ENT:Think()
	local nearestPlayer
	local nearestDistance = config.Vendor.LookRange

	for _, ply in ipairs(player.GetAll()) do
		if IsValid(ply) and ply:Alive() then
			local dist = ply:GetPos():Distance(self:GetPos())
			if dist < nearestDistance then
				nearestDistance = dist
				nearestPlayer = ply
			end
		end
	end

	if IsValid(nearestPlayer) then
		local targetPos = nearestPlayer:EyePos()
		self:SetEyeTarget(targetPos)

		local ang = (targetPos - self:EyePos()):Angle()
		local localAng = self:WorldToLocalAngles(ang)
		self:SetPoseParameter("head_yaw", math.Clamp(localAng.y, -60, 60))
		self:SetPoseParameter("head_pitch", math.Clamp(-localAng.p, -40, 40))
	end

	self:NextThink(CurTime())
	return true
end
