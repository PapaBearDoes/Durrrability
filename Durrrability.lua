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
local me, ns = ...
local addon = LibStub("LibInit"):NewAddon(ns, "Durrrability", true, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
local L = addon:GetLocale()
-- End Imports

--[[ ######################################################################## ]]
--   ## Do All The Things!!!
-- Define Globals
Durrr_enableTasks = {}
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
Durrr_frame = CreateFrame("GameTooltip")
Durrr_frame:SetOwner(WorldFrame, "ANCHOR_NONE")
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
local Durrr_dbDefaults = {
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
  addon.db = LibStub("AceDB-3.0"):New("DurrrabilityDB", Durrr_dbDefaults, "Default")
  if not addon.db then
    local Durrr_errorDB = L["ErrorDB"]
    print(Durrr_errorDB)
  end

  addon.db.RegisterCallback(self, "OnProfileChanged", "UpdateProfile")
  addon.db.RegisterCallback(self, "OnProfileCopied", "UpdateProfile")
  addon.db.RegisterCallback(self, "OnProfileReset", "UpdateProfile")

  local Durrr_index, Durrr_item
  for Durrr_index, Durrr_item in pairs(Durrr_slots) do
    Durrr_slots[Durrr_index][Durrr_ID] = GetInventorySlotInfo(Durrr_item[Durrr_SLOT] .. "Slot")
  end

  addon:CreateDialogs()

  addon:RegisterEvent("PLAYER_DEAD", "ScheduleUpdate")
	addon:RegisterEvent("PLAYER_UNGHOST", "ScheduleUpdate")
	addon:RegisterEvent("UPDATE_INVENTORY_DURABILITY", "ScheduleUpdate")
	addon:RegisterEvent("PLAYER_REGEN_ENABLED", "OnRestEnable")
	addon:RegisterEvent("PLAYER_REGEN_DISABLED", "OnRestDisable")
	addon:RegisterEvent("MERCHANT_SHOW", "OnVendorShow")
	addon:RegisterEvent("MERCHANT_CLOSED", "OnVendorClose")
  addon:RegisterEvent("ZONE_CHANGED_NEW_AREA", "OnWarnUpdate")

  if (addon.db.profile.warntoRepair or addon.db.profile.critWarntoRepair) then
    addon:RegisterEvent("PLAYER_UPDATE_RESTING", "OnWarnUpdate")
    addon:RegisterEvent("ZONE_CHANGED_NEW_AREA", "OnWarnUpdate")
    addon:ScheduleTimer("OnWarnUpdate", 5)
  end

  addon:UpdateIcon()
  addon:ScheduleUpdate()

  --LoadModules()
end

function addon:OnEnable()
  for i, v in ipairs(Durrr_enableTasks) do
    v(self)
  end
  Durrr_enableTasks = nil

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
