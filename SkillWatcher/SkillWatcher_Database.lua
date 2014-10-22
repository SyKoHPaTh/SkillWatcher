--[[	SkillWatcher Database File
	Please don't change anything here, as it will likely be overwritten with newer versions!

Path to file:  WoW/Interface/Addons/SkillWatcher
Author:  SyKoHPaTh - sykohpath@gmail.com

Common format
	Node Name
		- min (orange), minimum skill required for node
		- low (yellow), skill is low and able to get a point every time
		- high (green), skill is high enough that it's not a point every time
		- max (grey), maximum skill to still get a point up
		- text, common "drops" from the node.  Uncommon/rares aren't listed since the tooltip text could get very large

	Note that a decent percent of this database is empty since this stuff isn't known / not researched fully / hard to info
		- if you contribute data, you get your name commented on the respective line!  yay!  you're helping!

--]]


local skillWatcher_data = {
	--====Mining====--
		-- Vanilla
	["Copper Vein"]						= { min = 1,	low = 25,	high = 50,	max = 100,	text = "Copper Ore, Rough Stone"},
	["Incendicite Mineral Vein"] 		= { min = 65,	low = 50,	high = 115,	max = 165,	text = "Incendicite Ore"},
	["Tin Vein"] 						= { min = 65,	low = 90,	high = 115,	max = 165,	text = "Tin Ore, Course Stone"},
	["Silver Vein"] 					= { min = 75,	low = 100,	high = 125,	max = 175,	text = "Silver Ore"},
	["Ooze Covered Silver Vein"] 		= { min = 75,	low = 100,	high = 125,	max = 175,	text = "Silver Ore"},
	["Lesser Bloodstone Deposit"] 		= { min = 75,	low = 100,	high = 125,	max = 175,	text = "Lesser Bloodstone Ore"},
	["Iron Deposit"] 					= { min = 125,	low = 150,	high = 175,	max = 225,	text = "Iron Ore, Heavy Stone"},
	["Indurium Mineral Vein"] 			= { min = 150,	low = 175,	high = 200,	max = 250,	text = "Indurium Ore"},
	["Gold Vein"] 						= { min = 155,	low = 175,	high = 205,	max = 255,	text = "Gold Ore"},
	["Ooze Covered Gold Vein"] 			= { min = 155,	low = 175,	high = 205,	max = 255,	text = "Gold Ore"},
	["Mithril Deposit"] 				= { min = 175,	low = 200,	high = 225,	max = 275,	text = "Mithril Ore, Solid Stone"},
	["Ooze Covered Mithril Deposit"] 	= { min = 175,	low = 200,	high = 225,	max = 275,	text = "Mithril Ore, Solid Stone"},
	["Truesilver Deposit"] 				= { min = 230,	low = 255,	high = 280,	max = 330,	text = "Truesilver Ore"},
	["Ooze Covered Truesilver Deposit"]	= { min = 230,	low = 255,	high = 280,	max = 330,	text = "Truesilver Ore"},
	["Dark Iron Deposit"] 				= { min = 230,	low = 255,	high = 280,	max = 330,	text = "Dark Iron Ore"},
	["Small Thorium Vein"] 				= { min = 245,	low = 270,	high = 295,	max = 345,	text = "Thorium Ore, Dense Stone"},
	["Ooze Covered Thorium Vein"] 		= { min = 245,	low = 270,	high = 295,	max = 345,	text = "Thorium Ore, Dense Stone"},
	["Rich Thorium Vein"] 				= { min = 275,	low = 300,	high = 325,	max = 365,	text = "Thorium Ore, Dense Stone"},
	["Ooze Covered Rich Thorium Vein"] 	= { min = 275,	low = 300,	high = 325,	max = 365,	text = "Thorium Ore, Dense Stone"},
	["Hakkari Thorium Vein"] 			= { min = 275,	low = 300,	high = 325,	max = 365,	text = "Thorium Ore, Dense Stone"},
	["Small Obsidian Chunk"] 			= { min = 305,	low = 330,	high = 355,	max = 400,	text = "Small/Large Obsidian Shard"},
	["Large Obsidian Chunk"] 			= { min = 305,	low = 330,	high = 355,	max = 400,	text = "Small/Large Obsidian Shard"},
		--Outlands
	["Fel Iron Deposit"] 				= { min = 300,	low = 325,	high = 350,	max = 400,	text = "Fel Iron Ore, Mote of Earth/Fire, Eternium Ore"},
	["Adamantite Deposit"] 				= { min = 325,	low = 350,	high = 375,	max = 401,	text = "Adamantite Ore, Mote of Earth, Eternium Ore"},
	["Rich Adamantite Deposit"] 		= { min = 350,	low = 375,	high = 400,	max = 401,	text = "Adamantite Ore, Mote of Earth, Eternium Ore"},
	["Nethercite Ore"] 					= { min = 300,	low = 401,	high = 401,	max = 401,	text = "Nethercite Ore, More of Earth/Fire, Eternium Ore"},
	["Khorium Vein"] 					= { min = 375,	low = 400,	high = 401,	max = 401,	text = "Khorium Ore, Mote of Earth/Fire, Eternium Ore"},
	["Ancient Gem Vein"] 				= { min = 375,	low = 401,	high = 401,	max = 401,	text = ""},
		--Northrend
	["Cobalt Deposit"] 					= { min = 350,	low = 375,	high = 400,	max = 450,	text = "Cobalt Ore, Crystallized Earth/Water"},
	["Rich Cobalt Deposit"] 			= { min = 375,	low = 451,	high = 451,	max = 451,	text = "Cobalt Ore, Crystallized Earth/Water"},
	["Saronite Deposit"] 				= { min = 400,	low = 425,	high = 451,	max = 451,	text = "Saronite Ore, Crystallized Earth/Shadow"},
	["Rich Saronite Deposit"] 			= { min = 425,	low = 450,	high = 451,	max = 451,	text = "Saronite Ore, Crystallized Earth/Shadow"},
	["Titanium Deposit"] 				= { min = 450,	low = 451,	high = 451,	max = 451,	text = "Saronite Ore, Crystallized Earth/Fire/Water/Air"},
		--Cataclysm
	["Obsidium Deposit"] 				= { min = 425,	low = 450,	high = 475,	max = 500,	text = "Obsidium Ore"},
	["Rich Obsidium Deposit"] 			= { min = 450,	low = 475,	high = 500,	max = 525,	text = "Obsidium Ore"},
	["Elementium Vein"] 				= { min = 475,	low = 500,	high = 525,	max = 525,	text = "Elementium Ore"},
	["Rich Elementium Vein"] 			= { min = 500,	low = 525,	high = 475,	max = 525,	text = "Elementium Ore"},
	["Pyrite Deposit"] 					= { min = 525,	low = 525,	high = 525,	max = 525,	text = "Pyrite Ore"},
	["Rich Pyrite Deposit"] 			= { min = 525,	low = 525,	high = 525,	max = 525,	text = "Pyrite Ore"},
		--Pandaria
	["Ghost Iron Deposit"] 				= { min = 500,	low = 525,	high = 550,	max = 575,	text = "Ghost Iron Ore"},
	["Rich Ghost Iron Deposit"] 		= { min = 550,	low = 575,	high = 600,	max = 600,	text = "Ghost Iron Ore"},
	["Kyparite Deposit"] 				= { min = 550,	low = 575,	high = 600,	max = 600,	text = "Kyparite Ore"},
	["Rich Kyparite Deposit"] 			= { min = 600,	low = 600,	high = 600,	max = 600,	text = "Kyparite Ore"},
	["Trillium Vein"] 					= { min = 600,	low = 600,	high = 600,	max = 600,	text = "White or Black Trillium Ore"},
	["Rich Trillium Vein"] 				= { min = 600,	low = 600,	high = 600,	max = 600,	text = "White or Black Trillium Ore"},
		--Warlords


	--====Herbalism====--
			--Vanilla
	["Peacebloom"] 						= { min = 1,	low = 25,	high = 50,	max = 100,	text = "Peacebloom"},
	["Silverleaf"] 						= { min = 1,	low = 25,	high = 50,	max = 100,	text = "Silverleaf"},
	["Bloodthistle"] 					= { min = 1,	low = 25,	high = 50,	max = 100,	text = "Bloodthistle"},
	["Earthroot"]						= { min = 15,	low = 40,	high = 65,	max = 115,	text = "Earthroot"},
	["Mageroyal"] 						= { min = 50,	low = 75,	high = 100,	max = 150,	text = "Mageroyal, Swiftthistle"},
	["Briarthorn"] 						= { min = 70,	low = 95,	high = 120,	max = 170,	text = "Briarthorn, Swiftthistle"},
	["Stranglekelp"] 					= { min = 85,	low = 110,	high = 135,	max = 185,	text = "Stranglekelp"},
	["Bruiseweed"] 						= { min = 100,	low = 125,	high = 150,	max = 200,	text = "Bruiseweed"},
	["Wild Steelbloom"] 				= { min = 115,	low = 140,	high = 165,	max = 215,	text = "Wild Steelbloom"},
	["Grave Moss"] 						= { min = 120,	low = 150,	high = 170,	max = 220,	text = "Grave Moss"},
	["Kingsblood"] 						= { min = 125,	low = 155,	high = 175,	max = 225,	text = "Kingsblood"},
	["Liferoot"] 						= { min = 150,	low = 175,	high = 200,	max = 250,	text = "Liferoot"},
	["Fadeleaf"] 						= { min = 160,	low = 185,	high = 210,	max = 260,	text = "Fadeleaf"},
	["Goldthorn"] 						= { min = 170,	low = 195,	high = 220,	max = 270,	text = "Goldthorn"},
	["Khadgar's Whisker"] 				= { min = 185,	low = 210,	high = 235,	max = 285,	text = "Khadgar's Whisker"},
	["Wintersbite"] 					= { min = 195,	low = 225,	high = 245,	max = 295,	text = "Wintersbite"},
	["Firebloom"] 						= { min = 205,	low = 235,	high = 255,	max = 305,	text = "Firebloom"},
	["Purple Lotus"] 					= { min = 210,	low = 235,	high = 260,	max = 310,	text = "Purple Lotus, Wildvine"},
	["Arthas' Tears"] 					= { min = 220,	low = 250,	high = 270,	max = 320,	text = "Arthas' Tears"},
	["Sungrass"] 						= { min = 230,	low = 255,	high = 280,	max = 330,	text = "Sungrass"},
	["Blindweed"] 						= { min = 235,	low = 260,	high = 285,	max = 335,	text = "Blindweed"},
	["Ghost Mushroom"] 					= { min = 245,	low = 270,	high = 295,	max = 345,	text = "Ghost Mushroom"},
	["Gromsblood"] 						= { min = 250,	low = 275,	high = 300,	max = 350,	text = "Gromsblood"},
	["Golden Sansam"] 					= { min = 260,	low = 280,	high = 310,	max = 360,	text = "Golden Sansam"},
	["Dreamfoil"] 						= { min = 270,	low = 295,	high = 320,	max = 370,	text = "Dreamfoil"},
	["Mountain Silversage"] 			= { min = 280,	low = 310,	high = 330,	max = 380,	text = "Mountain Silversage"},
	["Plaguebloom"] 					= { min = 285,	low = 315,	high = 335,	max = 385,	text = "Plaguebloom"},
	["Icecap"] 							= { min = 290,	low = 315,	high = 340,	max = 390,	text = "Icecap"},
	["Black Lotus"] 					= { min = 300,	low = 345,	high = 399,	max = 400,	text = "Black Lotus"},
			--Outlands
	["Felweed"] 						= { min = 300,	low = 325,	high = 350,	max = 400,	text = "Felweed, Mote of Life, Fel Blossom, Fel Lotus"},
	["Dreaming Glory"] 					= { min = 315,	low = 340,	high = 365,	max = 415,	text = "Dreaming Glory, Mote of Life, Fel Lotus"},
	["Ragveil"] 						= { min = 325,	low = 350,	high = 400,	max = 425,	text = "Ragveil, Mote of Life, Fel Lotus"},
	["Flame Cap"] 						= { min = 335,	low = 350,	high = 410,	max = 435,	text = "Flame Cap, Fel Lotus"},
	["Terocone"] 						= { min = 325,	low = 350,	high = 415,	max = 425,	text = "Terocone, Mote of Life, Fel Lotus"},
	["Ancient Lichen"] 					= { min = 340,	low = 438,	high = 439,	max = 440,	text = "Ancient Lichen, Fel Lotus"},
	["Netherbloom"] 					= { min = 350,	low = 375,	high = 400,	max = 450,	text = "Netherbloom, Mote of Mana, Fel Lotus"},
	["Netherdust Bush"] 				= { min = 350,	low = 390,	high = 400,	max = 450,	text = "Netherdust Pollen, Mote of Mana, Fel Lotus"},
	["Nightmare Vine"] 					= { min = 365,	low = 390,	high = 415,	max = 465,	text = "Nightmare Vine, Nightmare Seed, Fel Lotus"},
	["Mana Thistle"] 					= { min = 375,	low = 415,	high = 425,	max = 475,	text = "Mana Thistle, Mote of Life, Fel Lotus"},
			--Northrend
	["Goldclover"] 						= { min = 350,	low = 380,	high = 420,	max = 450,	text = "Goldclover, Deadnettle, Crystallized Life, Frost Lotus"},
	["Firethorn"] 						= { min = 360,	low = 385,	high = 450,	max = 460,	text = "Fire Leaf, Fire Seed, Crystallized Life, Frost Lotus"},
	["Tiger Lily"] 						= { min = 375,	low = 400,	high = 450,	max = 475,	text = "Tiger Lily, Deadnettle, Crystallized Life, Frost Lotus"},
	["Talandra's Rose"] 				= { min = 385,	low = 405,	high = 450,	max = 485,	text = "Talandra's Rose, Deadnettle, Crystallized Life, Frost Lotus"},
	["Frozen Herb"] 					= { min = 415,	low = 425,	high = 450,	max = 515,	text = "Goldclover, Talandra's Rose, Tiger Lily"},
	["Adder's Tongue"] 					= { min = 400,	low = 415,	high = 450,	max = 500,	text = "Adder's Tongue, Crystallized Life, Frost Lotus"},
	["Lichbloom"] 						= { min = 425,	low = 435,	high = 450,	max = 525,	text = "Lichbloom, Crystallized Life, Frost Lotus"},
	["Icethorn"] 						= { min = 435,	low = 445,	high = 450,	max = 535,	text = "Icethorn, Crystallized Life, Frost Lotus"},
	["Frost Lotus"] 					= { min = 450,	low = 451,	high = 451,	max = 550,	text = "Deadnettle, Crystallized Life, Frost Lotus"},
			--Cataclysm
	["Cinderbloom"] 					= { min = 425,	low = 450,	high = 475,	max = 500,	text = ""},
	["Stormvine"] 						= { min = 425,	low = 450,	high = 475,	max = 500,	text = ""},
	["Azshara's Veil"] 					= { min = 425,	low = 450,	high = 475,	max = 500,	text = ""},
	["Heartblossom"] 					= { min = 475,	low = 500,	high = 525,	max = 525,	text = ""},
	["Whiptail"] 						= { min = 500,	low = 525,	high = 525,	max = 525,	text = ""},
	["Twilight Jasmine"] 				= { min = 525,	low = 525,	high = 525,	max = 525,	text = ""},
			--Pandaria
	["Fool's Cap"] 						= { min = 600,	low = 600,	high = 600,	max = 600,	text = ""},
	["Golden Lotus"] 					= { min = 550,	low = 575,	high = 600,	max = 600,	text = ""},
	["Green Tea Leaf"] 					= { min = 500,	low = 525,	high = 550,	max = 575,	text = ""},
	["Rain Poppy"] 						= { min = 525,	low = 550,	high = 575,	max = 600,	text = ""},
	["Sha-Touched Herb"] 				= { min = 575,	low = 600,	high = 600,	max = 600,	text = ""},
	["Silkweed"] 						= { min = 545,	low = 550,	high = 575,	max = 600,	text = ""},
	["Snow Lily"] 						= { min = 575,	low = 600,	high = 600,	max = 600,	text = ""},

	--====Rogue Lockpick====
			--Old World
				--crafted
	["Practice Lock"] 					= { min = 1,	low = 30,	high = 60,	max = 80,	text = "Nothing :("},
				--junkboxes
	["Battered Junkbox"] 				= { min = 1,	low = 30,	high = 75,	max = 20,	text = "(stuff)"},
	["Worn Junkbox"] 					= { min = 75,	low = 100,	high = 120,	max = 20,	text = "(stuff)"},
	["Sturdy Junkbox"] 					= { min = 175,	low = 200,	high = 225,	max = 35,	text = "(stuff)"},
	["Heavy Junkbox"] 					= { min = 250,	low = 275,	high = 300,	max = 50,	text = "(stuff)"},
				-- lockboxes (mob drops) - max is required player level!
	["Ornate Bronze Lockbox"] 			= { min = 1,	low = 1,	high = 50,	max = 20,	text = "(stuff)"},
	["Heavy Bronze Lockbox"] 			= { min = 25,	low = 50,	high = 75,	max = 20,	text = "(stuff)"},
	["Iron Lockbox"] 					= { min = 70,	low = 95,	high = 120,	max = 20,	text = "(stuff)"},
	["Strong Iron Lockbox"] 			= { min = 125,	low = 150,	high = 175,	max = 25,	text = "(stuff)"},
	["Steel Lockbox"] 					= { min = 175,	low = 205,	high = 225,	max = 35,	text = "(stuff)"},
	["Reinforced Steel Lockbox"] 		= { min = 225,	low = 250,	high = 275,	max = 45,	text = "(stuff)"},
	["Mithril Lockbox"] 				= { min = 225,	low = 250,	high = 275,	max = 50,	text = "(stuff)"},
	["Thorium Lockbox"] 				= { min = 225,	low = 250,	high = 275,	max = 50,	text = "(stuff)"},
				--locked chests (fishing)
	["Lockbox"] 						= { min = 1,	low = 300,	high = 300,	max = 300,	text = "(stuff)"},
	["Lockbox"] 						= { min = 70,	low = 300,	high = 300,	max = 300,	text = "(stuff)"},
	["Lockbox"] 						= { min = 175,	low = 300,	high = 300,	max = 300,	text = "(stuff)"},
	["Lockbox"] 						= { min = 250,	low = 300,	high = 300,	max = 300,	text = "(stuff)"},
				--footlockers
					--there's several repeated footlockers throughout the world...so data isn't 100% accurate
						--waterlogged, battered, mossy, dented
	["Burial Chest"] 					= { min = 1,	low = 30,	high = 55,	max = 100,	text = "(stuff)"},
	["Primitive Chest"] 				= { min = 20,	low = 30,	high = 55,	max = 100,	text = "(stuff)"},
	["Practice Lockbox"] 				= { min = 1,	low = 30,	high = 55,	max = 100,	text = "(stuff)"},
	["Buccaneer's Strongbox"] 			= { min = 1,	low = 30,	high = 55,	max = 100,	text = "(stuff)"},
	["The Jewel of the Southsea"] 		= { min = 25,	low = 30,	high = 75,	max = 125,	text = "(stuff)"},
	["Waterlogged Footlocker"] 			= { min = 70,	low = 95,	high = 120,	max = 150,	text = "(stuff)"},
	["Gallywix's Lockbox"] 				= { min = 70,	low = 100,	high = 120,	max = 170,	text = "(stuff)"},
	["Duskwood Chest"] 					= { min = 70,	low = 100,	high = 120,	max = 170,	text = "(stuff)"},
	["Battered Footlocker"] 			= { min = 110,	low = 135,	high = 160,	max = 175,	text = "(stuff)"},
	["Mossy Footlocker"] 				= { min = 175,	low = 200,	high = 225,	max = 250,	text = "(stuff)"},
	["Dented Footlocker"] 				= { min = 175,	low = 200,	high = 225,	max = 250,	text = "(stuff)"},
	["Scarlet Footlocker"] 				= { min = 250,	low = 275,	high = 300,	max = 350,	text = "(stuff)"},
	["Wicker Chest"] 					= { min = 300,	low = 325,	high = 350,	max = 400,	text = "(stuff)"},
				--treasure chests
	["Large Iron Bound Chest"] 			= { min = 25,	low = 50,	high = 75,	max = 105,	text = "(stuff)"},
	["Large Mithril Bound Chest"] 		= { min = 175,	low = 200,	high = 225,	max = 225,	text = "(stuff)"},
				--doors
	["Gate"] 							= { min = 1,	low = 30,	high = 55,	max = 100,	text = ""},
	["Workshop Door"] 					= { min = 150,	low = 175,	high = 200,	max = 250,	text = ""},
	["Armory Door"] 					= { min = 175,	low = 200,	high = 225,	max = 275,	text = ""},
	["Cathedral Door"] 					= { min = 175,	low = 200,	high = 225,	max = 275,	text = ""},
	["Searing Gorge Gate"] 				= { min = 225,	low = 250,	high = 275,	max = 350,	text = ""},
	["East Garrison Door"] 				= { min = 250,	low = 275,	high = 300,	max = 350,	text = ""},
	["Prison Cell"] 					= { min = 225,	low = 250,	high = 300,	max = 350,	text = ""},
	["Shadowforge Gate"] 				= { min = 250,	low = 275,	high = 300,	max = 350,	text = ""},
	["Shadowforge Mechanism"] 			= { min = 250,	low = 275,	high = 300,	max = 350,	text = ""},
	["Scholomance Door"] 				= { min = 280,	low = 325,	high = 340,	max = 350,	text = ""},
	["Stratholme Gate"] 				= { min = 300,	low = 325,	high = 340,	max = 350,	text = ""},
	["Crescent Door"] 					= { min = 300,	low = 325,	high = 400,	max = 400,	text = ""},
			--Outlands
				--junkboxes
	["Strong Junkbox"] 					= { min = 300,	low = 325,	high = 350,	max = 60,	text = "(stuff)"},
				--lockboxes (mob drops)
	["Eternium Lockbox"] 				= { min = 225,	low = 265,	high = 320,	max = 50,	text = "(stuff)"},
	["Khorium Lockbox"] 				= { min = 325,	low = 350,	high = 450,	max = 65,	text = "(stuff)"},
				--treasure chests
	["Bound Fel Iron Chest"] 			= { min = 300,	low = 325,	high = 350,	max = 400,	text = "(stuff)"},
	["Bound Adamantite Chest"] 			= { min = 325,	low = 350,	high = 375,	max = 450,	text = "(stuff)"},
				--doors
	["Shattered Halls Door"] 			= { min = 350,	low = 375,	high = 400,	max = 425,	text = ""},
	["Shadow Labyrinth Gate"] 			= { min = 350,	low = 375,	high = 400,	max = 450,	text = ""},
	["Arcatraz Door"] 					= { min = 350,	low = 375,	high = 400,	max = 450,	text = ""},
			--Northrend
				--junkboxes
	["Reinforced Junkbox"] 				= { min = 350,	low = 375,	high = 450,	max = 70,	text = "(stuff)"},
				--lockboxes (mob drops)
	["Froststeel Lockbox"] 				= { min = 375,	low = 450,	high = 450,	max = 75,	text = "(stuff)"},
	["Titanium Lockbox"] 				= { min = 400,	low = 450,	high = 450,	max = 80,	text = "(stuff)"},
	["Tiny Titanium Lockbox"] 			= { min = 400,	low = 450,	high = 450,	max = 80,	text = "(stuff)"},
				--doors
	["Kharazhan Door"] 					= { min = 350,	low = 375,	high = 400,	max = 450,	text = ""},
	["Violet Hold Door"] 				= { min = 365,	low = 400,	high = 450,	max = 450,	text = ""},
			--Cataclysm
				--junkboxes
	["FLame-Scarred Junkbox"] 			= { min = 350,	low = 375,	high = 450,	max = 80,	text = "(stuff)"},
				--lockboxes (mob drops)
	["Elementium Lockbox"] 				= { min = 425,	low = 450,	high = 450,	max = 85,	text = "(stuff)"},
			--Pandaria
				--junkboxes
	["Vine-Cracked Junkbox"] 			= { min = 350,	low = 375,	high = 450,	max = 90,	text = "(stuff)"},
				--lockboxes (mob drops)
	["Ghost Iron Lockbox"] 				= { min = 450,	low = 450,	high = 450,	max = 90,	text = "(stuff)"},

}
