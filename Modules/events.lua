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
  for Durrr_timerKey, Durrr_timerValue in addon:IterateModules() do
    if Durrr_timerValue.db.profile.on then
      if Durrr_timerValue:IsEnabled() then
        Durrr_timerValue:Disable()
        Durrr_timerValue:Enable()
      else
        Durrr_timerValue:Enable()
      end
    else
      Durrr_timerValue:Disable()
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
  Durrr_updateReq = true
end

function addon:OnVendorShow()
  Durrr_vendorState = true
  if not CanMerchantRepair() then
    return
  end
  addon:RepairAttempt()
end

function addon:OnVendorClose()
  Durrr_vendorState = false
  if Durrr_Dialog:ActiveDialog("Durrr_Confirm") then
    Durrr_Dialog:Dismiss("Durrr_Confirm")
  end
  if Durrr_Dialog:ActiveDialog("Durrr_Dialog") then
    Durrr_Dialog:Dismiss("Durrr_Dialog")
  end
end

function addon:OnRestEnable()
  Durrr_combatState = false
  addon:ScheduleUpdate()
end

function addon:OnRestDisable()
  Durrr_combatState = true
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
