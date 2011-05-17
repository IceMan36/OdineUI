--Create interactable actionbars
local T, C, L, DB = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

if not C["actionbar"].enable == true then return end

local function Button_OnEnter(self)
	self.Text:SetTextColor(1, 1, 1)
	self:SetBackdropBorderColor(unpack(C["media"].txtcolor))
end

local function Button_OnLeave(self)
	self.Text:SetTextColor(unpack(C["media"].txtcolor))
	self:SetTemplate("Default", true)
end

local function Button_OnEvent(self, event)
	if self:IsShown() then self:Hide() end
	T.ABLock = false
end

local btnnames = {}

local function CreateMoverButton(name, text)
	local b = CreateFrame("Button", name, UIParent)
	b:SetTemplate("Default", true)
	b:RegisterEvent("PLAYER_REGEN_DISABLED")
	b:SetScript("OnEvent", Button_OnEvent)
	b:SetScript("OnEnter", Button_OnEnter)
	b:SetScript("OnLeave", Button_OnLeave)
	b:EnableMouse(true)
	b:Hide()
	b:CreateShadow("Default")
	tinsert(btnnames, tostring(name))
	
	local t = b:CreateFontString(nil, "OVERLAY", b)
	t:SetFont(C["media"].font,14,"THINOUTLINE")
	t:SetShadowOffset(T.mult, -T.mult)
	t:SetShadowColor(0, 0, 0, 0.4)
	t:SetPoint("CENTER")
	t:SetJustifyH("CENTER")
	t:SetText(text)
	t:SetTextColor(unpack(C["media"].txtcolor))
	b.Text = t
end

local function SaveBars(var, val)
	T["actionbar"][var] = val
	T.PositionAllBars()
end

function T.ToggleABLock()
	if InCombatLockdown() then return end
	
	if T.ABLock == true then
		T.ABLock = false
	else
		T.ABLock = true
	end
	
	for i, btnnames in pairs(btnnames) do
		if T.ABLock == false then
			_G[btnnames]:EnableMouse(false)
			_G[btnnames]:Hide()
			TukuiInfoLeftRButton.text:SetTextColor(1,1,1)
		else
			_G[btnnames]:EnableMouse(true)
			if btnnames == "RightBarBig" and not (T["actionbar"].rightbars ~= 0 or (T["actionbar"].bottomrows == 3 and T["actionbar"].splitbar == true)) then
				_G[btnnames]:Show()
			elseif btnnames ~= "RightBarBig" then
				_G[btnnames]:Show()
			end
			TukuiInfoLeftRButton.text:SetTextColor(unpack(C["media"].txtcolor))
		end
	end
end

--Create our buttons
do
	CreateMoverButton("LeftSplit", "<")
	CreateMoverButton("RightSplit", ">")
	CreateMoverButton("TopMainBar", "+")
	CreateMoverButton("RightBarBig", "<")
	CreateMoverButton("RightBarInc", "<")
	CreateMoverButton("RightBarDec", ">")
end

--Position & Size our buttons after variables loaded
local barloader = CreateFrame("Frame")
barloader:RegisterEvent("ADDON_LOADED")
barloader:SetScript("OnEvent", function(self, addon)
	if not IsAddOnLoaded("Tukui") then return end
	self:UnregisterEvent("ADDON_LOADED")
	
	if TukuiData == nil then TukuiData = {} end
	if TukuiData[T.myrealm] == nil then TukuiData[T.myrealm] = {} end
	if TukuiData[T.myrealm][T.myname] == nil then TukuiData[T.myrealm][T.myname] = {} end
	if TukuiData[T.myrealm][T.myname]["actionbar"] == nil then TukuiData[T.myrealm][T.myname]["actionbar"] = {} end
	
	T["actionbar"] = TukuiData[T.myrealm][T.myname]["actionbar"]
	
	--Default settings
	if T["actionbar"].splitbar == nil then T["actionbar"].splitbar = true end
	if T["actionbar"].bottomrows == nil then T["actionbar"].bottomrows = 1 end
	if T["actionbar"].rightbars == nil then T["actionbar"].rightbars = 0 end
	
	if T["actionbar"].splitbar == true then
		LeftSplit:SetPoint("TOPRIGHT", TukuiSplitActionBarLeftBackground, "TOPLEFT", T.Scale(-4), 0)
		LeftSplit:SetPoint("BOTTOMLEFT", TukuiSplitActionBarLeftBackground, "BOTTOMLEFT", T.Scale(-19), 0)
		LeftSplit.Text:SetText(">")
		
		RightSplit:SetPoint("TOPLEFT", TukuiSplitActionBarRightBackground, "TOPRIGHT", T.Scale(4), 0)
		RightSplit:SetPoint("BOTTOMRIGHT", TukuiSplitActionBarRightBackground, "BOTTOMRIGHT", T.Scale(19), 0)
		RightSplit.Text:SetText("<")
	else
		LeftSplit:SetPoint("TOPRIGHT", TukuiMainMenuBar, "TOPLEFT", T.Scale(-4), 0)
		LeftSplit:SetPoint("BOTTOMLEFT", TukuiMainMenuBar, "BOTTOMLEFT", T.Scale(-19), 0)	
		
		RightSplit:SetPoint("TOPLEFT", TukuiMainMenuBar, "TOPRIGHT", T.Scale(4), 0)
		RightSplit:SetPoint("BOTTOMRIGHT", TukuiMainMenuBar, "BOTTOMRIGHT", T.Scale(19), 0)
	end
	
	if T.lowversion == true or C["actionbar"].v12 then
		if T["actionbar"].bottomrows == 3 then
			TopMainBar.Text:SetText("-")
		else
			TopMainBar.Text:SetText("+")
		end
	else
		if T["actionbar"].bottomrows == 2 then
			TopMainBar.Text:SetText("-")
		else
			TopMainBar.Text:SetText("+")
		end	
	end
	
	TopMainBar:SetPoint("BOTTOMLEFT", TukuiMainMenuBar, "TOPLEFT", 0, T.Scale(4))
	TopMainBar:SetPoint("TOPRIGHT", TukuiMainMenuBar, "TOPRIGHT", 0, T.Scale(19))
	
	if TukuiPetBar:IsShown() and not C["actionbar"].bottompetbar == true then
		RightBarBig:SetPoint("TOPRIGHT", TukuiPetBar, "LEFT", T.Scale(-3), (TukuiActionBarBackgroundRight:GetHeight() * 0.2))
		RightBarBig:SetPoint("BOTTOMLEFT", TukuiPetBar, "LEFT", T.Scale(-19), -(TukuiActionBarBackgroundRight:GetHeight() * 0.2))			
	else
		RightBarBig:SetPoint("TOPRIGHT", UIParent, "RIGHT", T.Scale(-1), (TukuiActionBarBackgroundRight:GetHeight() * 0.2))
		RightBarBig:SetPoint("BOTTOMLEFT", UIParent, "RIGHT", T.Scale(-16), -(TukuiActionBarBackgroundRight:GetHeight() * 0.2))		
	end
	
	TukuiPetBar:HookScript("OnShow", function(self)
		if C["actionbar"].bottompetbar == true then return end
		if InCombatLockdown() then return end
		RightBarBig:ClearAllPoints()
		RightBarBig:SetPoint("TOPRIGHT", TukuiPetBar, "LEFT", T.Scale(-3), (TukuiActionBarBackgroundRight:GetHeight() * 0.2))
		RightBarBig:SetPoint("BOTTOMLEFT", TukuiPetBar, "LEFT", T.Scale(-19), -(TukuiActionBarBackgroundRight:GetHeight() * 0.2))	
	end)
	
	TukuiPetBar:HookScript("OnHide", function(self)
		if InCombatLockdown() then return end
		if C["actionbar"].bottompetbar == true then return end
		RightBarBig:ClearAllPoints()
		RightBarBig:SetPoint("TOPRIGHT", UIParent, "RIGHT", T.Scale(-1), (TukuiActionBarBackgroundRight:GetHeight() * 0.2))
		RightBarBig:SetPoint("BOTTOMLEFT", UIParent, "RIGHT", T.Scale(-16), -(TukuiActionBarBackgroundRight:GetHeight() * 0.2))
	end)
	
	RightBarBig:HookScript("OnEnter", function()
		if InCombatLockdown() then return end
		RightBarBig:ClearAllPoints()
		if TukuiPetBar:IsShown() and not C["actionbar"].bottompetbar == true then
			RightBarBig:SetPoint("TOPRIGHT", TukuiPetBar, "LEFT", T.Scale(-3), (TukuiActionBarBackgroundRight:GetHeight() * 0.2))
			RightBarBig:SetPoint("BOTTOMLEFT", TukuiPetBar, "LEFT", T.Scale(-19), -(TukuiActionBarBackgroundRight:GetHeight() * 0.2))			
		else
			RightBarBig:SetPoint("TOPRIGHT", UIParent, "RIGHT", T.Scale(-1), (TukuiActionBarBackgroundRight:GetHeight() * 0.2))
			RightBarBig:SetPoint("BOTTOMLEFT", UIParent, "RIGHT", T.Scale(-16), -(TukuiActionBarBackgroundRight:GetHeight() * 0.2))		
		end
	end)
	
	if T["actionbar"].rightbars ~= 0 or (T["actionbar"].bottomrows == 3 and T["actionbar"].splitbar == true) then
		RightBarBig:Hide()
	end
	
	RightBarInc:SetParent(TukuiActionBarBackgroundRight)
	RightBarDec:SetParent(TukuiActionBarBackgroundRight)
	
	--Disable some default button stuff
	if C["actionbar"].rightbarmouseover == true then
		RightBarInc:SetScript("OnEnter", function() RightBarMouseOver(1) end)
		RightBarInc:SetScript("OnLeave", function() RightBarMouseOver(0) end)
		RightBarDec:SetScript("OnEnter", function() RightBarMouseOver(1) end)
		RightBarDec:SetScript("OnLeave", function() RightBarMouseOver(0) end)	
	else
		RightBarInc:SetScript("OnEnter", function() end)
		RightBarInc:SetScript("OnLeave", function() end)
		RightBarDec:SetScript("OnEnter", function() end)
		RightBarDec:SetScript("OnLeave", function() end)	
	end

	RightBarDec:SetAlpha(1)
	RightBarInc:SetAlpha(1)
	
	RightBarInc:SetPoint("TOPLEFT", TukuiActionBarBackgroundRight, "BOTTOMLEFT", 0, T.Scale(-4))
	RightBarInc:SetPoint("BOTTOMRIGHT", TukuiActionBarBackgroundRight, "BOTTOM", T.Scale(-2), T.Scale(-19))
	RightBarDec:SetPoint("TOPRIGHT", TukuiActionBarBackgroundRight, "BOTTOMRIGHT", 0, T.Scale(-4))
	RightBarDec:SetPoint("BOTTOMLEFT", TukuiActionBarBackgroundRight, "BOTTOM", T.Scale(2), T.Scale(-19))

	T.ABLock = false
	TukuiInfoLeftRButton.text:SetTextColor(1,1,1)
	T.PositionAllBars()
end)

--Setup button clicks
do
	LeftSplit:SetScript("OnMouseDown", function(self)
		if InCombatLockdown() then return end	
		if T["actionbar"].splitbar ~= true then
			SaveBars("splitbar", true)
			LeftSplit.Text:SetText(">")
			LeftSplit:ClearAllPoints()
			LeftSplit:SetPoint("TOPRIGHT", TukuiSplitActionBarLeftBackground, "TOPLEFT", T.Scale(-4), 0)
			LeftSplit:SetPoint("BOTTOMLEFT", TukuiSplitActionBarLeftBackground, "BOTTOMLEFT", T.Scale(-19), 0)
			
			RightSplit.Text:SetText("<")
			RightSplit:ClearAllPoints()
			RightSplit:SetPoint("TOPLEFT", TukuiSplitActionBarRightBackground, "TOPRIGHT", T.Scale(4), 0)
			RightSplit:SetPoint("BOTTOMRIGHT", TukuiSplitActionBarRightBackground, "BOTTOMRIGHT", T.Scale(19), 0)

		else
			SaveBars("splitbar", false)
			LeftSplit.Text:SetText("<")
			LeftSplit:ClearAllPoints()
			LeftSplit:SetPoint("TOPRIGHT", TukuiMainMenuBar, "TOPLEFT", T.Scale(-4), 0)
			LeftSplit:SetPoint("BOTTOMLEFT", TukuiMainMenuBar, "BOTTOMLEFT", T.Scale(-19), 0)
	
			RightSplit.Text:SetText(">")
			RightSplit:ClearAllPoints()
			RightSplit:SetPoint("TOPLEFT", TukuiMainMenuBar, "TOPRIGHT", T.Scale(4), 0)
			RightSplit:SetPoint("BOTTOMRIGHT", TukuiMainMenuBar, "BOTTOMRIGHT", T.Scale(19), 0)
		end
		
		if (T.lowversion ~= true and C["actionbar"].v12 ~= true) and T["actionbar"].rightbars > 2 and T["actionbar"].splitbar == true and T["actionbar"].bottomrows == 1 then
			SaveBars("rightbars", 2)
		elseif (T.lowversion ~= true and C["actionbar"].v12 ~= true) and T["actionbar"].rightbars > 1 and T["actionbar"].splitbar == true and T["actionbar"].bottomrows == 2 then
			SaveBars("rightbars", 1)
		end	
		
		if (T.lowversion == true or C["actionbar"].v12) and T["actionbar"].splitbar ~= true and T.actionbar.bottomrows == 3 then
			SaveBars("rightbars", 0)	
			RightBarBig:Show()
			RightBarBig:ClearAllPoints()
			if TukuiPetBar:IsShown() and not C["actionbar"].bottompetbar == true then
				RightBarBig:SetPoint("TOPRIGHT", TukuiPetBar, "LEFT", T.Scale(-3), (TukuiActionBarBackgroundRight:GetHeight() * 0.2))
				RightBarBig:SetPoint("BOTTOMLEFT", TukuiPetBar, "LEFT", T.Scale(-19), -(TukuiActionBarBackgroundRight:GetHeight() * 0.2))			
			else
				RightBarBig:SetPoint("TOPRIGHT", UIParent, "RIGHT", T.Scale(-1), (TukuiActionBarBackgroundRight:GetHeight() * 0.2))
				RightBarBig:SetPoint("BOTTOMLEFT", UIParent, "RIGHT", T.Scale(-16), -(TukuiActionBarBackgroundRight:GetHeight() * 0.2))		
			end	
		elseif T.lowversion == true and T.actionbar.bottomrows == 3 then
			RightBarBig:Hide()
		end	
	end)
	
	RightSplit:SetScript("OnMouseDown", function(self)
		if InCombatLockdown() then return end
		
		if T["actionbar"].splitbar ~= true then
			SaveBars("splitbar", true)
			LeftSplit.Text:SetText(">")
			LeftSplit:ClearAllPoints()
			LeftSplit:SetPoint("TOPRIGHT", TukuiSplitActionBarLeftBackground, "TOPLEFT", T.Scale(-4), 0)
			LeftSplit:SetPoint("BOTTOMLEFT", TukuiSplitActionBarLeftBackground, "BOTTOMLEFT", T.Scale(-19), 0)
			
			RightSplit.Text:SetText("<")
			RightSplit:ClearAllPoints()
			RightSplit:SetPoint("TOPLEFT", TukuiSplitActionBarRightBackground, "TOPRIGHT", T.Scale(4), 0)
			RightSplit:SetPoint("BOTTOMRIGHT", TukuiSplitActionBarRightBackground, "BOTTOMRIGHT", T.Scale(19), 0)				
		else
			SaveBars("splitbar", false)
			LeftSplit.Text:SetText("<")
			LeftSplit:ClearAllPoints()
			LeftSplit:SetPoint("TOPRIGHT", TukuiMainMenuBar, "TOPLEFT", T.Scale(-4), 0)
			LeftSplit:SetPoint("BOTTOMLEFT", TukuiMainMenuBar, "BOTTOMLEFT", T.Scale(-19), 0)
			
			RightSplit.Text:SetText(">")
			RightSplit:ClearAllPoints()
			RightSplit:SetPoint("TOPLEFT", TukuiMainMenuBar, "TOPRIGHT", T.Scale(4), 0)
			RightSplit:SetPoint("BOTTOMRIGHT", TukuiMainMenuBar, "BOTTOMRIGHT", T.Scale(19), 0)
		end
			
		if (T.lowversion ~= true and C["actionbar"].v12 ~= true) and T["actionbar"].rightbars > 2 and T["actionbar"].splitbar == true and T["actionbar"].bottomrows == 1 then
			SaveBars("rightbars", 2)
		elseif (T.lowversion ~= true and C["actionbar"].v12 ~= true) and T["actionbar"].rightbars > 1 and T["actionbar"].splitbar == true and T["actionbar"].bottomrows == 2 then
			SaveBars("rightbars", 1)
		end
		
		if (T.lowversion == true or C["actionbar"].v12) and T["actionbar"].splitbar ~= true and T.actionbar.bottomrows == 3 then
			SaveBars("rightbars", 0)	
			RightBarBig:Show()
			RightBarBig:ClearAllPoints()
			if TukuiPetBar:IsShown() and not C["actionbar"].bottompetbar == true then
				RightBarBig:SetPoint("TOPRIGHT", TukuiPetBar, "LEFT", T.Scale(-3), (TukuiActionBarBackgroundRight:GetHeight() * 0.2))
				RightBarBig:SetPoint("BOTTOMLEFT", TukuiPetBar, "LEFT", T.Scale(-19), -(TukuiActionBarBackgroundRight:GetHeight() * 0.2))			
			else
				RightBarBig:SetPoint("TOPRIGHT", UIParent, "RIGHT", T.Scale(-1), (TukuiActionBarBackgroundRight:GetHeight() * 0.2))
				RightBarBig:SetPoint("BOTTOMLEFT", UIParent, "RIGHT", T.Scale(-16), -(TukuiActionBarBackgroundRight:GetHeight() * 0.2))		
			end	
		elseif T.lowversion == true and T.actionbar.bottomrows == 3 then
			RightBarBig:Hide()
			SaveBars("rightbars", 0)			
		end		
	end)
	
	TopMainBar:SetScript("OnMouseDown", function(self)
		if InCombatLockdown() then return end
		
		if T.lowversion == true or C["actionbar"].v12 then
			if T["actionbar"].bottomrows == 1 then
				SaveBars("bottomrows", 2)
				TopMainBar.Text:SetText("+")
			elseif T["actionbar"].bottomrows == 2 then
				SaveBars("bottomrows", 3)
				TopMainBar.Text:SetText("-")
				
				if T["actionbar"].splitbar == true then
					SaveBars("rightbars", 0)
					RightBarBig:Hide()		
				end
			elseif T["actionbar"].bottomrows == 3 then
				SaveBars("bottomrows", 1)
				TopMainBar.Text:SetText("+")
			end
			
			if T["actionbar"].bottomrows ~= 3 and T["actionbar"].rightbars == 0 then
				RightBarBig:Show()
				RightBarBig:ClearAllPoints()
				if TukuiPetBar:IsShown() and not C["actionbar"].bottompetbar == true then
					RightBarBig:SetPoint("TOPRIGHT", TukuiPetBar, "LEFT", T.Scale(-3), (TukuiActionBarBackgroundRight:GetHeight() * 0.2))
					RightBarBig:SetPoint("BOTTOMLEFT", TukuiPetBar, "LEFT", T.Scale(-19), -(TukuiActionBarBackgroundRight:GetHeight() * 0.2))			
				else
					RightBarBig:SetPoint("TOPRIGHT", UIParent, "RIGHT", T.Scale(-1), (TukuiActionBarBackgroundRight:GetHeight() * 0.2))
					RightBarBig:SetPoint("BOTTOMLEFT", UIParent, "RIGHT", T.Scale(-16), -(TukuiActionBarBackgroundRight:GetHeight() * 0.2))		
				end	
			end
		else
			if T["actionbar"].bottomrows == 1 then
				SaveBars("bottomrows", 2)
				TopMainBar.Text:SetText("-")	
				if T["actionbar"].rightbars > 0 and T["actionbar"].splitbar == true then
					SaveBars("rightbars", 1)
				end
			else
				SaveBars("bottomrows", 1)
				TopMainBar.Text:SetText("+")			
			end
		end
	end)
	
	RightBarBig:SetScript("OnMouseDown", function(self)
		if InCombatLockdown() then return end
		if C["actionbar"].rightbarmouseover ~= true then 
			TukuiActionBarBackgroundRight:Show()
		else
			TukuiActionBarBackgroundRight:SetAlpha(0)
		end
		SaveBars("rightbars", 1)
		self:Hide()
	end)
	
	RightBarInc:SetScript("OnMouseDown", function(self)
		if InCombatLockdown() then return end
		
		if T.lowversion == true or C["actionbar"].v12 then
			if T["actionbar"].rightbars == 1 then
				SaveBars("rightbars", 2)
			elseif T["actionbar"].rightbars == 2 then
				SaveBars("rightbars", 0)
				RightBarBig:Show()
				RightBarBig:ClearAllPoints()
				if TukuiPetBar:IsShown() and not C["actionbar"].bottompetbar == true then
					RightBarBig:SetPoint("TOPRIGHT", TukuiPetBar, "LEFT", T.Scale(-3), (TukuiActionBarBackgroundRight:GetHeight() * 0.2))
					RightBarBig:SetPoint("BOTTOMLEFT", TukuiPetBar, "LEFT", T.Scale(-19), -(TukuiActionBarBackgroundRight:GetHeight() * 0.2))			
				else
					RightBarBig:SetPoint("TOPRIGHT", UIParent, "RIGHT", T.Scale(-1), (TukuiActionBarBackgroundRight:GetHeight() * 0.2))
					RightBarBig:SetPoint("BOTTOMLEFT", UIParent, "RIGHT", T.Scale(-16), -(TukuiActionBarBackgroundRight:GetHeight() * 0.2))		
				end			
			end
		else
			if T["actionbar"].rightbars == 1 then
				if T["actionbar"].splitbar == true then
					SaveBars("splitbar", false)
					LeftSplit.Text:SetText("<")
					LeftSplit:ClearAllPoints()
					LeftSplit:SetPoint("TOPRIGHT", TukuiMainMenuBar, "TOPLEFT", T.Scale(-4), 0)
					LeftSplit:SetPoint("BOTTOMLEFT", TukuiMainMenuBar, "BOTTOMLEFT", T.Scale(-19), 0)
					
					RightSplit.Text:SetText(">")
					RightSplit:ClearAllPoints()
					RightSplit:SetPoint("TOPLEFT", TukuiMainMenuBar, "TOPRIGHT", T.Scale(4), 0)
					RightSplit:SetPoint("BOTTOMRIGHT", TukuiMainMenuBar, "BOTTOMRIGHT", T.Scale(19), 0)					
				end
				SaveBars("rightbars", 2)
			elseif T["actionbar"].rightbars == 2 then
				if T["actionbar"].splitbar == true then
					SaveBars("splitbar", false)
					LeftSplit.Text:SetText("<")
					LeftSplit:ClearAllPoints()
					LeftSplit:SetPoint("TOPRIGHT", TukuiMainMenuBar, "TOPLEFT", T.Scale(-4), 0)
					LeftSplit:SetPoint("BOTTOMLEFT", TukuiMainMenuBar, "BOTTOMLEFT", T.Scale(-19), 0)
					
					RightSplit.Text:SetText(">")
					RightSplit:ClearAllPoints()
					RightSplit:SetPoint("TOPLEFT", TukuiMainMenuBar, "TOPRIGHT", T.Scale(4), 0)
					RightSplit:SetPoint("BOTTOMRIGHT", TukuiMainMenuBar, "BOTTOMRIGHT", T.Scale(19), 0)					
				end	
				SaveBars("rightbars", 3)				
			elseif T["actionbar"].rightbars == 3 then
				SaveBars("rightbars", 0)
				RightBarBig:Show()
				RightBarBig:ClearAllPoints()
				if TukuiPetBar:IsShown() and not C["actionbar"].bottompetbar == true then
					RightBarBig:SetPoint("TOPRIGHT", TukuiPetBar, "LEFT", T.Scale(-3), (TukuiActionBarBackgroundRight:GetHeight() * 0.2))
					RightBarBig:SetPoint("BOTTOMLEFT", TukuiPetBar, "LEFT", T.Scale(-19), -(TukuiActionBarBackgroundRight:GetHeight() * 0.2))			
				else
					RightBarBig:SetPoint("TOPRIGHT", UIParent, "RIGHT", T.Scale(-1), (TukuiActionBarBackgroundRight:GetHeight() * 0.2))
					RightBarBig:SetPoint("BOTTOMLEFT", UIParent, "RIGHT", T.Scale(-16), -(TukuiActionBarBackgroundRight:GetHeight() * 0.2))		
				end			
			end		
		end
		if C["actionbar"].rightbarmouseover == true then 
			RightBarMouseOver(1)
		end
	end)
	
	RightBarDec:SetScript("OnMouseDown", function(self)
		if InCombatLockdown() then return end
		
		if T.lowversion == true or C["actionbar"].v12 then
			if T["actionbar"].rightbars == 1 then
				SaveBars("rightbars", 0)
				RightBarBig:Show()
				RightBarBig:ClearAllPoints()
				if TukuiPetBar:IsShown() and not C["actionbar"].bottompetbar == true then
					RightBarBig:SetPoint("TOPRIGHT", TukuiPetBar, "LEFT", T.Scale(-3), (TukuiActionBarBackgroundRight:GetHeight() * 0.2))
					RightBarBig:SetPoint("BOTTOMLEFT", TukuiPetBar, "LEFT", T.Scale(-19), -(TukuiActionBarBackgroundRight:GetHeight() * 0.2))			
				else
					RightBarBig:SetPoint("TOPRIGHT", UIParent, "RIGHT", T.Scale(-1), (TukuiActionBarBackgroundRight:GetHeight() * 0.2))
					RightBarBig:SetPoint("BOTTOMLEFT", UIParent, "RIGHT", T.Scale(-16), -(TukuiActionBarBackgroundRight:GetHeight() * 0.2))		
				end
			else
				SaveBars("rightbars", 1)
			end		
		else
			if T["actionbar"].rightbars == 1 then
				SaveBars("rightbars", 0)
				RightBarBig:Show()
				RightBarBig:ClearAllPoints()
				if TukuiPetBar:IsShown() and not C["actionbar"].bottompetbar == true then
					RightBarBig:SetPoint("TOPRIGHT", TukuiPetBar, "LEFT", T.Scale(-3), (TukuiActionBarBackgroundRight:GetHeight() * 0.2))
					RightBarBig:SetPoint("BOTTOMLEFT", TukuiPetBar, "LEFT", T.Scale(-19), -(TukuiActionBarBackgroundRight:GetHeight() * 0.2))			
				else
					RightBarBig:SetPoint("TOPRIGHT", UIParent, "RIGHT", T.Scale(-1), (TukuiActionBarBackgroundRight:GetHeight() * 0.2))
					RightBarBig:SetPoint("BOTTOMLEFT", UIParent, "RIGHT", T.Scale(-16), -(TukuiActionBarBackgroundRight:GetHeight() * 0.2))		
				end		
			elseif T["actionbar"].rightbars == 2 then
				SaveBars("rightbars", 1)
			else
				SaveBars("rightbars", 2)
			end
		end
		
		if C["actionbar"].rightbarmouseover == true then 
			RightBarMouseOver(1)
		end
	end)
end