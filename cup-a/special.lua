function Auxiliary.PreloadUds()
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetOperation(function(e)
		Duel.Hint(HINT_CARD,0,37812118)
		local tp=Duel.GetTurnPlayer()
		local res1=Duel.TossCoin(tp,1)
		local drawCounts={[0]=0,[1]=0}
		if res1==1 then drawCounts[tp]=drawCounts[tp]+2 else drawCounts[1-tp]=drawCounts[1-tp]+2 end
		if drawCounts[tp]>0 then Duel.Draw(tp,drawCounts[tp],REASON_EFFECT) end
		if drawCounts[1-tp]>0 then Duel.Draw(1-tp,drawCounts[1-tp],REASON_EFFECT) end
	end)
	Duel.RegisterEffect(e1,0)
end
