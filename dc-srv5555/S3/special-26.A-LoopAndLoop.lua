--村规决斗：循环往复
--所有怪兽得到以下效果：
--以下的①②效果使用后，原本卡名与这张卡的原本卡名相同的卡当回合不能使用类似效果。
--①自己场上有等级·阶级·连接数与这张卡的等级相同，或属性·种族与这张卡相同的卡的场合才能发动。这张卡从手卡特殊召唤。
--②这张卡特殊召唤的场合才能发动。从卡组把1只和这张卡等级·阶级·连接数相同的怪兽加入手卡。这个回合，自己不能把这个效果加入手卡的卡以及那些同名卡的效果发动。
--③这张卡被送去墓地的场合发动。这张卡返回卡组。
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
CUNGUI.Used={}
CUNGUI.Used[0]={}
CUNGUI.Used[1]={}
CUNGUI.Used2={}
CUNGUI.Used2[0]={}
CUNGUI.Used2[1]={}

function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetMatchingGroup(Card.IsType,0,0x7f,0x7f,nil,TYPE_MONSTER)
	g:ForEach(CUNGUI.RegisterMonsterSpecialEffects)
	CUNGUI.Used[0]={}
	CUNGUI.Used[1]={}
	CUNGUI.Used2[0]={}
	CUNGUI.Used2[1]={}
	if not CUNGUI.Init then
		CUNGUI.Init = true
		Duel.Draw(1,2,REASON_RULE)
	end
end

function CUNGUI.RegisterMonsterSpecialEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1764972,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(CUNGUI.spcon)
	e1:SetTarget(CUNGUI.sptg)
	e1:SetOperation(CUNGUI.spop)
	c:RegisterEffect(e1)
	--search
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(123709,2))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(CUNGUI.thcon)
	e1:SetTarget(CUNGUI.thtg)
	e1:SetOperation(CUNGUI.thop)
	c:RegisterEffect(e1)
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11868731,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetTarget(CUNGUI.rettg)
	e1:SetOperation(CUNGUI.retop)
	c:RegisterEffect(e1)
end

function CUNGUI.spfilter(c,sc)
	local x=sc:GetLevel()
	local y=sc:GetAttribute()
	local z=sc:GetRace()
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and (c:IsLevel(x) or c:IsRank(x) or c:IsLink(x) or c:IsAttribute(y) or c:IsRace(z))
end

function CUNGUI.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(CUNGUI.spfilter,tp,LOCATION_MZONE,0,1,nil,e:GetHandler())
		and not CUNGUI.Used[tp][e:GetHandler():GetOriginalCode()]
end
function CUNGUI.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	CUNGUI.Used[tp][e:GetHandler():GetOriginalCode()]=true
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function CUNGUI.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function CUNGUI.thcon(e,tp,eg,ep,ev,re,r,rp)
	return not CUNGUI.Used2[tp][e:GetHandler():GetOriginalCode()]
end
function CUNGUI.thfilter(c,sc)
	if not c:IsType(TYPE_MONSTER) then return false end
	local i=sc:GetLevel()
	local j=sc:GetRank()
	local k=sc:GetLink()
	local y=sc:GetAttribute()
	local z=sc:GetRace()
	return (c:IsLevel(x) or c:IsLevel(j) or c:IsLevel(k) or c:IsAttribute(y) or c:IsRace(z))
end
function CUNGUI.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(CUNGUI.thfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
	CUNGUI.Used2[tp][e:GetHandler():GetOriginalCode()]=true
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function CUNGUI.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,CUNGUI.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		if tc:IsLocation(LOCATION_HAND) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetTargetRange(1,0)
			e1:SetValue(CUNGUI.aclimit)
			e1:SetLabel(tc:GetCode())
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function CUNGUI.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
function CUNGUI.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function CUNGUI.retop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end