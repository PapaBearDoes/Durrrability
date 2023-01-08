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
-- Dialog Popups --
local Durrr_Dialog = LibStub("LibDialog-1.0")

function Durrrability:CreateDialogs()
	Durrr_Dialog:Register("Durrr_WhoPays", {
    text = "",
    buttons = {
      {
        text = L["Myself"],
        on_click = function(self, button, down)
          Durrrability:AutoRepair()
        end
      },
      {
        text = L["Cancel"]
      },
      {
        text = L["TheGuild"],
        on_click = function(self, button, down)
          Durrrability:AutoRepairFromBank()
        end
      },
    },
    on_show = function(self, data)
			self.text:SetFormattedText(L["WhoPays"], Durrrability:Coins2Str(Durrrability.db.global.repairAllCost))
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
					Durrrability:DoRepair()
				end
			},
			{
				text = L["No"]
			},
		},
		on_show = function(self, data)
			local text = L["YourRepIs"] .. Durrrability:Colorize(" %s.\n", Durrrability.db.global.repColor[data]) .. L["AutoRepairRequires"] .. Durrrability:Colorize(" %s.\n", Durrrability.db.global.repColor[Durrrability.db.profile.repairThreshold]) .. L["RepairConfirm"] .. "\n" .. L["ItWillCost"]
			self.text:SetFormattedText(text, _G["FACTION_STANDING_LABEL" .. data], _G["FACTION_STANDING_LABEL" .. Durrrability.db.profile.repairThreshold], Durrrability:Coins2Str(Durrrability.db.global.repairAllCost))
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
		show_while_dead = false,
		on_hide = function()
			local warnPause = Durrrability.db.profile.warnPause * 60
			Durrrability.db.global.alreadyWarned = true
			Durrrability:ScheduleTimer("warnTimerReset", warnPause)
		end,
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
		show_while_dead = false,
		on_hide = function()
			local warnPause = Durrrability.db.profile.warnPause * 60
			Durrrability.db.global.alreadyWarned = true
			Durrrability:ScheduleTimer("warnTimerReset", warnPause)
		end,
	})
end
-- End Dialog Popups --

-- Below Threshold Warnings --
function Durrrability:WarnToRepair()
	local totalCost, percent, percentMin = Durrrability:GetRepairData()
	if Durrrability.db.profile.warntoRepair and Durrrability.db.profile.warnThreshold >= percentMin * 100 then
    Durrr_Dialog:Spawn("Durrr_WarnToRepair", Durrrability:Colorize(string.format("%d", percentMin * 100), Durrrability:GetThresholdHexColor(percentMin)))
	end
end

function Durrrability:CritWarnToRepair()
	local totalCost, percent, percentMin = Durrrability:GetRepairData()
	if Durrrability.db.profile.critWarntoRepair and Durrrability.db.profile.critWarnThreshold >= percentMin * 100 then
    Durrr_Dialog:Spawn("Durrr_CritWarnToRepair", Durrrability:Colorize(string.format("%d", percentMin * 100), Durrrability:GetThresholdHexColor(percentMin)))
	end
end
-- End Below Threshold Warning --

-- Repair Popup --
function Durrrability:ShowDialog()
	Durrr_Dialog:Spawn("Durrr_WhoPays")
end
-- End Repair Popup --

function Durrrability:LowRepConfirmation()
	--local standing = UnitReaction("npc", "player")
	Durrr_Dialog:Spawn("Durrr_Confirm", standing)
end
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