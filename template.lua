--                                  \\\\///
--                                 /       \
--                               (| (.)(.) |)
-- .---------------------------.OOOo--()--oOOO.---------------------------.
-- |                                                                      |
-- |  @file-author@'s Durrrability Addon for World of Warcraft
-- ########################################################################
-- ## Let's init this file shall we?
-- Imports
local _G = _G
--Durrr = select(2, ...)
local me, Durrr = ...
local Durrr = Durrr
local LibStub = LibStub
local tonumber = tonumber
local tostring = tostring
local pairs = pairs
local type = type
local setmetatable = setmetatable
local tinsert = tinsert
local L = Durrr:GetLocale()
local ID = ID
local SLOT = SLOT
local NAME = NAME
local VAL = VAL
local MAX = MAX
local COST = COST
local repairAllCost = repairAllCost
local canRepair = canRepair
local bagsCost = bagsCost
local bagsPercent = bagsPercent
local combatState = combatState
local vendorState = vendorState
local updateReq = updateReq
local slots = slots
-- End Imports

-- Isolate the environment
setfenv(1, select(2, ...))
-- End Isolate
-- ########################################################################
-- ########################################################################
-- ## Do All The Things!!!

-- ########################################################################
-- |  Last Editted By: @file-author@ - @file-date-iso@
-- |  @file-revision@
-- |                                                                      |
-- '-------------------------.oooO----------------------------------------|
--                           (    )     Oooo.
--                            \  (     (    )
--                             \__)     )  /
--                                     (__/
