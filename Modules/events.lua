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
local Durrrability = ns
local L = Durrrability:GetLocale()
-- End Imports
--[[ ######################################################################## ]]
--   ## Do All The Things!!!
function Durrrability:ScheduleUpdate()
  if (Durrrability.db.profile.critWarntoRepair) then
    Durrrability:WarnToRepair()
  end
  Durrrability.globals.updateReq = true
end

function Durrrability:OnVendorShow()
  Durrrability.globals.vendorState = true
  if not CanMerchantRepair() then
    return
  end
  Durrrability:RepairAttempt()
end

function Durrrability:OnVendorClose()
  local Durrr_Dialog = LibStub("LibDialog-1.0")
  Durrrability.globals.vendorState = false
  if Durrr_Dialog:ActiveDialog("Durrr_Confirm") then
    Durrr_Dialog:Dismiss("Durrr_Confirm")
  end
  if Durrr_Dialog:ActiveDialog("Durrr_WhoPays") then
    Durrr_Dialog:Dismiss("Durrr_WhoPays")
  end
end

function Durrrability:OnRestEnable()
  Durrrability.globals.combatState = false
  Durrrability:ScheduleUpdate()
end

function Durrrability:OnRestDisable()
  Durrrability.globals.combatState = true
end

function Durrrability:OnWarnUpdate()
  if IsResting() then
    Durrrability:WarnToRepair()
  elseif (Durrrability.db.profile.critWarntoRepair) then
    Durrrability:WarnToRepair()
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
