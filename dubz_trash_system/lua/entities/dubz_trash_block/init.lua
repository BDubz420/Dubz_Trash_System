AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
local config = include("dubz_config.lua")

local function ApplyBlockWeight(ent, weight)
	ent:SetNWInt("TrashWeight", weight)

	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetMass(config.Physics.BlockMassBase + (weight * config.Physics.BlockMassPerKg))
		phys:Wake()
	end
end

function ENT:Initialize()
	self:SetModel(config.Models.TrashBlock.Model)
	self:SetMaterial(config.Models.TrashBlock.Material)
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType(SIMPLE_USE)
	ApplyBlockWeight(self, 0)
end

function ENT:SetTrashWeight(weight)
	ApplyBlockWeight(self, weight)
end
