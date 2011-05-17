local T, C, L, DB = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

if not C["actionbar"].enable == true then return end


---------------------------------------------------------------------------
-- setup MultiBarBottomRight as bar #5
---------------------------------------------------------------------------

local TukuiBar5 = CreateFrame("Frame","TukuiBar5",TukuiActionBarBackground) -- MultiBarBottomRight
TukuiBar5:SetAllPoints(TukuiActionBarBackground)
MultiBarBottomRight:SetParent(TukuiBar5)

function T.PositionBar5()
	for i= 1, 12 do
		local b = _G["MultiBarBottomRightButton"..i]
		local b2 = _G["MultiBarBottomRightButton"..i-1]
		b:ClearAllPoints()
		b:SetAlpha(1)
		b:Show()
		
		if T.lowversion ~= true then
			if T["actionbar"].splitbar == true and T["actionbar"].bottomrows == 2 then
				if i == 1 then
					b:SetPoint("TOPLEFT", TukuiSplitActionBarLeftBackground, "TOPLEFT", T.buttonspacing, -T.buttonspacing)
				elseif i == 7 then
					b:SetPoint("TOPLEFT", TukuiSplitActionBarRightBackground, "TOPLEFT", T.buttonspacing, -T.buttonspacing)
				else
					b:SetPoint("LEFT", b2, "RIGHT", T.buttonspacing, 0)
				end
			else
				if i == 1 then
					b:SetPoint("TOPRIGHT", MultiBarLeftButton1, "TOPLEFT", -T.buttonspacing, 0)
				else
					b:SetPoint("TOP", b2, "BOTTOM", 0, -T.buttonspacing)
				end
			
				if C["actionbar"].rightbarmouseover == true then
					b:SetAlpha(0)
					b:HookScript("OnEnter", function() RightBarMouseOver(1) end)
					b:HookScript("OnLeave", function() RightBarMouseOver(0) end)			
				end						
			end
		else
			if T["actionbar"].splitbar == true and T["actionbar"].bottomrows == 3 then
				if C["actionbar"].swaptopbottombar == true and i == 1 then
					b:SetPoint("TOP", MultiBarBottomLeftButton1, "BOTTOM", 0, -T.buttonspacing)
				elseif i == 1 then
					b:SetPoint("BOTTOM", MultiBarBottomLeftButton1, "TOP", 0, T.buttonspacing)
				else
					b:SetPoint("LEFT", b2, "RIGHT", T.buttonspacing, 0)
				end
			else
				if i == 1 then
					b:SetPoint("TOPLEFT", TukuiActionBarBackgroundRight, "TOPLEFT", T.buttonspacing, -T.buttonspacing)
				else
					b:SetPoint("TOP", b2, "BOTTOM", 0, -T.buttonspacing)
				end
				
				if C["actionbar"].rightbarmouseover == true then
					b:SetAlpha(0)
					b:HookScript("OnEnter", function() RightBarMouseOver(1) end)
					b:HookScript("OnLeave", function() RightBarMouseOver(0) end)			
				end			
			end
		end

	end

	-- hide it if needed
	if T.lowversion ~= true then
		if (T["actionbar"].splitbar == true and T["actionbar"].bottomrows == 2) or T["actionbar"].rightbars > 1 then
			TukuiBar5:Show()
		else
			TukuiBar5:Hide()
		end
	else
		if (T["actionbar"].splitbar == true and T["actionbar"].bottomrows == 3) or T["actionbar"].rightbars > 1 then
			TukuiBar5:Show()
		else
			TukuiBar5:Hide()
		end	
	end
end


