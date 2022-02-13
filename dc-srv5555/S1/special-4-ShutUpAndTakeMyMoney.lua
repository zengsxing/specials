--村规决斗：拿钱说话
--怪兽召唤·特殊召唤时，使其上场的玩家
--选1张手卡·墓地的卡里侧表示除外
--双方每个抽卡阶段的通常抽卡的数量，
--都比上个对方回合多1张
CUNGUI = {}

function Auxiliary.PreloadUds()
	--Duel Start
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(CUNGUI.Operation)
	Duel.RegisterEffect(e1,0)
	local ex = e1:Clone()
	ex:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(ex,0)
	--Draw
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetValue(CUNGUI.DrawCount)
	Duel.RegisterEffect(e2,0)
end

function CUNGUI.Operation(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.SelectMatchingCard(rp, nil, rp, LOCATION_HAND+LOCATION_GRAVE, 0, 1, 1,  nil)
	if g then
		Duel.Remove(g, POS_FACEDOWN, REASON_RULE)
	end
end
function CUNGUI.DrawCount(e)
	return Duel.GetTurnCount()
end
