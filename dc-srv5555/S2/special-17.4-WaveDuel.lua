--村规决斗：波动决斗
--所有怪兽得到以下效果：
--这张卡进行战斗后发动。
--这张卡的攻击力/守备力随机上升或下降。最少为-30%，最多为60%。
--这个效果上升和下降的攻击力不会被无效化，离场后仍然有效。
--具体规则：
--投一个硬币，如果是反面则下降，如果是正面则上升。
--再投一个骰子，如果是下降则按点数下降5%/10%/15%/20%/25%/30%，
--如果是上升则按点数上升10%/20%/30%/40%/50%/60%。
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
	local g = Duel.GetMatchingGroup(Card.IsType,0,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA+LOCATION_MZONE,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA+LOCATION_MZONE,nil,TYPE_MONSTER)
	g:ForEach(CUNGUI.RegisterMonsterSpecialEffects)
end

function CUNGUI.RegisterMonsterSpecialEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1621413,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLED)
	e1:SetOperation(CUNGUI.operation)
	c:RegisterEffect(e1)
end

function CUNGUI.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local coin=Duel.TossCoin(tp,1) * 2 - 1
	local atk=Duel.TossDice(tp,1) * c:GetAttack() * 0.1
	local def=Duel.TossDice(tp,1) * c:GetDefense() * 0.1
	if coin < 0 then
		atk = atk * 0.5
		def = def * 0.5
	end
	atk = atk * coin
	def = def * coin
	atk = math.ceil(atk)
	def = math.ceil(def)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(def)
	c:RegisterEffect(e2)
end

