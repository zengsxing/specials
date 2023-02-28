--村规决斗：极性不定
--所有卡片原本的Cost变为效果，原本的效果变为Cost。
--所有效果的动作信息不变（即，灰流丽·星尘龙以前能无效的现在也能无效）。
CUNGUI = {}
REASON_COST = 0x40
REASON_EFFECT = 0x80
Card.IsAbleToDeckAsCost,Card.IsAbleToDeck=Card.IsAbleToDeck,Card.IsAbleToDeckAsCost
Card.IsAbleToDeckOrExtraAsCost=Card.IsAbleToDeckAsCost --实质IsAbleToDeck
Card.IsAbleToDecreaseAttackAsCost=aux.TRUE
Card.IsAbleToDecreaseDefenseAsCost=aux.TRUE
Card.IsAbleToExtraAsCost=aux.TRUE
Card.IsAbleToHand,Card.IsAbleToHandAsCost=Card.IsAbleToHandAsCost,Card.IsAbleToHand
Card.IsAbleToRemove,Card.IsAbleToRemoveAsCost=Card.IsAbleToRemoveAsCost,Card.IsAbleToRemove
Card.IsAbleToGrave,Card.IsAbleToGraveAsCost=Card.IsAbleToGraveAsCost,Card.IsAbleToGrave

local dreg=Duel.RegisterEffect
local reg=Card.RegisterEffect
Card.RegisterEffect=function(c,e,f)
	local typ = e:GetType()
	if typ and (typ & 0x7d0)==0 then
		return reg(c,e,f)
	end
	local targ = e:GetTarget()
	local cost = e:GetCost()
	local op = e:GetOperation()
	local new_cost = function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then
			if targ then return targ(e,tp,eg,ep,ev,re,r,rp,chk) end
			return true
		end
		Duel.DisableActionCheck(true)
		if targ then targ(e,tp,eg,ep,ev,re,r,rp,1) end
		if op then op(e,tp,eg,ep,ev,re,r,rp,1) end
		Duel.DisableActionCheck(false)
	end
	local new_targ = function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return targ(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
		if chk==0 then
			if cost then return cost(e,tp,eg,ep,ev,re,r,rp,chk) end
			return true
		end
	end
	local new_op = function(e,tp,eg,ep,ev,re,r,rp)
		Duel.DisableActionCheck(true)
		if cost then cost(e,tp,eg,ep,ev,re,r,rp,1) end
		Duel.DisableActionCheck(false)
	end
	e:SetCost(new_cost)
	e:SetTarget(new_targ)
	e:SetOperation(new_op)
	return reg(c,e,f)
end
Duel.RegisterEffect=function(e,tp)
	local typ = e:GetType()
	if typ and (typ & 0x7d0)==0 then
		return dreg(e,tp)
	end
	local targ = e:GetTarget()
	local cost = e:GetCost()
	local op = e:GetOperation()
	local new_cost = function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then
			if targ then return targ(e,tp,eg,ep,ev,re,r,rp,chk) end
			return true
		end
		Duel.DisableActionCheck(true)
		if targ then targ(e,tp,eg,ep,ev,re,r,rp,1) end
		if op then op(e,tp,eg,ep,ev,re,r,rp,1) end
		Duel.DisableActionCheck(false)
	end
	local new_targ = function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return targ(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
		if chk==0 then
			if cost then return cost(e,tp,eg,ep,ev,re,r,rp,chk) end
			return true
		end
	end
	local new_op = function(e,tp,eg,ep,ev,re,r,rp)
		Duel.DisableActionCheck(true)
		if cost then cost(e,tp,eg,ep,ev,re,r,rp,1) end
		Duel.DisableActionCheck(false)
	end
	e:SetCost(new_cost)
	e:SetTarget(new_targ)
	e:SetOperation(new_op)
	return dreg(e,tp)
end
function Auxiliary.PreloadUds()
end
