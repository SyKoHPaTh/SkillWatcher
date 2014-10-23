--[[==========================
	Name: SkillWatcher.lua
	Last Updated: 2014 10 15
	Page Version: SkillWatcher.lua  
	==========================]]

--match these variables with versioning in the TOC file
SkillWatcherGameVersion = "WARLORD 6.0.2";
SkillWatcherVersion = "v2.4b";

--[[========================
	Path to file:  WoW/Interface/Addons/SkillWatcher
	Author:  SyKoHPaTh - sykohpath@gmail.com
	==========================
* Version History
*
*		2.4b-	- Split out database into separate file (finally) - should be easier to manually add data now
*					- Added a lot more data (mining, herb) to the database
*						- everything up through PANDA is filled out
*						- includes "guessed at" WARLORDS mining/herb nodes.  Prospecting still empty.
*				- Fix issue with font height.  Previously 10, now 11 (Thanks to "Kru", who uses '12'.  If 11 doesn't work for him, then I'll make 12 official)
*		2.4a-	- Added "Way of the" skills - only appears once you open cooking tab, though!  Some weird variable thing.
*					- these only show if rank < maxrank
*		2.4 -	- update to WARLORD 6.0.2, pre-expansion
*				- Bugfix: "if GetChecked() == 1" should be "if GetChecked()" since it's boolean
*				- Tooltip removed "Requires"
*				- Went ahead and increased the cap to 700
*				- Added show bonus skill.  Skills still hide depending on base value, not base + bonus
*		2.3 -	- updated lockbox info because I wanted to play rogue for 2 minutes
*				-	updated levelup coloring through Pandaria (600)
*				-	if profession is max at capped, show yellow instead of hiding.  Still hide if at XPAC max (600 Pandaria)
*				-	removed that empty line from the display window (finally!!)
*				-	MAXSKILL variable, just make it easier to update
*				-	When skill ready to be "trained", show the level required to train it - THIS IS GUESS sorta
*		2.2 -	- option to lock window to keep it from moving, add Cata and Panda nodes (mining/herbalism)
*		2.1	-	- option to turn off/on the tooltip window thing, bugfix ("Not found!" tooltip thing), bugfix (savedvariables not reading / event)
*		2.0	-	- Update to WRATH 4.0, Window size fix, added Prospecting mats tooltip stuff
*		1.9b-	- Add to tracking: blacksmith and engineering skill for "locked", customizable skills shown through config window
*		1.9a-	- Update to WRATH 3.3.2, added Rogue skill tracking for lockpicking: chests, doors, loot, etc.
*		1.9	-	- added training notifiers
*		1.8 -	- config window
*		1.7	-	- Updated version to WRATH 3.2.0; fixed "long line" bug with long skill names
*		1.6	-	- change level ping color fade
*		1.5	-	- code cleanup, launch, bug fixes
*		1.4	-	- save frame position, tooltip more data
*		1.3	-	- color "ping", tooltip modification
*		1.2	-	- code cleanup
*		1.1	-	- cleaned up frame, cleaned up code
*		1.0	-	- Initial structure

==========================
= Shared Variables:
	1.4	-	SkillWatcherPoint, SkillWatcherX, SkillWatcherY
	1.8	-	SkillWatcherConfig_TooltipMiningON, SkillWatcherConfig_TooltipHerbON, SkillWatcherConfig_WindowON
	1.9b-	SkillArray
	2.1	-	SkillWatcherConfig_TooltipON
	2.2 - 	SkillWatcherConfig_WindowMovable

==========================
= TO DO:

		Add checkbox to include "Way of the" in the window
		Replace color fading procedure with math function
		"Open Profession" button-icons on the window
		Split out files even more:
			init
			basic functions
			slash commands (make more robust, fill out with more info)
			SkillWatcher.lua should be main controller

		Config options
			Skin Selection
			Font Selection/styling
		Save Variables
			background texture
			font selection/styling/size
			text coloring
			Tracking of certain skills
==========================
--]]

-- ======== PRECODE ======== 
	--(code run instantly when file loaded)
	--main purpose is to register processes and variables "before addon load"
	
	--Globals
		local SkillWatcherConfig_defaultTest = 1;
		local SkillWatcherConfig_defaultPoint = "CENTER";
		local SkillWatcherConfig_defaultX = 0;
		local SkillWatcherConfig_defaultY = 0;
		local SkillWatcherConfig_defaultWindowMovable = 1;
		local SkillWatcherConfig_defaultWindowON = 1;
		local SkillWatcherConfig_defaultWindowDetailON = 2;
		local SkillWatcherConfig_defaultTooltipMiningON = 1;
		local SkillWatcherConfig_defaultTooltipHerbON = 1;		
		local SkillWatcherConfig_defaultTooltipON = 1;
		local MAXSKILL = 700; --Warlords, changing it here doesn't change it *everywhere*

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
				if (SkillWatcherConfig_WindowON == 1) then
					DEFAULT_CHAT_FRAME:AddMessage("SkillWatcherConfig_WindowON: YES")
				else
					DEFAULT_CHAT_FRAME:AddMessage("SkillWatcherConfig_WindowON: NO")
				end
				if (SkillWatcherConfig_TooltipMiningON == 1) then
					DEFAULT_CHAT_FRAME:AddMessage("SkillWatcherConfig_TooltipMiningON: YES")
				else
					DEFAULT_CHAT_FRAME:AddMessage("SkillWatcherConfig_TooltipMiningON: NO")
				end
				if (SkillWatcherConfig_TooltipHerbON == 1) then
					DEFAULT_CHAT_FRAME:AddMessage("SkillWatcherConfig_TooltipHerbON: YES")
				else
					DEFAULT_CHAT_FRAME:AddMessage("SkillWatcherConfig_TooltipHerbON: NO")
				end				
				if (SkillWatcherConfig_DetailWindowON == 1) then
					DEFAULT_CHAT_FRAME:AddMessage("SkillWatcherConfig_DetailWindowON: YES")
				else
					DEFAULT_CHAT_FRAME:AddMessage("SkillWatcherConfig_DetailWindowON: NO")
				end
				if (SkillWatcherConfig_TooltipON == 1) then
					DEFAULT_CHAT_FRAME:AddMessage("SkillWatcherConfig_TooltipON: YES")
				else
					DEFAULT_CHAT_FRAME:AddMessage("SkillWatcherConfig_TooltipON: NO")
				end	
				if (SkillWatcherConfig_WindowMovable == 1) then
					DEFAULT_CHAT_FRAME:AddMessage("SkillWatcherConfig_WindowMovable: YES")
				else
					DEFAULT_CHAT_FRAME:AddMessage("SkillWatcherConfig_WindowMovable: NO")
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
	--replaces the game default tooltip
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
					
					
				if skillText[i] == "Herbalism" and SkillWatcherConfig_TooltipHerbON == 1 then flag = 1; end
				if skillText[i] == "Mining" and SkillWatcherConfig_TooltipMiningON == 1 then flag = 1; end
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

			-- load info from database
			if skillWatcher_data[skillText[1]] ~= nil then
				Horange = skillWatcher_data[skillText[1]]["min"];
				Hyellow = skillWatcher_data[skillText[1]]["low"];
				Hgreen = skillWatcher_data[skillText[1]]["high"];
				Hgrey = skillWatcher_data[skillText[1]]["max"];
				skillText[4] = skillWatcher_data[skillText[1]]["text"];
			end

			--Read "require" off node
			if skillText[2] == "Herbalism" then
				--herbalism
				if GetSkillValue("Herbalism") < MAXSKILL then 
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

			elseif skillText[2] == "Mining" then
				--mining
				if GetSkillValue("Mining") < MAXSKILL then 
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
				if GetSkillValue("Lockpicking") < MAXSKILL then
					skillText[3] = "Level:" .. GetSkillValue("Lockpicking") .. " (Required: " ..  Hgrey .. ")"
				else
					--hide the skill line of text if at maximum skill
					skillText[3] = "NONE"
				end
				--determine node "difficulty"
				chance = 101  --can't harvest
				if GetSkillValue("Lockpicking") >= Hgrey then chance = 0; end
				if GetSkillValue("Lockpicking") < Hgrey then chance = 101; end
				--Handle professions that effect this skill: Blacksmithing, Engineering
				if GetSkillValue("Engineering") > 1 then
					skillText[4] = "(SkillWatcher: Not in database! 'Engineering')";
					if Horange < 150 then skillText[4] = "Use [Small Seaforium Charge]"; end
					if Horange < 250 then skillText[4] = "Use [Large Seaforium Charge]"; end
					if Horange < 300 then skillText[4] = "Use [Powerful Seaforim Charge]"; end
					if Horange < 350 then skillText[4] = "Use [Elemental Seaforium Charge]"; end
				end
				if GetSkillValue("Blacksmithing") > 1 then
					skillText[4] = "(SkillWatcher: Not in database! 'Blacksmithing')";
					if Horange < 25 then skillText[4] = "Use [Silver Skeleton Key]"; end
					if Horange < 125 then skillText[4] = "Use [Golden Skeleton Key]"; end
					if Horange < 200 then skillText[4] = "Use [Truesilver Skeleton Key]"; end
					if Horange < 300 then skillText[4] = "Use [Arcanite Skeleton Key]"; end
					if Horange < 375 then skillText[4] = "Use [Cobalt Skeleton Key]"; end
					if Horange < 430 then skillText[4] = "Use [Titanium Skeleton Key]"; end
				end
				if GetSkillValue("Blacksmithing") > 1 and GetSkillValue("Engineering") > 1 then
					--for the crazy people that have BOTH Blacksmithing and Engineering!
					skillText[4] = "(SkillWatcher: Not in database! 'Blacksmithing' and 'Engineering')";
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
				skillText[4] = "(SkillWatcher: Not in database! 'Prospectable')";
				-- load info from database
				if skillWatcher_data_prospect[skillText[1]] ~= nil then
					skillText[4] = skillWatcher_data_prospect[skillText[1]]["text"];
				end
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
			if TestCheckButton:GetChecked() then
				SkillWatcherConfig_defaultTest = 1
			else
				SkillWatcherConfig_defaultTest = 2
			end
			
			if TooltipMiningCheckButton:GetChecked() then
				SkillWatcherConfig_TooltipMiningON = 1
			else
				SkillWatcherConfig_TooltipMiningON = 2
			end
			
			if TooltipHerbCheckButton:GetChecked() then
				SkillWatcherConfig_TooltipHerbON = 1
			else
				SkillWatcherConfig_TooltipHerbON = 2
			end
			
			if WindowCheckButton:GetChecked() then
				SkillWatcherConfig_WindowON = 1
			else
				SkillWatcherConfig_WindowON = 2
			end

			if TooltipCheckButton:GetChecked() then
				SkillWatcherConfig_TooltipON = 1
			else
				SkillWatcherConfig_TooltipON = 2
			end

			if WindowMovableCheckButton:GetChecked() then
				--show checkmark to lock it
				SkillWatcherConfig_WindowMovable = 2
			else
				SkillWatcherConfig_WindowMovable = 1
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

			if SkillWatcherConfig_WindowMovable == 1 then
				WindowMovableCheckButton:SetChecked(0)
			else
				WindowMovableCheckButton:SetChecked(1)
			end

		end
		SkillWatcher.panel.default = function(self) 
			--self.originalValue = DEFAULT VALUE
			SkillWatcherConfig_WindowON = SkillWatcherConfig_defaultWindowON
			SkillWatcherConfig_DetailWindowON = SkillWatcherConfig_defaultDetailWindowON
			SkillWatcherConfig_TooltipMiningON = SkillWatcherConfig_defaultTooltipMiningON
			SkillWatcherConfig_TooltipHerbON = SkillWatcherConfig_defaultTooltipHerbON
			SkillWatcherConfig_TooltipON = SkillWatcherConfig_defaultTooltipON
			SkillWatcherConfig_WindowMovable = SkillWatcherConfig_defaultWindowMovable

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
			if SkillWatcherConfig_WindowMovable == 1 then
				WindowMovableCheckButton:SetChecked(0)
			else
				WindowMovableCheckButton:SetChecked(1)
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

		TestCheckButton:SetScript("OnClick", 
  			function()
				if (TestCheckButton:GetChecked()) then
					DEFAULT_CHAT_FRAME:AddMessage("testcheckbutton:getchecked TRUE")
				else
					DEFAULT_CHAT_FRAME:AddMessage("testcheckbutton:getchecked FALSE")
				end

  			end);		

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
		WindowMovableCheckButton = CreateFrame("CheckButton", "TestCheckButton", SkillWatcher.panel, "OptionsCheckButtonTemplate")
		WindowMovableCheckButton:SetWidth("25")
		WindowMovableCheckButton:SetHeight("25")
		WindowMovableCheckButton:SetPoint("TOPLEFT", 16, -175)
		WindowMovableCheckButton:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
		WindowMovableCheckButton:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
		WindowMovableCheckButton:SetHighlightTexture("Interface\\Buttons\\UI-CheckBox-Highlight", "ADD")
		WindowMovableCheckButton:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
		WindowMovableCheckButton:Show()
		--text
		SkillWatcherFrame.textSub = SkillWatcher.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		SkillWatcherFrame.textSub:SetPoint("TOPLEFT", 45, -181)
		SkillWatcherFrame.textSub:SetText("Lock the SkillWatcher window")
		if SkillWatcherConfig_WindowMovable == 1 then
			WindowMovableCheckButton:SetChecked(0)
		else
			WindowMovableCheckButton:SetChecked(1)
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
			if SkillWatcherConfig_WindowMovable ~= 1 and SkillWatcherConfig_WindowMovable ~= 2 then
				DEFAULT_CHAT_FRAME:AddMessage("Move Window - default")
				SkillWatcherConfig_WindowMovable = SkillWatcherConfig_defaultWindowMovable
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
			if SkillWatcherConfig_WindowMovable == 1 then
				WindowMovableCheckButton:SetChecked(0)
			else
				WindowMovableCheckButton:SetChecked(1)
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
			SkillWatcherFrame:SetScript("OnMouseDown", function() if SkillWatcherConfig_WindowMovable == 1 then SkillWatcherFrame:StartMoving(); end; end)
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
			frameHeight = 0;
			
			--setup us the professions
				--bad programmer doesn't put this into a function
			local prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions();
			for i=1, 6 do
				skillName = ""
				if i == 1 and prof1 then
					local name, icon, skillLevel, maxSkillLevel, numAbilities, abilityOffset, skillIdNum, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(prof1)
					skillName = name
				end
				if i == 2 and prof2 then
					local name, icon, skillLevel, maxSkillLevel, numAbilities, abilityOffset, skillIdNum, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(prof2)
					skillName = name
				end
				if i == 3 and archaeology then
					local name, icon, skillLevel, maxSkillLevel, numAbilities, abilityOffset, skillIdNum, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(archaeology)
					skillName = name
				end
				if i == 4 and fishing then
					local name, icon, skillLevel, maxSkillLevel, numAbilities, abilityOffset, skillIdNum, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(fishing)
					skillName = name
				end
				if i == 5 and cooking then
					local name, icon, skillLevel, maxSkillLevel, numAbilities, abilityOffset, skillIdNum, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(cooking)
					skillName = name
				end
				if i == 6 and firstAid then
					local name, icon, skillLevel, maxSkillLevel, numAbilities, abilityOffset, skillIdNum, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(firstAid)
					skillName = name
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
					frameHeight = frameHeight + 11
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
	
		local cookingText = ""
		local cookingSize = 0
	
		textThing = ""
		frameHeight = 0
		
		--number of skills on character
		local prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions();
		for i=1, 6 do
			skillName = ""
			if i == 1 and prof1 then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, abilityOffset, skillIdNum, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(prof1)
				skillName = name
				bonus = skillModifier
			end
			if i == 2 and prof2 then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, abilityOffset, skillIdNum, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(prof2)
				skillName = name
				bonus = skillModifier
			end
			if i == 3 and archaeology then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, abilityOffset, skillIdNum, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(archaeology)
				skillName = name
				bonus = skillModifier
			end
			if i == 4 and fishing then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, abilityOffset, skillIdNum, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(fishing)
				skillName = name
				bonus = skillModifier
			end
			if i == 5 and cooking then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, abilityOffset, skillIdNum, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(cooking)
				skillName = name
				bonus = skillModifier

				-- Pandaria "Way of the" are actually recipes!  so we need to get that info since they are "skills" we need to watch

					-- skillName, skillType, numAvailable, isExpanded, serviceType, numSkillUps, indentLevel, showProgressBar, currentRank, maxRank, startingRank = GetTradeSkillInfo(index)
				local cookingWayOfThe = { 
					['Way of the Brew'] =    125589,
					['Way of the Grill'] =   124694,
					['Way of the Oven'] =    125588,
					['Way of the Pot'] =     125586,
					['Way of the Steamer'] = 125587,
					['Way of the Wok'] =     125584,
				}

				for j = 1,5000 do
					local tradeName,tradeType = GetTradeSkillInfo(j)
					local rank,maxrank = select(9,GetTradeSkillInfo(j))

					if tradeName then
						--DEFAULT_CHAT_FRAME:AddMessage(" | " .. j .. tradeName .. " is rank " .. rank .. "/" .. maxrank)
					end

					if tradeName and tradeType=="subheader" then --Cooking Masteries
						for cookingName, id in pairs(cookingWayOfThe) do
							local name = GetSpellInfo(id) --local name

							if tradeName == name and rank < maxrank and rank > 0 then
								cookingName = skillName.gsub(cookingName, "Way of the ", "")
								cookingText = cookingText .. " * " .. cookingName .. " " .. rank .. "/" .. maxrank .. "|r\n"
								cookingSize = cookingSize + 11
								break
							end
						end
					end
				end


			end
			if i == 6 and firstAid then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, abilityOffset, skillIdNum, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(firstAid)
				skillName = name
				bonus = skillModifier
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
				--textThing = textThing .. " " .. name .. " " .. skillLevel .. " " .. maxSkillLevel .. " " .. numAbilities .. " " .. return6 .. " " .. return7 .. "|r\n"
			
					
			--display only skills not at 0 or maxed
			if (GetSkillValue(skillName) > 0 and GetSkillValue(skillName) < MAXSKILL) or SkillArray[skillName].show == 2 or SkillWatcherConfig_DetailWindowON == 1 then
			
				
				-- notifier instafix
				if SkillArray[skillName].color == "ff00ff00" then SkillArray[skillName].color = "ffffffff"; end
				
				-- Training notifier
				skillLevelReq = 0
				if SkillArray[skillName].max == 75 and SkillArray[skillName].current >= 50 then SkillArray[skillName].color = "ff00ff00"; skillLevelReq=5; end
				if SkillArray[skillName].max == 150 and SkillArray[skillName].current >= 125 then SkillArray[skillName].color = "ff00ff00"; skillLevelReq=10; end
				if SkillArray[skillName].max == 225 and SkillArray[skillName].current >= 200 then SkillArray[skillName].color = "ff00ff00"; skillLevelReq=25; end
				if SkillArray[skillName].max == 300 and SkillArray[skillName].current >= 275 then SkillArray[skillName].color = "ff00ff00"; skillLevelReq=40; end
				if SkillArray[skillName].max == 375 and SkillArray[skillName].current >= 350 then SkillArray[skillName].color = "ff00ff00"; skillLevelReq=55; end
				if SkillArray[skillName].max == 450 and SkillArray[skillName].current >= 425 then SkillArray[skillName].color = "ff00ff00"; skillLevelReq=75; end
				if SkillArray[skillName].max == 525 and SkillArray[skillName].current >= 500 then SkillArray[skillName].color = "ff00ff00"; skillLevelReq=85; end
				if SkillArray[skillName].max == 700 and SkillArray[skillName].current >= 575 then SkillArray[skillName].color = "ff00ff00"; skillLevelReq=90; end

				-- capped notified (less than expansion max)
				if(GetSkillValue(skillName) == GetSkillMaxValue(skillName)) then
					SkillArray[skillName].color = "00ffff00";
				end
				
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
					textThing = textThing .. " |c" .. SkillArray[skillName].color .. skillNameMod .. " " .. GetSkillValue(skillName)
					if(bonus > 0) then
						textThing = textThing .. "|cff00ff00+" .. bonus .. "|c" .. SkillArray[skillName].color
					end
					textThing = textThing .. "/" .. GetSkillMaxValue(skillName)

						--level training caps
					if skillLevelReq > 0 then
						textThing = textThing .. " (" .. skillLevelReq .. ")"
					end
					textThing = textThing .. "|r\n"
					if cookingText and cookingText ~= "" then
						textThing = textThing .. cookingText
						frameHeight = frameHeight + cookingSize
						-- reset vars so they don't show up again
						cookingText = ""
						cookingSize = 0
					end

					--frame height determined by font size * lines
					frameHeight = frameHeight + 11
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
		if skill=='Lockpicking' then
			return UnitLevel("player");
		end
		local prof1, prof2, archaeology, fishing, cooking, firstAid = GetProfessions();
		for i=1, 6 do

--name, texture, rank, maxRank, numSpells, spelloffset, skillLine, rankModifier, specializationIndex, specializationOffset = GetProfessionInfo(index)			
			if i == 1 and prof1 then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, abilityOffset, skillIdNum, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(prof1)
				if name==skill then
					return skillLevel
				end 
			end
			if i == 2 and prof2 then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, abilityOffset, skillIdNum, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(prof2)
				if name==skill then
					return skillLevel
				end 
			end
			if i == 3 and archaeology then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, abilityOffset, skillIdNum, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(archaeology)
				if name==skill then
					return skillLevel
				end 
			end
			if i == 4 and fishing then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, abilityOffset, skillIdNum, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(fishing)
				if name==skill then
					return skillLevel
				end 
			end
			if i == 5 and cooking then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, abilityOffset, skillIdNum, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(cooking)
				if name==skill then
					return skillLevel
				end 
			end
			if i == 6 and firstAid then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, abilityOffset, skillIdNum, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(firstAid)
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
				local name, icon, skillLevel, maxSkillLevel, numAbilities, abilityOffset, skillIdNum, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(prof1)
				if name==skill then
					return maxSkillLevel
				end 
			end
			if i == 2 and prof2 then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, abilityOffset, skillIdNum, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(prof2)
				if name==skill then
					return maxSkillLevel
				end 
			end
			if i == 3 and archaeology then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, abilityOffset, skillIdNum, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(archaeology)
				if name==skill then
					return maxSkillLevel
				end 
			end
			if i == 4 and fishing then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, abilityOffset, skillIdNum, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(fishing)
				if name==skill then
					return maxSkillLevel
				end 
			end
			if i == 5 and cooking then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, abilityOffset, skillIdNum, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(cooking)
				if name==skill then
					return maxSkillLevel
				end 
			end
			if i == 6 and firstAid then
				local name, icon, skillLevel, maxSkillLevel, numAbilities, abilityOffset, skillIdNum, skillModifier, specializationIndex, specializationOffset = GetProfessionInfo(firstAid)
				if name==skill then
					return maxSkillLevel
				end 
			end
		end
		return 0
	end