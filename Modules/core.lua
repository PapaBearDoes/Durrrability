--                                  \\\\///
--                                 /       \
--                               (| (.)(.) |)
-- .---------------------------.OOOo--()--oOOO.---------------------------.
-- |                                                                      |
-- |  @file-author@'s Durrrability Addon for World of Warcraft
-- ########################################################################
-- ## Let's init this file shall we?
-- Imports
local _G = _G
--Durrr = select(2, ...)
local me, ns = ...
local addon = ns
local L = addon:GetLocale()
-- End Imports

-- ########################################################################
-- ########################################################################
-- ## Do All The Things!!!
local DurrrDialog = LibStub("LibDialog-1.0")

-- Dialog Popups --
function addon:CreateDialogs()
	DurrrDialog:Register("DurrrDialog", {
    text = "",
    buttons = {
      {
        text = L["Myself"],
        on_click = function(self, button, down)
          addon:AutoRepair()
        end
      },
      {
        text = L["Cancel"]
      },
      {
        text = L["TheGuild"],
        on_click = function(self, button, down)
          addon:AutoRepairFromBank()
        end
      },
    },
    on_show = function(self, data)
			self.text:SetFormattedText(L["WhoPays"] .. " %s", addon:Coins2Str(Durrr_repairAllCost))
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
					addon:DoRepair()
				end
			},
			{
				text = L["No"]
			},
		},
		on_show = function(self, data)
			self.text:SetFormattedText(L["YourRepIs"] .. addon:Colorize("%s", "yellow") .. L["AutoRepairRequires"] .. " %s. " .. L["RepairConfirm"], _G["FACTION_STANDING_LABEL" .. data], _G["FACTION_STANDING_LABEL" .. addon.db.profile.repairThreshold])
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

-- Below Threshold Warnings --
function addon:WarnToRepair()
	local totalCost, percent, percentMin = addon:GetRepairData()
	if addon.db.profile.warntoRepair and addon.db.profile.warnThreshold >= percentMin * 100 then
    DurrrDialog:Spawn("DurrrWarnToRepair", addon:Colorize(string.format("%d", percentMin * 100), addon:GetThresholdHexColor(percentMin)))
	end
end

function addon:CritWarnToRepair()
	local totalCost, percent, percentMin = addon:GetRepairData()
	if addon.db.profile.critWarntoRepair and addon.db.profile.critWarnThreshold >= percentMin * 100 then
    DurrrDialog:Spawn("DurrrCritWarnToRepair", addon:Colorize(string.format("%d", percentMin * 100), addon:GetThresholdHexColor(percentMin)))
	end
end
-- End Below Threshold Warning --

-- Auto repair - Self --
function addon:AutoRepair()
  if Durrr_canRepair == true then
		RepairAllItems()
		addon:Print(addon:Colorize("[" .. L["AddonName"] .. "]", "green") .. L["RepairedPersonal"] .. " " .. addon:Coins2Str(Durrr_repairAllCost))
	else
		addon:Print(addon:Colorize("["..L["AddonName"].."]", "green") .. L["CardDeclined"] .. " " .. addon:Coins2Str(Durrr_repairAllCost))
  end
end
-- End Auto repair - Self --

-- Auto repair - Guild --
function addon:AutoRepairFromBank()
	local GuildBankWithdrawMoney = GetGuildBankWithdrawMoney()
	local GuildBankMoney = GetGuildBankMoney()
	if GuildBankWithdrawMoney == -1 then
		GuildBankWithdrawMoney = GuildBankMoney
	else
		GuildBankWithdrawMoney = min(GuildBankWithdrawMoney, GuildBankMoney)
	end
	if Durrr_canRepair == true and CanGuildBankRepair() and GuildBankWithdrawMoney >= Durrr_repairAllCost then
		RepairAllItems(1)
		addon:Print(addon:Colorize("["..L["AddonName"].."]", "green") .. L["RepairedGuildFunds"] .. " " .. addon:Coins2Str(Durrr_repairAllCost))
  elseif addon.db.profile.repairFromGuildOnly then
    addon:Print(addon:Colorize("["..L["AddonName"].."]", "green") .. L["NoGuildGold"])
	else
		addon:Print(addon:Colorize("["..L["AddonName"].."]", "green") .. L["NoGuildGoldUsePersonal"])
		addon:AutoRepair()
	end
end
-- End Auto repair - Guild --

-- Repair functions --
function addon:DoRepair()
	if addon.db.profile.repairType == 2 then
		addon:ShowDialog()
	elseif addon.db.profile.repairType == 1 then
		if addon.db.profile.repairFromGuild then
			addon:AutoRepairFromBank()
		else
			addon:AutoRepair()
		end
	end
end
-- End Repair functions --

-- Repair Popup --
function addon:ShowDialog()
	DurrrDialog:Spawn("DurrrDialog")
end
-- End Repair Popup --

-- Show coins with icons --
function addon:Coins2Str(coins)
  local string = ""
  if not coins or coins < 0 then
    return string
  end

  if coins >= 10000 then
		local gold = math.floor(coins / 10000)
		coins = coins - gold * 10000
		string = string .. addon:Colorize(gold, "gold") .. " |TInterface\\MoneyFrame\\UI-GoldIcon.blp:0:0:0:0|t"
	end
	if coins >= 100 then
		local silver = math.floor(coins / 100)
		coins = coins - silver * 100
		string = string .. addon:Colorize(silver, "silver") .. " |TInterface\\MoneyFrame\\UI-SilverIcon.blp:0:0:0:0|t"
	end
	if coins >= 0 then
		string = string .. addon:Colorize(coins, "copper") .. " |TInterface\\MoneyFrame\\UI-CopperIcon.blp:0:0:0:0|t"
	end

	return string
end
-- End Show coins with icons --

-- Data Updates --
function addon:GetRepairData()
	local totalCost = 0
	local percent = 0
	local percentMin = 1

	local total = 0
	local current = 0
	local index, item

	for index, item in pairs(Durrr_slots) do
		local val, max = GetInventoryItemDurability(Durrr_slots[index][Durrr_ID])
		local hasItem, hasCooldown, repairCost = DurrrFrame:SetInventoryItem("player", Durrr_slots[index][Durrr_ID])
		if max then
			if Durrr_vendorState == true then
				repairCost = addon:VendorFix(repairCost)
			end
			total = total + max
			current = current + val
			totalCost = totalCost + repairCost
			Durrr_slots[index][Durrr_VAL] = val
			Durrr_slots[index][Durrr_MAX] = max
			Durrr_slots[index][Durrr_COST] = repairCost
			percent = val / max
			if percent < percentMin then percentMin = percent end
		else
			Durrr_slots[index][Durrr_MAX] = 0
		end
	end

	local bagTotal, bagCurrent = 0, 0
	if addon.db.profile.showBags then
		bagCost = 0;
		for bag = 0, 4 do
			local numSlots = GetContainerNumSlots(bag)
			for slot = 1, numSlots do
				local val, max = GetContainerItemDurability(bag, slot)
				local hasCooldown, repairCost = DurrrFrame:SetBagItem(bag, slot)
				if max then
					if Durrr_vendorState == true then
						repairCost = addon:VendorFix(repairCost)
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
function addon:VendorFix(value)
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
function addon:RepairAttempt()
	Durrr_repairAllCost, Durrr_canRepair = GetRepairAllCost()
	if addon.db.profile.repairType > 0 and Durrr_repairAllCost > 0 then
		local standing = UnitReaction("npc", "player")
		if standing >= addon.db.profile.repairThreshold then
			addon:DoRepair()
		else
			addon:LowRepConfirmation()
		end
	end
end
-- End Checks --

-- Do Colors --
function addon:GetThresholdPercentage(quality, ...)
  local n = select('#', ...)
  if n <= 1 then
    return addon:GetThresholdPercentage(quality, 0, ... or 1)
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

function addon:GetThresholdColor(quality, ...)
  if quality ~= quality then
    return 1, 1, 1
  end

  local percent = addon:GetThresholdPercentage(quality, ...)

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

function addon:GetThresholdHexColor(quality, ...)
	local r, g, b = addon:GetThresholdColor(quality, ...)
	return string.format("%02x%02x%02x", r * 255, g * 255, b * 255)
end
-- End Colors --

-- ########################################################################
-- |  Last Editted By: @file-author@ - @file-date-iso@
-- |  @file-revision@
-- |                                                                      |
-- '-------------------------.oooO----------------------------------------|
--                           (    )     Oooo.
--                            \  (     (    )
--                             \__)     )  /
--                                     (__/
