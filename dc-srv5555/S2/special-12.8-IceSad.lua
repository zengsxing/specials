--村规决斗：霜之哀伤
--一名玩家的基本分达到16000的场合，那个玩家的对方基本分变为0。
--所有怪兽得到以下效果：
--这张卡召唤·特殊召唤成功的场合，
--从卡组外将1张【蓝色药剂】（20871001）加入对方墓地。
--这个效果置于墓地的【蓝色药剂】增加效果：
--此类效果1回合只能使用1次。
--这张卡在墓地的场合，自己结束阶段发动。回复自己墓地【蓝色药剂】数量*400。

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
	--adjust
	e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(CUNGUI.AdjustOperation2)
	Duel.RegisterEffect(e1,0)
end

function CUNGUI.AdjustOperation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(0)>=16000 then
		Duel.SetLP(1,0)
	elseif Duel.GetLP(1)>=16000 then
		Duel.SetLP(0,0)
	end
end

CUNGUI.RegisteredMonsters = Group.CreateGroup()

function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetMatchingGroup(Card.IsType,0,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA+LOCATION_MZONE,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA+LOCATION_MZONE,nil,TYPE_MONSTER)
	g:ForEach(CUNGUI.RegisterMonsterSpecialEffects)
end

function CUNGUI.RegisterMonsterSpecialEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetOperation(CUNGUI.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

function CUNGUI.thop(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(1-tp,20871001)
	Duel.SendtoGrave(token,REASON_RULE)
	local e1=Effect.CreateEffect(token)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,20871001)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetCondition(CUNGUI.reccon)
	e1:SetTarget(CUNGUI.rectg)
	e1:SetOperation(CUNGUI.recop)
	token:RegisterEffect(e1)
end
function CUNGUI.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function CUNGUI.recfilter(c)
	return c:IsFaceup() and c:IsCode(20871001)
end
function CUNGUI.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local rec=400*Duel.GetMatchingGroupCount(CUNGUI.recfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function CUNGUI.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	d=400*Duel.GetMatchingGroupCount(CUNGUI.recfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Recover(p,d,REASON_EFFECT)
end
