local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

-- just for creating text
T.SetFontString = function(parent, fontName, fontHeight, fontStyle)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetFont(fontName, fontHeight, fontStyle)
	fs:SetJustifyH("LEFT")
	return fs
end

if C["datatext"].classcolor then
	local color = RAID_CLASS_COLORS[TukuiDB.myclass]
	T.cStart = ("|cff%.2x%.2x%.2x"):format(color.r * 255, color.g * 255, color.b * 255)
else
	local r, g, b = unpack(C["datatext"].color)
	T.cStart = ("|cff%.2x%.2x%.2x"):format(r * 255, g * 255, b * 255)
end
T.cEnd = "|r"


T.PP = function(p, obj)
	local TukuiInfoLeft = TukuiInfoLeft
	local TukuiInfoRight = TukuiInfoRight
	
	local bottom = TukuiBottomStats
	local leftsplit = TukuiLeftSplitBarData
	local rightsplit = TukuiRightSplitBarData
	
	if p == 1 then
		obj:SetParent(TukuiInfoLeft)
		obj:Height(TukuiInfoLeft:GetHeight())
		obj:Point("LEFT", TukuiInfoLeft, 20, 1)
	elseif p == 2 then
		obj:SetParent(TukuiInfoLeft)
		obj:Height(TukuiInfoLeft:GetHeight())
		obj:Point("CENTER", TukuiInfoLeft, 0, 1)
	elseif p == 3 then
		obj:SetParent(TukuiInfoLeft)
		obj:Height(TukuiInfoLeft:GetHeight())
		obj:Point("RIGHT", TukuiInfoLeft, -20, 1)
	elseif p == 4 then
		obj:SetParent(TukuiInfoRight)
		obj:Height(TukuiInfoRight:GetHeight())
		obj:Point("LEFT", TukuiInfoRight, 20, 1)
	elseif p == 5 then
		obj:SetParent(TukuiInfoRight)
		obj:Height(TukuiInfoRight:GetHeight())
		obj:Point("CENTER", TukuiInfoRight, 0, 1)
	elseif p == 6 then
		obj:SetParent(TukuiInfoRight)
		obj:Height(TukuiInfoRight:GetHeight())
		obj:Point("RIGHT", TukuiInfoRight, -20, 1)
	end
	
	if p == 7 then
		obj:SetHeight(bottom:GetHeight())
		obj:SetPoint("LEFT", bottom, 20, 0)
		obj:SetPoint('TOP', bottom)
		obj:SetPoint('BOTTOM', bottom)
	elseif p == 8 then
		obj:SetHeight(bottom:GetHeight())
		obj:SetPoint('TOP', bottom)
		obj:SetPoint('BOTTOM', bottom)
	elseif p == 9 then
		obj:SetHeight(bottom:GetHeight())
		obj:SetPoint("RIGHT", bottom, -20, 0)
		obj:SetPoint('TOP', bottom)
		obj:SetPoint('BOTTOM', bottom)
	end
	
	if p == 10 then
		obj:SetHeight(leftsplit:GetHeight() - 10)
		obj:SetWidth(leftsplit:GetWidth() - 15)
		obj:SetPoint('CENTER', leftsplit)
	elseif p == 11 then
		obj:SetHeight(rightsplit:GetHeight() - 10)
		obj:SetWidth(rightsplit:GetWidth() - 15)
		obj:SetPoint('CENTER', rightsplit)
	end
	
end

T.DataTextTooltipAnchor = function(self)
	local panel = self:GetParent()
	local anchor = "ANCHOR_TOP"
	local xoff = 0
	local yoff = T.Scale(4)
	
	if panel == TukuiInfoLeft then
		anchor = "ANCHOR_TOPLEFT"
		xoff = T.Scale(-17)
	elseif panel == TukuiInfoRight then
		anchor = "ANCHOR_TOPRIGHT"
		xoff = T.Scale(17)
	elseif panel == TukuiBottomStats then
		anchor = "ANCHOR_TOPLEFT"
		xoff = T.Scale(-17)
	end
	
	return anchor, panel, xoff, yoff
end

T.Round = function(number, decimals)
	if not decimals then decimals = 0 end
    return (("%%.%df"):format(decimals)):format(number)
end

T.RGBToHex = function(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return string.format("|cff%02x%02x%02x", r*255, g*255, b*255)
end

--Check Player's Role
local RoleUpdater = CreateFrame("Frame")
local function CheckRole(self, event, unit)
	local tree = GetPrimaryTalentTree()
	local resilience
	local resilperc = GetCombatRatingBonus(COMBAT_RATING_RESILIENCE_PLAYER_DAMAGE_TAKEN)
	if resilperc > GetDodgeChance() and resilperc > GetParryChance() then
		resilience = true
	else
		resilience = false
	end
	if ((T.myclass == "PALADIN" and tree == 2) or
	(T.myclass == "WARRIOR" and tree == 3) or
	(T.myclass == "DEATHKNIGHT" and tree == 1)) and
	resilience == false or
	(T.myclass == "DRUID" and tree == 2 and GetBonusBarOffset() == 3) then
		T.Role = "Tank"
	else
		local playerint = select(2, UnitStat("player", 4))
		local playeragi	= select(2, UnitStat("player", 2))
		local base, posBuff, negBuff = UnitAttackPower("player");
		local playerap = base + posBuff + negBuff;

		if (((playerap > playerint) or (playeragi > playerint)) and not (T.myclass == "SHAMAN" and tree ~= 1 and tree ~= 3) and not (UnitBuff("player", GetSpellInfo(24858)) or UnitBuff("player", GetSpellInfo(65139)))) or T.myclass == "ROGUE" or T.myclass == "HUNTER" or (T.myclass == "SHAMAN" and tree == 2) then
			T.Role = "Melee"
		else
			T.Role = "Caster"
		end
	end
end
RoleUpdater:RegisterEvent("PLAYER_ENTERING_WORLD")
RoleUpdater:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
RoleUpdater:RegisterEvent("PLAYER_TALENT_UPDATE")
RoleUpdater:RegisterEvent("CHARACTER_POINTS_CHANGED")
RoleUpdater:RegisterEvent("UNIT_INVENTORY_CHANGED")
RoleUpdater:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
RoleUpdater:SetScript("OnEvent", CheckRole)
CheckRole()

--Return short value of a number
function T.ShortValue(v)
	if v >= 1e6 then
		return ("%.1fm"):format(v / 1e6):gsub("%.?0+([km])$", "%1")
	elseif v >= 1e3 or v <= -1e3 then
		return ("%.1fk"):format(v / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return v
	end
end

--Return short negative value of a number, example -1000 returned as string -1k
function T.ShortValueNegative(v)
	if v <= 999 then return v end
	if v >= 1000000 then
		local value = string.format("%.1fm", v/1000000)
		return value
	elseif v >= 1000 then
		local value = string.format("%.1fk", v/1000)
		return value
	end
end

--Truncate a number off to n places
function T.Truncate(v, decimals)
	if not decimals then decimals = 0 end
    return v - (v % (0.1 ^ decimals))
end

--Add time before calling a function
--Usage E.Delay(seconds, functionToCall, ...)
local waitTable = {}
local waitFrame
function T.Delay(delay, func, ...)
	if(type(delay)~="number" or type(func)~="function") then
		return false
	end
	if(waitFrame == nil) then
		waitFrame = CreateFrame("Frame","WaitFrame", UIParent)
		waitFrame:SetScript("onUpdate",function (self,elapse)
			local count = #waitTable
			local i = 1
			while(i<=count) do
				local waitRecord = tremove(waitTable,i)
				local d = tremove(waitRecord,1)
				local f = tremove(waitRecord,1)
				local p = tremove(waitRecord,1)
				if(d>elapse) then
				  tinsert(waitTable,i,{d-elapse,f,p})
				  i = i + 1
				else
				  count = count - 1
				  f(unpack(p))
				end
			end
		end)
	end
	tinsert(waitTable,{delay,func,{...}})
	return true
end

--Check if our embed right addon is shown
function T.CheckAddOnShown()
	if T.ChatRightShown == true and T.RightChat and T.RightChat == true then
		return true
	elseif C["addonskins"].embed == "Omen" and IsAddOnLoaded("Omen") and OmenAnchor then
		if OmenAnchor:IsShown() then
			return true
		else
			return false
		end
	elseif C["addonskins"].embed == "Recount" and IsAddOnLoaded("Recount") and Recount_MainWindow then
		if Recount_MainWindow:IsShown() then
			return true
		else
			return false
		end
	elseif  C["addonskins"].embed ==  "Skada" and IsAddOnLoaded("Skada") and Skada:GetWindows()[1] then
		if Skada:GetWindows()[1].bargroup:IsShown() then
			return true
		else
			return false
		end
	else
		return false
	end
end

function T.IsPTR()
	local _, version = GetBuildInfo()
	if tonumber(version) > 14007 then
		return true
	else
		return false
	end
end

--Return rounded number
function T.Round(v, decimals)
	if not decimals then decimals = 0 end
    return (("%%.%df"):format(decimals)):format(v)
end

--RGB to Hex
function T.RGBToHex(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return string.format("|cff%02x%02x%02x", r*255, g*255, b*255)
end

--Hex to RGB
function T.HexToRGB(hex)
	local rhex, ghex, bhex = string.sub(hex, 1, 2), string.sub(hex, 3, 4), string.sub(hex, 5, 6)
	return tonumber(rhex, 16), tonumber(ghex, 16), tonumber(bhex, 16)
end
