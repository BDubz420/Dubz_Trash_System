AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
local config = include("dubz_config.lua")

util.AddNetworkString("DubzTrashSendTime")
util.AddNetworkString("DubzTrashSendCTime")

function ENT:Initialize()
	self:SetModel(config.Models.Compactor)
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
    phys:Wake()

	self:SetNWInt("TrashHeldInCompactor", 0)
	self:SetNWInt("TrashWeightInCompactor", 0)
	self:SetNWBool("Compacting", false)
	self.BasePos = self:GetPos()
end

function ENT:SpawnFunction(ply, trace)
	local ent = ents.Create("dubz_trash_compactor")
	ent:SetPos(trace.HitPos + trace.HitNormal * 16)
	ent:Spawn()
	ent:Activate()
     
	return ent
end

function ENT:StartTouch(ent)
	if self:GetNWInt("TrashHeldInCompactor") == config.Limits.MaxCompactorTrash then return end
	if ent:GetClass() == "dubz_trash" then
		local itemWeight = ent:GetNWInt("TrashWeight", 1)
		self:SetNWInt("TrashHeldInCompactor", self:GetNWInt("TrashHeldInCompactor") + 1)
		self:SetNWInt("TrashWeightInCompactor", self:GetNWInt("TrashWeightInCompactor") + itemWeight)
		ent:Remove()	

		if config.Compactor.PlaySounds then
			ent:EmitSound(config.Sounds.TrashBin[math.random(1, #config.Sounds.TrashBin)])
		end
	end
end

local function StartCompactorShake(ent)
	if not config.Compactor.Shake.Enabled then return end

	local interval = config.Compactor.Shake.Interval
	local offset = config.Compactor.Shake.Offset
	local basePos = ent.BasePos or ent:GetPos()
	ent.BasePos = basePos

	timer.Create("DubzTrashShake_" .. ent:EntIndex(), interval, 0, function()
		if not IsValid(ent) or not ent:GetNWBool("Compacting") then
			if IsValid(ent) then
				ent:SetPos(ent.BasePos)
			end
			timer.Remove("DubzTrashShake_" .. ent:EntIndex())
			return
		end
		local shakeOffset = Vector(
			math.Rand(-offset, offset),
			math.Rand(-offset, offset),
			math.Rand(-offset * 0.5, offset * 0.5)
		)
		ent:SetPos(ent.BasePos + shakeOffset)
	end)
end

local function StopCompactorShake(ent)
	timer.Remove("DubzTrashShake_" .. ent:EntIndex())
	if IsValid(ent) then
		ent:SetPos(ent.BasePos or ent:GetPos())
	end
end

local delay = 2
local shouldOccur = true
function ENT:AcceptInput( input, ply )
	if shouldOccur then
		if input == "Use" and ply:IsPlayer() then
			local heldTrash = self:GetNWInt("TrashHeldInCompactor")
			local isFull = heldTrash == config.Limits.MaxCompactorTrash
			if isFull or (not config.Compactor.RequireFullLoad and heldTrash > 0) then
				self.BasePos = self:GetPos()

				net.Start("DubzTrashSendTime")
				net.WriteEntity(self)
				net.WriteInt(config.Compactor.CompactingTime, 32)
				net.Broadcast()

			    self:SetNWBool("Compacting", true)
				self.EffectTime = CurTime() + config.Compactor.CompactingTime

				if config.Compactor.PlaySounds then
					self:EmitSound(config.Compactor.StartSound)
					if config.Compactor.LoopSound and config.Compactor.LoopSound ~= "" then
						self.CompactorLoop = CreateSound(self, config.Compactor.LoopSound)
						self.CompactorLoop:Play()
					end
				end
				StartCompactorShake(self)

				timer.Simple(config.Compactor.CompactingTime, function()
					if not IsValid(self) then return end

					StopCompactorShake(self)
					if self.CompactorLoop then
						self.CompactorLoop:Stop()
						self.CompactorLoop = nil
					end

					if config.Compactor.PlaySounds then
						self:EmitSound(config.Compactor.CompletionSound)
					end

					local trashblock = ents.Create("dubz_trash_block")
					trashblock:SetPos(self:GetPos() + Vector(0, 0, 50))
					trashblock:Spawn()

					local blockWeight = self:GetNWInt("TrashWeightInCompactor", 0)
					if config.Weights.UseItemWeightsForBlocks then
						if config.Weights.Block.ClampToRange then
							blockWeight = math.Clamp(blockWeight, config.Weights.Block.Min, config.Weights.Block.Max)
						end
					else
						blockWeight = math.random(config.Weights.Block.Min, config.Weights.Block.Max)
					end

					if trashblock.SetTrashWeight then
						trashblock:SetTrashWeight(blockWeight)
					else
						trashblock:SetNWInt("TrashWeight", blockWeight)
					end

			    	self:SetNWBool("Compacting", false)
					self:SetNWInt("TrashHeldInCompactor", 0)
					self:SetNWInt("TrashWeightInCompactor", 0)

					local owner = self:Getowning_ent()
					if IsValid(owner) then
						owner:SendLua([[chat.AddText( Color(255,50,0), "]] .. config.General.ChatPrefix .. [[ ", Color(255,255,255), " Your trash compactor has finished processing.")]])
					end
				end)
			else
				local trash = config.Limits.MaxCompactorTrash - self:GetNWInt("TrashHeldInCompactor")
				ply:SendLua([[chat.AddText( Color(255,50,0), "]] .. config.General.ChatPrefix .. [[ ", Color(255,255,255), " Add ]] .. trash .. [[ trash to start the machine!")]])
			end
		end

		shouldOccur = false
		timer.Simple( delay, function() shouldOccur = true end )
	end
end

function ENT:Think()
	if self:GetNWBool("Compacting") == true then
		local effectData = EffectData()
		effectData:SetStart(self:GetPos())
		effectData:SetOrigin(self:GetPos())
		effectData:SetScale(8)
		util.Effect("GlassImpact", effectData, true, true)

		self.EffectTime = CurTime() + config.Compactor.CompactingTime
	end
end

function ENT:OnRemove()
	if not IsValid(self) then return end
	StopCompactorShake(self)
	if self.CompactorLoop then
		self.CompactorLoop:Stop()
		self.CompactorLoop = nil
	end
end

local function PlayerPickup( ply, ent )
	if ent:GetClass() == "dubz_trash_compactor" and ply == ent:Getowning_ent() then
	    return true
	end
end
hook.Add( "PhysgunPickup", "Allow Player to pickup mailbox", PlayerPickup )
