local E, L, DF = unpack(ElvUI); --Inport: Engine, Locales, ProfileDB, GlobalDB
local M = E:GetModule('Misc')

threatbar_db = threatbar_db or {
	["threatbar_enable"] = true,
	["threatbar_sound_disable"] = false,
	["threatbar_sound"] = "Fel Nova",
    ["threatbar_low_color"] = {
		["r"] = 0.2941176470588235,
		["g"] = 0.6862745098039216,
		["b"] = 0.2980392156862745,
	},
	["threatbar_medium_color"] = {
		["r"] = 0.9411764705882353,
		["g"] = 0.6039215686274509,
		["b"] = 0.06666666666666667,
	},
	["threatbar_high_color"] = {
		["r"] = 0.7803921568627451,
		["g"] = 0.2509803921568627,
		["b"] = 0.2509803921568627,
	},
}

E.Options.args.datatexts.args.elvui_threatbar = {
    order = 2000,
    type = "group",
    name = 'Threatbar',
    guiInline = true,
	get = function(info) return threatbar_db[ info[#info] ] end,
	set = function(info, value) threatbar_db[ info[#info] ] = value; end,
    args = {
        threatbar_enable = {
            order = 1,
            name = L["Enable"],
            type = 'toggle',
            desc = 'Activate threatbar on right chat datatext panel',
            get = function(info) return threatbar_db[ info[#info] ] end,
            set = function(info, value) threatbar_db[ info[#info] ] = value; M:InitializeThreatBar() end,               
        },
		threatbar_sound_disable = {
            order = 2,
            name = L["Disable Sound"],
			desc = L["Don't play the warning sound."],
            type = 'toggle',
            get = function(info) return threatbar_db[ info[#info] ] end,
            set = function(info, value) threatbar_db[ info[#info] ] = value end,               
        },
		threatbar_sound = {
			type = "select", dialogControl = 'LSM30_Sound',
			order = 3,
			name = L["Sound"],
			desc = L["Sound that will play when you have a warning icon displayed."],
			values = AceGUIWidgetLSMlists.sound,
			disabled = function() return threatbar_db.threatbar_sound_disable end,
			get = function(info) return threatbar_db[ info[#info] ] end,
			set = function(info, value) threatbar_db[ info[#info] ] = value end
		},
        threatbar_low_color = {
            order = 4,
            name = 'Low threat color',
            desc = 'Low threat color',
            type = 'color',
            hasAlpha = false,
            get = function(info)
				local t = threatbar_db[ info[#info] ]
				return t.r, t.g, t.b, t.a
			end,
			set = function(info, r, g, b)
				threatbar_db[ info[#info] ] = {}
				local t = threatbar_db[ info[#info] ]
				t.r, t.g, t.b = r, g, b
			end,                  
        },
        threatbar_medium_color = {
            order = 5,
            name = 'Medium threat color',
            desc = 'Medium threat color',
            type = 'color',
            hasAlpha = false,
            get = function(info)
				local t = threatbar_db[ info[#info] ]
				return t.r, t.g, t.b, t.a
			end,
			set = function(info, r, g, b)
				threatbar_db[ info[#info] ] = {}
				local t = threatbar_db[ info[#info] ]
				t.r, t.g, t.b = r, g, b
			end,                    
        },
		threatbar_high_color = {
            order = 6,
            name = 'High threat color',
            desc = 'High threat color',
            type = 'color',
            hasAlpha = false,
            get = function(info)
				local t = threatbar_db[ info[#info] ]
				return t.r, t.g, t.b, t.a
			end,
			set = function(info, r, g, b)
				threatbar_db[ info[#info] ] = {}
				local t = threatbar_db[ info[#info] ]
				t.r, t.g, t.b = r, g, b
			end,           
        },
    }
}