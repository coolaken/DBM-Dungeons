local mod = DBM:NewMod(530, "DBM-Party-BC", 16, 249)
local L = mod:GetLocalizedStrings()

mod.statTypes = "normal,heroic,timewalker"

mod:SetRevision("@file-date-integer@")

mod:SetCreatureID(24723)
mod:SetEncounterID(1897)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 44320"
)

local specWarnChannel		= mod:NewSpecialWarningSwitch(-5081, "-Healer", nil, 3, 1, 2)

local timerChannelCD		= mod:NewCDTimer(47, -5081, nil, nil, nil, 1, 44320)

function mod:OnCombatStart(delay)
	timerChannelCD:Start(15-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 44320 then--Mana Rage, triggers right before CHAT_MSG_RAID_BOSS_EMOTE
		specWarnChannel:Show()
		specWarnChannel:Play("targetchange")
		timerChannelCD:Start()
	end
end
