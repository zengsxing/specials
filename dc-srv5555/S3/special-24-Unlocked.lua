--村规决斗：挣脱枷锁II
--所有效果的发动·使用条件无效。
local SetCond=Effect.SetCondition
function GetFunc(func)
	return function(e,tp,eg,ep,ev,re,r,rp)
		func(e,tp,eg,ep,ev,re,r,rp)
		return true
	end
end
Effect.SetCondition = function(e,func)
	if func==nil then return end
	if e:GetCode()==EFFECT_FUSION_MATERIAL then
		SetCond(e,func)
	else
		SetCond(e,GetFunc(func))
	end
end
