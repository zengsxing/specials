--村规决斗：献上祭品
--所有怪兽得到以下效果：
--这张卡可以把自己场上的表侧表示的2只与这张卡同种族或同属性的怪兽送去墓地，
--从场上以外特殊召唤。

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
	local g = Duel.GetMatchingGroup(Card.IsType,0,0x7f,0x7f,nil,TYPE_MONSTER)
	g:ForEach(CUNGUI.RegisterMonsterSpecialEffects)
end

function CUNGUI.RegisterMonsterSpecialEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
	--spsummon proc
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetDescription(aux.Stringid(66666004,5))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(0x7f-LOCATION_ONFIELD)
	e1:SetCondition(CUNGUI.spcon)
	e1:SetOperation(CUNGUI.spop)
	c:RegisterEffect(e1)
end
function CUNGUI.CreateFilter(c)
	local race=c:GetRace()
	local attr=c:GetAttribute()
	return function(c)
		return c:IsFaceup() and (c:IsRace(race) or c:IsAttribute(attr)) and c:IsAbleToGraveAsCost()
	end
end
function CUNGUI.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(CUNGUI.CreateFilter(e:GetHandler()),tp,LOCATION_MZONE,0,2,nil)
end
function CUNGUI.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,CUNGUI.CreateFilter(e:GetHandler()),tp,LOCATION_MZONE,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
end