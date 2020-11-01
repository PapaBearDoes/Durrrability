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
local me, ns = ...
local lang = GetLocale()
local l = LibStub("AceLocale-3.0")
local L = l:NewLocale(me, "enUS", true, true)
if not L then return end
-- End Imports
--[[ ######################################################################## ]]
--   ## Do All The Things!!!

--@localization(locale="enUS", format="lua_additive_table")@

--@do-not-package@
L["AddonName"] = "Durrrability"
L["Ask"] = "Ask me"
L["AutoRepair"] = "AutoRepair"
L["Average"] = "Average"
L["Cancel"] = "Cancel"
L["DoNothing"] = "Do nothing"
L["Durability"] = "Durrrability"
L["Lowest"] = "Lowest"
L["Myself"] = "Myself"
L["No"] = "No"
L["Ok"] = "Ok"
L["Profiles"] = "Profiles"
L["Ranged"] = "Ranged"
L["RightClick"] = "Right-Click"
L["Yes"] = "Yes"
L["AskIfLower"] = "Ask me for input if lower"
L["CityWarnConf"] = "Warn when in city."
L["CityWarnToggle"] = "Toggle to warn you to repair upon entering a city."
L["CritWarningOpts"] = "Critical Warning Options"
L["CritWarnConf"] = "Warn when critical repair levels reached."
L["CritWarnToggle"] = "Toggle to warn you to repair when critical repair levels have been reached."
L["CritWarnMax"] = "Set maximum item durability to toggle the warning."
L["CritWarnThreshold"] = "Warning Threshold"
L["CritWarn"] = "Bruh!!! Your gear is busted! Your most broken item is at %s Durrr_percent. You might want to think about repairing!"
L["DisplayOptions"] = "Display Options"
L["GeneralSettings"] = "General Settings"
L["GuildFundsToggle"] = "Toggle to repair using guild bank."
L["InCombatToggle"] = "Toggle for in-combat updates !!!This *WILL* be CPU intensive if turned on!!!"
L["InCombatUpdate"] = "Update in combat."
L["LowRepConfirmPop"] = "Pop up a confirmation box for lower reputations."
L["MinRep"] = "Minimum reputation:"
L["MinRepLevel"] = "Minimum reputation level needed to automatically repair at vendors?"
L["NoGuildGoldToggle"] = "Toggle to not repair with your money if guild does not have enough."
L["OnlyGuildFunds"] = "Only use guild funds."
L["RepairOpts"] = "Repair Options"
L["RepairType"] = "Repair type:"
L["RepOpts"] = "Reputation Options"
L["RightToolTip"] = "to open the options menu."
L["ShowAllItemsToggle"] = "Toggle to show detailed item durability."
L["ShowBags"] = "Show bags"
L["ShowBagsToggle"] = "Toggle to show durability for items in bags."
L["ShowEachItem"] = "Show each item."
L["UseGuildFunds"] = "Use guild bank."
L["VendorRepairQuestion"] = "How should Durrrability handle item repairs at vendors?"
L["WarningOpts"] = "Warning Options"
L["WarnMax"] = "Set maximum item durability to toggle the warning."
L["WarnThreshold"] = "Warning Threshold"
L["AutoRepairRequires"] = "Auto repair requires"
L["CardDeclined"] = "Ahem ... It seems as though your card has been declined... I would love to help, but sadly it seems that you need"
L["CityWarn"] = "Bruh!!! Your gear is busted! Your most broken item is at %s Durrr_percent. You might want to think about repairing!"
L["ErrorDB"] = "Error: Database not loaded correctly. Exit WoW and delete Durrrability.lua found in your SavedVariables folder"
L["NoBroke"] = "Nothing's Broke!"
L["NoGuildGold"] = "It seems that you Guild bank does not have enough money (or you're not allowed to use guild funds)."
L["NoGuildGoldUsePersonal"] = "It seems that you Guild bank does not have enough money (or you're not allowed to use guild funds). We'll repair with your funds then."
L["RepairConfirm"] = "Do you still want to repair?"
L["RepairedGuildFunds"] = "Your items have been repaired using guild bank for"
L["RepairedPersonal"] = "Your items have been repaired for"
L["RepCost"] = "Your cost based on faction reputation:"
L["TheGuild"] = "The Guild"
L["WhoPays"] = "Who will be paying for the repairs? It costs %s"
L["YourRepIs"] = "Your reputation with this vendor is"
L["Back"] = "Back"
L["Chest"] = "Chest"
L["Feet"] = "Feet"
L["Hands"] = "Hands"
L["Head"] = "Head"
L["Legs"] = "Legs"
L["MainHand"] = "MainHand"
L["Neck"] = "Neck"
L["SecondaryHand"] = "SecondaryHand"
L["Shoulder"] = "Shoulder"
L["Waist"] = "Waist"
L["Wrist"] = "Wrist"
--@end-do-not-package@

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
