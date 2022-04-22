--村规决斗：神陆零式
--双方场上的怪兽攻击力上升对方基本分一半的数值（向下取整）。

CUNGUI = {}

function CUNGUI.Init()
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(CUNGUI.val)
	Duel.RegisterEffect(e1,0)
end

function CUNGUI.filter(c,race)
	return c:IsFaceup() and c:IsRace(race)
end

function CUNGUI.val(e,c)
	return math.floor(Duel.GetLP(1-c:GetControler()) / 2)
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