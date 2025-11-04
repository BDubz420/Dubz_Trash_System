
ENT.Type = "ai"
ENT.Base = "base_ai"
ENT.PrintName = "Trash Collector NPC"
ENT.Author = "BDubz420"
ENT.Category = "Dubz Trash System"
ENT.Spawnable = true
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AdminSpawnable = true
ENT.AutomaticFrameAdvance = true

function ENT:SetupDataTables()
    self:NetworkVar("Int", 0, "TrashSellPrice")
    self:NetworkVar("String", 0, "NPCName")
    self:NetworkVar("Int", 1, "Shmeckles")
end

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
    self.AutomaticFrameAdvance = bUsingAnim
end