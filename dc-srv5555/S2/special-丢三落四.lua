--村规决斗：丢三落四
--任何效果进行处理时，
--从自己卡组最上方将1张卡送去墓地。

CUNGUI = {}

local OrigSO = Effect.SetOperation

Effect.SetOperation = function(e,func)
	local typ = e:GetType()
	if not typ or (typ & 0x7d0)==0 then
		if func then return func(e,tp,eg,ep,ev,re,r,rp) end
		return
	end
	OrigSO(e,function (e,tp,eg,ep,ev,re,r,rp)
		Duel.DiscardDeck(tp,1,REASON_EFFECT)
		if func then return func(e,tp,eg,ep,ev,re,r,rp) end
	end)
end

function Auxiliary.PreloadUds()
	
end
