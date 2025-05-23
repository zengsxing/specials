--ジェネレーション・チェンジ
---@param c Card
function c34460239.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c34460239.target)
	e1:SetOperation(c34460239.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(34460239,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c34460239.handcon)
	c:RegisterEffect(e2)
end
function c34460239.filter(c,tp)
	return c:IsFaceup()
		and Duel.IsExistingMatchingCard(c34460239.nfilter1,tp,LOCATION_DECK,0,1,nil,c)
end
function c34460239.nfilter1(c,tc)
	return c:IsCode(tc:GetCode()) and c:IsAbleToHand()
end
function c34460239.nfilter2(c,tc)
	return c:IsCode(tc:GetPreviousCodeOnField()) and c:IsAbleToHand()
end
function c34460239.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c34460239.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c34460239.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c34460239.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c34460239.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,c34460239.nfilter2,tp,LOCATION_DECK,0,1,1,nil,tc)
		local hc=g:GetFirst()
		if hc then
			Duel.SendtoHand(hc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,hc)
		end
	end
end
function c34460239.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0
end