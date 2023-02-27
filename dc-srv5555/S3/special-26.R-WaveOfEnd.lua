--村规决斗：终末波纹
--所有起动效果、自由时点的诱发即时效果，
--变为结束阶段可以处理的效果。
CUNGUI = {}

local reg=Card.RegisterEffect
Card.RegisterEffect=function(c,e,f)
	local typ = e:GetType()
	local cod = e:GetCode()
	if typ == EFFECT_TYPE_IGNITION or (typ == EFFECT_TYPE_QUICK_O and cod==EVENT_FREE_CHAIN) then
		e:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e:SetCode(EVENT_PHASE+PHASE_END)
	end
	return reg(c,e,f)
end
function Auxiliary.PreloadUds()
end
