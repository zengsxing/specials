--クリフォート・アセンブラ
function c51194046.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(51194046,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c51194046.drcon)
	e3:SetTarget(c51194046.drtg)
	e3:SetOperation(c51194046.drop)
	c:RegisterEffect(e3)
end
function c51194046.cfilter(c,tp)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE) and c:IsSummonPlayer(tp)
end
function c51194046.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c51194046.cfilter,1,nil,tp)
end
function c51194046.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c51194046.cfilter,nil)
	local ct=0
	for tc in aux.Next(g) do
		ct=ct+tc:GetMaterial():FilterCount(Card.IsSetCard,nil,0xaa)
	end
	if chk==0 then return ct>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c51194046.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
