--村规决斗：神之旋风
--效果处理时，如果发动效果的卡与发动时相比已经发生了位移
--那个效果不处理。

local OrigRegister = Card.RegisterEffect
local OrigClone = Effect.Clone

CUNGUI = {}
CUNGUI.EffectSaver={}
CUNGUI.TargetSaver={}
CUNGUI.CostSaver={}

function Auxiliary.PreloadUds()
	Card.RegisterEffect = function(c,e,b)
		local typ = e:GetType()
		if (typ & 0x7d0)>0 and e:GetOperation()~=nil then
			CUNGUI.CostSaver[e] = e:GetCost()
			CUNGUI.TargetSaver[e] = e:GetTarget()
			CUNGUI.EffectSaver[e] = e:GetOperation()
			e:SetCost(CUNGUI.Cost)
			e:SetTarget(CUNGUI.Target)
			e:SetOperation(CUNGUI.Operation)
		end
		return OrigRegister(c,e,b)
	end
	Effect.Clone = function(e)
		local ce = OrigClone(e)
		if e:GetOperation() == CUNGUI.Operation then
			if CUNGUI.CostSaver[e] then ce:SetCost(CUNGUI.CostSaver[e]) end
			if CUNGUI.TargetSaver[e] then ce:SetTarget(CUNGUI.TargetSaver[e]) end
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

function CUNGUI.Cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if not CUNGUI.CostSaver[e] then return true end
	local result = CUNGUI.CostSaver[e](e,tp,eg,ep,ev,re,r,rp,chk)
	if not chk==0 then e:GetHandler():CreateEffectRelation(e) end
	return result
end

function CUNGUI.Target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if not CUNGUI.TargetSaver[e] then
		CUNGUI.TargetSaver[e] = function()
			if chkc then return false end
			return true
		end
	end
	if chkc then return CUNGUI.TargetSaver[e](e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	if chk==0 then return CUNGUI.TargetSaver[e](e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	e:GetHandler():CreateEffectRelation(e)
	return CUNGUI.TargetSaver[e](e,tp,eg,ep,ev,re,r,rp,chk,chkc)
end

function CUNGUI.Operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return nil end
	local result = CUNGUI.EffectSaver[e](e,tp,eg,ep,ev,re,r,rp)
	return result
end
