--村规决斗：正版卫士
--所有怪兽（同名卡）在场上都只能有1只表侧表示存在。
--所有怪兽得到以下效果。
--1回合1次，可以发动。宣言1个卡名，选场上1只怪兽的卡名变为宣言的卡名。
--这回合是第1次把这个效果发动的场合，再宣言1个卡名，那张卡从卡组外加入额外卡组。

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
	local g = Duel.GetMatchingGroup(Card.IsType,0,
		LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA+LOCATION_MZONE,
		LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA+LOCATION_MZONE,
		nil,TYPE_MONSTER)
	g:ForEach(CUNGUI.RegisterMonsterSpecialEffects)
end

CUNGUI.used={}
CUNGUI.used[0]=0
CUNGUI.used[1]=0

function CUNGUI.RegisterMonsterSpecialEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
	c:SetUniqueOnField(1,1,c:GetOriginalCode())
	--change code
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(89312388,0))
	e1:SetCountLimit(1,87654321)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(CUNGUI.target)
	e1:SetOperation(CUNGUI.operation)
	c:RegisterEffect(e1)
	
end

function CUNGUI.filter(c)
	return c:IsFaceup()
end
function CUNGUI.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return
		Duel.IsExistingMatchingCard(CUNGUI.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function CUNGUI.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,CUNGUI.filter,tp,0,LOCATION_MZONE,1,1,nil)
	if not g or #g == 0 then return end
	local c = g:GetFirst()
	local code = Duel.AnnounceCard(tp,TYPE_MONSTER)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(code)
	c:RegisterEffect(e1)
	local turn = Duel.GetTurnCount()
	if CUNGUI.used[tp]<turn then
		CUNGUI.used[tp]=turn
		code = Duel.AnnounceCard(tp,TYPE_SYNCHRO|TYPE_XYZ|TYPE_LINK|TYPE_FUSION)
		local tc=Duel.CreateToken(tp,code)
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
	end
end
