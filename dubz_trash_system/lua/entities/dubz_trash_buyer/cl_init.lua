include("shared.lua")
local config = include("dubz_config.lua")

local ypos = -150

function ENT:Draw()

	if( self:GetPos():Distance( LocalPlayer():GetPos() ) > 1500 ) then return end

	self:DrawModel()

	if( self:GetPos():Distance( LocalPlayer():GetPos() ) > 500 ) then return end
	
	local ang = LocalPlayer():EyeAngles()

	local pos
    if self:LookupBone("ValveBiped.Bip01_Head1") != nil then
    	pos = self:GetBonePosition(self:LookupBone("ValveBiped.Bip01_Head1")) + Vector(0,0,3)
    else 
    	pos = self:GetPos()+ Vector(0,0,68)
    end 

	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 90)

	cam.Start3D2D(pos, ang, 0.11)
		draw.WordBox(6, 0, ypos +32, config.Vendor.Name, "Trebuchet24", Color(140, 0, 0, 100), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()

	cam.Start3D2D(pos, ang, 0.05)
		draw.WordBox(8, 0, ypos -35, config.Vendor.Tagline, "Trebuchet24", Color(140, 0, 0, 100), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

		if self:GetNWInt("HoldingTrashBlocks") > 0 then
			draw.WordBox(8, 0, ypos +15, config.Vendor.SellHint, "Trebuchet24", Color(140, 0, 0, 100), Color(255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end	
	cam.End3D2D()
end
