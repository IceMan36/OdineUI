local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

-- BUTTON SIZES
T.buttonsize = T.Scale(C["actionbar"].buttonsize)
T.buttonspacing = T.Scale(C["actionbar"].buttonspacing)
T.petbuttonsize = T.Scale(C["actionbar"].petbuttonsize)
T.buttonspacing = T.Scale(C["actionbar"].buttonspacing)

local f = CreateFrame("Frame", "TukuiBottomPanel", UIParent)
f:SetHeight(C["general"].panelheight)
f:SetWidth(UIParent:GetWidth() + (T.mult * 2))
f:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", -T.mult, -T.mult)
f:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", T.mult, -T.mult)
f:SetFrameStrata("BACKGROUND")
f:SetFrameLevel(0)

-- MAIN ACTION BAR
local barbg = CreateFrame("Frame", "TukuiActionBarBackground", UIParent)
if C["actionbar"].bottompetbar ~= true then
	barbg:CreatePanel("Default", 1, 1, "BOTTOM", UIParent, "BOTTOM", 0, T.Scale(4))
else
	barbg:CreatePanel("Default", 1, 1, "BOTTOM", UIParent, "BOTTOM", 0, (T.buttonsize + (T.buttonspacing * 2)) + T.Scale(8))
end
barbg:SetWidth(math.ceil((T.buttonsize * 12) + (T.buttonspacing * 13)))
barbg:SetFrameStrata("BACKGROUND")
barbg:SetHeight(T.buttonsize + (T.buttonspacing * 2))
barbg:CreateShadow("Default")
barbg:SetFrameLevel(2)

if C["actionbar"].enable ~= true then
	barbg:SetAlpha(0)
end

--SPLIT BAR PANELS
local splitleft = CreateFrame("Frame", "TukuiSplitActionBarLeftBackground", TukuiActionBarBackground)
splitleft:CreatePanel("Default", (T.buttonsize * 6) + (T.buttonspacing * 7), TukuiActionBarBackground:GetHeight(), "RIGHT", TukuiActionBarBackground, "LEFT", T.Scale(-6), 0)
splitleft:SetFrameLevel(TukuiActionBarBackground:GetFrameLevel())
splitleft:SetFrameStrata(TukuiActionBarBackground:GetFrameStrata())

local splitright = CreateFrame("Frame", "TukuiSplitActionBarRightBackground", TukuiActionBarBackground)
splitright:CreatePanel("Default", (T.buttonsize * 6) + (T.buttonspacing * 7), TukuiActionBarBackground:GetHeight(), "LEFT", TukuiActionBarBackground, "RIGHT", T.Scale(6), 0)
splitright:SetFrameLevel(TukuiActionBarBackground:GetFrameLevel())
splitright:SetFrameStrata(TukuiActionBarBackground:GetFrameStrata())

splitleft:CreateShadow("Default")
splitright:CreateShadow("Default")


-- RIGHT BAR
if C["actionbar"].enable == true then
	local barbgr = CreateFrame("Frame", "TukuiActionBarBackgroundRight", TukuiActionBarBackground)
	barbgr:CreatePanel("Default", 1, (T.buttonsize * 12) + (T.buttonspacing * 13), "RIGHT", UIParent, "RIGHT", T.Scale(-4), T.Scale(-8))
	barbgr:Hide()
	barbgr:SetFrameLevel(2)
	
	local petbg = CreateFrame("Frame", "TukuiPetActionBarBackground", UIParent)
	if C["actionbar"].bottompetbar ~= true then
		petbg:CreatePanel("Default", T.petbuttonsize + (T.buttonspacing * 2), (T.petbuttonsize * 10) + (T.buttonspacing * 11), "RIGHT", UIParent, "RIGHT", T.Scale(-6), T.Scale(-13.5))
	else
		petbg:CreatePanel("Default", (T.petbuttonsize * 10) + (T.buttonspacing * 11), T.petbuttonsize + (T.buttonspacing * 2), "BOTTOM", UIParent, "BOTTOM", 0, T.Scale(4))
	end
	
	local ltpetbg = CreateFrame("Frame", "TukuiLineToPetActionBarBackground", petbg)
	if C["actionbar"].bottompetbar ~= true then
		ltpetbg:CreatePanel("Default", 30, 265, "LEFT", petbg, "RIGHT", 0, 0)
	else
		ltpetbg:CreatePanel("Default", 265, 30, "BOTTOM", petbg, "TOP", 0, 0)
	end
	
	ltpetbg:SetScript("OnShow", function(self)
		self:SetFrameStrata("BACKGROUND")
		self:SetFrameLevel(0)
	end)

	
	barbgr:CreateShadow("Default")
	petbg:CreateShadow("Default")
end

-- VEHICLE BAR
if C["actionbar"].enable == true then
	local vbarbg = CreateFrame("Frame", "TukuiVehicleBarBackground", UIParent)
	vbarbg:CreatePanel("Default", 1, 1, "BOTTOM", UIParent, "BOTTOM", 0, C["general"].panelheight+7)
	vbarbg:SetWidth((T.buttonsize * 12) + (T.buttonspacing * 13))
	vbarbg:SetHeight(T.buttonsize + (T.buttonspacing * 2))
	vbarbg:CreateShadow("Default")
	vbarbg:SetFrameLevel(barbg:GetFrameLevel())
end

-- CHAT BACKGROUND LEFT (MOVES)
local chatlbgdummy = CreateFrame("Frame", "ChatLBackground", UIParent)
chatlbgdummy:SetWidth(C["chat"].width)
chatlbgdummy:SetHeight(C["chat"].height+6)
chatlbgdummy:SetPoint("BOTTOMLEFT", TukuiBottomPanel, "TOPLEFT", T.Scale(6),  T.Scale(12))

-- CHAT BACKGROUND LEFT (DOESN'T MOVE THIS IS WHAT WE ATTACH FRAMES TO)
local chatlbgdummy2 = CreateFrame("Frame", "ChatLBackground2", UIParent)
chatlbgdummy2:SetWidth(C["chat"].width)
chatlbgdummy2:SetHeight(C["chat"].height+6)
chatlbgdummy2:SetPoint("BOTTOMLEFT", TukuiBottomPanel, "TOPLEFT", T.Scale(6),  T.Scale(12))

-- CHAT BACKGROUND RIGHT (MOVES)
local chatrbgdummy = CreateFrame("Frame", "ChatRBackground", UIParent)
chatrbgdummy:SetWidth(C["chat"].width)
chatrbgdummy:SetHeight(C["chat"].height+6)
chatrbgdummy:SetPoint("BOTTOMRIGHT", TukuiBottomPanel, "TOPRIGHT", T.Scale(-6),  T.Scale(16))

-- CHAT BACKGROUND RIGHT (DOESN'T MOVE THIS IS WHAT WE ATTACH FRAMES TO)
local chatrbgdummy2 = CreateFrame("Frame", "ChatRBackground2", UIParent)
chatrbgdummy2:SetWidth(C["chat"].width)
chatrbgdummy2:SetHeight(C["chat"].height+6)
chatrbgdummy2:SetPoint("BOTTOMRIGHT", TukuiBottomPanel, "TOPRIGHT", T.Scale(-6),  T.Scale(16))

T.ChatRightShown = true
if C["chat"].background == true then
	local chatlbg = CreateFrame("Frame", "ChatLBG", ChatLBackground)
	chatlbg:SetTemplate("Transparent")
	chatlbg:SetAllPoints(chatlbgdummy)
	chatlbg:SetFrameStrata("BACKGROUND")
	
	local chatltbg = CreateFrame("Frame", nil, chatlbg)
	chatltbg:SetTemplate("Default", true)
	chatltbg:SetPoint("BOTTOMLEFT", chatlbg, "TOPLEFT", 0, T.Scale(3))
	chatltbg:SetPoint("BOTTOMRIGHT", chatlbg, "TOPRIGHT", 0, T.Scale(3))
	chatltbg:SetHeight(T.Scale(22))
	chatltbg:SetFrameStrata("BACKGROUND")
	
	chatlbg:CreateShadow("Default")
	chatltbg:CreateShadow("Default")
end

if C["chat"].background == true then
	local chatrbg = CreateFrame("Frame", "ChatRBG", ChatRBackground)
	chatrbg:SetAllPoints(chatrbgdummy)
	chatrbg:SetTemplate("Transparent")
	chatrbg:SetFrameStrata("BACKGROUND")
	chatrbg:SetAlpha(0)

	local chatrtbg = CreateFrame("Frame", nil, chatrbg)
	chatrtbg:SetTemplate("Default", true)
	chatrtbg:SetPoint("BOTTOMLEFT", chatrbg, "TOPLEFT", 0, T.Scale(3))
	chatrtbg:SetPoint("BOTTOMRIGHT", chatrbg, "TOPRIGHT", 0, T.Scale(3))
	chatrtbg:SetHeight(T.Scale(22))
	chatrtbg:SetFrameStrata("BACKGROUND")
	chatrbg:CreateShadow("Default")
	chatrtbg:CreateShadow("Default")
end

--INFO LEFT
local infoleft = CreateFrame("Frame", "TukuiInfoLeft", UIParent)
infoleft:SetFrameLevel(2)
infoleft:SetTemplate("Default", true)
infoleft:CreateShadow("Default")
infoleft:SetPoint("TOPLEFT", chatlbgdummy2, "BOTTOMLEFT", T.Scale(17), T.Scale(-4))
infoleft:SetPoint("BOTTOMRIGHT", chatlbgdummy2, "BOTTOMRIGHT", T.Scale(-17), T.Scale(-C["general"].panelheight-3))

	-- LEFT BUTTONS
	local infoleftLbutton = CreateFrame("Button", "TukuiInfoLeftLButton", TukuiInfoLeft)
	infoleftLbutton:SetTemplate("Default", true)
	infoleftLbutton:SetPoint("TOPRIGHT", infoleft, "TOPLEFT", T.Scale(-2), 0)
	infoleftLbutton:SetPoint("BOTTOMLEFT", chatlbgdummy2, "BOTTOMLEFT", 0, T.Scale(-C["general"].panelheight-3))

	local infoleftRbutton = CreateFrame("Button", "TukuiInfoLeftRButton", TukuiInfoLeft)
	infoleftRbutton:SetTemplate("Default", true)
	infoleftRbutton:SetPoint("TOPLEFT", infoleft, "TOPRIGHT", T.Scale(2), 0)
	infoleftRbutton:SetPoint("BOTTOMRIGHT", chatlbgdummy2, "BOTTOMRIGHT", 0, T.Scale(-C["general"].panelheight-3))

	infoleft.shadow:ClearAllPoints()
	infoleft.shadow:SetPoint("TOPLEFT", infoleftLbutton, "TOPLEFT", T.Scale(-4), T.Scale(4))
	infoleft.shadow:SetPoint("BOTTOMRIGHT", infoleftRbutton, "BOTTOMRIGHT", T.Scale(4), T.Scale(-4))

	infoleftLbutton:FontString(nil, C["media"].dfont, C["datatext"].fsize, "THINOUTLINE")
	infoleftLbutton.text:SetText("-")
	infoleftLbutton.text:SetPoint("CENTER")

	infoleftRbutton:FontString(nil, C["media"].dfont, C["datatext"].fsize, "THINOUTLINE")
	infoleftRbutton.text:SetText("L")
	infoleftRbutton.text:SetPoint("CENTER")

-- INFO RIGHT
local inforight = CreateFrame("Frame", "TukuiInfoRight", UIParent)
inforight:SetTemplate("Default", true)
inforight:SetFrameLevel(2)
inforight:CreateShadow("Default")
inforight:SetPoint("TOPLEFT", chatrbgdummy2, "BOTTOMLEFT", T.Scale(17), T.Scale(-4))
inforight:SetPoint("BOTTOMRIGHT", chatrbgdummy2, "BOTTOMRIGHT", T.Scale(-17), T.Scale(-C["general"].panelheight-3))

	-- RIGHT BUTTONS
	local inforightLbutton = CreateFrame("Button", "TukuiInfoRightLButton", TukuiInfoRight)
	inforightLbutton:SetTemplate("Default", true)
	inforightLbutton:SetPoint("TOPRIGHT", inforight, "TOPLEFT", T.Scale(-2), 0)
	inforightLbutton:SetPoint("BOTTOMLEFT", chatrbgdummy2, "BOTTOMLEFT", 0, T.Scale(-C["general"].panelheight-3))
	
	local inforightRbutton = CreateFrame("Button", "TukuiInfoRightRButton", TukuiInfoRight)
	inforightRbutton:SetTemplate("Default", true)
	inforightRbutton:SetPoint("TOPLEFT", inforight, "TOPRIGHT", T.Scale(2), 0)
	inforightRbutton:SetPoint("BOTTOMRIGHT", chatrbgdummy2, "BOTTOMRIGHT", 0, T.Scale(-C["general"].panelheight-3))

	inforight.shadow:ClearAllPoints()
	inforight.shadow:SetPoint("TOPLEFT", inforightLbutton, "TOPLEFT", T.Scale(-4), T.Scale(4))
	inforight.shadow:SetPoint("BOTTOMRIGHT", inforightRbutton, "BOTTOMRIGHT", T.Scale(4), T.Scale(-4))
	
	inforightLbutton:FontString(nil, C["media"].dfont, C["datatext"].fsize, "THINOUTLINE")
	inforightLbutton.text:SetText("R")
	inforightLbutton.text:SetPoint("CENTER")

	inforightRbutton:FontString(nil, C["media"].dfont, C["datatext"].fsize, "THINOUTLINE")
	inforightRbutton.text:SetText("-")
	inforightRbutton.text:SetPoint("CENTER")

-- BOTTOM PANEL STATS
local bcPanel = CreateFrame("Frame", "TukuiBottomStats", UIParent)
bcPanel:CreatePanel("Default", (T.buttonsize * 12 + T.buttonspacing * 13) + 2, 23, "BOTTOM", UIParent, "BOTTOM", 0, T.Scale(6))
bcPanel:SetFrameLevel(2)
bcPanel:SetTemplate("Default", true)

local leftsd = CreateFrame("Frame", "TukuiLeftSplitBarData", UIParent)
if T.lowversion == true or C["actionbar"].v12 then
	leftsd:CreatePanel("Default", (T.buttonsize * 3 + T.buttonspacing * 4) + 2, 23, "RIGHT", TukuiBottomStats, "LEFT", T.Scale(-4), 0)
else
	leftsd:CreatePanel("Default", (T.buttonsize * 6 + T.buttonspacing * 7) + 2, 23, "RIGHT", TukuiBottomStats, "LEFT", T.Scale(-4), 0)
end
leftsd:SetFrameLevel(2)
leftsd:SetTemplate("Default", true)

local rightsd = CreateFrame("Frame", "TukuiRightSplitBarData", UIParent)
if T.lowversion == true or C["actionbar"].v12 then
	rightsd:CreatePanel("Default", (T.buttonsize * 3 + T.buttonspacing * 4) + 2, 23, "LEFT", TukuiBottomStats, "RIGHT", T.Scale(4), 0)
else
	rightsd:CreatePanel("Default", (T.buttonsize * 6 + T.buttonspacing * 7) + 2, 23, "LEFT", TukuiBottomStats, "RIGHT", T.Scale(4), 0)
end
rightsd:SetFrameLevel(2)
rightsd:SetTemplate("Default", true)

-- VIEWPORT ON TOP AND BOTTOM OF THE UI
if C["misc"].viewport then
	local height = T.buttonsize - 10

	local tbar = CreateFrame("Frame", "TukuiVPTopBar", UIParent)
	tbar:CreatePanel("Default", 1, 1, "TOP", UIParent, "TOP", 0, T.buttonspacing)
	tbar:SetWidth(T.getscreenwidth + 4)
	tbar:SetHeight(height+2)
	tbar:SetFrameStrata("BACKGROUND")
	tbar:SetFrameLevel(0)
		
	local bbar = CreateFrame("Frame", "TukuiVPBottomBar", UIParent)
	bbar:CreatePanel("Default", 1, 1, "BOTTOM", UIParent, "BOTTOM", 0, -T.buttonspacing)
	bbar:SetWidth(T.getscreenwidth + 4)
	bbar:SetHeight(height+2)
	bbar:SetFrameStrata("BACKGROUND")
	bbar:SetFrameLevel(0)
end

--BATTLEGROUND STATS FRAME
if C["datatext"].battleground == true then
	local bgframe = CreateFrame("Frame", "TukuiInfoLeftBattleGround", UIParent)
	bgframe:CreatePanel("Default", 1, 1, "TOPLEFT", UIParent, "BOTTOMLEFT", 0, 0)
	bgframe:SetAllPoints(TukuiInfoLeft)
	bgframe:SetFrameStrata("LOW")
	bgframe:SetFrameLevel(0)
	bgframe:EnableMouse(true)
end