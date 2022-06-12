--村规决斗：琴瑟合鸣
--开局时，后攻方抽2张。
--所有灵摆卡以外的原本种类是怪兽卡的卡得到以下效果：
--表侧表示的这张卡因Cost·召唤手续以外从场上送去墓地的场合，
--可以不送去墓地当作通常魔法卡使用在自己的魔法与陷阱区域表侧表示放置。
--那次连锁结束后，这张卡得到以下②效果。

--所有【场地·装备·永续】以外的原本种类是魔法·陷阱卡的卡得到以下效果：
--①：这张卡发动的场合不送去墓地。那次连锁结束后，这张卡得到以下②效果。

--②：此类②效果以外的效果发动时，把表侧表示的这张卡从自己的魔法·陷阱区域送去墓地才能发动。
--这个效果变成与那个效果相同。

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
	if not CUNGUI.DrawInit then
		CUNGUI.DrawInit = true
		Duel.Draw(1,2,REASON_RULE)
	end
end

function CUNGUI.RegisterMonsterSpecialEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
	if c:IsType(TYPE_MONSTER) then
		if c:IsType(TYPE_PENDULUM) then return end
		--send replace
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e1:SetCondition(CUNGUI.repcon)
		e1:SetOperation(CUNGUI.repop)
		c:RegisterEffect(e1)
	elseif not c:IsType(TYPE_PENDULUM+TYPE_CONTINUOUS+TYPE_EQUIP+TYPE_FIELD) then
		--remain field
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetCode(EFFECT_REMAIN_FIELD)
		c:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e4:SetCode(EVENT_CHAIN_SOLVED)
		e4:SetRange(LOCATION_SZONE)
		e4:SetOperation(CUNGUI.regop)
		c:RegisterEffect(e4)
	end
end
CUNGUI.Registered={}
function CUNGUI.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(66666666)>0 then return end
	c:RegisterFlagEffect(66666666,RESET_EVENT+RESETS_STANDARD,0,1)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetReset(RESETS_STANDARD+RESET_EVENT)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	CUNGUI.Registered[e1]=true
	e1:SetCondition(CUNGUI.condition)
	e1:SetCost(CUNGUI.cost)
	e1:SetTarget(CUNGUI.target)
	e1:SetOperation(CUNGUI.activate)
	c:RegisterEffect(e1)
end

function CUNGUI.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(0x7d0) and not CUNGUI.Registered[re]
end
function CUNGUI.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function CUNGUI.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ftg=re:GetTarget()
	if chkc then return ftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	if chk==0 then return not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk) end
	local prop = EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP
	if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		prop = prop | EFFECT_FLAG_CARD_TARGET
	end
	e:SetProperty(prop)
	if ftg then
		pcall(ftg,e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function CUNGUI.activate(e,tp,eg,ep,ev,re,r,rp)
	local fop=re:GetOperation()
	if fop==nil then return end
	pcall(fop,e,tp,eg,ep,ev,re,r,rp)
end

function CUNGUI.repcon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and not c:IsReason(REASON_COST)
end

function CUNGUI.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_SPELL)
	c:RegisterEffect(e1)
	CUNGUI.regop(e,tp,eg,ep,ev,re,r,rp)
end

function CUNGUI.spfilter(c,e,tp)
	return c:IsCode(e:GetHandler():GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,true,true,POS_FACEUP_ATTACK)
end

function CUNGUI.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(CUNGUI.spfilter,tp,0x33,0,c,e,tp)
	local f=Duel.GetMZoneCount(tp)
	if #g>0 and f>0 then
		local max = #g
		if max > f then max = f end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=g:Select(g,tp,max,max,nil)
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP_ATTACK)
	end
end