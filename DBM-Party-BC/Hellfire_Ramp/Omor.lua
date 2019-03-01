local mod	= DBM:NewMod(528, "DBM-Party-BC", 1, 248)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision$"):sub(12, -3))
mod:SetCreatureID(17308)
mod:SetEncounterID(1891)
mod:SetUsedIcons(8)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 37566",
	"SPELL_AURA_REMOVED 37566"
)

local warnBane      = mod:NewTargetAnnounce(37566)

local specwarnBane  = mod:NewSpecialWarningMoveAway(37566, nil, nil, nil, 1, 2)
local yellBane		= mod:NewYell(37566)

local timerBane     = mod:NewTargetTimer(15, 37566, nil, nil, nil, 3)

mod:AddBoolOption("SetIconOnBaneTarget", true)
mod:AddBoolOption("RangeFrame")

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 37566 then
		timerBane:Start(args.destName)
		if self.Options.SetIconOnBaneTarget then
			self:SetIcon(args.destName, 8, 15)
		end
		if args:IsPlayer() then
            specwarnBane:Show()
            specwarnBane:Play("runout")
            yellBane:Yell()
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(15)
			end
		else
			warnBane:Show(args.destName)
        end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 37566 then
		timerBane:Stop(args.destName)
		if self.Options.SetIconOnBaneTarget then
			self:SetIcon(args.destName, 0)
		end
		if args:IsPlayer() and self.Options.RangeFrame then
			DBM.RangeCheck:Hide()
		end
	end
end