--村规决斗：无限起动
--每次把卡的效果发动，发动那个效果的对方抽1张卡。
CUNGUI = {}

function Auxiliary.PreloadUds()
	--Duel Start
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e1:SetOperation(function(e)
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAINING)
		e2:SetOperation(CUNGUI.operation)
		Duel.RegisterEffect(e2,0)
		e:Reset()
	end)
	Duel.RegisterEffect(e1,0)
end
function CUNGUI.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(1-rp,1,REASON_RULE)
end