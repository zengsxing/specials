--村规决斗：汉诺之塔
--所有起动效果变为2速。
--T2多抽1张。

OrigRegister = Card.RegisterEffect
Card.RegisterEffect = function(c,e,forced)
	local typ = e:GetType()
	if typ and (typ & EFFECT_TYPE_IGNITION)>0 then
		e:SetType(EFFECT_TYPE_QUICK_O)
		e:SetCode(EVENT_FREE_CHAIN)
		local cat = e:GetCategory()
		if cat and (cat & (CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_NEGATE))>0 then
			local prop = e:GetProperty()
			if not prop then prop = 0 end
			prop = prop | (EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
			e:SetProperty(prop)
		end
	end
	return OrigRegister(c,e,forced)
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