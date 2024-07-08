--AI祭-202408-世界BOSS活动 森罗无尽的万华镜
--Boss会有1或16张额外，第1或16张额外为龙魔导（37818794）
--这张卡开局时会被撕掉（标记为AI）

--回合开始时，回合玩家抽1张赌博卡。
--AI手卡在2以下，则额外抽到【圣杯A】
--AI基本分在700以下，则额外抽到【大逆转谜题】【风魔手里剑】
--玩家基本分在2000以下，则额外抽到【命运的分岔道】【火焰飞镖】
--玩家手卡6以上，AI手卡2以下，额外抽到【赌博】
--玩家后场3以上，额外抽到【骰子旋风】
--玩家怪兽3以上，额外抽到【时间的魔术师】【二重召唤】
--玩家后场5张，抽卡阶段直接发动【同花顺】

--特殊规则
--载入各个特殊规则。

--兜底
math.random = Duel.GetRandomNumber or math.random
local CUNGUI={}

local CUNGUI.AI = 0
local CUNGUI.SummoningChest = false


--赌博卡列表
CUNGUI.GambleCards = {3280747,37812118,50470982,43061293,37313786,3493058,38299233,25173686,71625222,36562627,19162134,81172176,
						21598948,39537362,36378044,38143903,96012004,62784717,84290642,3549275,41139112,36708764,74137509,126218,
						93078761,76895648,22802010,83241722,84397023,31863912,39454112,59905358,5990062,9373534,58577036}

function Auxiliary.PreloadUds()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(CUNGUI.CheckAI)
	Duel.RegisterEffect(e1,0)

	--要执行的特殊规则
	--本次活动中，一阶段=8，二阶段=15
	local RULE_MAX_INDEX = 8
	Duel.LoadScript("rule" .. tostring(math.random(RULE_MAX_INDEX)) .. ".lua")
	if SP_RULE and SP_RULE.Init then
		SP_RULE.Init()
	end
--[[第一阶段的宝箱怪被抠辣.jpg
    if math.random(2)==1 then
        InitRefreshChest()
    end
]]--
end

function InitRefreshChest()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(CUNGUI.RefreshChestCheck)
	Duel.RegisterEffect(e1,0)
end

function CUNGUI.RefreshChestCheck(e)

end

function CUNGUI.CheckAI(e)
    local a0 = Duel.GetFieldGroupCount(0, LOCATION_EXTRA, 0)
    local a1 = Duel.GetFieldGroupCount(1, LOCATION_EXTRA, 0)
    local c0 = Duel.GetMatchingGroup(Card.IsCode, 0, LOCATION_EXTRA, 0, nil, 37818794)
    local c1 = Duel.GetMatchingGroup(Card.IsCode, 1, LOCATION_EXTRA, 0, nil, 37818794)
    if a0 > 15 and #c0>0 then
		Duel.Exile(c0:GetFirst(),REASON_RULE)
		CUNGUI.StartAI(0)
	else
		CUNGUI.StartHuman(0)
    end
    if a1 > 15 and #c1>0 then
		Duel.Exile(c1:GetFirst(),REASON_RULE)
		CUNGUI.StartAI(1)
	else
		CUNGUI.StartHuman(1)
    end
	if SP_RULE then
		if SP_RULE.Card then
			SP_RULE.CardGroup={}
			--创造并固定规则卡
			local e1=Effect.GlobalEffect()
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EVENT_ADJUST)
			e1:SetLabel(SP_RULE.Card)
			e1:SetOperation(CUNGUI.RuleCardMove)
			Duel.RegisterEffect(e1,0)
			e1=e1:Clone()
			Duel.RegisterEffect(e1,1)
		end
		if SP_RULE.RuleName then
			Debug.Message("已启动规则：【" .. SP_RULE.RuleName .. "】，以下为规则详情。")
		end
		if SP_RULE.Message then
			for _,v in pairs(SP_RULE.Message) do
				Debug.Message(v)
			end
		else
			Debug.Message("（详情不明）")
		end
	end
	e:Reset()
end

function CUNGUI.StartHuman(tp)
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1,34567890)
	e1:SetOperation(CUNGUI.HumanDraw)
	Duel.RegisterEffect(e1,tp)
end

function CUNGUI.HumanDraw(e,tp)
	if Duel.GetTurnPlayer()~=tp then return end
	local id=CUNGUI.GambleCards[math.random(#CUNGUI.GambleCards)]
	local c=Duel.CreateToken(tp,id)
    Duel.SendtoDeck(c,tp,SEQ_DECKTOP,REASON_RULE)
	Duel.Draw(tp,1,REASON_RULE)
end

function RuleCardMove(e,tp)
	local c=e:GetLabelObject()
	if not c then
		c=Duel.CreateToken(tp,e:GetLabel())
		if SP_RULE and SP_RULE.InitRuleCard then
			SP_RULE.InitRuleCard(c)
		end
		e:SetLabelObject(c)
		SP_RULE.CardGroup[tp]=c
	end
	if c:IsLocation(LOCATION_REMOVED) and c:IsFacedown() then
		Duel.SendtoGrave(c,REASON_RULE)
	end
	if not c:IsLocation(LOCATION_REMOVED) then
		Duel.Remove(c,POS_FACEUP,REASON_RULE)
	end
end

function CUNGUI.GetRandomGambleCard(tp)
	local id=CUNGUI.GambleCards[math.random(#CUNGUI.GambleCards)]
	local c=Duel.CreateToken(tp,id)
	if Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP_ATTACK)>0 then
		c:CompleteProcedure()
		return true
	end
	return false
end

function CUNGUI.StartAI(tp)
	CUNGUI.AI = tp

	if SP_RULE and SP_RULE.InitAdjust then
		--adjust
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_ADJUST)
		if SP_RULE.AdjustCountLimit > 0 then
			e1:SetCountLimit(SP_RULE.AdjustCountLimit)
		end
		e1:SetCondition(CUNGUI.SpecialRuleAdjustCond)
		e1:SetOperation(CUNGUI.SpecialRuleAdjust)
		Duel.RegisterEffect(e1,tp)
	end
	
    Duel.Draw(tp,1,REASON_RULE)
    Duel.Recover(tp,4000,REASON_RULE)
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetOperation(CUNGUI.AICheckDraw)
	Duel.RegisterEffect(e1,tp)
	--Draw
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
    e2:SetLabel(1)
	e2:SetValue(CUNGUI.DrawCount)
    CUNGUI.AIDrawCountEffect = e2
	Duel.RegisterEffect(e2,tp)
end

function CUNGUI.SpecialRuleAdjustCond(e,tp)
	return (not SP_RULE.Card) or (SP_RULE.CardGroup and SP_RULE.CardGroup[tp])
end

function SpecialRuleAdjust(e,tp)
	if e:GetLabel()==1 then return end
	e:SetLabel(1)
	SP_RULE.InitAdjust(e,tp)
	e:SetLabel(0)
	if not SP_RULE.AlwaysAdjust then
		e:Reset()
	end
end

function CUNGUI.AICheckDraw(e,tp)
	if Duel.GetTurnPlayer()~=tp then return end
	CUNGUI.AIDrawCountEffect:SetLabel(Duel.GetDrawCount(tp))

	--额外抽1张赌博卡
	local code = CUNGUI.GambleCards[math.random(#CUNGUI.GambleCards)]
	CUNGUI.CreateCardForAIDraw(tp,code)

	--AI手卡在2以下，则额外抽到【圣杯A】37812118
	if Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<3 then
        CUNGUI.CreateCardForAIDraw(tp,37812118)
	end

	--AI基本分在700以下，则额外抽到【大逆转谜题5990062】【风魔手里剑9373534】
	if Duel.GetLP(tp)<=700 then
        CUNGUI.CreateCardForAIDraw(tp,5990062)
        CUNGUI.CreateCardForAIDraw(tp,9373534)
	end

	--玩家基本分在2000以下，则额外抽到【命运的分岔道50470982】【火焰飞镖43061293】
	if Duel.GetLP(1-tp)<=2000 then
        CUNGUI.CreateCardForAIDraw(tp,50470982)
        CUNGUI.CreateCardForAIDraw(tp,43061293)
	end

	--玩家手卡6以上，AI手卡2以下，额外抽到【赌博37313786】
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>=6 and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<=2 then
        CUNGUI.CreateCardForAIDraw(tp,37313786)
	end

	--玩家后场3以上，额外抽到【骰子旋风3493058】
	if Duel.GetFieldGroupCount(tp,0,LOCATION_SZONE)>=3 then
        CUNGUI.CreateCardForAIDraw(tp,3493058)
	end

	--玩家怪兽3以上，额外抽到【时间魔术师71625222】【二重召唤43422537】
	if Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>=3 then
        CUNGUI.CreateCardForAIDraw(tp,71625222)
        CUNGUI.CreateCardForAIDraw(tp,43422537)
	end

	local royal = true
	for i=0,4 do
		if Duel.GetFieldCard(1-tp,LOCATION_SZONE,i)==nil then royal = false end
	end
	--玩家后场5张，抽卡阶段直接使用1次【同花顺25173686】效果
	if royal then
		local sg=Duel.GetMatchingGroup(CUNGUI.royalfilter,tp,0,LOCATION_SZONE,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end

function CUNGUI.royalfilter(c)
	return c:GetSequence()<5
end

function CUNGUI.CreateCardForAIDraw(tp,code)
    local c=Duel.CreateToken(tp, code)
    Duel.SendtoDeck(c,tp,SEQ_DECKTOP,REASON_RULE)
	CUNGUI.AIDrawCountEffect:SetLabel((CUNGUI.AIDrawCountEffect:GetLabel() or Duel.GetDrawCount(tp)) + 1)
end

function CUNGUI.DrawCount(e)
	return e:GetLabel() or Duel.GetDrawCount(e:GetOwner())
end