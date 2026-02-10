--[[-------------------------------------------------------------------------
 				  Dubz Trash System Config File
 				Only for use in Vintage Roleplay ;)
---------------------------------------------------------------------------]]	
priceperkg = 10							--This is the pice per kg of trash

minweight = 1							--This is the min weight (kg) of the trash blocks
maxweight = 10							--This is the max weight (kg) of the trash blocks

maxplytrash = 25 						--This is the max amount of trash a player can hold

vendorname = "Trash Vendor"				--The Name of the vendor npc
vendortext = "Sell your trash here!"	--The text line under the npc

compactingtime = 30						--Time to compact one block of trash
maxcompactortrash = 25					--Time to compact one block of trash

compactorsound = true					--The machine sounds played while compacting trash

trashmodels = {							-- This is a list of models for the trash
	"models/props_junk/garbage_milkcarton001a.mdl",
	"models/props_junk/garbage_bag001a.mdl",
	"models/props_junk/garbage_metalcan001a.mdl",
	"models/props_junk/Shoe001a.mdl",
	"models/props_vehicles/carparts_muffler01a.mdl",
	"models/props_vehicles/carparts_axel01a.mdl",
	"models/props_vehicles/carparts_door01a.mdl",
	"models/props_interiors/Furniture_chair03a.mdl",
	"models/props_junk/garbage_milkcarton002a.mdl",
	"models/props_junk/garbage_metalcan002a.mdl",
	"models/props_junk/garbage_carboard002a.mdl",
	"models/props_junk/TrafficCone001a.mdl",
	"models/props_lab/harddrive01.mdl",
	"models/props_junk/plasticbucket001a.mdl",
	"models/props_junk/MetalBucket01a.mdl",
	"models/props_junk/metal_paintcan001b.mdl",
	"models/props_interiors/pot02a.mdl",
	"models/props_combine/breenglobe.mdl",
	"models/props_junk/PropaneCanister001a.mdl",
	"models/props_lab/lockerdoorleft.mdl",
	"models/props_junk/meathook001a.mdl",
	"models/props_c17/lampShade001a.mdl",
	"models/props_c17/playground_swingset_seat01a.mdl",
	"models/props_c17/doll01.mdl",
	"models/props_c17/chair_office01a.mdl",
	"models/props_canal/mattpipe.mdl",
	"models/props_combine/breenclock.mdl",
	"models/props_lab/hevplate.mdl",
	"models/props_lab/reciever01c.mdl",
	"models/props_trainstation/payphone_reciever001a.mdl",
	"models/props_junk/garbage_newspaper001a.mdl",
	"models/props_junk/garbage_plasticbottle001a.mdl",
	"models/props_junk/garbage_plasticbottle003a.mdl",
	"models/props_junk/garbage_plasticbottle002a.mdl",
	"models/props_junk/sawblade001a.mdl",
	"models/props_interiors/pot01a.mdl",
	"models/props_junk/CinderBlock01a.mdl",
	"models/props_c17/tools_wrench01a.mdl"
}

trashsounds = { 							-- This is a list of sounds for the trash bin
	{
		"physics/plastic/plastic_barrel_break1.wav",
		"physics/plastic/plastic_barrel_break2.wav",
		"Computer.ImpactSoft",
		"physics/metal/metal_grenade_impact_soft1.wav",
		"physics/wood/wood_box_impact_bullet1.wav",
	}
}