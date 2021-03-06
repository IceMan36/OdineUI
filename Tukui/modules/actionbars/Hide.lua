local T, C, L, DB = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

if not C["actionbar"].enable == true then return end

---------------------------------------------------------------------------
-- Hide all Blizzard stuff that we don't need
---------------------------------------------------------------------------

do
	MainMenuBar:SetScale(0.00001)
	MainMenuBar:EnableMouse(false)
	VehicleMenuBar:SetScale(0.00001)
	PetActionBarFrame:EnableMouse(false)
	ShapeshiftBarFrame:EnableMouse(false)
	
	local elements = {
		MainMenuBar, MainMenuBarArtFrame, BonusActionBarFrame, VehicleMenuBar,
		PossessBarFrame, PetActionBarFrame, ShapeshiftBarFrame,
		ShapeshiftBarLeft, ShapeshiftBarMiddle, ShapeshiftBarRight,
	}
	for _, element in pairs(elements) do
		if element:GetObjectType() == "Frame" then
			element:UnregisterAllEvents()
		end
		
		if element ~= MainMenuBar then
			element:Hide()
		end
		element:SetAlpha(0)
	end
	elements = nil

	-- fix main bar keybind not working after a talent switch. :X
	hooksecurefunc('TalentFrame_LoadUI', function()
		PlayerTalentFrame:UnregisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
	end)
end

do
	local uiManagedFrames = {
		"MultiBarLeft",
		"MultiBarRight",
		"MultiBarBottomLeft",
		"MultiBarBottomRight",
		"ShapeshiftBarFrame",
		"PossessBarFrame",
		"PETACTIONBAR_YPOS",
		"MultiCastActionBarFrame",
		"MULTICASTACTIONBAR_YPOS",
		"ChatFrame1",
		"ChatFrame2",
	}
	for _, frame in pairs(uiManagedFrames) do
		UIPARENT_MANAGED_FRAME_POSITIONS[frame] = nil
	end
	uiManagedFrames = nil
end

function RightBarMouseOver(alpha)
	TukuiActionBarBackgroundRight:SetAlpha(alpha)
	if C["actionbar"].bottompetbar ~= true then
		TukuiPetActionBarBackground:SetAlpha(alpha)
	end
	
	if T.lowversion ~= true and C["actionbar"].v12 ~= true then
		if T["actionbar"].rightbars > 0 and MultiBarLeft:IsShown() then
			for i=1, 12 do
				local pb = _G["MultiBarLeftButton"..i]
				pb:SetAlpha(alpha)
			end	
		end
		
		if T["actionbar"].rightbars > 1 and MultiBarBottomRight:IsShown() then
			for i=1, 12 do
				local pb = _G["MultiBarBottomRightButton"..i]
				pb:SetAlpha(alpha)
			end
		end

		if T["actionbar"].rightbars > 2 and MultiBarRight:IsShown() then
			for i=1, 12 do
				local pb = _G["MultiBarRightButton"..i]
				pb:SetAlpha(alpha)
			end		
		end
	else
		if T["actionbar"].rightbars > 0 and MultiBarRight:IsShown() then
			for i=1, 12 do
				local pb = _G["MultiBarRightButton"..i]
				pb:SetAlpha(alpha)
			end
		end
		
		if T["actionbar"].rightbars > 1 and MultiBarBottomRight:IsShown() then
			for i=1, 12 do
				local pb = _G["MultiBarBottomRightButton"..i]
				pb:SetAlpha(alpha)
			end
		end
	end

	if TukuiPetBar:IsShown() and C["actionbar"].bottompetbar ~= true then
		for i=1, 10 do
			local pb = _G["PetActionButton"..i]
			pb:SetAlpha(alpha)
		end	
		TukuiPetBar:SetAlpha(alpha)
	end
end

function ShapeShiftMouseOver(alpha)
	for i=1, NUM_SHAPESHIFT_SLOTS do
		local pb = _G["ShapeshiftButton"..i]
		pb:SetAlpha(alpha)
	end
end

do
	if C["actionbar"].rightbarmouseover == true then
		TukuiActionBarBackgroundRight:SetAlpha(0)
		TukuiActionBarBackgroundRight:SetScript("OnEnter", function() RightBarMouseOver(1) end)
		TukuiActionBarBackgroundRight:SetScript("OnLeave", function() RightBarMouseOver(0) end)
	end
end