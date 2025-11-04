-- init.lua
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString("collectoropenmenu")
util.AddNetworkString("cashouttrash")
util.AddNetworkString("ShowConversionMessage")

local MinTrashSellPrice = 5
local MaxTrashSellPrice = 250

local trash_npc_playermodels = {
    "models/Humans/Group03/male_01.mdl",
    "models/Humans/Group03/male_02.mdl",
    "models/Humans/Group03/male_03.mdl",
    "models/Humans/Group03/male_04.mdl",
    "models/Humans/Group03/male_05.mdl",
    "models/Humans/Group03/male_06.mdl",
    "models/Humans/Group03/male_07.mdl",
    "models/Humans/Group03/male_08.mdl",
    "models/Humans/Group03/male_09.mdl",
}

local npcnames = {
    "Frank", "Billy", "Joe", "Tom", "Chuck", "Larry", "Steve", "Dave", "Sam", 
    "Greg", "Rick", "Vince", "Rob", "Dan", "Tony", "Bob", "Mike", "John", 
    "Pete", "Al", "Ray", "Charlie", "Jack", "Oscar", "Tim", "Dan"
}

function ENT:Initialize()
    self:SetModel(table.Random(trash_npc_playermodels))
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:SetSolid(SOLID_BBOX)
    self:SetUseType(SIMPLE_USE)
    self:DropToFloor()
    self:SetTrigger(true)

    -- Set the initial conversion rate when the NPC spawns
    self:SetTrashSellPrice(math.random(MinTrashSellPrice, MaxTrashSellPrice))
    self:SetNPCName(table.Random(npcnames))

    -- Periodically update the conversion rate
    timer.Create("UpdateConversionRate_" .. self:EntIndex(), 30, 0, function()
        if IsValid(self) then
            self:SetTrashSellPrice(math.random(MinTrashSellPrice, MaxTrashSellPrice))
        end
    end)
end

function ENT:OnTakeDamage()
    return 0
end

function ENT:AcceptInput(_, _, activator)
    net.Start("collectoropenmenu")
    net.WriteEntity(self)
    net.WriteInt(self:GetTrashSellPrice(), 24)
    net.WriteString(self:GetNPCName())
    net.WriteEntity(activator)
    net.Send(activator)
end

-- Convert shmeckles to cash
net.Receive("cashouttrash", function(_, ply)
    local collector = net.ReadEntity()
    local shmeckles = ply:GetNWInt("Shmeckles", 0)

    if shmeckles < 1 then
        return
    end

    local cashConverted = shmeckles * collector:GetTrashSellPrice()
    ply:addMoney(cashConverted)

    -- Send the message to the client
    net.Start("ShowConversionMessage")
    net.WriteInt(shmeckles, 32)
    net.WriteInt(cashConverted, 32)
    net.Send(ply)

    ply:SetNWInt("Shmeckles", 0)
end)
