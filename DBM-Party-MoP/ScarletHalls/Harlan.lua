local mod	= DBM:NewMod(654, "DBM-Party-MoP", 8, 311)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("@file-date-integer@")
mod:SetCreatureID(58632)
mod:SetEncounterID(1421)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 111216",
	"SPELL_CAST_SUCCESS 111217",
	"SPELL_AURA_REMOVED 111216",
	"RAID_BOSS_EMOTE"
)

--All data confirmed and accurate for normal mode scarlet halls. heroic data should be quite similar but with diff spellids, will wait for logs to assume anything there.
local warnDragonsReach			= mod:NewSpellAnnounce(111217, 2)
local warnCallReinforcements	= mod:NewSpellAnnounce(-5378, 3)--triggers only found in emote

local specWarnBladesofLight		= mod:NewSpecialWarningSpell(111216, nil, nil, nil, 4, 2)

local timerDragonsReachCD		= mod:NewCDTimer(7, 111217, nil, nil, nil, 3)--12 on normal, 7 on heroic, OR, 7 in both and it was buffed on normal since i've run it. For time being i'll make it 7 but change it from next to CD
local timerCallReinforcementsCD	= mod:NewCDTimer(20, -5378, nil, nil, nil, 1)--adjusted in build 15799?
local timerBladesofLightCD		= mod:NewNextTimer(30, 111216, nil, nil, nil, 2)

--CallReinforcementsCD DATA
--"<1789.8> RAID_BOSS_EMOTE#|TInterface\\Icons\\ability_warrior_battleshout.blp:20|tArmsmaster Harlan calls on two of his allies to join the fight!#0#false", -- [19]
--"<1810.3> RAID_BOSS_EMOTE#|TInterface\\Icons\\inv_weapon_halberd_05.blp:20|tArmsmaster Harlan casts |cFFFF0000|Hspell:111216|h[Blades of Light]|h|r!#2#false", -- [20]
--"<1819.8> RAID_BOSS_EMOTE#|TInterface\\Icons\\ability_warrior_battleshout.blp:20|tArmsmaster Harlan calls on two of his allies to join the fight!#0#false", -- [21]
--"<1844.1> RAID_BOSS_EMOTE#|TInterface\\Icons\\ability_warrior_battleshout.blp:20|tArmsmaster Harlan calls on two of his allies to join the fight!#0#false", -- [22]

function mod:OnCombatStart(delay)
	timerDragonsReachCD:Start(-delay)
	timerCallReinforcementsCD:Start(-delay)
	timerBladesofLightCD:Start(40-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 111217 then
		warnDragonsReach:Show()
		timerDragonsReachCD:Start()
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 111216 then
		specWarnBladesofLight:Show()
		specWarnBladesofLight:Play("justrun")
		timerDragonsReachCD:Cancel()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 111216 then
		timerBladesofLightCD:Start()
	end
end

function mod:RAID_BOSS_EMOTE(msg)
	if msg:find("ability_warrior_battleshout.blp") then
		warnCallReinforcements:Show()
		timerCallReinforcementsCD:Start()
	end
end
