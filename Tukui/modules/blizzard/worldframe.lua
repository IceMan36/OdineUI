local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

local TukuiWorldState = CreateFrame("Frame", nil, UIParent)
TukuiWorldState:RegisterEvent("PLAYER_ENTERING_WORLD")

-- create our moving area
local TukuiWorldStateAnchor = CreateFrame("Button", "TukuiWorldStateAnchor", UIParent)
TukuiWorldStateAnchor:SetFrameStrata("LOW")
TukuiWorldStateAnchor:SetFrameLevel(5)
TukuiWorldStateAnchor:SetHeight(20)
TukuiWorldStateAnchor:SetWidth(200)
TukuiWorldStateAnchor:SetClampedToScreen(true)
TukuiWorldStateAnchor:SetMovable(true)
TukuiWorldStateAnchor:SetTemplate("Default", true)
TukuiWorldStateAnchor:SetBackdropBorderColor(0,0,0,0)
TukuiWorldStateAnchor:SetBackdropColor(0,0,0,0)
TukuiWorldStateAnchor.text = T.SetFontString(TukuiWorldStateAnchor, C["media"].font, C["general"].fontscale)
TukuiWorldStateAnchor.text:SetPoint("CENTER")
TukuiWorldStateAnchor.text:SetText("Move WorldStateFrame")
TukuiWorldStateAnchor.text:Hide()

TukuiWorldStateAnchor:SetPoint("TOP", UIParent, "TOP", 25, -80)

TukuiWorldState:ClearAllPoints()
TukuiWorldState:SetParent(TukuiWorldStateAnchor)
TukuiWorldState:SetPoint("BOTTOM")
TukuiWorldState:SetHeight(100)
TukuiWorldState:SetWidth(200)

WorldStateAlwaysUpFrame:ClearAllPoints()
WorldStateAlwaysUpFrame:SetParent(TukuiWorldState)
WorldStateAlwaysUpFrame:SetFrameStrata("MEDIUM")
WorldStateAlwaysUpFrame:SetFrameLevel(3)
WorldStateAlwaysUpFrame:SetClampedToScreen(true)
WorldStateAlwaysUpFrame:EnableMouse(false)
WorldStateAlwaysUpFrame:SetPoint("LEFT", 50, 0)
WorldStateAlwaysUpFrame.SetPoint = T.dummy