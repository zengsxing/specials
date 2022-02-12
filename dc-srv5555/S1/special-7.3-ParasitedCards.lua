--村规决斗：寄生宝札
--怪兽被战斗破坏的场合，双方从卡组抽1张。
CUNGUI = {}
function Auxiliary.PreloadUds()
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(CUNGUI.AdjustOperation)
	Duel.RegisterEffect(e1,0)
end

function CUNGUI.AdjustOperation(e)
	local e3=Effect.GlobalEffect()
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetOperation(CUNGUI.drop)
	Duel.RegisterEffect(e3,0)
	e:Reset()
end

function CUNGUI.drop(e,tp,eg,ep,ev,re,r,rp)
	local tp = Duel.GetTurnPlayer()
	Duel.Draw(tp,1,REASON_RULE)
	Duel.Draw(1-tp,1,REASON_RULE)
end
