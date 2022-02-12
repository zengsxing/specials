--村规决斗：正大光明
--双方始终公开手卡决斗。
--决斗开始时，双方互相确认对方的额外卡组和卡组。
--后攻多抽1张。
function Inititialize()
	Duel.Draw(1,1,REASON_RULE)
	Duel.ConfirmCards(0,Duel.GetFieldGroup(0,0,LOCATION_EXTRA))
	Duel.ConfirmCards(1,Duel.GetFieldGroup(1,0,LOCATION_EXTRA))
	Duel.ConfirmCards(0,Duel.GetFieldGroup(0,0,LOCATION_DECK))
	Duel.ConfirmCards(1,Duel.GetFieldGroup(1,0,LOCATION_DECK))
	Duel.ShuffleDeck(0)
	Duel.ShuffleDeck(1)
	Duel.ShuffleExtra(0)
	Duel.ShuffleExtra(1)
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_PUBLIC)
	e2:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	Duel.RegisterEffect(e2,0)
end

function Auxiliary.PreloadUds()
	-- one more draw
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function(e)
		Inititialize()
		e:Reset()
	end)
	Duel.RegisterEffect(e1,0)
end