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
local L = l:NewLocale(me, "enUS", true, true)
if not L then return end
-- End Imports
--[[ ######################################################################## ]]
--   ## Do All The Things!!!

L["AddonName"] = "Durrrability"
L["Ask"] = "Ask me"
L["AskIfLower"] = "Ask me for input if lower"
L["AutoRepair"] = "AutoRepair"
L["AutoRepairRequires"] = "Auto repair requires"
L["Average"] = "Average"
L["Back"] = "Back"
L["Cancel"] = "Cancel"
L["CardDeclined"] = "Ahem ... It seems as though your card has been declined... I would love to help, but sadly it seems that you need"
L["Chest"] = "Chest"
L["CityWarn"] = [=[Bruh!!! Your gear is busted!
Your most broken item is at %s percent.

You might want to think about repairing!]=]
L["CityWarnConf"] = "Warn when in city."
L["CityWarnToggle"] = "Toggle to warn you to repair upon entering a city."
L["CritWarn"] = [=[|CFFFF0000Bruh!!! Your gear is critically busted!|r
|CFFFFFF00Your most broken item is at|r %s|CFFFFFF00%%.|r

|CFFFF0000You need to repair!|r]=]
L["CritWarnConf"] = "Warn when critical repair levels reached."
L["CritWarningOpts"] = "Critical Warning Options"
L["CritWarnMax"] = "Set maximum item durability to toggle the warning."
L["CritWarnThreshold"] = "Warning Threshold"
L["CritWarnToggle"] = "Toggle to warn you to repair when critical repair levels have been reached."
L["DisplayOptions"] = "Display Options"
L["DoNothing"] = "Do nothing"
L["Durability"] = "Durrrability"
L["ErrorDB"] = "Error: Database not loaded correctly. Exit WoW and delete Durrrability.lua found in your SavedVariables folder"
L["Feet"] = "Feet"
L["GeneralSettings"] = "General Settings"
L["GuildFundsToggle"] = "Toggle to repair using guild bank."
L["Hands"] = "Hands"
L["Head"] = "Head"
L["InCombatToggle"] = [=[Toggle for in-combat updates.

!!!This *WILL* be CPU intensive if turned on!!!]=]
L["InCombatUpdate"] = "Update in combat."
L["ItWillCost"] = "It will cost %s"
L["Legs"] = "Legs"
L["Lowest"] = "Lowest"
L["LowRepConfirmPop"] = "Pop up a confirmation box for lower reputations."
L["MainHand"] = "MainHand"
L["MinRep"] = "Minimum reputation:"
L["MinRepLevel"] = "Minimum reputation level needed to automatically repair at vendors?"
L["Myself"] = "Myself"
L["Neck"] = "Neck"
L["No"] = "No"
L["NoBroke"] = "Nothing's Broke!"
L["NoGuildGold"] = "It seems that you Guild bank does not have enough money (or you're not allowed to use guild funds)."
L["NoGuildGoldToggle"] = "Toggle to not repair with your money if guild does not have enough."
L["NoGuildGoldUsePersonal"] = "It seems that you Guild bank does not have enough money (or you're not allowed to use guild funds). We'll repair with your funds then."
L["Ok"] = "Ok"
L["OnlyGuildFunds"] = "Only use guild funds."
L["Profiles"] = "Profiles"
L["Ranged"] = "Ranged"
L["RepairConfirm"] = "Do you still want to repair?"
L["RepairedGuildFunds"] = "Your items have been repaired using guild bank for"
L["RepairedPersonal"] = "Your items have been repaired for"
L["RepairOpts"] = "Repair Options"
L["RepairType"] = "Repair type:"
L["RepCost"] = "Your cost based on faction reputation:"
L["RepOpts"] = "Reputation Options"
L["RightClick"] = "Right-Click"
L["RightToolTip"] = "to open the options menu."
L["SecondaryHand"] = "SecondaryHand"
L["Shoulder"] = "Shoulder"
L["ShowAllItemsAlways"] = "Always Show All Items"
L["ShowAllItemsAlwaysToggle"] = "Always show all items in LDB tooltip"
L["ShowAllItemsToggle"] = "Toggle to show detailed item durability."
L["ShowBags"] = "Show bags"
L["ShowBagsToggle"] = "Toggle to show durability for items in bags."
L["ShowEachItem"] = "Show each item."
L["ShowMinimapButton"] = "Show Minimap Button?"
L["ShowMinimapButtonDesc"] = "Shall we show the Minimap Icon?"
L["TheGuild"] = "The Guild"
L["UseGuildFunds"] = "Use guild bank."
L["VendorRepairQuestion"] = "How should Durrrability handle item repairs at vendors?"
L["Waist"] = "Waist"
L["WarningOpts"] = "Warning Options"
L["WarnMax"] = "Set maximum item durability to toggle the warning."
L["WarnPause"] = "Warning Pause"
L["WarnPauseDesc"] = "How long should we pause warnings after acknowledging them?"
L["WarnThreshold"] = "Warning Threshold"
L["WhoPays"] = [=[Who will be paying for the repairs?

It costs %s]=]
L["Wrist"] = "Wrist"
L["Yes"] = "Yes"
L["YourRepIs"] = "Your reputation with this vendor is"



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
