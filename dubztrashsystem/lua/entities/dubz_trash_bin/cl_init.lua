include("shared.lua")

surface.CreateFont( "dubztrashfont1", {
    font = "Trebuchet18",
    size = 18,
    weight = 600,
    antialias = true
} )

surface.CreateFont( "dubztrashfont2", {
    font = "Trebuchet24",
    size = 12,
    weight = 600,
    antialias = true
} )

function ENT:Initialize()
    self.Time = 0
    self.ShowTime = 0
    net.Receive("Dubz_DumpsterSendTime",function()
        net.ReadEntity().Time = CurTime()+net.ReadInt(32)
    end)
end

function ENT:Think()
    if self.Time > 0 then
        self.ShowTime = self.Time - CurTime()
    end
end

function ENT:Draw()
    self:DrawModel()
end

hook.Add("HUDPaint", "TrashSearchHUD", function()
    local player = LocalPlayer()
    local eye = player:GetEyeTrace()
    local ent = eye.Entity

    if not IsValid(ent) then return end
    -- Check if the entity is a trash bin
    if ent:GetClass() == "dubz_trash_bin" then
        -- Calculate the distance between the player and the trash bin
        local dist = player:GetPos():Distance(ent:GetPos())

        -- Show the HUD only if the player is close enough (you can adjust the distance threshold)
        if dist <= 100 then  -- 200 units is the distance threshold, change this value if necessary
            local tr = ent:WorldToLocal(eye.HitPos)
            local gap = ScrH() * 0.1
            local boxW, boxH = ScrW() * 0.15, ScrH() * 0.025

            if ent.ShowTime == nil or ent.ShowTime <= 0 then
                -- Display the "Press 'E' to search" message
                draw.RoundedBox(8, ScrW() / 2 - boxW / 2, (ScrH() - boxH) - gap, boxW, boxH, Color(0, 0, 0, 200))
                draw.SimpleText("Press 'e' to search.", "dubztrashfont1", ScrW() / 2, (ScrH() - boxH) - (gap - boxH / 2), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            else
                -- Convert ShowTime to minutes and seconds
                local minutes = math.floor(ent.ShowTime / 60)
                local seconds = math.floor(ent.ShowTime % 60)

                -- Format the time as MM:SS
                local formattedTime = string.format("%02d:%02d", minutes, seconds)

                -- Display the "Lootable in: MM:SS" message
                draw.RoundedBox(8, ScrW() / 2 - boxW / 2, (ScrH() - boxH) - gap, boxW, boxH, Color(0, 0, 0, 200))
                draw.SimpleText("Lootable in: " .. formattedTime, "dubztrashfont1", ScrW() / 2, (ScrH() - boxH) - (gap - boxH / 2), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
        end
    end
end)

