--村规决斗：挣脱枷锁 Extra
--所有入连锁的效果的发动条件无效，
--可以空发，并尽量处理Cost和效果。
--
function GetFunc(func)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		local err,c = pcall(func,e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return c end
		return true
	end
end
local Register = Card.RegisterEffect

Card.RegisterEffect = function(c,e,forced)
	local type=e:GetType()
	local cost=e:GetCost()
	local cond=e:GetCondition()
	local targ=e:GetTarget()
	if (type & 0x7d0) > 0 then 
		if cond then e:SetCondition(GetFunc(cond)) end
		if cost then e:SetCost(GetFunc(cost)) end
		if targ then e:SetTarget(GetFunc(targ)) end
	end
	return Register(c,e,forced)
end