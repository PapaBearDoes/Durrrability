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
local L = LibStub("AceLocale-3.0"):NewLocale(myName, "enUS", true)
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
-- enUS Localization
--@localization(locale="enUS", format="lua_additive_table", same-key-is-true=true, handle-subnamespaces="subtable")@

L["Ask"] = "Ask me"
L["AskIfLower"] = "Ask me for input if lower"
L["AutoRepair"] = true
L["AutoRepairRequires"] = "Auto repair requires"
L["Average"] = true
L["Back"] = true
L["Cancel"] = true
L["CardDeclined"] = "Ahem ... It seems as though your card has been declined ... I would love to help, but sadly it seems that you need more funds."
L["Chest"] = true
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
L["Feet"] = true
L["GeneralSettings"] = "General Settings"
L["GuildFundsToggle"] = "Toggle to repair using guild bank."
L["Hands"] = true
L["Head"] = true
L["InCombatToggle"] = [=[Toggle for in-combat updates.

!!!This *WILL* be CPU intensive if turned on!!!]=]
L["InCombatUpdate"] = "Update in combat."
L["ItWillCost"] = "It will cost %s"
L["Legs"] = true
L["Lowest"] = true
L["LowRepConfirmPop"] = "Pop up a confirmation box for lower reputations."
L["MainHand"] = true
L["MinRep"] = "Minimum reputation:"
L["MinRepLevel"] = "Minimum reputation level needed to automatically repair at vendors?"
L["Myself"] = true
L["Neck"] = true
L["No"] = true
L["NoBroke"] = "Nothing's Broke!"
L["NoGuildGold"] = "It seems that you Guild bank does not have enough money (or you're not allowed to use guild funds)."
L["NoGuildGoldToggle"] = "Toggle to not repair with your money if guild does not have enough."
L["NoGuildGoldUsePersonal"] = "It seems that you Guild bank does not have enough money (or you're not allowed to use guild funds). We'll repair with your funds then."
L["Ok"] = true
L["OnlyGuildFunds"] = "Only use guild funds."
L["Profiles"] = true
L["Ranged"] = true
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
L["Shoulder"] = true
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
L["Waist"] = true
L["WarningOpts"] = "Warning Options"
L["WarnMax"] = "Set maximum item durability to toggle the warning."
L["WarnPause"] = "Warning Pause"
L["WarnPauseDesc"] = "How long should we pause warnings after acknowledging them?"
L["WarnThreshold"] = "Warning Threshold"
L["WhoPays"] = [=[Who will be paying for the repairs?

It costs %s]=]
L["Wrist"] = true
L["Yes"] = true
L["YourRepIs"] = "Your reputation with this vendor is"

L["general"] = true
L["profile"] = true
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