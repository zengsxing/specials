--村规决斗：众生平等
--所有怪兽都可以不用解放作通常召唤。
--所有怪兽都可以从手卡特殊召唤。
--以上2种方式的通常召唤与特殊召唤，每个玩家1回合只能进行1次（两个类型合计1次）
--（仅增加了出场方式，并不意味着每个回合的通常召唤权限变多了）
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

function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetMatchingGroup(Card.IsType,0,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_HAND,nil,TYPE_MONSTER)
	g:ForEach(CUNGUI.RegisterSummonCondition)
	e:Reset()
end

function CUNGUI.RegisterSummonCondition(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32446630,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,23456789)
	c:RegisterEffect(e1,true)
	--summon & set with no tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(78651105,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCondition(CUNGUI.ntcon)
	e2:SetCountLimit(1,23456789)
	c:RegisterEffect(e2,true)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e3,true)
end

function CUNGUI.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
