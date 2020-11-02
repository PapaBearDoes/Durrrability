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
function addon:UpdateProfile()
  addon:ScheduleTimer("UpdateProfileDelayed", 0)
end

function addon:OnProfileChanged(event, database, newProfileKey)
  addon.db.profile = database.profile
end

function addon:UpdateProfileDelayed()
  for timerKey, timerValue in addon:IterateModules() do
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

  addon:UpdateOptions()
end

function addon:OnProfileReset()
end

-- Events --
function addon:ScheduleUpdate()
  if (addon.db.profile.critWarntoRepair) then
    addon:WarnToRepair()
  end
  Durrr_globals.updateReq = true
end

function addon:OnVendorShow()
  Durrr_globals.vendorState = true
  if not CanMerchantRepair() then
    return
  end
  addon:RepairAttempt()
end

function addon:OnVendorClose()
  local Durrr_Dialog = LibStub("LibDialog-1.0")
  Durrr_globals.vendorState = false
  if Durrr_Dialog:ActiveDialog("Durrr_Confirm") then
    Durrr_Dialog:Dismiss("Durrr_Confirm")
  end
  if Durrr_Dialog:ActiveDialog("Durrr_WhoPays") then
    Durrr_Dialog:Dismiss("Durrr_WhoPays")
  end
end

function addon:OnRestEnable()
  Durrr_globals.combatState = false
  addon:ScheduleUpdate()
end

function addon:OnRestDisable()
  Durrr_globals.combatState = true
end

function addon:OnWarnUpdate()
  if IsResting() then
    addon:WarnToRepair()
  elseif (addon.db.profile.critWarntoRepair) then
    addon:WarnToRepair()
  end
end
-- End Events --

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
