--村规决斗：拼多多多
--要支付Cost时，投1个骰子。
--不是1或6的场合，无需支付。
--是1或6的场合，需要支付2次。第2次支付失败的场合，发动无效。

local OrigRegister = Card.RegisterEffect

CUNGUI = {}

Card.RegisterEffect = function(c,e,b)
	local f=e:GetCost()
	if f then
		e:SetCost(CUNGUI.CreateFunction(f))
	end
	return OrigRegister(c,e,b)
end

function Auxiliary.PreloadUds()
end

function CUNGUI.CreateFunction(f)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return true end
		local dice = Duel.TossDice(tp,1)
		if dice==1 or dice==6 then
			f(e,tp,eg,ep,ev,re,r,rp)
			if not f(e,tp,eg,ep,ev,re,r,rp,0) then
				Duel.NegateActivation(0)
				return false
			else
				f(e,tp,eg,ep,ev,re,r,rp,chk)
				return true
			end
		else
			return true
		end
	end
end