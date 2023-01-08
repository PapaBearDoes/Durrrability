--[[
                                      \\\\///
                                     /       \
                                   (| (.)(.) |)
     .---------------------------.OOOo--()--oOOO.---------------------------.
     |                                                                      |
     |  PapaBearDoes's Durrrability Addon for World of Warcraft
     ######################################################################## ]]
--   ## Let's init this file shall we?
-- Imports
local _G = _G
--Durrr = select(2, ...)
local me, ns = ...
local Durrrability = ns
local L = Durrrability:GetLocale()
-- End Imports
--[[ ######################################################################## ]]
--   ## Do All The Things!!!
-- Show coins with icons --
function Durrrability:Coins2Str(copper)
  local coins = ""
  if not copper or copper < 0 then
    return coints
  end

  if copper >= 10000 then
		local gold = math.floor(copper / 10000)
		copper = copper - gold * 10000
		coins = coins .. Durrrability:Colorize(gold, "gold") .. " |TInterface\\MoneyFrame\\UI-GoldIcon.blp:0:0:0:0|t"
	end
	if copper >= 100 then
		local silver = math.floor(copper / 100)
		copper = copper - silver * 100
		coins = coins .. Durrrability:Colorize(silver, "silver") .. " |TInterface\\MoneyFrame\\UI-SilverIcon.blp:0:0:0:0|t"
	end
	if copper >= 0 then
		coins = coins .. Durrrability:Colorize(copper, "copper") .. " |TInterface\\MoneyFrame\\UI-CopperIcon.blp:0:0:0:0|t"
	end

	return coins
end
-- End Show coins with icons --

-- Data Updates --
function Durrrability:GetRepairData()
	local totalCost = 0
	local percent = 0
	local percentMin = 1

	local total = 0
	local current = 0
	local index, item

	for index, item in pairs(Durrrability.globals.slots) do
		local val, max = GetInventoryItemDurability(Durrrability.globals.slots[index][Durrrability.globals.ID])
		local hasItem, hasCooldown, repairCost = Durrrability.frame:SetInventoryItem("player", Durrrability.globals.slots[index][Durrrability.globals.ID])
		if max then
			if Durrrability.globals.vendorState == true then
				repairCost = Durrrability:VendorFix(repairCost)
			end
			total = total + max
			current = current + val
			totalCost = totalCost + repairCost
			Durrrability.globals.slots[index][Durrrability.globals.VAL] = val
			Durrrability.globals.slots[index][Durrrability.globals.MAX] = max
			Durrrability.globals.slots[index][Durrrability.globals.COST] = repairCost
			percent = val / max
			if percent < percentMin then
        percentMin = percent
      end
		else
			Durrrability.globals.slots[index][Durrrability.globals.MAX] = 0
		end
	end

	local bagTotal, bagCurrent = 0, 0
	if Durrrability.db.profile.showBags then
		bagCost = 0;
		for bag = 0, 4 do
			local numSlots = GetContainerNumSlots(bag)
			for slot = 1, numSlots do
				local val, max = GetContainerItemDurability(bag, slot)
				local hasCooldown, repairCost = Durrrability.frame:SetBagItem(bag, slot)
				if max then
					if Durrrability.globals.vendorState == true then
						repairCost = Durrrability:VendorFix(repairCost)
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
function Durrrability:VendorFix(value)
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

-- Do Colors --
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

function Durrrability:GetThresholdColor(quality, ...)
  if quality ~= quality then
    return 1, 1, 1
  end

  local percent = Durrrability:GetThresholdPercentage(quality, ...)

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

function Durrrability:GetThresholdHexColor(quality, ...)
	local r, g, b = Durrrability:GetThresholdColor(quality, ...)
	return string.format("%02x%02x%02x", r * 255, g * 255, b * 255)
end
--[[
     ########################################################################
     |  Last Editted By: PapaBearDoes - 2020-11-14T21:29:30Z
     |  e04a0ea10bc01c36fb184f96aaa71582d019138f
     |                                                                      |
     '-------------------------.oooO----------------------------------------|
                              (    )     Oooo.
                              \  (     (    )
                               \__)     )  /
                                       (__/                                   ]]
