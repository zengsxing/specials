--村规决斗：背水一战
--自己场上的怪兽攻击力上升
--（8000-自己基本分）/2的数值（向下取整）。

--细则：基本分大于8000的场合，攻击力不会下降。

CUNGUI = {}

function CUNGUI.Init()
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(CUNGUI.val)
	Duel.RegisterEffect(e1,0)
end

function CUNGUI.val(e,c)
	local val = math.floor((8000-Duel.GetLP(c:GetControler())) / 2)
	if val < 0 then val = 0 end
	return val
end

function Auxiliary.PreloadUds()
	-- one more draw
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function(e)
		CUNGUI.Init()
		e:Reset()
	end)
	Duel.RegisterEffect(e1,0)
end