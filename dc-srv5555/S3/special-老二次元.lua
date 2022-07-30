--村规决斗：老二次元
--入连锁的效果处理时，投一个骰子。
--1、2：以对方视角把效果处理2次。
--3、4：处理1次，再以对方视角处理1次。
--5、6：效果处理2次。

--细则：
--对任何效果有效，但处理后不一定有意义。
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
	local dice = math.random(1,6)
	if dice < 3 then
		CUNGUI.EffectSaver[e](e,1-tp,eg,ep,ev,re,r,rp)
		CUNGUI.EffectSaver[e](e,1-tp,eg,ep,ev,re,r,rp)
	elseif dice < 5 then
		CUNGUI.EffectSaver[e](e,tp,eg,ep,ev,re,r,rp)
		CUNGUI.EffectSaver[e](e,1-tp,eg,ep,ev,re,r,rp)
	else
		CUNGUI.EffectSaver[e](e,tp,eg,ep,ev,re,r,rp)
		CUNGUI.EffectSaver[e](e,tp,eg,ep,ev,re,r,rp)
	end
end
