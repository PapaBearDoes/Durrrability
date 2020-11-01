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
local addon = ns
local L = addon:GetLocale()
-- End Imports
--[[ ######################################################################## ]]
--   ## Do All The Things!!!
local DurrrDialog = LibStub("LibDialog-1.0")

-- Dialog Popups --
function addon:CreateDialogs()
	DurrrDialog:Register("DurrrDialog", {
    text = "",
    buttons = {
      {
        text = L["Myself"],
        on_click = function(self, button, down)
          addon:AutoRepair()
        end
      },
      {
        text = L["Cancel"]
      },
      {
        text = L["TheGuild"],
        on_click = function(self, button, down)
          addon:AutoRepairFromBank()
        end
      },
    },
    on_show = function(self, data)
			self.text:SetFormattedText(L["WhoPays"] .. " %s", addon:Coins2Str(Durrr_repairAllCost))
    end,
    hide_on_escape = true,
    show_while_dead = false
  })

	DurrrDialog:Register("DurrrConfirm", {
		text = "",
		icon = [[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]],
		buttons = {
			{
				text = L["Yes"],
				on_click = function(self, button, down)
					addon:DoRepair()
				end
			},
			{
				text = L["No"]
			},
		},
		on_show = function(self, data)
			self.text:SetFormattedText(L["YourRepIs"] .. addon:Colorize("%s", "yellow") .. L["AutoRepairRequires"] .. " %s. " .. L["RepairConfirm"], _G["FACTION_STANDING_LABEL" .. data], _G["FACTION_STANDING_LABEL" .. addon.db.profile.repairThreshold])
		end,
		hide_on_escape = true,
		show_while_dead = false
	})

  DurrrDialog:Register("DurrrWarn", {
		text = "",
		icon = [[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]],
		buttons = {
			{
				text = L["Ok"]
			},
		},
		on_show = function(self, data)
			self.text:SetFormattedText(L["Card Declined"], data)
		end,
		hide_on_escape = true,
		show_while_dead = false
	})

    DurrrDialog:Register("DurrrWarnToRepair", {
  		text = "",
  		icon = [[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]],
  		buttons = {
  			{
  				text = L["Ok"]
  			},
  		},
  		on_show = function(self, data)
  			self.text:SetFormattedText(L["CityWarn"], data)
  		end,
  		hide_on_escape = true,
  		show_while_dead = false
  	})

      DurrrDialog:Register("DurrrCritWarnToRepair", {
    		text = "",
    		icon = [[Interface\DialogFrame\UI-Dialog-Icon-AlertNew]],
    		buttons = {
    			{
    				text = L["Ok"]
    			},
    		},
    		on_show = function(self, data)
    			self.text:SetFormattedText(L["CritWarn"], data)
    		end,
    		hide_on_escape = true,
    		show_while_dead = false
    	})
end
-- End Dialog Popups --

-- Below Threshold Warnings --
function addon:WarnToRepair()
	local totalCost, percent, percentMin = addon:GetRepairData()
	if addon.db.profile.warntoRepair and addon.db.profile.warnThreshold >= percentMin * 100 then
    DurrrDialog:Spawn("DurrrWarnToRepair", addon:Colorize(string.format("%d", percentMin * 100), addon:GetThresholdHexColor(percentMin)))
	end
end

function addon:CritWarnToRepair()
	local totalCost, percent, percentMin = addon:GetRepairData()
	if addon.db.profile.critWarntoRepair and addon.db.profile.critWarnThreshold >= percentMin * 100 then
    DurrrDialog:Spawn("DurrrCritWarnToRepair", addon:Colorize(string.format("%d", percentMin * 100), addon:GetThresholdHexColor(percentMin)))
	end
end
-- End Below Threshold Warning --

-- Auto repair - Self --
function addon:AutoRepair()
  if Durrr_canRepair == true then
		RepairAllItems()
		addon:Print(addon:Colorize("[" .. L["AddonName"] .. "]", "green") .. L["RepairedPersonal"] .. " " .. addon:Coins2Str(Durrr_repairAllCost))
	else
		addon:Print(addon:Colorize("["..L["AddonName"].."]", "green") .. L["CardDeclined"] .. " " .. addon:Coins2Str(Durrr_repairAllCost))
  end
end
-- End Auto repair - Self --

-- Auto repair - Guild --
function addon:AutoRepairFromBank()
	local GuildBankWithdrawMoney = GetGuildBankWithdrawMoney()
	local GuildBankMoney = GetGuildBankMoney()
	if GuildBankWithdrawMoney == -1 then
		GuildBankWithdrawMoney = GuildBankMoney
	else
		GuildBankWithdrawMoney = min(GuildBankWithdrawMoney, GuildBankMoney)
	end
	if Durrr_canRepair == true and CanGuildBankRepair() and GuildBankWithdrawMoney >= Durrr_repairAllCost then
		RepairAllItems(1)
		addon:Print(addon:Colorize("["..L["AddonName"].."]", "green") .. L["RepairedGuildFunds"] .. " " .. addon:Coins2Str(Durrr_repairAllCost))
  elseif addon.db.profile.repairFromGuildOnly then
    addon:Print(addon:Colorize("["..L["AddonName"].."]", "green") .. L["NoGuildGold"])
	else
		addon:Print(addon:Colorize("["..L["AddonName"].."]", "green") .. L["NoGuildGoldUsePersonal"])
		addon:AutoRepair()
	end
end
-- End Auto repair - Guild --

-- Repair functions --
function addon:DoRepair()
	if addon.db.profile.repairType == 2 then
		addon:ShowDialog()
	elseif addon.db.profile.repairType == 1 then
		if addon.db.profile.repairFromGuild then
			addon:AutoRepairFromBank()
		else
			addon:AutoRepair()
		end
	end
end
-- End Repair functions --

-- Repair Popup --
function addon:ShowDialog()
	DurrrDialog:Spawn("DurrrDialog")
end
-- End Repair Popup --

-- Checks --
function addon:RepairAttempt()
	Durrr_repairAllCost, Durrr_canRepair = GetRepairAllCost()
	if addon.db.profile.repairType > 0 and Durrr_repairAllCost > 0 then
		local standing = UnitReaction("npc", "player")
		if standing >= addon.db.profile.repairThreshold then
			addon:DoRepair()
		else
			addon:LowRepConfirmation()
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
