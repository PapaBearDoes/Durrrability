-- Init This File --
local me, ns = ...
local Durrr = LibStub("LibInit"):NewAddon(ns, me, true, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
local L = Durrr:GetLocale()
-- End Init This File --

-- Constants --
local _G = getfenv(0)
local DurrrConfig = LibStub("AceConfig-3.0")
local DurrrConfigDialog = LibStub("AceConfigDialog-3.0")
local DurrrDB = LibStub("AceDB-3.0")
local DurrrDBOptions = LibStub("AceDBOptions-3.0")
local DurrrDialog = LibStub("LibDialog-1.0")
local DLDB = LibStub("LibDataBroker-1.1")
-- End Constants --

-- Defaults --
local slots = {
  {0, 0, 0, "Head", L["Head"], 0},
  {0, 0, 0, "Neck", L["Neck"], 0},
	{0, 0, 0, "Shoulder", L["Shoulder"], 0},
	{0, 0, 0, "Back", L["Back"], 0},
	{0, 0, 0, "Chest", L["Chest"], 0},
	{0, 0, 0, "Wrist", L["Wrist"], 0},
	{0, 0, 0, "Hands", L["Hands"], 0},
	{0, 0, 0, "Waist", L["Waist"], 0},
	{0, 0, 0, "Legs", L["Legs"], 0},
	{0, 0, 0, "Feet", L["Feet"], 0},
	{0, 0, 0, "MainHand", L["MainHand"], 0},
	{0, 0, 0, "SecondaryHand", L["SecondaryHand"], 0},
}

local repairIconCoords = {0.28125, 0.5625, 0, 0.5625}
local guildRepairIconCoords = {0.5625, 0.84375, 0, 0.5625}

local hiddenFrame = CreateFrame("GameTooltip")
hiddenFrame:SetOwner(WorldFrame, "ANCHOR_NONE")

local repairAllCost, canRepair

local ID = 6
local SLOT = 4
local NAME = 5
local VAL = 1
local MAX = 2
local COST = 3

local bagsCost = 0
local bagsPercent = 0

local combatState = false
local merchantState = false
local request = true

local profileDB
local DurrrDBDefaults = {
  profile = {
    showDetails = true,
    showBags = true,
    updateInCombat = false,
    repairFromGuild = true,
    repairFromGuildOnly = false,
    repairThreshold = 4,
    showPopup = true,
    repairType = 1,
    alwaysAsk = false,
    warntoRepair = true,
    warnThreshold = 65,
  },
}
-- End Defaults --

-- Options --
Durrr.options = {
  type = "group",
  name = "Durrrability",
  args = {
    general = {
      order = 1,
      type = "group",
      name = L["GeneralSettings"],
      cmdInline = true,
      args = {
        separator1 = {
          type = "header",
          name = L["DisplayOptions"],
          order = 1,
        },
        details = {
          order = 2,
          type = "toggle",
          name = L["ShowEachItem"],
          desc = L["ShowAllItemsToggle"],
          get = function()
            return profileDB.showDetails
          end,
          set = function(key, value)
            profileDB.showDetails = value
          end,
        },
        bags = {
          order = 3,
          type = "toggle",
          name = L["ShowBags"],
          desc = L["ShowBagsToggle"],
          get = function()
            return profileDB.showBags
          end,
          set = function(key, value)
            profileDB.showBags = value
          end,
        },
        combat = {
          order = 4,
          type = "toggle",
          name = L["InCombatUpdate"],
          desc = L["InCombatToggle"],
          get = function()
            return profileDB.updateInCombat
          end,
          set = function(key, value)
            profileDB.updateInCombat = value
          end,
        },
        separator3 = {
          type = "header",
          name = L["RepOpts"],
          order = 5,
        },
        factionThreshold = {
					order = 6,
					type = "select",
					style = "dropdown",
					name = L["MinRep"],
					desc = L["MinRepLevel"],
					get = function()
						return profileDB.repairThreshold
					end,
					set = function(key, value)
						profileDB.repairThreshold = value
					end,
					values = function()
						return {
							[4] = _G["FACTION_STANDING_LABEL4"],
							[5] = _G["FACTION_STANDING_LABEL5"],
							[6] = _G["FACTION_STANDING_LABEL6"],
							[7] = _G["FACTION_STANDING_LABEL7"],
							[8] = _G["FACTION_STANDING_LABEL8"],
						}
					end,
					disabled = function()
						return profileDB.repairType == 0
					end,
				},
				askEverywhere = {
					order = 7,
					type = "toggle",
          width = "full",
					name = L["AskIfLower"],
					desc = L["LowRepConfirmPop"],
					get = function()
						return profileDB.alwaysAsk
					end,
					set = function(key, value)
						profileDB.alwaysAsk = value
					end,
					disabled = function()
						return profileDB.repairType == 0
					end,
				},
        separator2 = {
          type = "header",
          name = L["RepairOpts"],
          order = 8,
        },
        repairType = {
          order = 9,
          type = "select",
          style = "dropdown",
          name = L["RepairType"],
          desc = L["VendorRepairQuestion"],
          get = function()
            return profileDB.repairType
          end,
          set = function(key, value)
            profileDB.repairType = value
            Durrr:UpdateIcon()
          end,
          values = function()
            return {
              [0] = L["DoNothing"],
              [1] = L["AutoRepair"],
              [2] = L["Ask"],
            }
          end,
        },
        repairGuild = {
          order = 10,
          type = "toggle",
          width = "full",
          name = L["UseGuildFunds"],
          desc = L["GuildFundsToggle"],
          get = function()
            return profileDB.repairFromGuild
          end,
          set = function(key, value)
            profileDB.repairFromGuild = value
            Durrr:UpdateIcon()
          end,
          disabled = function()
            return not (profileDB.repairType == 1)
          end,
        },
        repairGuildOnly = {
          order = 11,
          type = "toggle",
          width = "full",
          name = L["OnlyGuildFunds"],
          desc = L["NoGuildGoldToggle"],
          get = function()
            return profileDB.repairFromGuildOnly
          end,
          set = function(key, value)
            profileDB.repairFromGuildOnly = value
          end,
          disabled = function()
            return ( profileDB.repairFromGuild == false or (not (profileDB.repairType == 1)) )
          end,
        },
				separator4 = {
					type = "header",
					name = L["WarningOpts"],
					order = 12,
				},
				warn = {
					order = 13,
					type = "toggle",
					name = L["CityWarn"],
					desc = L["CityWarnToggle"],
					get = function()
						return profileDB.warntoRepair
					end,
					set = function(key, value)
						profileDB.warntoRepair = value
						if (value) then
							Durrr:RegisterEvent("PLAYER_UPDATE_RESTING", "OnUpdateResting")
						else
							Durrr:UnregisterEvent("PLAYER_UPDATE_RESTING")
						end
					end,
				},
				warnThreshold = {
					order = 14,
					type = "range",
					name = L["WarnThreshold"],
					desc = L["WarnMax"],
					min = 0, max = 100, step = 1,
					get = function()
						return profileDB.warnThreshold
					end,
					set = function(key, value)
						profileDB.warnThreshold = value
					end,
        },
      },
    },
  },
}

function Durrr:SetupOptions()
  Durrr.options.args.profile = DurrrDBOptions:GetOptionsTable(Durrr.db)
  Durrr.options.args.profile.order = -2

  DurrrConfig:RegisterOptionsTable("Durrrability", Durrr.options, nil)

  Durrr.optionsFrames = {}
  Durrr.optionsFrames.general = DurrrConfigDialog:AddToBlizOptions("Durrrability", nil, nil, "general")
  Durrr.optionsFrames.profile = DurrrConfigDialog:AddToBlizOptions("Durrrability", L["Profiles"], "Durrrability", "profile")
end
-- End Options --

-- Init Things --
function Durrr:OnInitialize()
  Durrr.db = DurrrDB:New("DurrrabilityDB", DurrrDBDefaults, true)
  if not Durrr.db then
    print("Error: Database not loaded correctly. Exit WoW and delete Durrrability.lua found in your SavedVariables folder")
  end

  Durrr.db.RegisterCallback(Durrr, "OnProfileChanged", "OnProfileChanged")
  Durrr.db.RegisterCallback(Durrr, "OnProfileCopied", "OnProfileChanged")
  Durrr.db.RegisterCallback(Durrr, "OnProfileReset", "OnProfileChanged")

  profileDB = Durrr.db.profile
  Durrr:SetupOptions()

  local index, item
  for index, item in pairs(slots) do
    slots[index][ID] = GetInventorySlotInfo(item[SLOT] .. "Slot")
  end

  Durrr:CreateDialogs()

  Durrr:RegisterEvent("PLAYER_DEAD", "ScheduleUpdate")
	Durrr:RegisterEvent("PLAYER_UNGHOST", "ScheduleUpdate")
	Durrr:RegisterEvent("UPDATE_INVENTORY_DURABILITY", "ScheduleUpdate")
	Durrr:RegisterEvent("PLAYER_REGEN_ENABLED", "OnRegenEnable")
	Durrr:RegisterEvent("PLAYER_REGEN_DISABLED", "OnRegenDisable")
	Durrr:RegisterEvent("MERCHANT_SHOW", "OnMerchantShow")
	Durrr:RegisterEvent("MERCHANT_CLOSED", "OnMerchantClose")

  if (profileDB.warntoRepair) then
    Durrr:RegisterEvent("PLAYER_UPDATE_RESTING", "OnUpdateResting")
    Durrr:ScheduleTimer("OnUpdateResting", 5)
  end

  Durrr:UpdateIcon()
  Durrr:ScheduleUpdate()
end

function Durrr:OnEnable()
  Durrr:ScheduleRepeatingTimer("MainUpdate", 1)
end
-- End Init Things --

-- Do LDB object --
DurrrLDB = DLDB:NewDataObject("Durrrability", {
  type = "data source",
  label = L["Durability"],
  text = "",
  icon = "Interface\\MerchantFrame\\UI-Merchant-RepairIcons",
  iconCoords = repairIconCoords,
  OnClick = function(frame, click)
    if click == "RightButton" then
      Durrr:ShowConfig()
    end
    Durrr:MainUpdate()
  end,
  OnTooltipShow = function(tooltip)
    if not tooltip or not tooltip.AddLine then return end

    tooltip:AddLine(L["AddonName"] .. " " .. GetAddOnMetadata("Durrrability", "Version"))

    local totalcost, percent, percentmin  = Durrr:GetRepairData()
    if totalcost <= 0 then
      tooltip:AddLine(" ")
      tooltip:AddLine(L["NoBroke"], 0, 1, 0)
    else
      if profileDB.showDetails then
        tooltip:AddLine(" ")
        for index, item in pairs(slots) do
          if item[MAX] > 0 and item[VAL] < item[MAX] then
            local p = item[VAL] / item[MAX]
            local r, g, b = Durrr:GetThresholdColor(p)

            tooltip:AddDoubleLine(string.format("%d%%  |cFFFFFF00%s|t", p * 100, item[NAME]), Durrr:CopperToString(math.floor(item[COST])), r, g, b, 1, 1, 1)
          end
        end
        if profileDB.showBags and (bagCost > 0) then
          local r, g, b = Durrr:GetThresholdColor(bagPercent)

          tooltip:AddDoubleLine(string.format("%d%%  |cFFFFFF00Bags|t", bagPercent * 100), Durrr:CopperToString(math.floor(bagCost)), r, g, b, 1, 1, 1)
        end
      end

      tooltip:AddLine(" ")

      local r, g, b = Durrr:GetThresholdColor(percent)
			tooltip:AddDoubleLine("|cFFFFFFFF"..L["Average"].." :", string.format("%d%%", percent * 100), 1, 1, 1, r, g, b)
      local r, g, b = Durrr:GetThresholdColor(percentmin)
      tooltip:AddDoubleLine("|cFFFFFFFF"..L["Lowest"].." :", string.format("%d%%", percentmin * 100), 1, 1, 1, r, g, b)

      tooltip:AddLine(" ")
			tooltip:AddLine("|cFFFFFFFF"..L["RepCost"])
			tooltip:AddDoubleLine("|cFFFFFF00".._G["FACTION_STANDING_LABEL4"], Durrr:CopperToString(math.floor(totalcost)))
			tooltip:AddDoubleLine("|cFFAAFF00".._G["FACTION_STANDING_LABEL5"], Durrr:CopperToString(math.floor(totalcost*0.95)))
			tooltip:AddDoubleLine("|cFF55FF00".._G["FACTION_STANDING_LABEL6"], Durrr:CopperToString(math.floor(totalcost*0.90)))
			tooltip:AddDoubleLine("|cFF00FF00".._G["FACTION_STANDING_LABEL7"], Durrr:CopperToString(math.floor(totalcost*0.85)))
			tooltip:AddDoubleLine("|cFF00FFAA".._G["FACTION_STANDING_LABEL8"], Durrr:CopperToString(math.floor(totalcost*0.80)))
    end

    tooltip:AddLine(" ")
    local rightClick = ("|cffeda55f" .. L["RightClick"] .. "|r " .. L["RightToolTip"])
    tooltip:AddLine(rightClick)
  end,
})
-- End LDB object --

-- LDB Update --
function Durrr:MainUpdate()
  if request then
    request = false

    if (combatState == true) and (not profileDB.updateInCombat) then
      return
    end

    local totalcost, percent, percentmin  = Durrr:GetRepairData()

    if percentmin then
      DurrrLDB.text = (string.format("|cff%s%d%%|r", Durrr:GetThresholdHexColor(percentmin), percentmin * 100))
    end
  end
end
-- End LDB Update --

-- LDB icon --
function Durrr:UpdateIcon()
	if profileDB.repairFromGuild and (profileDB.repairType == 1) then
		DurrrLDB.iconCoords = guildRepairIconCoords
	else
		DurrrLDB.iconCoords = repairIconCoords
	end
end
-- End LDB icon --

-- Events --
function Durrr:ScheduleUpdate()
  request = true
end

function Durrr:OnMerchantShow()
  merchantState = true
  if not CanMerchantRepair() then
    return
  end
  Durrr:AttemptToRepair()
end

function Durrr:OnMerchantClose()
  merchantState = false
  if DurrrDialog:ActiveDialog("DurrrConfirm") then
    DurrrDialog:Dismiss("DurrrConfirm")
  end
  if DurrrDialog:ActiveDialog("DurrrDialog") then
    DurrrDialog:Dismiss("DurrrDialog")
  end
end

function Durrr:OnRegenEnable()
  combatState = false
  Durrr:ScheduleUpdate()
end

function Durrr:OnRegenDisable()
  combatState = true
end

function Durrr:OnUpdateResting()
  if IsResting() then
    Durrr:WarnToRepair()
  end
end
-- End Events --

-- Profile Change Functions --
function Durrr:OnProfileChanged(event, database, newProfileKey)
  profileDB = database.profile
end
-- End Profile Change Functions --

-- Config window --
function Durrr:ShowConfig()
  InterfaceOptionsFrame_OpenToCategory(Durrr.optionsFrames.profile)
	InterfaceOptionsFrame_OpenToCategory(Durrr.optionsFrames.profile)
	InterfaceOptionsFrame_OpenToCategory(Durrr.optionsFrames.general)
end
-- End Config window --

-- Show coins with icons --
function Durrr:CopperToString(c)
  local str = ""
  if not c or c < 0 then
    return str
  end

  if c >= 10000 then
		local g = math.floor(c/10000)
		c = c - g*10000
		str = str.."|cFFFFD800"..g.."|r |TInterface\\MoneyFrame\\UI-GoldIcon.blp:0:0:0:0|t"
	end
	if c >= 100 then
		local s = math.floor(c/100)
		c = c - s*100
		str = str.."|cFFC7C7C7"..s.."|r |TInterface\\MoneyFrame\\UI-SilverIcon.blp:0:0:0:0|t"
	end
	if c >= 0 then
		str = str.."|cFFEEA55F"..c.."|r |TInterface\\MoneyFrame\\UI-CopperIcon.blp:0:0:0:0|t"
	end

	return str
end
-- End Show coins with icons --

-- Data Updates --
function Durrr:GetRepairData()
	local totalcost = 0
	local percent = 0
	local percentmin = 1

	local total = 0
	local current = 0
	local index, item

	for index, item in pairs(slots) do
		local val, max = GetInventoryItemDurability(slots[index][ID])
		local hasItem, hasCooldown, repairCost = hiddenFrame:SetInventoryItem("player", slots[index][ID])
		if max then
			if merchantState == true then
				repairCost = Durrr:MerchantCorrection(repairCost)
			end
			total = total + max
			current = current + val
			totalcost = totalcost + repairCost
			slots[index][VAL] = val
			slots[index][MAX] = max
			slots[index][COST] = repairCost
			percent = val/max
			if percent < percentmin then percentmin = percent end
		else
			slots [index][MAX] = 0
		end
	end

	local bagTotal, bagCurrent = 0, 0
	if profileDB.showBags then
		bagCost = 0;
		for bag = 0, 4 do
			local nrslots = GetContainerNumSlots(bag)
			for slot = 1, nrslots do
				local val, max = GetContainerItemDurability(bag, slot)
				local hasCooldown, repairCost = hiddenFrame:SetBagItem(bag, slot)
				if max then
					if merchantState == true then
						repairCost = Durrr:MerchantCorrection(repairCost)
					end
					bagTotal = bagTotal + max
					bagCurrent = bagCurrent + val
					bagCost = bagCost + repairCost
					percent = val/max
					if percent < percentmin then percentmin = percent end
				end
			end
		end
		if bagTotal > 0 then
			bagPercent = bagCurrent / bagTotal
		else
			bagPercent = 1
		end
		totalcost = totalcost + bagCost
	end

	current = current + bagCurrent
	total = total + bagTotal
	if total then
		percent = current/total
	end

	return totalcost, percent, percentmin
end
-- End Data Updates --

-- Faction discount --
function Durrr:MerchantCorrection(value)
	local standing = UnitReaction("npc", "player")
	if standing == 5 then
		value = value * 100 / 95
	elseif standing == 6 then
		value = value * 10 / 9
	elseif standing == 7 then
		value = value * 100 / 85
	elseif standing == 8 then
		value = value * 10 / 8
	end
	return value
end
-- End Faction discount --

-- Checks --
function Durrr:AttemptToRepair()
	repairAllCost, canRepair = GetRepairAllCost()
	if profileDB.repairType > 0 and repairAllCost > 0 then
		local standing = UnitReaction("npc", "player")
		if standing >= profileDB.repairThreshold then
			Durrr:DoRepair()
		else
			Durrr:LowRepConfirmation()
		end
	end
end
-- End Checks --

-- Repair functions --
function Durrr:DoRepair()
	if profileDB.repairType == 2 then
		Durrr:ShowDialog()
	elseif profileDB.repairType == 1 then
		if profileDB.repairFromGuild then
			Durrr:AutoRepairFromBank()
		else
			Durrr:AutoRepair()
		end
	end
end
-- End Repair functions --

-- Low rep confirm --
function Durrr:LowRepConfirmation()
	if (profileDB.alwaysAsk) then
		local standing = UnitReaction("npc", "player")
		DurrrDialog:Spawn("DurrrConfirm", standing)
	end
end
-- End Low rep confirm --

-- Repair Popup --
function Durrr:ShowDialog()
	DurrrDialog:Spawn("DurrrDialog")
end
-- End Repair Popup --

-- Auto repair - Self --
function Durrr:AutoRepair()
  if canRepair == true then
		RepairAllItems()
		Durrr:Print("|cff00ff00["..L["AddonName"].."]|r " .. L["RepairedPersonal"] .. " " .. Durrr:CopperToString(repairAllCost))
	else
		Durrr:Print("|cff00ff00["..L["AddonName"].."]|r " .. L["CardDeclined"] .. " " .. Durrr:CopperToString(repairAllCost))
  end
end
-- End Auto repair - Self --

-- Auto repair - Guild --
function Durrr:AutoRepairFromBank()
	local GuildBankWithdrawMoney = GetGuildBankWithdrawMoney()
	local GuildBankMoney = GetGuildBankMoney()
	if GuildBankWithdrawMoney == -1 then
		GuildBankWithdrawMoney = GuildBankMoney
	else
		GuildBankWithdrawMoney = min(GuildBankWithdrawMoney, GuildBankMoney)
	end
	if canRepair == true and CanGuildBankRepair() and GuildBankWithdrawMoney >= repairAllCost then
		RepairAllItems(1)
		Durrr:Print("|cff00ff00["..L["AddonName"].."]|r " .. L["RepairedGuildFunds"] .. " " .. Durrr:CopperToString(repairAllCost))
  elseif profileDB.repairFromGuildOnly then
    Durrr:Print("|cff00ff00["..L["AddonName"].."]|r " .. L["NoGuildGold"])
	else
		Durrr:Print("|cff00ff00["..L["AddonName"].."]|r " .. L["NoGuildGoldUsePersonal"])
		Durrr:AutoRepair()
	end
end
-- End Auto repair - Guild --

-- Below Threshold Warning --
function Durrr:WarnToRepair()
	local totalcost, percent, percentmin  = Durrr:GetRepairData()
	if profileDB.warntoRepair and profileDB.warnThreshold >= percentmin*100 then
		local hexColor = Durrr:GetThresholdHexColor(percentmin)
		local text = Durrr:Colorize(hexColor, string.format("%d", percentmin * 100))
    DurrrDialog:Spawn("DurrrWarnToRepair", text)
	end
end
-- End Below Threshold Warning --

-- Dialog Popups --
function Durrr:CreateDialogs()
	DurrrDialog:Register("DurrrDialog", {
		text = " ",
		buttons = {
			{
				text = L["Myself"],
				on_click = function(self, button, down)
					Durrr:AutoRepair()
				end,
			},
			{
				text = L["Cancel"],
			},
			{
				text = L["TheGuild"],
				on_click = function(self, button, down)
					Durrr:AutoRepairFromBank()
				end,
			},
		},
		on_show = function(self, data)
			self.text:SetFormattedText(L["WhoPays"], Durrr:CopperToString(repairAllCost))
		end,
		hide_on_escape = true,
		show_while_dead = false,
	})

	DurrrDialog:Register("DurrrConfirm", {
		text = " ",
		icon = [[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]],
		buttons = {
			{
				text = L["Yes"],
				on_click = function(self, button, down)
					Durrr:DoRepair()
				end,
			},
			{
				text = L["No"],
			},
		},
		on_show = function(self, data)
			self.text:SetFormattedText(L["YourRepIs"].."|cFFFFFF00%s|r. "..L["AutoRepairRequires"].." %s. "..L["RepairConfirm"], _G["FACTION_STANDING_LABEL" .. data], _G["FACTION_STANDING_LABEL" .. profileDB.repairThreshold])
		end,
		hide_on_escape = true,
		show_while_dead = false,
	})

  DurrrDialog:Register("DurrrWarn", {
		text = " ",
		icon = [[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]],
		buttons = {
			{
				text = L["Ok"],
			},
		},
		on_show = function(self, data)
			self.text:SetFormattedText(L["Card Declined"], data)
		end,
		hide_on_escape = true,
		show_while_dead = false,
	})

  DurrrDialog:Register("DurrrWarnToRepair", {
		text = " ",
		icon = [[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]],
		buttons = {
			{
				text = L["Ok"],
			},
		},
		on_show = function(self, data)
			self.text:SetFormattedText(L["CityWarn"], data)
		end,
		hide_on_escape = true,
		show_while_dead = false,
	})
end
-- End Dialog Popups --

-- Do Colors --
function Durrr:GetThresholdPercentage(quality, ...)
  local n = select('#', ...)
  if n <= 1 then
    return Durrr:GetThresholdPercentage(quality, 0, ... or 1)
  end

  local worst = ...
  local best = select(n, ...)

  if worst == best and quality == worst then
    return 0.5
  end

  if worst <= best then
    if quality <= worst then
      return 0
    elseif quality >= best then
      return 1
    end
    local last = worst
    for i = 2, n-1 do
      local value = select(i, ...)
      if quality <= value then
        return ((i-2) + (quality - last) / (value - last)) / (n-1)
      end
      last = value
    end

    local value = select(n, ...)
    return ((n-2) + (quality - last) / (value - last)) / (n-1)
  else
    if quality >= worst then
      return 0
    elseif quality <= best then
      return 1
    end
    local last = worst
    for i = 2, n-1 do
      local value = select(i, ...)
      if quality >= value then
        return ((i-2) + (quality - last) / (value - last)) / (n-1)
      end
      last = value
    end

    local value = select(n, ...)
    return ((n-2) + (quality - last) / (value - last)) / (n-1)
  end
end

function Durrr:GetThresholdColor(quality, ...)
  if quality ~= quality --[[or quality == inf or quality == -inf]] then
    return 1, 1, 1
  end

  local percent = Durrr:GetThresholdPercentage(quality, ...)

  if percent <= 0 then
    return 1, 0, 0
  elseif percent <= 0.5 then
    return 1, percent*2, 0
  elseif percent >= 1 then
    return 0, 1, 0
  else
    return 2 - percent*2, 1, 0
  end
end

function Durrr:GetThresholdHexColor(quality, ...)
	local r, g, b = Durrr:GetThresholdColor(quality, ...)
	return string.format("%02x%02x%02x", r*255, g*255, b*255)
end

function Durrr:Colorize(hexColor, text)
	return "|cff" .. tostring(hexColor or 'ffffff') .. tostring(text) .. "|r"
end
-- End Colors --

-- Last Editted By: @file-author@ - @file-date-iso@
-- @file-revision@
