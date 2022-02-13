--村规决斗：三生三世
--双方没有手卡限制。
--作为通常抽卡的代替：
--回合玩家将手卡送去墓地
--那些卡以外的墓地的卡返回卡组
--那些回到卡组的卡以外的卡组的卡加入手卡

CUNGUI = {}

function Auxiliary.PreloadUds()
	--search
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetCondition(CUNGUI.ReplaceDrawCond)
	e2:SetTarget(CUNGUI.ReplaceDrawTarg)
	e2:SetOperation(CUNGUI.ReplaceDrawOp)
	Duel.RegisterEffect(e2,0)
	--search
	e2=e2:Clone()
	Duel.RegisterEffect(e2,1)
	--Hand Limit
	local e3=Effect.GlobalEffect()
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_HAND_LIMIT)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetValue(100)
	Duel.RegisterEffect(e3,0)
end
function CUNGUI.ReplaceDrawCond(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetDrawCount(tp)>0
end
function CUNGUI.ReplaceDrawTarg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		aux.DrawReplaceCount=0
		aux.DrawReplaceMax=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
end
function CUNGUI.ReplaceDrawOp(e,tp,eg,ep,ev,re,r,rp)
	aux.DrawReplaceCount=aux.DrawReplaceCount+1
	if aux.DrawReplaceCount>aux.DrawReplaceMax then return end
	local deck=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local hand=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local grave=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	if #deck > 0 then Duel.SendtoHand(deck, nil, REASON_RULE) end
	if #hand > 0 then Duel.SendtoGrave(hand, REASON_RULE) end
	if #grave > 0 then Duel.SendtoDeck(grave, nil, 2,REASON_RULE) end
end


