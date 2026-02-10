include("shared.lua")
local config = include("dubz_config.lua")

local maxcompactortrash = config.Limits.MaxCompactorTrash
local compactTime = math.max(config.Compactor.CompactingTime, 1)
local ypos = 150
local x = 100
local xpos = (x /2) -20

function ENT:Initialize()
	self.Time = 0
	self.ShowTime = 0
	net.Receive("DubzTrashSendTime",function()
		net.ReadEntity().Time = CurTime()+net.ReadInt(32)
	end)
end

function ENT:Think()
	if self.Time > 0 then
		self.ShowTime = self.Time - CurTime()
	end
end

function ENT:Draw()
	if self:GetPos():Distance(LocalPlayer():GetPos()) > 2000 then return end

	self:DrawModel()

	if self:GetPos():Distance(LocalPlayer():GetPos()) > 400 then return end

	local owner = self:Getowning_ent()
    owner = (IsValid(owner) and owner:Nick()) or DarkRP.getPhrase("unknown")

	local pos2 = self:GetPos() + ( self:GetAngles():Forward() * -18 ) + ( self:GetAngles():Up() *22.2  ) + (self:GetAngles():Right() *-3)
	local ang2 = self:GetAngles()

	ang2:RotateAroundAxis(ang2:Up(), 180)

 	cam.Start3D2D(pos2,Angle(ang2.p,ang2.y,ang2.r+35), 0.113)
 		draw.RoundedBox(0,-160,0,283,180,Color(30,30,30))
 		draw.RoundedBox(0,-160,0,283,5,Color(255, 50, 0))
		draw.SimpleText("Trash Compactor","Font",-20,10,Color(255, 50, 0),TEXT_ALIGN_CENTER)
		draw.SimpleText("Max: " .. maxcompactortrash,"Font",-20,35,Color(255, 255, 255),TEXT_ALIGN_CENTER)

		local heldTrash = self:GetNWInt("TrashHeldInCompactor", 0)
		if self:GetNWBool("Compacting") == true then
			draw.SimpleText("Compacting...", "Font", -20, 60, Color(255, 255, 255), TEXT_ALIGN_CENTER)
		elseif heldTrash <= 0 then
			draw.SimpleText("Empty", "Font", -20, 60, Color(255, 255, 255), TEXT_ALIGN_CENTER)
		elseif heldTrash >= maxcompactortrash then
			draw.SimpleText("Full", "Font", -20, 60, Color(255, 255, 255), TEXT_ALIGN_CENTER)
		else
			draw.SimpleText("Trash: " .. heldTrash, "Font", -20, 60, Color(255, 255, 255), TEXT_ALIGN_CENTER)
		end

		if self:GetNWBool("Compacting") == false then
			if config.Compactor.RequireFullLoad and heldTrash < maxcompactortrash then
				local trash = maxcompactortrash - heldTrash
				draw.SimpleText("Add "..trash.." more trash to start.", "Font", -20, 85, Color(255, 255, 255), TEXT_ALIGN_CENTER)
			elseif heldTrash > 0 then
				draw.SimpleText("Press 'e' to start compacting", "Font", -20, 85, Color(255, 255, 255), TEXT_ALIGN_CENTER)
			end
		end

 		-- Progress Bar
 		draw.RoundedBox(4, -70, ypos, 104, 9, Color(25,25,25))

		if self.ShowTime == nil or self.ShowTime <= 0 then
			//nothing
		else
			draw.SimpleText("Please wait "..math.Round(self.ShowTime).." seconds", "Font", -20, 85,Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)

 			-- Progress Bar internal
 			draw.RoundedBox(4, -68, ypos +2, 100 * ( math.Round(self.ShowTime) / compactTime), 5,Color(255, 50, 0))
		end

 		draw.SimpleText(owner, "Font", -20, 115, Color(255, 50, 0), TEXT_ALIGN_CENTER)
 	cam.End3D2D()
end

