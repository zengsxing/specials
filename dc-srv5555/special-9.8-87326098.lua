--村规决斗：87326098
--所有上场的怪兽消失并变成同表示形式的【青眼白龙】。

CUNGUI = {}

function Inititialize()
	local g = Duel.GetMatchingGroup(CUNGUI.gfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		local pos = tc:GetPosition()
		local tp = tc:GetControler()
		Duel.Exile(tc,REASON_RULE)
		local c = Duel.CreateToken(0,89631139)
		Duel.MoveToField(c,tp,tp,LOCATION_MZONE,pos,true)
	end
end

function CUNGUI.gfilter(c)
	return not c:IsCode(89631139)
end

function Auxiliary.PreloadUds()
	-- one more draw
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function(e)
		Inititialize()
	end)
	Duel.RegisterEffect(e1,0)
end