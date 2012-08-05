local E, L, P, G = unpack(ElvUI); --Import: Engine, Locales, ProfileDB, GlobalDB
local M = E:GetModule('Misc')


M.InitializeOld = M.Initialize
function M:Initialize()
	M.InitializeOld(self)
	self:InitializeThreatBar()
end