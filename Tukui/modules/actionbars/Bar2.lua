local T, C, L, DB = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

if not C["actionbar"].enable == true then return end

---------------------------------------------------------------------------
-- setup MultiBarBottomLeft as bar #2
---------------------------------------------------------------------------

local TukuiBar2 = CreateFrame("Frame","TukuiBar2",TukuiActionBarBackground)
TukuiBar2:SetAllPoints(TukuiActionBarBackground)
MultiBarBottomLeft:SetParent(TukuiBar2)

function T.PositionBar2()
	for i=1, 12 do
		local b = _G["MultiBarBottomLeftButton"..i]
		local b2 = _G["MultiBarBottomLeftButton"..i-1]
		b:ClearAllPoints()
		if i == 1 then
			if C["actionbar"].swaptopbottombar == true then
				b:SetPoint("TOP", ActionButton1, "BOTTOM", 0, -T.buttonspacing)
			else
				b:SetPoint("BOTTOM", ActionButton1, "TOP", 0, T.buttonspacing)
			end
		else
			b:SetPoint("LEFT", b2, "RIGHT", T.buttonspacing, 0)
		end
	end
	-- hide it if needed
	if T.actionbar.bottomrows == 1 then
		TukuiBar2:Hide()
	else
		TukuiBar2:Show()
	end
end
