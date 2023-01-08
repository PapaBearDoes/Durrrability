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
--Durrr = select(2, ...)
local me, ns = ...
local Durrrability = ns
local L = Durrrability:GetLocale()
-- End Imports
--[[ ######################################################################## ]]
--   ## Do All The Things!!!
Durrrability.globals = {
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
  alreadyWarned = false,
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
Durrrability.frame = CreateFrame("GameTooltip")
Durrrability.frame:SetOwner(WorldFrame, "ANCHOR_NONE")

-- Create DB defaults
Durrrability.dbDefaults = {
  global = {
  },
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
    warnPause = 5,
    moduleEnabledState = {
      ["*"] = true
    },
    mmIcon = {
      hide = false,
      minimapPos = 205,
    },
  }
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
