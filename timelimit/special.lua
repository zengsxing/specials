function Auxiliary.PreloadUds()
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e1:SetCountLimit(1)
	e1:SetOperation(function(e)
		local time=90
		local turn=Duel.GetTurnCount()
		if turn>2 then time=60 end
		if turn>4 then time=30 end
		for p=0,1 do
			Duel.ResetTimeLimit(tp,time)
		end
	end)
	Duel.RegisterEffect(e1,0)
end
