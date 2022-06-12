--村规决斗：继往开来
--所有怪兽得到以下效果：
--场上存在的这张卡送去墓地时发动。从卡组将1只与这张卡种族或属性相同的怪兽加入手卡。
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
	--search
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(135598,0))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetCondition(CUNGUI.condition)
    e1:SetTarget(CUNGUI.target)
    e1:SetOperation(CUNGUI.operation)
    c:RegisterEffect(e1)
end
function CUNGUI.condition(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function CUNGUI.filter(c,oc)
    return (c:IsRace(oc:GetRace()) or c:IsAttribute(oc:GetAttribute())) and c:IsAbleToHand()
end
function CUNGUI.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function CUNGUI.operation(e,tp,eg,ep,ev,re,r,rp,chk)
    if not (e:GetHandler():IsRelateToEffect(e)) then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,CUNGUI.filter,tp,LOCATION_DECK,0,1,1,nil,e:GetHandler())
	if #tc>0 then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT) > 0 then
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
