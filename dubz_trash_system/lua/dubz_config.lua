--[[-------------------------------------------------------------------------
  Dubz Trash System Configuration
  Customize values below to suit your server.
---------------------------------------------------------------------------]]

if SERVER then
	AddCSLuaFile()
end

DubzTrashConfig = DubzTrashConfig or {}

DubzTrashConfig = {
	General = {
		ChatPrefix = "[DTS]",
	},

	Economy = {
		PricePerKg = 10,
		BlockBonus = 0,
		MinimumPayout = 0,
		RoundTo = 1,
	},

	Weights = {
		TrashItem = {
			Min = 1,
			Max = 3,
		},
		Block = {
			Min = 10,
			Max = 50,
			ClampToRange = true,
		},
		UseItemWeightsForBlocks = true,
	},

	Limits = {
		MaxPlayerTrash = 25,
		MaxPlayerWeight = 75,
		MaxCompactorTrash = 25,
	},

	Compactor = {
		CompactingTime = 30,
		RequireFullLoad = true,
		PlaySounds = true,
		StartSound = "buttons/button9.wav",
		LoopSound = "ambient/machines/engine_idle1.wav",
		CompletionSound = "buttons/button4.wav",
		Shake = {
			Enabled = true,
			Interval = 0.2,
			Offset = 1.5,
		},
	},

	Models = {
		Trash = {
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
			"models/props_c17/tools_wrench01a.mdl",
		},
		TrashBlock = {
			Model = "models/hunter/blocks/cube05x05x05.mdl",
			Material = "models/props/CS_militia/rocks01",
		},
		TrashBin = "models/props_trainstation/trashcan_indoor001b.mdl",
		Compactor = "models/props_wasteland/laundry_washer003.mdl",
		Vendor = "models/Humans/Group03/male_03.mdl",
	},

	Vendor = {
		Name = "Trash Vendor",
		Tagline = "Sell your trash here!",
		SellHint = "Press 'e' to sell your product!",
		VoiceLines = {
			"vo/npc/male01/yeah02.wav",
			"vo/npc/male01/fantastic01.wav",
			"vo/npc/male01/answer17.wav",
		},
		VoiceCooldown = 6,
		LookRange = 500,
	},

	Sounds = {
		TrashBin = {
			"physics/plastic/plastic_barrel_break1.wav",
			"physics/plastic/plastic_barrel_break2.wav",
			"Computer.ImpactSoft",
			"physics/metal/metal_grenade_impact_soft1.wav",
			"physics/wood/wood_box_impact_bullet1.wav",
		},
		TrashPickup = {
			"physics/cardboard/cardboard_box_impact_hard1.wav",
			"physics/cardboard/cardboard_box_impact_hard6.wav",
			"physics/cardboard/cardboard_box_impact_hard5.wav",
		},
	},

	Physics = {
		TrashMassBase = 1,
		TrashMassPerKg = 0.5,
		BlockMassBase = 5,
		BlockMassPerKg = 1.5,
	},

	Teams = {
		Collectors = {
			TEAM_TRASH,
		},
	},

	Spawns = {
		Enabled = true,
		MaxTrashPerPlayer = 8,
		MaxTrashGlobal = 64,
		Interval = 6,
		Attempts = 12,
		MinDistance = 200,
		MaxDistance = 600,
		CleanupDistance = 900,
		BlindSpotDot = -0.1,
	},
}

return DubzTrashConfig
