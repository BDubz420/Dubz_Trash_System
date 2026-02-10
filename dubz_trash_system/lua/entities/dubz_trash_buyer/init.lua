AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")
include("dubz_config.lua")

local trashprice = 100

function ENT:Initialize()
	self:SetModel("models/Humans/Group03/male_03.mdl")
	self:SetHullType(HULL_HUMAN)
	self:SetHullSizeNormal()
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)	
	self:CapabilitiesAdd( CAP_ANIMATEDFACE || CAP_TURN_HEAD )

	self:DropToFloor()
	self:SetTrigger(true)

	self:SetNWInt("HoldingTrashBlocks", 0)
end

function ENT:StartTouch(ent)
	if ent:GetClass() == "dubz_trash_block" then
		self:SetNWInt("HoldingTrashBlocks", self:GetNWInt("HoldingTrashBlocks") + 1)
		ent:Remove()
	end
end

function ENT:Use(ply)
	if self:GetNWInt("HoldingTrashBlocks") > 0 then
		ply:addMoney(self:GetNWInt("HoldingTrashBlocks", 0) * trashprice)
		ply:SendLua([[chat.AddText( Color(255,50,0), "[DTS] ", Color(255,255,255), " You have sold your trash for $]] .. self:GetNWInt("HoldingTrashBlocks", 0) * trashprice .. [[.")]])
		self:SetNWInt("HoldingTrashBlocks", 0)
	end
end