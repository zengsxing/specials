--村规决斗：稳步慢行
--双方抽卡阶段的通常抽卡数量，变成直到让自己场上+手卡的卡的数量达到（5+回合数）为止。
--抽卡量最少为1。

CUNGUI={}

function Auxiliary.PreloadUds()
	--Draw
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetValue(CUNGUI.DrawCount)
	Duel.RegisterEffect(e2,0)
end
CUNGUI.Used=0
function CUNGUI.DrawCount(e)
	local p=Duel.GetTurnPlayer()
	local ct=Duel.GetTurnCount()+5-Duel.GetFieldGroupCount(p,LOCATION_HAND+LOCATION_ONFIELD,0)
	if ct<=0 then ct=1 end
	return ct
end