--村规决斗：等价交换
--所有卡得到以下效果：
--这个类型的效果1回合只能使用最多（回合数-1）次。
--把这张卡从手卡返回卡组，支付25%的基本分才能发动。从卡组选1张卡加入手卡。
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

CUNGUI.RegisteredMonsters = Group.CreateGroup()

function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetMatchingGroup(nil,0,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,nil)
	g:ForEach(CUNGUI.RegisterMonsterSpecialEffects)
end

function CUNGUI.RegisterMonsterSpecialEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
	
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3431737,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(CUNGUI.cost)
	e1:SetTarget(CUNGUI.target)
	e1:SetOperation(CUNGUI.operation)
	c:RegisterEffect(e1)
end
CUNGUI.LastUsedTurn = {}
CUNGUI.LastUsedNum = {}
CUNGUI.LastUsedTurn[0] = 0
CUNGUI.LastUsedTurn[1] = 0
CUNGUI.LastUsedNum[0] = 0
CUNGUI.LastUsedNum[1] = 0
function CUNGUI.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local now=Duel.GetTurnCount()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c, nil, 2, REASON_COST)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/4))
end
function CUNGUI.filter(c)
	return c:IsAbleToHand()
end
function CUNGUI.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local now=Duel.GetTurnCount()-1
	if chk==0 then return
		Duel.IsExistingMatchingCard(CUNGUI.filter,tp,LOCATION_DECK,0,1,nil)
		and (now>CUNGUI.LastUsedTurn[tp] or CUNGUI.LastUsedNum[tp]<CUNGUI.LastUsedTurn[tp]-1) end
	local now=Duel.GetTurnCount()
	if CUNGUI.LastUsedTurn[tp] ~= now then
		CUNGUI.LastUsedTurn[tp]=now
		CUNGUI.LastUsedNum[tp]=0
	end
	CUNGUI.LastUsedNum[tp] = CUNGUI.LastUsedNum[tp] + 1
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function CUNGUI.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,CUNGUI.filter,tp,LOCATION_DECK,0,1,1,nil)
	if tc then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT) > 0 then
			Duel.ConfirmCards(1-tp,tc)
		end
	end
end
