local addonstub = LibStub("AceAddon-3.0"):NewAddon("AddonStub", "AceConsole-3.0")

--Make the LibDataBroker
local addonstub.LDB = LibStub("LibDataBroker-1.1"):NewDataObject("AddonStubLDB", {
  type = "data source",
  text = "AddonStub",
	icon = "Interface\\Icons\\",
	OnTooltipShow = function(tooltip)
		tooltip:AddDoubleLine("");
		tooltip:AddDoubleLine("");
		tooltip:AddDoubleLine("");
	end,
	OnClick = function(self, button)
	end
})

--Make the MiniMap Button
local addonstub.MiniMapIcon = LibStub("LibDBIcon-1.0")

--Do The Rest Of The Things!


--Functions
function exitbroker:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("AddonStubSV", {
  	profile = {
    	minimap = {
      	hide = false,
				minimapPos = 90,
    	},
			SvArray = {
				Key = Value,
			}
  	},
	})
	ExitBrokerIcon:Register("ExitBroker", ExitBrokerLDB, self.db.profile.minimap)
end
