local T, C, L, DB = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales


if not IsAddOnLoaded("Recount") or C["addonskins"].recount == false then return end
local Recount = _G.Recount

local function SkinFrame(frame)
	frame.bgMain = CreateFrame("Frame", nil, frame)
	frame.bgMain:SetTemplate("Transparent")
	frame.bgMain:CreateShadow("Default")
	frame.bgMain:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT")
	frame.bgMain:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT")
	frame.bgMain:SetPoint("TOP", frame, "TOP", 0, -7)
	frame.bgMain:SetFrameLevel(frame:GetFrameLevel())
	frame.CloseButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -1, -9)
	frame:SetBackdrop(nil)
end

-- Override bar textures
Recount.UpdateBarTextures = function(self)
	for k, v in pairs(Recount.MainWindow.Rows) do
		v.StatusBar:SetStatusBarTexture(C["media"].normTex)
		v.StatusBar:GetStatusBarTexture():SetHorizTile(false)
		v.StatusBar:GetStatusBarTexture():SetVertTile(false)
	end
	Recount:SetFont(C["media"].font)
end
Recount.SetBarTextures = Recount.UpdateBarTextures

-- Fix bar textures as they're created
Recount.SetupBar_ = Recount.SetupBar
Recount.SetupBar = function(self, bar)
	self:SetupBar_(bar)
	bar.StatusBar:SetStatusBarTexture(C["media"].normTex)
end

-- Skin frames when they're created
Recount.CreateFrame_ = Recount.CreateFrame
Recount.CreateFrame = function(self, Name, Title, Height, Width, ShowFunc, HideFunc)
	local frame = self:CreateFrame_(Name, Title, Height, Width, ShowFunc, HideFunc)
	SkinFrame(frame)
	return frame
end

-- Skin existing frames
if Recount.MainWindow then SkinFrame(Recount.MainWindow) end
if Recount.ConfigWindow then SkinFrame(Recount.ConfigWindow) end
if Recount.GraphWindow then SkinFrame(Recount.GraphWindow) end
if Recount.DetailWindow then SkinFrame(Recount.DetailWindow) end
if Recount.ResetFrame then SkinFrame(Recount.ResetFrame) end
if _G["Recount_Realtime_!RAID_DAMAGE"] then SkinFrame(_G["Recount_Realtime_!RAID_DAMAGE"].Window) end
if _G["Recount_Realtime_!RAID_HEALING"] then SkinFrame(_G["Recount_Realtime_!RAID_HEALING"].Window) end
if _G["Recount_Realtime_!RAID_HEALINGTAKEN"] then SkinFrame(_G["Recount_Realtime_!RAID_HEALINGTAKEN"].Window) end
if _G["Recount_Realtime_!RAID_DAMAGETAKEN"] then SkinFrame(_G["Recount_Realtime_!RAID_DAMAGETAKEN"].Window) end
if _G["Recount_Realtime_Bandwidth Available_AVAILABLE_BANDWIDTH"] then SkinFrame(_G["Recount_Realtime_Bandwidth Available_AVAILABLE_BANDWIDTH"].Window) end
if _G["Recount_Realtime_FPS_FPS"] then SkinFrame(_G["Recount_Realtime_FPS_FPS"].Window) end
if _G["Recount_Realtime_Latency_LAG"] then SkinFrame(_G["Recount_Realtime_Latency_LAG"].Window) end
if _G["Recount_Realtime_Downstream Traffic_DOWN_TRAFFIC"] then SkinFrame(_G["Recount_Realtime_Downstream Traffic_DOWN_TRAFFIC"].Window) end
if _G["Recount_Realtime_Upstream Traffic_UP_TRAFFIC"] then SkinFrame(_G["Recount_Realtime_Upstream Traffic_UP_TRAFFIC"].Window) end

--Update Textures
Recount:UpdateBarTextures()

if C["addonskins"].embed == "Recount" then
	local Recount_Skin = CreateFrame("Frame")
	Recount_Skin:RegisterEvent("PLAYER_ENTERING_WORLD")
	Recount_Skin:SetScript("OnEvent", function(self)
		self:UnregisterAllEvents()
		self = nil

		Recount_MainWindow:ClearAllPoints()
		Recount_MainWindow:SetPoint("TOPLEFT", ChatRBackground2,"TOPLEFT", 0, 7)
		Recount_MainWindow:SetPoint("BOTTOMRIGHT", ChatRBackground2,"BOTTOMRIGHT", 0, 0)
		Recount.db.profile.FrameStrata = "4-HIGH"
		Recount.db.profile.MainWindowWidth = (C["chat"].width - 4)	
	end)
	
	local ctab = CreateFrame("Frame", "TukuiEmbedBar", ChatRBackground2)
	ctab:SetHeight(T.Scale(22))
	ctab:SetWidth(T.Scale(C["chat"].width))
	ctab:SetFrameLevel(3)	
	ctab:SetPoint("TOPLEFT", 0, 25)
	ctab:SetTemplate("Default", true)
	ctab:CreateShadow("Default")
	ctab:Hide()
	Recount_MainWindow:Hide()
	
	ctab.text = T.SetFontString(ctab, C["media"].dfont, C["datatext"].fsize, "OUTLINE")
	ctab.text:SetPoint("LEFT", ctab, "LEFT", 10, 0)
	ctab.text:SetText(T.cStart.."Recount")
	
	TukuiInfoRightLButton.hovered = false
	TukuiInfoRightLButton:SetScript("OnMouseDown", function(self)
		
		if TukuiInfoRightLButton.hovered == true then
			GameTooltip:ClearLines()
			if IsAddOnLoaded("Recount") and Recount.MainWindow:IsShown() then
				GameTooltip:AddDoubleLine("Toggle Recount", SHOW,1,1,1,unpack(C["media"].txtcolor))
				TukuiInfoRightLButton.text:SetTextColor(1,1,1)
				ctab:Hide()
				Recount.MainWindow:Hide()
			else
				GameTooltip:AddDoubleLine("Toggle Recount", HIDE,1,1,1,unpack(C["media"].txtcolor))
				TukuiInfoRightLButton.text:SetTextColor(unpack(C["media"].txtcolor))
				ctab:Show()
				Recount.MainWindow:Show()
			end
		end
	end)
	
	TukuiInfoRightLButton:SetScript("OnEnter", function(self)
		TukuiInfoRightLButton.hovered = true
		if InCombatLockdown() then return end
		GameTooltip:SetOwner(self, "ANCHOR_TOP", 0, T.Scale(6));
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("BOTTOM", self, "TOP", 0, T.mult)
		GameTooltip:ClearLines()
		
		if IsAddOnLoaded("Recount") and Recount.MainWindow:IsShown() then
			GameTooltip:AddDoubleLine("Toggle Recount", HIDE,1,1,1,unpack(C["media"].txtcolor))
		else
			GameTooltip:AddDoubleLine("Toggle Recount", SHOW,1,1,1,unpack(C["media"].txtcolor))
		end
		GameTooltip:Show()
	end)

	TukuiInfoRightLButton:SetScript("OnLeave", function(self)
		TukuiInfoRightLButton.hovered = false
		GameTooltip:Hide()
	end)
end