--村规决斗：强制平衡
--双方抽卡阶段抽卡数量，变成双方场上+手卡数量之差。
--连续4个回合未能抽卡的场合，第4个回合的回合玩家的基本分变为0。
--（自己比对方多也会多抽卡）
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
	local ct=Duel.GetFieldGroupCount(p,LOCATION_HAND+LOCATION_ONFIELD,0)
	local ct2=Duel.GetFieldGroupCount(1-p,LOCATION_HAND+LOCATION_ONFIELD,0)-ct
	if ct2<0 then ct2=-ct2 end
	if ct2==0 then
		CUNGUI.Used = CUNGUI.Used + 1
	else
		CUNGUI.Used = 0
	end
	if CUNGUI.Used > 3 then
		Duel.SetLP(p,0)
	end
	return ct2
end