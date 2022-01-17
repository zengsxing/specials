--村规决斗：双生视界
--效果处理时，可以支付1000点基本分。
--那个效果处理完成后，再处理1次效果。

--细则：
--可以对任何效果发动，但处理后不一定有意义。
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
	-- 1 more draw
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function(e)
		Duel.Draw(1,1,REASON_RULE)
		e:Reset()
	end)
	Duel.RegisterEffect(e1,0)
end

function CUNGUI.Operation(e,tp,eg,ep,ev,re,r,rp)
	local runDouble = false
	if Duel.CheckLPCost(tp,1000) and Duel.SelectYesNo(tp,aux.Stringid(57496978,0)) then
		Duel.PayLPCost(tp,1000)
		runDouble = true 
	end

	local result = CUNGUI.EffectSaver[e](e,tp,eg,ep,ev,re,r,rp)
	if runDouble then
		Duel.BreakEffect()
		result = CUNGUI.EffectSaver[e](e,tp,eg,ep,ev,re,r,rp)
	end

	return result
end
