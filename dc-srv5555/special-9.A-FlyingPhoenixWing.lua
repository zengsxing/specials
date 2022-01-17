--村规决斗：凤翼天翔
--所有怪兽得到以下效果：
--自己·对方回合才能发动。对方选发动这个效果的玩家的场上1张卡，自己选场上1张卡破坏，对方可以从卡组抽1张。
--这个效果在对方回合也能发动。
--后攻开局时多抽1张。

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
    if not CUNGUI.DRAW then
        CUNGUI.DRAW = true
        Duel.Draw(1,1,REASON_RULE)
    end
	local g = Duel.GetMatchingGroup(Card.IsType,0,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA+LOCATION_MZONE,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA+LOCATION_MZONE,nil,TYPE_MONSTER)
	g:ForEach(CUNGUI.RegisterMonsterSpecialEffects)
end

function CUNGUI.RegisterMonsterSpecialEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
	
    --destroy
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(1157683,1))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,98765432)
    e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
    e2:SetTarget(CUNGUI.destg)
    e2:SetOperation(CUNGUI.desop)
    c:RegisterEffect(e2)
end
function CUNGUI.desfilter1(c)
    return Duel.IsExistingMatchingCard(nil,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function CUNGUI.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(CUNGUI.desfilter1,tp,LOCATION_ONFIELD,0,1,nil) end
    local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function CUNGUI.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g1=Duel.SelectMatchingCard(1-tp,CUNGUI.desfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
    if #g1==0 then return end
    Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
    local g2=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,g1)
    g1:Merge(g2)
    Duel.HintSelection(g1)
    Duel.Destroy(g1,REASON_EFFECT)
    if Duel.SelectYesNo(1-tp,aux.Stringid(63166095,0)) then
        Duel.Draw(1-tp,1,REASON_RULE)
    end
end