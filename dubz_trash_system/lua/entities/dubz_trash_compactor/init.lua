AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
include("dubz_config.lua")

util.AddNetworkString("DubzTrashSendTime")
util.AddNetworkString("DubzTrashSendCTime")

function ENT:Initialize()
	self:SetModel("models/props_wasteland/laundry_washer003.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
    phys:Wake()

    self:SetNWInt("TrashHeldInCompactor", 0)
    self:SetNWBool("Compacting", false)
end

function ENT:SpawnFunction(ply, trace)
	local ent = ents.Create("dubz_trash_compactor")
	ent:SetPos(trace.HitPos + trace.HitNormal * 16)
	ent:Spawn()
	ent:Activate()
     
	return ent
end

function ENT:StartTouch(ent)
	if self:GetNWInt("TrashHeldInCompactor") == maxcompactortrash then return end
	if ent:GetClass() == "dubz_trash" then
		self:SetNWInt("TrashHeldInCompactor", self:GetNWInt("TrashHeldInCompactor") + 1)
		ent:Remove()	

		for _, trashsounds in pairs( trashsounds ) do

			ent:EmitSound( trashsounds[math.random( 1, #trashsounds )] )
	    end
	end
end

local delay = 2
local shouldOccur = true
function ENT:AcceptInput( input, ply )
	if shouldOccur then
		if input == "Use" and ply:IsPlayer() then
			if self:GetNWInt("TrashHeldInCompactor") == maxcompactortrash then

				net.Start("DubzTrashSendTime")
				net.WriteEntity(self)
				net.WriteInt(compactingtime,32)
				net.Broadcast()

			    self:SetNWBool("Compacting", true)
				self.EffectTime = CurTime() + compactingtime

				timer.Simple(compactingtime, function()	

					--self:StopLoopingSound(1)
					self:EmitSound("buttons/button4.wav")					

					local trashblock = ents.Create("dubz_trash_block")
					trashblock:SetPos(self:GetPos() + Vector(0, 0, 50))
					trashblock:Spawn()

			    	self:SetNWBool("Compacting", false)
					self:SetNWInt("TrashHeldInCompactor", 0)

					self:Getowning_ent():SendLua([[chat.AddText( Color(255,50,0), "[DTS] ", Color(255,255,255), " Your trash compactor has finished processing.")]])
				end)
			else
				local trash = maxcompactortrash - self:GetNWInt("TrashHeldInCompactor")
				ply:SendLua([[chat.AddText( Color(255,50,0), "[DTS] ", Color(255,255,255), " Add ]] .. trash .. [[ trash to start the machine!")]])
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

		self.EffectTime = CurTime() + compactingtime
	end
end

function ENT:OnRemove()
	if not IsValid(self) then return end
end

local function PlayerPickup( ply, ent )
	if ent:GetClass() == "dubz_trash_compactor" and ply == ent:Getowning_ent() then
	    return true
	end
end
hook.Add( "PhysgunPickup", "Allow Player to pickup mailbox", PlayerPickup )