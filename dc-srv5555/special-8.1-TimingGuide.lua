--村规决斗：时点教学
--所有场合类效果变为时类效果。
--所有必发效果变为选发效果。

local OrigRegister = Card.RegisterEffect

CUNGUI = {}

Card.RegisterEffect = function(c,e,b)
	local typ = e:GetType()
	if (typ & 0x7d0)>0 and e:GetOperation()~=nil then
		if (typ & EFFECT_TYPE_QUICK_F) > 0 then
			typ = typ - EFFECT_TYPE_QUICK_F
			typ = typ | EFFECT_TYPE_QUICK_O
		end
		if (typ & EFFECT_TYPE_TRIGGER_F) > 0 then
			typ = typ - EFFECT_TYPE_TRIGGER_F
			typ = typ | EFFECT_TYPE_TRIGGER_O
		end
		e:SetType(typ)
		local p = e:GetProperty()
		if p and (p & EFFECT_FLAG_DELAY)>0 then
			p = p - EFFECT_FLAG_DELAY
			e:SetProperty(p)
		end
	end
	return OrigRegister(c,e,b)
end

function Auxiliary.PreloadUds()
end
