--[[
                                      \\\\///
                                     /       \
                                   (| (.)(.) |)
     .---------------------------.OOOo--()--oOOO.---------------------------.
     |                                                                      |
     |  @file-author@'s Durrrability Addon for World of Warcraft
     ######################################################################## ]]
--   ## Let's init this file shall we?
-- Imports
local _G = _G
--Durrr = select(2, ...)
local me, ns = ...
local addon = ns
local L = addon:GetLocale()
-- End Imports
--[[ ######################################################################## ]]
--   ## Do All The Things!!!
-- Show coins with icons --
function addon:Coins2Str(Durrr_coins)
  local Durrr_string = ""
  if not Durrr_coins or Durrr_coins < 0 then
    return Durrr_string
  end

  if Durrr_coins >= 10000 then
		local Durrr_gold = math.floor(Durrr_coins / 10000)
		Durrr_coins = Durrr_coins - Durrr_gold * 10000
		Durrr_string = Durrr_string .. addon:Colorize(Durrr_gold, "gold") .. " |TInterface\\MoneyFrame\\UI-GoldIcon.blp:0:0:0:0|t"
	end
	if Durrr_coins >= 100 then
		local Durrr_silver = math.floor(Durrr_coins / 100)
		Durrr_coins = Durrr_coins - Durrr_silver * 100
		Durrr_string = Durrr_string .. addon:Colorize(Durrr_silver, "silver") .. " |TInterface\\MoneyFrame\\UI-SilverIcon.blp:0:0:0:0|t"
	end
	if Durrr_coins >= 0 then
		Durrr_string = Durrr_string .. addon:Colorize(Durrr_coins, "copper") .. " |TInterface\\MoneyFrame\\UI-CopperIcon.blp:0:0:0:0|t"
	end

	return Durrr_string
end
-- End Show Durrr_coins with icons --

-- Data Updates --
function addon:GetRepairData()
	local Durrr_totalCost = 0
	local Durrr_percent = 0
	local Durrr_percentMin = 1

	local Durrr_total = 0
	local Durrr_current = 0
	local Durrr_index, Durrr_item

	for Durrr_index, Durrr_item in pairs(Durrr_globals.slots) do
		local Durrr_val, Durrr_max = GetInventoryItemDurability(Durrr_globals.slots[Durrr_index][Durrr_globals.ID])
		local hasItem, hasCooldown, Durrr_repairCost = Durrr_frame:SetInventoryItem("player", Durrr_globals.slots[Durrr_index][Durrr_globals.ID])
		if Durrr_max then
			if Durrr_globals.vendorState == true then
				Durrr_repairCost = addon:VendorFix(repairCost)
			end
			Durrr_total = Durrr_total + Durrr_max
			Durrr_current = Durrr_current + Durrr_val
			Durrr_totalCost = Durrr_totalCost + Durrr_repairCost
			Durrr_globals.slots[Durrr_index][Durrr_globals.VAL] = Durrr_val
			Durrr_globals.slots[Durrr_index][Durrr_globals.MAX] = Durrr_max
			Durrr_globals.slots[Durrr_index][Durrr_globals.COST] = Durrr_repairCost
			Durrr_percent = Durrr_val / Durrr_max
			if Durrr_percent < Durrr_percentMin then Durrr_percentMin = Durrr_percent end
		else
			Durrr_globals.slots[Durrr_index][Durrr_globals.MAX] = 0
		end
	end

	local Durrr_bagTotal, Durrr_bagCurrent = 0, 0
	if addon.db.profile.showBags then
		Durrr_bagCost = 0;
		for Durrr_bag = 0, 4 do
			local Durrr_numSlots = GetContainerNumSlots(Durrr_bag)
			for Durrr_slot = 1, Durrr_numSlots do
				local Durrr_val, Durrr_max = GetContainerItemDurability(Durrr_bag, Durrr_slot)
				local hasCooldown, Durrr_repairCost = Durrr_frame:SetBagItem(Durrr_bag, Durrr_slot)
				if Durrr_max then
					if Durrr_globals.vendorState == true then
						Durrr_repairCost = addon:VendorFix(Durrr_repairCost)
					end
					Durrr_bagTotal = Durrr_bagTotal + Durrr_max
					Durrr_bagCurrent = Durrr_bagCurrent + Durrr_val
					Durrr_bagCost = Durrr_bagCost + Durrr_repairCost
					Durrr_percent = Durrr_val / Durrr_max
					if Durrr_percent < Durrr_percentMin then Durrr_percentMin = Durrr_percent end
				end
			end
		end
		if Durrr_bagTotal > 0 then
			Durrr_bagPercent = Durrr_bagCurrent / Durrr_bagTotal
		else
			Durrr_bagPercent = 1
		end
		Durrr_totalCost = Durrr_totalCost + Durrr_bagCost
	end

	Durrr_current = Durrr_current + Durrr_bagCurrent
	Durrr_total = Durrr_total + Durrr_bagTotal
	if Durrr_total then
		Durrr_percent = Durrr_current/Durrr_total
	end

	return Durrr_totalCost, Durrr_percent, Durrr_percentMin
end
-- End Data Updates --

-- Faction discount --
function addon:VendorFix(Durrr_value)
	local Durrr_standing = UnitReaction("npc", "player")
	if Durrr_standing == 5 then
		Durrr_value = Durrr_value * 100 / 95
	elseif Durrr_standing == 6 then
		Durrr_value = Durrr_value * 10 / 9
	elseif Durrr_standing == 7 then
		Durrr_value = Durrr_value * 100 / 85
	elseif Durrr_standing == 8 then
		Durrr_value = Durrr_value * 10 / 8
	end
	return Durrr_value
end
-- End Faction discount --

-- Do Colors --
function addon:GetThresholdPercentage(Durrr_quality, ...)
  local n = select('#', ...)
  if n <= 1 then
    return addon:GetThresholdPercentage(Durrr_quality, 0, ... or 1)
  end

  local Durrr_worst = ...
  local Durrr_best = select(n, ...)

  if Durrr_worst == Durrr_best and Durrr_quality == Durrr_worst then
    return 0.5
  end

  if Durrr_worst <= Durrr_best then
    if Durrr_quality <= Durrr_worst then
      return 0
    elseif Durrr_quality >= Durrr_best then
      return 1
    end
    local Durrr_last = Durrr_worst
    for i = 2, n - 1 do
      local Durrr_value = select(i, ...)
      if Durrr_quality <= Durrr_value then
        return ((i - 2) + (Durrr_quality - Durrr_last) / (Durrr_value - Durrr_last)) / (n - 1)
      end
      Durrr_last = Durrr_value
    end

    local Durrr_value = select(n, ...)
    return ((n - 2) + (Durrr_quality - Durrr_last) / (Durrr_value - Durrr_last)) / (n - 1)
  else
    if Durrr_quality >= Durrr_worst then
      return 0
    elseif Durrr_quality <= Durrr_best then
      return 1
    end
    local Durrr_last = Durrr_worst
    for i = 2, n - 1 do
      local Durrr_value = select(i, ...)
      if Durrr_quality >= Durrr_value then
        return ((i - 2) + (Durrr_quality - Durrr_last) / (Durrr_value - Durrr_last)) / (n - 1)
      end
      Durrr_last = Durrr_value
    end

    local Durrr_value = select(n, ...)
    return ((n - 2) + (Durrr_quality - Durrr_last) / (Durrr_value - Durrr_last)) / (n - 1)
  end
end

function addon:GetThresholdColor(Durrr_quality, ...)
  if Durrr_quality ~= Durrr_quality then
    return 1, 1, 1
  end

  local Durrr_percent = addon:GetThresholdPercentage(Durrr_quality, ...)

  if Durrr_percent <= 0 then
    return 1, 0, 0
  elseif Durrr_percent <= 0.5 then
    return 1, Durrr_percent * 2, 0
  elseif Durrr_percent >= 1 then
    return 0, 1, 0
  else
    return 2 - Durrr_percent * 2, 1, 0
  end
end

function addon:GetThresholdHexColor(Durrr_quality, ...)
	local r, g, b = addon:GetThresholdColor(Durrr_quality, ...)
	return string.format("%02x%02x%02x", r * 255, g * 255, b * 255)
end
-- End Colors --

--[[
     ########################################################################
     |  Last Editted By: @file-author@ - @file-date-iso@
     |  @file-revision@
     |                                                                      |
     '-------------------------.oooO----------------------------------------|
                              (    )     Oooo.
                              \  (     (    )
                               \__)     )  /
                                       (__/                                   ]]
