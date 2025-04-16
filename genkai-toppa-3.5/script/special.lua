--[[
开局时，双方将1张一色之劳（83404468）从卡组外表侧表示除外。
这场决斗中这张卡不是表侧表示除外的场合，这张卡表侧表示除外。
这张卡得到以下效果外文本。

场上4星以下的【森罗】怪兽得到以下效果。
·这张卡不受效果影响。这个效果不会被无效化。
手卡中5星以上的【森罗】怪兽得到以下效果。
·这张卡可以从手卡特殊召唤。

手牌·墓地的【无限起动】怪兽得到以下效果。
这个卡名的这个效果1回合只能使用1次。
自己·对方回合才能发动。这张卡在场上特殊召唤。从卡组把1只【无限起动】怪兽特殊召唤。

场上的【无限起动】怪兽得到以下效果。
自己·对方回合1次，宣言1个1~13的等级、1个属性、1个种族才能发动。
双方场上所有怪兽变为那个等级、属性、种族，卡名当作【无名氏】使用。

手卡原本卡名是【魔厨】的卡得到以下效果。
这个卡名的这个效果1回合只能使用1次。
把这张卡从手卡丢弃才能发动。从卡组·墓地选1张【魔厨】怪兽和1张【食谱】卡加入手卡。

场上原本卡名是【魔厨】的怪兽得到以下效果。
卡被解放时发动。选场上最多有那个相同数量的卡烧掉。

]]--
CUNGUI = {}
CUNGUI.disabled={}
CUNGUI.RuleCards=Group.CreateGroup()
CUNGUI._IsSetCard=Card.IsSetCard

function Card.IsSetCard(c,setcode)
    if c:GetFlagEffect(98765432)>0 then return false end
    return CUNGUI._IsSetCard(c, setcode)
end

function Card.IsOrigSetCard(c,setcode)
    return CUNGUI._IsSetCard(c, setcode)
end

function CUNGUI.regsplimit(tc,tp)
	local code=tc:GetOriginalCodeRule()
	local race=tc:GetOriginalRace()
	
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(CUNGUI.sylcheckfunc(code,race))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	
end

function CUNGUI.sylcheckfunc(code,race)
	return function(e,c,sump,sumtype,sumpos,targetp,se)
		return c:GetOriginalRace()==race and c:GetOriginalCodeRule()~=code
	end
end

function Auxiliary.PreloadUds()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetOperation(CUNGUI.AdjustOperation)
	Duel.RegisterEffect(e1,0)
	--adjust
	e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(CUNGUI.AdjustOperation2)
	Duel.RegisterEffect(e1,0)
end

function CUNGUI.AdjustOperation2(e,tp,eg,ep,ev,re,r,rp)
	if (CUNGUI.RuleCards:Filter(Card.IsLocation,nil,LOCATION_REMOVED):GetCount()~=2) then
		Duel.Remove(CUNGUI.RuleCards,POS_FACEUP,REASON_RULE)
	end
end

CUNGUI.Used={}

function CUNGUI.useoncecondition(e,tp,eg,ep,ev,re,r,rp)
    return CUNGUI.Used[e:GetHandler():GetOriginalCode()] == nil
        or CUNGUI.Used[e:GetHandler():GetOriginalCode()][e:GetLabel()] == nil
        or CUNGUI.Used[e:GetHandler():GetOriginalCode()][e:GetLabel()] < Duel.GetTurnCount()
end

function CUNGUI.RegisterRuleEffect(c,tp)
	--森罗-4星以下
	--immune
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_IMMUNE_EFFECT)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(CUNGUI.efilter)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_REMOVED)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(CUNGUI.eftgsyl1)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
    e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(CUNGUI.sylspcon)
	c:RegisterEffect(e0)
    e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_REMOVED)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(CUNGUI.eftgsyl2)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	--spsummon
	e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(75425043,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e0:SetTarget(CUNGUI.inftsptg)
	e0:SetOperation(CUNGUI.inftspop)
    e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_REMOVED)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_GRAVE,0)
	e1:SetTarget(CUNGUI.eftginft)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	--to hand
	e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(75425043,0))
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND)
    e0:SetCost(CUNGUI.discost)
	e0:SetTarget(CUNGUI.bdnthtg)
	e0:SetOperation(CUNGUI.bdnthop)
    e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_REMOVED)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(CUNGUI.eftgbdn2)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	--exile
	e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(75425043,0))
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetRange(LOCATION_MZONE)
    e0:SetCode(EVENT_RELEASE)
	e0:SetOperation(CUNGUI.bdnexop)
    e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e1:SetRange(LOCATION_REMOVED)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(CUNGUI.eftgbdn2)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
end
function CUNGUI.bdnextg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    e:SetLabel(eg:GetCount())
end
function CUNGUI.bdnexop(e,tp,eg,ep,ev,re,r,rp)
    local i=e:GetLabel()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
    local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,i,nil)
    if #g>0 then
        Duel.Exile(g,REASON_EFFECT)
    end
end
function CUNGUI.bdnthtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(CUNGUI.bdnthfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
            and Duel.IsExistingMatchingCard(CUNGUI.bdnthfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function CUNGUI.bdnthfilter1(c)
    return c:IsSetCard(0x196) and c:IsAbleToHand()
end
function CUNGUI.bdnthfilter2(c)
    return c:IsSetCard(0x197) and c:IsAbleToHand()
end
function CUNGUI.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function CUNGUI.bdnthtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return
        Duel.IsExistingMatchingCard(CUNGUI.bdnthfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
        and Duel.IsExistingMatchingCard(CUNGUI.bdnthfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function CUNGUI.bdnthop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g1=Duel.SelectMatchingCard(tp,CUNGUI.bdnthfilter1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g2=Duel.SelectMatchingCard(tp,CUNGUI.bdnthfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
    if #g1>0 then
        Duel.SendtoHand(g1,nil,REASON_EFFECT)
    end
    if #g2>0 then
        Duel.SendtoHand(g2,nil,REASON_EFFECT)
    end
end
function CUNGUI.inftchtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsSetCard(0x127) end
end
function CUNGUI.inftchop(e,tp,eg,ep,ev,re,r,rp)
    local race=Duel.AnnounceRace(tp,1,RACE_ALL)
    local attr=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL)
    local lv=Duel.AnnounceLevel(tp,1,13)
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    for c in aux.Next(g) do
        local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
        e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(race)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
        e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(attr)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
        c:RegisterFlagEffect(98765432,RESET_EVENT+RESETS_STANDARD+RESET_PHASE,0,1)
    end
end
function CUNGUI.inftspfilter(c,e,tp)
    return c:IsSetCard(0x127) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function CUNGUI.inftsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
        return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
            and Duel.IsExistingMatchingCard(CUNGUI.inftspfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
            and Duel.GetMZoneCount(tp)>1
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK+e:GetHandler():GetLocation())
end
function CUNGUI.inftspop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,CUNGUI.inftspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    end
end
function CUNGUI.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
--森罗
function CUNGUI.eftgsyl1(e,c)
	return c:IsSetCard(0x90) and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4)
end
function CUNGUI.eftgsyl2(e,c)
	return c:IsSetCard(0x90) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(5)
end
function CUNGUI.eftginft(e,c)
	return c:IsSetCard(0x127) and c:IsType(TYPE_MONSTER)
end
function CUNGUI.eftgbdn(e,c)
	return (c:IsOrigSetCard(0x196) or c:IsOrigSetCard(0x197)) and c:IsType(TYPE_MONSTER)
end
function CUNGUI.eftgbdn2(e,c)
	return c:IsOrigSetCard(0x196) and c:IsType(TYPE_MONSTER)
end
function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
	local card1 = Duel.CreateToken(0,83404468)
	local card2 = Duel.CreateToken(1,83404468)
	CUNGUI.RegisterRuleEffect(card1,0)
	CUNGUI.RegisterRuleEffect(card2,1)
	CUNGUI.RuleCards:AddCard(card1)
	CUNGUI.RuleCards:AddCard(card2)
	Duel.Remove(card1,POS_FACEUP,REASON_RULE)
	Duel.Remove(card2,POS_FACEUP,REASON_RULE)
	e:Reset()
end
