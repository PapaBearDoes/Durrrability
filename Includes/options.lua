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
Durrrability.options = {
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
            return Durrrability.db.profile.showDetails
          end,
          set = function(key, value)
            Durrrability.db.profile.showDetails = value
            if not Durrrability.db.profile.showDetails then
              Durrrability.db.profile.showAllItemsAlways = value
            end
          end,
        },
        alwaysShow = {
          order = 3,
          type = "toggle",
          name = L["ShowAllItemsAlways"],
          desc = L["ShowAllItemsAlwaysToggle"],
          get = function()
            return Durrrability.db.profile.showAllItemsAlways
          end,
          set = function(key, value)
            Durrrability.db.profile.showAllItemsAlways = value
          end,
          disabled = function()
            return (Durrrability.db.profile.showDetails == false)
          end,
        },
        bags = {
          order = 4,
          type = "toggle",
          name = L["ShowBags"],
          desc = L["ShowBagsToggle"],
          get = function()
            return Durrrability.db.profile.showBags
          end,
          set = function(key, value)
            Durrrability.db.profile.showBags = value
          end,
        },
        showMinimapButton = {
          order = 6,
          type = "toggle",
          name = L["ShowMinimapButton"],
          desc = L["ShowMinimapButtonDesc"],
          get = function()
            if Durrrability.db.profile.mmIcon.hide == true then
              show = false
            else
              show = true
            end
            return show
          end,
          set = function(key, value)
            if value == true then
              Durrrability.db.profile.mmIcon.hide = false
              Durrr_icon:Show(myName .. "_mapIcon")
            else
              Durrrability.db.profile.mmIcon.hide = true
              Durrr_icon:Hide(myName .. "_mapIcon")
            end
          end,
        },
        combat = {
          order = 6,
          type = "toggle",
          name = L["InCombatUpdate"],
          desc = L["InCombatToggle"],
          get = function()
            return Durrrability.db.profile.updateInCombat
          end,
          set = function(key, value)
            Durrrability.db.profile.updateInCombat = value
          end,
        },
        separator2 = {
          type = "header",
          name = L["RepOpts"],
          order = 10,
        },
        factionThreshold = {
					order = 11,
					type = "select",
					style = "dropdown",
					name = L["MinRep"],
					desc = L["MinRepLevel"],
					get = function()
						return Durrrability.db.profile.repairThreshold
					end,
					set = function(key, value)
						Durrrability.db.profile.repairThreshold = value
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
						return Durrrability.db.profile.repairType == 0
					end,
				},
				askEverywhere = {
					order = 12,
					type = "toggle",
          width = "full",
					name = L["AskIfLower"],
					desc = L["LowRepConfirmPop"],
					get = function()
						return Durrrability.db.profile.alwaysAsk
					end,
					set = function(key, value)
						Durrrability.db.profile.alwaysAsk = value
					end,
					disabled = function()
						return Durrrability.db.profile.repairType == 0
					end,
				},
        separator3 = {
          type = "header",
          name = L["RepairOpts"],
          order = 20,
        },
        repairType = {
          order = 21,
          type = "select",
          style = "dropdown",
          name = L["RepairType"],
          desc = L["VendorRepairQuestion"],
          get = function()
            return Durrrability.db.profile.repairType
          end,
          set = function(key, value)
            Durrrability.db.profile.repairType = value
            Durrrability:UpdateIcon()
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
          order = 22,
          type = "toggle",
          width = "full",
          name = L["UseGuildFunds"],
          desc = L["GuildFundsToggle"],
          get = function()
            return Durrrability.db.profile.repairFromGuild
          end,
          set = function(key, value)
            Durrrability.db.profile.repairFromGuild = value
            Durrrability:UpdateIcon()
          end,
          disabled = function()
            return not (Durrrability.db.profile.repairType == 1)
          end,
        },
        repairGuildOnly = {
          order = 23,
          type = "toggle",
          width = "full",
          name = L["OnlyGuildFunds"],
          desc = L["NoGuildGoldToggle"],
          get = function()
            return Durrrability.db.profile.repairFromGuildOnly
          end,
          set = function(key, value)
            Durrrability.db.profile.repairFromGuildOnly = value
          end,
          disabled = function()
            return (Durrrability.db.profile.repairFromGuild == false or (not (Durrrability.db.profile.repairType == 1)))
          end,
        },
				separator4 = {
					type = "header",
					name = L["WarningOpts"],
					order = 30,
				},
				warn = {
					order = 31,
					type = "toggle",
					name = L["CityWarnConf"],
					desc = L["CityWarnToggle"],
					get = function()
						return Durrrability.db.profile.warntoRepair
					end,
					set = function(key, value)
						Durrrability.db.profile.warntoRepair = value
						if (value) then
							Durrrability:RegisterEvent("PLAYER_UPDATE_RESTING", "OnWarnUpdate")
						else
							Durrrability:UnregisterEvent("PLAYER_UPDATE_RESTING")
						end
					end,
				},
				warnThreshold = {
					order = 32,
					type = "range",
					name = L["WarnThreshold"],
					desc = L["WarnMax"],
					min = 0, max = 100, step = 1,
					get = function()
						return Durrrability.db.profile.warnThreshold
					end,
					set = function(key, value)
						Durrrability.db.profile.warnThreshold = value
					end,
        },
        separator5 = {
					type = "header",
					name = L["CritWarningOpts"],
					order = 40,
				},
				critWarn = {
					order = 41,
					type = "toggle",
          width = "full",
					name = L["CritWarnConf"],
					desc = L["CritWarnToggle"],
					get = function()
						return Durrrability.db.profile.critWarntoRepair
					end,
					set = function(key, value)
						Durrrability.db.profile.critWarntoRepair = value
						if (value) then
              Durrrability:RegisterEvent("ZONE_CHANGED", "OnCritWarnUpdate")
              Durrrability:RegisterEvent("ZONE_CHANGED_NEW_AREA", "OnCritWarnUpdate")
						else
              Durrrability:RegisterEvent("ZONE_CHANGED")
              Durrrability:RegisterEvent("ZONE_CHANGED_NEW_AREA")
						end
					end,
				},
				critWarnThreshold = {
					order = 42,
					type = "range",
					name = L["WarnThreshold"],
					desc = L["WarnMax"],
					min = 0, max = 100, step = 1,
					get = function()
						return Durrrability.db.profile.critWarnThreshold
					end,
					set = function(key, value)
						Durrrability.db.profile.critWarnThreshold = value
					end,
        },
        separator6 = {
					type = "header",
					name = "",
					order = 50,
				},
        warnPause = {
          type = "range",
          name = L["WarnPause"],
          desc = L["WarnPauseDesc"],
          order = 51,
          width = "full",
          min = 0,
          max = 30,
          step = 1,
          get = function()
            return Durrrability.db.profile.warnPause
          end,
          set = function(key, value)
            Durrrability.db.profile.warnPause = value
          end,
        },
      },
    },
  },
}
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
