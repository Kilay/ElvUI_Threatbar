local E, L, P, G = unpack(ElvUI); --Import: Engine, Locales, ProfileDB, GlobalDB
local M = E:GetModule('Misc')
local LSM = LibStub("LibSharedMedia-3.0")
local OUIThreat

-- event func
local function OnEvent(self, event, ...)
	local party = GetNumPartyMembers()
	local raid = GetNumRaidMembers()
	local pet = select(1, HasPetUI())
	
	if event == "PLAYER_ENTERING_WORLD" then
		self:Hide()
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	elseif event == "PLAYER_REGEN_ENABLED" then
		self:Hide()
	elseif event == "PLAYER_REGEN_DISABLED" then
		-- look if we have a pet, party or raid active
		-- having threat bar solo is totally useless
		if party > 0 or raid > 0 or pet == 1 then
			self:Show()
		else
			self:Hide()
		end
	else
		-- update when pet, party or raid change.
		if (InCombatLockdown()) and (party > 0 or raid > 0 or pet == 1) then
			self:Show()
		else
			self:Hide()
		end
	end
end

-- update status bar func
local function OnUpdate(self, event, unit)
	if UnitAffectingCombat(self.unit) then
		local _, _, threatpct, rawthreatpct, _ = UnitDetailedThreatSituation(self.unit, self.tar)
		local threatval = threatpct or 0
		
		self:SetValue(threatval)
		self.text:SetFormattedText("%s "..E["media"].hexvaluecolor.."%3.1f%%|r", L['Threat on current target:'], threatval)

		if E.role ~= "Tank" then
			if( threatval < 30 ) then
				self:SetStatusBarColor(threatbar_db.threatbar_low_color.r, threatbar_db.threatbar_low_color.g, threatbar_db.threatbar_low_color.b)
				M.SoundThrottled = nil;
			elseif( threatval >= 30 and threatval < 70 ) then
				self:SetStatusBarColor(threatbar_db.threatbar_medium_color.r, threatbar_db.threatbar_medium_color.g, threatbar_db.threatbar_medium_color.b)
				M.SoundThrottled = nil
			else
				self:SetStatusBarColor(threatbar_db.threatbar_high_color.r, threatbar_db.threatbar_high_color.g, threatbar_db.threatbar_high_color.b)
				if threatbar_db.threatbar_enable and not threatbar_db.threatbar_sound_disable then
					if not M.SoundThrottled then
						M.SoundThrottled = true
						PlaySoundFile(LSM:Fetch("sound", threatbar_db.threatbar_sound))
					end
				end
			end
		else
			if( threatval < 30 ) then
				self:SetStatusBarColor(threatbar_db.threatbar_high_color.r, threatbar_db.threatbar_high_color.g, threatbar_db.threatbar_high_color.b)
				if threatbar_db.threatbar_enable and not threatbar_db.threatbar_sound_disable then
					if not M.SoundThrottled then
						M.SoundThrottled = true;
						PlaySoundFile(LSM:Fetch("sound", threatbar_db.threatbar_sound))
					end
				end
			elseif( threatval >= 30 and threatval < 70 ) then
				self:SetStatusBarColor(threatbar_db.threatbar_medium_color.r, threatbar_db.threatbar_medium_color.g, threatbar_db.threatbar_medium_color.b)
				M.SoundThrottled = nil;
			else
				self:SetStatusBarColor(threatbar_db.threatbar_low_color.r, threatbar_db.threatbar_low_color.g, threatbar_db.threatbar_low_color.b)
				M.SoundThrottled = nil;
			end		
		end
				
		if threatval > 0 then
			self:SetAlpha(1)
		else
			self:SetAlpha(0)
		end		
	end
end

function M:InitializeThreatBar()
	if threatbar_db.threatbar_enable ~= true then
		if OUIThreat ~= nil then
			OUIThreat:Hide()
			OUIThreat = nil
			OUIThreat:SetScript("OnEvent", nil)
			OUIThreat:SetScript("OnUpdate", nil)
		end
		return
	else
		if OUIThreat ~= nil then
			if threatbar_db.threatbar_position == 'LEFT' then
				OUIThreat:SetParent(LeftChatDataPanel)
				OUIThreat:SetAllPoints(LeftChatDataPanel)
			elseif threatbar_db.threatbar_position == 'RIGHT' then
				OUIThreat:SetParent(RightChatDataPanel)
				OUIThreat:SetAllPoints(RightChatDataPanel)
			end
			OUIThreat:SetFrameStrata("TOOLTIP")
			OUIThreat:Show()
			OUIThreat:SetScript("OnEvent", OnEvent)
			OUIThreat:SetScript("OnUpdate", OnUpdate)
		else
			self.LoadThreatBar()
		end
	end
end

function M:LoadThreatBar()
	if threatbar_db.threatbar_position == 'LEFT' then
		OUIThreat = CreateFrame("StatusBar", "OUIThreatBar", LeftChatDataPanel)
	elseif threatbar_db.threatbar_position == 'RIGHT' then
		OUIThreat = CreateFrame("StatusBar", "OUIThreatBar", RightChatDataPanel)
	end
	
	OUIThreat:Point("TOPLEFT", 2, -2)
	OUIThreat:Point("BOTTOMRIGHT", -2, 2)

	OUIThreat:SetStatusBarTexture(E["media"].normTex)
	OUIThreat:GetStatusBarTexture():SetHorizTile(false)
	OUIThreat:SetTemplate('Default', true)
	OUIThreat:SetBackdropBorderColor(0, 0, 0, 0)
	OUIThreat:SetMinMaxValues(0, 100)
	OUIThreat:SetFrameStrata("TOOLTIP")

	OUIThreat.text = OUIThreat:CreateFontString(nil, "OVERLAY")
	OUIThreat.text:FontTemplate(nil, nil, "THINOUTLINE")
	OUIThreat.text:SetPoint("CENTER")
	OUIThreat.text:SetShadowOffset(E.mult, -E.mult)
	OUIThreat.text:SetShadowColor(0, 0, 0, 0.4)

	OUIThreat.bg = OUIThreat:CreateTexture(nil, 'BORDER')
	OUIThreat.bg:SetAllPoints(OUIThreatBar)
	
	-- event handling
	OUIThreat:RegisterEvent("PLAYER_ENTERING_WORLD")
	OUIThreat:RegisterEvent("PLAYER_REGEN_ENABLED")
	OUIThreat:RegisterEvent("PLAYER_REGEN_DISABLED")
	OUIThreat:SetScript("OnEvent", OnEvent)
	OUIThreat:SetScript("OnUpdate", OnUpdate)
	OUIThreat.unit = "player"
	OUIThreat.tar = OUIThreat.unit.."target"
	OUIThreat:SetAlpha(0)
end