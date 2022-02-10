--村规决斗：昨日方舟
--所有怪兽得到以下效果：
--（仅通常怪兽）这张卡也当作效果怪兽使用。
--这个类型的效果1回合能使用最多3次。
--自己主要阶段才能发动。宣言1个种族，从自己卡组上面把5张卡翻开。
--可以从那之中选1只那个种族的怪兽特殊召唤。
--剩下的卡用喜欢的顺序回到卡组最下面。

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
	local g = Duel.GetMatchingGroup(Card.IsType,0,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,nil,TYPE_MONSTER)
	g:ForEach(CUNGUI.RegisterMonsterSpecialEffects)
end

function CUNGUI.RegisterMonsterSpecialEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
	if c:IsType(TYPE_NORMAL) then
		--Normal monster
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(TYPE_EFFECT)
		c:RegisterEffect(e1)
	end
    --spsummon2
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(41546,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(3,98765432)
    e2:SetTarget(CUNGUI.sptg2)
    e2:SetOperation(CUNGUI.spop2)
    c:RegisterEffect(e2)
end
function CUNGUI.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
end
function CUNGUI.spfilter(c,e,tp,rc)
    return c:IsRace(rc) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function CUNGUI.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=4 then return end
    local rc=Duel.AnnounceRace(tp,1,RACE_ALL)
    Duel.ConfirmDecktop(tp,5)
    local g=Duel.GetDecktopGroup(tp,5)
    local ct=g:GetCount()
    if ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:FilterCount(CUNGUI.spfilter,nil,e,tp,rc)>0
        and Duel.SelectYesNo(tp,aux.Stringid(48519867,2)) then
        Duel.DisableShuffleCheck()
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local sg=g:FilterSelect(tp,CUNGUI.spfilter,1,1,nil,e,tp,rc)
        Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
        ct=g:GetCount()-sg:GetCount()
    end
    if ct>0 then
        Duel.SortDecktop(tp,tp,ct)
        for i=1,ct do
            local mg=Duel.GetDecktopGroup(tp,1)
            Duel.MoveSequence(mg:GetFirst(),1)
        end
    end
end
