--This file contains the Install process and everything we do after PLAYER_ENTERING_WORLD event.

local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

-- this install Tukui with default settings.
function T.Install()
	local CURRENT_PAGE = 0
	local MAX_PAGE = 7
	
	local function InstallComplete()
		TukuiData[T.myrealm][T.myname].v2installed = true
		
	
		ReloadUI()
	end
	
	local function ResetUFPos()
		if C["unitframes"].positionbychar == true then
			TukuiUFpos = {}
		else
			TukuiData.ufpos = {}
		end	
		print(L.TukuiInstall_UFSet)
	end
	
	local function SetupChat()
		if (C.chat.enable == true) and (not IsAddOnLoaded("Prat") or not IsAddOnLoaded("Chatter")) then
			print(L.TukuiInstall_ChatSet)
			FCF_ResetChatWindows()
			FCF_SetLocked(ChatFrame1, 1)
			FCF_DockFrame(ChatFrame2)
			FCF_SetLocked(ChatFrame2, 1)

			FCF_OpenNewWindow(LOOT)
			FCF_UnDockFrame(ChatFrame3)
			FCF_SetLocked(ChatFrame3, 1)
			ChatFrame3:Show()			
					
			for i = 1, NUM_CHAT_WINDOWS do
				local frame = _G[format("ChatFrame%s", i)]
				local chatFrameId = frame:GetID()
				local chatName = FCF_GetChatWindowInfo(chatFrameId)
				
				_G["ChatFrame"..i]:SetSize(T.Scale(C["chat"].width - 5), T.Scale(C["chat"].height))
				
				-- this is the default width and height of Tukui chats.
				SetChatWindowSavedDimensions(chatFrameId, T.Scale(C["chat"].width + -4), T.Scale(C["chat"].height))
				
				-- move general bottom left
				if i == 1 then
					frame:ClearAllPoints()
					frame:SetPoint("BOTTOMLEFT", ChatLBackground, "BOTTOMLEFT", T.Scale(2), 0)
				elseif i == 3 then
					frame:ClearAllPoints()
					frame:SetPoint("BOTTOMLEFT", ChatRBackground, "BOTTOMLEFT", T.Scale(2), 0)			
				end
						
				-- save new default position and dimension
				FCF_SavePositionAndDimensions(frame)
				
				-- set default Tukui font size
				FCF_SetChatWindowFontSize(nil, frame, 12)
				
				-- rename windows general because moved to chat #3
				if i == 1 then
					FCF_SetWindowName(frame, GENERAL)
				elseif i == 2 then
					FCF_SetWindowName(frame, GUILD_EVENT_LOG)
				elseif i == 3 then 
					FCF_SetWindowName(frame, LOOT.." / "..TRADE) 
				end
			end
			
			ChatFrame_RemoveAllMessageGroups(ChatFrame1)
			ChatFrame_AddMessageGroup(ChatFrame1, "SAY")
			ChatFrame_AddMessageGroup(ChatFrame1, "EMOTE")
			ChatFrame_AddMessageGroup(ChatFrame1, "YELL")
			ChatFrame_AddMessageGroup(ChatFrame1, "GUILD")
			ChatFrame_AddMessageGroup(ChatFrame1, "OFFICER")
			ChatFrame_AddMessageGroup(ChatFrame1, "GUILD_ACHIEVEMENT")
			ChatFrame_AddMessageGroup(ChatFrame1, "WHISPER")
			ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_SAY")
			ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_EMOTE")
			ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_YELL")
			ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_BOSS_EMOTE")
			ChatFrame_AddMessageGroup(ChatFrame1, "PARTY")
			ChatFrame_AddMessageGroup(ChatFrame1, "PARTY_LEADER")
			ChatFrame_AddMessageGroup(ChatFrame1, "RAID")
			ChatFrame_AddMessageGroup(ChatFrame1, "RAID_LEADER")
			ChatFrame_AddMessageGroup(ChatFrame1, "RAID_WARNING")
			ChatFrame_AddMessageGroup(ChatFrame1, "BATTLEGROUND")
			ChatFrame_AddMessageGroup(ChatFrame1, "BATTLEGROUND_LEADER")
			ChatFrame_AddMessageGroup(ChatFrame1, "BG_HORDE")
			ChatFrame_AddMessageGroup(ChatFrame1, "BG_ALLIANCE")
			ChatFrame_AddMessageGroup(ChatFrame1, "BG_NEUTRAL")
			ChatFrame_AddMessageGroup(ChatFrame1, "SYSTEM")
			ChatFrame_AddMessageGroup(ChatFrame1, "ERRORS")
			ChatFrame_AddMessageGroup(ChatFrame1, "AFK")
			ChatFrame_AddMessageGroup(ChatFrame1, "DND")
			ChatFrame_AddMessageGroup(ChatFrame1, "IGNORED")
			ChatFrame_AddMessageGroup(ChatFrame1, "ACHIEVEMENT")
			ChatFrame_AddMessageGroup(ChatFrame1, "BN_WHISPER")
			ChatFrame_AddMessageGroup(ChatFrame1, "BN_CONVERSATION")
			ChatFrame_AddMessageGroup(ChatFrame1, "BN_INLINE_TOAST_ALERT")
			

			ChatFrame_RemoveAllMessageGroups(ChatFrame3)	
			ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_FACTION_CHANGE")
			ChatFrame_AddMessageGroup(ChatFrame3, "SKILL")
			ChatFrame_AddMessageGroup(ChatFrame3, "LOOT")
			ChatFrame_AddMessageGroup(ChatFrame3, "MONEY")
			ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_XP_GAIN")
			ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_HONOR_GAIN")
			ChatFrame_AddMessageGroup(ChatFrame3, "COMBAT_GUILD_XP_GAIN")
			ChatFrame_AddChannel(ChatFrame1, GENERAL)
			ChatFrame_RemoveChannel(ChatFrame1, L.chat_trade)
			ChatFrame_AddChannel(ChatFrame3, L.chat_trade)
		
			-- enable classcolor automatically on login and on each character without doing /configure each time.
			ToggleChatColorNamesByClassGroup(true, "SAY")
			ToggleChatColorNamesByClassGroup(true, "EMOTE")
			ToggleChatColorNamesByClassGroup(true, "YELL")
			ToggleChatColorNamesByClassGroup(true, "GUILD")
			ToggleChatColorNamesByClassGroup(true, "OFFICER")
			ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
			ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
			ToggleChatColorNamesByClassGroup(true, "WHISPER")
			ToggleChatColorNamesByClassGroup(true, "PARTY")
			ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
			ToggleChatColorNamesByClassGroup(true, "RAID")
			ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
			ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
			ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND")
			ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND_LEADER")	
			ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
			ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
			ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
			ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
			ToggleChatColorNamesByClassGroup(true, "CHANNEL5")
			ToggleChatColorNamesByClassGroup(true, "CHANNEL6")
			ToggleChatColorNamesByClassGroup(true, "CHANNEL7")
			ToggleChatColorNamesByClassGroup(true, "CHANNEL8")
			ToggleChatColorNamesByClassGroup(true, "CHANNEL9")
			ToggleChatColorNamesByClassGroup(true, "CHANNEL10")
			ToggleChatColorNamesByClassGroup(true, "CHANNEL11")
		end
	end
	
	local function SetupCVars()
		SetCVar("buffDurations", 1)
		SetCVar("mapQuestDifficulty", 1)
		SetCVar("scriptErrors", 1) -- enable while ptr 4.2 in testing
		SetCVar("ShowClassColorInNameplate", 1)
		SetCVar("screenshotQuality", 10)
		SetCVar("cameraDistanceMax", 50)
		SetCVar("cameraDistanceMaxFactor", 3.4)
		SetCVar("chatMouseScroll", 1)
		SetCVar("chatStyle", "classic")
		SetCVar("WholeChatWindowClickable", 0)
		SetCVar("ConversationMode", "inline")
		SetCVar("showTutorials", 0)
		SetCVar("showNewbieTips", 0)
		SetCVar("autoQuestWatch", 1)
		SetCVar("autoQuestProgress", 1)
		SetCVar("showLootSpam", 1)
		SetCVar("UberTooltips", 1)
		SetCVar("removeChatDelay", 1)
		SetCVar("gxTextureCacheSize", 512)
		print(L.TukuiInstall_CVarSet)
	end
	
	local function ResetAll()
		InstallNextButton:Disable()
		InstallPrevButton:Disable()
		InstallOption1Button:Hide()
		InstallOption1Button:SetScript("OnClick", nil)
		InstallOption1Button:SetText("")
		TukuiInstallFrame.SubTitle:SetText("")
		TukuiInstallFrame.Desc1:SetText("")
		TukuiInstallFrame.Desc2:SetText("")
		TukuiInstallFrame.Desc3:SetText("")
	end
	
	local function SetPage(PageNum)
		ResetAll()
		InstallStatus:SetValue(PageNum)
		
		local f = TukuiInstallFrame
		
		if PageNum == MAX_PAGE then
			InstallNextButton:Disable()
		else
			InstallNextButton:Enable()
		end
		
		if PageNum == 1 then
			InstallPrevButton:Disable()
		else
			InstallPrevButton:Enable()
		end
		
		--Page#1
		if PageNum == 1 then
			f.SubTitle:SetText(format(L.TukuiInstall_page1_subtitle, T.OUI, T.version))
			f.Desc1:SetText(L.TukuiInstall_page1_desc1)
			f.Desc2:SetText(L.TukuiInstall_page1_desc2)
			f.Desc3:SetText(L.TukuiInstall_ContinueMessage)
			InstallOption1Button:Show()
			InstallOption1Button:SetScript("OnClick", InstallComplete)
			InstallOption1Button:SetText(L.TukuiInstall_page1_button1)			
		elseif PageNum == 2 then
			f.SubTitle:SetText(L.TukuiInstall_page2_subtitle)
			f.Desc1:SetText(L.TukuiInstall_page2_desc1)
			f.Desc2:SetText(L.TukuiInstall_page2_desc2)
			f.Desc3:SetText(L.TukuiInstall_HighRecommended)
			InstallOption1Button:Show()
			InstallOption1Button:SetScript("OnClick", SetupCVars)
			InstallOption1Button:SetText(L.TukuiInstall_page2_button1)
		elseif PageNum == 3 then
			f.SubTitle:SetText(L.TukuiInstall_page3_subtitle)
			f.Desc1:SetText(L.TukuiInstall_page3_desc1)
			f.Desc2:SetText(L.TukuiInstall_page3_desc2)
			f.Desc3:SetText(L.TukuiInstall_MediumRecommended)
			InstallOption1Button:Show()
			InstallOption1Button:SetScript("OnClick", SetupChat)
			InstallOption1Button:SetText(L.TukuiInstall_page3_button1)
		elseif PageNum == 4 then
			local string_ = L.TukuiInstall_High
			if T.lowversion then
				string_ = L.TukuiInstall_Low
			end
			
			f.SubTitle:SetText(L.TukuiInstall_page4_subtitle)
			f.Desc1:SetText(format(L.TukuiInstall_page4_desc1, T.getscreenresolution, string_))
			f.Desc2:SetText(L.TukuiInstall_page4_desc2)			
			f.Desc3:SetText(L.TukuiInstall_ContinueMessage)
		elseif PageNum == 5 then
			f.SubTitle:SetText(L.TukuiInstall_page5_subtitle)
			f.Desc1:SetText(L.TukuiInstall_page5_desc1)
			f.Desc2:SetText(L.TukuiInstall_page5_desc2)
			f.Desc3:SetText(L.TukuiInstall_ContinueMessage)
		elseif PageNum == 6 then
			f.SubTitle:SetText(L.TukuiInstall_page6_subtitle)
			f.Desc1:SetText(L.TukuiInstall_page6_desc1)
			f.Desc2:SetText(L.TukuiInstall_page6_desc2)
			f.Desc3:SetText(L.TukuiInstall_page6_desc3)
			InstallOption1Button:Show()
			InstallOption1Button:SetScript("OnClick", ResetUFPos)
			InstallOption1Button:SetText(L.TukuiInstall_page6_button1)
		elseif PageNum == 7 then
			f.SubTitle:SetText(L.TukuiInstall_page7_subtitle)
			f.Desc1:SetText(L.TukuiInstall_page7_desc1)
			f.Desc2:SetText(L.TukuiInstall_page7_desc2)
			InstallOption1Button:Show()
			InstallOption1Button:SetScript("OnClick", InstallComplete)
			InstallOption1Button:SetText(L.TukuiInstall_page7_button1)				
		end
	end
	
	local function NextPage()	
		if CURRENT_PAGE ~= MAX_PAGE then
			CURRENT_PAGE = CURRENT_PAGE + 1
			SetPage(CURRENT_PAGE)
		end
	end

	local function PreviousPage()
		if CURRENT_PAGE ~= 1 then
			CURRENT_PAGE = CURRENT_PAGE - 1
			SetPage(CURRENT_PAGE)
		end
	end

	--Create Frame
	if not TukuiInstallFrame then
		local f = CreateFrame("Frame", "TukuiInstallFrame", UIParent)
		f:Size(550, 400)
		f:SetTemplate("Transparent")
		f:CreateShadow("Default")
		f:SetPoint("CENTER", 0, 100)
		
		f:FontString("Title", C["media"].font, 17, "THINOUTLINE")
		f.Title:Point("TOP", 0, -5)
		f.Title:SetText(L.TukuiInstall_Title)
		
		f.Next = CreateFrame("Button", "InstallNextButton", f, "UIPanelButtonTemplate2")
		f.Next:StripTextures()
		f.Next:SetTemplate("Default", true)
		f.Next:Size(110, 25)
		f.Next:Point("BOTTOMRIGHT", -5, 5)
		f.Next:SetText(CONTINUE)
		f.Next:Disable()
		f.Next:SetScript("OnClick", NextPage)
		
		f.Prev = CreateFrame("Button", "InstallPrevButton", f, "UIPanelButtonTemplate2")
		f.Prev:StripTextures()
		f.Prev:SetTemplate("Default", true)
		f.Prev:Size(110, 25)
		f.Prev:Point("BOTTOMLEFT", 5, 5)
		f.Prev:SetText(PREVIOUS)	
		f.Prev:Disable()
		f.Prev:SetScript("OnClick", PreviousPage)
		
		f.Status = CreateFrame("StatusBar", "InstallStatus", f)
		f.Status:SetFrameLevel(f.Status:GetFrameLevel() + 2)
		f.Status:CreateBackdrop("Default")
		f.Status:SetStatusBarTexture(C["media"].normTex)
		f.Status:SetStatusBarColor(unpack(C["media"].txtcolor))
		f.Status:SetMinMaxValues(0, MAX_PAGE)
		f.Status:Point("TOPLEFT", f.Prev, "TOPRIGHT", 6, -2)
		f.Status:Point("BOTTOMRIGHT", f.Next, "BOTTOMLEFT", -6, 2)
		f.Status:FontString(nil, C["media"].font, 12, "THINOUTLINE")
		f.Status.text:SetPoint("CENTER")
		f.Status.text:SetText(CURRENT_PAGE.." / "..MAX_PAGE)
		f.Status:SetScript("OnValueChanged", function(self)
			self.text:SetText(self:GetValue().." / "..MAX_PAGE)
		end)
		
		f.Option1 = CreateFrame("Button", "InstallOption1Button", f, "UIPanelButtonTemplate2")
		f.Option1:StripTextures()
		f.Option1:SetTemplate("Default", true)
		f.Option1:Size(160, 30)
		f.Option1:Point("BOTTOM", 0, 45)
		f.Option1:SetText("")
		f.Option1:Hide()
		
		f:FontString("SubTitle", C["media"].font, 15, "THINOUTLINE")
		f.SubTitle:Point("TOP", 0, -40)
		
		f:FontString("Desc1", C["media"].font, 12)
		f.Desc1:Point("TOPLEFT", 20, -75)	

		f:FontString("Desc2", C["media"].font, 12)
		f.Desc2:Point("TOPLEFT", 20, -125)		

		f:FontString("Desc3", C["media"].font, 12)
		f.Desc3:Point("TOPLEFT", 20, -175)	

		local close = CreateFrame("Button", "InstallCloseButton", f, "UIPanelCloseButton")
		close:SetPoint("TOPRIGHT", f, "TOPRIGHT")
		close:SetScript("OnClick", function()
			f:Hide()
		end)		
	end
	
	TukuiInstallFrame:Show()
	NextPage()
end

local function DisableTukui()
	DisableAddOn("Tukui")
	ReloadUI()
end

------------------------------------------------------------------------
--	Popups
------------------------------------------------------------------------

StaticPopupDialogs["TUKUIDISABLE_UI"] = {
	text = L.popup_disableui,
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = DisableTukui,
	timeout = 0,
	whileDead = 1,
}

StaticPopupDialogs["TUKUIDISABLE_RAID"] = {
	text = L.popup_2raidactive,
	button1 = "DPS - TANK",
	button2 = "HEAL",
	OnAccept = function() DisableAddOn("Tukui_Heal") EnableAddOn("Tukui_DPS") ReloadUI() end,
	OnCancel = function() EnableAddOn("Tukui_Heal") DisableAddOn("Tukui_DPS") ReloadUI() end,
	timeout = 0,
	whileDead = 1,
}

StaticPopupDialogs["BUY_BANK_SLOT"] = {
	text = CONFIRM_BUY_BANK_SLOT,
	button1 = YES,
	button2 = NO,
	OnAccept = function(self)
		PurchaseSlot()
	end,
	OnShow = function(self)
		MoneyFrame_Update(self.moneyFrame, GetBankSlotCost())
	end,
	hasMoneyFrame = 1,
	timeout = 0,
	hideOnEscape = 1,
}

StaticPopupDialogs["CANNOT_BUY_BANK_SLOT"] = {
	text = L.bags_noslots,
	button1 = ACCEPT,
	timeout = 0,
	whileDead = 1,	
}

StaticPopupDialogs["NO_BANK_BAGS"] = {
	text = L.bags_need_purchase,
	button1 = ACCEPT,
	timeout = 0,
	whileDead = 1,	
}

StaticPopupDialogs["RESET_UF"] = {
	text = L.popup_resetuf,
	button1 = YES,
	button2 = NO,
	OnAccept = function() T.ResetUF() ReloadUI() end,
	timeout = 0,
	whileDead = 1,
}

------------------------------------------------------------------------
--	On login function, look for some infos!
------------------------------------------------------------------------

local TukuiOnLogon = CreateFrame("Frame")
TukuiOnLogon:RegisterEvent("PLAYER_ENTERING_WORLD")
TukuiOnLogon:SetScript("OnEvent", function(self, event)
	self:UnregisterEvent("PLAYER_ENTERING_WORLD")

	if T.getscreenwidth < 1200 then
			SetCVar("useUiScale", 0)
			StaticPopup_Show("TUKUIDISABLE_UI")
	else
		SetCVar("useUiScale", 1)
		if C["general"].multisampleprotect == true then
			SetMultisampleFormat(1)
		end
		if C["general"].uiscale > 1 then C["general"].uiscale = 1 end
		if C["general"].uiscale < 0.64 then C["general"].uiscale = 0.64 end

		-- set our uiscale
		SetCVar("uiScale", C["general"].uiscale)
		
		-- we adjust UIParent to screen #1 if Eyefinity is found
		if T.eyefinity then
			local width = T.eyefinity
			local height = T.getscreenheight
			
			-- if autoscale is off, find a new width value of UIParent for screen #1.
			if not C.general.autoscale or height > 1200 then
				local h = UIParent:GetHeight()
				local ratio = T.getscreenheight / h
				local w = T.eyefinity / ratio
				
				width = w
				height = h			
			end
			
			UIParent:SetSize(width, height)
			UIParent:ClearAllPoints()
			UIParent:SetPoint("CENTER")		
		end
		
		if TukuiData == nil then TukuiData = {} end
		if TukuiData[T.myrealm] == nil then TukuiData[T.myrealm] = {} end
		if TukuiData[T.myrealm][T.myname] == nil then TukuiData[T.myrealm][T.myname] = {} end
	
		if TukuiData[T.myrealm][T.myname].v2installed ~= true then
			T.Install()
		end
	end
	
	if (IsAddOnLoaded("Tukui_DPS") and IsAddOnLoaded("Tukui_Heal")) then
		StaticPopup_Show("TUKUIDISABLE_RAID")
	end
	
	if C["unitframes"].arena == true then
		SetCVar("showArenaEnemyFrames", 0)
	end
	
	if C["nameplate"].enable == true and C["nameplate"].enhancethreat == true then
		SetCVar("threatWarning", 3)
	end

	T.ChatLIn = true
	T.ChatRIn = true
	
	print(format(L.core_welcome1, T.OUI))
	print(L.core_welcome2)
	
	local maxresolution
	for i=1, 30 do
		if select(i, GetScreenResolutions()) ~= nil then
			maxresolution = select(i, GetScreenResolutions())
		end
	end

	if select(GetCurrentResolution(), GetScreenResolutions()) ~= maxresolution then
		print(format(L.core_resowarning, select(GetCurrentResolution(), GetScreenResolutions()), maxresolution))
	end
end)

-- collect garbage
local eventcount = 0
local OUIInGame = CreateFrame("Frame")
OUIInGame:RegisterAllEvents()
OUIInGame:SetScript("OnEvent", function(self, event)
	eventcount = eventcount + 1
	if InCombatLockdown() then return end

	if eventcount > 6000 then
		collectgarbage("collect")
		eventcount = 0
	end
end)

------------------------------------------------------------------------
--	UI HELP
------------------------------------------------------------------------

-- Print Help Messages
local function UIHelp()
	print(" ")
	print(L.core_uihelp1)
	print(L.core_uihelp2)
	print(L.core_uihelp3)
	print(L.core_uihelp4)
	print(L.core_uihelp5)
	print(L.core_uihelp6)
	print(L.core_uihelp7)
	print(L.core_uihelp9)
	print(L.core_uihelp10)
	print(" ")
	print(L.core_uihelp100)
end

SLASH_UIHELP1 = "/UIHelp"
SlashCmdList["UIHELP"] = UIHelp

SLASH_CONFIGURE1 = "/resetui"
SlashCmdList.CONFIGURE = function() T.Install() end