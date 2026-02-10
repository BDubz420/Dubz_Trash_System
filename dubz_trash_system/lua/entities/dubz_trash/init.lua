AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
include("dubz_config.lua")

function ENT:Initialize()
	self:SetModel(table.Random(trashmodels))
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
    phys:Wake()
end

local sounds = trashsounds

function ENT:Touch(ent, ply)
	if ent:GetClass() == "ms_trash" then
		for _, sounds in pairs( sounds ) do
			self:EmitSound( sounds[math.random( 1, #sounds )] )
    	end		
    	self:Remove()
	end
end

function ENT:Use(ply)	
	if ( self:IsPlayerHolding() ) then return end

	ply:PickupObject( self )
end