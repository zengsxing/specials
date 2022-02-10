--村规决斗：原谅之神
--所有怪兽得到以下效果：
--同类型的效果1回合只能使用1次。
--结束阶段发动。这张卡的控制权移给对方。
--细则：
--由于回合玩家有优先权，所以回合玩家在结束阶段优先发动这个效果。
--（正常来说可以有1次优先权让渡，然而貌似ygopro没有实现？）
--可以被无效化。

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
    --ntr
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(9780364,1))
    e4:SetCategory(CATEGORY_CONTROL)
    e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_PHASE+PHASE_END)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1,98765432)
    e4:SetCondition(CUNGUI.ctcon)
    e4:SetTarget(CUNGUI.cttg2)
    e4:SetOperation(CUNGUI.ctop2)
    c:RegisterEffect(e4)
end
function CUNGUI.cttg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function CUNGUI.ctop2(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.GetControl(c,1-tp)
    end
end