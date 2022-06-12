--村规决斗：收支平衡
--开局时，双方将1张【霰弹式洗牌】（12183332）从卡组外除外。这张卡不在除外状态的场合立刻除外。
--这张【霰弹式洗牌】得到以下效果：
--在自己的回合，场面每次因这张卡以外的原因发生变化，依次进行如下动作：
--如果自己的卡组数量比墓地数量多，从卡组随机将1张卡送去墓地。
--如果自己的墓地数量比卡组数量多，从墓地随机将1张卡返回卡组。

CUNGUI = {}
CUNGUI.disabled={}
CUNGUI.RuleCards=Group.CreateGroup()

function Auxiliary.PreloadUds()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetOperation(CUNGUI.AdjustOperation)
	Duel.RegisterEffect(e1,0)
	--adjust
	e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(CUNGUI.AdjustOperation2)
	Duel.RegisterEffect(e1,0)
end

function CUNGUI.AdjustOperation2(e,tp,eg,ep,ev,re,r,rp)
	if (CUNGUI.RuleCards:Filter(Card.IsLocation,nil,LOCATION_REMOVED):GetCount()~=2) then
		Duel.Remove(CUNGUI.RuleCards,POS_FACEUP,REASON_RULE)
	end
end

function CUNGUI.RegisterRuleEffect(c)
	--return
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetCondition(CUNGUI.condition)
	e2:SetOperation(CUNGUI.operation)
	Duel.RegisterEffect(e2,c:GetControler())
end

function CUNGUI.condition(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetCurrentChain()==0 and Duel.GetTurnPlayer()==tp) then return false end
	if CUNGUI.disabled[tp] then
		CUNGUI.disabled[tp]=false
		return false
	end
	return true
end
function CUNGUI.filter(c)
	return CUNGUI.RuleCards:IsContains(c)
end

function CUNGUI.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local g2=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	local g3=nil
	if #g1>#g2 then
		g3=g1:RandomSelect(tp,1)
		Duel.SendtoGrave(g3,REASON_EFFECT)
	end
	g1=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
	g2=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if #g1>#g2 then
		g3=g1:RandomSelect(tp,1)
		Duel.SendtoDeck(g3,nil,2,REASON_EFFECT)
	end
	CUNGUI.disabled[tp]=true
end

function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
	local card1 = Duel.CreateToken(0,12183332)
	local card2 = Duel.CreateToken(1,12183332)
	CUNGUI.RegisterRuleEffect(card1)
	CUNGUI.RegisterRuleEffect(card2)
	CUNGUI.RuleCards:AddCard(card1)
	CUNGUI.RuleCards:AddCard(card2)
	Duel.Remove(card1,POS_FACEUP,REASON_RULE)
	Duel.Remove(card2,POS_FACEUP,REASON_RULE)
	e:Reset()
end