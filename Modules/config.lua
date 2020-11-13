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
tinsert(Durrr_globals.enableTasks, function(self)
  Durrr_options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(addon.db)
  Durrr_options.args.profile.order = -2

  LibStub("AceConfig-3.0"):RegisterOptionsTable(me, Durrr_options, nil)

  local Durrr_Dialog = LibStub("AceConfigDialog-3.0")
  Durrr_optionFrames = {}
  Durrr_optionFrames.general = Durrr_Dialog:AddToBlizOptions("Durrrability", nil, nil, "general")
  Durrr_optionFrames.profile = Durrr_Dialog:AddToBlizOptions("Durrrability", L["Profiles"], "Durrrability", "profile")
end)

-- Config window --
function addon:ShowConfig()
	InterfaceOptionsFrame_OpenToCategory(Durrr_optionFrames.profile)
	InterfaceOptionsFrame_OpenToCategory(Durrr_optionFrames.general)
end
-- End Options --

function addon:UpdateOptions()
  LibStub("AceConfigRegistry-3.0"):NotifyChange(me)
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
