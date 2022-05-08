--村规决斗：随机附赠
--所有怪兽得到以下效果：
--这张卡的效果处理的场合，
--那个效果处理后，随机选1张自己目前控制的卡中
--1张当前可处理的魔法陷阱卡的发动时的代价和效果，进行处理。
--（如果没有任何卡可以处理则不处理）

CUNGUI = {}
CUNGUI.Lock = {}
CUNGUI.NoFunc = {}

function CUNGUI.filter(c,e,tp,eg,ep,ev,re,r,rp)
	local te=c:GetActivateEffect()
	if not te then return false end
	local cond = te:GetCondition()
	local cost = te:GetCost()
	local targ = te:GetTarget()
	return (te:GetCode()==EVENT_FREE_CHAIN or te:GetType()==EFFECT_TYPE_IGNITION) and
		(c:GetOriginalType() & (TYPE_MONSTER+TYPE_CONTINUOUS+TYPE_FIELD+TYPE_EQUIP))==0 and
		(not cost or cost(e,tp,eg,ep,ev,re,r,rp,0)) and
		(not targ or targ(e,tp,eg,ep,ev,re,r,rp,0)) and
		not CUNGUI.NoFunc[e]
end

local SetOperation = Effect.SetOperation
Effect.SetOperation = function(e,func)
	local typ = e:GetType()
	if typ and (typ & 0x7d0)==0 then
		SetOperation(e,func)
		return
	end
	SetOperation(e,function(e,tp,eg,ep,ev,re,r,rp)
		if func then
			func(e,tp,eg,ep,ev,re,r,rp)
		else
			CUNGUI.NoFunc[e]=true
		end
		local atyp = e:GetActiveType()
		if not CUNGUI.Lock[e] and atyp and (atyp & TYPE_MONSTER)>0 then
			local g=Duel.GetMatchingGroup(CUNGUI.filter,tp,0xff,0,nil,e,tp,eg,ep,ev,re,r,rp)
			if #g>0 then
				CUNGUI.Lock[e]=true
				local tc=g:RandomSelect(tp,1):GetFirst()
				Duel.Hint(HINT_CARD,tp,tc:GetOriginalCode())
				Duel.Hint(HINT_CODE,tp,tc:GetOriginalCode())
				local te=tc:GetActivateEffect()
				local cond = te:GetCondition()
				local cost = te:GetCost()
				local target = te:GetTarget()
				local operation = te:GetOperation()
				Duel.ClearTargetCard()
				e:SetProperty(te:GetProperty())
				e:GetHandler():CreateEffectRelation(te)
				if cost then cost(te,tp,eg,ep,ev,re,r,rp,1) end
				if target then target(te,tp,eg,ep,ev,re,r,rp,1) end
				
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
				if g then
					local fc=g:GetFirst()
					while fc do
						fc:CreateEffectRelation(te)
						fc=g:GetNext()
					end
				end
				if operation then operation(te,tp,eg,ep,ev,re,r,rp) end
				if g then
					fc=g:GetFirst()
					while fc do
						fc:ReleaseEffectRelation(te)
						fc=g:GetNext()
					end
				end
				CUNGUI.Lock[e]=false
			end
		end
	end)
end

function Auxiliary.PreloadUds()
end
