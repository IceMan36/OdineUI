local T, C, L = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

function T.UIScale()
	if C["general"].autoscale == true then
		C["general"].uiscale = min(1, max(.64, 768/T.getscreenheight))
	end

	T.lowversion = false

	if T.getscreenwidth < 1600 then
			T.lowversion = true
	elseif T.getscreenwidth >= 3840 or (UIParent:GetWidth() + 1 > T.getscreenwidth) then
		local width = T.getscreenwidth
		local height = T.getscreenheight
	
		-- because some user enable bezel compensation, we need to find the real width of a single monitor.
		-- I don't know how it really work, but i'm assuming they add pixel to width to compensate the bezel. :P

		-- HQ resolution
		if width >= 9840 then width = 3280 end                   	                -- WQSXGA
		if width >= 7680 and width < 9840 then width = 2560 end                     -- WQXGA
		if width >= 5760 and width < 7680 then width = 1920 end 	                -- WUXGA & HDTV
		if width >= 5040 and width < 5760 then width = 1680 end 	                -- WSXGA+

		-- adding height condition here to be sure it work with bezel compensation because WSXGA+ and UXGA/HD+ got approx same width
		if width >= 4800 and width < 5760 and height == 900 then width = 1600 end   -- UXGA & HD+

		-- low resolution screen
		if width >= 4320 and width < 4800 then width = 1440 end 	                -- WSXGA
		if width >= 4080 and width < 4320 then width = 1360 end 	                -- WXGA
		if width >= 3840 and width < 4080 then width = 1224 end 	                -- SXGA & SXGA (UVGA) & WXGA & HDTV
		
		-- yep, now set Tukui to lower reso if screen #1 width < 1600
		if width < 1600 then
			T.lowversion = true
		end
		
		-- register a constant, we will need it later for launch.lua
		T.eyefinity = width
	end
	
	if C["general"].resolutionoverride == "Low" then
		T.lowversion = true
	elseif C["general"].resolutionoverride == "High" then
		T.lowversion = false
	end
	
	--Set a value for unitframe scaling
	if T.lowversion == true then
		T.raidscale = 0.9
	else
		T.raidscale = 1
	end
end
T.UIScale()

-- pixel perfect script of custom ui scale.
local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/C["general"].uiscale
local function scale(x)
    return mult*math.floor(x/mult+.5)
end

function T.Scale(x) return scale(x) end
T.mult = mult