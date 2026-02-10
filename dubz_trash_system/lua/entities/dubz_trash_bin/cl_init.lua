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
	
	local distance = LocalPlayer():GetPos():DistToSqr(self:GetPos())
	if distance > 2000000 then return end

    local pos = self:GetPos()
    local ang = self:GetAngles()
    local eyepos = EyePos()
    local planeNormal = ang:Up()
	local relativeEye = eyepos - pos
    local relativeEyeOnPlane = relativeEye - planeNormal * relativeEye:Dot(planeNormal)
    local textAng = relativeEyeOnPlane:AngleEx(planeNormal)

	ang:RotateAroundAxis(ang:Forward(), 90)
	textAng:RotateAroundAxis(textAng:Up(), 90)
    textAng:RotateAroundAxis(textAng:Forward(), 90)
	
 	cam.Start3D2D(pos - ang:Right() * 11.5 , textAng, 0.17)
		draw.SimpleText("Trash: "..self:GetNWInt("TrashWeightInBin",0).."kg", "Font", 0, -120, Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("Press 'e' to collect the trash.", "Font2", 0, -100, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
 	cam.End3D2D()
end
