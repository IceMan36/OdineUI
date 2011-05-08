------------------------------------------------------------------------
--	GM ticket position
------------------------------------------------------------------------
local T, C, L, DB = unpack(select(2, ...)) -- Import: T - functions, constants, variables; C - config; L - locales

TicketStatusFrame:ClearAllPoints()
TicketStatusFrame:SetPoint("TOPLEFT", 250, -5)

HelpOpenTicketButton:SetParent(Minimap)
HelpOpenTicketButton:ClearAllPoints()
HelpOpenTicketButton:SetPoint("TOPLEFT", Minimap, "TOPLEFT")

-- Shortcut function
SLASH_GM1 = "/gm"
SlashCmdList["GM"] = function() ToggleHelpFrame() end
