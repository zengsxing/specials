--村规决斗：巅峰出道
--所有其他诱发效果的触发时点都变为【有怪兽（包括自己）召唤·反转召唤·特殊召唤成功时】。
--如果原本就是这三个时点触发的效果，则没有变化。
--会直接导致一部分对触发时点有所依赖的效果无法发动或处理。

local OrigRegister = Card.RegisterEffect

CUNGUI = {}
CUNGUI.Registered={}

Card.RegisterEffect = function(c,e,b)
	local typ = e:GetType()
	if not CUNGUI.Registered[e] and (typ & (EFFECT_TYPE_TRIGGER_O + EFFECT_TYPE_TRIGGER_F))>0 and e:GetOperation()~=nil then
		local code = e:GetCode()
		if code and code~=EVENT_SUMMON_SUCCESS and code~=EVENT_SPSUMMON_SUCCESS and code~=EVENT_FLIP_SUMMON_SUCCESS then
			CUNGUI.Registered[e]=true
			e:SetCondition(aux.TRUE)
			e:SetCode(EVENT_SUMMON_SUCCESS)
			e:SetRange(LOCATION_ONFIELD)
			local prop = e:GetProperty() or 0
			prop = prop | EFFECT_FLAG_DELAY
			e:SetProperty(prop)
			if (typ | EFFECT_TYPE_SINGLE) > 0 then
				typ = typ - EFFECT_TYPE_SINGLE
				typ = typ | EFFECT_TYPE_FIELD
			end
			if (typ | EFFECT_TYPE_ACTIONS)>0 then
				typ = typ - EFFECT_TYPE_ACTIONS
			end
			e:SetType(typ)
			local xe=e:Clone()
			xe:SetCode(EVENT_SPSUMMON_SUCCESS)
			OrigRegister(c,xe)
			local xe2=e:Clone()
			xe2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
			OrigRegister(c,xe2)
			local xe3=e:Clone()
			typ=xe3:GetType()
			if (typ & EFFECT_TYPE_FIELD)>0 then
				if (typ | EFFECT_TYPE_ACTIONS)>0 then
					typ = typ - EFFECT_TYPE_ACTIONS
				end
				typ = typ - EFFECT_TYPE_FIELD
				typ = typ | EFFECT_TYPE_SINGLE
			end
			xe3:SetType(typ)
			OrigRegister(c,xe3)
			local xe4=xe2:Clone()
			typ=xe4:GetType()
			if (typ & EFFECT_TYPE_FIELD)>0 then
				if (typ | EFFECT_TYPE_ACTIONS)>0 then
					typ = typ - EFFECT_TYPE_ACTIONS
				end
				typ = typ - EFFECT_TYPE_FIELD
				typ = typ | EFFECT_TYPE_SINGLE
			end
			xe4:SetType(typ)
			OrigRegister(c,xe4)
			local xe5=xe:Clone()
			typ=xe5:GetType()
			if (typ & EFFECT_TYPE_FIELD)>0 then
				if (typ | EFFECT_TYPE_ACTIONS)>0 then
					typ = typ - EFFECT_TYPE_ACTIONS
				end
				typ = typ - EFFECT_TYPE_FIELD
				typ = typ | EFFECT_TYPE_SINGLE
			end
			xe5:SetType(typ)
			OrigRegister(c,xe5)
		end
	end
	return OrigRegister(c,e,b)
end

function Auxiliary.PreloadUds()
end
