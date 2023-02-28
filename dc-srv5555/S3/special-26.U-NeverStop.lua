--村规决斗：源源不绝
--所有怪兽得到以下效果：
--场上表侧表示存在的这张卡被送去墓地的场合才能发动。
--从卡组把1张和这张卡的种类完全相同的卡加入手卡。
--例如【速攻·魔法】，那么加入手卡的卡必须是【速攻·魔法】。
--如果效果处理时这张卡已经离开墓地，那么效果由于无法判断种类而完全不处理。

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
	--Search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1644289,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(CUNGUI.thcon)
	e4:SetTarget(CUNGUI.thtg)
	e4:SetOperation(CUNGUI.thop)
	c:RegisterEffect(e4)
end

function CUNGUI.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
		and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function CUNGUI.thfilter(c,typ)
	return c:GetType()==typ and c:IsAbleToHand()
end
function CUNGUI.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(CUNGUI.thfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler():GetType()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function CUNGUI.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,CUNGUI.thfilter,tp,LOCATION_DECK,0,1,1,nil,e:GetHandler():GetType())
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end