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

local DurrrFrame = CreateFrame("GameTooltip")
DurrrFrame:SetOwner(WorldFrame, "ANCHOR_NONE")

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
local vendorState = false
local updateReq = true

local DurrrDBprofile
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
    critWarntoRepair = true,
    critWarnThreshold = 25,
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
            return DurrrDBprofile.showDetails
          end,
          set = function(key, value)
            DurrrDBprofile.showDetails = value
          end,
        },
        bags = {
          order = 3,
          type = "toggle",
          name = L["ShowBags"],
          desc = L["ShowBagsToggle"],
          get = function()
            return DurrrDBprofile.showBags
          end,
          set = function(key, value)
            DurrrDBprofile.showBags = value
          end,
        },
        combat = {
          order = 4,
          type = "toggle",
          name = L["InCombatUpdate"],
          desc = L["InCombatToggle"],
          get = function()
            return DurrrDBprofile.updateInCombat
          end,
          set = function(key, value)
            DurrrDBprofile.updateInCombat = value
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
						return DurrrDBprofile.repairThreshold
					end,
					set = function(key, value)
						DurrrDBprofile.repairThreshold = value
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
						return DurrrDBprofile.repairType == 0
					end,
				},
				askEverywhere = {
					order = 7,
					type = "toggle",
          width = "full",
					name = L["AskIfLower"],
					desc = L["LowRepConfirmPop"],
					get = function()
						return DurrrDBprofile.alwaysAsk
					end,
					set = function(key, value)
						DurrrDBprofile.alwaysAsk = value
					end,
					disabled = function()
						return DurrrDBprofile.repairType == 0
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
            return DurrrDBprofile.repairType
          end,
          set = function(key, value)
            DurrrDBprofile.repairType = value
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
            return DurrrDBprofile.repairFromGuild
          end,
          set = function(key, value)
            DurrrDBprofile.repairFromGuild = value
            Durrr:UpdateIcon()
          end,
          disabled = function()
            return not (DurrrDBprofile.repairType == 1)
          end,
        },
        repairGuildOnly = {
          order = 11,
          type = "toggle",
          width = "full",
          name = L["OnlyGuildFunds"],
          desc = L["NoGuildGoldToggle"],
          get = function()
            return DurrrDBprofile.repairFromGuildOnly
          end,
          set = function(key, value)
            DurrrDBprofile.repairFromGuildOnly = value
          end,
          disabled = function()
            return ( DurrrDBprofile.repairFromGuild == false or (not (DurrrDBprofile.repairType == 1)) )
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
					name = L["CityWarnConf"],
					desc = L["CityWarnToggle"],
					get = function()
						return DurrrDBprofile.warntoRepair
					end,
					set = function(key, value)
						DurrrDBprofile.warntoRepair = value
						if (value) then
							Durrr:RegisterEvent("PLAYER_UPDATE_RESTING", "OnRestUpdate")
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
						return DurrrDBprofile.warnThreshold
					end,
					set = function(key, value)
						DurrrDBprofile.warnThreshold = value
					end,
        },
        separator5 = {
					type = "header",
					name = L["CritWarningOpts"],
					order = 15,
				},
				critWarn = {
					order = 16,
					type = "toggle",
          width = "full",
					name = L["CritWarnConf"],
					desc = L["CritWarnToggle"],
					get = function()
						return DurrrDBprofile.critWarntoRepair
					end,
					set = function(key, value)
						DurrrDBprofile.critWarntoRepair = value
						if (value) then
              Durrr:RegisterEvent("ZONE_CHANGED", "OnCritUpdate")
              Durrr:RegisterEvent("ZONE_CHANGED_INDOORS", "OnCritUpdate")
              Durrr:RegisterEvent("ZONE_CHANGED_NEW_AREA", "OnCritUpdate")
						else
              Durrr:RegisterEvent("ZONE_CHANGED")
              Durrr:RegisterEvent("ZONE_CHANGED_INDOORS")
              Durrr:RegisterEvent("ZONE_CHANGED_NEW_AREA")
						end
					end,
				},
				critWarnThreshold = {
					order = 17,
					type = "range",
					name = L["WarnThreshold"],
					desc = L["WarnMax"],
					min = 0, max = 100, step = 1,
					get = function()
						return DurrrDBprofile.critWarnThreshold
					end,
					set = function(key, value)
						DurrrDBprofile.critWarnThreshold = value
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
    local errorDB = L["ErrorDB"]
    print(errorDB)
  end

  Durrr.db.RegisterCallback(Durrr, "OnProfileChanged", "OnProfileChanged")
  Durrr.db.RegisterCallback(Durrr, "OnProfileCopied", "OnProfileChanged")
  Durrr.db.RegisterCallback(Durrr, "OnProfileReset", "OnProfileChanged")

  DurrrDBprofile = Durrr.db.profile
  Durrr:SetupOptions()

  local index, item
  for index, item in pairs(slots) do
    slots[index][ID] = GetInventorySlotInfo(item[SLOT] .. "Slot")
  end

  Durrr:CreateDialogs()

  Durrr:RegisterEvent("PLAYER_DEAD", "ScheduleUpdate")
	Durrr:RegisterEvent("PLAYER_UNGHOST", "ScheduleUpdate")
	Durrr:RegisterEvent("UPDATE_INVENTORY_DURABILITY", "ScheduleUpdate")
	Durrr:RegisterEvent("PLAYER_REGEN_ENABLED", "OnRestEnable")
	Durrr:RegisterEvent("PLAYER_REGEN_DISABLED", "OnRestDisable")
	Durrr:RegisterEvent("MERCHANT_SHOW", "OnVendorShow")
	Durrr:RegisterEvent("MERCHANT_CLOSED", "OnVendorClose")
  Durrr:RegisterEvent("ZONE_CHANGED", "OnCritUpdate")
  Durrr:RegisterEvent("ZONE_CHANGED_INDOORS", "OnCritUpdate")
  Durrr:RegisterEvent("ZONE_CHANGED_NEW_AREA", "OnCritUpdate")

  if (DurrrDBprofile.warntoRepair) then
    Durrr:RegisterEvent("PLAYER_UPDATE_RESTING", "OnRestUpdate")
    Durrr:ScheduleTimer("OnRestUpdate", 5)
  end
-- Figure out this timer thing!!!!
  if (DurrrDBprofile.critWarntoRepair) then
    Durrr:RegisterEvent("ZONE_CHANGED", "OnCritUpdate")
    Durrr:RegisterEvent("ZONE_CHANGED_INDOORS", "OnCritUpdate")
    Durrr:RegisterEvent("ZONE_CHANGED_NEW_AREA", "OnCritUpdate")
    Durrr:ScheduleTimer("OnCritUpdate", 5)
  end

  Durrr:UpdateIcon()
  Durrr:ScheduleUpdate()
end

function Durrr:OnEnable()
  Durrr:ScheduleRepeatingTimer("MainUpdate", 1)
end
-- End Init Things --

-- Profile Change Functions --
function Durrr:OnProfileChanged(event, database, newProfileKey)
  DurrrDBprofile = database.profile
end
-- End Profile Change Functions --

-- Config window --
function Durrr:ShowConfig()
	InterfaceOptionsFrame_OpenToCategory(Durrr.optionsFrames.profile)
	InterfaceOptionsFrame_OpenToCategory(Durrr.optionsFrames.general)
end
-- End Config window --

-- Do LDB stuff --
local DurrrLDB = DLDB:NewDataObject("Durrrability", {
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

    local totalCost, percent, percentMin  = Durrr:GetRepairData()
    if totalCost <= 0 then
      tooltip:AddLine(" ")
      tooltip:AddLine(L["NoBroke"], 0, 1, 0)
    else
      if DurrrDBprofile.showDetails then
        tooltip:AddLine(" ")
        for index, item in pairs(slots) do
          if item[MAX] > 0 and item[VAL] < item[MAX] then
            local p = item[VAL] / item[MAX]
            local r, g, b = Durrr:GetThresholdColor(p)

            tooltip:AddDoubleLine(string.format("%d%%  " .. Durrr:Colorize("%s", "yellow"), p * 100, item[NAME]), Durrr:Coins2Str(math.floor(item[COST])), r, g, b, 1, 1, 1)
          end
        end
        if DurrrDBprofile.showBags and (bagCost > 0) then
          local r, g, b = Durrr:GetThresholdColor(bagPercent)

          tooltip:AddDoubleLine(string.format("%d%%  " .. Durrr:Colorize("Bags", "yellow"), bagPercent * 100), Durrr:Coins2Str(math.floor(bagCost)), r, g, b, 1, 1, 1)
        end
      end

      tooltip:AddLine(" ")

      local r, g, b = Durrr:GetThresholdColor(percent)
			tooltip:AddDoubleLine(Durrr:Colorize(L["Average"] .. " :", "white"), string.format("%d%%", percent * 100), 1, 1, 1, r, g, b)
      local r, g, b = Durrr:GetThresholdColor(percentMin)
      tooltip:AddDoubleLine(Durrr:Colorize(L["Lowest"] .. " :", "white"), string.format("%d%%", percentMin * 100), 1, 1, 1, r, g, b)

      tooltip:AddLine(" ")
			tooltip:AddLine(Durrr:Colorize(L["RepCost"], "white"))
			tooltip:AddDoubleLine(Durrr:Colorize(_G["FACTION_STANDING_LABEL4"], "yellow"), Durrr:Coins2Str(math.floor(totalCost)))
			tooltip:AddDoubleLine(Durrr:Colorize(_G["FACTION_STANDING_LABEL5"], "aaff00"), Durrr:Coins2Str(math.floor(totalCost*0.95)))
			tooltip:AddDoubleLine(Durrr:Colorize(_G["FACTION_STANDING_LABEL6"], "55ff00"), Durrr:Coins2Str(math.floor(totalCost*0.90)))
			tooltip:AddDoubleLine(Durrr:Colorize(_G["FACTION_STANDING_LABEL7"], "00ff00"), Durrr:Coins2Str(math.floor(totalCost*0.85)))
			tooltip:AddDoubleLine(Durrr:Colorize(_G["FACTION_STANDING_LABEL8"], "00ffaa"), Durrr:Coins2Str(math.floor(totalCost*0.80)))
    end

    tooltip:AddLine(" ")
    local rightClick = (Durrr:Colorize(L["RightClick"] .. " ", "eda55f") .. L["RightToolTip"])
    tooltip:AddLine(rightClick)
  end,
})

function Durrr:MainUpdate()
  if updateReq then
    updateReq = false

    if (combatState == true) and (not DurrrDBprofile.updateInCombat) then
      return
    end

    local totalCost, percent, percentMin  = Durrr:GetRepairData()

    if percentMin then
      DurrrLDB.text = (string.format(Durrr:Colorize("%d%%", "%s"), percentMin * 100, Durrr:GetThresholdHexColor(percentMin)))
    end
  end
end

function Durrr:UpdateIcon()
	if DurrrDBprofile.repairFromGuild and (DurrrDBprofile.repairType == 1) then
		DurrrLDB.iconCoords = guildRepairIconCoords
	else
		DurrrLDB.iconCoords = repairIconCoords
	end
end
-- End LDB stuff --

-- Events --
function Durrr:ScheduleUpdate()
  if (DurrrDBprofile.critWarntoRepair) then
    Durrr:CritWarnToRepair()
  end
  updateReq = true
end

function Durrr:OnVendorShow()
  vendorState = true
  if not CanMerchantRepair() then
    return
  end
  Durrr:RepairAttempt()
end

function Durrr:OnVendorClose()
  vendorState = false
  if DurrrDialog:ActiveDialog("DurrrConfirm") then
    DurrrDialog:Dismiss("DurrrConfirm")
  end
  if DurrrDialog:ActiveDialog("DurrrDialog") then
    DurrrDialog:Dismiss("DurrrDialog")
  end
end

function Durrr:OnRestEnable()
  combatState = false
  if (DurrrDBprofile.critWarntoRepair) then
    Durrr:CritWarnToRepair()
  end
  Durrr:ScheduleUpdate()
end

function Durrr:OnRestDisable()
  combatState = true
end

function Durrr:OnRestUpdate()
  if IsResting() then
    Durrr:WarnToRepair()
  elseif (DurrrDBprofile.critWarntoRepair) then
    Durrr:CritWarnToRepair()
  end
end

function Durrr:OnCritUpdate()
  if (DurrrDBprofile.critWarntoRepair) then
    Durrr:CritWarnToRepair()
  end
  Durrr:ScheduleUpdate()
end
-- End Events --

-- Show coins with icons --
function Durrr:Coins2Str(coins)
  local string = ""
  if not coins or coins < 0 then
    return string
  end

  if coins >= 10000 then
		local gold = math.floor(coins / 10000)
		coins = coins - gold * 10000
		string = string .. Durrr:Colorize(gold, "gold") .. " |TInterface\\MoneyFrame\\UI-GoldIcon.blp:0:0:0:0|t"
	end
	if coins >= 100 then
		local silver = math.floor(coins / 100)
		coins = coins - silver * 100
		string = string .. Durrr:Colorize(silver, "silver") .. " |TInterface\\MoneyFrame\\UI-SilverIcon.blp:0:0:0:0|t"
	end
	if coins >= 0 then
		string = string .. Durrr:Colorize(coins, "copper") .. " |TInterface\\MoneyFrame\\UI-CopperIcon.blp:0:0:0:0|t"
	end

	return string
end
-- End Show coins with icons --

-- Data Updates --
function Durrr:GetRepairData()
	local totalCost = 0
	local percent = 0
	local percentMin = 1

	local total = 0
	local current = 0
	local index, item

	for index, item in pairs(slots) do
		local val, max = GetInventoryItemDurability(slots[index][ID])
		local hasItem, hasCooldown, repairCost = DurrrFrame:SetInventoryItem("player", slots[index][ID])
		if max then
			if vendorState == true then
				repairCost = Durrr:VendorFix(repairCost)
			end
			total = total + max
			current = current + val
			totalCost = totalCost + repairCost
			slots[index][VAL] = val
			slots[index][MAX] = max
			slots[index][COST] = repairCost
			percent = val / max
			if percent < percentMin then percentMin = percent end
		else
			slots [index][MAX] = 0
		end
	end

	local bagTotal, bagCurrent = 0, 0
	if DurrrDBprofile.showBags then
		bagCost = 0;
		for bag = 0, 4 do
			local numSlots = GetContainerNumSlots(bag)
			for slot = 1, numSlots do
				local val, max = GetContainerItemDurability(bag, slot)
				local hasCooldown, repairCost = DurrrFrame:SetBagItem(bag, slot)
				if max then
					if vendorState == true then
						repairCost = Durrr:VendorFix(repairCost)
					end
					bagTotal = bagTotal + max
					bagCurrent = bagCurrent + val
					bagCost = bagCost + repairCost
					percent = val / max
					if percent < percentMin then percentMin = percent end
				end
			end
		end
		if bagTotal > 0 then
			bagPercent = bagCurrent / bagTotal
		else
			bagPercent = 1
		end
		totalCost = totalCost + bagCost
	end

	current = current + bagCurrent
	total = total + bagTotal
	if total then
		percent = current/total
	end

	return totalCost, percent, percentMin
end
-- End Data Updates --

-- Faction discount --
function Durrr:VendorFix(value)
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
function Durrr:RepairAttempt()
	repairAllCost, canRepair = GetRepairAllCost()
	if DurrrDBprofile.repairType > 0 and repairAllCost > 0 then
		local standing = UnitReaction("npc", "player")
		if standing >= DurrrDBprofile.repairThreshold then
			Durrr:DoRepair()
		else
			Durrr:LowRepConfirmation()
		end
	end
end
-- End Checks --

-- Repair functions --
function Durrr:DoRepair()
	if DurrrDBprofile.repairType == 2 then
		Durrr:ShowDialog()
	elseif DurrrDBprofile.repairType == 1 then
		if DurrrDBprofile.repairFromGuild then
			Durrr:AutoRepairFromBank()
		else
			Durrr:AutoRepair()
		end
	end
end
-- End Repair functions --

-- Low rep confirm --
function Durrr:LowRepConfirmation()
	if (DurrrDBprofile.alwaysAsk) then
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
		Durrr:Print(Durrr:Colorize("[" .. L["AddonName"] .. "]", "green") .. L["RepairedPersonal"] .. " " .. Durrr:Coins2Str(repairAllCost))
	else
		Durrr:Print(Durrr:Colorize("["..L["AddonName"].."]", "green") .. L["CardDeclined"] .. " " .. Durrr:Coins2Str(repairAllCost))
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
		Durrr:Print(Durrr:Colorize("["..L["AddonName"].."]", "green") .. L["RepairedGuildFunds"] .. " " .. Durrr:Coins2Str(repairAllCost))
  elseif DurrrDBprofile.repairFromGuildOnly then
    Durrr:Print(Durrr:Colorize("["..L["AddonName"].."]", "green") .. L["NoGuildGold"])
	else
		Durrr:Print(Durrr:Colorize("["..L["AddonName"].."]", "green") .. L["NoGuildGoldUsePersonal"])
		Durrr:AutoRepair()
	end
end
-- End Auto repair - Guild --

-- Below Threshold Warnings --
function Durrr:WarnToRepair()
	local totalCost, percent, percentMin  = Durrr:GetRepairData()
	if DurrrDBprofile.warntoRepair and DurrrDBprofile.warnThreshold >= percentMin * 100 then
    DurrrDialog:Spawn("DurrrWarnToRepair", Durrr:Colorize(string.format("%d", percentMin * 100), Durrr:GetThresholdHexColor(percentMin)))
	end
end

function Durrr:CritWarnToRepair()
	local totalCost, percent, percentMin  = Durrr:GetRepairData()
	if DurrrDBprofile.critWarntoRepair and DurrrDBprofile.critWarnThreshold >= percentMin * 100 then
    DurrrDialog:Spawn("DurrrCritWarnToRepair", Durrr:Colorize(string.format("%d", percentMin * 100), Durrr:GetThresholdHexColor(percentMin)))
	end
end
-- End Below Threshold Warning --

-- Dialog Popups --
function Durrr:CreateDialogs()
	DurrrDialog:Register("DurrrDialog", {
    text = "",
    buttons = {
      {
        text = L["Myself"],
        on_click = function(self, button, down)
          Durrr:AutoRepair()
        end
      },
      {
        text = L["Cancel"]
      },
      {
        text = L["TheGuild"],
        on_click = function(self, button, down)
          Durrr:AutoRepairFromBank()
        end
      },
    },
    on_show = function(self, data)
			self.text:SetFormattedText(L["WhoPays"] .. " %s", Durrr:Coins2Str(repairAllCost))
    end,
    hide_on_escape = true,
    show_while_dead = false
  })

	DurrrDialog:Register("DurrrConfirm", {
		text = "",
		icon = [[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]],
		buttons = {
			{
				text = L["Yes"],
				on_click = function(self, button, down)
					Durrr:DoRepair()
				end
			},
			{
				text = L["No"]
			},
		},
		on_show = function(self, data)
			self.text:SetFormattedText(L["YourRepIs"] .. Durrr:Colorize("%s", "yellow") .. L["AutoRepairRequires"] .. " %s. " .. L["RepairConfirm"], _G["FACTION_STANDING_LABEL" .. data], _G["FACTION_STANDING_LABEL" .. DurrrDBprofile.repairThreshold])
		end,
		hide_on_escape = true,
		show_while_dead = false
	})

  DurrrDialog:Register("DurrrWarn", {
		text = "",
		icon = [[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]],
		buttons = {
			{
				text = L["Ok"]
			},
		},
		on_show = function(self, data)
			self.text:SetFormattedText(L["Card Declined"], data)
		end,
		hide_on_escape = true,
		show_while_dead = false
	})

    DurrrDialog:Register("DurrrWarnToRepair", {
  		text = "",
  		icon = [[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]],
  		buttons = {
  			{
  				text = L["Ok"]
  			},
  		},
  		on_show = function(self, data)
  			self.text:SetFormattedText(L["CityWarn"], data)
  		end,
  		hide_on_escape = true,
  		show_while_dead = false
  	})

      DurrrDialog:Register("DurrrCritWarnToRepair", {
    		text = "",
    		icon = [[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]],
    		buttons = {
    			{
    				text = L["Ok"]
    			},
    		},
    		on_show = function(self, data)
    			self.text:SetFormattedText(L["CritWarn"], data)
    		end,
    		hide_on_escape = true,
    		show_while_dead = false
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
    for i = 2, n - 1 do
      local value = select(i, ...)
      if quality <= value then
        return ((i - 2) + (quality - last) / (value - last)) / (n - 1)
      end
      last = value
    end

    local value = select(n, ...)
    return ((n - 2) + (quality - last) / (value - last)) / (n - 1)
  else
    if quality >= worst then
      return 0
    elseif quality <= best then
      return 1
    end
    local last = worst
    for i = 2, n - 1 do
      local value = select(i, ...)
      if quality >= value then
        return ((i - 2) + (quality - last) / (value - last)) / (n - 1)
      end
      last = value
    end

    local value = select(n, ...)
    return ((n - 2) + (quality - last) / (value - last)) / (n - 1)
  end
end

function Durrr:GetThresholdColor(quality, ...)
  if quality ~= quality then
    return 1, 1, 1
  end

  local percent = Durrr:GetThresholdPercentage(quality, ...)

  if percent <= 0 then
    return 1, 0, 0
  elseif percent <= 0.5 then
    return 1, percent * 2, 0
  elseif percent >= 1 then
    return 0, 1, 0
  else
    return 2 - percent * 2, 1, 0
  end
end

function Durrr:GetThresholdHexColor(quality, ...)
	local r, g, b = Durrr:GetThresholdColor(quality, ...)
	return string.format("%02x%02x%02x", r * 255, g * 255, b * 255)
end
-- End Colors --

-- Last Editted By: @file-author@ - @file-date-iso@
-- @file-revision@
