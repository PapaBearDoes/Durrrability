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
local Durrrability = ns
local Durrr_Functions = Durrrability:NewModule("Functions", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0")
local L = Durrrability:GetLocale()
-- End Imports
--[[ ######################################################################## ]]
--   ## Do All The Things!!!
-- Auto repair - Self --
function Durrrability:AutoRepair()
  if Durrrability.globals.canRepair == true then
		RepairAllItems()
		Durrrability:Print(Durrrability:Colorize("[" .. L["AddonName"] .. "]", "green") .. L["RepairedPersonal"] .. " " .. Durrrability:Coins2Str(Durrrability.globals.repairAllCost))
	else
		Durrrability:Print(Durrrability:Colorize("["..L["AddonName"].."]", "green") .. L["CardDeclined"] .. " " .. Durrrability:Coins2Str(Durrrability.globals.repairAllCost))
  end
end
-- End Auto repair - Self --

-- Auto repair - Guild --
function Durrrability:AutoRepairFromBank()
	local guildBankWithdrawMoney = GetGuildBankWithdrawMoney()
	local guildBankMoney = GetGuildBankMoney()
	if guildBankWithdrawMoney == -1 then
		guildBankWithdrawMoney = guildBankMoney
	else
		guildBankWithdrawMoney = min(guildBankWithdrawMoney, guildBankMoney)
	end
	if Durrrability.globals.canRepair == true and CanGuildBankRepair() and guildBankWithdrawMoney >= Durrrability.globals.repairAllCost then
		RepairAllItems(1)
		Durrrability:Print(Durrrability:Colorize("["..L["AddonName"].."]", "green") .. L["RepairedGuildFunds"] .. " " .. Durrrability:Coins2Str(Durrrability.globals.repairAllCost))
  elseif Durrrability.db.profile.repairFromGuildOnly then
    Durrrability:Print(Durrrability:Colorize("["..L["AddonName"].."]", "green") .. L["NoGuildGold"])
	else
		Durrrability:Print(Durrrability:Colorize("["..L["AddonName"].."]", "green") .. L["NoGuildGoldUsePersonal"])
		Durrrability:AutoRepair()
	end
end
-- End Auto repair - Guild --

-- Repair functions --
function Durrrability:DoRepair()
	if Durrrability.db.profile.repairType == 2 then
		Durrrability:ShowDialog()
	elseif Durrrability.db.profile.repairType == 1 then
		if Durrrability.db.profile.repairFromGuild then
			Durrrability:AutoRepairFromBank()
		else
			Durrrability:AutoRepair()
		end
	end
end
-- End Repair functions --

-- Checks --
function Durrrability:RepairAttempt()
	Durrrability.globals.repairAllCost, Durrrability.globals.canRepair = GetRepairAllCost()
	if Durrrability.db.profile.repairType > 0 and Durrrability.globals.repairAllCost > 0 then
		standing = UnitReaction("npc", "player")
		if standing >= Durrrability.db.profile.repairThreshold then
			Durrrability:DoRepair()
		else
			Durrrability:LowRepConfirmation()
		end
	end
end
-- End Checks --
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
