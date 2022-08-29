--村规决斗：我的回合
--怪兽效果在对方的回合无效化。

CUNGUI = {}
CUNGUI.RuleCardCode=3285551

function Auxiliary.PreloadUds()
	--disable
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(0x7f,0x7f)
	e2:SetTarget(CUNGUI.disable)
	Duel.RegisterEffect(e2,0)
end
function CUNGUI.disable(e,c)
	return (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT) and c:IsControler(1-Duel.GetTurnPlayer())
end
