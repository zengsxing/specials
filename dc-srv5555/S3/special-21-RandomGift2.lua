--村规决斗：随机附赠2
--入连锁的效果处理的场合，
--那个效果处理后，随机选1张自己目前控制的卡的效果中
--1个当前可处理的效果的发动时的代价和效果，进行处理。
--（如果没有任何卡可以处理则不处理）

CUNGUI = {}
CUNGUI.NoFunc = {}
CUNGUI.Success=false

function CUNGUI.TestEffect(te,e,tp,eg,ep,ev,re,r,rp)
	local cod = e:GetCode()
	local cond = te:GetCondition()
	local cost = te:GetCost()
	local targ = te:GetTarget()
	local op = te:GetOperation()
	if  (not cost or cost(e,tp,eg,ep,ev,re,r,rp,0)) and
		(not targ or targ(e,tp,eg,ep,ev,re,r,rp,0)) then
		return true end
	local err = CUNGUI.None[111]
	return CUNGUI.None[111]
end

local SelectTarget = Duel.SelectTarget
CUNGUI.Target=nil
Duel.SelectTarget = function(...)
	local g=SelectTarget(...)
	CUNGUI.Target=g
	g:KeepAlive()
	return g
end

local GetFirstTarget = Duel.GetFirstTarget
Duel.GetFirstTarget = function(b)
	if GetFirstTarget() then return GetFirstTarget() end
	if not CUNGUI.Target then return nil end
	return CUNGUI.Target:GetFirst()
end

function CUNGUI.filter(c,e,tp,eg,ep,ev,re,r,rp)
	if not CUNGUI.EffectSaver[c] then return false end
	for k,te in pairs(CUNGUI.EffectSaver[c]) do
		local success,err = pcall(CUNGUI.TestEffect,te,e,tp,eg,ep,ev,re,r,rp)
		if success then return err end
	end
	return false
end

function CUNGUI.GetEffect(c,e,tp,eg,ep,ev,re,r,rp)
	local es={}
	for k,te in pairs(CUNGUI.EffectSaver[c]) do
		local success,_ = pcall(CUNGUI.TestEffect,te,e,tp,eg,ep,ev,re,r,rp)
		if success then
			table.insert(es,te)
		end
	end
	if #es==0 then return nil end
	return es[math.random(#es)]
end

CUNGUI.EffectSaver={}

local RegisterEffect = Card.RegisterEffect
Card.RegisterEffect = function(c,e,forced)
	if not CUNGUI.EffectSaver[c] then CUNGUI.EffectSaver[c]={} end
	local typ = e:GetType()
	local op = e:GetOperation()
	if typ and (typ & 0x7d0)>0 and op then
		table.insert(CUNGUI.EffectSaver[c],e)
		Effect.SetOperationEx(e,e:GetOperation())
	end
	return RegisterEffect(c,e,forced)
end

Effect.SetOperationEx = function(e,func)
	local typ = e:GetType()
	if typ and (typ & 0x7d0)==0 then
		Effect.SetOperation(e,func)
		return
	end
	Effect.SetOperation(e,function(e,tp,eg,ep,ev,re,r,rp)
		if func then
			func(e,tp,eg,ep,ev,re,r,rp)
		else
			CUNGUI.NoFunc[e]=true
		end
		local atyp = e:GetActiveType()
		if not CUNGUI.Lock then
			local g=Duel.GetMatchingGroup(CUNGUI.filter,tp,0xff,0xff,nil,e,tp,eg,ep,ev,re,r,rp)
			if #g>0 then
				CUNGUI.Lock=true
				local tc=g:RandomSelect(tp,1):GetFirst()
				local tcc=tc:GetOriginalCode()
				Duel.Hint(HINT_CARD,tp,tcc)
				Duel.Hint(HINT_CODE,tp,tcc)
				Duel.Hint(HINT_CODE,1-tp,tcc)
				local te=CUNGUI.GetEffect(tc,e,tp,eg,ep,ev,re,r,rp)
				if te==nil then
					CUNGUI.Lock=false
					return
				end
				local desc = te:GetDescription()
				if not desc or desc==0 then desc = 7 end
				Duel.Hint(HINT_OPSELECTED,tp,desc)
				local cost = te:GetCost()
				local target = te:GetTarget()
				local operation = te:GetOperation()
				Duel.ClearTargetCard()
				local prop = e:GetProperty()
				e:SetProperty(te:GetProperty())
				e:GetHandler():CreateEffectRelation(e)
				if cost then pcall(cost,e,tp,eg,ep,ev,re,r,rp,1) end
				if target then pcall(target,e,tp,eg,ep,ev,re,r,rp,1) end
				
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
				if g then
					local fc=g:GetFirst()
					while fc do
						fc:CreateEffectRelation(e)
						fc=g:GetNext()
					end
				end
				if operation then pcall(operation,e,tp,eg,ep,ev,re,r,rp) end
				if g then
					fc=g:GetFirst()
					while fc do
						fc:ReleaseEffectRelation(e)
						fc=g:GetNext()
					end
				end
				e:SetProperty(prop)
			end
		end
	end)
end

function CUNGUI.reset()
	CUNGUI.Lock=false
end

function Auxiliary.PreloadUds()
	local e4=Effect.GlobalEffect()
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetOperation(CUNGUI.reset)
	Duel.RegisterEffect(e4,0)
end
