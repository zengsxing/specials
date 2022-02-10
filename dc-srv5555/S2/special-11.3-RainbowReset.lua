--村规决斗：虹色重启
--所有陷阱卡得到以下效果：
--这张卡也能支付一半基本分，抽2张卡并从手卡发动。

--细则：类似【红色重启】的卡仍要支付这个基本分。
--结局相当于支付3/4的基本分发动。

CUNGUI = {}

function Auxiliary.PreloadUds()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetOperation(CUNGUI.AdjustOperation)
	Duel.RegisterEffect(e1,0)
end

CUNGUI.Registered = Group.CreateGroup()
CUNGUI.CostSaver = {}
local OrigClone = Effect.Clone
local OrigRegisterEffect = Card.RegisterEffect

Card.RegisterEffect = function(c,e)
	local cost = e:GetCost()
	local typ = e:GetType()
	if typ and (typ & EFFECT_TYPE_ACTIVATE)>0 then
		e:SetCost(CUNGUI.cost)
		CUNGUI.CostSaver[e] = cost
	end
	OrigRegisterEffect(c,e)
end

Effect.Clone = function(e)
	local ce = OrigClone(e)
	local typ = e:GetType()
	if e:GetCost() == CUNGUI.cost then
		ce:SetCost(CUNGUI.CostSaver[e])
	end
	return ce
end

function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetMatchingGroup(Card.IsType,0,LOCATION_DECK+LOCATION_HAND,LOCATION_DECK+LOCATION_HAND,nil,TYPE_TRAP)
	g:ForEach(CUNGUI.RegisterSpecialEffects)
end

function CUNGUI.RegisterSpecialEffects(c)
	if CUNGUI.Registered:IsContains(c) then return end
	CUNGUI.Registered:AddCard(c)
    --act in hand
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
    OrigRegisterEffect(c,e2)
end

function CUNGUI.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local origCost = CUNGUI.CostSaver[e]
    if chk==0 then return origCost == nil or origCost(e,tp,eg,ep,ev,re,r,rp,chk) end
    if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) and e:GetHandler():IsType(TYPE_TRAP) then
		Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
		Duel.Draw(tp,2,REASON_COST)
    end
	if origCost ~= nil then return origCost(e,tp,eg,ep,ev,re,r,rp,chk) end
end
