------------------------------------------------------------------------
--	ActionBar Functions
------------------------------------------------------------------------
local T, C, L, DB = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

function T.TukuiPetBarUpdate(self, event)
	local petActionButton, petActionIcon, petAutoCastableTexture, petAutoCastShine
	for i=1, NUM_PET_ACTION_SLOTS, 1 do
		local buttonName = "PetActionButton" .. i
		petActionButton = _G[buttonName]
		petActionIcon = _G[buttonName.."Icon"]
		petAutoCastableTexture = _G[buttonName.."AutoCastable"]
		petAutoCastShine = _G[buttonName.."Shine"]
		local name, subtext, texture, isToken, isActive, autoCastAllowed, autoCastEnabled = GetPetActionInfo(i)
		
		if not isToken then
			petActionIcon:SetTexture(texture)
			petActionButton.tooltipName = name
		else
			petActionIcon:SetTexture(_G[texture])
			petActionButton.tooltipName = _G[name]
		end
		
		petActionButton.isToken = isToken
		petActionButton.tooltipSubtext = subtext

		if isActive and name ~= "PET_ACTION_FOLLOW" then
			petActionButton:SetChecked(1)
			if IsPetAttackAction(i) then
				PetActionButton_StartFlash(petActionButton)
			end
		else
			petActionButton:SetChecked(0)
			if IsPetAttackAction(i) then
				PetActionButton_StopFlash(petActionButton)
			end			
		end
		
		if autoCastAllowed then
			petAutoCastableTexture:Show()
		else
			petAutoCastableTexture:Hide()
		end
		
		if autoCastEnabled then
			AutoCastShine_AutoCastStart(petAutoCastShine)
		else
			AutoCastShine_AutoCastStop(petAutoCastShine)
		end
		
		-- grid display
		if name then
			if not C["actionbar"].showgrid then
				petActionButton:SetAlpha(1)
			end			
		else
			if not C["actionbar"].showgrid then
				petActionButton:SetAlpha(0)
			end
		end
		
		if texture then
			if GetPetActionSlotUsable(i) then
				SetDesaturation(petActionIcon, nil)
			else
				SetDesaturation(petActionIcon, 1)
			end
			petActionIcon:Show()
		else
			petActionIcon:Hide()
		end
		
		-- between level 1 and 10 on cata, we don't have any control on Pet. (I lol'ed so hard)
		-- Setting desaturation on button to true until you learn the control on class trainer.
		-- you can at least control "follow" button.
		if not PetHasActionBar() and texture and name ~= "PET_ACTION_FOLLOW" then
			PetActionButton_StopFlash(petActionButton)
			SetDesaturation(petActionIcon, 1)
			petActionButton:SetChecked(0)
		end
	end
end

function T.TukuiShiftBarUpdate()
	local numForms = GetNumShapeshiftForms()
	local texture, name, isActive, isCastable
	local button, icon, cooldown
	local start, duration, enable
	for i = 1, NUM_SHAPESHIFT_SLOTS do
		button = _G["ShapeshiftButton"..i]
		icon = _G["ShapeshiftButton"..i.."Icon"]
		if i <= numForms then
			texture, name, isActive, isCastable = GetShapeshiftFormInfo(i)
			icon:SetTexture(texture)
			
			cooldown = _G["ShapeshiftButton"..i.."Cooldown"]
			if texture then
				cooldown:SetAlpha(1)
			else
				cooldown:SetAlpha(0)
			end
			
			start, duration, enable = GetShapeshiftFormCooldown(i)
			CooldownFrame_SetTimer(cooldown, start, duration, enable)
			
			if isActive then
				ShapeshiftBarFrame.lastSelected = button:GetID()
				button:SetChecked(1)
			else
				button:SetChecked(0)
			end

			if isCastable then
				icon:SetVertexColor(1.0, 1.0, 1.0)
			else
				icon:SetVertexColor(0.4, 0.4, 0.4)
			end
		end
	end
end

function T.PositionAllPanels()
	TukuiActionBarBackground:ClearAllPoints()
	TukuiPetActionBarBackground:ClearAllPoints()
	TukuiLineToPetActionBarBackground:ClearAllPoints()
	
	if C["actionbar"].bottompetbar ~= true then
		TukuiActionBarBackground:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, T.Scale(C["general"].panelheight+11))
		if T["actionbar"].rightbars > 0 then
			TukuiPetActionBarBackground:SetPoint("RIGHT", TukuiActionBarBackgroundRight, "LEFT", T.Scale(-6), 0)
		else
			TukuiPetActionBarBackground:SetPoint("RIGHT", UIParent, "RIGHT", T.Scale(-6), T.Scale(-13.5))
		end
		TukuiPetActionBarBackground:SetSize(T.petbuttonsize + (T.buttonspacing * 2), (T.petbuttonsize * 10) + (T.buttonspacing * 11))
		TukuiLineToPetActionBarBackground:SetSize(30, 265)
		TukuiLineToPetActionBarBackground:SetPoint("LEFT", TukuiPetActionBarBackground, "RIGHT", 0, 0)
	else
		TukuiActionBarBackground:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, (T.buttonsize + (T.buttonspacing * 2)) + T.Scale(C["general"].panelheight+8))
		TukuiPetActionBarBackground:SetSize((T.petbuttonsize * 10) + (T.buttonspacing * 11), T.petbuttonsize + (T.buttonspacing * 2))
		TukuiPetActionBarBackground:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, T.Scale(4))
		TukuiLineToPetActionBarBackground:SetSize(265, 30)
		TukuiLineToPetActionBarBackground:SetPoint("BOTTOM", TukuiPetActionBarBackground, "TOP", 0, 0)
	end
	
	if T.lowversion == true then
		if T["actionbar"].bottomrows == 3 then
			TukuiActionBarBackground:SetHeight((T.buttonsize * 3) + (T.buttonspacing * 4))
		elseif T["actionbar"].bottomrows == 2 then
			TukuiActionBarBackground:SetHeight((T.buttonsize * 2) + (T.buttonspacing * 3))
		else
			TukuiActionBarBackground:SetHeight(T.buttonsize + (T.buttonspacing * 2))
		end
	else
		if T["actionbar"].bottomrows > 1 then
			TukuiActionBarBackground:SetHeight((T.buttonsize * 2) + (T.buttonspacing * 3))
		else
			TukuiActionBarBackground:SetHeight(T.buttonsize + (T.buttonspacing * 2))
		end	
	end
	
	--SplitBar
	if T["actionbar"].splitbar == true then
		TukuiSplitActionBarLeftBackground:Show()
		TukuiSplitActionBarRightBackground:Show()
		TukuiSplitActionBarLeftBackground:SetHeight(TukuiActionBarBackground:GetHeight())
		TukuiSplitActionBarRightBackground:SetHeight(TukuiActionBarBackground:GetHeight())
	else
		TukuiSplitActionBarLeftBackground:Hide()
		TukuiSplitActionBarRightBackground:Hide()	
	end
	
	if T.lowversion == true then
		if T["actionbar"].bottomrows < 3 then
			TukuiSplitActionBarLeftBackground:SetWidth((T.buttonsize * 3) + (T.buttonspacing * 4))
			TukuiSplitActionBarRightBackground:SetWidth((T.buttonsize * 3) + (T.buttonspacing * 4))			
		else
			TukuiSplitActionBarLeftBackground:SetWidth((T.buttonsize * 4) + (T.buttonspacing * 5))
			TukuiSplitActionBarRightBackground:SetWidth((T.buttonsize * 4) + (T.buttonspacing * 5))					
		end
	else
		TukuiSplitActionBarLeftBackground:SetWidth((T.buttonsize * 6) + (T.buttonspacing * 7))
		TukuiSplitActionBarRightBackground:SetWidth((T.buttonsize * 6) + (T.buttonspacing * 7))
	end
	TukuiSplitActionBarLeftBackground:SetHeight(TukuiActionBarBackground:GetHeight())
	TukuiSplitActionBarRightBackground:SetHeight(TukuiActionBarBackground:GetHeight())
	
	--RightBar
	TukuiActionBarBackgroundRight:Show()
	
	if T.lowversion == true then
		if T["actionbar"].rightbars == 1 then
			TukuiActionBarBackgroundRight:SetWidth(T.buttonsize + (T.buttonspacing * 2))
		elseif T["actionbar"].rightbars == 2 then
			TukuiActionBarBackgroundRight:SetWidth((T.buttonsize * 2) + (T.buttonspacing * 3))
		else
			TukuiActionBarBackgroundRight:Hide()
		end	
	else
		if T["actionbar"].rightbars == 1 then
			TukuiActionBarBackgroundRight:SetWidth(T.buttonsize + (T.buttonspacing * 2))
		elseif T["actionbar"].rightbars == 2 then
			TukuiActionBarBackgroundRight:SetWidth((T.buttonsize * 2) + (T.buttonspacing * 3))
		elseif T["actionbar"].rightbars == 3 then
			TukuiActionBarBackgroundRight:SetWidth((T.buttonsize * 3) + (T.buttonspacing * 4))			
		else
			TukuiActionBarBackgroundRight:Hide()
		end	
	end
end

function T.PositionAllBars()
	if T.lowversion == true then
		if T.actionbar.rightbars > 2 then
			T.actionbar.rightbars = 2
		end
	else
		if T.actionbar.rightbars > 1 and T.actionbar.splitbar == true then
			T.actionbar.rightbars = 1
		end
		
		if T.actionbar.bottomrows > 2 then
			T.actionbar.bottomrows = 2
		end
	end
	
	T.PositionAllPanels()
	T.PositionMainBar()
	T.PositionBar2()
	T.PositionBar3()
	T.PositionBar4()
	T.PositionBar5()
	T.PositionBarPet(TukuiPetBar)
	if T.PositionWatchFrame then
		T.PositionWatchFrame()
	end
end

function T.UpdateHotkey(self, actionButtonType)
	local hotkey = _G[self:GetName() .. 'HotKey']
	local text = hotkey:GetText()
	
	text = string.gsub(text, '(s%-)', 'S')
	text = string.gsub(text, '(a%-)', 'A')
	text = string.gsub(text, '(c%-)', 'C')
	text = string.gsub(text, '(Mouse Button )', 'M')
	text = string.gsub(text, '(Mouse Wheel Up)', 'MU')
	text = string.gsub(text, '(Mouse Wheel Down)', 'MD')	
	text = string.gsub(text, KEY_BUTTON3, 'M3')
	text = string.gsub(text, '(Num Pad )', 'N')
	text = string.gsub(text, KEY_PAGEUP, 'PU')
	text = string.gsub(text, KEY_PAGEDOWN, 'PD')
	text = string.gsub(text, KEY_SPACE, 'SpB')
	text = string.gsub(text, KEY_INSERT, 'Ins')
	text = string.gsub(text, KEY_HOME, 'Hm')
	text = string.gsub(text, KEY_DELETE, 'Del')
	text = string.gsub(text, KEY_MOUSEWHEELUP, 'MwU')
	text = string.gsub(text, KEY_MOUSEWHEELDOWN, 'MwD')
	
	if hotkey:GetText() == _G['RANGE_INDICATOR'] then
		hotkey:SetText('')
	else
		hotkey:SetText(text)
	end
end