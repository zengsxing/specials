--村规决斗：罪域骨王
--游戏开始时，各自从卡组外将1张【白骨王】加入双方手卡。
--除外的卡中有【白骨王】的场合（无论表侧还是里侧表示），那些【白骨王】回到墓地。
--所有怪兽得到以下效果：
--这张卡的卡名只要在墓地存在也当作「白骨」使用。

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
	--return
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetCountLimit(1)
	e2:SetOperation(CUNGUI.AdjustOperation2)
	Duel.RegisterEffect(e2,0)
end

CUNGUI.RegisteredMonsters = Group.CreateGroup()

function CUNGUI.AdjustOperation2(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetMatchingGroup(Card.IsCode,0,LOCATION_REMOVED,LOCATION_REMOVED,nil,36021814)
	if #g > 0 then
        Duel.SendtoGrave(g,REASON_RULE+REASON_RETURN)
	end
end

function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
	if not CUNGUI.INIT then
		CUNGUI.INIT = true
		local card1 = Duel.CreateToken(0,36021814)
		local card2 = Duel.CreateToken(1,36021814)
		CUNGUI.RegisteredMonsters:AddCard(card1)
		CUNGUI.RegisteredMonsters:AddCard(card2)
		Duel.SendtoHand(card1, nil, REASON_RULE)
		Duel.SendtoHand(card2, nil, REASON_RULE)
	end
	local g = Duel.GetMatchingGroup(Card.IsType,0,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,nil,TYPE_MONSTER)
	g:ForEach(CUNGUI.RegisterMonsterSpecialEffects)
end

function CUNGUI.RegisterMonsterSpecialEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
    aux.EnableChangeCode(c,32274490,LOCATION_GRAVE)
end