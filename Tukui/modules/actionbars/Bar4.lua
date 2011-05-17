local T, C, L, DB = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

if not C["actionbar"].enable == true then return end


---------------------------------------------------------------------------
-- setup MultiBarRight as bar #4
---------------------------------------------------------------------------

local TukuiBar4 = CreateFrame("Frame","TukuiBar4",TukuiActionBarBackground) -- bottomrightbar
TukuiBar4:SetAllPoints(TukuiActionBarBackground)
MultiBarRight:SetParent(TukuiBar4)

function T.PositionBar4()
	for i= 1, 12 do
		local b = _G["MultiBarRightButton"..i]
		local b2 = _G["MultiBarRightButton"..i-1]
		b:ClearAllPoints()
		b:SetAlpha(1)
		b:Show()
		
		if T.lowversion ~= true then
			if T["actionbar"].splitbar == true then
				if i == 1 then
					b:SetPoint("BOTTOMLEFT", TukuiSplitActionBarLeftBackground, "BOTTOMLEFT", T.buttonspacing, T.buttonspacing)
				elseif i == 7 then
					b:SetPoint("BOTTOMLEFT", TukuiSplitActionBarRightBackground, "BOTTOMLEFT", T.buttonspacing, T.buttonspacing)
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
		else
			if T["actionbar"].splitbar == true and T["actionbar"].bottomrows == 3 then
				if i == 1 then
					b:SetPoint("TOPLEFT", TukuiSplitActionBarLeftBackground, "TOPLEFT", T.buttonspacing, -T.buttonspacing)
				elseif (i > 1 and i < 5) or (i > 7 and i < 11) then
					b:SetPoint("LEFT", b2, "RIGHT", T.buttonspacing, 0)
				elseif i == 5 or i == 6 or i == 11 or i == 12 then
					b:SetPoint("TOP", b2, "BOTTOM", 0, -T.buttonspacing)
				elseif i == 7 then 
					b:SetPoint("TOPLEFT", TukuiSplitActionBarRightBackground, "TOPLEFT", T.buttonspacing, -T.buttonspacing)
				end
			else
				if i == 1 then
					b:SetPoint("TOPRIGHT", TukuiActionBarBackgroundRight, "TOPRIGHT", -T.buttonspacing, -T.buttonspacing)
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
		if T["actionbar"].splitbar == true or T["actionbar"].rightbars > 2 then
			TukuiBar4:Show()
		else
			TukuiBar4:Hide()
		end
	else
		if (T["actionbar"].splitbar == true and T["actionbar"].bottomrows == 3) or T["actionbar"].rightbars > 0 then
			TukuiBar4:Show()
		else
			TukuiBar4:Hide()
		end	
	end
end
