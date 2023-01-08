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
local repairIconCoords = {0.28125, 0.5625, 0, 0.5625}
local repairIconCoords = {0.5625, 0.84375, 0, 0.5625}

-- Do LDB stuff --
Durrr_LDB = LibStub("LibDataBroker-1.1")
DLDB = Durrr_LDB:NewDataObject("DurrrLDB", {
  type = "data source",
  label = L["Durability"],
  text = "",
  icon = "Interface\\MerchantFrame\\UI-Merchant-RepairIcons",
  iconCoords = repairIconCoords,
  OnClick = function(frame, click)
    if click == "RightButton" then
      Durrrability:ShowConfig()
    end
    Durrrability:MainUpdate()
  end,
  OnTooltipShow = function(tooltip)
    if not tooltip or not tooltip.AddLine then return end
    tooltip:AddLine(myName .. " " .. GetAddOnMetadata("Durrrability", "Version"))

    local totalCost, percent, percentMin, bagCost  = Durrrability:GetRepairData()
    if Durrrability.db.profile.showAllItemsAlways then
      tooltip:AddLine(" ")
      for index, item in pairs(Durrrability.db.global.slots) do
        if totalCost <= 0 then
        end
        local p = item[Durrrability.db.global.VAL] / item[Durrrability.db.global.MAX]
        if p <= 0 then
          p = 1
        end
        local r, g, b = Durrrability:GetThresholdColor(p)
        tooltip:AddDoubleLine(string.format("%d%%  " .. Durrrability:Colorize("%s", "yellow"), p * 100, item[Durrrability.db.global.NAME]), Durrrability:Coins2Str(math.floor(item[Durrrability.db.global.COST])), r, g, b, 1, 1, 1)
      end
      if Durrrability.db.profile.showBags then
        local r, g, b = Durrrability:GetThresholdColor(bagPercent)
        tooltip:AddDoubleLine(string.format("%d%%  " .. Durrrability:Colorize("Bags", "yellow"), bagPercent * 100), Durrrability:Coins2Str(math.floor(bagCost)), r, g, b, 1, 1, 1)
      end
    else
      if totalCost <= 0 then
        tooltip:AddLine(" ")
        tooltip:AddLine(L["NoBroke"], 0, 1, 0)
      else
        if Durrrability.db.profile.showDetails then
          tooltip:AddLine(" ")
          for index, item in pairs(Durrrability.db.global.slots) do
            if item[Durrrability.db.global.MAX] > 0 and item[Durrrability.db.global.VAL] < item[Durrrability.db.global.MAX] then
              local p = item[Durrrability.db.global.VAL] / item[Durrrability.db.global.MAX]
              local r, g, b = Durrrability:GetThresholdColor(p)
              tooltip:AddDoubleLine(string.format("%d%%  " .. Durrrability:Colorize("%s", "yellow"), p * 100, item[Durrrability.db.global.NAME]), Durrrability:Coins2Str(math.floor(item[Durrrability.db.global.COST])), r, g, b, 1, 1, 1)
            end
          end
          if Durrrability.db.profile.showBags and (bagCost > 0) then
            local r, g, b = Durrrability:GetThresholdColor(bagPercent)
            tooltip:AddDoubleLine(string.format("%d%%  " .. Durrrability:Colorize("Bags", "yellow"), bagPercent * 100), Durrrability:Coins2Str(math.floor(bagCost)), r, g, b, 1, 1, 1)
          end
        end
      end
    end

    tooltip:AddLine(" ")

    local r, g, b = Durrrability:GetThresholdColor(percent)
		tooltip:AddDoubleLine(Durrrability:Colorize(L["Average"] .. " :", "white"), string.format("%d%%", percent * 100), 1, 1, 1, r, g, b)
    local r, g, b = Durrrability:GetThresholdColor(percentMin)
    tooltip:AddDoubleLine(Durrrability:Colorize(L["Lowest"] .. " :", "white"), string.format("%d%%", percentMin * 100), 1, 1, 1, r, g, b)

    tooltip:AddLine(" ")
		tooltip:AddLine(Durrrability:Colorize(L["RepCost"], "white"))
		tooltip:AddDoubleLine(Durrrability:Colorize(_G["FACTION_STANDING_LABEL4"], "yellow"), Durrrability:Coins2Str(math.floor(totalCost)))
		tooltip:AddDoubleLine(Durrrability:Colorize(_G["FACTION_STANDING_LABEL5"], "aaff00"), Durrrability:Coins2Str(math.floor(totalCost*0.95)))
		tooltip:AddDoubleLine(Durrrability:Colorize(_G["FACTION_STANDING_LABEL6"], "55ff00"), Durrrability:Coins2Str(math.floor(totalCost*0.90)))
		tooltip:AddDoubleLine(Durrrability:Colorize(_G["FACTION_STANDING_LABEL7"], "00ff00"), Durrrability:Coins2Str(math.floor(totalCost*0.85)))
		tooltip:AddDoubleLine(Durrrability:Colorize(_G["FACTION_STANDING_LABEL8"], "00ffaa"), Durrrability:Coins2Str(math.floor(totalCost*0.80)))

    tooltip:AddLine(" ")
    tooltip:AddLine(Durrrability:Colorize(L["RightClick"] .. " ", "eda55f") .. L["RightToolTip"])
  end,
})

function Durrrability:MainUpdate()
  if Durrrability.db.global.updateReq then
    Durrrability.db.global.updateReq = false
    if (Durrrability.db.global.combatState == true) and (not Durrrability.db.profile.updateInCombat) then
      return
    end

    local totalCost, percent, percentMin  = Durrrability:GetRepairData()
    if percentMin then
      DLDB.text = (string.format(Durrrability:Colorize("%d%%", "%s"), percentMin * 100, Durrrability:GetThresholdHexColor(percentMin)))
    end
  end
end

function Durrrability:UpdateIcon()
	if Durrrability.db.profile.repairFromGuild and (Durrrability.db.profile.repairType == 1) then
		DLDB.iconCoords = repairIconCoords
	else
		DLDB.iconCoords = repairIconCoords
	end
end

function Durrrability:MiniMapIcon()
  Durrr_icon = LibStub("LibDBIcon-1.0")
  if not Durrr_icon:IsRegistered(myName .. "_mapIcon") then
    Durrr_icon:Register(myName .. "_mapIcon", DLDB, Durrrability.db.profile.mmIcon)
  end
end
-- End LDB stuff --
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