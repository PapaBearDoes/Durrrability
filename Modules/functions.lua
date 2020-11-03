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
-- Dialog Popups --
local Durrr_Dialog = LibStub("LibDialog-1.0")
function addon:CreateDialogs()
	Durrr_Dialog:Register("Durrr_WhoPays", {
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
			self.text:SetFormattedText(L["WhoPays"], addon:Coins2Str(Durrr_globals.repairAllCost))
    end,
    hide_on_escape = true,
    show_while_dead = false
  })

	Durrr_Dialog:Register("Durrr_Confirm", {
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
			local text = L["YourRepIs"] .. addon:Colorize(" %s.\n", Durrr_globals.repColor[data]) .. L["AutoRepairRequires"] .. addon:Colorize(" %s.\n", Durrr_globals.repColor[addon.db.profile.repairThreshold]) .. L["RepairConfirm"] .. "\n" .. L["ItWillCost"]
			self.text:SetFormattedText(text, _G["FACTION_STANDING_LABEL" .. data], _G["FACTION_STANDING_LABEL" .. addon.db.profile.repairThreshold], addon:Coins2Str(Durrr_globals.repairAllCost))
		end,
		hide_on_escape = true,
		show_while_dead = false
	})

  Durrr_Dialog:Register("Durrr_Warn", {
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

    Durrr_Dialog:Register("Durrr_WarnToRepair", {
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

      Durrr_Dialog:Register("Durrr_CritWarnToRepair", {
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
	if addon.db.profile.critWarntoRepair and addon.db.profile.critWarnThreshold >= percentMin * 100 then
    Durrr_Dialog:Spawn("Durrr_CritWarnToRepair", addon:Colorize(string.format("%d", percentMin * 100), addon:GetThresholdHexColor(percentMin)))
	elseif addon.db.profile.warntoRepair and addon.db.profile.warnThreshold >= percentMin * 100 then
    Durrr_Dialog:Spawn("Durrr_WarnToRepair", addon:Colorize(string.format("%d", percentMin * 100), addon:GetThresholdHexColor(percentMin)))
	end
end
-- End Below Threshold Warning --

-- Auto repair - Self --
function addon:AutoRepair()
  if Durrr_globals.canRepair == true then
		RepairAllItems()
		addon:Print(addon:Colorize("[" .. L["AddonName"] .. "]", "green") .. L["RepairedPersonal"] .. " " .. addon:Coins2Str(Durrr_globals.repairAllCost))
	else
		addon:Print(addon:Colorize("["..L["AddonName"].."]", "green") .. L["CardDeclined"] .. " " .. addon:Coins2Str(Durrr_globals.repairAllCost))
  end
end
-- End Auto repair - Self --

-- Auto repair - Guild --
function addon:AutoRepairFromBank()
	local guildBankWithdrawMoney = GetGuildBankWithdrawMoney()
	local guildBankMoney = GetGuildBankMoney()
	if guildBankWithdrawMoney == -1 then
		guildBankWithdrawMoney = guildBankMoney
	else
		guildBankWithdrawMoney = min(guildBankWithdrawMoney, guildBankMoney)
	end
	if Durrr_globals.canRepair == true and CanGuildBankRepair() and guildBankWithdrawMoney >= Durrr_globals.repairAllCost then
		RepairAllItems(1)
		addon:Print(addon:Colorize("["..L["AddonName"].."]", "green") .. L["RepairedGuildFunds"] .. " " .. addon:Coins2Str(Durrr_globals.repairAllCost))
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
	Durrr_Dialog:Spawn("Durrr_WhoPays")
end
-- End Repair Popup --

-- Checks --
function addon:RepairAttempt()
	Durrr_globals.repairAllCost, Durrr_globals.canRepair = GetRepairAllCost()
	if addon.db.profile.repairType > 0 and Durrr_globals.repairAllCost > 0 then
		standing = UnitReaction("npc", "player")
		if standing >= addon.db.profile.repairThreshold then
			addon:DoRepair()
		else
			addon:LowRepConfirmation()
		end
	end
end
-- End Checks --

function addon:LowRepConfirmation()
	--local standing = UnitReaction("npc", "player")
	Durrr_Dialog:Spawn("Durrr_Confirm", standing)
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
