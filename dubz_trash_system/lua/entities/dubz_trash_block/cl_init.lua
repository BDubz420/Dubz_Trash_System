include("shared.lua")


surface.CreateFont( "Font", {
	font = "Trebuchet24", 
	size = ScreenScale(7)
})

surface.CreateFont( "Font2", {
	font = "Trebuchet24", 
	size = ScreenScale(5)
})

function ENT:Draw()

	self:DrawModel()

	local pos = self:GetPos()
	local ang = self:GetAngles()

    local text = "Trash Block"
    local text2 = self:GetNWInt("TrashWeight", 0).."kg"
	local drawdistance = 245

	ang:RotateAroundAxis(ang:Up(), 90)
	
	if LocalPlayer():GetPos():Distance(self:GetPos()) < drawdistance then
 		cam.Start3D2D(pos + ang:Up(), Angle(0, LocalPlayer():EyeAngles().y-90, 90), 0.17)
			draw.SimpleText(text, "Font", 0, -100, Color(255, 255, 255), 1, 1)
			draw.SimpleText(text2, "Font2", 0, -80, Color(255, 255, 255), 1, 1)
 		cam.End3D2D()
 	end
end