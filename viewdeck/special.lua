function inititialize()
	--Duel.Draw(1,1,REASON_RULE)
	Duel.ConfirmCards(0,Duel.GetFieldGroup(0,0,LOCATION_EXTRA))
	Duel.ConfirmCards(1,Duel.GetFieldGroup(1,0,LOCATION_EXTRA))
	Duel.ConfirmCards(0,Duel.GetFieldGroup(0,0,LOCATION_DECK))
	Duel.ConfirmCards(1,Duel.GetFieldGroup(1,0,LOCATION_DECK))
	Duel.ShuffleDeck(0)
	Duel.ShuffleDeck(1)
	Duel.ShuffleExtra(0)
	Duel.ShuffleExtra(1)
end

function Auxiliary.PreloadUds()
	-- one more draw
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function(e)
		inititialize()
		e:Reset()
	end)
	Duel.RegisterEffect(e1,0)
end
