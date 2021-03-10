--天変地異
function inititialize()
	Duel.Draw(1,1,REASON_RULE)
end

function Auxiliary.PreloadUds()
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_REVERSE_DECK)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	Duel.RegisterEffect(e2,0)
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
