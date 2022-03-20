--村规决斗：逆转裁判
--效果处理时，对方可以支付1000点基本分。
--那个效果处理完成后，对方以对方的视角再处理1次效果。

--细则：
--适用于任何效果，但处理后不一定有意义。
--比如旋风即使再处理一次效果，对象也不会有所改变；
--又比如天空侠虽然可以二次处理效果，但对方的卡组未必有合适的卡可拿。
local OrigRegister = Card.RegisterEffect
local OrigClone = Effect.Clone

CUNGUI = {}
CUNGUI.EffectSaver={}

function Auxiliary.PreloadUds()
	Card.RegisterEffect = function(c,e,b)
		local typ = e:GetType()
		if (typ & 0x7d0)>0 and e:GetOperation()~=nil then
			CUNGUI.EffectSaver[e] = e:GetOperation()
			e:SetOperation(CUNGUI.Operation)
		end
		return OrigRegister(c,e,b)
	end
	Effect.Clone = function(e)
		local ce = OrigClone(e)
		if e:GetOperation() == CUNGUI.Operation then
			ce:SetOperation(CUNGUI.EffectSaver[e])
		end
		return ce
	end
end

function CUNGUI.Operation(e,tp,eg,ep,ev,re,r,rp)
	local runDouble = false
	if Duel.CheckLPCost(1-tp,1000) and Duel.SelectYesNo(1-tp,aux.Stringid(57496978,0)) then
		Duel.PayLPCost(1-tp,1000)
		runDouble = true 
	end

	local result = CUNGUI.EffectSaver[e](e,tp,eg,ep,ev,re,r,rp)
	if runDouble then
		Duel.BreakEffect()
		result = CUNGUI.EffectSaver[e](e,1-tp,eg,ep,ev,re,r,rp)
	end

	return result
end
