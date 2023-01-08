--[[
                                      \\\\///
                                     /       \
                                   (| (.)(.) |)
     .---------------------------.OOOo--()--oOOO.---------------------------.
     |                                                                      |
     |  PapaBearDoes's Durrrability Addon for World of Warcraft
     |  @project-version@
     ######################################################################## ]]
--   ## Let's init this file shall we?
-- Imports
local _G = _G
--Durrr = select(2, ...)
local myName, addon = ...
local Durrrability = addon
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

	for index, item in pairs(Durrrability.db.global.slots) do
		local val, max = GetInventoryItemDurability(Durrrability.db.global.slots[index][Durrrability.db.global.ID])
    if val == nil then val = 1 end
    if max == nil then max = 1 end
    local repairCost = 0
		local data = C_TooltipInfo.GetInventoryItem("player", Durrrability.db.global.slots[index][Durrrability.db.global.ID])
		if data then
      TooltipUtil.SurfaceArgs(data)
			repairCost = data.repairCost
      if max and repairCost then
        if Durrrability.db.global.vendorState == true then
          repairCost = Durrrability:VendorFix(repairCost)
        end
			  total = total + max
        current = current + val
        totalCost = totalCost + repairCost
        Durrrability.db.global.slots[index][Durrrability.db.global.VAL] = val
        Durrrability.db.global.slots[index][Durrrability.db.global.MAX] = max
        Durrrability.db.global.slots[index][Durrrability.db.global.COST] = repairCost
        percent = val / max
        if percent < percentMin then
          percentMin = percent
        end
      end
		else
			Durrrability.db.global.slots[index][Durrrability.db.global.MAX] = 0
		end
	end

  local bagTotal = 0
  local bagCurrent = 0
  local bagCost = 0;
	if Durrrability.db.profile.showBags then
		for bag = 0, 4 do
			local numSlots = C_Container.GetContainerNumSlots(bag)
			for slot = 1, numSlots do
				local val, max = C_Container.GetContainerItemDurability(bag, slot)
        if val == nil then val = 1 end
        if max == nil then max = 1 end
        local repairCost = 0
				local data = C_TooltipInfo.GetBagItem(bag, slot)
				if data then
          TooltipUtil.SurfaceArgs(data)
					repairCost = data.repairCost
        end
        if max and repairCost then
          if Durrrability.db.global.vendorState == true then
            repairCost = Durrrability:VendorFix(repairCost)
          end
          bagTotal = bagTotal + max
          bagCurrent = bagCurrent + val
          bagCost = bagCost + repairCost
          percent = val / max
          if percent < percentMin then
            percentMin = percent
          end
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
  
	return totalCost, percent, percentMin, bagCost
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
     |  Last Editted By: @file-author@ - @file-date-iso@
     |  @file-hash@
     |                                                                      |
     '-------------------------.oooO----------------------------------------|
                              (    )     Oooo.
                              \  (     (    )
                               \__)     )  /
                                       (__/                                   ]]