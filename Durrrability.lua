local _G = getfenv(0)

local Durrrability = LibStub("AceAddon-3.0"):NewAddon("Durrrability", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
--local DurrrabilityColors = LibStub:GetLibrary("LibColors-1.0")
local DurrrabilityConfig = LibStub("AceConfig-3.0")
local DurrrabilityConfigDialog = LibStub("AceConfigDialog-3.0")
local DurrrabilityDB = LibStub("AceDB-3.0")
local DurrrabilityDBOptions = LibStub("AceDBOptions-3.0")
local DurrrabilityDialog = LibStub("LibDialog-1.0")
local DurrrabilityLDB = LibStub:GetLibrary("LibDataBroker-1.1")
local L = LibStub("AceLocale-3.0"):GetLocale("Durrrability")

-- Defaults
local ID = 6
local SLOT = 4
local NAME = 5
local VAL = 1
local MAX = 2
local COST = 3

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

local bagsCost = 0
local bagsPercent = 0

--local IN_COMBAT = 0
--local OUT_OF_COMBAT = 1
local combatState = true

--local NOT_AT_MERCHANT = 0
--local AT_MERCHANT = 1
local merchantState = false

local request = true

local hiddenFrame = CreateFrame("GameTooltip")
  hiddenFrame:SetOwner(WorldFrame, "ANCHOR_NONE")

local repairIconCoords = {0.28125, 0.5625, 0, 0.5625}
local guildRepairIconCoords = {0.5625, 0.84375, 0, 0.5625}

local profileDB
local DurrrabilityDBDefaults = {
  profile = {
    showDetails = true,
    showBags = true,
    updateCombat = true,
    repairFromGuild = true,
    repairFromGuildOnly = false,
    repairThreshold = 4,
    showPopup = true,
    repairType = 1,
    alwaysAsk = false,
    warntoRepair = true,
    warnThreshold = 50,
  },
}

local repairAllCost, canRepair

--------------------------------------------------------------------------------------------------------
--                              Broker_DurabilityInfo options panel                                   --
--------------------------------------------------------------------------------------------------------
Durrrability.options = {
  type = "group",
  name = "Durrrability",
  args = {
    general = {
      order = 1,
      type = "group",
      name = L["General Settings"],
      cmdInline = true,
      args = {
        separator1 = {
          type = "header",
          name = L["Display Options"],
          order = 1,
        },
        details = {
          order = 2,
          type = "toggle",
          name = L["Show each item."],
          desc = L["Toggle to show detailed item durability."],
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
          name = L["Show bags."],
          desc = L["Toggle to show durability for items in bags."],
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
          name = L["Update in combat."],
          desc = L["Toggle to update while in combat. (could be CPU intensive)"],
          get = function()
            return profileDB.updateInCombat
          end,
          set = function(key, value)
            profileDB.updateInCombat = value
          end,
        },
        separator2 = {
          type = "header",
          name = L["Repair Options"],
          order = 5,
        },
        repairType = {
          order = 6,
          type = "select",
          style = "dropdown",
          name = L["Repair type:"],
          desc = L["Choose how do you want DurabilityInfo to handle item repairs at vendor."],
          get = function()
            return profileDB.repairType
          end,
          set = function(key, value)
            profileDB.repairType = value
            Durrrability:UpdateIcon()
          end,
          values = function()
            return {
              [0] = L["Do nothing"],
              [1] = L["Auto repair"],
              [2] = L["Ask me"],
            }
          end,
        },
        repairGuild = {
          order = 7,
          type = "toggle",
          width = "full",
          name = L["Use guild bank."],
          desc = L["Toggle to repair using guild bank."],
          get = function()
            return profileDB.repairFromGuild
          end,
          set = function(key, value)
            profileDB.repairFromGuild = value
            Durrrability:UpdateIcon()
          end,
          disabled = function()
            return not (profileDB.repairType == 1)
          end,
        },
        repairGuildOnly = {
          order = 8,
          type = "toggle",
          width = "full",
          name = L["Only use guild bank."],
          desc = L["Toggle to not repair with your money if guild does not have enough."],
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
				factionThreshold = {
					order = 9,
					type = "select",
					style = "dropdown",
					name = L["Minimum reputation:"],
					desc = L["Choose the minimum reputation level for auto repair."],
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
					order = 10,
					type = "toggle",
					name = L["If lower ask me."],
					desc = L["Pop up a confirmation box for lower reputations."],
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
				separator3 = {
					type = "header",
					name = L["Warning Options"],
					order = 11,
				},
				warn = {
					order = 12,
					type = "toggle",
					name = L["Warn when in city."],
					desc = L["Toggle to warn you to repair upon entering a city."],
					get = function()
						return profileDB.warntoRepair
					end,
					set = function(key, value)
						profileDB.warntoRepair = value
						if (value) then
							Durrrability:RegisterEvent("PLAYER_UPDATE_RESTING","OnUpdateResting")
						else
							Durrrability:UnregisterEvent("PLAYER_UPDATE_RESTING")
						end
					end,
				},
				warnThreshold = {
					order = 13,
					type = "range",
					name = L["Warn Threshold"],
					desc = L["Set maximum item durability to toggle the warning."],
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

function Durrrability:SetupOptions()
  Durrrability.options.args.profile = DurrrabilityDBOptions:GetOptionsTable(self.db)
  Durrrability.options.args.profile.order = -2

  DurrrabilityConfig:RegisterOptionsTable("Durrrability", Durrrability.options, nil)

  self.optionsFrames = {}
  self.optionsFrames.general = DurrrabilityConfigDialog:AddToBlizOptions("Durrrability", nil, nil, "general")
  self.optionsFrames.profile = DurrrabilityConfigDialog:AddToBlizOptions("Durrrability", L["Profiles"], "Durrrability", "profile")
end

-- Do The Things
function Durrrability:OnInitialize()
  self.db = DurrrabilityDB:New("DurrrabilityDB", DurrrabilityDBDefaults, true)
  if not self.db then
    print("Error: Database not loaded correctly.  Please exit out of WoW and delete Broker_DurabilityInfo.lua found in: \\World of Warcraft\\WTF\\Account\\<Account Name>>\\SavedVariables\\")
  end

  self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
  self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
  self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")

  profileDB = self.db.profile
  self:SetupOptions()

  local index, item
  for index, item in pairs(slots) do
    slots[index][ID] = GetInventorySlotInfo(item[SLOT] .. "Slot")
  end

  self:CreateDialogs()

  self:RegisterEvent("PLAYER_DEAD","ScheduleUpdate")
	self:RegisterEvent("PLAYER_UNGHOST","ScheduleUpdate")
	self:RegisterEvent("UPDATE_INVENTORY_DURABILITY","ScheduleUpdate")
	self:RegisterEvent("PLAYER_REGEN_ENABLED","OnRegenEnable")
	self:RegisterEvent("PLAYER_REGEN_DISABLED","OnRegenDisable")
	self:RegisterEvent("MERCHANT_SHOW","OnMerchantShow")
	self:RegisterEvent("MERCHANT_CLOSED","OnMerchantClose")

  if (profileDB.warntoRepair) then
    self:RegisterEvent("PLAYER_UPDATE_RESTING","OnUpdateResting")
    self:ScheduleTimer("OnUpdateResting", 5)
  end

  self:UpdateIcon()
  self:ScheduleUpdate()
end

function Durrrability:OnEnable()
  self:ScheduleRepeatingTimer("MainUpdate", 1)
end

-- LDB object
Durrrability.obj = DurrrabilityLDB:NewDataObject("Durrrability", {
  type = "data source",
  label = L["Durability"],
  text = "",
  icon = "Interface\\MerchantFrame\\UI-Merchant-RepairIcons",
  iconCoords = repairIconCoords,
  OnClick = function(frame, msg)
    if msg == "RightButton" then
      Durrrability:ShowConfig()
    end
    Durrrability:MainUpdate()
  end,
  OnTooltipShow = function(tooltip)
    if not tooltip or not tooltip.AddLine then return end

    tooltip:AddLine("Durrrability" .. " " .. GetAddOnMetadata("Durrrability", "Version"))

    local totalcost, percent, percentmin  = Durrrability:GetRepairData()
    if totalcost <= 0 then
      tooltip:AddLine(" ")
      tooltip:AddLine(L["All items repaired!"], 0, 1, 0)
    else
      if profileDB.showDetails then
        tooltip:AddLine(" ")
        for index, item in pairs(slots) do
          if item[MAX] > 0 and item[VAL] < item[MAX] then
            local p = item[VAL] / item[MAX]
            local r, g, b = Durrrability:GetThresholdColor(p)

            tooltip:AddDoubleLine(string.format("%d%%  |cFFFFFF00%s|t", p * 100, item[NAME]), Durrrability:CopperToString(math.floor(item[COST])), r, g, b, 1, 1, 1)
          end
        end
        if profileDB.showBags and (bagCost > 0) then
          local r, g, b = Durrrability:GetThresholdColor(bagPercent)

          tooltip:AddDoubleLine(string.format("%d%%  |cFFFFFF00Bags|t", bagPercent * 100), Durrrability:CopperToString(math.floor(bagCost)), r, g, b, 1, 1, 1)
        end
      end

      tooltip:AddLine(" ")

      local r, g, b = Durrrability:GetThresholdColor(percent)
			tooltip:AddDoubleLine("|cFFFFFFFF"..L["Average"].." :", string.format("%d%%", percent * 100), 1, 1, 1, r, g, b)
      local r, g, b = Durrrability:GetThresholdColor(percentmin)
      tooltip:AddDoubleLine("|cFFFFFFFF"..L["Lowest"].." :", string.format("%d%%", percentmin * 100), 1, 1, 1, r, g, b)

      tooltip:AddLine(" ")
			tooltip:AddLine("|cFFFFFFFF"..L["Cost for faction reputation:"])
			tooltip:AddDoubleLine("|cFFFFFF00".._G["FACTION_STANDING_LABEL4"], Durrrability:CopperToString(math.floor(totalcost)))
			tooltip:AddDoubleLine("|cFFAAFF00".._G["FACTION_STANDING_LABEL5"], Durrrability:CopperToString(math.floor(totalcost*0.95)))
			tooltip:AddDoubleLine("|cFF55FF00".._G["FACTION_STANDING_LABEL6"], Durrrability:CopperToString(math.floor(totalcost*0.90)))
			tooltip:AddDoubleLine("|cFF00FF00".._G["FACTION_STANDING_LABEL7"], Durrrability:CopperToString(math.floor(totalcost*0.85)))
			tooltip:AddDoubleLine("|cFF00FFAA".._G["FACTION_STANDING_LABEL8"], Durrrability:CopperToString(math.floor(totalcost*0.80)))
    end

    tooltip:AddLine(" ")
    tooltip:AddLine(L["Right-hint"])
  end,
})
local updateTime, elapsed = 0.5, 0
local ldbf = CreateFrame("frame")
ldbf:SetScript("OnUpdate", function(self, elap)
  elapsed = elapsed + elap
  if elapsed < updateTime then return end

  elapsed = 0
  local ldbcost, ldbpercent, ldbpercentmin = Durrrability:GetRepairData()
  Durrrability.obj.text = string.format("%d%%", ldbpercent * 100)
end)

-- Main update function
function Durrrability:MainUpdate()
  if request then
    request = false

    if (combatState == true) and (not profileDB.updateInCombat) then
      return
    end

    local totalcost, percent, percentmin  = self:GetRepairData()

    if percentmin then
      self.obj.text = (string.format("|cff%s%d%%|r", Durrrability:GetThresholdHexColor(percentmin), percentmin * 100))
    end
  end
end

-- Events
function Durrrability:ScheduleUpdate()
  request = true
end

function Durrrability:OnMerchantShow()
  merchantState = true
  if not CanMerchantRepair() then
    return
  end
  self:AttemptToRepair()
end

function Durrrability:OnMerchantClose()
  merchantState = false
  if DurrrabilityDialog:ActiveDialog("Durrrability_Confirm") then
    DurrrabilityDialog:Dismiss("DurrrabilityInfo_Confirm")
  end
  if DurrrabilityDialog:ActiveDialog("Durrrability_Dialog") then
    DurrrabilityDialog:Dismiss("Durrrability_Dialog")
  end
end

function Durrrability:OnRegenEnable()
  combatState = false
  self:ScheduleUpdate()
end

function Durrrability:OnRegenDisable()
  combatState = true
end

function Durrrability:OnUpdateResting()
  if IsResting() then
    self:WarnToRepair()
  end
end

-- Functions
function Durrrability:OnProfileChanged(event, database, newProfileKey)
  profileDB = database.profile
end

-- Open config window
function Durrrability:ShowConfig()
  -- call twice to workaround a bug in Blizzard's function
  InterfaceOptionsFrame_OpenToCategory(Durrrability.optionsFrames.profile)
	InterfaceOptionsFrame_OpenToCategory(Durrrability.optionsFrames.profile)
	InterfaceOptionsFrame_OpenToCategory(Durrrability.optionsFrames.general)
end

-- Show money with icons
function Durrrability:CopperToString(c)
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

-- Update data structures
function Durrrability:GetRepairData()
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
				repairCost = self:MerchantCorrection(repairCost)
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
						repairCost = self:MerchantCorrection(repairCost)
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

-- Remove faction discount
function Durrrability:MerchantCorrection(value)
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

-- Do some checks
function Durrrability:AttemptToRepair()
	repairAllCost, canRepair = GetRepairAllCost()
	if profileDB.repairType > 0 and repairAllCost > 0 then
		local standing = UnitReaction("npc", "player")
		if standing >= profileDB.repairThreshold then
			self:DoRepair()
		else
			self:LowRepConfirmation()
		end
	end
end

-- Call repair functions
function Durrrability:DoRepair()
	if profileDB.repairType == 2 then
		self:ShowDialog()
	elseif profileDB.repairType == 1 then
		if profileDB.repairFromGuild then
			self:AutoRepairFromBank()
		else
			self:AutoRepair()
		end
	end
end

-- Low reputation confirmation
function Durrrability:LowRepConfirmation()
	if (profileDB.alwaysAsk) then
		local standing = UnitReaction("npc", "player")
		DurrrabilityDialog:Spawn("Broker_DurabilityInfo_Confirm", standing)
	end
end

-- Display popup for repair
function Durrrability:ShowDialog()
	DurrrabilityDialog:Spawn("Broker_DurabilityInfo_Dialog")
end

-- Auto repair using own money
function Durrrability:AutoRepair()
  if canRepair == true then
		RepairAllItems()
		Durrrability:Print("|cff00ff00[DurabilityInfo]|r " .. L["Your items have been repaired for"] .. " " .. self:CopperToString(repairAllCost))
	else
		Durrrability:Print("|cff00ff00[DurabilityInfo]|r " .. L["You don't have enough money for repairs! You need"] .. " " .. self:CopperToString(repairAllCost))
  end
end

-- Auto repair using guild money
function Durrrability:AutoRepairFromBank()
	local GuildBankWithdrawMoney = GetGuildBankWithdrawMoney()
	local GuildBankMoney = GetGuildBankMoney()
	if GuildBankWithdrawMoney == -1 then
		GuildBankWithdrawMoney = GuildBankMoney
	else
		GuildBankWithdrawMoney = min(GuildBankWithdrawMoney, GuildBankMoney)
	end
	if canRepair == true and CanGuildBankRepair() and GuildBankWithdrawMoney >= repairAllCost then
		RepairAllItems(1)
		Durrrability:Print("|cff00ff00[DurabilityInfo]|r " .. L["Your items have been repaired using guild bank for"] .. " " .. self:CopperToString(repairAllCost))
  elseif profileDB.repairFromGuildOnly then
    Durrrability:Print("|cff00ff00[DurabilityInfo]|r " .. L["Guild bank does not have enough money."])
	else
		Durrrability:Print("|cff00ff00[DurabilityInfo]|r " .. L["Guild bank does not have enough money. Using yours."])
		self:AutoRepair()
	end
end

-- Set LDB icon
function Durrrability:UpdateIcon()
	if profileDB.repairFromGuild and (profileDB.repairType == 1) then
		self.obj.iconCoords = guildRepairIconCoords
	else
		self.obj.iconCoords = repairIconCoords
	end
end

-- Warn to repair if under a threshold
function Durrrability:WarnToRepair()
	local totalcost, percent, percentmin  = Durrrability:GetRepairData()
	if profileDB.warntoRepair and profileDB.warnThreshold >= percentmin*100 then
		local hexColor = Durrrability:GetThresholdHexColor(percentmin)
		local text = Durrrability:Colorize(hexColor, string.format("%d", percentmin * 100))
    DurrrabilityDialog:Spawn("Broker_DurabilityInfo_Warn", text)
	end
end

-- Create static popup dialogs
function Durrrability:CreateDialogs()
	DurrrabilityDialog:Register("Durrrability_Dialog", {
		text = " ",
		buttons = {
			{
				text = L["Myself"],
				on_click = function(self, button, down)
					Durrrability:AutoRepair()
				end,
			},
			{
				text = L["Cancel"],
			},
			{
				text = L["The guild"],
				on_click = function(self, button, down)
					Durrrability:AutoRepairFromBank()
				end,
			},
		},
		on_show = function(self, data)
			self.text:SetFormattedText(L["Who's paying for the repairs?\nIt Costs %s"], Durrrability:CopperToString(repairAllCost))
		end,
		hide_on_escape = true,
		show_while_dead = false,
	})

	DurrrabilityDialog:Register("Durrrability_Confirm", {
		text = " ",
		icon = [[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]],
		buttons = {
			{
				text = L["Yes"],
				on_click = function(self, button, down)
					Durrrability:DoRepair()
				end,
			},
			{
				text = L["No"],
			},
		},
		on_show = function(self, data)
			self.text:SetFormattedText(L["You are only |cFFFFFF00%s|r with this NPC. Auto repair requires %s.\nDo you stil want to repair?"], _G["FACTION_STANDING_LABEL"..data], _G["FACTION_STANDING_LABEL"..profileDB.repairThreshold])
		end,
		hide_on_escape = true,
		show_while_dead = false,
	})

	DurrrabilityDialog:Register("Durrrability_Warn", {
		text = " ",
		icon = [[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]],
		buttons = {
			{
				text = L["Ok"],
			},
		},
		on_show = function(self, data)
			self.text:SetFormattedText(L["Your most broken item is at %s percent.\nTake the time to repair!"], data)
		end,
		hide_on_escape = true,
		show_while_dead = false,
	})
end

function Durrrability:GetThresholdPercentage(quality, ...)
  local n = select('#', ...)
  if n <= 1 then
    return Durrrability:GetThresholdPercentage(quality, 0, ... or 1)
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

function Durrrability:GetThresholdColor(quality, ...)
  if quality ~= quality --[[or quality == inf or quality == -inf]] then
    return 1, 1, 1
  end

  local percent = Durrrability:GetThresholdPercentage(quality, ...)

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

function Durrrability:GetThresholdHexColor(quality, ...)
	local r, g, b = self:GetThresholdColor(quality, ...)
	return string.format("%02x%02x%02x", r*255, g*255, b*255)
end

function Durrrability:Colorize(hexColor, text)
	return "|cff" .. tostring(hexColor or 'ffffff') .. tostring(text) .. "|r"
end
