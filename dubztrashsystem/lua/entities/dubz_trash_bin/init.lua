AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
util.AddNetworkString("Dubz_DumpsterSendTime")

local trashcanmodels = {
  "models/props_trainstation/trashcan_indoor001b.mdl",
  "models/props_trainstation/trashcan_indoor001a.mdl"
}
 
function ENT:Initialize()
  self:SetModel(table.Random(trashcanmodels))
  self:PhysicsInit(SOLID_VPHYSICS)
  self:SetSolid(SOLID_VPHYSICS) 
  self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetTrigger(true)
  local phys = self:GetPhysicsObject()
	phys:SetMass(100)
  if phys:IsValid() then
    phys:Wake()
	end
end

function ENT:Use(ply)
  if self.CanUse == false then return end
  --print(ply:getJobTable().name)
  if Dubz_DumpsterAddon.DumpsterJobs[ply:getJobTable().name] == nil and table.Count(Dubz_DumpsterAddon.DumpsterJobs) >= 1 then return end
  net.Start("Dubz_DumpsterSendTime")
  net.WriteEntity(self)
  net.WriteInt(Dubz_DumpsterAddon.DumpsterCooldown,32)
  net.Broadcast()


  -- Random Props
  for i=1,Dubz_DumpsterAddon.DumpsterPropsAmount do
    local dumpsterprop = ents.Create("dubz_trash")
    dumpsterprop:SetModel(table.Random(Dubz_DumpsterAddon.DumpsterProps))
    dumpsterprop:SetPos(self:GetPos()+Vector(math.random(-15,15),math.random(-40,40),math.random(30,50)))
    dumpsterprop:Spawn()
    timer.Simple(20,function()
     if dumpsterprop:IsValid() then
       dumpsterprop:Remove()
     end
    end)
 end
 -- Random Money
  if Dubz_DumpsterAddon.ChanceOfMoneyDrop >= math.random(1,100) then
    local moneyent = ents.Create(GAMEMODE.Config.MoneyClass)
    moneyent:SetPos(self:GetPos()+Vector(math.random(-5,5),math.random(-10,10),math.random(30,50)))
    moneyent:Setamount(math.random(Dubz_DumpsterAddon.MinimumMoneyDrop,Dubz_DumpsterAddon.MaximumMoneyDrop))
    moneyent:Spawn()
 end
 -- Random Entities/Weapons
 for a=1,Dubz_DumpsterAddon.DumpsterEntChances do
   local tableitem = table.Random(Dubz_DumpsterAddon.DumpsterEnts)
    if tableitem[2] >= math.random(1,100) then
      local ent = ents.Create(tableitem[1])
      ent:SetPos(self:GetPos()+Vector(math.random(-5,5),math.random(-10,10),math.random(30,50)))
      ent:Spawn()
    end
 end

  self.CanUse = false
  timer.Simple(Dubz_DumpsterAddon.DumpsterCooldown,function()
    self.CanUse = true
  end)
end