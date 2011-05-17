local T, C, L, DB = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

if not C["actionbar"].enable == true then return end

---------------------------------------------------------------------------
-- setup PetActionBar
---------------------------------------------------------------------------

local bar = CreateFrame("Frame", "TukuiPetBar", TukuiActionBarBackground, "SecureHandlerStateTemplate")
bar:ClearAllPoints()
bar:SetAllPoints(TukuiPetActionBarBackground)

function T.PositionBarPet(self)
	local button		
	for i = 1, 10 do
		button = _G["PetActionButton"..i]
		button:ClearAllPoints()
		button:SetParent(TukuiPetBar)
		TukuiPetActionBarBackground:SetParent(TukuiPetBar)
		button:SetFrameStrata("MEDIUM")
		button:SetSize(T.petbuttonsize, T.petbuttonsize)
		if i == 1 then
			button:SetPoint("TOPLEFT", T.buttonspacing, -T.buttonspacing)
		else
			if C["actionbar"].bottompetbar ~= true then
				button:SetPoint("TOP", _G["PetActionButton"..(i - 1)], "BOTTOM", 0, -T.buttonspacing)
			else
				button:SetPoint("LEFT", _G["PetActionButton"..(i - 1)], "RIGHT", T.buttonspacing, 0)
			end	
		end
		button:Show()
		self:SetAttribute("addchild", button)
	end
	
	--Setup Mouseover
	if C["actionbar"].rightbarmouseover == true and C["actionbar"].bottompetbar ~= true then
		TukuiPetActionBarBackground:SetAlpha(0)
		TukuiPetActionBarBackground:SetScript("OnEnter", function() RightBarMouseOver(1) end)
		TukuiPetActionBarBackground:SetScript("OnLeave", function() RightBarMouseOver(0) end)
		TukuiLineToPetActionBarBackground:SetScript("OnEnter", function() RightBarMouseOver(1) end)
		TukuiLineToPetActionBarBackground:SetScript("OnLeave", function() RightBarMouseOver(0) end)
		
		for i=1, 10 do
			local b = _G["PetActionButton"..i]
			b:SetAlpha(0)
			b:HookScript("OnEnter", function() RightBarMouseOver(1) end)
			b:HookScript("OnLeave", function() RightBarMouseOver(0) end)
		end
	end
end
	
bar:RegisterEvent("PLAYER_LOGIN")
bar:RegisterEvent("PLAYER_CONTROL_LOST")
bar:RegisterEvent("PLAYER_CONTROL_GAINED")
bar:RegisterEvent("PLAYER_ENTERING_WORLD")
bar:RegisterEvent("PLAYER_FARSIGHT_FOCUS_CHANGED")
bar:RegisterEvent("PET_BAR_UPDATE")
bar:RegisterEvent("PET_BAR_UPDATE_USABLE")
bar:RegisterEvent("PET_BAR_UPDATE_COOLDOWN")
bar:RegisterEvent("PET_BAR_HIDE")
bar:RegisterEvent("UNIT_PET")
bar:RegisterEvent("UNIT_FLAGS")
bar:RegisterEvent("UNIT_AURA")
bar:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then	
		-- bug reported by Affli on t12 BETA
		PetActionBarFrame.showgrid = 1 -- hack to never hide pet button. :X
		
		T.PositionBarPet(self)
		RegisterStateDriver(self, "visibility", "[pet,novehicleui,nobonusbar:5] show; hide")
		hooksecurefunc("PetActionBar_Update", T.TukuiPetBarUpdate)
	elseif event == "PET_BAR_UPDATE" or event == "UNIT_PET" and arg1 == "player" 
	or event == "PLAYER_CONTROL_LOST" or event == "PLAYER_CONTROL_GAINED" or event == "PLAYER_FARSIGHT_FOCUS_CHANGED" or event == "UNIT_FLAGS"
	or arg1 == "pet" and (event == "UNIT_AURA") then
		T.TukuiPetBarUpdate()
	elseif event == "PET_BAR_UPDATE_COOLDOWN" then
		PetActionBar_UpdateCooldowns()
	else
		T.StylePet()
	end
end)