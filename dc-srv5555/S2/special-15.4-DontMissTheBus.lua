--村规决斗：莫误班车
--所有选发效果变为必发效果。

local OrigRegister = Card.RegisterEffect

CUNGUI = {}

Card.RegisterEffect = function(c,e,b)
	local typ = e:GetType()
	if (typ & 0x7d0)>0 and e:GetOperation()~=nil then
		if (typ & EFFECT_TYPE_QUICK_O) > 0 then
			typ = typ - EFFECT_TYPE_QUICK_O
			typ = typ | EFFECT_TYPE_QUICK_F
		end
		if (typ & EFFECT_TYPE_TRIGGER_O) > 0 then
			typ = typ - EFFECT_TYPE_TRIGGER_O
			typ = typ | EFFECT_TYPE_TRIGGER_F
		end
		e:SetType(typ)
		local p = e:GetProperty() or 0
		p = p | EFFECT_FLAG_DELAY
		e:SetProperty(p)
	end
	return OrigRegister(c,e,b)
end

function Auxiliary.PreloadUds()
end
