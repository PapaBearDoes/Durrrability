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
local me, ns = ...
local lang = GetLocale()
local l = LibStub("AceLocale-3.0")
local L = l:NewLocale(me, "esES")
if not L then return end
-- End Imports
--[[ ######################################################################## ]]
--   ## Do All The Things!!!

--[[Translation missing --]]
--[[ L["AddonName"] = ""--]] 
--[[Translation missing --]]
--[[ L["Ask"] = ""--]] 
--[[Translation missing --]]
--[[ L["AskIfLower"] = ""--]] 
--[[Translation missing --]]
--[[ L["AutoRepair"] = ""--]] 
--[[Translation missing --]]
--[[ L["AutoRepairRequires"] = ""--]] 
--[[Translation missing --]]
--[[ L["Average"] = ""--]] 
--[[Translation missing --]]
--[[ L["Back"] = ""--]] 
--[[Translation missing --]]
--[[ L["Cancel"] = ""--]] 
--[[Translation missing --]]
--[[ L["CardDeclined"] = ""--]] 
--[[Translation missing --]]
--[[ L["Chest"] = ""--]] 
--[[Translation missing --]]
--[[ L["CityWarn"] = ""--]] 
--[[Translation missing --]]
--[[ L["CityWarnConf"] = ""--]] 
--[[Translation missing --]]
--[[ L["CityWarnToggle"] = ""--]] 
--[[Translation missing --]]
--[[ L["CritWarn"] = ""--]] 
--[[Translation missing --]]
--[[ L["CritWarnConf"] = ""--]] 
--[[Translation missing --]]
--[[ L["CritWarningOpts"] = ""--]] 
--[[Translation missing --]]
--[[ L["CritWarnMax"] = ""--]] 
--[[Translation missing --]]
--[[ L["CritWarnThreshold"] = ""--]] 
--[[Translation missing --]]
--[[ L["CritWarnToggle"] = ""--]] 
--[[Translation missing --]]
--[[ L["DisplayOptions"] = ""--]] 
--[[Translation missing --]]
--[[ L["DoNothing"] = ""--]] 
--[[Translation missing --]]
--[[ L["Durability"] = ""--]] 
--[[Translation missing --]]
--[[ L["ErrorDB"] = ""--]] 
--[[Translation missing --]]
--[[ L["Feet"] = ""--]] 
--[[Translation missing --]]
--[[ L["GeneralSettings"] = ""--]] 
--[[Translation missing --]]
--[[ L["GuildFundsToggle"] = ""--]] 
--[[Translation missing --]]
--[[ L["Hands"] = ""--]] 
--[[Translation missing --]]
--[[ L["Head"] = ""--]] 
--[[Translation missing --]]
--[[ L["InCombatToggle"] = ""--]] 
--[[Translation missing --]]
--[[ L["InCombatUpdate"] = ""--]] 
--[[Translation missing --]]
--[[ L["ItWillCost"] = ""--]] 
--[[Translation missing --]]
--[[ L["Legs"] = ""--]] 
--[[Translation missing --]]
--[[ L["Lowest"] = ""--]] 
--[[Translation missing --]]
--[[ L["LowRepConfirmPop"] = ""--]] 
--[[Translation missing --]]
--[[ L["MainHand"] = ""--]] 
--[[Translation missing --]]
--[[ L["MinRep"] = ""--]] 
--[[Translation missing --]]
--[[ L["MinRepLevel"] = ""--]] 
--[[Translation missing --]]
--[[ L["Myself"] = ""--]] 
--[[Translation missing --]]
--[[ L["Neck"] = ""--]] 
--[[Translation missing --]]
--[[ L["No"] = ""--]] 
--[[Translation missing --]]
--[[ L["NoBroke"] = ""--]] 
--[[Translation missing --]]
--[[ L["NoGuildGold"] = ""--]] 
--[[Translation missing --]]
--[[ L["NoGuildGoldToggle"] = ""--]] 
--[[Translation missing --]]
--[[ L["NoGuildGoldUsePersonal"] = ""--]] 
--[[Translation missing --]]
--[[ L["Ok"] = ""--]] 
--[[Translation missing --]]
--[[ L["OnlyGuildFunds"] = ""--]] 
--[[Translation missing --]]
--[[ L["Profiles"] = ""--]] 
--[[Translation missing --]]
--[[ L["Ranged"] = ""--]] 
--[[Translation missing --]]
--[[ L["RepairConfirm"] = ""--]] 
--[[Translation missing --]]
--[[ L["RepairedGuildFunds"] = ""--]] 
--[[Translation missing --]]
--[[ L["RepairedPersonal"] = ""--]] 
--[[Translation missing --]]
--[[ L["RepairOpts"] = ""--]] 
--[[Translation missing --]]
--[[ L["RepairType"] = ""--]] 
--[[Translation missing --]]
--[[ L["RepCost"] = ""--]] 
--[[Translation missing --]]
--[[ L["RepOpts"] = ""--]] 
--[[Translation missing --]]
--[[ L["RightClick"] = ""--]] 
--[[Translation missing --]]
--[[ L["RightToolTip"] = ""--]] 
--[[Translation missing --]]
--[[ L["SecondaryHand"] = ""--]] 
--[[Translation missing --]]
--[[ L["Shoulder"] = ""--]] 
--[[Translation missing --]]
--[[ L["ShowAllItemsAlways"] = ""--]] 
--[[Translation missing --]]
--[[ L["ShowAllItemsAlwaysToggle"] = ""--]] 
--[[Translation missing --]]
--[[ L["ShowAllItemsToggle"] = ""--]] 
--[[Translation missing --]]
--[[ L["ShowBags"] = ""--]] 
--[[Translation missing --]]
--[[ L["ShowBagsToggle"] = ""--]] 
--[[Translation missing --]]
--[[ L["ShowEachItem"] = ""--]] 
--[[Translation missing --]]
--[[ L["ShowMinimapButton"] = ""--]] 
--[[Translation missing --]]
--[[ L["ShowMinimapButtonDesc"] = ""--]] 
--[[Translation missing --]]
--[[ L["TheGuild"] = ""--]] 
--[[Translation missing --]]
--[[ L["UseGuildFunds"] = ""--]] 
--[[Translation missing --]]
--[[ L["VendorRepairQuestion"] = ""--]] 
--[[Translation missing --]]
--[[ L["Waist"] = ""--]] 
--[[Translation missing --]]
--[[ L["WarningOpts"] = ""--]] 
--[[Translation missing --]]
--[[ L["WarnMax"] = ""--]] 
--[[Translation missing --]]
--[[ L["WarnPause"] = ""--]] 
--[[Translation missing --]]
--[[ L["WarnPauseDesc"] = ""--]] 
--[[Translation missing --]]
--[[ L["WarnThreshold"] = ""--]] 
--[[Translation missing --]]
--[[ L["WhoPays"] = ""--]] 
--[[Translation missing --]]
--[[ L["Wrist"] = ""--]] 
--[[Translation missing --]]
--[[ L["Yes"] = ""--]] 
--[[Translation missing --]]
--[[ L["YourRepIs"] = ""--]] 


--[[
     ########################################################################
     |  Last Editted By: PapaBearDoes - 2020-11-10T18:01:33Z
     |  a6a3d377e451b250ff2c586665cf48d6bed631a9
     |                                                                      |
     '-------------------------.oooO----------------------------------------|
                              (    )     Oooo.
                              \  (     (    )
                               \__)     )  /
                                       (__/                                   ]]
