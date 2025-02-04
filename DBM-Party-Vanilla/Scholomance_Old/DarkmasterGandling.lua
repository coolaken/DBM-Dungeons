local mod	= DBM:NewMod("DarkmasterGandling", "DBM-Party-Vanilla", 16)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("@file-date-integer@")
mod:SetCreatureID(1853)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 17950"
)

local warningShadowPortal		= mod:NewSpellAnnounce(17950, 2) -- Target seems unreliable

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 17950 then
		warningShadowPortal:Show()
	end
end
