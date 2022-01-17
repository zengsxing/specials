--村规决斗：烙印之战
--以下怪兽均不在自己场上存在时，宣言1个未因这个效果宣言过的卡名，那个卡名的卡从卡组外表侧攻击表示放置到场上。
--这个效果放置的怪兽当作正规召唤使用，不受其他卡的效果影响，不能解放，不能作为融合·同调·超量·连接召唤的素材。
--应宣言却无法宣言（即，5只龙均已用过）的场合，基本分变为0。

--【铁驱龙 迅妖龙】【黑衣龙 白界龙】【痕食龙 盗兽龙】【灰烬龙 落胤龙】【烙印龙 白界龙】
--以上龙的效果有所加强（在extra文件夹里）

CUNGUI = {}

function Auxiliary.PreloadUds()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(CUNGUI.AdjustOperation)
	Duel.RegisterEffect(e1,0)
end

CUNGUI.PlayerDragonList = {}
CUNGUI.PlayerDragonList[0] = Group.CreateGroup()
CUNGUI.PlayerDragonList[1] = Group.CreateGroup()

function CUNGUI.ToGraveFilter(c)
	return c:GetSequence() <= 5
end

function CUNGUI.CheckPlayer(tp)
	if Duel.GetMZoneCount(tp) == 0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0) == 0 then
		return
	end
	local g = Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_MZONE,0,nil,table.unpack(CUNGUI.DragonList))
	if not g or #g == 0 then
		if #CUNGUI.PlayerDragonList[tp]==0 then
			Duel.SetLP(tp,0)
			return
		end
		local index = 1
		local afilter = {}
		for i = 1,#CUNGUI.DragonList do
			if CUNGUI.PlayerDragonList[tp]:IsExists(Card.IsCode,1,nil,CUNGUI.DragonList[i]) then
				index = i + 1
				afilter = {CUNGUI.DragonList[i],OPCODE_ISCODE}
				break
			end
		end
		for i = index,#CUNGUI.DragonList do
			if CUNGUI.PlayerDragonList[tp]:IsExists(Card.IsCode,1,nil,CUNGUI.DragonList[i]) then
				table.insert(afilter,CUNGUI.DragonList[i])
				table.insert(afilter,OPCODE_ISCODE)
				table.insert(afilter,OPCODE_OR)
			end
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
		if Duel.GetMZoneCount(tp) == 0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local tc = Duel.SelectMatchingCard(tp,CUNGUI.ToGraveFilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
			Duel.SendtoGrave(tc,REASON_RULE)
		end
		local cg=CUNGUI.PlayerDragonList[tp]:Filter(Card.IsCode,nil,ac)
		if not cg or #cg == 0 then return end
		local mc = cg:GetFirst()
		if not Duel.MoveToField(mc, tp, tp, LOCATION_MZONE,POS_FACEUP_ATTACK, true) then return end
		CUNGUI.PlayerDragonList[tp]:RemoveCard(mc)
		CUNGUI.RegisterMonsterSpecialEffects(mc)
		mc:CompleteProcedure()
	end
end

function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
	if not CUNGUI.DragonList then
		CUNGUI.DragonList = {1906812,25451383,34848821,41373230,87746184}
		for code=1,#CUNGUI.DragonList do
			CUNGUI.PlayerDragonList[0]:AddCard(Duel.CreateToken(tp,CUNGUI.DragonList[code]))
			CUNGUI.PlayerDragonList[1]:AddCard(Duel.CreateToken(tp,CUNGUI.DragonList[code]))
		end
	end
	tp = Duel.GetTurnPlayer()
	CUNGUI.CheckPlayer(tp)
	CUNGUI.CheckPlayer(1-tp)
end

function CUNGUI.RegisterMonsterSpecialEffects(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e4)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_UNRELEASABLE_SUM)
	c:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(CUNGUI.efilter)
	c:RegisterEffect(e6)
end

function CUNGUI.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end