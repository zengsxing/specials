--村规决斗：连锁指名
--每当一个效果发动，将那个卡名的卡从那个玩家的卡组·手卡全部破坏。
CUNGUI = {}

function Auxiliary.PreloadUds()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(CUNGUI.AdjustOperation)
	Duel.RegisterEffect(e1,0)
end

function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(CUNGUI.operation)
	Duel.RegisterEffect(e1,0)
	e:Reset()
end

function CUNGUI.operation(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler():GetCode()
	tp = re:GetHandler():GetControler()
	local g = Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_HAND+LOCATION_DECK,0,nil,rc)
	if not g or #g < 1 then return end
	Duel.Destroy(g,REASON_RULE)
end