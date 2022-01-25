--村规决斗：坟头蹦迪
--起动效果·永续效果以外的效果，
--在场上·墓地·被除外状态下均能触发和适用。
--后攻开局时多抽2张。
local OrigRegisterEffect = Card.RegisterEffect

function Auxiliary.PreloadUds()
	Card.RegisterEffect = function(c,e,forced)
		if (e:GetType() & EFFECT_TYPE_CONTINUOUS)==0 and e:GetRange()>0 then
			e:SetRange(e:GetRange() | LOCATION_GRAVE | LOCATION_REMOVED | LOCATION_ONFIELD)
		end
		OrigRegisterEffect(c,e,forced)
	end
	-- 1 more draw
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function(e)
		Duel.Draw(1,2,REASON_RULE)
		e:Reset()
	end)
	Duel.RegisterEffect(e1,0)
end