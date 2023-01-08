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
local myName, addon = ...
local durrrabilityInitOptions = {
	profile = "Default",
	noswitch = false,
	nogui = false,
	nohelp = false,
	enhancedProfile = true
}
local Durrrability = LibStub("LibInit"):NewAddon(addon, myName, durrrabilityInitOptions, true)
local L = Durrrability:GetLocale()
-- End Imports
--[[ ######################################################################## ]]
--   ## Do All The Things!!!
function Durrrability:OnInitialize()
  Durrrability.db = LibStub("AceDB-3.0"):New("DurrrabilitySV", Durrrability.dbDefaults, "Default")
  if not Durrrability.db then
    local errorDB = L["ErrorDB"]
    print(errorDB)
  end
  Durrrability.db.RegisterCallback(self, "OnProfileChanged", "UpdateProfile")
  Durrrability.db.RegisterCallback(self, "OnProfileCopied", "UpdateProfile")
  Durrrability.db.RegisterCallback(self, "OnProfileReset", "UpdateProfile")

  Durrrability.options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(Durrrability.db)
  LibStub("AceConfig-3.0"):RegisterOptionsTable(myName, Durrrability.options, nil)

  local i, item
  for i, item in pairs(Durrrability.db.global.slots) do
    Durrrability.db.global.slots[i][Durrrability.db.global.ID] = GetInventorySlotInfo(item[Durrrability.db.global.SLOT] .. "Slot")
  end

  Durrrability:CreateDialogs()

  --Durrrability:RegisterEvent("ADDON_LOADED", "MiniMapIcon")
  Durrrability:RegisterEvent("PLAYER_DEAD", "ScheduleUpdate")
	Durrrability:RegisterEvent("PLAYER_UNGHOST", "ScheduleUpdate")
	Durrrability:RegisterEvent("UPDATE_INVENTORY_DURABILITY", "ScheduleUpdate")
	Durrrability:RegisterEvent("PLAYER_REGEN_ENABLED", "OnRestEnable")
	Durrrability:RegisterEvent("PLAYER_REGEN_DISABLED", "OnRestDisable")
	Durrrability:RegisterEvent("MERCHANT_SHOW", "OnVendorShow")
	Durrrability:RegisterEvent("MERCHANT_CLOSED", "OnVendorClose")

  if Durrrability.db.profile.warntoRepair then
    Durrrability:RegisterEvent("PLAYER_UPDATE_RESTING", "OnWarnUpdate")
		Durrrability:ScheduleTimer("OnWarnUpdate", 5)
	end

	if (Durrrability.db.profile.critWarntoRepair) then
    Durrrability:RegisterEvent("ZONE_CHANGED", "OnCritWarnUpdate")
    Durrrability:RegisterEvent("ZONE_CHANGED_NEW_AREA", "OnCritWarnUpdate")
		Durrrability:ScheduleTimer("OnCritWarnUpdate", 5)
  end

  Durrrability:UpdateIcon()
  Durrrability:ScheduleUpdate()

  Durrrability:MiniMapIcon()
end

function Durrrability:OnEnable()
  local Durrr_Dialog = LibStub("AceConfigDialog-3.0")
  Durrr_OptionFrames = {}
  Durrr_OptionFrames.general = Durrr_Dialog:AddToBlizOptions(myName, nil, nil, L["general"])
  Durrr_OptionFrames.profile = Durrr_Dialog:AddToBlizOptions(myName, L["Profiles"], myName, L["profile"])

  Durrrability:ScheduleRepeatingTimer("MainUpdate", 1)
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