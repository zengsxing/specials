--村规决斗：万物创世
--游戏开始时，各自从卡组外将1张【万物创世龙】加入双方手卡。
--场上·手卡以外的卡有【万物创世龙】的场合（无论表侧还是里侧表示），那些【万物创世龙】加入手卡。
--万物创世龙的效果修改：
--这张卡不能通常召唤。把自己场上攻击力与守备力数值合计不为0的任意数量的怪兽解放的场合才能特殊召唤。
--①：这个方法特殊召唤的这张卡的攻击力·守备力变成解放的怪兽的攻击力·守备力合计数值。这个效果不会被无效化。

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
	e2:SetOperation(CUNGUI.AdjustOperation2)
	Duel.RegisterEffect(e2,0)
end

CUNGUI.RegisteredMonsters = Group.CreateGroup()

function CUNGUI.AdjustOperation2(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetMatchingGroup(Card.IsCode,0,0x7f-LOCATION_HAND-LOCATION_ONFIELD,0x7f-LOCATION_HAND-LOCATION_ONFIELD,nil,10000)
	if #g > 0 then
        Duel.SendtoHand(g,nil,REASON_RULE+REASON_RETURN)
	end
end

function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
	if not CUNGUI.INIT then
		CUNGUI.INIT = true
		local card1 = Duel.CreateToken(0,10000)
		local card2 = Duel.CreateToken(1,10000)
		CUNGUI.RegisteredMonsters:AddCard(card1)
		CUNGUI.RegisteredMonsters:AddCard(card2)
		Duel.SendtoHand(card1, nil, REASON_RULE)
		Duel.SendtoHand(card2, nil, REASON_RULE)
	end
	e:Reset()
	--local g = Duel.GetMatchingGroup(Card.IsType,0,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,nil,TYPE_MONSTER)
	--g:ForEach(CUNGUI.RegisterMonsterSpecialEffects)
end

function CUNGUI.RegisterMonsterSpecialEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
    aux.EnableChangeCode(c,32274490,LOCATION_GRAVE)
end