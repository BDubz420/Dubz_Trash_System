AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
local config = include("dubz_config.lua")

function ENT:Initialize()
	self:SetModel(table.Random(config.Models.Trash))
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType(SIMPLE_USE)

	local weight = math.random(config.Weights.TrashItem.Min, config.Weights.TrashItem.Max)
	self:SetNWInt("TrashWeight", weight)

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMass(config.Physics.TrashMassBase + (weight * config.Physics.TrashMassPerKg))
		phys:Wake()
	end
end

local sounds = config.Sounds.TrashBin

function ENT:Touch(ent, ply)
	if ent:GetClass() == "ms_trash" then
		self:EmitSound(sounds[math.random(1, #sounds)])
    	self:Remove()
	end
end

function ENT:Use(ply)	
	if ( self:IsPlayerHolding() ) then return end

	ply:PickupObject( self )
end
