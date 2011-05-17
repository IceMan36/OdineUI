local T, C, L, DB = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

if not C["actionbar"].enable == true then return end


---------------------------------------------------------------------------
-- setup MultiBarLeft as bar #3
---------------------------------------------------------------------------

local TukuiBar3 = CreateFrame("Frame","TukuiBar3",TukuiActionBarBackground) -- bottomrightbar
TukuiBar3:SetAllPoints(TukuiActionBarBackground)
MultiBarLeft:SetParent(TukuiBar3)

local TukuiBar3Split = CreateFrame("Frame", nil, TukuiBar3)

function T.PositionBar3()
	TukuiBar3Split:Show()
	for i= 1, 12 do
		local b = _G["MultiBarLeftButton"..i]
		local b2 = _G["MultiBarLeftButton"..i-1]
		b:ClearAllPoints()
		b:Show()
		b:SetParent(MultiBarLeft)
		b:SetAlpha(1)
		if T.lowversion ~= true then
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
		else
			if T["actionbar"].splitbar ~= true and T["actionbar"].bottomrows == 3 then
				if C["actionbar"].swaptopbottombar == true and i == 1 then
					b:SetPoint("TOP", MultiBarBottomLeftButton1, "BOTTOM", 0, -T.buttonspacing)
				elseif i == 1 then
					b:SetPoint("BOTTOM", MultiBarBottomLeftButton1, "TOP", 0, T.buttonspacing)
				else
					b:SetPoint("LEFT", b2, "RIGHT", T.buttonspacing, 0)
				end
			else
				if i > 6 and T["actionbar"].bottomrows == 1 then
					b:Hide()
					b:SetParent(TukuiBar3Split)
					TukuiBar3Split:Hide()
				end
				
				if i == 1 then
					b:SetPoint("BOTTOMLEFT", TukuiSplitActionBarLeftBackground, "BOTTOMLEFT", T.buttonspacing, T.buttonspacing)
				elseif i == 4 then
					b:SetPoint("BOTTOMLEFT", TukuiSplitActionBarRightBackground, "BOTTOMLEFT", T.buttonspacing, T.buttonspacing)
				elseif i == 7 then
					b:SetPoint("BOTTOM", MultiBarLeftButton1, "TOP", 0, T.buttonspacing)
				elseif i == 10 then
					b:SetPoint("BOTTOM", MultiBarLeftButton4, "TOP", 0, T.buttonspacing)
				else
					b:SetPoint("LEFT", b2, "RIGHT", T.buttonspacing, 0)
				end
			end
		end
	
	end
	
	-- hide it if needed
	if T.lowversion ~= true then
		if T["actionbar"].rightbars > 0 then
			TukuiBar3:Show()
		else
			TukuiBar3:Hide()
		end	
	else
		if T["actionbar"].bottomrows ~= 3 and T["actionbar"].splitbar ~= true then
			TukuiBar3:Hide()
		else
			TukuiBar3:Show()
		end
	end	
end