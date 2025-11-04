AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

local model = {
"models/props_junk/garbage_milkcarton001a.mdl",
"models/props_junk/garbage_bag001a.mdl",
"models/props_junk/garbage_metalcan001a.mdl",
"models/props_junk/Shoe001a.mdl",
"models/props_vehicles/carparts_muffler01a.mdl",
"models/props_vehicles/carparts_axel01a.mdl",
"models/props_vehicles/carparts_door01a.mdl",
"models/props_interiors/Furniture_chair03a.mdl",
"models/props_junk/garbage_milkcarton002a.mdl",
"models/props_junk/garbage_metalcan002a.mdl",
"models/props_junk/garbage_carboard002a.mdl",
"models/props_junk/TrafficCone001a.mdl",
"models/props_lab/harddrive01.mdl",
"models/props_junk/plasticbucket001a.mdl",
"models/props_junk/MetalBucket01a.mdl",
"models/props_junk/metal_paintcan001b.mdl",
"models/props_interiors/pot02a.mdl",
"models/props_combine/breenglobe.mdl",
"models/props_junk/PropaneCanister001a.mdl",
"models/props_lab/lockerdoorleft.mdl",
"models/props_junk/meathook001a.mdl",
"models/props_c17/lampShade001a.mdl",
"models/props_c17/playground_swingset_seat01a.mdl",
"models/props_c17/doll01.mdl",
"models/props_c17/chair_office01a.mdl",
"models/props_canal/mattpipe.mdl",
"models/props_combine/breenclock.mdl",
"models/props_lab/hevplate.mdl",
"models/props_lab/reciever01c.mdl",
"models/props_trainstation/payphone_reciever001a.mdl",
"models/props_junk/garbage_newspaper001a.mdl",
"models/props_junk/garbage_plasticbottle001a.mdl",
"models/props_junk/garbage_plasticbottle003a.mdl",
"models/props_junk/garbage_plasticbottle002a.mdl",
"models/props_junk/sawblade001a.mdl",
"models/props_interiors/pot01a.mdl",
"models/props_junk/CinderBlock01a.mdl",
"models/props_c17/tools_wrench01a.mdl"
}

function ENT:Initialize()
	self:SetModel(table.Random(model))
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
    phys:Wake()
end

function PlayerPickupObject( ply, obj )
	if ( obj:IsPlayerHolding() ) then return end

	ply:PickupObject( obj )
end