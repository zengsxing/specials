--村规决斗：百家争鸣
--每个回合，回合玩家把手卡抽到6。
--所有怪兽（因下列效果特殊召唤的怪兽除外）得到以下效果。
--1回合1次，可以发动。这张卡里侧表示除外，从卡组外选以下1只随机怪兽，
--攻击力/守备力变为和这张卡攻击力相同（离场再返场也不会失效），在自己场上特殊召唤。
--这个效果特殊召唤的怪兽当作正规召唤使用，不受其他这个效果特殊召唤的怪兽的效果的影响。
--万物创世龙（暗）；闪刀姬-飒天（风）；防火龙（光）；重爆击禽 炸弹不死魔鸟（火）；宝石骑士·斜绿（地）；半龙女仆·洗衣龙女（水）

--半龙女仆·洗衣龙女追加效果：
--这张卡不受其他卡的效果影响。只要这张卡在自己的怪兽区域表侧表示存在，自己即使基本分降为0也不会决斗败北。
--（特殊胜利仍然还是会导致失败的）

--闪刀姬-飒天修改效果：
--②：这张卡进行战斗的伤害计算后才能发动。从卡组·额外卡组把1~2张卡送去墓地。

--防火龙修改效果：
--②：这张卡所连接区的怪兽被战斗破坏的场合或者被送去墓地的场合才能发动。从手卡·卡组·墓地·除外·额外卡组把1只怪兽特殊召唤。

--重爆击禽 炸弹不死魔鸟修改效果：
--每1张700分伤害。

--宝石骑士·斜绿修改效果：
--最多通常召唤100次。

--万物创世龙修改效果：
--攻击力固定为10000（大黑球优先级）（防御力不变）。

CUNGUI = {}
CUNGUI.SPList = {}
CUNGUI.RegisteredMonsters = Group.CreateGroup()
CUNGUI.CardList={10000,8491308,5043010,6602300,3113836,13171876}

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

function CUNGUI.AdjustOperation()
	local g = Duel.GetMatchingGroup(Card.IsType,0,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,nil,TYPE_MONSTER)
	g:ForEach(CUNGUI.RegisterMonsterRuleEffects)
end

function CUNGUI.RegisterMonsterRuleEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetDescription(aux.Stringid(6625096,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(CUNGUI.target1)
	e1:SetOperation(CUNGUI.operation1)
	c:RegisterEffect(e1)
end
function CUNGUI.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() and Duel.GetMZoneCount(tp,c)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function CUNGUI.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	local def=c:GetDefense()
	if c:IsRelateToEffect(e) and Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT) and Duel.GetMZoneCount(tp)>0 then
		local dice=Duel.TossDice(tp,1)
		local token = Duel.CreateToken(tp,CUNGUI.CardList[dice])
		Duel.SpecialSummonStep(token,0,tp,tp,true,true,POS_FACEUP)
		if dice > 1 then
			local e1=Effect.CreateEffect(token)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(atk)
			token:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE)
			e2:SetValue(def)
			token:RegisterEffect(e2)
		else
			local e1=Effect.CreateEffect(token)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK)
			e1:SetValue(10000)
			token:RegisterEffect(e1)
		end
		token:CompleteProcedure()
		local e3=Effect.CreateEffect(token)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetCode(EFFECT_IMMUNE_EFFECT)
		e3:SetRange(LOCATION_MZONE)
		e3:SetValue(CUNGUI.efilter)
		token:RegisterEffect(e3)
		CUNGUI.RegisteredMonsters:AddCard(token)
		CUNGUI.SPList[token]=true
		Duel.SpecialSummonComplete()
		token:CompleteProcedure()
	end
end
function CUNGUI.efilter(e,te)
	return CUNGUI.SPList[te:GetHandler()]
end