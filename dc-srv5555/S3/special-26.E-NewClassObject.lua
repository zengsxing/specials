--村规决斗：怪以类聚
--所有怪兽得到以下效果：
--这张卡召唤·特殊召唤成功的场合，
--从手卡·卡组·墓地·除外的卡中将所有同名怪兽
--无视召唤条件和苏生限制在自己场上尽可能地攻击表示特殊召唤。
--这个效果特殊召唤的卡当作正规召唤使用。
--后攻多抽2张。

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
	if not CUNGUI.Init then
		CUNGUI.Init = true
		Duel.Draw(1,2,REASON_RULE)
	end
end

function CUNGUI.RegisterMonsterSpecialEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetOperation(CUNGUI.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

function CUNGUI.spfilter(c,e,tp)
	return c:IsCode(e:GetHandler():GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP_ATTACK)
end

function CUNGUI.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(CUNGUI.spfilter,tp,0x33,0,c,e,tp)
	local f=Duel.GetMZoneCount(tp)
	if #g>0 and f>0 then
		local max = #g
		if max > f then max = f end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:Select(g,tp,max,max,nil)
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP_ATTACK)
	end
end