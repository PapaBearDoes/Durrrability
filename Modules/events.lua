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
    addon:CritWarnToRepair()
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
  if DurrrDialog:ActiveDialog("DurrrConfirm") then
    DurrrDialog:Dismiss("DurrrConfirm")
  end
  if DurrrDialog:ActiveDialog("DurrrDialog") then
    DurrrDialog:Dismiss("DurrrDialog")
  end
end

function addon:OnRestEnable()
  Durrr_combatState = false
  if (addon.db.profile.critWarntoRepair) then
    addon:CritWarnToRepair()
  end
  addon:ScheduleUpdate()
end

function addon:OnRestDisable()
  Durrr_combatState = true
end

function addon:OnRestUpdate()
  if IsResting() then
    addon:WarnToRepair()
  elseif (addon.db.profile.critWarntoRepair) then
    addon:CritWarnToRepair()
  end
end

function addon:OnCritUpdate()
  if (addon.db.profile.critWarntoRepair) then
    addon:CritWarnToRepair()
  end
  addon:ScheduleUpdate()
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
