----------------------------------------------------------------------------
-- This Module loads new user settings if TukUI_ConfigUI is loaded
----------------------------------------------------------------------------
local T, C, L, DB = unpack(select(2, ...)) -- Import Functions/Constants, Config, Locales

--Convert default database
for group,options in pairs(DB) do
	if not C[group] then C[group] = {} end
	for option, value in pairs(options) do
		C[group][option] = value
	end
end

if IsAddOnLoaded("Tukui_Config") and OUIDB then
	local OUI = LibStub("AceAddon-3.0"):GetAddon("OUI")
	OUI:Load()

	--Load settings from OUI database
	for group, options in pairs(OUI.db.profile) do
		if C[group] then
			for option, value in pairs(options) do
				C[group][option] = value
			end
		end
	end
	
	--Raid Debuffs
	T.RaidDebuffs = OUI.db.profile.spellfilter.RaidDebuffs
	
	--Debuff Blacklist
	T.DebuffBlacklist = OUI.db.profile.spellfilter.DebuffBlacklist
	
	--Target PvP
	T.TargetPVPOnly = OUI.db.profile.spellfilter.TargetPVPOnly
	
	--Debuff Whitelist
	T.DebuffWhiteList = OUI.db.profile.spellfilter.DebuffWhiteList
	
	--Arena Buffs
	T.ArenaBuffWhiteList = OUI.db.profile.spellfilter.ArenaBuffWhiteList
	
	--Nameplate Filter
	T.PlateBlacklist = OUI.db.profile.spellfilter.PlateBlacklist
	
	--HealerBuffIDs
	T.HealerBuffIDs = OUI.db.profile.spellfilter.HealerBuffIDs
	
	--DPSBuffIDs
	T.DPSBuffIDs = OUI.db.profile.spellfilter.DPSBuffIDs
	
	--PetBuffIDs
	T.PetBuffs = OUI.db.profile.spellfilter.PetBuffs
end
