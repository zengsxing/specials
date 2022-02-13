--村规决斗：人海战术
--所有（非衍生物）怪兽得到以下效果：
--这张卡召唤·特殊召唤成功时发动。
--宣言1个数字（1-12），从卡组外在自己场上将1只「白骨」特殊召唤。
--这个效果特殊召唤的衍生物的等级和宣言的数字相同，属性、种族和卡名变成和特殊召唤的怪兽相同（离场后仍然生效）
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
	local g = Duel.GetMatchingGroup(Card.IsType,0,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,nil,TYPE_MONSTER)
	g:ForEach(CUNGUI.RegisterMonsterSpecialEffects)
end

function CUNGUI.RegisterMonsterSpecialEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
	
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(645087,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(CUNGUI.tkop)
	c:RegisterEffect(e1)
	
	local e2 = e1:Clone()
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	
end

function CUNGUI.tkop(e,tp,eg,ep,ev,re,r,rp)
	local lv = Duel.AnnounceLevel(tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,73915052,nil,TYPES_TOKEN_MONSTER,0,0,lv,RACE_BEAST,ATTRIBUTE_EARTH) then return end
	local token=Duel.CreateToken(tp,32274490)
	if not Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then return end
	local e1=Effect.CreateEffect(token)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(lv)
	token:RegisterEffect(e1)
	local e2=Effect.CreateEffect(token)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_ATTACK_FINAL)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(1)
	token:RegisterEffect(e2)
	local e3=Effect.CreateEffect(token)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(0)
	token:RegisterEffect(e3)
	local e4=Effect.CreateEffect(token)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CHANGE_CODE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(e:GetHandler():GetCode())
	token:RegisterEffect(e4)
	local e5=Effect.CreateEffect(token)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CHANGE_RACE)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetValue(e:GetHandler():GetRace())
	token:RegisterEffect(e5)
	local e6=Effect.CreateEffect(token)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetValue(e:GetHandler():GetAttribute())
	token:RegisterEffect(e6)
	Duel.SpecialSummonComplete()
end