--村规决斗：虹之生命
--双方受到的伤害变为回复。
--基本分在16000以上的玩家的基本分变为0。
function Auxiliary.PreloadUds()
	-- one more draw
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function(e)
		if Duel.GetLP(0)>= 16000 then Duel.SetLP(0,0) end
		if Duel.GetLP(1)>= 16000 then Duel.SetLP(1,0) end
		e:Reset()
	end)
	Duel.RegisterEffect(e1,0)
	--damage conversion
	e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_REVERSE_DAMAGE)
	e1:SetTargetRange(1,1)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,0)
end