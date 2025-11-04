include("shared.lua")

surface.CreateFont( "dubztrashfont1", {
    font = "Trebuchet18",
    size = 18,
    weight = 600,
    antialias = true
} )

function ENT:Draw()
    self:DrawModel()

    if( self:GetPos():Distance( LocalPlayer():GetPos() ) > 1500 ) then return end

    self:DrawModel()

    if( self:GetPos():Distance( LocalPlayer():GetPos() ) > 500 ) then return end
    
    local pos = self:GetPos( )
    local ang = self:GetAngles( )

    ang:RotateAroundAxis( ang:Up( ), 90 )
    ang:RotateAroundAxis( ang:Forward( ), 0 )

    cam.Start3D2D( pos + ang:Up( ), Angle( 1, LocalPlayer( ):EyeAngles( ).y - 90, 90 ), 0.11 )
        draw.SimpleText("Holding: "..self:GetHolding(), "Trebuchet24", 0, -120, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText("Press 'e' to collect earnings.", "Trebuchet18", 0, -100, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    cam.End3D2D()
end

function ENT:Draw()
    self:DrawModel()
    local pos2 = self:GetPos() + ( self:GetAngles():Forward() * 23.46 ) + ( self:GetAngles():Up() *10.4  ) + (self:GetAngles():Right() *25.3)
    local ang2 = self:GetAngles()
    local eyetrace = LocalPlayer():GetEyeTrace()
    ang2:RotateAroundAxis(ang2:Up(), 90)
    cam.Start3D2D(pos2,Angle(ang2.p,ang2.y,ang2.r+97), 0.113)
    --draw.RoundedBox(0,-5,0,455,100, Color(32,32,37,255))
    --draw.RoundedBox(0,-5,0,455,5, Color(248,42,74,255))
    if LocalPlayer():GetEyeTrace().Entity then
        if LocalPlayer():GetEyeTrace().Entity == self then
            local tr = self:WorldToLocal(LocalPlayer():GetEyeTrace().HitPos)
            draw.SimpleText("Holding: "..self:GetHolding(), "Trebuchet24", 455/2,55/2, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            draw.SimpleText("Press 'e' to collect earnings.", "Trebuchet24", 455/2,100/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    end

    cam.End3D2D()
end


hook.Add("HUDPaint", "ShowShmecklesOnHUD", function()
    local player = LocalPlayer()
    local shmeckles = player:GetNWInt("Shmeckles", 0)  -- Get the shmeckles, default to 0 if not set

    if shmeckles > 0 then

	    local gap = ScrH() * 0.01
	    local boxW, boxH = ScrW() * 0.15, ScrH() * 0.025

	    draw.RoundedBox(8, ScrW() / 2 - boxW / 2, (ScrH() - boxH) - gap, boxW, boxH, Color(0, 0, 0, 200))
	    draw.SimpleText("Shmeckles: " .. shmeckles, "dubztrashfont1", ScrW() / 2, (ScrH() - boxH) - (gap - boxH / 2), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    else
    	return
    end
end)

net.Receive("SendDumpsterReminder", function()
    -- Read the message and color values from the net message
    local message = net.ReadString()
    local r = net.ReadUInt(8)
    local g = net.ReadUInt(8)
    local b = net.ReadUInt(8)
    
    -- Create a color object from the received color values
    local customColor = Color(r, g, b)
    
    -- Send the message to the player's chat
    chat.AddText(customColor, "Trash Collector: ", Color(255, 255, 255), message)
end)