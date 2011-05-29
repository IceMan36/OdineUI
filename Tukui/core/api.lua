local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

local noop = T.dummy
local floor = math.floor
local class = T.myclass
local texture = C.media.blank
local backdropr, backdropg, backdropb, backdropa, borderr, borderg, borderb = 0, 0, 0, 1, 0, 0, 0

---------------------------------------------------
-- TEMPLATES
---------------------------------------------------

local function GetTemplate(t)
	backdropa = 1
	if t == "Transparent" then
		borderr, borderg, borderb = unpack(C["media"].bordercolor)
		backdropr, backdropg, backdropb, backdropa = unpack(C["media"].backdropfadecolor)	
	else
		borderr, borderg, borderb = unpack(C["media"].bordercolor)
		backdropr, backdropg, backdropb = unpack(C["media"].backdropcolor)
	end
end

---------------------------------------------------
-- END OF TEMPLATES
---------------------------------------------------

local function Size(frame, width, height)
	frame:SetSize(T.Scale(width), T.Scale(height or width))
end

local function Width(frame, width)
	frame:SetWidth(T.Scale(width))
end

local function Height(frame, height)
	frame:SetHeight(T.Scale(height))
end

local function Point(obj, arg1, arg2, arg3, arg4, arg5)
	-- anyone has a more elegant way for this?
	if type(arg1)=="number" then arg1 = T.Scale(arg1) end
	if type(arg2)=="number" then arg2 = T.Scale(arg2) end
	if type(arg3)=="number" then arg3 = T.Scale(arg3) end
	if type(arg4)=="number" then arg4 = T.Scale(arg4) end
	if type(arg5)=="number" then arg5 = T.Scale(arg5) end

	obj:SetPoint(arg1, arg2, arg3, arg4, arg5)
end

local function CreateShadow(f, t)
	if f.shadow then return end -- we seriously don't want to create shadow 2 times in a row on the same frame.
	
	borderr, borderg, borderb = 0, 0, 0
	backdropr, backdropg, backdropb = 0, 0, 0
	
	if t == "ClassColor" then
		local c = T.oUF_colors.class[class]
		borderr, borderg, borderb = c[1], c[2], c[3]
		backdropr, backdropg, backdropb = unpack(C["media"].backdropcolor)
	end
	
	local shadow = CreateFrame("Frame", nil, f)
	shadow:SetFrameLevel(1)
	shadow:SetFrameStrata(f:GetFrameStrata())
	shadow:Point("TOPLEFT", -3, 3)
	shadow:Point("BOTTOMLEFT", -3, -3)
	shadow:Point("TOPRIGHT", 3, 3)
	shadow:Point("BOTTOMRIGHT", 3, -3)
	shadow:SetBackdrop( { 
		edgeFile = C["media"].glowTex, edgeSize = T.Scale(3),
		insets = {left = T.Scale(5), right = T.Scale(5), top = T.Scale(5), bottom = T.Scale(5)},
	})
	shadow:SetBackdropColor(backdropr, backdropg, backdropb, 0)
	shadow:SetBackdropBorderColor(borderr, borderg, borderb, 0.9)
	f.shadow = shadow
end

local function SetTemplate(f, t, texture)
	if texture then myTex = C.media.oTex else myTex = C.media.blank end
	GetTemplate(t)
		
	f:SetBackdrop({
	  bgFile = myTex,
	  edgeFile = C["media"].blank,
	  tile = false, tileSize = 0, edgeSize = T.mult, 
	  insets = { left = -T.mult, right = -T.mult, top = -T.mult, bottom = -T.mult}
	})

	if texture and not f.tex then
		if C["general"].sharpborders == true and C["general"].classcolortheme ~= true then
			f:SetBackdropColor(0, 0, 0, backdropa)
		else
			f:SetBackdropColor(backdropr, backdropg, backdropb, backdropa)
		end
		
		local tex = f:CreateTexture(nil, "BORDER")
		tex:Point("TOPLEFT", f, "TOPLEFT", 2, -2)
		tex:Point("BOTTOMRIGHT", f, "BOTTOMRIGHT", -2, 2)
		tex:SetTexture(C["media"].glossTex)
		tex:SetVertexColor(backdropr, backdropg, backdropb)
		tex:SetDrawLayer("BORDER", -8)
		tex:SetAlpha(backdropa)
		f.tex = tex
	else
		f:SetBackdropColor(backdropr, backdropg, backdropb, backdropa)
		
		if not f.oborder and not f.iborder and C["general"].sharpborders == true then
			local border = CreateFrame("Frame", nil, f)
			border:Point("TOPLEFT", T.mult, -T.mult)
			border:Point("BOTTOMRIGHT", -T.mult, T.mult)
			border:SetBackdrop({
				edgeFile = C["media"].blank, 
				edgeSize = T.mult, 
				insets = { left = T.mult, right = T.mult, top = T.mult, bottom = T.mult }
			})
			border:SetBackdropBorderColor(0, 0, 0, 1)
			f.iborder = border
			
			if f.oborder then return end
			local border = CreateFrame("Frame", nil, f)
			border:Point("TOPLEFT", -T.mult, T.mult)
			border:Point("BOTTOMRIGHT", T.mult, -T.mult)
			border:SetFrameLevel(f:GetFrameLevel() + 1)
			border:SetBackdrop({
				edgeFile = C["media"].blank, 
				edgeSize = T.mult, 
				insets = { left = T.mult, right = T.mult, top = T.mult, bottom = T.mult }
			})
			border:SetBackdropBorderColor(0, 0, 0, 1)
			f.oborder = border				
		end
	end
	f:SetBackdropBorderColor(borderr, borderg, borderb)
end

local function CreatePanel(f, t, w, h, a1, p, a2, x, y)
	local sh = T.Scale(h)
	local sw = T.Scale(w)
	f:SetFrameLevel(1)
	f:SetHeight(sh)
	f:SetWidth(sw)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint(a1, p, a2, x, y)
	f:SetTemplate(t)
	f:CreateShadow("Default")
end

local function CreateBackdrop(f, t, tex)
	if not t then t = "Default" end
	
	local b = CreateFrame("Frame", nil, f)
	b:Point("TOPLEFT", -2, 2)
	b:Point("BOTTOMRIGHT", 2, -2)
	b:SetTemplate(t, tex)

	if f:GetFrameLevel() - 1 >= 0 then
		b:SetFrameLevel(f:GetFrameLevel() - 1)
	else
		b:SetFrameLevel(0)
	end
	
	f.backdrop = b
end

local function Kill(object)
	if object.UnregisterAllEvents then
		object:UnregisterAllEvents()
	end
	object.Show = noop
	object:Hide()
end

local function StripTextures(object, kill)
	for i=1, object:GetNumRegions() do
		local region = select(i, object:GetRegions())
		if region:GetObjectType() == "Texture" then
			if kill then
				region:Kill()
			else
				region:SetTexture(nil)
			end
		end
	end		
end

-- styleButton function authors are Chiril & Karudon.
local function StyleButton(b, c) 
    local name = b:GetName()
 
    local button          = _G[name]
    local icon            = _G[name.."Icon"]
    local count           = _G[name.."Count"]
    local border          = _G[name.."Border"]
    local hotkey          = _G[name.."HotKey"]
    local cooldown        = _G[name.."Cooldown"]
    local nametext        = _G[name.."Name"]
    local flash           = _G[name.."Flash"]
    local normaltexture   = _G[name.."NormalTexture"]
	local icontexture     = _G[name.."IconTexture"]
	
	local hover = b:CreateTexture("frame", nil, self) -- hover
	hover:SetTexture(1,1,1,0.3)
	hover:SetHeight(button:GetHeight())
	hover:SetWidth(button:GetWidth())
	hover:Point("TOPLEFT",button,2,-2)
	hover:Point("BOTTOMRIGHT",button,-2,2)
	button:SetHighlightTexture(hover)

	local pushed = b:CreateTexture("frame", nil, self) -- pushed
	pushed:SetTexture(0.9,0.8,0.1,0.3)
	pushed:SetHeight(button:GetHeight())
	pushed:SetWidth(button:GetWidth())
	pushed:Point("TOPLEFT",button,2,-2)
	pushed:Point("BOTTOMRIGHT",button,-2,2)
	button:SetPushedTexture(pushed)
	
	if cooldown then
		cooldown:ClearAllPoints()
		cooldown:Point("TOPLEFT",button,2,-2)
		cooldown:Point("BOTTOMRIGHT",button,-2,2)
	end
 
	if c then
		local checked = b:CreateTexture("frame", nil, self) -- checked
		checked:SetTexture(unpack(C["media"].txtcolor))
		checked:SetHeight(button:GetHeight())
		checked:SetWidth(button:GetWidth())
		checked:Point("TOPLEFT",button,2,-2)
		checked:Point("BOTTOMRIGHT",button,-2,2)
		checked:SetAlpha(0.3)
		button:SetCheckedTexture(checked)
	end
end

local function FontString(parent, name, fontName, fontHeight, fontStyle)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetFont(fontName, fontHeight, fontStyle)
	fs:SetJustifyH("LEFT")
	fs:SetShadowColor(0, 0, 0, 0.4)
	fs:SetShadowOffset(T.mult, -T.mult)
	
	if not name then
		parent.text = fs
	else
		parent[name] = fs
	end
	
	return fs
end

local function addapi(object)
	local mt = getmetatable(object).__index
	mt.Width = Width
	mt.Height = Height
	mt.Size = Size
	mt.Point = Point
	mt.SetTemplate = SetTemplate
	mt.CreatePanel = CreatePanel
	mt.CreateShadow = CreateShadow
	mt.Kill = Kill
	mt.StyleButton = StyleButton
	mt.FontString = FontString
	mt.StripTextures = StripTextures
	mt.CreateBackdrop = CreateBackdrop
end

local handled = {["Frame"] = true}
local object = CreateFrame("Frame")
addapi(object)
addapi(object:CreateTexture())
addapi(object:CreateFontString())

object = EnumerateFrames()
while object do
	if not handled[object:GetObjectType()] then
		addapi(object)
		handled[object:GetObjectType()] = true
	end

	object = EnumerateFrames(object)
end