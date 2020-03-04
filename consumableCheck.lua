local firstTimeChk = false;
local startTime = 0;
local currentTime = 0;
local elapsedTime = 0;
local expArray = {};
local timeArray = {};
local timeBinMins = 1;
local timeBinning = timeBinMins*60;
local currentBin = 0;
local displayArray = {5,15,30,60,90,120,121,122,123,124,125,126,127,128,129,130,131,132,133};
local displayWarArray = {5,15,30,60,90,120,121,122,123,124,125,126,127,128,129,130,131,132,133};
local TextLineArray = {};


function createFrameConsumable()

	textFrame = CreateFrame("frame","textFrame")
	textFrame:SetBackdrop({
		  bgFile="Interface\\DialogFrame\\UI-DialogBox-Background", 
	})
	textFrame:SetWidth(160)
	textFrame:SetHeight(tonumber(#displayArray+1)*16)
	textFrame:SetPoint("CENTER",UIParent)
	textFrame:EnableMouse(true)
	textFrame:SetMovable(true)
	textFrame:RegisterForDrag("LeftButton")
	textFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
	textFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
	textFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	textFrame:SetFrameStrata("FULLSCREEN_DIALOG")

	TextLineArray[0] = textFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	TextLineArray[0]:SetPoint("TOPLEFT",textFrame,1,0)
	TextLineArray[0]:SetText(string.format("tE,eT"));

	for displayBin, value in pairs(displayArray) do
		if displayBin > 0 then 
			TextLineArray[displayBin] = textFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
			TextLineArray[displayBin]:SetPoint("TOPLEFT",textFrame,1,-15*displayBin)
			TextLineArray[displayBin]:SetText("consumableName");
			
		end
	end

end

function stateFrame(state)

	if state == false then
		textFrame:Hide();
	end

	if state == true then
		textFrame:Show();
	end

end

function updateFrameText(num, line)
	TextLineArray[num]:SetText(line);
end


function checkConsumables(strict)

	local consumablesArrayLong = {}
	-- Long Duration
	consumablesArrayLong["Elixir of the Mongoose"] = 5
	consumablesArrayLong["Elixir of Superior Defense"] = 5
	consumablesArrayLong["Elixir of Fortitude"] = 5
	consumablesArrayLong["Lung Juice Cocktail"] = 1
	
	-- Medium Duration
	local consumablesArrayMedium = {}
	consumablesArrayMedium["Rumsey Rum Black Label"] = 10
	consumablesArrayMedium["Tender Wolf Steak"] = 10
	consumablesArrayMedium["Juju Might"] = 5
	consumablesArrayMedium["Juju Ember"] = 3
	consumablesArrayMedium["Juju Power"] = 5
	
	-- Short Duration
	local consumablesArrayShort = {}
	consumablesArrayShort["Free Action Potion"] = 10
	consumablesArrayShort["Mighty Rage Potion"] = 5
	consumablesArrayShort["Greater Stoneshield Potion"] = 5
	consumablesArrayShort["Restorative Potion"] = 5
	consumablesArrayShort["Magic Resistance Potion"] = 5
	
	-- Area Threat
	local consumablesArrayThreat = {}
	consumablesArrayThreat["Goblin Sapper Charge"] = 5
	--consumablesArrayThreat["Crystal Spire"] = 5
	consumablesArrayThreat["Dragonbreath Chili"] = 5
	consumablesArrayThreat["Oil of Immolation"] = 10
	
	-- Misc
	local consumablesArrayMisc = {}
	--consumablesArrayMisc["Aqual Quintessence"] = 1
	consumablesArrayMisc["Light Shot"] = 200
	consumablesArrayMisc["Sharp Arrow"] = 200
	
	-- Protection pots
	local consumablesArrayProtection = {}
	consumablesArrayProtection["Greater Fire Protection Potion"] = 5
	--consumablesArrayProtection["Greater Arcane Protection Potion"] = 5
	consumablesArrayProtection["Greater Shadow Protection Potion"] = 5
	
	local consumablesArray = {}
	consumablesArray["Long"] = consumablesArrayLong
	consumablesArray["Medium"] = consumablesArrayMedium
	consumablesArray["Short"] = consumablesArrayShort
	consumablesArray["Threat"] = consumablesArrayThreat
	consumablesArray["Misc"] = consumablesArrayMisc
	consumablesArray["Protection"] = consumablesArrayProtection
	--consumablesArray["Ground Scorpok Assay"] = 5
	--consumablesArray["Gift of Arthas"] = 5
	--consumablesArray["Dense Sharpening Stone"] = 5
	--consumablesArray["Flask of the Titans"] = 2
	
	local consumMissingNum = 0;

	for arrayName in pairs (consumablesArray) do
		print("---------- ",arrayName," ----------")
		local array = consumablesArray[arrayName]
		for itemName in pairs (array) do
			local countReq = array[itemName];
			local count = GetItemCount(itemName);
			

			if strict == 0 then
			
				
				if itemName == "Elixir of the Mongoose" then
					count = count + GetItemCount("Elixir of Greater Agility")
					itemName = "Elixir of the Mongoose OR Agility"
				end
				if itemName == "Juju Power" then
					count = count + GetItemCount("Elixir of Giants")
					itemName = "Juju Power (Winterfall E'ko) OR Elixir of Giants"
				end
				if itemName == "Juju Ember" then
					itemName = "Juju Ember (Shardtooth E'ko)"
				end
				if itemName == "Juju Might" then
					count = count + GetItemCount("Winterfall Firewater")
					itemName = "Juju Might (Frostmaul E'ko) OR Winterfall Firewater"
				end
				if itemName == "Rumsey Rum Black Label" then
					count = count + GetItemCount("Gordok Green Grog") + GetItemCount("Rumsey Rum Dark") + GetItemCount("Rumsey Rum")
					itemName = "Rumsey Rum Black Label OR Dark OR regular OR Gordok Green Grog"
				end
				if itemName == "Mighty Rage Potion" then
					count = count + GetItemCount("Great Rage Potion")
					itemName = "Mighty Rage Potion OR Great Rage Potion"
				end
				if itemName == "Greater Shadow Protection Potion" then
					count = count + GetItemCount("Shadow Protection Potion")
					itemName = "Greater Shadow Protection Potion OR regular"
				end
				if itemName == "Greater Fire Protection Potion" then
					count = count + GetItemCount("Fire Protection Potion")
					itemName = "Greater Fire Protection Potion OR regular"
				end
				if itemName == "Tender Wolf Steak" then
					count = count + GetItemCount("Monster Omelet") + GetItemCount("Spiced Chili Crab") + GetItemCount("Spider Sausage") + GetItemCount("Heavy Kodo Stew")
					itemName = "Tender wolf or monster omelet or spiced chili or spider saus or heavy kodo"
				end
				
				
				
				
			end
			
			if consumMissingNum < 20 then
				if count < countReq then
					print("Missing: ", itemName, " :: ", string.format("%d",count),"/",string.format("%d",countReq));
					updateFrameText(tonumber(consumMissingNum), string.format("%s %d/%d",itemName,count,countReq));
					consumMissingNum = consumMissingNum + 1
					if itemName == "Crystal Spire" then
						print("== ", "Yellow Power Crystal", " :: ", string.format("%d",GetItemCount("Yellow Power Crystal")),"/",string.format("%d",10));
						print("== ", "Blue Power Crystal", " :: ", string.format("%d",GetItemCount("Blue Power Crystal")),"/",string.format("%d",10));
					end
					if itemName == "Lung Juice Cocktail" then
						itemName = "Blasted Boar Lung"
						print("== ", itemName, " :: ", string.format("%d",GetItemCount(itemName)),"/",string.format("%d",3));
						itemName = "Scorpok Pincer"
						print("== ", itemName, " :: ", string.format("%d",GetItemCount(itemName)),"/",string.format("%d",2));
						itemName = "Basilisk Brain"
						print("== ", itemName, " :: ", string.format("%d",GetItemCount(itemName)),"/",string.format("%d",1));
					end
				end
			end
		end
	end
end



createFrameConsumable();
SLASH_CONSUMABLES_CHECK1 = "/consumablesCheck";
SlashCmdList["CONSUMABLES_CHECK"] = function(msg)

	if msg == "" then
		checkConsumables(0);
	end


	if msg == "strict" then
		checkConsumables(1);
	end

	if msg == "frame" then
		if isFrameOn == true then

			isFrameOn = false;
			stateFrame(false);
			DEFAULT_CHAT_FRAME:AddMessage("Frame OFF", 1.0, 0.0, 0.0);
		else
			isFrameOn = true;
			stateFrame(true);
			DEFAULT_CHAT_FRAME:AddMessage("Frame ON", 0.0, 1.0, 0.0);
		end
				
	end

	if msg == ""
		then
			DEFAULT_CHAT_FRAME:AddMessage("=============================================", 0.3, 1.0, 0.0);
			DEFAULT_CHAT_FRAME:AddMessage("consumablesCheck information", 0.0, 1.0, 0.0);
			DEFAULT_CHAT_FRAME:AddMessage("/consumablesCheck frame - turn on and off frame window.", 0.0, 1.0, 0.0);
			DEFAULT_CHAT_FRAME:AddMessage("/consumablesCheck strict", 0.0, 1.0, 0.0);
			DEFAULT_CHAT_FRAME:AddMessage("=============================================", 0.3, 1.0, 0.0);
		end

end

local consumablesEv = CreateFrame("Frame") 
consumablesEv:RegisterEvent("ADDON_LOADED")
consumablesEv:SetScript("OnEvent", function (self, event, arg1)

	if event == "ADDON_LOADED" and arg1 == "consumableCheck" then

		--DEFAULT_CHAT_FRAME:AddMessage("ON LOAD", 1.0, 0.0, 0.0);
		if isChatOn == nil then
		isChatOn = false
		end

		if isFrameOn == nil then
		isFrameOn = true
		end

		if isFrameOn == true then
		stateFrame(true)
		else
		stateFrame(false)
		end
	end
end)


