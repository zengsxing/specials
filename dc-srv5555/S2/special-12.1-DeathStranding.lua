--村规决斗：死亡搁浅
--所有怪兽得到以下效果：
--此类效果1回合只能使用1次。
--这张卡被送去墓地时才能发动。这张卡无视召唤条件和苏生限制在场上特殊召唤。

--细则：
--不能在伤判发动。这意味着被战斗破坏时不能发动。
--当然会被卡时点。
--这也同时意味着【作为各类召唤方式的素材】【取除叠光素材发动效果】【作为Cost送去墓地】
--等各种行为都会导致这个效果被卡掉时点。
--并不意味着能无视虚无空间。
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

    --ss
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(66666004,5))
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCountLimit(1,98765432)
    e4:SetCode(EVENT_TO_GRAVE)
    e4:SetTarget(CUNGUI.target)
    e4:SetOperation(CUNGUI.operation)
    c:RegisterEffect(e4)
end
function CUNGUI.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function CUNGUI.operation(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
	end
end
