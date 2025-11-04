AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

--[[
-- Mapping of models to shmeckle values and names
local trashModelToInfo = {
    ["models/props_junk/garbage_milkcarton001a.mdl"] = {name = "Milk Carton", shmeckles = 10},
    ["models/props_junk/garbage_bag001a.mdl"] = {name = "Garbage Bag", shmeckles = 5},
    ["models/props_junk/garbage_metalcan001a.mdl"] = {name = "Metal Can", shmeckles = 7},
    ["models/props_junk/Shoe001a.mdl"] = {name = "Shoe", shmeckles = 8},
    ["models/props_vehicles/carparts_muffler01a.mdl"] = {name = "Car Muffler", shmeckles = 15},
    ["models/props_vehicles/carparts_axel01a.mdl"] = {name = "Car Axle", shmeckles = 12},
    ["models/props_vehicles/carparts_door01a.mdl"] = {name = "Car Door", shmeckles = 20},
    ["models/props_interiors/Furniture_chair03a.mdl"] = {name = "Chair", shmeckles = 10},
    ["models/props_junk/garbage_milkcarton002a.mdl"] = {name = "Milk Carton", shmeckles = 10},
    ["models/props_junk/garbage_metalcan002a.mdl"] = {name = "Metal Can", shmeckles = 7},
    -- Add other models here...
}
--]]

-- A table to store players interacting with the dumpster
local playersUsingDumpster = {}

-- The time interval for sending reminder (in seconds)
local reminderInterval = 2 * 60  -- Every 2 minutes

local sounds = {
    {
        "physics/plastic/plastic_barrel_break1.wav",
        "physics/plastic/plastic_barrel_break2.wav",
    }
}

function ENT:Initialize()
    self:SetModel("models/props_junk/TrashDumpster01a.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
    phys:Wake()
end

function ENT:StartTouch(ent)
    if ent:GetClass() == "dubz_trash" then
        self:SetHolding(self:GetHolding() + 1)
        ent:Remove()
        for _, sound in pairs(sounds) do
            ent:EmitSound(sound[math.random(1, #sound)])
        end
    end
end

-- Function to add shmeckles to the player
function AddShmeckles(player, amount)
    if IsValid(player) then  -- Check if the player is valid
        local currentShmeckles = player:GetNWInt("Shmeckles")
        local newShmeckles = currentShmeckles + amount
        player:SetNWInt("Shmeckles", newShmeckles)
    end
end

function ENT:Use(ply)
    if IsValid(ply) and ply:IsPlayer() then  -- Ensure ply is a valid player
        ply:SetNWInt("Shmeckles", 0)
        if self:GetHolding() > 0 then
            AddShmeckles(ply, self:GetHolding())  -- Add the shmeckles to the player

            ply:EmitSound("ui/buttonclickrelease.wav")

            -- Track the player as using the dumpster
            playersUsingDumpster[ply] = true
        end
        self:SetHolding(0)
    end
end

function ENT:EndTouch(ent)
    if ent:IsPlayer() then
        -- Remove the player from the tracking table when they stop using the dumpster
        playersUsingDumpster[ent] = nil
    end
end

-- Function to send the reminder message to the player
local function sendReminderMessage(player)
    -- Define the custom color for the message (orange for Trash Collector)
    local customColor = Color(255, 165, 0)  -- Default orange color
    local message = "Visit the Trash Collector to convert them into Cash!"
    
    -- Start a net message to send to the client
    net.Start("SendDumpsterReminder")
    net.WriteString(message)
    net.WriteUInt(customColor.r, 8)
    net.WriteUInt(customColor.g, 8)
    net.WriteUInt(customColor.b, 8)
    net.Send(player)
end

-- Timer that runs every reminderInterval and sends the message to players using the dumpster
timer.Create("DumpsterReminderTimer", reminderInterval, 0, function()
    -- Loop through all players using the dumpster
    for player, _ in pairs(playersUsingDumpster) do
        if IsValid(player) then
            -- Send reminder message to the player
            sendReminderMessage(player)
        end
    end
end)

-- Make sure to stop the timer when it's no longer needed
function ENT:OnRemove()
    timer.Remove("DumpsterReminderTimer")
end