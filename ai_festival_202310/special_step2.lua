--AI祭-231024-世界BOSS 发牌姬
--发牌姬会有1或16张额外，第1或16张额外为龙魔导（37818794）
--这张卡开局时会被撕掉（标记为AI）
--或，发牌姬额外【仅有】2张龙魔导，则发牌姬会在自己能抽卡的第一个回合抽到5老I。

--对方怪兽卡>=3 -> 多抽张雷击
--对方后场>=3 -> 多抽张羽毛扫
--对方LP<=1000 -> 多抽2张火球
--对方手卡>=5 -> 多抽张强引的番兵
--（以上可叠加）
--自己LP<=1000 -> 抽卡固定为5
--以上条件全部不满足 ->多抽1张

--AI开局多抽1张卡。

--人类手卡+场上的卡+4<=AI手卡+场上的卡的场合，决斗中只有1次：
--将以下怪兽中的1只特殊召唤到玩家场上
--90673288 #水刀
--37818794 #龙魔导
--60461804 #凤凰人
--29432356 #神星龙
--48626373 #阿莱斯哈特
--32909498 #芬里尔狼
--41685633 #雷神龙-雷龙
--84330567 #水仙女人鱼
--21522601 #玻璃女巫

--人类在自己的抽卡阶段手卡<=2的场合，决斗中只有1次：
--从卡组外把以下卡中的随机1张加入手卡。
--55144522 #强欲之壶
--79571449 #天使的施舍
--74191942 #苦涩的选择
--54447022 #灵魂补充
--4031928 #心变
--31305911 #棉花糖
--72589042 #辉煌的逆转之女神

--在第6/第7回合，人类自己的抽卡阶段：
--从卡组外把以下卡中的随机1张加入手卡。
--12580477 #雷击
--83764718 #死者苏生
--18144506 #羽毛扫
--44095762 #圣防
--62279055 #魔法筒

--在第10/第11回合，人类自己的抽卡阶段：
--AI从特殊召唤列表中尽可能多地将怪兽特殊召唤到AI的场上。
--从卡组外把以下卡加入人类手卡。
--54693926 #冥王结界波
--15693423 #颉颃胜负
--04392470 #狮子男巫

--AI的准备阶段：
--AI从特殊召唤列表中将1只怪兽特殊召唤到自己场上。
--这之后，如果AI场上只有1只怪兽，再重复1次特殊召唤。

--特殊召唤列表：
--27279764 #物质主义
--40061558 #无神论
--99267150 #五神龙
--62873545 #究极龙骑士
--72989439 #大开辟
--98630720 #前托枪管龙
--31833038 #装弹枪管龙
--98127546 #冥神
--86221741 #究极猎鹰
--80611581 #帝企
--52085072 #绝望神
--63468625 #机皇神 机录
--69120785 #白界丧失龙
--31764700 #于贝尔-极度悲伤的魔龙
--82103466 #蛇神 格
--84433295 #五阵魔术师
--04167084 #黎明之堕天使 路西法
--13331639 #霸王龙 扎克
--08505920 #合体魔神-门之守护神
--21123811 #宇宙耀变龙
--37442336 #宇宙类星龙
--97836203 #科技属 戟炮手
--97489701 #真红莲新星龙
--15982593 #骑士皇 
--95095116 #炽天之骑士 盖亚日珥
--18666161 #死狱乡演员·镜框舞台龙
--40939228 #流天救世星龙
--41517789 #星态龙
--62180201 #邪神 恐惧之源
--47084486 #虚无魔人
--33746252 #威光魔人
--21208154 #邪神 神之化身
--57793869 #邪神 抹灭者
--14799437 #狱火机·拿玛
--23440231 #狱火机·莉莉丝
--10669138 #连神龙
--21637210 #防火龙·奇点
--03134857 #机械乐团
--29479265 #来迎
--08763963 #天蝇王
--27572350 #深渊之神兽
--72402069 #白地狱终末神
--30604579 #极神皇 托尔
--96633955 #承影
--84815190 #鲜花女男爵
--67508932 #时械神祖
--87460579 #五光
--60465049 #念力终结处刑者
--23288411 #冥地王龙
--91588074 #创星神 提耶拉
--25451652 #堕天使 路西法
--22073844 #神龙四教导
--47556396 #磁魔神
--51522296 #凶导的白天底
--68199168 #哈尔王
--06150044 #天位骑士
--37663536 #古代的机械超巨人
--75286621 #梅尔卡巴
--58481572 #暗爪

--在第1回合的抽卡阶段，有50%几率从以下配置中随机初始场面：
-- AI场上特殊召唤 除暗外的5结界像。玩家场上特殊召唤 闪刀姬零衣
-- AI场上特殊召唤 3物质龙+RR 。玩家场上特殊召唤 超魔导龙骑兵
-- AI场上特殊召唤 物质主义+无神论+拿码+莉莉丝 。玩家场上特殊召唤 智天之神星龙
-- AI场上特殊召唤 6000攻电子界到临者  。玩家场上特殊召唤 水仙女人鱼+鲁莎卡人鱼
-- AI场上特殊召唤 三幻神 。玩家场上特殊召唤 狼+独角兽+哈特
-- AI场上特殊召唤 星尘龙+希望皇+异色眼+防火龙 。玩家场上特殊召唤 超雷龙
-- AI场上特殊召唤 巨人斗士+核成龙+鲜花女男爵+绝对零度侠  。玩家场上特殊召唤 勇者token装备骑龙
-- AI场上特殊召唤 5只五神龙 。玩家场上特殊召唤 玻璃女巫+服装女巫
--否则，AI从特殊召唤列表中特殊召唤1只怪兽到AI场上。


local CUNGUI={}
math.random = Duel.GetRandomNumber or math.random

function Auxiliary.PreloadUds()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(CUNGUI.CheckAI)
	Duel.RegisterEffect(e1,0)
end

function CUNGUI.CheckAI(e)
	local a0 = Duel.GetFieldGroupCount(0, LOCATION_EXTRA, 0)
	local a1 = Duel.GetFieldGroupCount(1, LOCATION_EXTRA, 0)
	local c0 = Duel.GetMatchingGroup(Card.IsCode, 0, LOCATION_EXTRA, 0, nil, 37818794)
	local c1 = Duel.GetMatchingGroup(Card.IsCode, 1, LOCATION_EXTRA, 0, nil, 37818794)
	local ex0 = a0 == 2 and #c0 == 2
	local ex1 = a1 == 2 and #c1 == 2
	local b0 = a0 >= 15 or a0 == 1
	local b1 = a1 >= 15 or a1 == 1
	if b0 and #c0>0 or ex0 then
		if #c0 < 3 then Duel.Exile(c0,REASON_RULE) end
		CUNGUI.StartAI(0,ex0)
		Duel.Draw(tp,0,REASON_RULE)
	else
		CUNGUI.StartHuman(0)
	end
	if b1 and #c1>0 or ex1 then
		if #c1 < 3 then Duel.Exile(c1,REASON_RULE) end
		CUNGUI.StartAI(1,ex1)
		Duel.Draw(tp,1,REASON_RULE)
	else
		CUNGUI.StartHuman(1)
	end
	e:Reset()
end

CUNGUI.Event2List = {90673288,37818794,60461804,29432356,48626373,32909498,41685633,84330567,21522601}
CUNGUI.Event3List = {55144522,79571449,74191942,54447022,4031928,31305911,72589042}
CUNGUI.Event4List = {12580477,83764718,18144506,44095762,62279055}
CUNGUI.SPList = {27279764,40061558,99267150,62873545,72989439,98630720,31833038,98127546,86221741,
80611581,52085072,63468625,69120785,31764700,82103466,84433295,4167084,13331639,
8505920,21123811,37442336,97836203,97489701,15982593,95095116,18666161,40939228,
41517789,62180201,47084486,33746252,21208154,57793869,14799437,23440231,10669138,
21637210,3134857,29479265,8763963,27572350,72402069,30604579,96633955,84815190,
67508932,87460579,60465049,23288411,91588074,25451652,22073844,47556396,51522296,
68199168,6150044,37663536,75286621,58481572}


function CUNGUI.InitSpecial1(ga,gb)
	local c=b:GetFirst()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(6000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end

CUNGUI.InitList = {{{26077387},{10963799,47961808,73356503,19740112,46145256},false},
{{37818794},{12298909,12298909,12298909,86221741},false},
{{29432356},{27279764,40061558,14799437,23440231},false},
{{92731385,84330567},{11738489},CUNGUI.InitSpecial1}, --11738489要加6000攻
{{32909498,68304193,31149212},{10000000,10000010,10000020},false},
{{15291624},{44508094,84013237,16178681,5043010},false},
{{3285552,2563463},{23693634,84815190,40854197,34408491},CUNGUI.InitSpecial2}, --3285552要装备38745520
{{21522601,84523092},{99267150,99267150,99267150,99267150,99267150},false},}


function CUNGUI.StartHuman(tp)
	--event 2
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(CUNGUI.Event2)
	Duel.RegisterEffect(e1,tp)

	--event 3
	e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetOperation(CUNGUI.Event3)
	Duel.RegisterEffect(e1,tp)

	--event 4
	e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetOperation(CUNGUI.Event4)
	Duel.RegisterEffect(e1,tp)

	--event 5
	e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetOperation(CUNGUI.Event5)
	Duel.RegisterEffect(e1,tp)

	--event 6
	e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetOperation(CUNGUI.InitField)
	Duel.RegisterEffect(e1,tp)

end

function CUNGUI.InitField(e,tp)
	if math.random(2)==1 then
		local tbl = CUNGUI.InitList[math.random(#CUNGUI.InitList)]
		local ga=tbl[1] --Summon for human
		local gb=tbl[2] --Summon for AI
		local func=tbl[3] --Special function
		for _,code in pairs(ga) do
			local c=Duel.CreateToken(tp,code)
			Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP_ATTACK)
		end
		for _,code in pairs(gb) do
			local c=Duel.CreateToken(1-tp,code)
			Duel.SpecialSummon(c,0,1-tp,1-tp,true,true,POS_FACEUP_ATTACK)
		end
		ga=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
		gb=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
		if func then func(ga,gb) end
		e:Reset()
	end
end

CUNGUI.LockEvent2 = false
function CUNGUI.Event2(e,tp)
	CUNGUI.LockEvent2 = true
	if not CUNGUI.LockEvent2 and Duel.GetMZoneCount(tp)>0 and
		((Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0) + 4
		<= Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND))
		or (Duel.GetCurrentPhase()==PHASE_STANDBY and Duel.GetTurnPlayer()==tp
		and Duel.GetLP(tp) <= 2000)) then
		local id = CUNGUI.Event2List[math.random(#CUNGUI.Event2List)]
		if Duel.IsPlayerCanSpecialSummonMonster(tp,id) then
			local c=Duel.CreateToken(tp,id)
			if Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP_ATTACK)>0 then
				e:Reset()
			end
		end
	end
	CUNGUI.LockEvent2 = false
end

function CUNGUI.CreateCardToHand(tp,id)
	local c=Duel.CreateToken(tp,id)
	Duel.SendtoHand(c,nil,REASON_RULE)
end

function CUNGUI.Event3(e,tp)
	if Duel.GetTurnPlayer()==tp and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<=2 then
		local id = CUNGUI.Event3List[math.random(#CUNGUI.Event3List)]
		CUNGUI.CreateCardToHand(tp,id)
		e:Reset()
	end
end

function CUNGUI.Event4(e,tp)
	if Duel.GetTurnPlayer()==tp and Duel.GetTurnCount()>=6 then
		local id=CUNGUI.Event4List[math.random(#CUNGUI.Event4List)]
		CUNGUI.CreateCardToHand(tp,id)
		e:Reset()
	end
end

function CUNGUI.RandomSummon(tp)
	local id=CUNGUI.SPList[math.random(#CUNGUI.SPList)]
	if Duel.IsPlayerCanSpecialSummonMonster(tp,id) then
		local c=Duel.CreateToken(tp,id)
		return Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP_ATTACK)
	end
	return false
end

function CUNGUI.Event5(e,tp)
	if Duel.GetTurnCount()>=10 and Duel.GetLP(tp)<=3000 then
		while CUNGUI.RandomSummon(1-tp) do end
		CUNGUI.CreateCardToHand(tp,54693926)
		CUNGUI.CreateCardToHand(tp,15693423)
		CUNGUI.CreateCardToHand(tp,4392470)
		e:Reset()
	end
end

function CUNGUI.StartAI(tp,ex)
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetOperation(CUNGUI.BeforeDraw)
	if ex then
		e1:SetLabel(1)
	end
	Duel.RegisterEffect(e1,tp)
	--Draw
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetLabel(1)
	e2:SetValue(CUNGUI.DrawCount)
	e1:SetLabelObject(e2)
	Duel.RegisterEffect(e2,tp)
	--adjust
	local e3=Effect.GlobalEffect()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCountLimit(1)
	e3:SetOperation(CUNGUI.StandbySPSummon)
	Duel.RegisterEffect(e3,tp)
end

function CUNGUI.CreateCard(tp,code)
	local c=Duel.CreateToken(tp, code)
	Duel.SendtoDeck(c,tp,SEQ_DECKTOP,REASON_RULE)
end
function CUNGUI.BeforeDraw(e,tp)
	if Duel.GetTurnCount()==1 then return end
	if Duel.GetTurnPlayer()~=tp then
		e:GetLabelObject():SetLabel(1)
		return
	end
	if e:GetLabel()==1 then
		CUNGUI.CreateCard(tp,8124921)
		CUNGUI.CreateCard(tp,44519536)
		CUNGUI.CreateCard(tp,70903634)
		CUNGUI.CreateCard(tp,7902349)
		CUNGUI.CreateCard(tp,33396948)
		e:GetLabelObject():SetLabel(5)
		return
	end
	local draw=Duel.GetDrawCount(tp)
	if Duel.GetFieldGroupCount(tp, 0, LOCATION_MZONE)>=3 then
		CUNGUI.CreateCard(tp,12580477)
		draw=draw + 1
	end
	if Duel.GetFieldGroupCount(tp, 0, LOCATION_SZONE)>=3 then
		CUNGUI.CreateCard(tp,18144506)
		draw=draw + 1
	end
	if Duel.GetFieldGroupCount(tp, 0, LOCATION_HAND)>=5 then
		CUNGUI.CreateCard(tp,42829885)
		draw=draw + 1
	end
	if Duel.GetLP(1-tp)<=1000 then
		CUNGUI.CreateCard(tp,46130346)
		CUNGUI.CreateCard(tp,46130346)
		draw=draw + 2
	end
	if Duel.GetLP(tp)<=1000 then
		draw=5
	end
	if draw == Duel.GetDrawCount(tp) then
		draw = draw + 1
	end
	e:GetLabelObject():SetLabel(draw)
end

function CUNGUI.DrawCount(e)
	return e:GetLabel() or 1
end

function StandbySPSummon(e,tp)
	CUNGUI.RandomSummon(tp)
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1 then
		CUNGUI.RandomSummon(tp)
	end
end