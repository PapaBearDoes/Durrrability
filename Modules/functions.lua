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
-- Auto repair - Self --
function Durrrability:AutoRepair()
  if Durrrability.db.global.canRepair == true then
		RepairAllItems()
		Durrrability:Print(Durrrability:Colorize("[" .. myName .. "]", "green") .. L["RepairedPersonal"] .. " " .. Durrrability:Coins2Str(Durrrability.db.global.repairAllCost))
	else
		Durrrability:Print(Durrrability:Colorize("["..myName.."]", "green") .. L["CardDeclined"] .. " " .. Durrrability:Coins2Str(Durrrability.db.global.repairAllCost))
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
	if Durrrability.db.global.canRepair == true and CanGuildBankRepair() and guildBankWithdrawMoney >= Durrrability.db.global.repairAllCost then
		RepairAllItems(1)
		Durrrability:Print(Durrrability:Colorize("["..myName.."]", "green") .. L["RepairedGuildFunds"] .. " " .. Durrrability:Coins2Str(Durrrability.db.global.repairAllCost))
  elseif Durrrability.db.profile.repairFromGuildOnly then
    Durrrability:Print(Durrrability:Colorize("["..myName.."]", "green") .. L["NoGuildGold"])
	else
		Durrrability:Print(Durrrability:Colorize("["..myName.."]", "green") .. L["NoGuildGoldUsePersonal"])
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
	Durrrability.db.global.repairAllCost, Durrrability.db.global.canRepair = GetRepairAllCost()
	if Durrrability.db.profile.repairType > 0 and Durrrability.db.global.repairAllCost > 0 then
		standing = UnitReaction("npc", "player")
		if standing >= Durrrability.db.profile.repairThreshold then
			Durrrability:DoRepair()
		else
			Durrrability:LowRepConfirmation()
		end
	end
end
-- End Checks --

-- Run The Addon --
function Durrrability:ShowConfig()
	InterfaceOptionsFrame_OpenToCategory(Durrr_OptionFrames.profile)
	InterfaceOptionsFrame_OpenToCategory(Durrr_OptionFrames.general)
end

function Durrrability:UpdateOptions()
  LibStub("AceConfigRegistry-3.0"):NotifyChange(me)
end

function Durrrability:UpdateProfile()
  Durrrability:ScheduleTimer("UpdateProfileDelayed", 0)
end

function Durrrability:OnProfileChanged(event, database, newProfileKey)
  Durrrability.db.profile = database.profile
end

function Durrrability:UpdateProfileDelayed()
  for timerKey, timerValue in Durrrability:IterateModules() do
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

  Durrrability:UpdateOptions()
end

function Durrrability:OnProfileReset()
end
-- End Addon Functions --
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