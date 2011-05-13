local ADDON_NAME, ns = ...
local oUF = oUFTukui or oUF
assert(oUF, "Tukui was unable to locate oUF install.")

ns._Objects = {}
ns._Headers = {}

local T, C, L = unpack(Tukui) -- Import: T - functions, constants, variables; C - config; L - locales
if not C["unitframes"].enable == true then return end

local font1 = C["media"].pixel_font
local font2 = C["media"].font

local function Shared(self, unit)
	self.colors = T.oUF_colors
	self:RegisterForClicks("AnyUp")
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	self.menu = T.SpawnMenu
	
	local t = CreateFrame("Frame", nil, self)
	t:CreatePanel("Default", 120, 20, "CENTER", self)
	t:SetFrameLevel(0)
	-- t:CreateBorder(true, true)
	self.t = t		

	local health = CreateFrame('StatusBar', nil, self)
	health:SetFrameLevel(t:GetFrameLevel())
	health:SetFrameStrata(t:GetFrameStrata())
	health:Point("TOPLEFT", t, 2, -2)
	health:Point("BOTTOMRIGHT", t, -2, 2)
	--health:SetStatusBarTexture(C["media"].normTex)
	health:SetStatusBarTexture(C["media"].hTex)
	self.Health = health
	
	local healthBG = health:CreateTexture(nil, 'BORDER')
	healthBG:SetAllPoints()
	self.Health.bg = healthBG
	
	health.PostUpdate = T.PostUpdatePetColor
	health.frequentUpdates = true
	
	if C["unitframes"].showsmooth == true then
		health.Smooth = true
	end

	if C["general"].template ~= "ClassColor" then
		health.colorDisconnected = false
		health.colorClass = false
		health:SetStatusBarColor(unpack(C["unitframes"].healthColor))
		healthBG:SetTexture(1, 1, 1)
		healthBG:SetVertexColor(unpack(C["unitframes"].healthBgColor))
	else
		healthBG:SetTexture(.1, .1, .1)
		health.colorDisconnected = true	
		health.colorClass = true
		health.colorReaction = true		
	end

	if not C["unitframes"].hidepower then
		local tt = CreateFrame("Frame", nil, self)
		tt:CreatePanel("Default", 60, 7, "LEFT", t, "BOTTOMLEFT", 5, 0)
		tt:SetFrameLevel(t:GetFrameLevel() + 2)
		tt.shadow:SetFrameLevel(0)
		self.tt = tt
		-- tt:CreateBorder(true, true)

		local power = CreateFrame("StatusBar", nil, self)
		power:SetFrameLevel(tt:GetFrameLevel() + 1)
		power:SetFrameStrata(tt:GetFrameStrata())
		power:Height(3)
		power:Point("TOPLEFT", tt, "TOPLEFT", 2, -2)
		power:Point("BOTTOMRIGHT", tt, "BOTTOMRIGHT", -2, 2)
		power:SetStatusBarTexture(normTex)
		self.Power = power
		
		local powerBG = power:CreateTexture(nil, "BORDER")
		powerBG:SetAllPoints()
		powerBG:SetTexture(C["media"].normTex)
		powerBG.multiplier = 0.3
		self.Power.bg = powerBG	
	
		power.frequentUpdates = true
		power.colorDisconnected = true

		if C["unitframes"].showsmooth == true then
			power.Smooth = true
		end

		if C["general"].template ~= "ClassColor" then
			power.colorClass = true
		else
			power.colorPower = true		
		end
	end
	
	local name = health:CreateFontString(nil, 'OVERLAY')
	name:SetFont(C["media"].uffont, 14, "OUTLINE")
	name:Point("LEFT", t, "RIGHT", 4, 1)
	self:Tag(name, '[Tukui:getnamecolor][Tukui:namemedium][Tukui:dead][Tukui:afk]')
	self.Name = name
	
	if C["unitframes"].showsymbols == true then
		RaidIcon = health:CreateTexture(nil, 'OVERLAY')
		RaidIcon:Height(16)
		RaidIcon:Width(16)
		RaidIcon:SetPoint("CENTER", t, "TOP")
		RaidIcon:SetTexture("Interface\\AddOns\\Tukui\\medias\\textures\\raidicons.blp") -- thx hankthetank for texture
		self.RaidIcon = RaidIcon
	end
	
	if C["unitframes"].aggro == true then
		table.insert(self.__elements, T.UpdateThreat)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', T.UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', T.UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', T.UpdateThreat)
    end
	
	local LFDRole = health:CreateTexture(nil, "OVERLAY")
    LFDRole:Height(6)
    LFDRole:Width(6)
	LFDRole:Point("TOPLEFT", 2, -2)
	LFDRole:SetTexture("Interface\\AddOns\\Tukui\\medias\\textures\\lfdicons.blp")
	self.LFDRole = LFDRole
	
	local ReadyCheck = health:CreateTexture(nil, "OVERLAY")
	ReadyCheck:Height(12)
	ReadyCheck:Width(12)
	ReadyCheck:SetPoint('CENTER')
	self.ReadyCheck = ReadyCheck
	
	--local picon = self.Health:CreateTexture(nil, 'OVERLAY')
	--picon:SetPoint('CENTER', self.Health)
	--picon:SetSize(16, 16)
	--picon:SetTexture[[Interface\AddOns\Tukui\media\textures\picon]]
	--picon.Override = T.Phasing
	--self.PhaseIcon = picon
	
	self.DebuffHighlightAlpha = 1
	self.DebuffHighlightBackdrop = true
	self.DebuffHighlightFilter = true
	
	if C["unitframes"].showrange == true then
		local range = {insideAlpha = 1, outsideAlpha = C["unitframes"].raidalphaoor}
		self.Range = range
	end

	return self
end

oUF:RegisterStyle("OUIDpsPR10", Shared)
oUF:Factory(function(self)
	oUF:SetActiveStyle("OUIDpsPR10")

	local raid = self:SpawnHeader("oUF_OUIDpsPR10", nil, "custom [@raid16,exists] hide;show", 
		'oUF-initialConfigFunction', [[
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute('initial-width'))
			self:SetHeight(header:GetAttribute('initial-height'))
		]],
		'initial-width', T.Scale(120),
		'initial-height', T.Scale(22),	
		"showParty", true, 
		"showRaid", true, 
		"showPlayer", C["unitframes"].showplayerinparty, 
		"groupFilter", "1,2,3,4,5,6,7,8", 
		"groupingOrder", "1,2,3,4,5,6,7,8",
		"groupBy", "GROUP",
		"yOffset", T.Scale(-5), 
		"showSolo", false
	)
	raid:SetPoint('TOPLEFT', UIParent, 8, -320)
end)