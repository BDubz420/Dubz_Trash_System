AddCSLuaFile("dubz_config.lua")

local meta = FindMetaTable("Player")
local config = include("dubz_config.lua")

local maxcompactortrash = config.Limits.MaxCompactorTrash
local maxplytrash = config.Limits.MaxPlayerTrash

function meta:CollectTrash(ent)

	local trash = ent:GetNWInt("TrashBeingHeld", 0)
	local plytrash = self:GetNWInt("TrashAmount", 0)

	if plytrash == maxplytrash then return end
	if trash > 0 then

		local remainingtrash = maxplytrash -plytrash
		if remainingtrash == 0 then return end
		if trash >= remainingtrash then

			self:SetNWInt("TrashAmount", self:GetNWInt("TrashAmount") + remainingtrash ) -- add remaining trash to ply
			ent:SetNWInt("TrashBeingHeld", ent:GetNWInt("TrashBeingHeld") -remainingtrash) -- subtract remaining trash from ent
			self:SendLua([[chat.AddText( Color(255,50,0), "]] .. config.General.ChatPrefix .. [[ ", Color(255,255,255), "You have collected ]] .. remainingtrash .. [[ trash.")]])
		else

			self:SetNWInt("TrashAmount", self:GetNWInt("TrashAmount") + trash ) -- withdraw all trash 
			ent:SetNWInt("TrashBeingHeld", 0) -- set ent trash to 0
			self:SendLua([[chat.AddText( Color(255,50,0), "]] .. config.General.ChatPrefix .. [[ ", Color(255,255,255), "You have collected ]] .. trash .. [[ trash.")]])
		end
	end
end

function meta:DepositTrash(ent)

	local trash = ent:GetNWInt("TrashHeldInCompactor", 0)
	local plytrash = self:GetNWInt("TrashAmount", 0)

	if trash == maxcompactortrash then return end
	if plytrash > 0 then

		local remainingtrash = maxcompactortrash -trash
		if remainingtrash == 0 then return end
		
		if plytrash >= remainingtrash then
 
			ent:SetNWInt("TrashHeldInCompactor", ent:GetNWInt("TrashHeldInCompactor") + remainingtrash) -- add remaining trash to ent
			self:SetNWInt("TrashAmount", self:GetNWInt("TrashAmount") - remainingtrash ) -- subtract remaining trash to ply
			self:SendLua([[chat.AddText( Color(255,50,0), "]] .. config.General.ChatPrefix .. [[ ", Color(255,255,255), "You put ]] .. remainingtrash .. [[ trash into the compactor.")]])
		else

			ent:SetNWInt("TrashHeldInCompactor", ent:GetNWInt("TrashHeldInCompactor") + plytrash ) -- add all ply trash to ent
			self:SetNWInt("TrashAmount", 0) -- set ply trash to 0
			self:SendLua([[chat.AddText( Color(255,50,0), "]] .. config.General.ChatPrefix .. [[ ", Color(255,255,255), "You put ]] .. plytrash .. [[ trash into the compactor.")]])
		end
	end
end
