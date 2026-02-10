ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Trash Compactor"
ENT.Author = "ITZJAN"
ENT.Contact = "Via Steam"
ENT.Spawnable = true
ENT.Category = "Dubz Trash System"
ENT.AdminSpawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "owning_ent")
end