Dubz_DumpsterAddon = {}
-- Dumpster
Dubz_DumpsterAddon.DumpsterJobs = {
	--["Hobo"] = true,
} -- The NAME of the job, As in the name that you see in the F4 menu or on your HUD. If table left blank all jobs can use the dumpster.

Dubz_DumpsterAddon.DumpsterCooldown = 100

-- Props
Dubz_DumpsterAddon.DumpsterProps = {
--Prop Model (right click prop in Q menu then click copy to clipboard) 
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

Dubz_DumpsterAddon.DumpsterPropsAmount = 5 -- How many props spawn when opening a dumpster? Reccomended: 4-5
Dubz_DumpsterAddon.DumpsterTimeout = 100 -- How long does it take to 'refill' the dumpster?


-- Money Drops
Dubz_DumpsterAddon.MinimumMoneyDrop = 1 -- The minimum amount of money that will drop.
Dubz_DumpsterAddon.MaximumMoneyDrop = 250 -- The maximum amount of money that will drop.
Dubz_DumpsterAddon.ChanceOfMoneyDrop = 20 -- Percentage, Anything over 100 won't work very well.

--  Entity Drops

Dubz_DumpsterAddon.DumpsterEnts = {
--Entity_Class,ChanceToGet1-100
{"durgz_cocaine",25},
{"durgz_cigarette",25},
{"durgz_heroine",25},
{"durgz_weed",25},
{"durgz_meth",25},
{"am_beer",20},
{"soda_can",30},
{"uweed_bud",25},
{"uweed_skin",25},
{"uweed_brownies",20},
{"csgo_bayonet_rustcoat",10},
{"m9k_sig_p229r",30}
}
-- Table Explination ^^: You have so many chances to get an item. For each chance a random entity is selected from the table, 
-- You then have the corrosponding percentage chance for said item to drop

Dubz_DumpsterAddon.DumpsterEntChances = 2 -- How many chances you you get to get an entity. Reccomended 1-2

hook.Add("PlayerInitialSpawn", "InitializeShmeckles", function(ply)
    -- Initialize Shmeckles to 0 when the player first spawns
    ply:SetNWInt("Shmeckles", 0)  -- Set the networked value to 0 initially
end)