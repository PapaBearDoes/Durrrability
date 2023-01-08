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
    tooltip:AddLine(L["AddonName"] .. " " .. GetAddOnMetadata("Durrrability", "Version"))

    local totalCost, percent, percentMin  = Durrrability:GetRepairData()
    if Durrrability.db.profile.showAllItemsAlways then
      tooltip:AddLine(" ")
      for index, item in pairs(Durrrability.globals.slots) do
        if totalCost <= 0 then
        end
        local p = item[Durrrability.globals.VAL] / item[Durrrability.globals.MAX]
        if p <= 0 then
          p = 1
        end
        local r, g, b = Durrrability:GetThresholdColor(p)
        tooltip:AddDoubleLine(string.format("%d%%  " .. Durrrability:Colorize("%s", "yellow"), p * 100, item[Durrrability.globals.NAME]), Durrrability:Coins2Str(math.floor(item[Durrrability.globals.COST])), r, g, b, 1, 1, 1)
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
          for index, item in pairs(Durrrability.globals.slots) do
            if item[Durrrability.globals.MAX] > 0 and item[Durrrability.globals.VAL] < item[Durrrability.globals.MAX] then
              local p = item[Durrrability.globals.VAL] / item[Durrrability.globals.MAX]
              local r, g, b = Durrrability:GetThresholdColor(p)
              tooltip:AddDoubleLine(string.format("%d%%  " .. Durrrability:Colorize("%s", "yellow"), p * 100, item[Durrrability.globals.NAME]), Durrrability:Coins2Str(math.floor(item[Durrrability.globals.COST])), r, g, b, 1, 1, 1)
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
  if Durrrability.globals.updateReq then
    Durrrability.globals.updateReq = false
    if (Durrrability.globals.combatState == true) and (not Durrrability.db.profile.updateInCombat) then
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
-- End LDB stuff --

--[[
     ########################################################################
     |  Last Editted By: PapaBearDoes - 2020-11-20T1:53:18Z
     |  fc99a9652fc14b572e08c02facc0d9d8e222317b
     |                                                                      |
     '-------------------------.oooO----------------------------------------|
                              (    )     Oooo.
                              \  (     (    )
                               \__)     )  /
                                       (__/                                   ]]
