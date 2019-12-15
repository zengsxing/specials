local activity_check_list=0
function Auxiliary.PreloadUds()
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function(e)
		for tp=0,1 do
			local fc=Duel.CreateToken(tp,4064256)
			Duel.MoveToField(fc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local dc=Duel.CreateToken(tp,32274490)
			Duel.SendtoGrave(dc,REASON_RULE+REASON_RETURN)
			local e1=Effect.CreateEffect(dc)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_FREE_CHAIN)
			local function f(c)
				return c:IsRace(RACE_ZOMBIE) and c:IsAbleToGrave()
				--return true
			end
			e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
				local g=Duel.GetMatchingGroup(f,tp,LOCATION_DECK,0,nil)
				return (activity_check_list&(0x1<<tp))>0 and #g>0
			end)
			e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
				Duel.Hint(HINT_CARD,0,32274490)
				local g=Duel.GetMatchingGroup(f,tp,LOCATION_DECK,0,nil)
				local tg=g:RandomSelect(tp,1)
				Duel.SendtoGrave(tg,REASON_EFFECT)
				e:Reset()
			end)
			Duel.RegisterEffect(e1,tp)
		end
		e:Reset()
	end)
	Duel.RegisterEffect(e1,0)
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		for p=0,1 do
			if eg:IsExists(function(c)
				return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==p
			end,1,nil) then
				activity_check_list=activity_check_list|(0x1<<p)
			end
		end
	end)
	Duel.RegisterEffect(e1,0)
end
