-- ==========================
-- Name: SkillWatcher.lua
-- Last Updated: 20101209
-- Page Version: SkillWatcher.lua  
-- ==========================

--match these variables with versioning in the TOC file
SkillWatcherGameVersion = "CATA 4.0.3a";
SkillWatcherVersion = "v2.1a";

-- [[========================
-- Path to file:  WoW/Interface/Addons/SkillWatcher
-- Author:  SyKoHPaTh - sykohpath@gmail.com
-- ==========================
-- Version History
--
--		2.1	-	option to turn off/on the tooltip window thing, bugfix ("Not found!" tooltip thing), bugfix (savedvariables not reading / event)
--		2.0	-	Update to WRATH 4.0, Window size fix, added Prospecting mats tooltip stuff
--		1.9b	-	Add to tracking: blacksmith and engineering skill for "locked", customizable skills shown through config window
--		1.9a	-	Update to WRATH 3.3.2, added Rogue skill tracking for lockpicking: chests, doors, loot, etc.
--		1.9	-	added training notifiers
--		1.8 -	config window
--		1.7	-	Updated version to WRATH 3.2.0; fixed "long line" bug with long skill names
--		1.6	-	change level ping color fade
--		1.5	-	code cleanup, launch, bug fixes
--		1.4	-	save frame position, tooltip more data
--		1.3	-	color "ping", tooltip modification
--		1.2	-	code cleanup
--		1.1	-	cleaned up frame, cleaned up code
--		1.0	-	Initial structure
--
-- ==========================
-- = TO DO:
--
--		Replace color fading procedure with math function
--		table data for herbalism, mining
--
--		Config options
--			Skin Selection
--			Font Selection/styling
--		Save Variables
--			background texture
--			font selection/styling/size
--			text coloring
--			Tracking of certain skills
-- ==========================
--]]

--Shared Variables:
--	1.4	-	SkillWatcherPoint, SkillWatcherX, SkillWatcherY
--	1.8	-	SkillWatcherConfig_TooltipMiningON, SkillWatcherConfig_TooltipHerbON, SkillWatcherConfig_WindowON
--	1.9b-	SkillArray
--	2.1	-	SkillWatcherConfig_TooltipON
--
--
--
--
--

-- config options:
--	turn mod on and off SkillWatcherFrame:Hide(); and Show();
--	use skill window





-- ======== PRECODE ======== 
	--(code run instantly when file loaded)
	--main purpose is to register processes and variables "before addon load"
	
	--Globals
		local SkillWatcherConfig_defaultTest = 1;
		local SkillWatcherConfig_defaultPoint = "CENTER";
		local SkillWatcherConfig_defaultX = 0;
		local SkillWatcherConfig_defaultY = 0;
		local SkillWatcherConfig_defaultWindowON = 1;
		local SkillWatcherConfig_defaultWindowDetailON = 2;
		local SkillWatcherConfig_defaultTooltipMiningON = 1;
		local SkillWatcherConfig_defaultTooltipHerbON = 1;		
		local SkillWatcherConfig_defaultTooltipON = 1;		

	-- ==== Slash Command ====
		SLASH_SKILLWATCHER1 = "/skillwatcher";
		SLASH_SKILLWATCHER2 = "/swr";
		function SlashCmdList.SKILLWATCHER(msg, editbox)
			-- msg is the passed argument from command line
			if msg == "help" or msg == "" then
				--display all help options
				DEFAULT_CHAT_FRAME:AddMessage("SkillWatcher" .. SkillWatcherVersion .. SkillWatcherGameVersion .. "\n  help     brings up this help!\n  config   shows configuration menu\n  default  set SkillWatcher window to default\n  version  shows versioning info\n  detail   Show the skill details for AUTO/SHOW/HIDE");
			end

			if msg == "frame" then
				--debug command - just shows position of the info frame
				point, relativeTo, relativePoint, xOfs, yOfs = SkillWatcherFrame:GetPoint()
				DEFAULT_CHAT_FRAME:AddMessage("Dumping frame getpoint")
				DEFAULT_CHAT_FRAME:AddMessage(point .. " SWP:"..SkillWatcherPoint)
				DEFAULT_CHAT_FRAME:AddMessage(xOfs .. " SWX:"..SkillWatcherX)
				DEFAULT_CHAT_FRAME:AddMessage(yOfs .. " SWY:"..SkillWatcherY)
			end

			if msg == "config" then
				--open config panel
				InterfaceOptionsFrame_OpenToCategory(SkillWatcher.panel)
			end

			if msg == "default" then
				--resets the info window
				SkillWatcherFrame:ClearAllPoints()
				SkillWatcherFrame:SetPoint("CENTER", 0, 0)
				SkillWatcherPoint = "CENTER"
				SkillWatcherX = 0
				SkillWatcherY = 0
				SkillArray = {}
			end
			
			if msg == "version" then
				DEFAULT_CHAT_FRAME:AddMessage("Game Version: " .. select(1, GetBuildInfo()))
				DEFAULT_CHAT_FRAME:AddMessage("Build: " .. select(2, GetBuildInfo()))
				DEFAULT_CHAT_FRAME:AddMessage("Date: " .. select(3, GetBuildInfo()))
				DEFAULT_CHAT_FRAME:AddMessage("TOC Version Number: " .. select(4, GetBuildInfo()))
				
			end

			if msg == "debug" then
				if (SkillWatcherConfig_WindowON) then
					DEFAULT_CHAT_FRAME:AddMessage("SkillWatcherConfig_WindowON: YES")
				else
					DEFAULT_CHAT_FRAME:AddMessage("SkillWatcherConfig_WindowON: NO")
				end
				if (SkillWatcherConfig_TooltipMiningON) then
					DEFAULT_CHAT_FRAME:AddMessage("SkillWatcherConfig_TooltipMiningON: YES")
				else
					DEFAULT_CHAT_FRAME:AddMessage("SkillWatcherConfig_TooltipMiningON: NO")
				end
				if (SkillWatcherConfig_TooltipHerbON) then
					DEFAULT_CHAT_FRAME:AddMessage("SkillWatcherConfig_TooltipHerbON: YES")
				else
					DEFAULT_CHAT_FRAME:AddMessage("SkillWatcherConfig_TooltipHerbON: NO")
				end				
				if (SkillWatcherConfig_DetailWindowON) then
					DEFAULT_CHAT_FRAME:AddMessage("SkillWatcherConfig_DetailWindowON: YES")
				else
					DEFAULT_CHAT_FRAME:AddMessage("SkillWatcherConfig_DetailWindowON: NO")
				end
				if (SkillWatcherConfig_TooltipON) then
					DEFAULT_CHAT_FRAME:AddMessage("SkillWatcherConfig_TooltipON: YES")
				else
					DEFAULT_CHAT_FRAME:AddMessage("SkillWatcherConfig_TooltipON: NO")
				end	
			end
			
			if msg == "detail" then
				if SkillWatcherConfig_DetailWindowON == 1 then
					SkillWatcherConfig_DetailWindowON = 2
				else
					SkillWatcherConfig_DetailWindowON = 1
				end
			end
		end

	-- ==== Event Listeners ====
		--when events are detected, call the function in the SetScript
		hidden = CreateFrame("Frame", nil, UIParent)
		hidden:RegisterEvent("CHAT_MSG_SKILL")
		hidden:RegisterEvent("PLAYER_ALIVE")
		hidden:RegisterEvent("PLAYER_LEVEL_UP")
		hidden:RegisterEvent("TRADE_SKILL_UPDATE")
		hidden:RegisterEvent("TRAINER_UPDATE")
		hidden:RegisterEvent("VARIABLES_LOADED")
		hidden:RegisterEvent("ADDON_LOADED")
		hidden:SetScript("OnEvent", function(self, event, ...)
			SkillWatcher_EventHandler(self, event, ...)
		end)
		--hidden:SetScript("OnEvent", SkillWatcher_EventHandler)


-- ======== Functions ========
	
	-- ==== Timer ====
		--this block of code calls functions every set amount of seconds
	local f = CreateFrame("frame")
	f:SetScript("OnUpdate", function(self, elapsed)
		self.elapsed = self.elapsed + elapsed
		if self.elapsed >= .1 then
			self.elapsed = 0
			SkillWatcher_UpdateWindow()
			SkillWatcher_Tooltip()
			SkillWatcherDetails_UpdateWindow()
		end
	end)
	f.elapsed = 0


	-- ==== Tooltip handler ====
	--replaces the game default tooltime
	function SkillWatcher_Tooltip()
		skillText = {}
		local flag = 0 --used to specify if a node is hovered over
		for i=1,GameTooltip:NumLines() do
			local mytext = getglobal("GameTooltipTextLeft" .. i)
			local text = mytext:GetText()
			if (text) then
				skillText[i] = text
				--determine if mousing over a node
					--we're only replacing the tooltip on Herbalism and Mining nodes right now
					
					
				if skillText[i] == "Requires Herbalism" and SkillWatcherConfig_TooltipHerbON == 1 then flag = 1; end
				if skillText[i] == "Requires Mining" and SkillWatcherConfig_TooltipMiningON == 1 then flag = 1; end
				--check for rogue/engineer/blacksmith
				if skillText[i] == "Locked" then flag = 1; end
				--jewelcrafting
				if skillText[i] == "Prospectable" then flag = 1; end
			end
		end


		if flag == 1 then
			--placeholder
			skillText[3] = "NONE"
			
			-- determine skill
			--this is a horrid way to store this data...need to store it in a table!  --note for future version
			
			--local NodeStuff = { ["NODENAME"] = "Copper Vein" , ["Horange"] = 1, ["Hyellow"] = 25, ["Hgreen"] = 50, ["Hgrey"] = 100, ["NODETEXT"] = "Copper Ore, Rough Stone"};
			--for a = 0 to 100 or something.  if skilltext1 = NodeStuff["NODENAME"], then Horange = Nodestuff["Horange"]...etc
			
			--prevent nil
			Horange = 0; Hyellow = 0; Hgreen = 0; Hgrey = 0; skillText[4] = "Need to add to database";
			
			--====Mining====
			--Old World
			if skillText[1] == "Copper Vein" then Horange = 1; Hyellow = 25; Hgreen = 50; Hgrey = 100; skillText[4] = "Copper Ore, Rough Stone"; end
			if skillText[1] == "Incendicite Mineral Vein" then Horange = 65; Hyellow = 50; Hgreen = 115; Hgrey = 165; skillText[4] = "Incendicite Ore"; end
			if skillText[1] == "Tin Vein" then Horange = 65; Hyellow = 90; Hgreen = 115; Hgrey = 165; skillText[4] = "Tin Ore, Course Stone"; end
			if skillText[1] == "Silver Vein" then Horange = 75; Hyellow = 100; Hgreen = 125; Hgrey = 175; skillText[4] = "Silver Ore";end
			if skillText[1] == "Ooze Covered Silver Vein" then Horange = 75; Hyellow = 100; Hgreen = 125; Hgrey = 175; skillText[4] = "Silver Ore";end
			if skillText[1] == "Lesser Bloodstone Deposit" then Horange = 75; Hyellow = 100; Hgreen = 125; Hgrey = 175; skillText[4] = "Lesser Bloodstone Ore";end
			if skillText[1] == "Iron Deposit" then Horange = 125; Hyellow = 150; Hgreen = 175; Hgrey = 225; skillText[4] = "Iron Ore, Heavy Stone";end
			if skillText[1] == "Indurium Mineral Vein" then Horange = 150; Hyellow = 175; Hgreen = 200; Hgrey = 250; skillText[4] = "Indurium Ore";end
			if skillText[1] == "Gold Vein" then Horange = 155; Hyellow = 175; Hgreen = 205; Hgrey = 255; skillText[4] = "Gold Ore";end
			if skillText[1] == "Ooze Covered Gold Vein" then Horange = 155; Hyellow = 175; Hgreen = 205; Hgrey = 255; skillText[4] = "Gold Ore";end
			if skillText[1] == "Mithril Deposit" then Horange = 175; Hyellow = 200; Hgreen = 225; Hgrey = 275; skillText[4] = "Mithril Ore, Solid Stone";end
			if skillText[1] == "Ooze Covered Mithril Deposit" then Horange = 175; Hyellow = 200; Hgreen = 225; Hgrey = 275; skillText[4] = "Mithril Ore, Solid Stone";end
			if skillText[1] == "Truesilver Deposit" then Horange = 230; Hyellow = 255; Hgreen = 280; Hgrey = 330; skillText[4] = "Truesilver Ore";end
			if skillText[1] == "Ooze Covered Truesilver Deposit" then Horange = 230; Hyellow = 255; Hgreen = 280; Hgrey = 330; skillText[4] = "Truesilver Ore";end
			if skillText[1] == "Dark Iron Deposit" then Horange = 230; Hyellow = 255; Hgreen = 280; Hgrey = 330; skillText[4] = "Dark Iron Ore";end
			if skillText[1] == "Small Thorium Vein" then Horange = 245; Hyellow = 270; Hgreen = 295; Hgrey = 345; skillText[4] = "Thorium Ore, Dense Stone";end
			if skillText[1] == "Ooze Covered Thorium Vein" then Horange = 245; Hyellow = 270; Hgreen = 295; Hgrey = 345; skillText[4] = "Thorium Ore, Dense Stone";end
			if skillText[1] == "Rich Thorium Vein" then Horange = 275; Hyellow = 300; Hgreen = 325; Hgrey = 365; skillText[4] = "Thorium Ore, Dense Stone";end
			if skillText[1] == "Ooze Covered Rich Thorium Vein" then Horange = 275; Hyellow = 300; Hgreen = 325; Hgrey = 365; skillText[4] = "Thorium Ore, Dense Stone";end
			if skillText[1] == "Hakkari Thorium Vein" then Horange = 275; Hyellow = 300; Hgreen = 325; Hgrey = 365; skillText[4] = "Thorium Ore, Dense Stone";end
			if skillText[1] == "Small Obsidian Chunk" then Horange = 305; Hyellow = 330; Hgreen = 355; Hgrey = 400; skillText[4] = "Small/Large Obsidian Shard";end
			if skillText[1] == "Large Obsidian Chunk" then Horange = 305; Hyellow = 330; Hgreen = 355; Hgrey = 400; skillText[4] = "Small/Large Obsidian Shard";end
			--Outlands
			if skillText[1] == "Fel Iron Deposit" then Horange = 300; Hyellow = 325; Hgreen = 350; Hgrey = 400; skillText[4] = "Fel Iron Ore, Mote of Earth/Fire, Eternium Ore";end
			if skillText[1] == "Adamantite Deposit" then Horange = 325; Hyellow = 350; Hgreen = 375; Hgrey = 401; skillText[4] = "Adamantite Ore, Mote of Earth, Eternium Ore";end
			if skillText[1] == "Rich Adamantite Deposit" then Horange = 350; Hyellow = 375; Hgreen = 400; Hgrey = 401; skillText[4] = "Adamantite Ore, Mote of Earth, Eternium Ore";end
			if skillText[1] == "Nethercite Ore" then Horange = 300; Hyellow = 401; Hgreen = 401; Hgrey = 401; skillText[4] = "Nethercite Ore, More of Earth/Fire, Eternium Ore";end
			if skillText[1] == "Khorium Vein" then Horange = 375; Hyellow = 400; Hgreen = 401; Hgrey = 401; skillText[4] = "Khorium Ore, Mote of Earth/Fire, Eternium Ore";end
			if skillText[1] == "Ancient Gem Vein" then Horange = 375; Hyellow = 401; Hgreen = 401; Hgrey = 401; skillText[4] = "";end
			--Northrend
			if skillText[1] == "Cobalt Deposit" then Horange = 350; Hyellow = 375; Hgreen = 400; Hgrey = 450; skillText[4] = "Cobalt Ore, Crystallized Earth/Water";end
			if skillText[1] == "Rich Cobalt Deposit" then Horange = 375; Hyellow = 451; Hgreen = 451; Hgrey = 451; skillText[4] = "Cobalt Ore, Crystallized Earth/Water";end
			if skillText[1] == "Saronite Deposit" then Horange = 400; Hyellow = 425; Hgreen = 451; Hgrey = 451; skillText[4] = "Saronite Ore, Crystallized Earth/Shadow";end
			if skillText[1] == "Rich Saronite Deposit" then Horange = 425; Hyellow = 450; Hgreen = 451; Hgrey = 451; skillText[4] = "Saronite Ore, Crystallized Earth/Shadow";end
			if skillText[1] == "Titanium Deposit" then Horange = 450; Hyellow = 451; Hgreen = 451; Hgrey = 451; skillText[4] = "Saronite Ore, Crystallized Earth/Fire/Water/Air";end
			--Cataclysm
			if skillText[1] == "Obsidium Deposit" then Horange = 425; Hyellow = 450; Hgreen = 475; Hgrey = 500; skillText[4] = "Obsidium Ore, Volatile Earth/Air";end
			if skillText[1] == "Elementium Vein" then Horange = 475; Hyellow = 500; Hgreen = 525; Hgrey = 525; skillText[4] = "Elementium Ore, Volatile Earth/Air/FIre/Water";end
			if skillText[1] == "Rich Elementium Vein" then Horange = 500; Hyellow = 525; Hgreen = 525; Hgrey = 525; skillText[4] = "Elementium Ore, Volatile Earth/Air/Fire/Water";end
			if skillText[1] == "Pyrite Deposit" then Horange = 525; Hyellow = 525; Hgreen = 525; Hgrey = 525; skillText[4] = "Pyrite Ore, Volatile Fire/Air";end
			if skillText[1] == "Rich Pyrite Deposit" then Horange = 525; Hyellow = 525; Hgreen = 525; Hgrey = 525; skillText[4] = "Pyrite Ore, Volatile Fire/Air";end


			--====Herbalism====
			--Old World
			if skillText[1] == "Peacebloom" then Horange = 1; Hyellow = 25; Hgreen = 50; Hgrey = 100; skillText[4] = "Peacebloom"; end
			if skillText[1] == "Silverleaf" then Horange = 1; Hyellow = 25; Hgreen = 50; Hgrey = 100; skillText[4] = "Silverleaf"; end
			if skillText[1] == "Bloodthistle" then Horange = 1; Hyellow = 25; Hgreen = 50; Hgrey = 100; skillText[4] = "Bloodthistle"; end
			if skillText[1] == "Earthroot" then Horange = 15; Hyellow = 40; Hgreen = 65; Hgrey = 115; skillText[4] = "Earthroot"; end
			if skillText[1] == "Mageroyal" then Horange = 50; Hyellow = 75; Hgreen = 100; Hgrey = 150; skillText[4] = "Mageroyal, Swiftthistle"; end
			if skillText[1] == "Briarthorn" then Horange = 70; Hyellow = 95; Hgreen = 120; Hgrey = 170; skillText[4] = "Briarthorn, Swiftthistle"; end
			if skillText[1] == "Stranglekelp" then Horange = 85; Hyellow = 110; Hgreen = 135; Hgrey = 185; skillText[4] = "Stranglekelp"; end
			if skillText[1] == "Bruiseweed" then Horange = 100; Hyellow = 125; Hgreen = 150; Hgrey = 200; skillText[4] = "Bruiseweed"; end
			if skillText[1] == "Wild Steelbloom" then Horange = 115; Hyellow = 140; Hgreen = 165; Hgrey = 215; skillText[4] = "Wild Steelbloom"; end
			if skillText[1] == "Grave Moss" then Horange = 120; Hyellow = 150; Hgreen = 170; Hgrey = 220; skillText[4] = "Grave Moss"; end
			if skillText[1] == "Kingsblood" then Horange = 125; Hyellow = 155; Hgreen = 175; Hgrey = 225; skillText[4] = "Kingsblood"; end
			if skillText[1] == "Liferoot" then Horange = 150; Hyellow = 175; Hgreen = 200; Hgrey = 250; skillText[4] = "Liferoot"; end
			if skillText[1] == "Fadeleaf" then Horange = 160; Hyellow = 185; Hgreen = 210; Hgrey = 260; skillText[4] = "Fadeleaf"; end
			if skillText[1] == "Goldthorn" then Horange = 170; Hyellow = 195; Hgreen = 220; Hgrey = 270; skillText[4] = "Goldthorn"; end
			if skillText[1] == "Khadgar's Whisker" then Horange = 185; Hyellow = 210; Hgreen = 235; Hgrey = 285; skillText[4] = "Khadgar's Whisker"; end
			if skillText[1] == "Wintersbite" then Horange = 195; Hyellow = 225; Hgreen = 245; Hgrey = 295; skillText[4] = "Wintersbite"; end
			if skillText[1] == "Firebloom" then Horange = 205; Hyellow = 235; Hgreen = 255; Hgrey = 305; skillText[4] = "Firebloom"; end
			if skillText[1] == "Purple Lotus" then Horange = 210; Hyellow = 235; Hgreen = 260; Hgrey = 310; skillText[4] = "Purple Lotus, Wildvine"; end
			if skillText[1] == "Arthas' Tears" then Horange = 220; Hyellow = 250; Hgreen = 270; Hgrey = 320; skillText[4] = "Arthas' Tears"; end
			if skillText[1] == "Sungrass" then Horange = 230; Hyellow = 255; Hgreen = 280; Hgrey = 330; skillText[4] = "Sungrass"; end
			if skillText[1] == "Blindweed" then Horange = 235; Hyellow = 260; Hgreen = 285; Hgrey = 335; skillText[4] = "Blindweed"; end
			if skillText[1] == "Ghost Mushroom" then Horange = 245; Hyellow = 270; Hgreen = 295; Hgrey = 345; skillText[4] = "Ghost Mushroom"; end
			if skillText[1] == "Gromsblood" then Horange = 250; Hyellow = 275; Hgreen = 300; Hgrey = 350; skillText[4] = "Gromsblood"; end
			if skillText[1] == "Golden Sansam" then Horange = 260; Hyellow = 280; Hgreen = 310; Hgrey = 360; skillText[4] = "Golden Sansam"; end
			if skillText[1] == "Dreamfoil" then Horange = 270; Hyellow = 295; Hgreen = 320; Hgrey = 370; skillText[4] = "Dreamfoil"; end
			if skillText[1] == "Mountain Silversage" then Horange = 280; Hyellow = 310; Hgreen = 330; Hgrey = 380; skillText[4] = "Mountain Silversage"; end
			if skillText[1] == "Plaguebloom" then Horange = 285; Hyellow = 315; Hgreen = 335; Hgrey = 385; skillText[4] = "Plaguebloom"; end
			if skillText[1] == "Icecap" then Horange = 290; Hyellow = 315; Hgreen = 340; Hgrey = 390; skillText[4] = "Icecap"; end
			if skillText[1] == "Black Lotus" then Horange = 300; Hyellow = 345; Hgreen = 399; Hgrey = 400; skillText[4] = "Black Lotus"; end
			--Outlands
			if skillText[1] == "Felweed" then Horange = 300; Hyellow = 325; Hgreen = 350; Hgrey = 400; skillText[4] = "Felweed, Mote of Life, Fel Blossom, Fel Lotus"; end
			if skillText[1] == "Dreaming Glory" then Horange = 315; Hyellow = 340; Hgreen = 365; Hgrey = 415; skillText[4] = "Dreaming Glory, Mote of Life, Fel Lotus"; end
			if skillText[1] == "Ragveil" then Horange = 325; Hyellow = 350; Hgreen = 400; Hgrey = 425; skillText[4] = "Ragveil, Mote of Life, Fel Lotus"; end
			if skillText[1] == "Flame Cap" then Horange = 335; Hyellow = 350; Hgreen = 410; Hgrey = 435; skillText[4] = "Flame Cap, Fel Lotus"; end
			if skillText[1] == "Terocone" then Horange = 325; Hyellow = 350; Hgreen = 415; Hgrey = 425; skillText[4] = "Terocone, Mote of Life, Fel Lotus"; end
			if skillText[1] == "Ancient Lichen" then Horange = 340; Hyellow = 438; Hgreen = 439; Hgrey = 440; skillText[4] = "Ancient Lichen, Fel Lotus"; end
			if skillText[1] == "Netherbloom" then Horange = 350; Hyellow = 375; Hgreen = 400; Hgrey = 450; skillText[4] = "Netherbloom, Mote of Mana, Fel Lotus"; end
			if skillText[1] == "Netherdust Bush" then Horange = 350; Hyellow = 390; Hgreen = 400; Hgrey = 450; skillText[4] = "Netherdust Pollen, Mote of Mana, Fel Lotus"; end
			if skillText[1] == "Nightmare Vine" then Horange = 365; Hyellow = 390; Hgreen = 415; Hgrey = 465; skillText[4] = "Nightmare Vine, Nightmare Seed, Fel Lotus"; end
			if skillText[1] == "Mana Thistle" then Horange = 375; Hyellow = 415; Hgreen = 425; Hgrey = 475; skillText[4] = "Mana Thistle, Mote of Life, Fel Lotus"; end
			--Northrend
			if skillText[1] == "Goldclover" then Horange = 350; Hyellow = 380; Hgreen = 420; Hgrey = 450; skillText[4] = "Goldclover, Deadnettle, Crystallized Life, Frost Lotus"; end
			if skillText[1] == "Firethorn" then Horange = 360; Hyellow = 385; Hgreen = 450; Hgrey = 460; skillText[4] = "Fire Leaf, Fire Seed, Crystallized Life, Frost Lotus"; end
			if skillText[1] == "Tiger Lily" then Horange = 375; Hyellow = 400; Hgreen = 450; Hgrey = 475; skillText[4] = "Tiger Lily, Deadnettle, Crystallized Life, Frost Lotus"; end
			if skillText[1] == "Talandra's Rose" then Horange = 385; Hyellow = 405; Hgreen = 450; Hgrey = 485; skillText[4] = "Talandra's Rose, Deadnettle, Crystallized Life, Frost Lotus"; end
			if skillText[1] == "Frozen Herb" then Horange = 415; Hyellow = 425; Hgreen = 450; Hgrey = 515; skillText[4] = "Goldclover, Talandra's Rose, Tiger Lily"; end
			if skillText[1] == "Adder's Tongue" then Horange = 400; Hyellow = 415; Hgreen = 450; Hgrey = 500; skillText[4] = "Adder's Tongue, Crystallized Life, Frost Lotus"; end
			if skillText[1] == "Lichbloom" then Horange = 425; Hyellow = 435; Hgreen = 450; Hgrey = 525; skillText[4] = "Lichbloom, Crystallized Life, Frost Lotus"; end
			if skillText[1] == "Icethorn" then Horange = 435; Hyellow = 445; Hgreen = 450; Hgrey = 535; skillText[4] = "Icethorn, Crystallized Life, Frost Lotus"; end
			if skillText[1] == "Frost Lotus" then Horange = 450; Hyellow = 451; Hgreen = 451; Hgrey = 550; skillText[4] = "Deadnettle, Crystallized Life, Frost Lotus"; end
			--Cataclysm

			--====Rogue Lockpick====
			--Old World
				--crafted
			if skillText[1] == "Practice Lock" then Horange = 1; Hyellow = 30; Hgreen = 60; Hgrey = 80; skillText[4] = "Nothing :("; end
				--junkboxes
			if skillText[1] == "Battered Junkbox" then Horange = 1; Hyellow = 30; Hgreen = 75; Hgrey = 105; skillText[4] = "(stuff)"; end
			if skillText[1] == "Worn Junkbox" then Horange = 75; Hyellow = 100; Hgreen = 120; Hgrey = 170; skillText[4] = "(stuff)"; end
			if skillText[1] == "Sturdy Junkbox" then Horange = 175; Hyellow = 200; Hgreen = 225; Hgrey = 225; skillText[4] = "(stuff)"; end
			if skillText[1] == "Heavy Junkbox" then Horange = 250; Hyellow = 275; Hgreen = 300; Hgrey = 350; skillText[4] = "(stuff)"; end
				-- lockboxes (mob drops)
			if skillText[1] == "Ornate Bronze Lockbox" then Horange = 1; Hyellow = 1; Hgreen = 50; Hgrey = 105; skillText[4] = "(stuff)"; end
			if skillText[1] == "Heavy Bronze Lockbox" then Horange = 25; Hyellow = 50; Hgreen = 75; Hgrey = 125; skillText[4] = "(stuff)"; end
			if skillText[1] == "Iron Lockbox" then Horange = 70; Hyellow = 95; Hgreen = 120; Hgrey = 170; skillText[4] = "(stuff)"; end
			if skillText[1] == "Strong Iron Lockbox" then Horange = 125; Hyellow = 150; Hgreen = 175; Hgrey = 225; skillText[4] = "(stuff)"; end
			if skillText[1] == "Steel Lockbox" then Horange = 175; Hyellow = 205; Hgreen = 225; Hgrey = 275; skillText[4] = "(stuff)"; end
			if skillText[1] == "Reinforced Lockbox" then Horange = 225; Hyellow = 250; Hgreen = 275; Hgrey = 325; skillText[4] = "(stuff)"; end
			if skillText[1] == "Mithril Lockbox" then Horange = 225; Hyellow = 250; Hgreen = 275; Hgrey = 325; skillText[4] = "(stuff)"; end
			if skillText[1] == "Thorium Lockbox" then Horange = 225; Hyellow = 250; Hgreen = 275; Hgrey = 325; skillText[4] = "(stuff)"; end
			if skillText[1] == "Froststeel Lockbox" then Horange = 375; Hyellow = 450; Hgreen = 450; Hgrey = 450; skillText[4] = "(stuff)"; end
				--locked chests (fishing)
			if skillText[1] == "Lockbox" then Horange = 1; Hyellow = 300; Hgreen = 300; Hgrey = 300; skillText[4] = "(stuff)"; end
			if skillText[1] == "Lockbox" then Horange = 70; Hyellow = 300; Hgreen = 300; Hgrey = 300; skillText[4] = "(stuff)"; end
			if skillText[1] == "Lockbox" then Horange = 175; Hyellow = 300; Hgreen = 300; Hgrey = 300; skillText[4] = "(stuff)"; end
			if skillText[1] == "Lockbox" then Horange = 250; Hyellow = 300; Hgreen = 300; Hgrey = 300; skillText[4] = "(stuff)"; end
				--footlockers
					--there's several repeated footlockers throughout the world...so data isn't 100% accurate
						--waterlogged, battered, mossy, dented
			if skillText[1] == "Burial Chest" then Horange = 1; Hyellow = 30; Hgreen = 55; Hgrey = 100; skillText[4] = "(stuff)"; end
			if skillText[1] == "Primitive Chest" then Horange = 20; Hyellow = 30; Hgreen = 55; Hgrey = 100; skillText[4] = "(stuff)"; end
			if skillText[1] == "Practice Lockbox" then Horange = 1; Hyellow = 30; Hgreen = 55; Hgrey = 100; skillText[4] = "(stuff)"; end
			if skillText[1] == "Buccaneer's Strongbox" then Horange = 1; Hyellow = 30; Hgreen = 55; Hgrey = 100; skillText[4] = "(stuff)"; end
			if skillText[1] == "The Jewel of the Southsea" then Horange = 25; Hyellow = 30; Hgreen = 75; Hgrey = 125; skillText[4] = "(stuff)"; end
			if skillText[1] == "Waterlogged Footlocker" then Horange = 70; Hyellow = 95; Hgreen = 120; Hgrey = 150; skillText[4] = "(stuff)"; end
			if skillText[1] == "Gallywix's Lockbox" then Horange = 70; Hyellow = 100; Hgreen = 120; Hgrey = 170; skillText[4] = "(stuff)"; end
			if skillText[1] == "Duskwood Chest" then Horange = 70; Hyellow = 100; Hgreen = 120; Hgrey = 170; skillText[4] = "(stuff)"; end
			if skillText[1] == "Battered Footlocker" then Horange = 110; Hyellow = 135; Hgreen = 160; Hgrey = 175; skillText[4] = "(stuff)"; end
			if skillText[1] == "Mossy Footlocker" then Horange = 175; Hyellow = 200; Hgreen = 225; Hgrey = 250; skillText[4] = "(stuff)"; end
			if skillText[1] == "Dented Footlocker" then Horange = 175; Hyellow = 200; Hgreen = 225; Hgrey = 250; skillText[4] = "(stuff)"; end
			if skillText[1] == "Scarlet Footlocker" then Horange = 250; Hyellow = 275; Hgreen = 300; Hgrey = 350; skillText[4] = "(stuff)"; end
			if skillText[1] == "Wicker Chest" then Horange = 300; Hyellow = 325; Hgreen = 350; Hgrey = 400; skillText[4] = "(stuff)"; end
				--treasure chests
			if skillText[1] == "Large Iron Bound Chest" then Horange = 25; Hyellow = 50; Hgreen = 75; Hgrey = 105; skillText[4] = "(stuff)"; end
			if skillText[1] == "Large Mithril Bound Chest" then Horange = 175; Hyellow = 200; Hgreen = 225; Hgrey = 225; skillText[4] = "(stuff)"; end
			--if skillText[1] == "Large Mithril Bound Chest" then Horange = 250; Hyellow = 275; Hgreen = 300; Hgrey = 350; skillText[4] = "(stuff)"; end
				--doors
			if skillText[1] == "Gate" then Horange = 1; Hyellow = 30; Hgreen = 55; Hgrey = 100; skillText[4] = ""; end
			if skillText[1] == "Workshop Door" then Horange = 150; Hyellow = 175; Hgreen = 200; Hgrey = 250; skillText[4] = ""; end
			if skillText[1] == "Armory Door" then Horange = 175; Hyellow = 200; Hgreen = 225; Hgrey = 275; skillText[4] = ""; end
			if skillText[1] == "Cathedral Door" then Horange = 175; Hyellow = 200; Hgreen = 225; Hgrey = 275; skillText[4] = ""; end
			if skillText[1] == "Searing Gorge Gate" then Horange = 225; Hyellow = 250; Hgreen = 275; Hgrey = 350; skillText[4] = ""; end
			if skillText[1] == "East Garrison Door" then Horange = 250; Hyellow = 275; Hgreen = 300; Hgrey = 350; skillText[4] = ""; end
			if skillText[1] == "Prison Cell" then Horange = 225; Hyellow = 250; Hgreen = 300; Hgrey = 350; skillText[4] = ""; end
			if skillText[1] == "Shadowforge Gate" then Horange = 250; Hyellow = 275; Hgreen = 300; Hgrey = 350; skillText[4] = ""; end
			if skillText[1] == "Shadowforge Mechanism" then Horange = 250; Hyellow = 275; Hgreen = 300; Hgrey = 350; skillText[4] = ""; end
			if skillText[1] == "Scholomance Door" then Horange = 280; Hyellow = 325; Hgreen = 340; Hgrey = 350; skillText[4] = ""; end
			if skillText[1] == "Stratholme Gate" then Horange = 300; Hyellow = 325; Hgreen = 340; Hgrey = 350; skillText[4] = ""; end
			if skillText[1] == "Crescent Door" then Horange = 300; Hyellow = 325; Hgreen = 400; Hgrey = 400; skillText[4] = ""; end
			--Outlands
				--junkboxes
			if skillText[1] == "Strong Junkbox" then Horange = 300; Hyellow = 325; Hgreen = 350; Hgrey = 400; skillText[4] = "(stuff)"; end
				--lockboxes (mob drops)
			if skillText[1] == "Eternium Lockbox" then Horange = 225; Hyellow = 265; Hgreen = 320; Hgrey = 325; skillText[4] = "(stuff)"; end
			if skillText[1] == "Khorium Lockbox" then Horange = 325; Hyellow = 350; Hgreen = 450; Hgrey = 450; skillText[4] = "(stuff)"; end
				--treasure chests
			if skillText[1] == "Bound Fel Iron Chest" then Horange = 300; Hyellow = 325; Hgreen = 350; Hgrey = 400; skillText[4] = "(stuff)"; end
			if skillText[1] == "Bound Adamantite Chest" then Horange = 325; Hyellow = 350; Hgreen = 375; Hgrey = 450; skillText[4] = "(stuff)"; end
			--if skillText[1] == "Bound Adamantite Chest" then Horange = 350; Hyellow = 375; Hgreen = 400; Hgrey = 450; skillText[4] = "(stuff)"; end
				--doors
			if skillText[1] == "Shattered Halls Door" then Horange = 350; Hyellow = 375; Hgreen = 400; Hgrey = 425; skillText[4] = ""; end
			if skillText[1] == "Shadow Labyrinth Gate" then Horange = 350; Hyellow = 375; Hgreen = 400; Hgrey = 450; skillText[4] = ""; end
			if skillText[1] == "Arcatraz Door" then Horange = 350; Hyellow = 375; Hgreen = 400; Hgrey = 450; skillText[4] = ""; end
			--Northrend
				--junkboxes
			if skillText[1] == "Reinforced Junkbox" then Horange = 350; Hyellow = 375; Hgreen = 450; Hgrey = 450; skillText[4] = "(stuff)"; end
				--lockboxes (mob drops)
			if skillText[1] == "Titanium Lockbox" then Horange = 400; Hyellow = 450; Hgreen = 450; Hgrey = 450; skillText[4] = "(stuff)"; end
				--doors
			if skillText[1] == "Kharazhan Door" then Horange = 350; Hyellow = 375; Hgreen = 400; Hgrey = 450; skillText[4] = ""; end
			if skillText[1] == "Violet Hold Door" then Horange = 365; Hyellow = 400; Hgreen = 450; Hgrey = 450; skillText[4] = ""; end
			--Cataclysm
			

			--Read "require" off node
			if skillText[2] == "Requires Herbalism" then
				--herbalism
				if GetSkillValue("Herbalism") < 450 then 
					skillText[3] = "Skill:" .. GetSkillValue("Herbalism") .. " (" .. Horange .. "-" .. Hgrey .. ")"
				else
					--hide the skill line of text if at maximum skill
					skillText[3] = "NONE"
				end
				--determine node "difficulty"
				chance = 101  --can't harvest
				if GetSkillValue("Herbalism") >= Horange then chance = 100; end
				if GetSkillValue("Herbalism") >= Hyellow then chance = 75; end
				if GetSkillValue("Herbalism") >= Hgreen then chance = 50; end
				if GetSkillValue("Herbalism") >= Hgrey then chance = 0; end
				if GetSkillValue("Herbalism") < Horange then chance = 101; end

			elseif skillText[2] == "Requires Mining" then
				--mining
				if GetSkillValue("Mining") < 450 then 
					skillText[3] = "Skill:" .. GetSkillValue("Mining").. " (" ..  Horange .. "-" .. Hgrey .. ")"
				else
					--hide the skill line of text if at maximum skill
					skillText[3] = "NONE"
				end
				--determine node "difficulty"
				chance = 101  --can't harvest
				if GetSkillValue("Mining") >= Horange then chance = 100; end
				if GetSkillValue("Mining") >= Hyellow then chance = 75; end
				if GetSkillValue("Mining") >= Hgreen then chance = 50; end
				if GetSkillValue("Mining") >= Hgrey then chance = 0; end
				if GetSkillValue("Mining") < Horange then chance = 101; end
			elseif skillText[2] == "Locked" and Hgrey and Horange then
				--lockpicking
				if GetSkillValue("Lockpicking") < 450 then
					skillText[3] = "Skill:" .. GetSkillValue("Lockpicking").. " (" ..  Horange .. "-" .. Hgrey .. ")"
				else
					--hide the skill line of text if at maximum skill
					skillText[3] = "NONE"
				end
				--determine node "difficulty"
				chance = 101  --can't harvest
				if GetSkillValue("Lockpicking") >= Horange then chance = 100; end
				if GetSkillValue("Lockpicking") >= Hyellow then chance = 75; end
				if GetSkillValue("Lockpicking") >= Hgreen then chance = 50; end
				if GetSkillValue("Lockpicking") >= Hgrey then chance = 0; end
				if GetSkillValue("Lockpicking") < Horange then chance = 101; end
				--Handle professions that effect this skill: Blacksmithing, Engineering
				if GetSkillValue("Engineering") > 1 then
					if Horange < 150 then skillText[4] = "Use [Small Seaforium Charge]"; end
					if Horange < 250 then skillText[4] = "Use [Large Seaforium Charge]"; end
					if Horange < 300 then skillText[4] = "Use [Powerful Seaforim Charge]"; end
					if Horange < 350 then skillText[4] = "Use [Elemental Seaforium Charge]"; end
				end
				if GetSkillValue("Blacksmithing") > 1 then
					if Horange < 25 then skillText[4] = "Use [Silver Skeleton Key]"; end
					if Horange < 125 then skillText[4] = "Use [Golden Skeleton Key]"; end
					if Horange < 200 then skillText[4] = "Use [Truesilver Skeleton Key]"; end
					if Horange < 300 then skillText[4] = "Use [Arcanite Skeleton Key]"; end
					if Horange < 375 then skillText[4] = "Use [Cobalt Skeleton Key]"; end
					if Horange < 430 then skillText[4] = "Use [Titanium Skeleton Key]"; end
				end
				if GetSkillValue("Blacksmithing") > 1 and GetSkillValue("Engineering") > 1 then
					--for the crazy people that have BOTH Blacksmithing and Engineering!
					if Horange < 25 then skillText[4] = "Use [Silver Skeleton Key] or [Small Seaforium Charge]"; end
					if Horange < 125 then skillText[4] = "Use [Golden Skeleton Key] or [Small Seaforium Charge]"; end
					if Horange < 150 then skillText[4] = "Use [Truesilver Skeleton Key] or [Small Seaforium Charge]"; end
					if Horange < 200 then skillText[4] = "Use [Truesilver Skeleton Key] or [Large Seaforium Charge]"; end
					if Horange < 250 then skillText[4] = "Use [Arcanite Skeleton Key] or [Large Seaforium Charge]"; end
					if Horange < 300 then skillText[4] = "Use [Arcanite Skeleton Key] or [Powerful Seaforium Charge]"; end
					if Horange < 350 then skillText[4] = "Use [Cobalt Skeleton Key] or [Elemental Seaforium Charge]"; end
					if Horange < 375 then skillText[4] = "Use [Cobalt Skeleton Key] or [Elemental Seaforium Charge]"; end
					if Horange < 430 then skillText[4] = "Use [Titanium Skeleton Key] or [Elemental Seaforium Charge]"; end
				end
			elseif skillText[2] == "Prospectable" then
				skillText[4] = "(SkillWatcher: Not in database! Let me know what this is)";
				if skillText[1] == "Copper Ore" then skillText[4] = "Common: Tigerseye, Malachite"; end
				if skillText[1] == "Tin Ore" then skillText[4] = "Common: Shadowgem, Lesser Moonstone, Moss Agate"; end
				if skillText[1] == "Iron Ore" then skillText[4] = "Common: Citrine, Lesser Moonstone, Jade"; end
				if skillText[1] == "Mithril Ore" then skillText[4] = "Common: Citrine, Star Ruby, Aquamarine"; end
				if skillText[1] == "Thorium Ore" then skillText[4] = "Common: Star Ruby, Large Opal, Blue Sapphire, Huge Emerald, Azerothian Diamond"; end
				if skillText[1] == "Fel Iron Ore" then skillText[4] = "Common: Tigerseye, Malachite"; end
				if skillText[1] == "Adamantite Ore" then skillText[4] = "Common: Blood Garnet, Flame Spessarite, Golden Draenite, Deep Peridot, Azure Moonstone, Shadow Draenite"; end
				if skillText[1] == "Cobalt Ore" then skillText[4] = "Common: Bloodstone, Huge Citrine, Sun Crystal, Dark Jade, Chalcedony, Shadow Crystal"; end
				if skillText[1] == "Saronite Ore" then skillText[4] = "Common: Bloodstone, Huge Citrine, Sun Crystal, Dark Jade, Chalcedony, Shadow Crystal"; end
				if skillText[1] == "Titanium Ore" then skillText[4] = "Common: Bloodstone, Huge Citrine, Sun Crystal, Dark Jade, Chalcedony, Shadow Crystal"; end
			else 
				--some other node!?
				skillText[3] = "NOTVALID"
				--skillText[3] = "Not found!  Let me know that this was flagged: Flag = 1 and [" .. skillText[2] .. "]"
			end
		end

		if flag == 1 then
			--replace the "requires skill" line with the crap that drops info
			skillText[2] = skillText[4]
			skillText[4] = ""

			--clear placeholder
			if skillText[3] == "NONE" then skillText[3] = ""; end;

			--fill tooltip with all the info
			for x=1, table.getn(skillText) do
				text = skillText[x]
				if (text) and SkillWatcherConfig_TooltipON == 1 and skillText[3] ~= "NOTVALID" then
					--DEFAULT_CHAT_FRAME:AddMessage("SkillWatcher Tooltip: #" .. x .. " " .. text);
					if x == 1 then
						GameTooltip:SetOwner(WorldFrame, "ANCHOR_CURSOR")
						GameTooltip:SetText(text)
					elseif x == 2 then
						--other crap that drops off nodes
						GameTooltip:AddLine(text, 1, 1, 1)
					else
						--red cant grab
						--orange 100%
						--yellow 75
						--green <50
						--grey 0%
						redColor = .7
						greenColor = .7
						blueColor = .7
						if chance == 101 then redColor = 1; greenColor = 0; blueColor = 0; end
						if chance == 100 then redColor = 1; greenColor = .8; blueColor = 0; end
						if chance == 75 then redColor = 1; greenColor = 1; blueColor = 0; end
						if chance == 50 then redColor = 0; greenColor = 1; blueColor = 0; end
						GameTooltip:AddLine(text, redColor, greenColor, blueColor)
					end
					GameTooltip:Show()
				else
					if SkillWatcherConfig_TooltipON == 1 then
						--tooltip flag is on, but hidden because either notext, or notvalid
						GameTooltip:Hide()
						flag = 0
					end
				end
			end
		end
	end

	-- ==== Config Window Toggle ====
	function ToggleConfig()
		-- toggle config menu
		if(SkillWatcher.panel:IsVisible() ) then
			SkillWatcher.panel:Hide();
		else
			SkillWatcher.panel:Show();
		end
	end

    -- ==== Addon Loaded ====
	--this is called from the XML file
	function SkillWatcher()
		SkillArray = {};
		
		-- ==== Interface Options Panel ====
			--this shows in the game options window
		SkillWatcher = {};
		SkillWatcher.panel = CreateFrame( "Frame", "SkillWatcherPanel", UIParent );
		--panel size is 385x409
		-- Register in the Interface Addon Options GUI
		-- Set the name for the Category for the Options Panel
		SkillWatcher.panel.name = "SkillWatcher";
		   --button handler functions
		SkillWatcher.panel.okay = function(self)
			--self.originalValue = MY_VARIABLE;
			if TestCheckButton:GetChecked() == 1 then
				SkillWatcherConfig_defaultTest = 1
			else
				SkillWatcherConfig_defaultTest = 2
			end
			
			if TooltipMiningCheckButton:GetChecked() == 1 then
				SkillWatcherConfig_TooltipMiningON = 1
			else
				SkillWatcherConfig_TooltipMiningON = 2
			end
			
			if TooltipHerbCheckButton:GetChecked() == 1 then
				SkillWatcherConfig_TooltipHerbON = 1
			else
				SkillWatcherConfig_TooltipHerbON = 2
			end
			
			if WindowCheckButton:GetChecked() == 1 then
				SkillWatcherConfig_WindowON = 1
			else
				SkillWatcherConfig_WindowON = 2
			end

			if TooltipCheckButton:GetChecked() == 1 then
				SkillWatcherConfig_TooltipON = 1
			else
				SkillWatcherConfig_TooltipON = 2
			end
		end

		SkillWatcher.panel.cancel = function(self) 
			--MY_VARIABLE = self.originalValue
			if SkillWatcherConfig_TooltipMiningON == 1 then
				TooltipMiningCheckButton:SetChecked(1)
			else
				TooltipMiningCheckButton:SetChecked(0)
			end
			if SkillWatcherConfig_TooltipHerbON == 1 then
				TooltipHerbCheckButton:SetChecked(1)
			else
				TooltipHerbCheckButton:SetChecked(0)
			end			
			if SkillWatcherConfig_defaultTest == 1 then
				TestCheckButton:SetChecked(1)
			else
				TestCheckButton:SetChecked(0)
			end
			if SkillWatcherConfig_WindowON == 1 then
				WindowCheckButton:SetChecked(1)
			else
				WindowCheckButton:SetChecked(0)
			end
			if SkillWatcherConfig_TooltipON == 1 then
				TooltipCheckButton:SetChecked(1)
			else
				TooltipCheckButton:SetChecked(0)
			end
		end
		SkillWatcher.panel.default = function(self) 
			--self.originalValue = DEFAULT VALUE
			SkillWatcherConfig_WindowON = SkillWatcherConfig_defaultWindowON
			SkillWatcherConfig_DetailWindowON = SkillWatcherConfig_defaultDetailWindowON
			SkillWatcherConfig_TooltipMiningON = SkillWatcherConfig_defaultTooltipMiningON
			SkillWatcherConfig_TooltipHerbON = SkillWatcherConfig_defaultTooltipHerbON
			SkillWatcherConfig_TooltipON = SkillWatcherConfig_defaultTooltipON
			
			if SkillWatcherConfig_defaultTest == 1 then
				TestCheckButton:SetChecked(1)
			else
				TestCheckButton:SetChecked(0)
			end

			if SkillWatcherConfig_TooltipMiningON == 1 then
				TooltipMiningCheckButton:SetChecked(1)
			else
				TooltipMiningCheckButton:SetChecked(0)
			end
			if SkillWatcherConfig_TooltipHerbON == 1 then
				TooltipHerbCheckButton:SetChecked(1)
			else
				TooltipHerbCheckButton:SetChecked(0)
			end
			if SkillWatcherConfig_WindowON == 1 then
				WindowCheckButton:SetChecked(1)
			else
				WindowCheckButton:SetChecked(0)
			end		
			if SkillWatcherConfig_TooltipON == 1 then
				TooltipCheckButton:SetChecked(1)
			else
				TooltipCheckButton:SetChecked(0)
			end	
		end
		
		-- Add the panel to the Interface Options
		InterfaceOptions_AddCategory(SkillWatcher.panel);
		
		--make a checkbutton on the interface options panel
		TestCheckButton = CreateFrame("CheckButton", "TestCheckButton", SkillWatcher.panel, "OptionsCheckButtonTemplate")
		TestCheckButton:SetWidth("25")
		TestCheckButton:SetHeight("25")
		TestCheckButton:SetPoint("TOPLEFT", 16, -40)
		TestCheckButton:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
		TestCheckButton:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
		TestCheckButton:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight", "ADD")
		TestCheckButton:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
		TestCheckButton:Show()
		--text
		SkillWatcherFrame.textSub = SkillWatcher.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		SkillWatcherFrame.textSub:SetPoint("TOPLEFT", 45, -46)
		SkillWatcherFrame.textSub:SetText("Test checkbox (does nothing)")
		if SkillWatcherConfig_defaultTest == 1 then
			TestCheckButton:SetChecked(1)
		else
			TestCheckButton:SetChecked(0)
		end

		--make a checkbutton - use tooltip for mining nodes
		TooltipMiningCheckButton = CreateFrame("CheckButton", "TestCheckButton", SkillWatcher.panel, "OptionsCheckButtonTemplate")
		TooltipMiningCheckButton:SetWidth("25")
		TooltipMiningCheckButton:SetHeight("25")
		TooltipMiningCheckButton:SetPoint("TOPLEFT", 16, -65)
		TooltipMiningCheckButton:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
		TooltipMiningCheckButton:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
		TooltipMiningCheckButton:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight", "ADD")
		TooltipMiningCheckButton:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
		TooltipMiningCheckButton:Show()
		--text
		SkillWatcherFrame.textSub = SkillWatcher.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		SkillWatcherFrame.textSub:SetPoint("TOPLEFT", 45, -71)
		SkillWatcherFrame.textSub:SetText("Enable Tooltip (Mining)")
		if SkillWatcherConfig_TooltipMiningON == 1 then
			TooltipMiningCheckButton:SetChecked(1)
		else
			TooltipMiningCheckButton:SetChecked(0)
		end

		--make a checkbutton - use tooltip for Herb nodes
		TooltipHerbCheckButton = CreateFrame("CheckButton", "TestCheckButton", SkillWatcher.panel, "OptionsCheckButtonTemplate")
		TooltipHerbCheckButton:SetWidth("25")
		TooltipHerbCheckButton:SetHeight("25")
		TooltipHerbCheckButton:SetPoint("TOPLEFT", 16, -90)
		TooltipHerbCheckButton:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
		TooltipHerbCheckButton:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
		TooltipHerbCheckButton:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight", "ADD")
		TooltipHerbCheckButton:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
		TooltipHerbCheckButton:Show()
		--text
		SkillWatcherFrame.textSub = SkillWatcher.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		SkillWatcherFrame.textSub:SetPoint("TOPLEFT", 45, -96)
		SkillWatcherFrame.textSub:SetText("Enable Tooltip (Herb)")
		if SkillWatcherConfig_TooltipHerbON == 1 then
			TooltipHerbCheckButton:SetChecked(1)
		else
			TooltipHerbCheckButton:SetChecked(0)
		end
		
		--make a checkbutton - window toggle
		WindowCheckButton = CreateFrame("CheckButton", "TestCheckButton", SkillWatcher.panel, "OptionsCheckButtonTemplate")
		WindowCheckButton:SetWidth("25")
		WindowCheckButton:SetHeight("25")
		WindowCheckButton:SetPoint("TOPLEFT", 16, -115)
		WindowCheckButton:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
		WindowCheckButton:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
		WindowCheckButton:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight", "ADD")
		WindowCheckButton:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
		WindowCheckButton:Show()
		--text
		SkillWatcherFrame.textSub = SkillWatcher.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		SkillWatcherFrame.textSub:SetPoint("TOPLEFT", 45, -121)
		SkillWatcherFrame.textSub:SetText("Enable Skill Window")
		if SkillWatcherConfig_WindowON == 1 then
			WindowCheckButton:SetChecked(1)
		else
			WindowCheckButton:SetChecked(0)
		end
		
		--make a button to show/hide the config window for specific skills
		DetailWindowButton = CreateFrame("Button", "DetailWindowButton", SkillWatcher.panel, "UIPanelButtonTemplate");
		DetailWindowButton:SetWidth(250)
		DetailWindowButton:SetHeight(22)
		DetailWindowButton:SetText("Select Skills to AUTO/SHOW/HIDE")
		DetailWindowButton:SetPoint("CENTER",0 ,0)
		DetailWindowButton:SetScript("OnClick", function() if SkillWatcherConfig_DetailWindowON == 1 then SkillWatcherConfig_DetailWindowON = 0 else SkillWatcherConfig_DetailWindowON = 1; end; end)
		DetailWindowButton:SetAlpha(1)
		DetailWindowButton:Show()

		--make a checkbutton - use tooltip for toggling the tooltip window
		TooltipCheckButton = CreateFrame("CheckButton", "TestCheckButton", SkillWatcher.panel, "OptionsCheckButtonTemplate")
		TooltipCheckButton:SetWidth("25")
		TooltipCheckButton:SetHeight("25")
		TooltipCheckButton:SetPoint("TOPLEFT", 16, -140)
		TooltipCheckButton:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
		TooltipCheckButton:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
		TooltipCheckButton:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight", "ADD")
		TooltipCheckButton:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
		TooltipCheckButton:Show()
		--text
		SkillWatcherFrame.textSub = SkillWatcher.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		SkillWatcherFrame.textSub:SetPoint("TOPLEFT", 45, -146)
		SkillWatcherFrame.textSub:SetText("Show Tooltip when hovering over stuff")
		if SkillWatcherConfig_TooltipON == 1 then
			TooltipCheckButton:SetChecked(1)
		else
			TooltipCheckButton:SetChecked(0)
		end
		
		--	turn mod on and off SkillWatcherFrame:Hide(); and Show();
		--	replace tooltip
		--	use skill window


		--title text
		SkillWatcherFrame.textTitle = SkillWatcher.panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		SkillWatcherFrame.textTitle:SetPoint("TOPLEFT", 16, -16)
		SkillWatcherFrame.textTitle:SetJustifyH("LEFT")
		SkillWatcherFrame.textTitle:SetJustifyV("TOP")
		SkillWatcherFrame.textTitle:SetText("SkillWatcher " .. SkillWatcherVersion)
		--subtext
		SkillWatcherFrame.textSub = SkillWatcher.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		SkillWatcherFrame.textSub:SetPoint("TOPLEFT", 16, -32)
		SkillWatcherFrame.textSub:SetJustifyH("LEFT")
		SkillWatcherFrame.textSub:SetJustifyV("TOP")
		SkillWatcherFrame.textSub:SetText("A small window to quickly view current skill levels")
		--options text
		--SkillWatcherFrame.textSub = SkillWatcher.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		--SkillWatcherFrame.textSub:SetPoint("CENTER", 0, 0)
		--SkillWatcherFrame.textSub:SetText("This addon has no configuration options (yet!)")


		--display the information window on load
		SkillWatcher_UpdateWindow()
		--notify that addon was loaded
		DEFAULT_CHAT_FRAME:AddMessage("SkillWatcher " .. SkillWatcherVersion .. " " .. SkillWatcherGameVersion ..": Addon Loaded");
	end


	function SkillWatcher_AddonLoaded()
			-- variable management
			if SkillWatcherConfig_TooltipMiningON ~= 1 and SkillWatcherConfig_TooltipMiningON ~= 2 then
				DEFAULT_CHAT_FRAME:AddMessage("Mining - default")
				SkillWatcherConfig_TooltipMiningON = SkillWatcherConfig_defaultTooltipMiningON
			end
			if SkillWatcherConfig_TooltipHerbON ~= 1 and SkillWatcherConfig_TooltipHerbON ~= 2 then
				DEFAULT_CHAT_FRAME:AddMessage("Herb - default")
				SkillWatcherConfig_TooltipHerbON = SkillWatcherConfig_defaultTooltipHerbON
			end			
			if SkillWatcherConfig_TooltipON ~= 1 and SkillWatcherConfig_TooltipON ~= 2 then
				DEFAULT_CHAT_FRAME:AddMessage("Tooltip - default")
				SkillWatcherConfig_TooltipON = SkillWatcherConfig_defaultTooltipON
			end			
			if SkillWatcherConfig_WindowON ~= 1 and SkillWatcherConfig_WindowON ~= 2 then
				DEFAULT_CHAT_FRAME:AddMessage("Window - default")
				SkillWatcherConfig_WindowON = SkillWatcherConfig_defaultWindowON
			end			
			if SkillWatcherConfig_DetailWindowON ~= 1 and SkillWatcherConfig_DetailWindowON ~= 2 then
				DEFAULT_CHAT_FRAME:AddMessage("Detail - default")
				SkillWatcherConfig_DetailWindowON = SkillWatcherConfig_defaultWindowDetailON
			end
			
			-- flag the buttons
			if SkillWatcherConfig_TooltipMiningON == 1 then
				TooltipMiningCheckButton:SetChecked(1)
			else
				TooltipMiningCheckButton:SetChecked(0)
			end
			if SkillWatcherConfig_TooltipHerbON == 1 then
				TooltipHerbCheckButton:SetChecked(1)
			else
				TooltipHerbCheckButton:SetChecked(0)
			end
			if SkillWatcherConfig_TooltipON == 1 then
				TooltipCheckButton:SetChecked(1)
			else
				TooltipCheckButton:SetChecked(0)
			end
			if SkillWatcherConfig_WindowON == 1 then
				WindowCheckButton:SetChecked(1)
			else
				WindowCheckButton:SetChecked(0)
			end
		DEFAULT_CHAT_FRAME:AddMessage(" Skillwatcher variables loaded and set!")
	end
	
    -- ==== Event Handler ====
    function SkillWatcher_EventHandler(self, event, ...)
		local arg1 = ...
		--if arg1 then
		--DEFAULT_CHAT_FRAME:AddMessage(" EVENT:" .. event .. arg1)
		--else
		--DEFAULT_CHAT_FRAME:AddMessage(" EVENT:" .. event .. "-none-")
		--end

		if event == "ADDON_LOADED" then
			if arg1 == "SkillWatcher" then
				SkillWatcher_AddonLoaded()
			end
		end
		
		-- ==== SkillWatcherFrame ====
		if frameAllLoaded ~= 1 then
			-- ==== create frame ====
			SkillWatcherFrame = CreateFrame("ScrollingMessageFrame", "SkillWatcherFrame", UIParent)
			--strata
			SkillWatcherFrame:SetFrameStrata("BACKGROUND")
			--texture
			SkillWatcherFrame:SetBackdrop({
			bgFile = "Interface/Tooltips/ChatBubble-Background",
			-- edgeFile = "Interface/Tooltips/ChatBubble-BackDrop", --frame border
			tile = true, tileSize = 32, edgeSize = 0,
				insets = { left = 0, right = 0, top = 0, bottom = 0 }
			})

			SkillWatcherFrame:SetHeight(0) --0 height, since this window dynamically changes height based on content
			SkillWatcherFrame:SetWidth(150)
			SkillWatcherFrame:SetMovable(true)
			SkillWatcherFrame:EnableMouse(true)
			SkillWatcherFrame:SetUserPlaced(true)
			
			-- ==== Frame Dragging ====
				--when user drags the frame, same the location of the window to the variables marked for saving
			SkillWatcherFrame:SetScript("OnMouseDown", function() SkillWatcherFrame:StartMoving(); end)
			SkillWatcherFrame:SetScript("OnMouseUp", function() SkillWatcherFrame:StopMovingOrSizing();
			SkillWatcherPoint, relativeTo, relativePoint, SkillWatcherX, SkillWatcherY = SkillWatcherFrame:GetPoint(); end)

			-- ==== Text within Frame ====

			SkillWatcherFrame.text = SkillWatcherFrame:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
			SkillWatcherFrame.text:SetAllPoints()
			SkillWatcherFrame.text:SetJustifyH("LEFT");
			SkillWatcherFrame.text:SetJustifyV("TOP");
			SkillWatcherFrame:Show();
			frameAllLoaded = 1

			SkillWatcherFrame:ClearAllPoints()
			if SkillWatcherPoint then
				--set window to location from saved variables
				SkillWatcherFrame:SetPoint(SkillWatcherPoint, SkillWatcherX, SkillWatcherY)
			else
				--set default position
				SkillWatcherFrame:SetPoint("CENTER", 0, 0)
			end
		end
			--populate the info window
			SkillWatcher_UpdateWindow()
		
		-- ==== SkillWatcherFrameDetails ====
			-- ==== create frame ====
			SkillWatcherFrameDetails = CreateFrame("ScrollingMessageFrame", "SkillWatcherFrameDetails", UIParent)
			--strata
			SkillWatcherFrameDetails:SetFrameStrata("LOW") --highest strata with linking working
			--texture
			SkillWatcherFrameDetails:SetBackdrop({
			bgFile = "Interface/Tooltips/ChatBubble-Background",
			-- edgeFile = "Interface/Tooltips/ChatBubble-BackDrop", --frame border
			tile = true, tileSize = 32, edgeSize = 0,
				insets = { left = 0, right = 0, top = 0, bottom = 0 }
			})

			SkillWatcherFrameDetails:SetHeight(0) --0 height, since this window dynamically changes height based on content
			SkillWatcherFrameDetails:SetWidth(250)
			SkillWatcherFrameDetails:SetMovable(true)
			SkillWatcherFrameDetails:EnableMouse(true)
			SkillWatcherFrameDetails:SetUserPlaced(true)
			
			SkillWatcherFrameDetails:SetHeight(0)

			-- ==== Text within Frame ====

			SkillWatcherFrameDetails.text = SkillWatcherFrameDetails:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
			SkillWatcherFrameDetails.text:SetAllPoints()
			SkillWatcherFrameDetails.text:SetText("")

			SkillWatcherFrameDetails:SetFontObject("GameFontNormal");
			SkillWatcherFrameDetails:SetJustifyH("LEFT");
			SkillWatcherFrameDetails:SetJustifyV("TOP");
			SkillWatcherFrameDetails:SetHyperlinksEnabled(true);
			SkillWatcherFrameDetails:SetFading(false);

			SkillWatcherFrameDetails:SetScript("OnHyperlinkClick", function(...) OnHyperlinkClicked(...) end)
		

			--loop through and display all the things
						
			textThing = "|c00ffffff Click on a skill to AUTO/SHOW/HIDE |r\n";
			frameHeight = 28;
			
			--setup us the professions
				--bad programmer doesn't put this into a function
			local prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions();
			for i=1, 6 do
				skillName = ""
				if i == 1 and prof1 then
					local name, icon, skillLevel, maxSkillLevel, numAbilities, return6, return7 = GetProfessionInfo(prof1)
					skillName = name
					skillID = firstAid
				end
				if i == 2 and prof2 then
					local name, icon, skillLevel, maxSkillLevel, numAbilities, return6, return7 = GetProfessionInfo(prof2)
					skillName = name
					skillID = firstAid
				end
				if i == 3 and archaeology then
					local name, icon, skillLevel, maxSkillLevel, numAbilities, return6, return7 = GetProfessionInfo(archaeology)
					skillName = name
					skillID = firstAid
				end
				if i == 4 and fishing then
					local name, icon, skillLevel, maxSkillLevel, numAbilities, return6, return7 = GetProfessionInfo(fishing)
					skillName = name
					skillID = firstAid
				end
				if i == 5 and cooking then
					local name, icon, skillLevel, maxSkillLevel, numAbilities, return6, return7 = GetProfessionInfo(cooking)
					skillName = name
					skillID = firstAid
				end
				if i == 6 and firstAid then
					local name, icon, skillLevel, maxSkillLevel, numAbilities, return6, return7 = GetProfessionInfo(firstAid)
					skillName = name
					skillID = firstAid
				end

				if skillName ~= "" then
					--make sure skill array is good
					if not (SkillArray[skillName]) then
						--table for holding skill levels
						SkillArray[skillName] = {
							["current"] = GetSkillValue(skillName),
							["max"] = GetSkillMaxValue(skillName),
							["old"] = 0,
							["color"] = "00ffffff",
							["show"] = 1
							};
					end
				frameHeight = frameHeight + 12
				--Format text line for info window
				textThing = textThing .. "|cffffd000|H" .. skillName .. "|h["..skillName.."]|h|r \n"
				end
			end		
				

			-----------------------
	
	
			
			SkillWatcherFrameDetails:AddMessage(textThing .. "|c00ff0000 |HCLOSE|h[Close Window]|h|r");
			SkillWatcherFrameDetails:SetHeight(frameHeight)
			
			--SkillWatcherFrameDetails:AddMessage("|cffffd000|Henchant:2963|h[Tailoring: Bolt of Linen Cloth]|h|r");
			SkillWatcherFrameDetails:Show();

			SkillWatcherFrameDetails:ClearAllPoints()
				--set default position
				SkillWatcherFrameDetails:SetPoint("CENTER", 0, 0)
			
			--populate the info window
			SkillWatcherDetails_UpdateWindow()			


	end

	-- ==== Clicked on a link ====	
	function OnHyperlinkClicked(frame, link)
		if link == "CLOSE" then
			SkillWatcherConfig_DetailWindowON = 0
		end
		
			if not (SkillArray[link]) then
				--table for holding skill levels
				SkillArray[link] = {
					["current"] = GetSkillValue(link),
					["max"] = GetSkillMaxValue(link),
					["old"] = 0,
					["color"] = "00ffffff",
					["show"] = 0
					};
			end
		SkillArray[link].show = SkillArray[link].show + 1
		if SkillArray[link].show == 3 then
			SkillArray[link].show = 0
		end
		
		--if SkillArray[link].show == 0 then DEFAULT_CHAT_FRAME:AddMessage( "Skill: ".. link.." is now HIDDEN ALWAYS"); end
		--if SkillArray[link].show == 1 then DEFAULT_CHAT_FRAME:AddMessage( "Skill: ".. link.." is now AUTO SHOWN"); end
		--if SkillArray[link].show == 2 then DEFAULT_CHAT_FRAME:AddMessage( "Skill: ".. link.." is now SHOW ALWAYS"); end
		--DEFAULT_CHAT_FRAME:AddMessage( "CLICK: ".. link)
		
	end

		-- ==== Update Data Window ====
	function SkillWatcherDetails_UpdateWindow()  
		if (SkillWatcherFrameDetails) then
		if SkillWatcherConfig_DetailWindowON == 1 then
			SkillWatcherFrameDetails:Show()
		else  		
			SkillWatcherFrameDetails:Hide()
		end
		end
	end


	-- ==== Update Data Window ====
	function SkillWatcher_UpdateWindow()    
	
	
		textThing = ""
		frameHeight = 11
		
		--number of skills on character
		local prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions();
		for i=1, 6 do
			skillName = ""
			if i == 1 and prof1 then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, return6, return7 = GetProfessionInfo(prof1)
				skillName = name
				skillID = firstAid
			end
			if i == 2 and prof2 then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, return6, return7 = GetProfessionInfo(prof2)
				skillName = name
				skillID = firstAid
			end
			if i == 3 and archaeology then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, return6, return7 = GetProfessionInfo(archaeology)
				skillName = name
				skillID = firstAid
			end
			if i == 4 and fishing then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, return6, return7 = GetProfessionInfo(fishing)
				skillName = name
				skillID = firstAid
			end
			if i == 5 and cooking then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, return6, return7 = GetProfessionInfo(cooking)
				skillName = name
				skillID = firstAid
			end
			if i == 6 and firstAid then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, return6, return7 = GetProfessionInfo(firstAid)
				skillName = name
				skillID = firstAid
			end

			if skillName ~= "" then
				--make sure skill array is good
				if not (SkillArray[skillName]) then
					--table for holding skill levels
					SkillArray[skillName] = {
						["current"] = GetSkillValue(skillName),
						["max"] = GetSkillMaxValue(skillName),
						["old"] = 0,
						["color"] = "00ffffff",
						["show"] = 1
						};
				end
				--textThing = textThing .. skillID .. " " .. name .. " " .. skillLevel .. " " .. maxSkillLevel .. " " .. numAbilities .. " " .. return6 .. " " .. return7 .. "|r\n"
			
					
			--display only skills not at 0 or maxed
			if (GetSkillValue(skillName) > 0 and GetSkillValue(skillName) < GetSkillMaxValue(skillName)) or SkillArray[skillName].show == 2 or SkillWatcherConfig_DetailWindowON == 1 then
			
				
				-- notifier instafix
				
				if SkillArray[skillName].color == "ff00ff00" then SkillArray[skillName].color = "ffffffff"; end
				
				-- Training notifier
				if SkillArray[skillName].max == 75 and SkillArray[skillName].current > 50 then SkillArray[skillName].color = "ff00ff00"; end
				if SkillArray[skillName].max == 150 and SkillArray[skillName].current > 125 then SkillArray[skillName].color = "ff00ff00"; end
				if SkillArray[skillName].max == 225 and SkillArray[skillName].current > 200 then SkillArray[skillName].color = "ff00ff00"; end
				if SkillArray[skillName].max == 300 and SkillArray[skillName].current > 275 then SkillArray[skillName].color = "ff00ff00"; end
				
				--Really bad method to handle color fading
				if SkillArray[skillName].color == "fffff8f8" then SkillArray[skillName].color = "ffffffff"; end				
				if SkillArray[skillName].color == "ffffefef" then SkillArray[skillName].color = "fffff8f8"; end
				if SkillArray[skillName].color == "ffffe8e8" then SkillArray[skillName].color = "ffffefef"; end
				if SkillArray[skillName].color == "ffffdfdf" then SkillArray[skillName].color = "ffffe8e8"; end
				if SkillArray[skillName].color == "ffffd8d8" then SkillArray[skillName].color = "ffffdfdf"; end
				if SkillArray[skillName].color == "ffffcfcf" then SkillArray[skillName].color = "ffffd8d8"; end
				if SkillArray[skillName].color == "ffffc8c8" then SkillArray[skillName].color = "ffffcfcf"; end
				if SkillArray[skillName].color == "ffffbfbf" then SkillArray[skillName].color = "ffffc8c8"; end
				if SkillArray[skillName].color == "ffffb8b8" then SkillArray[skillName].color = "ffffbfbf"; end
				if SkillArray[skillName].color == "ffffafaf" then SkillArray[skillName].color = "ffffb8b8"; end
				if SkillArray[skillName].color == "ffffa8a8" then SkillArray[skillName].color = "ffffafaf"; end
				if SkillArray[skillName].color == "ffff9f9f" then SkillArray[skillName].color = "ffffa8a8"; end
				if SkillArray[skillName].color == "ffff9898" then SkillArray[skillName].color = "ffff9f9f"; end
				if SkillArray[skillName].color == "ffff8f8f" then SkillArray[skillName].color = "ffff9898"; end
				if SkillArray[skillName].color == "ffff8888" then SkillArray[skillName].color = "ffff8f8f"; end
				if SkillArray[skillName].color == "ffff7f7f" then SkillArray[skillName].color = "ffff8888"; end
				if SkillArray[skillName].color == "ffff7878" then SkillArray[skillName].color = "ffff7f7f"; end
				if SkillArray[skillName].color == "ffff6f6f" then SkillArray[skillName].color = "ffff7878"; end
				if SkillArray[skillName].color == "ffff6868" then SkillArray[skillName].color = "ffff6f6f"; end
				if SkillArray[skillName].color == "ffff5f5f" then SkillArray[skillName].color = "ffff6868"; end
				if SkillArray[skillName].color == "ffff5858" then SkillArray[skillName].color = "ffff5f5f"; end
				if SkillArray[skillName].color == "ffff4f4f" then SkillArray[skillName].color = "ffff5858"; end
				if SkillArray[skillName].color == "ffff4848" then SkillArray[skillName].color = "ffff4f4f"; end
				if SkillArray[skillName].color == "ffff3f3f" then SkillArray[skillName].color = "ffff4848"; end
				if SkillArray[skillName].color == "ffff3838" then SkillArray[skillName].color = "ffff3f3f"; end
				if SkillArray[skillName].color == "ffff2f2f" then SkillArray[skillName].color = "ffff3838"; end
				if SkillArray[skillName].color == "ffff2828" then SkillArray[skillName].color = "ffff2f2f"; end
				if SkillArray[skillName].color == "ffff1f1f" then SkillArray[skillName].color = "ffff2828"; end
				if SkillArray[skillName].color == "ffff1818" then SkillArray[skillName].color = "ffff1f1f"; end
				if SkillArray[skillName].color == "ffff0f0f" then SkillArray[skillName].color = "ffff1818"; end
				if SkillArray[skillName].color == "ffff0808" then SkillArray[skillName].color = "ffff0f0f"; end
				if SkillArray[skillName].color == "ffff0000" then SkillArray[skillName].color = "ffff0808"; end
								
				SkillArray[skillName].current = GetSkillValue(skillName)
				SkillArray[skillName].max = GetSkillMaxValue(skillName)
				
				--change color, make it "ping" when change detected, so user notices they got an increase!
				if SkillArray[skillName].current > SkillArray[skillName].old then
					SkillArray[skillName].color = "ffff0000"
				end
				SkillArray[skillName].old = SkillArray[skillName].current

				--string-replace..."Two-Handed" to "2-H" ("-" not found!?)
				skillNameMod = skillName
				skillNameMod = skillName.gsub(skillNameMod, "Jewelcrafting", "Jwlcraft")
				skillNameMod = skillName.gsub(skillNameMod, "Blacksmithing", "Blksmith")
				skillNameMod = skillName.gsub(skillNameMod, "Leatherworking", "LtherWkg")
				skillNameMod = skillName.gsub(skillNameMod, "Lockpicking", "LckPick")
				skillNameMod = skillName.gsub(skillNameMod, "Handed", "H")
				skillNameMod = skillName.gsub(skillNameMod, "Two", "2")
				skillNameMod = skillName.gsub(skillNameMod, " ", "") --trim spaces in name
				
				--Format text line for info window
				if SkillArray[skillName].show == 1 or SkillArray[skillName].show == 2 or SkillWatcherConfig_DetailWindowON == 1 then
					if SkillWatcherConfig_DetailWindowON == 1 then
						SkillWatcherFrame:SetWidth(200)
						if SkillArray[skillName].show == 0 then textThing = textThing .. "[HIDDEN]"; end
						if SkillArray[skillName].show == 1 then textThing = textThing .. "[AUTO]"; end
						if SkillArray[skillName].show == 2 then textThing = textThing .. "[SHOWN]"; end
					else
						SkillWatcherFrame:SetWidth(150)
					end
					textThing = textThing .. " |c" .. SkillArray[skillName].color .. skillNameMod .. " " .. GetSkillValue(skillName) .. "/" .. GetSkillMaxValue(skillName) .. "|r\n"
					--frame height determined by font size * lines
					frameHeight = frameHeight + 10
				end
			end
			end
		end
		
		if SkillWatcherConfig_WindowON == 1 then
			SkillWatcherFrame:Show()
		else		
			SkillWatcherFrame:Hide()
		end
		
		--place text in info frame
		if SkillWatcherFrame.text then
		        SkillWatcherFrame.text:SetText(textThing)
		end
		
		--adjust frame height
		SkillWatcherFrame:SetHeight(frameHeight)
		
	end
	
	-- ==== Return Current Skill Level ====
	function GetSkillValue(skill)
		if not skill then
			return 0
		end
		local prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions();
		for i=1, 6 do
			if i == 1 and prof1 then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, return6, return7 = GetProfessionInfo(prof1)
				if name==skill then
					return skillLevel
				end 
			end
			if i == 2 and prof2 then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, return6, return7 = GetProfessionInfo(prof2)
				if name==skill then
					return skillLevel
				end 
			end
			if i == 3 and archaeology then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, return6, return7 = GetProfessionInfo(archaeology)
				if name==skill then
					return skillLevel
				end 
			end
			if i == 4 and fishing then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, return6, return7 = GetProfessionInfo(fishing)
				if name==skill then
					return skillLevel
				end 
			end
			if i == 5 and cooking then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, return6, return7 = GetProfessionInfo(cooking)
				if name==skill then
					return skillLevel
				end 
			end
			if i == 6 and firstAid then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, return6, return7 = GetProfessionInfo(firstAid)
				if name==skill then
					return skillLevel
				end 
			end
		end
		return 0
	end

	-- ==== Return Maximum Skill Level ====
	function GetSkillMaxValue(skill)
		if not skill then
			return 0
		end
		local prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions();
		for i=1, 6 do
			if i == 1 and prof1 then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, return6, return7 = GetProfessionInfo(prof1)
				if name==skill then
					return maxSkillLevel
				end 
			end
			if i == 2 and prof2 then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, return6, return7 = GetProfessionInfo(prof2)
				if name==skill then
					return maxSkillLevel
				end 
			end
			if i == 3 and archaeology then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, return6, return7 = GetProfessionInfo(archaeology)
				if name==skill then
					return maxSkillLevel
				end 
			end
			if i == 4 and fishing then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, return6, return7 = GetProfessionInfo(fishing)
				if name==skill then
					return maxSkillLevel
				end 
			end
			if i == 5 and cooking then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, return6, return7 = GetProfessionInfo(cooking)
				if name==skill then
					return maxSkillLevel
				end 
			end
			if i == 6 and firstAid then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, return6, return7 = GetProfessionInfo(firstAid)
				if name==skill then
					return maxSkillLevel
				end 
			end
		end
		return 0
	end
