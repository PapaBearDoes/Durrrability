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
local me, ns = ...
local durrrabilityInitOptions = {
	profile = "Default",
	noswitch = false,
	nogui = false,
	nohelp = false,
	enhancedProfile = true
}
local Durrrability = LibStub("LibInit"):NewAddon(ns, me, durrrabilityInitOptions, true, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0")
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
  LibStub("AceConfig-3.0"):RegisterOptionsTable(me, Durrrability.options, nil)

  -- Enable/disable modules based on saved settings
	for name, module in Durrrability:IterateModules() do
		module:SetEnabledState(Durrrability.db.profile.moduleEnabledState[name] or false)
    if module.OnEnable then
      hooksecurefunc(module, "OnEnable", Durrrability.OnModuleEnable_Common)
    end
  end

  local i, item
  for i, item in pairs(Durrrability.globals.slots) do
    Durrrability.globals.slots[i][Durrrability.globals.ID] = GetInventorySlotInfo(item[Durrrability.globals.SLOT] .. "Slot")
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

function Durrrability:OnModuleEnable_Common()
end

function Durrrability:MiniMapIcon()
  Durrr_icon = LibStub("LibDBIcon-1.0")
  if not Durrr_icon:IsRegistered(me .. "_mapIcon") then
    Durrr_icon:Register(me .. "_mapIcon", DLDB, Durrrability.db.profile.mmIcon)
  end
end

function Durrrability:OnEnable()
  local Durrr_Dialog = LibStub("AceConfigDialog-3.0")
  Durrr_OptionFrames = {}
  Durrr_OptionFrames.general = Durrr_Dialog:AddToBlizOptions("Durrrability", nil, nil, "general")
  Durrr_OptionFrames.profile = Durrr_Dialog:AddToBlizOptions("Durrrability", L["Profiles"], "Durrrability", "profile")

  Durrrability:ScheduleRepeatingTimer("MainUpdate", 1)
end

function Durrrability:OnDisable()
end

-- Config window --
function Durrrability:ShowConfig()
	InterfaceOptionsFrame_OpenToCategory(Durrr_OptionFrames.profile)
	InterfaceOptionsFrame_OpenToCategory(Durrr_OptionFrames.general)
end
-- End Options --

function Durrrability:UpdateOptions()
  LibStub("AceConfigRegistry-3.0"):NotifyChange(me)
end

function Durrrability:UpdateProfile()
  Durrrability:ScheduleTimer("UpdateProfileDelayed", 0)
end

function Durrrability:OnProfileChanged(event, database, newProfileKey)
  Durrrability.db.profile = database.profile
end

function Durrrability:UpdateProfileDelayed()
  for timerKey, timerValue in Durrrability:IterateModules() do
    if timerValue.db.profile.on then
      if timerValue:IsEnabled() then
        timerValue:Disable()
        timerValue:Enable()
      else
        timerValue:Enable()
      end
    else
      timerValue:Disable()
    end
  end

  Durrrability:UpdateOptions()
end

function Durrrability:OnProfileReset()
end

--[[
     ########################################################################
     |  Last Editted By: PapaBearDoes - 2020-12-09T22:42:31Z
     |  a7f3efb405ed0a7f2093c28fae666ca86e8610d6
     |                                                                      |
     '-------------------------.oooO----------------------------------------|
                              (    )     Oooo.
                              \  (     (    )
                               \__)     )  /
                                       (__/                                   ]]
