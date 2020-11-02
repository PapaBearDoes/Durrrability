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
local Durrr_repairIconCoords = {0.28125, 0.5625, 0, 0.5625}
local Durrr_repairIconCoords = {0.5625, 0.84375, 0, 0.5625}

-- Do LDB stuff --
local DLDB = LibStub("LibDataBroker-1.1")
local Durrr_LDB = DLDB:NewDataObject("Durrrability", {
  type = "data source",
  label = L["Durability"],
  text = "",
  icon = "Interface\\MerchantFrame\\UI-Merchant-RepairIcons",
  iconCoords = Durrr_repairIconCoords,
  OnClick = function(frame, click)
    if click == "RightButton" then
      addon:ShowConfig()
    end
    addon:MainUpdate()
  end,
  OnTooltipShow = function(tooltip)
    if not tooltip or not tooltip.AddLine then return end

    tooltip:AddLine(L["AddonName"] .. " " .. GetAddOnMetadata("Durrrability", "Version"))

    local Durrr_totalCost, Durrr_percent, Durrr_percentMin  = addon:GetRepairData()
    if Durrr_totalCost <= 0 then
      tooltip:AddLine(" ")
      tooltip:AddLine(L["NoBroke"], 0, 1, 0)
    else
      if addon.db.profile.showDetails then
        tooltip:AddLine(" ")
        for Durrr_index, Durrr_item in pairs(Durrr_slots) do
          if Durrr_item[Durrr_MAX] > 0 and Durrr_item[Durrr_VAL] < Durrr_item[Durrr_MAX] then
            local p = Durrr_item[Durrr_VAL] / Durrr_item[Durrr_MAX]
            local r, g, b = addon:GetThresholdColor(p)

            tooltip:AddDoubleLine(string.format("%d%%  " .. addon:Colorize("%s", "yellow"), p * 100, Durrr_item[Durrr_NAME]), addon:Coins2Str(math.floor(Durrr_item[Durrr_COST])), r, g, b, 1, 1, 1)
          end
        end
        if addon.db.profile.showBags and (Durrr_bagCost > 0) then
          local r, g, b = addon:GetThresholdColor(Durrr_bagPercent)

          tooltip:AddDoubleLine(string.format("%d%%  " .. addon:Colorize("Bags", "yellow"), Durrr_bagPercent * 100), addon:Coins2Str(math.floor(Durrr_bagCost)), r, g, b, 1, 1, 1)
        end
      end

      tooltip:AddLine(" ")

      local r, g, b = addon:GetThresholdColor(Durrr_percent)
			tooltip:AddDoubleLine(addon:Colorize(L["Average"] .. " :", "white"), string.format("%d%%", Durrr_percent * 100), 1, 1, 1, r, g, b)
      local r, g, b = addon:GetThresholdColor(Durrr_percentMin)
      tooltip:AddDoubleLine(addon:Colorize(L["Lowest"] .. " :", "white"), string.format("%d%%", Durrr_percentMin * 100), 1, 1, 1, r, g, b)

      tooltip:AddLine(" ")
			tooltip:AddLine(addon:Colorize(L["RepCost"], "white"))
			tooltip:AddDoubleLine(addon:Colorize(_G["FACTION_STANDING_LABEL4"], "yellow"), addon:Coins2Str(math.floor(Durrr_totalCost)))
			tooltip:AddDoubleLine(addon:Colorize(_G["FACTION_STANDING_LABEL5"], "aaff00"), addon:Coins2Str(math.floor(Durrr_totalCost*0.95)))
			tooltip:AddDoubleLine(addon:Colorize(_G["FACTION_STANDING_LABEL6"], "55ff00"), addon:Coins2Str(math.floor(Durrr_totalCost*0.90)))
			tooltip:AddDoubleLine(addon:Colorize(_G["FACTION_STANDING_LABEL7"], "00ff00"), addon:Coins2Str(math.floor(Durrr_totalCost*0.85)))
			tooltip:AddDoubleLine(addon:Colorize(_G["FACTION_STANDING_LABEL8"], "00ffaa"), addon:Coins2Str(math.floor(Durrr_totalCost*0.80)))
    end

    tooltip:AddLine(" ")
    tooltip:AddLine(addon:Colorize(L["RightClick"] .. " ", "eda55f") .. L["RightToolTip"])
  end,
})

function addon:MainUpdate()
  if Durrr_updateReq then
    Durrr_updateReq = false

    if (Durrr_combatState == true) and (not addon.db.profile.updateInCombat) then
      return
    end

    local Durrr_totalCost, Durrr_percent, Durrr_percentMin  = addon:GetRepairData()

    if Durrr_percentMin then
      Durrr_LDB.text = (string.format(addon:Colorize("%d%%", "%s"), Durrr_percentMin * 100, addon:GetThresholdHexColor(Durrr_percentMin)))
    end
  end
end

function addon:UpdateIcon()
	if addon.db.profile.repairFromGuild and (addon.db.profile.repairType == 1) then
		Durrr_LDB.iconCoords = Durrr_repairIconCoords
	else
		Durrr_LDB.iconCoords = Durrr_repairIconCoords
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
