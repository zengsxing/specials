--村规决斗：孪生兄弟
--所有额外卡组的卡（开始游戏后送去额外的灵摆卡不算）得到以下效果：
--这张卡特殊召唤成功的场合发动。
--将1张这张卡原本卡名的同名卡从卡组外加入额外卡组，
--将这场决斗中上次用于这张卡特殊召唤的一组素材无视召唤条件从任何区域特殊召唤到场上。

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
CUNGUI.Used={}
CUNGUI.Used[0]={}
CUNGUI.Used[1]={}

function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
	CUNGUI.Used[0]={}
	CUNGUI.Used[1]={}
	local g = Duel.GetMatchingGroup(nil,0,LOCATION_EXTRA,LOCATION_EXTRA,nil)
	g:ForEach(CUNGUI.RegisterMonsterSpecialEffects)
end

function CUNGUI.RegisterMonsterSpecialEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
	if c:IsFaceup() then return end
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66666004,4))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(CUNGUI.distg2)
	e2:SetOperation(CUNGUI.disop2)
	c:RegisterEffect(e2)
end

function CUNGUI.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end

function CUNGUI.distg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return not CUNGUI.Used[tp][e:GetHandler():GetOriginalCode()] end
	if not g then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,0)
	else
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,#g,tp,0)
	end
end

function CUNGUI.disop2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetMaterial()
	local code = e:GetHandler():GetOriginalCode()
	if not g or #g==0 then return end
	CUNGUI.Used[tp][code]=true
	local tc=Duel.CreateToken(tp,code)
	Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
end