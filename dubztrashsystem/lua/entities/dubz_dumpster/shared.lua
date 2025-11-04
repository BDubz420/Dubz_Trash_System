ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Dumpster"
ENT.Author = "ITZJAN"
ENT.Contact = "Via Steam"
ENT.Spawnable = true
ENT.Category = "Dubz Trash System"
ENT.AdminSpawnable = true

function ENT:SetupDataTables()
    self:NetworkVar("Int", 1, "Holding")
end
