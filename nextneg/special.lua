function Auxiliary.PreloadUds()
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return ep==tp
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=re:GetHandler()
		Duel.SetChainLimit(function(re,ep,tp)
			return tp==ep
		end)
		for _,code in pairs({EFFECT_CANNOT_DISABLE, EFFECT_CANNOT_INACTIVATE, EFFECT_CANNOT_DISEFFECT}) do
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(code)
			e2:SetReset(RESET_CHAIN+RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(1)
			c:RegisterEffect(e2)
		end
		e:Reset()
	end)
	Duel.RegisterEffect(e1,1)
end
