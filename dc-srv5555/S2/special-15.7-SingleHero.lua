--村规决斗：孤胆英雄
--所有怪兽得到以下效果：
--这张卡可以支付一半生命值，在对方场上守备表示特殊召唤。
--自己场上的怪兽只有这张卡的场合，这张卡不受其他卡的效果影响。
CUNGUI = {}

function Auxiliary.PreloadUds()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetOperation(CUNGUI.AdjustOperation)
	Duel.RegisterEffect(e1,0)
end

CUNGUI.RegisteredMonsters = Group.CreateGroup()

function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetMatchingGroup(Card.IsType,0,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA+LOCATION_MZONE,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA+LOCATION_MZONE,nil,TYPE_MONSTER)
	g:ForEach(CUNGUI.RegisterMonsterSpecialEffects)
end

function CUNGUI.RegisterMonsterSpecialEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(CUNGUI.imcon)
	e1:SetValue(CUNGUI.efilter)
	c:RegisterEffect(e1)
	--special summon
	e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,1)
	e1:SetCondition(CUNGUI.spcon)
	e1:SetOperation(CUNGUI.spop)
	c:RegisterEffect(e1)
end
function CUNGUI.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		and Duel.IsPlayerCanSpecialSummonCount(tp,1)
end
function CUNGUI.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function CUNGUI.imcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==1
end
function CUNGUI.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end