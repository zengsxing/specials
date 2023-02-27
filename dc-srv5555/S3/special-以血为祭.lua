--村规决斗：以血为祭
--所有卡片原本的Cost变为【支付200点基本分才能发动】。
--为没有Cost的效果添加以上Cost。
CUNGUI = {}

local reg=Card.RegisterEffect
Card.RegisterEffect=function(c,e,f)
	local new_cost = function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.CheckLPCost(tp,200) end
		Duel.DisableActionCheck(true)
		Duel.PayLPCost(tp,200)
		Duel.DisableActionCheck(false)
	end
	e:SetCost(new_cost)
	return reg(c,e,f)
end
function Auxiliary.PreloadUds()
end
