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
function Durrrability:ScheduleUpdate()
  Durrrability.db.global.updateReq = true
end

function Durrrability:OnVendorShow()
  Durrrability.db.global.vendorState = true
  if not CanMerchantRepair() then
    return
  end
  Durrrability:RepairAttempt()
end

function Durrrability:OnVendorClose()
  local Durrr_Dialog = LibStub("LibDialog-1.0")
  Durrrability.db.global.vendorState = false
  if Durrr_Dialog:ActiveDialog("Durrr_Confirm") then
    Durrr_Dialog:Dismiss("Durrr_Confirm")
  end
  if Durrr_Dialog:ActiveDialog("Durrr_WhoPays") then
    Durrr_Dialog:Dismiss("Durrr_WhoPays")
  end
end

function Durrrability:OnRestEnable()
  Durrrability.db.global.combatState = false
  Durrrability:ScheduleUpdate()
end

function Durrrability:OnRestDisable()
  Durrrability.db.global.combatState = true
end

function Durrrability:OnWarnUpdate()
  if IsResting() then
    if Durrrability.db.global.alreadyWarned == false then
      Durrrability:WarnToRepair()
    end
  end
end

function Durrrability:OnCritWarnUpdate()
  if Durrrability.db.profile.critWarntoRepair then
    if Durrrability.db.global.alreadyWarned == false then
      Durrrability:CritWarnToRepair()
    end
  end
end

function Durrrability:warnTimerReset()
  Durrrability.db.global.alreadyWarned = false
  Durrrability:ScheduleTimer("OnWarnUpdate", 5)
end
-- End Events --
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