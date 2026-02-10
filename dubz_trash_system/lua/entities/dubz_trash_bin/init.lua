AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
include("dubz_config.lua")

function ENT:Initialize()
	self:SetModel("models/props_trainstation/trashcan_indoor001b.mdl")
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
    phys:Wake()

    self:SetNWInt("TrashBeingHeld", 0)
end

function ENT:StartTouch(ent)

	if ent:GetClass() == "dubz_trash" then

		self:SetNWInt("TrashBeingHeld", self:GetNWInt("TrashBeingHeld") + 1)
		ent:Remove()

		for _, trashsounds in pairs( trashsounds ) do

			ent:EmitSound( trashsounds[math.random( 1, #trashsounds )] )
	    end
	end
end

function ENT:AcceptInput( input, ply )

	if input == "Use" and ply:IsPlayer() then

		if table.HasValue({TEAM_TRASH}, ply:Team()) then

			if self:GetNWInt("TrashBeingHeld") == 0 then
				DarkRP.notify(ply, 0, 4, "Trash can is empty!")
			else

				ply:CollectTrash(self)
			end
		else

			DarkRP.notify(ply, 1, 6, "You are not a trash collector!")
		end
	end
end