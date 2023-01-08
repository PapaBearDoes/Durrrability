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
local myName, addon = ...
local L = LibStub("AceLocale-3.0"):NewLocale(myName, "frFR")
local L = L or {}
-- End Imports
--[[ ######################################################################## ]]
--[[
L["Phrase"] = "Translation"
L["Phrase"] = true
L["SubNameSpace"] = {
  L["Phrase"] = "Translation"
  L["Phrase"] = true
}
]]
--[[ ######################################################################## ]]
--   ## Do All The Things!!!
-- frFR Localization
--@localization(locale="frFR", format="lua_additive_table", same-key-is-true=true, handle-subnamespaces="subtable")@

L["AddonName"] = "Durrrability"
L["Ask"] = "Demandez-moi"
--[[Translation missing --]]
--[[ L["AskIfLower"] = ""--]] 
L["AutoRepair"] = "Réparation automatique"
--[[Translation missing --]]
--[[ L["AutoRepairRequires"] = ""--]] 
L["Average"] = "Moyenne"
L["Back"] = "Dos"
L["Cancel"] = "Annuler"
L["CardDeclined"] = "Euh ... Il semble que votre carte ait été refusée ... J'adorerais vous aider, mais malheureusement, il semble que vous ayez besoin"
L["Chest"] = "Torse"
L["CityWarn"] = "Votre équipement est cassé ! Votre objet le plus cassé est à %s. Vous voudrez peut-être penser à réparer !"
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
     |  Last Editted By: @file-author@ - @file-date-iso@
     |  @file-hash@
     |                                                                      |
     '-------------------------.oooO----------------------------------------|
                              (    )     Oooo.
                              \  (     (    )
                               \__)     )  /
                                       (__/                                   ]]