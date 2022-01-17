--村规决斗：永不卡手
--结束阶段开始时，回合玩家选手上·场上一半以下（向下取整）的卡回卡组洗切（至少1）
--那些卡返回卡组，再随机取相同数量的手上·场上的卡回卡组洗切
--然后抽与那个总数量相同数量的卡
CUNGUI = {}
CUNGUI.EndPhaseEffects = {}

function CUNGUI.B2S(b)
	if b then return "TRUE" end
	return "FALSE"
end

function CUNGUI.CheckGroup(g)
	return g:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD)
end

function Auxiliary.PreloadUds()
	--Duel Start
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(CUNGUI.Operation)
	Duel.RegisterEffect(e1,0)
end

function CUNGUI.Operation(e,tp,eg,ep,ev,re,r,rp)
	local p = Duel.GetTurnPlayer()
	local g = Duel.GetMatchingGroup(Card.IsAbleToDeck, p, LOCATION_HAND+LOCATION_ONFIELD, 0, nil)
	local max = math.floor(#g / 2)
	if max == 0 then return end
	local g2
	while not g2 do
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD) then
			g2 = g:SelectSubGroup(p, CUNGUI.CheckGroup, true, 1, max)
		else
			g2 = g:SelectSubGroup(p, aux.TRUE, true, 1, max)
		end
	end
	g:Sub(g2)
	g = g:RandomSelect(p, #g2)
	g2:Merge(g)
	Duel.SendtoDeck(g2, nil, 2, REASON_RULE)
	Duel.ShuffleDeck(p)
	Duel.Draw(p, #g2, REASON_RULE)
end