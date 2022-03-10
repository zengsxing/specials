--村规决斗：怨灵缠身
--所有卡得到以下效果：
--这张卡在墓地的场合，从墓地把任意张卡除外才能发动。场上1只和那个数量相同等级的表侧表示的怪兽破坏。
--这个效果在对方回合也能发动。
--后攻多抽1张。
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
	local g = Duel.GetMatchingGroup(nil,0,0x7f,0x7f,nil)
	g:ForEach(CUNGUI.RegisterMonsterSpecialEffects)
	if not CUNGUI.Init then
		CUNGUI.Init = true
		Duel.Draw(1,1,REASON_RULE)
	end
end

function CUNGUI.RegisterMonsterSpecialEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
	--instant(chain)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(6733059,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCost(CUNGUI.cost)
	e2:SetOperation(CUNGUI.operation)
	c:RegisterEffect(e2)
end
function CUNGUI.cfilter(c)
	return c:IsAbleToRemoveAsCost()
end
function CUNGUI.tfilter(c,lv)
	return c:IsFaceup() and c:IsLevelBelow(lv)
end
function CUNGUI.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local cg=Duel.GetMatchingGroup(CUNGUI.cfilter,tp,LOCATION_GRAVE,0,nil)
		local tg=Duel.GetMatchingGroup(CUNGUI.tfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,cg:GetCount())
		return tg:GetCount()>0
	end
	e:SetLabel(0)
	local cg=Duel.GetMatchingGroup(CUNGUI.cfilter,tp,LOCATION_GRAVE,0,nil)
	local tg=Duel.GetMatchingGroup(CUNGUI.tfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,cg:GetCount())
	local lvt={}
	local tc=tg:GetFirst()
	while tc do
		local tlv=tc:GetLevel()
		lvt[tlv]=tlv
		tc=tg:GetNext()
	end
	local pc=1
	for i=1,12 do
		if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(6733059,2))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=cg:Select(tp,lv,lv,nil)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
	Duel.SetTargetParam(lv)
end
function CUNGUI.dfilter(c,lv)
	return c:IsFaceup() and c:IsLevel(lv)
end
function CUNGUI.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if lv==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,CUNGUI.dfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,lv)
	Duel.Destroy(g,REASON_EFFECT)
end
