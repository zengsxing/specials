--村规决斗：谁是小丑
--开局时，双方从卡组外将1张【娱乐法师 戏法小丑】表侧表示从游戏中除外。
--这张【娱乐法师 戏法小丑】得到以下效果。
--①自己准备阶段，这张卡不在场上的场合发动。
--投1个硬币。如果是正面，这张卡在自己场上特殊召唤，自己受到1000点伤害。
--③这张卡离开场上的场合从游戏中除外，不在场上存在的场合（比如作为超量素材）从游戏中除外。

CUNGUI = {}

function Auxiliary.PreloadUds()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(CUNGUI.AdjustOperation)
	Duel.RegisterEffect(e1,0)
end
function CUNGUI.AdjustOperation()
	if not CUNGUI.INIT then
		CUNGUI.INIT = true
		CUNGUI.RegisterForbiddenRule(0)
		CUNGUI.RegisterForbiddenRule(1)
	end
	if CUNGUI.RuleCard[0] and not CUNGUI.RuleCard[0]:IsLocation(LOCATION_REMOVED+LOCATION_ONFIELD) then
		Duel.Remove(CUNGUI.RuleCard[0],POS_FACEUP,REASON_RULE)
	end
	if CUNGUI.RuleCard[1] and not CUNGUI.RuleCard[1]:IsLocation(LOCATION_REMOVED+LOCATION_ONFIELD) then
		Duel.Remove(CUNGUI.RuleCard[1],POS_FACEUP,REASON_RULE)
	end
	if CUNGUI.RuleCard[0] and not CUNGUI.RuleCard[0]:IsFaceup() then
		Duel.ChangePosition(CUNGUI.RuleCard[0],POS_FACEUP)
	end
	if CUNGUI.RuleCard[1] and not CUNGUI.RuleCard[1]:IsFaceup() then
		Duel.ChangePosition(CUNGUI.RuleCard[1],POS_FACEUP)
	end
end

CUNGUI.RuleCard={}
CUNGUI.ForbiddenEffects={}
CUNGUI.ForbiddenEffects[0]={}
CUNGUI.ForbiddenEffects[1]={}

function CUNGUI.RegisterForbiddenRule(tp)
	local c=Duel.CreateToken(tp,67696066)
	Duel.Remove(c,POS_FACEUP,REASON_RULE)
	CUNGUI.RuleCard[tp]=c
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetDescription(aux.Stringid(102380,1))
	e2:SetCategory(CATEGORY_DICE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_OVERLAY+LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCountLimit(1)
	e2:SetCondition(CUNGUI.damcon)
	e2:SetOperation(CUNGUI.damop)
	c:RegisterEffect(e2)
end
function CUNGUI.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function CUNGUI.damop(e,tp,eg,ep,ev,re,r,rp)
	local dice=Duel.TossCoin(tp,1)
	if dice==1 then
		if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)>0 then
			Duel.Damage(tp,1000,REASON_EFFECT)
		end
	end
end









