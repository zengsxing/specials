--瀑征竜－タイダル
function c26400609.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26400609,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCost(c26400609.hspcost)
	e1:SetTarget(c26400609.hsptg)
	e1:SetOperation(c26400609.hspop)
	c:RegisterEffect(e1)
	--return
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26400609,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,26400609)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCondition(c26400609.retcon)
	e2:SetTarget(c26400609.rettg)
	e2:SetOperation(c26400609.retop)
	c:RegisterEffect(e2)
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26400609,2))
	e3:SetCategory(CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCost(c26400609.tgcost)
	e3:SetTarget(c26400609.tgtg)
	e3:SetOperation(c26400609.tgop)
	c:RegisterEffect(e3)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26400609,3))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetCountLimit(1,26400609)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetTarget(c26400609.thtg)
	e4:SetOperation(c26400609.thop)
	c:RegisterEffect(e4)
	c26400609.Dragon_Ruler_handes_effect=e3
end
function c26400609.rfilter(c)
	return (c:IsRace(RACE_DRAGON) or c:IsAttribute(ATTRIBUTE_WATER)) and c:IsAbleToRemoveAsCost()
end
function c26400609.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local a=Duel.GetFlagEffect(tp,13513663)>0 and Duel.GetFlagEffect(tp,26400609)==0
    local b=Duel.GetFlagEffect(tp,13513663)==0 and Duel.GetFlagEffect(tp,26400609)==0 and Duel.GetFlagEffect(tp,26400610)==0  and Duel.GetFlagEffect(tp,26400611)==0 and Duel.GetFlagEffect(tp,26400612)==0  
	if chk==0 then return Duel.IsExistingMatchingCard(c26400609.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,e:GetHandler()) and (a or b) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c26400609.rfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,2,2,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
    Duel.RegisterFlagEffect(tp,26400609,RESET_PHASE+PHASE_END,0,1)
end
function c26400609.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c26400609.hspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c26400609.retcon(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetFlagEffect(tp,13513663)>0
    local b=Duel.GetFlagEffect(tp,13513663)==0 and Duel.GetFlagEffect(tp,26400609)==0 and Duel.GetFlagEffect(tp,26400610)==0 and Duel.GetFlagEffect(tp,26400611)==0 and Duel.GetFlagEffect(tp,26400612)==0  
	return Duel.GetTurnPlayer()==1-tp
		and e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL) and (a or b)
end
function c26400609.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
    Duel.RegisterFlagEffect(tp,26400612,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c26400609.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c26400609.dfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function c26400609.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local a=Duel.GetFlagEffect(tp,13513663)>0 and Duel.GetFlagEffect(tp,26400610)==0
    local b=Duel.GetFlagEffect(tp,13513663)==0 and Duel.GetFlagEffect(tp,26400609)==0 and Duel.GetFlagEffect(tp,26400610)==0  and Duel.GetFlagEffect(tp,26400611)==0 and Duel.GetFlagEffect(tp,26400612)==0  
	if chk==0 then return e:GetHandler():IsDiscardable() and e:GetHandler():IsAbleToGraveAsCost()
		and Duel.IsExistingMatchingCard(c26400609.dfilter,tp,LOCATION_HAND,0,1,e:GetHandler())  and (a or b) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c26400609.dfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
    Duel.RegisterFlagEffect(tp,26400610,RESET_PHASE+PHASE_END,0,1)
end
function c26400609.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c26400609.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,_,exc)
	if chk==0 then return Duel.IsExistingMatchingCard(c26400609.tgfilter,tp,LOCATION_DECK,0,1,exc) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c26400609.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c26400609.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c26400609.thfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToHand()
end
function c26400609.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local a=Duel.GetFlagEffect(tp,13513663)>0
    local b=Duel.GetFlagEffect(tp,13513663)==0 and Duel.GetFlagEffect(tp,26400609)==0 and Duel.GetFlagEffect(tp,26400610)==0  and Duel.GetFlagEffect(tp,26400611)==0 and Duel.GetFlagEffect(tp,26400612)==0  
	if chk==0 then return Duel.IsExistingMatchingCard(c26400609.thfilter,tp,LOCATION_DECK,0,1,nil) and (a or b) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.RegisterFlagEffect(tp,26400611,RESET_PHASE+PHASE_END,0,1)
end
function c26400609.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c26400609.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
