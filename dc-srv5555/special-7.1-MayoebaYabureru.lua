--村规决斗：犹豫败北
--每个回合不再限制总时间，但每一步行动都只有10秒钟的时间。
CUNGUI = {}
function Auxiliary.PreloadUds()
	CUNGUI.AnnouceCardOrig = Duel.AnnounceCard
	Duel.AnnounceCard = function(player,...)
		local time = 10
		if Duel.GetTurnCount() < 3 then time = 20 end
		Duel.ResetTimeLimit(player,30)
		CUNGUI.AnnouceCardOrig(player,...)
		Duel.ResetTimeLimit(player,time)
	end
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function(e)
		local time = 10
		if Duel.GetTurnCount() < 3 then time = 20 end
		for p=0,1 do
			Duel.ResetTimeLimit(p,time)
		end
	end)
	Duel.RegisterEffect(e1,0)
end