local targetCodes={
	10000020,
	99267150,
	37542782,
	55410871,
	21123811,
	98630720,
}

function Auxiliary.PreloadUds()
	-- summon
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(function()
		local tp=Duel.GetTurnPlayer()
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end)
	e1:SetOperation(function()
		local tp=Duel.GetTurnPlayer()
		local diceResult=Duel.TossDice(tp,1)
		local code=0
		if diceResult~=6 then
			code=32274490
		else
			Duel.Hint(HINT_CARD,tp,31305911)
			diceResult=Duel.TossDice(tp,1)
			code=targetCodes[diceResult]
		end
		local token=Duel.CreateToken(tp,code)
		Duel.MoveToField(token,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
	end)
	Duel.RegisterEffect(e1,0)

	-- forbidden
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE_START+PHASE_MAIN1)
	e2:SetCountLimit(1)
	e2:SetOperation(function()
		local tp=Duel.GetTurnPlayer()
		Duel.Hint(HINT_CARD,tp,43711255)
		local code=Duel.AnnounceCard(tp)
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCode(EFFECT_FORBIDDEN)
		e2:SetTargetRange(0xff,0xff)
		e2:SetTarget(function(e,c)
			return c:IsOriginalCodeRule(code)
		end)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end)
	Duel.RegisterEffect(e2,0)
end
