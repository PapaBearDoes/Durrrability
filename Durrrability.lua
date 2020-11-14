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
local me, ns = ...
local addon = LibStub("LibInit"):NewAddon(ns, me, true, "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")
local L = addon:GetLocale()
-- End Imports
--[[ ######################################################################## ]]
--   ## Do All The Things!!!
-- Define Globals
Durrr_globals = {
  enableTasks = {},
  mapIcon = {},
  ID = 6,
  SLOT = 4,
  NAME = 5,
  VAL = 1,
  MAX = 2,
  COST = 3,
  repairAllCost = nil,
  canRepair = false,
  combatState = false,
  vendorState = false,
  updateReq = true,
  slots = {
    {0, 0, 0, "Head", L["Head"], 0},
    {0, 0, 0, "Neck", L["Neck"], 0},
    {0, 0, 0, "Shoulder", L["Shoulder"], 0},
    {0, 0, 0, "Back", L["Back"], 0},
    {0, 0, 0, "Chest", L["Chest"], 0},
    {0, 0, 0, "Wrist", L["Wrist"], 0},
    {0, 0, 0, "Hands", L["Hands"], 0},
    {0, 0, 0, "Waist", L["Waist"], 0},
    {0, 0, 0, "Legs", L["Legs"], 0},
    {0, 0, 0, "Feet", L["Feet"], 0},
    {0, 0, 0, "MainHand", L["MainHand"], 0},
    {0, 0, 0, "SecondaryHand", L["SecondaryHand"], 0},
  },
  repColor = {
    [4] = "yellow",
    [5] = "lime",
    [6] = "00ff88",
    [7] = "00ffcc",
    [8] = "cyan",
  },
}

-- Create any required hidden frames
Durrr_frame = CreateFrame("GameTooltip")
Durrr_frame:SetOwner(WorldFrame, "ANCHOR_NONE")

-- Create DB defaults
Durrr_dbDefaults = {
  profile = {
    showDetails = true,
    showBags = true,
    updateInCombat = false,
    showAllItemsAlways = false,
    repairFromGuild = true,
    repairFromGuildOnly = false,
    repairThreshold = 4,
    showPopup = true,
    repairType = 1,
    alwaysAsk = false,
    warntoRepair = true,
    warnThreshold = 65,
    critWarntoRepair = true,
    critWarnThreshold = 25,
    minimap = {
      hide = true,
      minimapPos = 205,
    },
    moduleEnabledState = {
      ["*"] = true
    }
  }
}

--Create config defaults
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
            if not addon.db.profile.showDetails then
              addon.db.profile.showAllItemsAlways = value
            end
          end,
        },
        alwaysShow = {
          order = 3,
          type = "toggle",
          name = L["ShowAllItemsAlways"],
          desc = L["ShowAllItemsAlwaysToggle"],
          get = function()
            return addon.db.profile.showAllItemsAlways
          end,
          set = function(key, value)
            addon.db.profile.showAllItemsAlways = value
          end,
          disabled = function()
            return (addon.db.profile.showDetails == false)
          end,
        },
        bags = {
          order = 4,
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
        showMinimapButton = {
          order = 6,
          type = "toggle",
          name = L["ShowMinimapButton"],
          desc = L["ShowMinimapButtonDesc"],
          get = function()
            if addon.db.profile.minimap.hide == true then
              show = false
            else
              show = true
            end
            return show
          end,
          set = function(key, value)
            if value == true then
              addon.db.profile.minimap.hide = false
              icon:Show("Durrr_MapIcon")
            else
              addon.db.profile.minimap.hide = true
              icon:Hide("Durrr_MapIcon")
            end
          end,
        },
        combat = {
          order = 6,
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
					order = 12,
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
          order = 22,
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
          order = 23,
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
					order = 30,
				},
				warn = {
					order = 31,
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
					order = 32,
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
					order = 40,
				},
				critWarn = {
					order = 41,
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
					order = 42,
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
--End Globals

function addon:OnInitialize()
  addon.db = LibStub("AceDB-3.0"):New("DurrrabilityDB", Durrr_dbDefaults, "Default")
  if not addon.db then
    local errorDB = L["ErrorDB"]
    print(errorDB)
  end
  addon.db.RegisterCallback(self, "OnProfileChanged", "UpdateProfile")
  addon.db.RegisterCallback(self, "OnProfileCopied", "UpdateProfile")
  addon.db.RegisterCallback(self, "OnProfileReset", "UpdateProfile")

  Durrr_options.args.profile = LibStub("AceDBOptions-3.0"):GetOptionsTable(addon.db)
  LibStub("AceConfig-3.0"):RegisterOptionsTable(me, Durrr_options, nil)

  local i, item
  for i, item in pairs(Durrr_globals.slots) do
    Durrr_globals.slots[i][Durrr_globals.ID] = GetInventorySlotInfo(item[Durrr_globals.SLOT] .. "Slot")
  end

  -- Enable/disable modules based on saved settings
	for name, module in addon:IterateModules() do
		module:SetEnabledState(self.db.profile.moduleEnabledState[name] or false)
    --if module.OnEnable then
      --hooksecurefunc(module, "OnEnable", self.OnModuleEnable_Common) -- Posthook
    --end
  end

  addon:CreateDialogs()

  addon:RegisterEvent("PLAYER_DEAD", "ScheduleUpdate")
	addon:RegisterEvent("PLAYER_UNGHOST", "ScheduleUpdate")
	addon:RegisterEvent("UPDATE_INVENTORY_DURABILITY", "ScheduleUpdate")
	addon:RegisterEvent("PLAYER_REGEN_ENABLED", "OnRestEnable")
	addon:RegisterEvent("PLAYER_REGEN_DISABLED", "OnRestDisable")
	addon:RegisterEvent("MERCHANT_SHOW", "OnVendorShow")
	addon:RegisterEvent("MERCHANT_CLOSED", "OnVendorClose")

  if (addon.db.profile.warntoRepair or addon.db.profile.critWarntoRepair) then
    addon:RegisterEvent("PLAYER_UPDATE_RESTING", "OnWarnUpdate")
    addon:RegisterEvent("ZONE_CHANGED", "OnWarnUpdate")
    addon:RegisterEvent("ZONE_CHANGED_NEW_AREA", "OnWarnUpdate")
    addon:ScheduleTimer("OnWarnUpdate", 5)
  end

  addon:MiniMapIcon()

  addon:UpdateIcon()
  addon:ScheduleUpdate()
end

function addon:MiniMapIcon()
  if icon == nil or not icon then
    icon = LDB and LibStub("LibDBIcon-1.0")
    icon:Register("Durrr_MapIcon", DLDB)
  end
end

function addon:OnEnable()
  local Durrr_Dialog = LibStub("AceConfigDialog-3.0")
  Durrr_optionFrames = {}
  Durrr_optionFrames.general = Durrr_Dialog:AddToBlizOptions("Durrrability", nil, nil, "general")
  Durrr_optionFrames.profile = Durrr_Dialog:AddToBlizOptions("Durrrability", L["Profiles"], "Durrrability", "profile")

  addon:ScheduleRepeatingTimer("MainUpdate", 1)

end

function addon:OnDisable()
end

-- Config window --
function addon:ShowConfig()
	InterfaceOptionsFrame_OpenToCategory(Durrr_optionFrames.profile)
	InterfaceOptionsFrame_OpenToCategory(Durrr_optionFrames.general)
end
-- End Options --

function addon:UpdateOptions()
  LibStub("AceConfigRegistry-3.0"):NotifyChange(me)
end

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
