--村规决斗：同化完成
--所有怪兽得到以下效果：
--原本持有者是自己的这张卡向对方怪兽攻击的伤害步骤开始时才能发动。
--得到那只怪兽的控制权。

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
	--control
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(31833038,1))
	e4:SetCategory(CATEGORY_CONTROL)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetTarget(CUNGUI.cttg)
	e4:SetOperation(CUNGUI.ctop)
	c:RegisterEffect(e4)
end

function CUNGUI.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	if chk==0 then
		return Duel.GetAttacker()==c and tc and tc:IsControlerCanBeChanged()
			and c:IsOwner(tp)
	end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,tc,1,0,0)
end
function CUNGUI.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
end