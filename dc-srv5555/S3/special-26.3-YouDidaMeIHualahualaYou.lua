--村规决斗：礼尚往来
--所有卡得到以下效果：
--此类效果回合玩家1回合只能使用2次，非回合玩家1回合只能使用1次，结束阶段不能发动。
--这个效果发动的回合，对方可以进行通常召唤最多2次。
--自己·对方回合，把手卡的这张卡给对方展示才能发动。
--选对方1张能加入自己手卡的卡加入这张卡的持有者的手卡。那之后，这张卡交给对方。
--这个效果加入自己手卡的卡在下个回合的结束阶段未发生过移动的场合，自己受到2000点伤害。
--细则：
--可以选场上·墓地·手卡·除外的卡，但未公开区域是盲选。
--当然会被屋敷童·灰流丽无效。

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
	if not CUNGUI.RandomSeedInit then
		CUNGUI.RandomSeedInit = true
		Duel.LoadScript("random.lua")
		math.randomseed(_G.RANDOMSEED)
		for i=1,10 do math.random(1000) end
		CUNGUI.Used={}
		CUNGUI.Used[0]=0
		CUNGUI.Used[1]=0
	end
	CUNGUI.Used[0]=0
	CUNGUI.Used[1]=0
	local g = Duel.GetMatchingGroup(aux.TRUE,0,0x7f,0x7f,nil)
	g:ForEach(CUNGUI.RegisterMonsterSpecialEffects)
end

function CUNGUI.RegisterMonsterSpecialEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66666004,4))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(CUNGUI.sptg)
	e2:SetOperation(CUNGUI.spop)
	c:RegisterEffect(e2)
end
CUNGUI.Used={}
function CUNGUI.filter(c)
	return c:IsAbleToHandAsCost() or c:IsLocation(LOCATION_HAND)
end
function CUNGUI.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(CUNGUI.filter,tp,0,0x7f,1,nil)
		and CUNGUI.Used[tp]==0 or (Duel.GetTurnPlayer()==tp and CUNGUI.Used[tp]<2)
		and Duel.GetCurrentPhase()~=PHASE_END end
	CUNGUI.Used[tp]=CUNGUI.Used[tp]+1
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(2)
	Duel.RegisterEffect(e1,tp)
end
function CUNGUI.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,CUNGUI.filter,tp,0,0x7f,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,tp,REASON_EFFECT)>0 and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,1-tp,REASON_EFFECT)
		c=g:GetFirst()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetCondition(CUNGUI.damcon)
		e2:SetOperation(CUNGUI.damop)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		e2:SetLabelObject(c)
		e2:SetLabel(c:GetFieldID())
		Duel.RegisterEffect(e2,tp)
	end
end
function CUNGUI.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():IsLocation(LOCATION_HAND) and e:GetLabelObject():GetFieldID() == e:GetLabel()
end
CUNGUI.EffectSaver={}
function CUNGUI.damop(e,tp,eg,ep,ev,re,r,rp)
	if not CUNGUI.EffectSaver[e] then
		CUNGUI.EffectSaver[e]=true
		return
	end
	local c=e:GetLabelObject()
	if c:GetFieldID()==e:GetLabel() then
		Duel.Damage(tp,2000,REASON_EFFECT)
	end
end