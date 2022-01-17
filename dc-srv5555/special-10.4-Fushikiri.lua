--村规决斗：断绝不死
--送去墓地的卡直接消失。
--被除外的卡直接消失。
-->ygopro客户端引擎不支持，废弃

CUNGUI = {}

function Auxiliary.PreloadUds()
	-- one more draw
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function(e)
		local g = Duel.GetMatchingGroup(nil,0,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil)
		Duel.Exile(g,REASON_RULE)
	end)
	Duel.RegisterEffect(e1,0)
end