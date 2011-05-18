local T, C, L, DB = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

local TukuiWatchFrame = CreateFrame("Frame", "TukuiWatchFrame", UIParent)
TukuiWatchFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

-- to be compatible with blizzard option
local wideFrame = GetCVar("watchFrameWidth")

-- lots of code unfinished to go with new mover functionality soon.. shouldnt cuase lua errors atm


-- create our moving area
local TukuiWatchFrameAnchor = CreateFrame("Button", "TukuiWatchFrameAnchor", UIParent)
TukuiWatchFrameAnchor:SetFrameStrata("HIGH")
TukuiWatchFrameAnchor:SetFrameLevel(20)
TukuiWatchFrameAnchor:SetHeight(20)
TukuiWatchFrameAnchor:SetClampedToScreen(true)
TukuiWatchFrameAnchor:SetMovable(true)
TukuiWatchFrameAnchor:EnableMouse(false)
TukuiWatchFrameAnchor:SetTemplate("Default", true)
TukuiWatchFrameAnchor:SetBackdropBorderColor(0,0,0,0)
TukuiWatchFrameAnchor:SetBackdropColor(0,0,0,0)
TukuiWatchFrameAnchor.text = T.SetFontString(TukuiWatchFrameAnchor, C["media"].font, 12, "OUTLINE")
TukuiWatchFrameAnchor.text:SetPoint("CENTER")
TukuiWatchFrameAnchor.text:SetText(L.move_watchframe)
TukuiWatchFrameAnchor.text:Hide()
TukuiWatchFrameAnchor:Point("TOPLEFT", UIParent, 35, -115)

-- width of the watchframe according to our Blizzard cVar.
if wideFrame == "1" then
	TukuiWatchFrame:SetWidth(350)
	TukuiWatchFrameAnchor:SetWidth(350)
else
	TukuiWatchFrame:SetWidth(250)
	TukuiWatchFrameAnchor:SetWidth(250)
end

local function init()
	TukuiWatchFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
	TukuiWatchFrame:RegisterEvent("CVAR_UPDATE")
	TukuiWatchFrame:SetScript("OnEvent", function(_,_,cvar,value)
		SetCVar("watchFrameWidth", 0)
		TukuiWatchFrame:SetWidth(250)
		InterfaceOptionsObjectivesPanelWatchFrameWidth:Hide()
	end)
	
	TukuiWatchFrame:ClearAllPoints()
	TukuiWatchFrame:SetPoint("TOP", TukuiWatchFrameAnchor, "TOP", 0, 0)
end

function T.PostWatchMove()
	if T.Movers["WatchFrameMover"]["moved"] == false then
		T.PositionWatchFrame()
	end
end

function T.PositionWatchFrame()
	if fired == true and T.Movers["WatchFrameMover"]["moved"] == true then return end
	
	if WatchFrameMover then
		if T.Movers["WatchFrameMover"]["moved"] == true then return end
		
		WatchFrameMover:ClearAllPoints()
		if T.actionbar then	
			if T.actionbar.rightbars == 3 then
				if C["actionbar"].bottompetbar ~= true then
					WatchFrameMover:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", T.Scale(-210), T.Scale(-300))
				else
					WatchFrameMover:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", T.Scale(-165), T.Scale(-300))
				end
			elseif T.actionbar.rightbars == 2 then
				if C["actionbar"].bottompetbar ~= true then
					WatchFrameMover:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", T.Scale(-190), T.Scale(-300))
				else
					WatchFrameMover:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", T.Scale(-140), T.Scale(-300))
				end
			elseif T.actionbar.rightbars == 1 then
				if C["actionbar"].bottompetbar ~= true then
					WatchFrameMover:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", T.Scale(-160), T.Scale(-300))
				else
					WatchFrameMover:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", T.Scale(-110), T.Scale(-300))
				end
			else
				if C["actionbar"].bottompetbar ~= true then
					WatchFrameMover:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", T.Scale(-120), T.Scale(-300))
				else
					WatchFrameMover:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", T.Scale(-70), T.Scale(-300))
				end
			end
		end
	else
		
		TukuiWatchFrameAnchor:ClearAllPoints()
		if T.actionbar then
			if C["actionbar"].enable and T.actionbar.rightbars == 3 then
				if C["actionbar"].bottompetbar ~= true then
					TukuiWatchFrameAnchor:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", T.Scale(-210), T.Scale(-300))
				else
					TukuiWatchFrameAnchor:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", T.Scale(-165), T.Scale(-300))
				end
			elseif C["actionbar"].enable and T.actionbar.rightbars == 2 then
				if C["actionbar"].bottompetbar ~= true then
					TukuiWatchFrameAnchor:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", T.Scale(-190), T.Scale(-300))
				else
					TukuiWatchFrameAnchor:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", T.Scale(-140), T.Scale(-300))
				end
			elseif C["actionbar"].enable and T.actionbar.rightbars == 1 then
				if C["actionbar"].bottompetbar ~= true then
					TukuiWatchFrameAnchor:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", T.Scale(-160), T.Scale(-300))
				else
					TukuiWatchFrameAnchor:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", T.Scale(-110), T.Scale(-300))
				end
			else
				if C["actionbar"].bottompetbar ~= true then
					TukuiWatchFrameAnchor:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", T.Scale(-120), T.Scale(-300))
				else
					TukuiWatchFrameAnchor:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", T.Scale(-70), T.Scale(-300))
				end
			end
		else
			TukuiWatchFrameAnchor:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", T.Scale(-120), T.Scale(-300))			
		end
	end
end

local function setup()
	T.PositionWatchFrame()
	
	local screenheight = GetScreenHeight()
	TukuiWatchFrame:SetSize(1,screenheight / 2)
	TukuiWatchFrame:SetWidth(250)
	
	WatchFrame:SetParent(TukuiWatchFrame)
	WatchFrame:SetClampedToScreen(false)
	WatchFrame:ClearAllPoints()
	WatchFrame.ClearAllPoints = function() end
	WatchFrame:SetPoint("TOPLEFT", 32,-2.5)
	WatchFrame:SetPoint("BOTTOMRIGHT", 4,0)
	WatchFrame.SetPoint = T.dummy
	
	WatchFrameTitle:SetParent(TukuiWatchFrame)
	WatchFrameCollapseExpandButton:SetParent(TukuiWatchFrame)
	WatchFrameCollapseExpandButton:SetFrameStrata(WatchFrameHeader:GetFrameStrata())
	WatchFrameCollapseExpandButton:SetFrameLevel(WatchFrameHeader:GetFrameLevel() + 1)
	WatchFrameCollapseExpandButton:SetNormalTexture("")
	WatchFrameCollapseExpandButton:SetPushedTexture("")
	WatchFrameCollapseExpandButton:SetHighlightTexture("")
	WatchFrameCollapseExpandButton:SetTemplate("Default")
	WatchFrameCollapseExpandButton:FontString("text", C.media.font, 12, "OUTLINE")
	WatchFrameCollapseExpandButton.text:SetText("X")
	WatchFrameCollapseExpandButton.text:Point("CENTER", 1, 1)
	WatchFrameCollapseExpandButton:HookScript("OnClick", function(self) 
		if WatchFrame.collapsed then 
			self.text:SetText("V") 
		else 
			self.text:SetText("X")
		end 
	end)
	WatchFrameTitle:Kill()
end


------------------------------------------------------------------------
-- Execute setup after we enter world
------------------------------------------------------------------------

local f = CreateFrame("Frame")
f:Hide()
f.elapsed = 0
f:SetScript("OnUpdate", function(self, elapsed)
	f.elapsed = f.elapsed + elapsed
	if f.elapsed > .5 then
		setup()
		f:Hide()
	end
end)
TukuiWatchFrame:SetScript("OnEvent", function() if not IsAddOnLoaded("Who Framed Watcher Wabbit") or not IsAddOnLoaded("Fux") then init() f:Show() end end)