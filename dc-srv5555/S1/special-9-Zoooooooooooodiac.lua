--村规决斗：十万生肖
--所有额外卡组的怪兽（不包括从场上表侧表示送去额外卡组的灵摆怪兽）得到以下效果：
--（仅非XYZ怪兽）这张卡当作XYZ怪兽使用，阶级相当于原本等级，或LINK数*2。
--（所有卡）这张卡也能在任何怪兽上面重叠来XYZ召唤。以这个方法进行的XYZ召唤1回合只能进行最多1次。
--（所有卡）这张卡也能在种族和这张卡的原本种族相同的怪兽上面重叠来XYZ召唤。

--细则：
--原本是连接怪兽，则不能在非连接区域/非额外区域进行XYZ召唤。
--本来是连接怪兽的怪兽在场时，仍有连接区。
OrigGetType = Card.GetType
Card.GetType = function(c)
	local typ = OrigGetType(c)
	if OrigIsType(c,TYPE_LINK+TYPE_SYNCHRO+TYPE_FUSION) then
		typ = typ | TYPE_XYZ
	end
	return typ
end

OrigIsType = Card.IsType
Card.IsType = function(c,typ)
	if (typ & TYPE_XYZ) == 0 then return OrigIsType(c,typ) end
	if OrigIsType(c,TYPE_XYZ+TYPE_LINK+TYPE_SYNCHRO+TYPE_FUSION) then return true end
	return false
end

OrigGetRank = Card.GetRank
Card.GetRank = function(c)
	if not c:IsType(TYPE_XYZ) then return OrigGetRank(c) end
	local lv = 0
	if c:IsType(TYPE_XYZ) then
		lv = c:GetOriginalRank()
	else
		lv = c:GetOriginalLevel()
	end
	return math.ceil(lv / 2)
end

OrigIsRank = Card.IsRank
Card.IsRank = function(c,...)
	local ranks = {...}
	if not c:IsType(TYPE_XYZ) then return OrigIsRank(c,...) end
	local lv = 0
	if c:IsType(TYPE_XYZ) then
		lv = c:GetOriginalRank()
	else
		lv = c:GetOriginalLevel()
	end
	for _,l in ipair(ranks) do
		if lv == l then return true end
	end
	return false
end

OrigIsRankAbove = Card.IsRankAbove
Card.IsRankAbove = function(c,rank)
	if not c:IsType(TYPE_LINK) then return OrigIsRankAbove(c,rank) end 
	return c:GetRank() >= rank
end

OrigIsRankBelow = Card.IsRankBelow
Card.IsRankBelow = function(c,rank)
	if not c:IsType(TYPE_XYZ) then return OrigIsRankBelow(c,rank) end 
	return c:GetLink() <= rank
end

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
	local g = Duel.GetMatchingGroup(Card.IsType,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,TYPE_MONSTER)
	g:ForEach(CUNGUI.RegisterMonsterSpecialEffects)
end

function CUNGUI.RegisterMonsterSpecialEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
	if not c:IsType(TYPE_XYZ) then
		--Non-link monster
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_ADD_TYPE)
		e3:SetRange(LOCATION_MZONE+LOCATION_EXTRA)
		e3:SetValue(TYPE_XYZ)
		c:RegisterEffect(e3)
	end
	if not c:IsType(TYPE_EFFECT) then
		--Normal monster
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetCode(EFFECT_ADD_TYPE)
		e4:SetRange(LOCATION_MZONE+LOCATION_EXTRA)
		e4:SetValue(TYPE_EFFECT)
		c:RegisterEffect(e4)
	end
	aux.AddXyzProcedure(c,nil,4,5,CUNGUI.ovfilter,aux.Stringid(18678554,0),5,CUNGUI.xyzop)
	--Link summon
	aux.AddXyzProcedure(c,nil,2)
end

function CUNGUI.AddXyzProcedure(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(18678554,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,87654321+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(CUNGUI.XyzCondition)
	e1:SetTarget(CUNGUI.XyzTarget)
	e1:SetOperation(CUNGUI.XyzOperation)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCondition(CUNGUI.XyzCondition)
	e2:SetTarget(CUNGUI.XyzTarget)
	e2:SetCountLimit(99)
	c:RegisterEffect(e2)
end

function CUNGUI.XyzCondition2(e,c,og,min,max)
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	return Duel.IsExistingMatchingCard(CUNGUI.XyzMaterial2,c:GetControler(),LOCATION_MZONE,0,1,nil,c)
end

function CUNGUI.XyzCondition(e,c,og,min,max)
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	return Duel.IsExistingMatchingCard(CUNGUI.XyzMaterial,c:GetControler(),LOCATION_MZONE,0,1,nil,c)
end

function CUNGUI.XyzMaterial(c,cc)
	return c:IsFaceup() and c:IsCanBeXyzMaterial(cc)
end

function CUNGUI.XyzMaterial2(c,cc)
	return c:IsFaceup() and c:IsRace(cc:GetOriginalRace()) and c:IsCanBeXyzMaterial(cc)
end

function CUNGUI.XyzTarget(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	if chk==0 then return Duel.GetFlagEffect(tp,87654321)==0 end
	Duel.RegisterFlagEffect(tp,87654321,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,CUNGUI.XyzMaterial,tp,LOCATION_MZONE,0,1,1,nil,c)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else
		return false
	end
end

function CUNGUI.XyzTarget2(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	if chk==0 then return Duel.GetFlagEffect(tp,87654321)==0 end
	Duel.RegisterFlagEffect(tp,87654321,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,CUNGUI.XyzMaterial2,tp,LOCATION_MZONE,0,1,1,nil,c)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else
		return false
	end
end

function CUNGUI.XyzOperation(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local sg=Group.CreateGroup()
	local gg=Group.CreateGroup()
	for tc in aux.Next(og) do
		local sg1=tc:GetOverlayGroup()
		sg1 = sg1:Filter(Card.IsCanBeXyzMaterial,nil,c)
		local sg2 = tc:GetOverlayGroup()
		sg2:Remove(Card.IsCanBeXyzMaterial,nil,c)
		Duel.SendtoGrave(sg2,REASON_RULE)
		sg:Merge(sg1)
		gg:Merge(sg2)
	end
	Duel.SendtoGrave(gg,REASON_RULE)
	c:SetMaterial(og)
	Duel.Overlay(c,og)
	Duel.Overlay(c,sg)
end
