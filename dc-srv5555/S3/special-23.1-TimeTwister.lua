--村规决斗：时空乱流
--每个回合的时长随机变化为30~300秒。
--（双方分别有一个随机的时间限制）

CUNGUI = {}

function Auxiliary.PreloadUds()
	if not CUNGUI.InitRandomSeed then
		CUNGUI.InitRandomSeed = true
		math.random = Duel.GetRandomNumber
	end
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetOperation(CUNGUI.AdjustOperation)
	Duel.RegisterEffect(e1,0)
end

function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
	local tm = math.random(30,300)
	Duel.Hint(HINT_NUMBER,tp,tm)
	Duel.ResetTimeLimit(0,tm)
	tm = math.random(30,300)
	Duel.ResetTimeLimit(1,tm)
	Duel.Hint(HINT_NUMBER,1,tm)
end
