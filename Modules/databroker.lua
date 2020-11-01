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
local repairIconCoords = {0.28125, 0.5625, 0, 0.5625}
local guildRepairIconCoords = {0.5625, 0.84375, 0, 0.5625}

-- Do LDB stuff --
local DLDB = LibStub("LibDataBroker-1.1")
local DurrrLDB = DLDB:NewDataObject("Durrrability", {
  type = "data source",
  label = L["Durability"],
  text = "",
  icon = "Interface\\MerchantFrame\\UI-Merchant-RepairIcons",
  iconCoords = repairIconCoords,
  OnClick = function(frame, click)
    if click == "RightButton" then
      addon:ShowConfig()
    end
    addon:MainUpdate()
  end,
  OnTooltipShow = function(tooltip)
    if not tooltip or not tooltip.AddLine then return end

    tooltip:AddLine(L["AddonName"] .. " " .. GetAddOnMetadata("Durrrability", "Version"))

    local totalCost, percent, percentMin  = addon:GetRepairData()
    if totalCost <= 0 then
      tooltip:AddLine(" ")
      tooltip:AddLine(L["NoBroke"], 0, 1, 0)
    else
      if addon.db.profile.showDetails then
        tooltip:AddLine(" ")
        for index, item in pairs(Durrr_slots) do
          if item[Durrr_MAX] > 0 and item[Durrr_VAL] < item[Durrr_MAX] then
            local p = item[Durrr_VAL] / item[Durrr_MAX]
            local r, g, b = addon:GetThresholdColor(p)

            tooltip:AddDoubleLine(string.format("%d%%  " .. addon:Colorize("%s", "yellow"), p * 100, item[Durrr_NAME]), addon:Coins2Str(math.floor(item[Durrr_COST])), r, g, b, 1, 1, 1)
          end
        end
        if addon.db.profile.showBags and (bagCost > 0) then
          local r, g, b = addon:GetThresholdColor(bagPercent)

          tooltip:AddDoubleLine(string.format("%d%%  " .. addon:Colorize("Bags", "yellow"), bagPercent * 100), addon:Coins2Str(math.floor(bagCost)), r, g, b, 1, 1, 1)
        end
      end

      tooltip:AddLine(" ")

      local r, g, b = addon:GetThresholdColor(percent)
			tooltip:AddDoubleLine(addon:Colorize(L["Average"] .. " :", "white"), string.format("%d%%", percent * 100), 1, 1, 1, r, g, b)
      local r, g, b = addon:GetThresholdColor(percentMin)
      tooltip:AddDoubleLine(addon:Colorize(L["Lowest"] .. " :", "white"), string.format("%d%%", percentMin * 100), 1, 1, 1, r, g, b)

      tooltip:AddLine(" ")
			tooltip:AddLine(addon:Colorize(L["RepCost"], "white"))
			tooltip:AddDoubleLine(addon:Colorize(_G["FACTION_STANDING_LABEL4"], "yellow"), addon:Coins2Str(math.floor(totalCost)))
			tooltip:AddDoubleLine(addon:Colorize(_G["FACTION_STANDING_LABEL5"], "aaff00"), addon:Coins2Str(math.floor(totalCost*0.95)))
			tooltip:AddDoubleLine(addon:Colorize(_G["FACTION_STANDING_LABEL6"], "55ff00"), addon:Coins2Str(math.floor(totalCost*0.90)))
			tooltip:AddDoubleLine(addon:Colorize(_G["FACTION_STANDING_LABEL7"], "00ff00"), addon:Coins2Str(math.floor(totalCost*0.85)))
			tooltip:AddDoubleLine(addon:Colorize(_G["FACTION_STANDING_LABEL8"], "00ffaa"), addon:Coins2Str(math.floor(totalCost*0.80)))
    end

    tooltip:AddLine(" ")
    local rightClick = (addon:Colorize(L["RightClick"] .. " ", "eda55f") .. L["RightToolTip"])
    tooltip:AddLine(rightClick)
  end,
})

function addon:MainUpdate()
  if Durrr_updateReq then
    Durrr_updateReq = false

    if (Durrr_combatState == true) and (not addon.db.profile.updateInCombat) then
      return
    end

    local totalCost, percent, percentMin  = addon:GetRepairData()

    if percentMin then
      DurrrLDB.text = (string.format(addon:Colorize("%d%%", "%s"), percentMin * 100, addon:GetThresholdHexColor(percentMin)))
    end
  end
end

function addon:UpdateIcon()
	if addon.db.profile.repairFromGuild and (addon.db.profile.repairType == 1) then
		DurrrLDB.iconCoords = guildRepairIconCoords
	else
		DurrrLDB.iconCoords = repairIconCoords
	end
end
-- End LDB stuff --

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
