local ADDON_NAME, ns = ...
local oUF = oUFTukui or oUF
assert(oUF, "Tukui was unable to locate oUF install.")

ns._Objects = {}
ns._Headers = {}

local T, C, L = unpack(Tukui) -- Import: T - functions, constants, variables; C - config; L - locales
if not C["unitframes"].enable == true or C["unitframes"].gridonly == true then return end

local font, fonts, fontf = C["media"].uffont, 14, "OUTLINE"

local normTex = C["media"].normTex

local function Shared(self, unit)
	self.colors = T.oUF_colors
	self:RegisterForClicks("AnyUp")
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	self.menu = T.SpawnMenu
	
	-- health
	local health = CreateFrame('StatusBar', nil, self)
	if unit:find("partypet") then
		health:Height(17)
	else
		health:Height(30)
	end
	health:SetPoint("TOPLEFT", T.mult, -T.mult)
	health:SetPoint("TOPRIGHT", -T.mult, T.mult)
	health:SetStatusBarTexture(normTex)
	self.Health = health
	
	if C["unitframes"].healthvertical then
		health:SetOrientation('VERTICAL')
	end
		
	local healthBg = health:CreateTexture(nil, "BORDER")
	healthBg:SetAllPoints()
	healthBg:SetTexture(unpack(C["unitframes"].healthBgColor))
	self.Health.bg = healthBg
		
	local healthB = CreateFrame("Frame", nil, health)
	healthB:SetFrameLevel(health:GetFrameLevel() - 1)
	healthB:Point("TOPLEFT", -2, 2)
	healthB:Point("BOTTOMRIGHT", 2, -2)
	healthB:SetTemplate("Default", true)
	healthB:CreateShadow("Default")
	self.Health.border = healthB

	-- power
	local power = CreateFrame('StatusBar', nil, self)
	if unit:find("partypet") then
		power:Height(0)
	else
		power:Height(4)
	end
	power:SetFrameLevel(self.Health:GetFrameLevel() + 2)
	power:SetPoint("TOPLEFT", healthB, "BOTTOMLEFT", T.Scale(2), -T.Scale(4))
	power:SetPoint("TOPRIGHT", healthB, "BOTTOMRIGHT", T.Scale(-2), -T.Scale(4))
	power:SetStatusBarTexture(normTex)
	power:GetStatusBarTexture():SetHorizTile(false)
	self.Power = power
		
	local powerBg = power:CreateTexture(nil, "BORDER")
	powerBg:SetAllPoints()
	powerBg:SetTexture(unpack(C["unitframes"].healthBgColor))
	powerBg.multiplier = 0.3
	self.Power.bg = powerBg
	
	local powerB = CreateFrame("Frame", nil, power)
	powerB:SetFrameLevel(power:GetFrameLevel() - 1)
	powerB:Point("TOPLEFT", -2, 2)
	powerB:Point("BOTTOMRIGHT", 2, -2)
	powerB:SetTemplate("Default", true)
	powerB:CreateShadow("Default")
	self.Power.border = powerB	
		
	health.frequentUpdates = true
	power.frequentUpdates = true
	
	if C["unitframes"].showsmooth == true then
		health.Smooth = true
		power.Smooth = true
	end
	
	if C["general"].classcolortheme ~= false then
		health.colorTapping = true
		health.colorDisconnected = true
		health.colorReaction = true
		health.colorClass = true
		healthBg.multiplier = 0.3
			
		power.colorPower = true
	else
		health.colorTapping = false
		health.colorDisconnected = false
		health.colorClass = false
		health.colorReaction = false
		health:SetStatusBarColor(unpack(C["unitframes"].healthColor))
		health.bg:SetVertexColor(unpack(C["unitframes"].healthBgColor))
		health.bg:SetTexture(1, 1, 1)
			
		power.multiplier = 0.5
		power.colorTapping = true
		power.colorDisconnected = true
		power.colorClass = true
		power.colorReaction = true
	end

	if C["unitframes"].healthdeficit then
		health.PostUpdate = T.PostUpdateHealthRaid

		health.value = health:CreateFontString(nil, "OVERLAY")
		health.value:SetPoint("CENTER", health, "CENTER", 0, -6)
		health.value:SetFont(font, fonts, fontf)
		self.Health.value = health.value
	end
	
	local name = health:CreateFontString(nil, "OVERLAY")
	if not C["unitframes"].healthdeficit or unit:find("partypet") then
		name:SetPoint("CENTER", health, "CENTER", 0, 1)
	else
		name:SetPoint("CENTER", health, "CENTER", 0, 6)
	end
	name:SetFont(font, fonts, fontf)
	if C["general"].classcolortheme ~= true then
		self:Tag(name, "[Tukui:getnamecolor][Tukui:name_short][Tukui:dead][Tukui:afk]")
	else
		self:Tag(name, "[Tukui:name_short][Tukui:dead][Tukui:afk]")
	end
	self.Name = name
	
    local LFDRole = health:CreateTexture(nil, "OVERLAY")
    LFDRole:Height(6)
    LFDRole:Width(6)
	LFDRole:Point("TOPRIGHT", -2, -2)
	LFDRole:SetTexture("Interface\\AddOns\\Tukui\\medias\\textures\\lfdicons.blp")
	self.LFDRole = LFDRole
	
	if C["unitframes"].showsymbols == true then
		local RaidIcon = health:CreateTexture(nil, 'OVERLAY')
		RaidIcon:Height(18)
		RaidIcon:Width(18)
		RaidIcon:SetPoint('CENTER', self, 'TOP')
		RaidIcon:SetTexture("Interface\\AddOns\\Tukui\\medias\\textures\\raidicons.blp") -- thx hankthetank for texture
		self.RaidIcon = RaidIcon
	end
	
	local ReadyCheck = self.Power:CreateTexture(nil, "OVERLAY")
	ReadyCheck:Height(12)
	ReadyCheck:Width(12)
	ReadyCheck:SetPoint('CENTER')
	self.ReadyCheck = ReadyCheck
	
	-- Debuff Highlight
	if C["unitframes"].debuffhighlight == true then
		local dbh = self.Health:CreateTexture(nil, "OVERLAY", healthBg)
		dbh:SetAllPoints(self)
		dbh:SetTexture(C["media"].blank)
		dbh:SetBlendMode("ADD")
		dbh:SetVertexColor(0,0,0,0)
		self.DebuffHighlight = dbh
		self.DebuffHighlightFilter = true
		self.DebuffHighlightAlpha = 0.35
	end

	if C["unitframes"].showrange == true then
		local range = {insideAlpha = 1, outsideAlpha = C["unitframes"].raidalphaoor}
		self.Range = range
	end
	
	if C["unitframes"].aggro == true then
		table.insert(self.__elements, T.UpdateThreat)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', T.UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', T.UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', T.UpdateThreat)
    end

	if C["unitframes"].healcomm then
		local mhpb = CreateFrame('StatusBar', nil, self.Health)
		mhpb:SetStatusBarTexture(normTex)
		mhpb:SetStatusBarColor(0, 1, 0.5, 0.25)

		local ohpb = CreateFrame('StatusBar', nil, self.Health)
		ohpb:SetStatusBarTexture(normTex)
		ohpb:SetStatusBarColor(0, 1, 0, 0.25)

		if C["unitframes"].healthvertical == true then
			mhpb:Point('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'TOPLEFT', 0, 0)
			mhpb:Point('BOTTOMRIGHT', self.Health:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)

			ohpb:Point('BOTTOMLEFT', mhpb:GetStatusBarTexture(), 'TOPLEFT', 0, 0)
			ohpb:Point('BOTTOMRIGHT', mhpb:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
			
			mhpb:Height(health:GetHeight())
			ohpb:Height(health:GetHeight())

			ohpb:SetOrientation('VERTICAL')
			mhpb:SetOrientation('VERTICAL')
		
		else
			mhpb:Point('TOPLEFT', self.Health:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
			mhpb:Point('BOTTOMLEFT', self.Health:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)

			ohpb:Point('TOPLEFT', mhpb:GetStatusBarTexture(), 'TOPRIGHT', 0, 0)
			ohpb:Point('BOTTOMLEFT', mhpb:GetStatusBarTexture(), 'BOTTOMRIGHT', 0, 0)
			
			mhpb:Width(150)
			ohpb:Width(150)

			ohpb:SetOrientation('HORIZONTAL')
			mhpb:SetOrientation('HORIZONTAL')
		end

		
		self.HealPrediction = {
			myBar = mhpb,
			otherBar = ohpb,
			maxOverflow = 1,
		}
	end

	if C["unitframes"].raidunitdebuffwatch == true then
		-- AuraWatch (corner icon)
		T.createAuraWatch(self,unit)
		
		-- Raid Debuffs (big middle icon)
		local RaidDebuffs = CreateFrame('Frame', nil, self)
		RaidDebuffs:Height(22)
		RaidDebuffs:Width(22)
		RaidDebuffs:Point('CENTER', health, 1,0)
		RaidDebuffs:SetFrameStrata("MEDIUM")
		RaidDebuffs:SetFrameLevel(50)
		
		RaidDebuffs:SetTemplate("Default")
		
		RaidDebuffs.icon = RaidDebuffs:CreateTexture(nil, 'OVERLAY')
		RaidDebuffs.icon:SetTexCoord(.09, .91, .09, .91)
		RaidDebuffs.icon:Point("TOPLEFT", 2, -2)
		RaidDebuffs.icon:Point("BOTTOMRIGHT", -2, 2)
		
		RaidDebuffs.count = RaidDebuffs:CreateFontString(nil, 'OVERLAY')
		RaidDebuffs.count:SetFont(font, fonts, fontf)
		RaidDebuffs.count:SetPoint('BOTTOMRIGHT', RaidDebuffs, 'BOTTOMRIGHT', 0, 2)
		RaidDebuffs.count:SetTextColor(1, .9, 0)
		
		self.RaidDebuffs = RaidDebuffs
    end

	return self
end

oUF:RegisterStyle('OUIHealParty', Shared)
oUF:Factory(function(self)
	oUF:SetActiveStyle("OUIHealParty")

	local raid = self:SpawnHeader("oUF_OUIHealParty", nil, "party", 
	'oUF-initialConfigFunction', [[
		local header = self:GetParent()
		self:SetWidth(header:GetAttribute('initial-width'))
		self:SetHeight(header:GetAttribute('initial-height'))
	]],
	'initial-width', T.Scale(70),
	'initial-height', T.Scale(41),	
	"showParty", true, 
	"showPlayer", C["unitframes"].showplayerinparty, 
	"groupFilter", "1,2,3,4,5,6,7,8", 
	"groupingOrder", "1,2,3,4,5,6,7,8", 
	"groupBy", "GROUP", 
	"xOffset", T.Scale(7),
	"point", "LEFT"
	)
	raid:Point("TOP", UIParent, "BOTTOM", 0, 205)
	
	local pets = {}
	for i = 1, 5 do 
		pets[i] = oUF:Spawn('partypet'..i, 'oUF_TukuiPartyPet'..i) 
		pets[i]:SetSize(raid:GetAttribute('initial-width'), 21)
		if i == 1 then
			if C["unitframes"].showplayerinparty == true then
				pets[i]:SetPoint('BOTTOMLEFT', raid, 'TOPLEFT', (pets[i]:GetWidth() + 7), 3)
			else
				pets[i]:SetPoint('BOTTOMLEFT', raid, 'TOPLEFT', 0, 3)
			end
		else
			pets[i]:SetPoint('TOPLEFT', pets[i-1], 'TOPRIGHT', 7, 0)
		end
	end

	local PetsFuckOffSeriously = CreateFrame("Frame")
	PetsFuckOffSeriously:RegisterEvent("PLAYER_ENTERING_WORLD")
	PetsFuckOffSeriously:RegisterEvent("RAID_ROSTER_UPDATE")
	PetsFuckOffSeriously:RegisterEvent("PARTY_LEADER_CHANGED")
	PetsFuckOffSeriously:RegisterEvent("PARTY_MEMBERS_CHANGED")
	PetsFuckOffSeriously:SetScript("OnEvent", function(self)
		if InCombatLockdown() then
			self:RegisterEvent("PLAYER_REGEN_ENABLED")
		else
			self:UnregisterEvent("PLAYER_REGEN_ENABLED")
			local numraid = GetNumRaidMembers()
			if numraid > 1  then
				for i, v in ipairs(pets) do v:Disable() end
			else
				for i, v in ipairs(pets) do v:Enable() end
			end
		end
	end)
end)