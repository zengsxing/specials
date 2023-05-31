--村规决斗：一期一会
--开局时，双方将1张幸运机会（96012004）从卡组外表侧表示除外。
--这场决斗中这张卡不是表侧表示除外的场合，这张卡表侧表示除外。
--这张卡得到以下效果。
--自己抽卡阶段的通常抽卡后，把手卡抽到5张。
--自己结束阶段。自己的手卡全部返回卡组。
--以上两个效果不受【不能抽卡】【不能返回卡组】的效果影响。
--（均不入连锁）

CUNGUI = {}
CUNGUI.RuleCardCode=96012004

function Auxiliary.PreloadUds()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(CUNGUI.AdjustOperation)
	Duel.RegisterEffect(e1,0)
end
function CUNGUI.AdjustOperation()
	math.random = Duel.GetRandomNumber or math.random
	if not CUNGUI.RuleCardInit then
		CUNGUI.RuleCardInit = true
		CUNGUI.RegisterCardRule(0)
		CUNGUI.RegisterCardRule(1)
	end
	if not CUNGUI.DrawInit then
		CUNGUI.DrawInit = true
		--Duel.Draw(1,1,REASON_RULE)
	end
	if CUNGUI.RuleCard[0] and (not CUNGUI.RuleCard[0]:IsLocation(LOCATION_REMOVED) or not CUNGUI.RuleCard[0]:IsFaceup()) then
		Duel.Remove(CUNGUI.RuleCard[0],POS_FACEUP,REASON_RULE)
	end
	if CUNGUI.RuleCard[1] and (not CUNGUI.RuleCard[1]:IsLocation(LOCATION_REMOVED) or not CUNGUI.RuleCard[1]:IsFaceup()) then
		Duel.Remove(CUNGUI.RuleCard[1],POS_FACEUP,REASON_RULE)
	end
	if CUNGUI.RuleCard[0] and not CUNGUI.RuleCard[0]:IsFaceup() then
		Duel.ChangePosition(CUNGUI.RuleCard[0],POS_FACEUP)
	end
	if CUNGUI.RuleCard[1] and not CUNGUI.RuleCard[1]:IsFaceup() then
		Duel.ChangePosition(CUNGUI.RuleCard[1],POS_FACEUP)
	end
end

CUNGUI.RuleCard={}

function CUNGUI.RegisterCardRule(tp)
	local c=Duel.CreateToken(tp,CUNGUI.RuleCardCode)
	Duel.Remove(c,POS_FACEUP,REASON_RULE)
	CUNGUI.RuleCard[tp]=c
	
	--start
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_DRAW)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCountLimit(1)
	e1:SetCondition(CUNGUI.con)
	e1:SetOperation(CUNGUI.startop)
	c:RegisterEffect(e1)
	--end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCountLimit(1)
	e2:SetCondition(CUNGUI.con)
	e2:SetOperation(CUNGUI.endop)
	c:RegisterEffect(e2)
end

function CUNGUI.con(e,tp)
	return Duel.GetTurnPlayer()==tp
end

function CUNGUI.startop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local num = 5
	if tp~=0 then num = 6 end
	local num = 5-(#g)
	if num > 0 then
		Duel.Draw(tp,num,REASON_RULE)
	end
end

function CUNGUI.endop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_RULE)
end
