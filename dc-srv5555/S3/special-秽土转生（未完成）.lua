--村规决斗：秽土转生
--所有【这个卡名1回合只能使用……/这个卡名的效果决斗中只能使用……/这个卡名的效果在场上只能使用……】的效果，变为【1回合……】的效果。
--开局时，把双方额外卡组的所有卡复制1份，加入各自的额外卡组。
--双方将1张转生炎兽的圣域（1295111）从卡组外表侧表示除外。
--这场决斗中这张卡不是表侧表示除外的场合，这张卡表侧表示除外。
--这张卡得到以下效果。这些效果的发动和效果不会被无效化。
--主要阶段才能发动。只用自己场上1只连接怪兽为素材，从额外卡组把1张同名卡连接召唤。
--主要阶段才能发动。只用自己场上1只超量怪兽为素材，从额外卡组把1张同名卡超量召唤。
--主要阶段才能发动。只用自己场上1只融合怪兽为素材，从额外卡组把1张同名卡融合召唤。
--主要阶段才能发动。只用自己场上1只同调怪兽为素材，从额外卡组把1张同名卡同调召唤。

CUNGUI = {}
CUNGUI.RuleCardCode=1295111

EFFECT_FLAG_NO_TURN_RESET = 0
EFFECT_COUNT_CODE_DUEL = 0
local scl = Effect.SetCountLimit
Effect.SetCountLimit = function(e,limit)
	return scl(e,limit)
end

function Auxiliary.PreloadUds()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(CUNGUI.AdjustOperation)
	Duel.RegisterEffect(e1,0)
end
function CUNGUI.AdjustOperation()
	if not CUNGUI.RandomSeedInit then
		CUNGUI.RandomSeedInit = true
		Duel.LoadScript("random.lua")
		math.randomseed(_G.RANDOMSEED)
		for i=1,10 do math.random(1000) end
	end
	if not CUNGUI.RuleCardInit then
		CUNGUI.RuleCardInit = true
		CUNGUI.RegisterCardRule(0)
		CUNGUI.RegisterCardRule(1)
	end
	if CUNGUI.RuleCard[0] and (not CUNGUI.RuleCard[0]:IsLocation(LOCATION_REMOVED) or not CUNGUI.RuleCard[0]:IsFaceup()) then
		Duel.Remove(CUNGUI.RuleCard[0],POS_FACEUP,REASON_RULE)
	end
	if CUNGUI.RuleCard[1] and (not CUNGUI.RuleCard[1]:IsLocation(LOCATION_REMOVED) or not CUNGUI.RuleCard[1]:IsFaceup()) then
		Duel.Remove(CUNGUI.RuleCard[1],POS_FACEUP,REASON_RULE)
	end
	if CUNGUI.RuleCard[0] and not CUNGUI.RuleCard[0]:IsFaceup() then
		Duel.ChangePosition(CUNGUI.RuleCard[0],POS_FACEUP)
	end
	if CUNGUI.RuleCard[1] and not CUNGUI.RuleCard[1]:IsFaceup() then
		Duel.ChangePosition(CUNGUI.RuleCard[1],POS_FACEUP)
	end
end

CUNGUI.RuleCard={}

function CUNGUI.RegisterCardRule(tp)
	local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
	for mc in aux.Next(g) do
		local nc=Duel.CreateToken(tp,mc:GetOriginalCode())
		Duel.SendtoDeck(nc,nil,0,REASON_RULE)
	end
	local c=Duel.CreateToken(tp,CUNGUI.RuleCardCode)
	Duel.Remove(c,POS_FACEUP,REASON_RULE)
	CUNGUI.RuleCard[tp]=c
	--synchro
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(50091196,1)) --同调召唤
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetTarget(CUNGUI.ruletg_synchro)
	e1:SetOperation(CUNGUI.ruleop_synchro)
	c:RegisterEffect(e1)
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5352328,1)) --超量召唤
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetTarget(CUNGUI.ruletg_xyz)
	e1:SetOperation(CUNGUI.ruleop_xyz)
	c:RegisterEffect(e1)
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65741786,0)) --连接召唤
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetTarget(CUNGUI.ruletg_link)
	e1:SetOperation(CUNGUI.ruleop_link)
	c:RegisterEffect(e1)
	e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1264319,0))--融合召唤
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetTarget(CUNGUI.ruletg_fusion)
	e1:SetOperation(CUNGUI.ruleop_fusion)
end
function CUNGUI.rule_syncfilter2(c,cc,tp)
	return c:IsCanBeSynchroMaterial(cc) and Duel.GetLocationCountFromEx(tp,tp,c,cc)
end

function CUNGUI.rule_syncfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.IsExistingMatchingCard(CUNGUI.rule_syncfilter2,tp,LOCATION_MZONE,0,1,nil,c,tp)
end

function CUNGUI.ruletg_synchro(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(CUNGUI.rule_syncfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function CUNGUI.ruleop_synchro(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(CUNGUI.rule_syncfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sg2=Duel.SelectMatchingCard(tp,CUNGUI.rule_syncfilter2,tp,LOCATION_MZONE,0,1,1,nil,tc,tp)
		Duel.SynchroSummon(tp,tc,nil,sg2)
	end
end
function CUNGUI.rule_xyzfilter2(c,cc,tp)
	return c:IsCanBeXyzMaterial(cc) and Duel.GetLocationCountFromEx(tp,tp,c,cc)
end

function CUNGUI.rule_xyzfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.IsExistingMatchingCard(CUNGUI.rule_xyzfilter2,tp,LOCATION_MZONE,0,1,nil,c,tp)
end

function CUNGUI.ruletg_xyz(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(CUNGUI.rule_xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function CUNGUI.ruleop_xyz(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(CUNGUI.rule_xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg2=Duel.SelectMatchingCard(tp,CUNGUI.rule_xyzfilter2,tp,LOCATION_MZONE,0,1,1,nil,tc,tp)
		Duel.XyzSummon(tp,tc,sg2)
	end
end
function CUNGUI.rule_linkfilter2(c,cc,tp)
	return c:IsCanBeLinkMaterial(cc) and Duel.GetLocationCountFromEx(tp,tp,c,cc)
end
function CUNGUI.rule_linkfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
		and Duel.IsExistingMatchingCard(CUNGUI.rule_linkfilter2,tp,LOCATION_MZONE,0,1,nil,c,tp)
end
function CUNGUI.ruletg_link(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(CUNGUI.rule_linkfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function CUNGUI.ruleop_link(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(CUNGUI.rule_linkfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local sg2=Duel.SelectMatchingCard(tp,CUNGUI.rule_linkfilter2,tp,LOCATION_MZONE,0,1,1,nil,tc,tp)
		Duel.LinkSummon(tp,tc,sg2)
	end
end
function CUNGUI.rule_fusionfilter2(c,cc,tp)
	return c:IsCanBeLinkMaterial(cc) and Duel.GetLocationCountFromEx(tp,tp,c,cc)
end
function CUNGUI.rule_fusionfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and Duel.IsExistingMatchingCard(CUNGUI.rule_fusionfilter2,tp,LOCATION_MZONE,0,1,nil,c,tp)
end
function CUNGUI.ruletg_fusion(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(CUNGUI.rule_fusionfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function CUNGUI.ruleop_fusion(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(CUNGUI.rule_fusionfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local sg2=Duel.SelectMatchingCard(tp,CUNGUI.rule_fusionfilter2,tp,LOCATION_MZONE,0,1,1,nil,tc,tp)
		Duel.SendtoGrave(sg2,REASON_EFFECT)
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	end
end