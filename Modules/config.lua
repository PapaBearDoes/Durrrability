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
Durrr_options = {
  type = "group",
  name = "Durrrability",
  args = {
    general = {
      order = 1,
      type = "group",
      name = L["GeneralSettings"],
      cmdInline = true,
      args = {
        separator1 = {
          type = "header",
          name = L["DisplayOptions"],
          order = 1,
        },
        details = {
          order = 2,
          type = "toggle",
          name = L["ShowEachItem"],
          desc = L["ShowAllItemsToggle"],
          get = function()
            return addon.db.profile.showDetails
          end,
          set = function(key, value)
            addon.db.profile.showDetails = value
          end,
        },
        bags = {
          order = 3,
          type = "toggle",
          name = L["ShowBags"],
          desc = L["ShowBagsToggle"],
          get = function()
            return addon.db.profile.showBags
          end,
          set = function(key, value)
            addon.db.profile.showBags = value
          end,
        },
        combat = {
          order = 4,
          type = "toggle",
          name = L["InCombatUpdate"],
          desc = L["InCombatToggle"],
          get = function()
            return addon.db.profile.updateInCombat
          end,
          set = function(key, value)
            addon.db.profile.updateInCombat = value
          end,
        },
        separator3 = {
          type = "header",
          name = L["RepOpts"],
          order = 5,
        },
        factionThreshold = {
					order = 6,
					type = "select",
					style = "dropdown",
					name = L["MinRep"],
					desc = L["MinRepLevel"],
					get = function()
						return addon.db.profile.repairThreshold
					end,
					set = function(key, value)
						addon.db.profile.repairThreshold = value
					end,
					values = function()
						return {
							[4] = _G["FACTION_STANDING_LABEL4"],
							[5] = _G["FACTION_STANDING_LABEL5"],
							[6] = _G["FACTION_STANDING_LABEL6"],
							[7] = _G["FACTION_STANDING_LABEL7"],
							[8] = _G["FACTION_STANDING_LABEL8"],
						}
					end,
					disabled = function()
						return addon.db.profile.repairType == 0
					end,
				},
				askEverywhere = {
					order = 7,
					type = "toggle",
          width = "full",
					name = L["AskIfLower"],
					desc = L["LowRepConfirmPop"],
					get = function()
						return addon.db.profile.alwaysAsk
					end,
					set = function(key, value)
						addon.db.profile.alwaysAsk = value
					end,
					disabled = function()
						return addon.db.profile.repairType == 0
					end,
				},
        separator2 = {
          type = "header",
          name = L["RepairOpts"],
          order = 8,
        },
        repairType = {
          order = 9,
          type = "select",
          style = "dropdown",
          name = L["RepairType"],
          desc = L["VendorRepairQuestion"],
          get = function()
            return addon.db.profile.repairType
          end,
          set = function(key, value)
            addon.db.profile.repairType = value
            addon:UpdateIcon()
          end,
          values = function()
            return {
              [0] = L["DoNothing"],
              [1] = L["AutoRepair"],
              [2] = L["Ask"],
            }
          end,
        },
        repairGuild = {
          order = 10,
          type = "toggle",
          width = "full",
          name = L["UseGuildFunds"],
          desc = L["GuildFundsToggle"],
          get = function()
            return addon.db.profile.repairFromGuild
          end,
          set = function(key, value)
            addon.db.profile.repairFromGuild = value
            addon:UpdateIcon()
          end,
          disabled = function()
            return not (addon.db.profile.repairType == 1)
          end,
        },
        repairGuildOnly = {
          order = 11,
          type = "toggle",
          width = "full",
          name = L["OnlyGuildFunds"],
          desc = L["NoGuildGoldToggle"],
          get = function()
            return addon.db.profile.repairFromGuildOnly
          end,
          set = function(key, value)
            addon.db.profile.repairFromGuildOnly = value
          end,
          disabled = function()
            return (addon.db.profile.repairFromGuild == false or (not (addon.db.profile.repairType == 1)))
          end,
        },
				separator4 = {
					type = "header",
					name = L["WarningOpts"],
					order = 12,
				},
				warn = {
					order = 13,
					type = "toggle",
					name = L["CityWarnConf"],
					desc = L["CityWarnToggle"],
					get = function()
						return addon.db.profile.warntoRepair
					end,
					set = function(key, value)
						addon.db.profile.warntoRepair = value
						if (value) then
							addon:RegisterEvent("PLAYER_UPDATE_RESTING", "OnWarnUpdate")
						else
							addon:UnregisterEvent("PLAYER_UPDATE_RESTING")
						end
					end,
				},
				warnThreshold = {
					order = 14,
					type = "range",
					name = L["WarnThreshold"],
					desc = L["WarnMax"],
					min = 0, max = 100, step = 1,
					get = function()
						return addon.db.profile.warnThreshold
					end,
					set = function(key, value)
						addon.db.profile.warnThreshold = value
					end,
        },
        separator5 = {
					type = "header",
					name = L["CritWarningOpts"],
					order = 15,
				},
				critWarn = {
					order = 16,
					type = "toggle",
          width = "full",
					name = L["CritWarnConf"],
					desc = L["CritWarnToggle"],
					get = function()
						return addon.db.profile.critWarntoRepair
					end,
					set = function(key, value)
						addon.db.profile.critWarntoRepair = value
						if (value) then
              addon:RegisterEvent("ZONE_CHANGED", "OnWarnUpdate")
              addon:RegisterEvent("ZONE_CHANGED_NEW_AREA", "OnWarnUpdate")
						else
              addon:RegisterEvent("ZONE_CHANGED")
              addon:RegisterEvent("ZONE_CHANGED_NEW_AREA")
						end
					end,
				},
				critWarnThreshold = {
					order = 17,
					type = "range",
					name = L["WarnThreshold"],
					desc = L["WarnMax"],
					min = 0, max = 100, step = 1,
					get = function()
						return addon.db.profile.critWarnThreshold
					end,
					set = function(key, value)
						addon.db.profile.critWarnThreshold = value
					end,
        },
      },
    },
  },
}

tinsert(Durrr_enableTasks, function(self)
  Durrr_options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(addon.db)
  Durrr_options.args.profile.order = -2

  LibStub("AceConfig-3.0"):RegisterOptionsTable("Durrrability", Durrr_options, nil)

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
  LibStub("AceConfigRegistry-3.0"):NotifyChange("Durrrability")
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
