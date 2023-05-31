--村规决斗：时空乱流EX
--双方每个回合的回合时间都会随机变化，从30~300秒不等。
--开局时，双方将1张【所罗门的律法书】（23471572）从卡组外除外。这张卡不在除外状态的场合立刻除外。
--这张【所罗门的律法书】得到以下效果：
--每个对方的结束阶段发动。掷1个骰子。
--1：跳过自己的下个抽卡阶段。
--2：跳过自己的下个准备阶段。
--3：跳过自己的下个主要阶段1。
--4：跳过自己的下个主要阶段2。
--5：跳过自己的下个战斗阶段。
--6：跳过自己的下个回合。
--这个效果从T2开始发动和处理。

--细则：投掷到6的场合，会因为未经过结束阶段而跳过1次投掷。

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

	if not CUNGUI.InitRandomSeed then
		CUNGUI.InitRandomSeed = true
		math.random = Duel.GetRandomNumber
	end
	--adjust
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetCountLimit(1)
	e2:SetOperation(CUNGUI.AdjustOperationTT)
	Duel.RegisterEffect(e2,0)
end

function CUNGUI.AdjustOperationTT(e,tp,eg,ep,ev,re,r,rp)
	local tm = math.random(30,300)
	Duel.Hint(HINT_NUMBER,tp,tm)
	Duel.ResetTimeLimit(0,tm)
	tm = math.random(30,300)
	Duel.ResetTimeLimit(1,tm)
	Duel.Hint(HINT_NUMBER,1,tm)
end

CUNGUI.RuleCards=Group.CreateGroup()

function CUNGUI.AdjustOperation2(e,tp,eg,ep,ev,re,r,rp)
	if (CUNGUI.RuleCards:Filter(Card.IsLocation,nil,LOCATION_REMOVED):GetCount()~=2) then
		Duel.Remove(CUNGUI.RuleCards,POS_FACEUP,REASON_RULE)
	end
end

function CUNGUI.RegisterRuleEffect(c)
	--skip phase
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66666004,4))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(CUNGUI.condition)
	e2:SetOperation(CUNGUI.operation)
	c:RegisterEffect(e2)
end

function CUNGUI.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()>1 and Duel.GetTurnPlayer()~=tp
end

function CUNGUI.operation(e,tp,eg,ep,ev,re,r,rp)
	local dice=Duel.TossDice(tp,1)
	local code=EFFECT_SKIP_DP
	if dice==2 then code=EFFECT_SKIP_SP end
	if dice==3 then code=EFFECT_SKIP_M1 end
	if dice==4 then code=EFFECT_SKIP_BP end
	if dice==5 then code=EFFECT_SKIP_M2 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(code)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	if dice==6 then
		e1:SetCode(EFFECT_SKIP_TURN)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e1:SetTargetRange(0,1)
		Duel.RegisterEffect(e1,1-tp)
	else
		Duel.RegisterEffect(e1,tp)
	end
end

function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
	if not CUNGUI.INIT then
		CUNGUI.INIT = true
		local card1 = Duel.CreateToken(0,23471572)
		local card2 = Duel.CreateToken(1,23471572)
		CUNGUI.RegisterRuleEffect(card1)
		CUNGUI.RegisterRuleEffect(card2)
		CUNGUI.RuleCards:AddCard(card1)
		CUNGUI.RuleCards:AddCard(card2)
		Duel.Remove(card1,POS_FACEUP,REASON_RULE)
		Duel.Remove(card2,POS_FACEUP,REASON_RULE)
	end
	--return
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetOperation(CUNGUI.AdjustOperation2)
	Duel.RegisterEffect(e2,0)
	e:Reset()
end