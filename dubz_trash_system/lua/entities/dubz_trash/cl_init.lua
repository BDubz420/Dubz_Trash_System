include("shared.lua")
local config = include("dubz_config.lua")

function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos()
	local ang = self:GetAngles()
	local weight = self:GetNWInt("TrashWeight", 0)
	local text = "Trash (" .. weight .. "kg)"
	local drawdistance = 245

	ang:RotateAroundAxis(ang:Up(), 90)

	if LocalPlayer():GetPos():Distance(self:GetPos()) < drawdistance then
		cam.Start3D2D(pos + ang:Up(), Angle(0, LocalPlayer():EyeAngles().y-90, 90), 0.13)
			draw.SimpleText( text, "Trebuchet24", 0, -125, Color(255,255,255,255), 1, 1)
		cam.End3D2D()
	end
end
