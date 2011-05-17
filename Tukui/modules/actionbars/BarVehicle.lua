local T, C, L, DB = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

if not C["actionbar"].enable == true then return end


---------------------------------------------------------------------------
-- Setup Vehicle Bar
---------------------------------------------------------------------------

local vbar = CreateFrame("Frame", "TukuiVehicleBar", TukuiVehicleBarBackground, "SecureHandlerStateTemplate")
vbar:ClearAllPoints()
vbar:SetAllPoints(TukuiVehicleBarBackground)

vbar:RegisterEvent("UNIT_ENTERED_VEHICLE")
vbar:RegisterEvent("UNIT_DISPLAYPOWER")
vbar:RegisterEvent("PLAYER_LOGIN")
vbar:RegisterEvent("PLAYER_ENTERING_WORLD")
vbar:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		local button
		for i = 1, VEHICLE_MAX_ACTIONBUTTONS do
			button = _G["VehicleMenuBarActionButton"..i]
			self:SetFrameRef("VehicleMenuBarActionButton"..i, button)
		end	
		
		self:SetAttribute("_onstate-vehicleupdate", [[
			if newstate == "s1" then
				self:GetParent():Show()
			else
				self:GetParent():Hide()
			end
		]])
		
		RegisterStateDriver(self, "vehicleupdate", "[vehicleui]s1;s2")
	elseif event == "PLAYER_ENTERING_WORLD" then
		local button
		for i = 1, VEHICLE_MAX_ACTIONBUTTONS do
			button = _G["VehicleMenuBarActionButton"..i]
			button:SetSize(T.buttonsize, T.buttonsize)
			button:ClearAllPoints()
			button:SetParent(TukuiVehicleBar)
			if i == 1 then
				button:SetPoint("BOTTOMLEFT", TukuiVehicleBar, T.buttonspacing, T.buttonspacing)
			else
				local previous = _G["VehicleMenuBarActionButton"..i-1]
				button:SetPoint("LEFT", previous, "RIGHT", T.buttonspacing, 0)
			end
		end
	else
		VehicleMenuBar_OnEvent(self, event, ...)
	end
end)

--Create our custom Vehicle Button Hotkeys, because blizzard is fucking gay and won't let us reposition the default ones
do
	for i=1, VEHICLE_MAX_ACTIONBUTTONS do
		_G["TukuiVehicleHotkey"..i] = _G["VehicleMenuBarActionButton"..i]:CreateFontString("TukuiVehicleHotkey"..i, "OVERLAY", nil)
		_G["TukuiVehicleHotkey"..i]:ClearAllPoints()
		_G["TukuiVehicleHotkey"..i]:SetPoint("TOPRIGHT", 0, T.Scale(-3))
		_G["TukuiVehicleHotkey"..i]:SetFont(C["media"].font, 12, "OUTLINE")
		_G["TukuiVehicleHotkey"..i].ClearAllPoints = T.dummy
		_G["TukuiVehicleHotkey"..i].SetPoint = T.dummy
		
		if not C["actionbar"].hotkey == true then
			_G["TukuiVehicleHotkey"..i]:SetText("")
			_G["TukuiVehicleHotkey"..i]:Hide()
			_G["TukuiVehicleHotkey"..i].Show = T.dummy
		else
			_G["TukuiVehicleHotkey"..i]:SetText(_G["VehicleMenuBarActionButton"..i.."HotKey"]:GetText())
		end
	end
end

local UpdateVehHotkeys = function()
	if not UnitHasVehicleUI("player") then return end
	if C["actionbar"].hotkey ~= true then return end
	for i=1, VEHICLE_MAX_ACTIONBUTTONS do
		_G["TukuiVehicleHotkey"..i]:SetText(_G["VehicleMenuBarActionButton"..i.."HotKey"]:GetText())
		_G["TukuiVehicleHotkey"..i]:SetTextColor(_G["VehicleMenuBarActionButton"..i.."HotKey"]:GetTextColor())
	end
end

local VehTextUpdate = CreateFrame("Frame")
VehTextUpdate:RegisterEvent("UNIT_ENTERING_VEHICLE")
VehTextUpdate:RegisterEvent("UNIT_ENTERED_VEHICLE")
VehTextUpdate:SetScript("OnEvent", UpdateVehHotkeys)

-- vehicle button under minimap
local vehicle = CreateFrame("Button", nil, UIParent, "SecureHandlerClickTemplate")
vehicle:SetWidth(T.Scale(26))
vehicle:SetHeight(T.Scale(26))
vehicle:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", T.Scale(2), T.Scale(2))
vehicle:SetNormalTexture("Interface\\AddOns\\Tukui\\medias\\textures\\vehicleexit")
vehicle:SetPushedTexture("Interface\\AddOns\\Tukui\\medias\\textures\\vehicleexit")
vehicle:SetHighlightTexture("Interface\\AddOns\\Tukui\\medias\\textures\\vehicleexit")
vehicle:SetTemplate("Default")
vehicle:RegisterForClicks("AnyUp")
vehicle:SetScript("OnClick", function() VehicleExit() end)
RegisterStateDriver(vehicle, "visibility", "[vehicleui][target=vehicle,noexists] hide;show")

-- vehicle on vehicle bar, dont need to have a state driver.. its parented to vehicle bar
local vehicle2 = CreateFrame("BUTTON", nil, TukuiVehicleBarBackground, "SecureActionButtonTemplate")
vehicle2:SetWidth(T.buttonsize)
vehicle2:SetHeight(T.buttonsize)
vehicle2:SetPoint("RIGHT", TukuiVehicleBarBackground, "RIGHT", -T.buttonspacing, 0)
vehicle2:RegisterForClicks("AnyUp")
vehicle2:SetNormalTexture("Interface\\AddOns\\Tukui\\medias\\textures\\vehicleexit")
vehicle2:SetPushedTexture("Interface\\AddOns\\Tukui\\medias\\textures\\vehicleexit")
vehicle2:SetHighlightTexture("Interface\\AddOns\\Tukui\\medias\\textures\\vehicleexit")
vehicle2:SetTemplate("Default")
vehicle2:SetScript("OnClick", function() VehicleExit() end)