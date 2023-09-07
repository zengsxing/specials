--村规决斗：一击脱离
--所有怪兽得到以下效果：
--这张卡战斗过的战斗阶段结束时，把这张卡返回卡组·额外卡组发动。
--从同样位置随机把1只怪兽无视条件攻击表示特殊召唤（当作正规召唤）。

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
	end
	local g = Duel.GetMatchingGroup(Card.IsType,0,0x7f,0x7f,nil,TYPE_MONSTER)
	g:ForEach(CUNGUI.RegisterMonsterSpecialEffects)
	if not CUNGUI.DrawInit then
		CUNGUI.DrawInit = true
		--Duel.Draw(1,2,REASON_RULE)
	end
end

function CUNGUI.RegisterMonsterSpecialEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(612115,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(CUNGUI.spcon)
	e2:SetCost(CUNGUI.spcost)
	e2:SetTarget(CUNGUI.sptg)
	e2:SetOperation(CUNGUI.spop)
	c:RegisterEffect(e2)
end
function CUNGUI.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0
end
function CUNGUI.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckOrExtraAsCost() end
	local sg = c:GetOverlayGroup()
	if sg and #sg > 0 then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		e:SetLabel(1)
	end
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function CUNGUI.filter(c,e,tp)
	local rc=e:GetHandler()
	local extra = rc:IsExtraDeckMonster()
	return c:IsType(TYPE_MONSTER) and c:GetCode()~=rc:GetCode() and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP_ATTACK)
		and ((extra and Duel.GetLocationCountFromEx(tp,tp,rc,c)>0) or (not extra and Duel.GetMZoneCount(tp,rc)>0))
end
function CUNGUI.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc = LOCATION_DECK
	if e:GetHandler():IsExtraDeckMonster() then loc = LOCATION_EXTRA end
	if chk==0 then return Duel.IsExistingMatchingCard(CUNGUI.filter,tp,loc,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function CUNGUI.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.GetMatchingGroup(CUNGUI.filter,tp,e:GetHandler():GetLocation(),0,nil,e,tp)
	local tc=g:RandomSelect(tp,1):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP_ATTACK)
		tc:CompleteProcedure()
	end
	local sg=e:GetLabelObject()
	if tc:IsType(TYPE_XYZ) and sg and e:GetLabel()==1 then
		Duel.Overlay(tc,sg)
	end
	e:SetLabel(0)
end
