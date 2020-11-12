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
local addon = ns
local L = addon:GetLocale()
-- End Imports

--[[ ######################################################################## ]]
--   | Rules:
--   | 1) All variables that need to be referenced across multiple files shall
--   | be defined in the Durrr_globals table and referenced via Durrr_globals.~
--   | 2) All other variables shall be local'd to either the file or function
--   | scopes as appropriate.
--   | 3) When possible, make use of the Durrr_globals.enableTasks table to
--   | pass one off functions that can be handled when AddonEnabled has fired.
--   | 4) Do utilize breakout modules to extend and contain large numbers of
--   | function definitions and name the file appropriately for what those
--   | functions accomplish.
--   | 5) Utilize template.lua for all new files.
--   | 6) Utilize the me, ns, addon variables for all Ace3 functions and
--   | capabilities.
--[[ ######################################################################## ]]
--   ## Do All The Things!!!
function addon:OnInitialize()
  addon.db = LibStub("AceDB-3.0"):New("DurrrabilityDB", Durrr_dbDefaults, "Default")
  if not addon.db then
    local errorDB = L["ErrorDB"]
    print(errorDB)
  end

  addon.db.RegisterCallback(self, "OnProfileChanged", "UpdateProfile")
  addon.db.RegisterCallback(self, "OnProfileCopied", "UpdateProfile")
  addon.db.RegisterCallback(self, "OnProfileReset", "UpdateProfile")

  local i, item
  for i, item in pairs(Durrr_globals.slots) do
    Durrr_globals.slots[i][Durrr_globals.ID] = GetInventorySlotInfo(item[Durrr_globals.SLOT] .. "Slot")
  end

  addon:CreateDialogs()

  addon:RegisterEvent("PLAYER_DEAD", "ScheduleUpdate")
	addon:RegisterEvent("PLAYER_UNGHOST", "ScheduleUpdate")
	addon:RegisterEvent("UPDATE_INVENTORY_DURABILITY", "ScheduleUpdate")
	addon:RegisterEvent("PLAYER_REGEN_ENABLED", "OnRestEnable")
	addon:RegisterEvent("PLAYER_REGEN_DISABLED", "OnRestDisable")
	addon:RegisterEvent("MERCHANT_SHOW", "OnVendorShow")
	addon:RegisterEvent("MERCHANT_CLOSED", "OnVendorClose")

  if (addon.db.profile.warntoRepair or addon.db.profile.critWarntoRepair) then
    addon:RegisterEvent("PLAYER_UPDATE_RESTING", "OnWarnUpdate")
    addon:RegisterEvent("ZONE_CHANGED", "OnWarnUpdate")
    addon:RegisterEvent("ZONE_CHANGED_NEW_AREA", "OnWarnUpdate")
    addon:ScheduleTimer("OnWarnUpdate", 5)
  end

  addon:UpdateIcon()
  addon:ScheduleUpdate()
end

function addon:OnEnable()
  for i, v in ipairs(Durrr_globals.enableTasks) do
    v(self)
  end
  Durrr_globals.enableTasks = nil

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
