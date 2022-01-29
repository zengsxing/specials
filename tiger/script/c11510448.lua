--十二獣タイグリス
function c11510448.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,3,c11510448.ovfilter,aux.Stringid(11510448,0),3,c11510448.xyzop)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c11510448.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c11510448.defval)
	c:RegisterEffect(e2)
	--xyz material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11510448,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c11510448.cost)
	e3:SetTarget(c11510448.target)
	e3:SetOperation(c11510448.operation)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetDescription(aux.Stringid(11510448,3))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetCost(c11510448.cost)
	e4:SetTarget(c11510448.drtg)
	e4:SetOperation(c11510448.drop)
	c:RegisterEffect(e4)
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetOperation(c11510448.regop1)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVED)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c11510448.damcon1)
	e6:SetOperation(c11510448.damop)
	c:RegisterEffect(e6)
	--damage
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(c11510448.damcon2)
	e7:SetOperation(c11510448.damop)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e8)
end
function c11510448.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf1) and not c:IsCode(11510448)
end
function c11510448.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,11510448)==0 end
	Duel.RegisterFlagEffect(tp,11510448,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c11510448.atkfilter(c)
	return c:IsSetCard(0xf1) and c:GetAttack()>=0
end
function c11510448.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c11510448.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c11510448.deffilter(c)
	return c:IsSetCard(0xf1) and c:GetDefense()>=0
end
function c11510448.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c11510448.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function c11510448.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c11510448.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c11510448.filter2(c)
	return c:IsSetCard(0xf1) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function c11510448.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c11510448.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c11510448.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11510448,2))
	Duel.SelectTarget(tp,c11510448.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectTarget(tp,c11510448.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c11510448.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc1=g:Filter(Card.IsLocation,nil,LOCATION_MZONE):GetFirst()
	local g2=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if tc1 and tc1:IsFaceup() and not tc1:IsImmuneToEffect(e) and g2:GetCount()>0 then
		Duel.Overlay(tc1,g2)
	end
end
function c11510448.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c11510448.drop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c11510448.regop1(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(11510448,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function c11510448.damcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOverlayCount()>0 and ep~=tp and c:GetFlagEffect(11510448)~=0
end
function c11510448.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp) and e:GetHandler():GetOverlayCount()>0
end
function c11510448.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,({9342162,42090294,45593826,68182934,73779005,77936940,82114013})[math.random(7)])
	Duel.Damage(1-tp,e:GetHandler():GetOverlayCount()*200,REASON_EFFECT)
end
