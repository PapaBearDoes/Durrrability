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
-- End Imports

--[[ ######################################################################## ]]
--   ## Do All The Things!!!
local addon = LibStub("LibInit"):NewAddon(ns, "Durrrability", true, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
local L = addon:GetLocale()

enableTasks = {}

Durrr_ID = 6
Durrr_SLOT = 4
Durrr_NAME = 5
Durrr_VAL = 1
Durrr_MAX = 2
Durrr_COST = 3
Durrr_repairAllCost = nil
Durrr_canRepair = nil
Durrr_bagsCost = 0
Durrr_bagsPercent = 0
Durrr_combatState = false
Durrr_vendorState = false
Durrr_updateReq = true
Durrr_slots = {
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

DurrrFrame = CreateFrame("GameTooltip")
DurrrFrame:SetOwner(WorldFrame, "ANCHOR_NONE")

local defaults = {
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
    modules = {
      ["*"] = 3
    }
  }
}

function addon:OnInitialize()
  addon.db = LibStub("AceDB-3.0"):New("DurrrabilityDB", defaults, "Default")
  if not addon.db then
    local errorDB = L["ErrorDB"]
    print(errorDB)
  end

  addon.db.RegisterCallback(self, "OnProfileChanged", "UpdateProfile")
  addon.db.RegisterCallback(self, "OnProfileCopied", "UpdateProfile")
  addon.db.RegisterCallback(self, "OnProfileReset", "UpdateProfile")

  local index, item
  for index, item in pairs(Durrr_slots) do
    Durrr_slots[index][Durrr_ID] = GetInventorySlotInfo(item[Durrr_SLOT] .. "Slot")
  end

  addon:CreateDialogs()

  addon:RegisterEvent("PLAYER_DEAD", "ScheduleUpdate")
	addon:RegisterEvent("PLAYER_UNGHOST", "ScheduleUpdate")
	addon:RegisterEvent("UPDATE_INVENTORY_DURABILITY", "ScheduleUpdate")
	addon:RegisterEvent("PLAYER_REGEN_ENABLED", "OnRestEnable")
	addon:RegisterEvent("PLAYER_REGEN_DISABLED", "OnRestDisable")
	addon:RegisterEvent("MERCHANT_SHOW", "OnVendorShow")
	addon:RegisterEvent("MERCHANT_CLOSED", "OnVendorClose")
  addon:RegisterEvent("ZONE_CHANGED", "OnCritUpdate")
  addon:RegisterEvent("ZONE_CHANGED_INDOORS", "OnCritUpdate")
  addon:RegisterEvent("ZONE_CHANGED_NEW_AREA", "OnCritUpdate")

  if (addon.db.profile.warntoRepair) then
    addon:RegisterEvent("PLAYER_UPDATE_RESTING", "OnRestUpdate")
    addon:ScheduleTimer("OnRestUpdate", 5)
  end
-- Figure out this timer thing!!!!
  if (addon.db.profile.critWarntoRepair) then
    addon:RegisterEvent("ZONE_CHANGED", "OnCritUpdate")
    addon:RegisterEvent("ZONE_CHANGED_INDOORS", "OnCritUpdate")
    addon:RegisterEvent("ZONE_CHANGED_NEW_AREA", "OnCritUpdate")
    addon:ScheduleTimer("OnCritUpdate", 5)
  end

  addon:UpdateIcon()
  addon:ScheduleUpdate()

  --LoadModules()
end

function addon:OnEnable()
  for i, v in ipairs(enableTasks) do
    v(self)
  end
  EnableTasks = nil

  addon:ScheduleRepeatingTimer("MainUpdate", 1)
end

function addon:OnDisable()
end

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
