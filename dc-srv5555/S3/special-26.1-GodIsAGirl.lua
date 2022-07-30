--村规决斗：天女散花
--所有卡随机得到以下效果（每张卡获得固定的随机效果）
--这张卡从场上送去墓地的场合：
--不去墓地从游戏中除外
--不去墓地回到手卡
--不去墓地回到卡组·额外卡组
--正常送去墓地

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
	local g = Duel.GetMatchingGroup(aux.TRUE,0,0x7f,0x7f,nil)
	g:ForEach(CUNGUI.RegisterMonsterSpecialEffects)
	if not CUNGUI.DrawInit then
		CUNGUI.DrawInit = true
		Duel.Draw(1,2,REASON_RULE)
	end
end

function CUNGUI.RegisterMonsterSpecialEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
	--redirect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(CUNGUI.recon)
	local rand = math.random(4)
	if rand == 1 then
		e2:SetValue(LOCATION_REMOVED)
	elseif rand == 2 then
		e2:SetValue(LOCATION_HAND)
	elseif rand == 3 then
		e2:SetValue(LOCATION_DECKBOT)
	elseif rand == 4 then
		e2:SetValue(0)
	end
	c:RegisterEffect(e2)
end

function CUNGUI.recon(e)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_ONFIELD)
end
