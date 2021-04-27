--カップ・オブ・エース
function c37812118.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c37812118.target)
	e1:SetOperation(c37812118.activate)
	c:RegisterEffect(e1)
end
c37812118.toss_coin=true
function c37812118.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,4) and Duel.IsPlayerCanDraw(1-tp,4) end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c37812118.activate(e,tp,eg,ep,ev,re,r,rp)
	local res1,res2=Duel.TossCoin(tp,2)
	local drawCounts={[0]=0,[1]=0}
	if res1==1 then drawCounts[tp]=drawCounts[tp]+2 else drawCounts[1-tp]=drawCounts[1-tp]+2 end
	if res2==1 then drawCounts[tp]=drawCounts[tp]+2 else drawCounts[1-tp]=drawCounts[1-tp]+2 end
	if drawCounts[tp]>0 then Duel.Draw(tp,drawCounts[tp],REASON_EFFECT) end
	if drawCounts[1-tp]>0 then Duel.Draw(1-tp,drawCounts[1-tp],REASON_EFFECT) end
end
