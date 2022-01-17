--村规决斗：死角奇袭
--所有起动效果从手卡也能用。
--后攻多抽1张。

local OrigRegisterEffect = Card.RegisterEffect
Card.RegisterEffect = function(c,e,forced)
	if (e:GetType() & EFFECT_TYPE_IGNITION) > 0 then
		local range = e:GetRange()
		if range and (range & LOCATION_HAND) == 0 then
			range = range | LOCATION_HAND
			e:SetRange(range)
		end
	end
	OrigRegisterEffect(c,e,forced)
end

function Auxiliary.PreloadUds()
	-- 1 more draw
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function(e)
		Duel.Draw(1,1,REASON_RULE)
		e:Reset()
	end)
	Duel.RegisterEffect(e1,0)
end