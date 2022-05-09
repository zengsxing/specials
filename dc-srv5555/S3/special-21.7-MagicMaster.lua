--村规决斗：魔术大师
--所有卡得到以下效果：
--支付500点基本分才能发动。查看自己卡组最上方的卡。
--那之后，可以将那张卡加入手卡，或洗切自己的卡组。
--加入手卡的场合，自己这回合不能再发动此类效果。

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
	local g = Duel.GetMatchingGroup(Card.IsType,0,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,nil,TYPE_MONSTER)
	g:ForEach(CUNGUI.RegisterMonsterSpecialEffects)
end

function CUNGUI.RegisterMonsterSpecialEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(51351302,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(CUNGUI.cond)
	e1:SetCost(CUNGUI.cost)
	e1:SetTarget(CUNGUI.target)
	e1:SetOperation(CUNGUI.operation)
	c:RegisterEffect(e1)
end
CUNGUI.Used={}
CUNGUI.Used[0]=0
CUNGUI.Used[1]=0
function CUNGUI.cond(e,tp)
	return CUNGUI.Used[tp]<Duel.GetTurnCount()
end
function CUNGUI.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function CUNGUI.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function CUNGUI.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,1)
	if g:GetCount()~=0 then
		Duel.ConfirmCards(tp,g)
		if Duel.SelectYesNo(tp,aux.Stringid(123709,2)) then
			CUNGUI.Used[tp] = Duel.GetTurnCount()
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
		Duel.ShuffleDeck(tp)
	end
end
