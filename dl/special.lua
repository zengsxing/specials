local skillLists={}
local skillSelections={}
local lp_record={[0]=0,[1]=0}
local need_shuffle={[0]=true,[1]=true}
local toss_coin=Duel.TossCoin

function Duel.TossCoin(player,count)
	local tmp_count=count
	if Duel.GetLP(player)<=1000 and Duel.GetFlagEffect(player,37812118)>0 then
		if count < 0 then
			tmp_count=7
		end
	end
	return toss_coin(player,tmp_count)
end

local function addSkill(code, skill)
	if not skillLists[code] then
		skillLists[code]={}
	end
	table.insert(skillLists[code], skill)
end

local function getAllSkillCodes()
	local skillCodes={}
	for code,_ in pairs(skillLists) do
		table.insert(skillCodes, code)
	end
	return skillCodes
end

local function registerSkillForPlayer(tp, code)
	local skills=skillLists[code]
	for _,skill in ipairs(skills) do
		local e1=Effect.GlobalEffect()
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		skill(e1,tp)
		Duel.RegisterEffect(e1,tp)
	end
end

local function wrapDeckSkill(code, effectFactory)
	addSkill(code, function(e2)
		local e1=Effect.GlobalEffect()
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetRange(LOCATION_DECK)
		effectFactory(e1)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e2:SetTargetRange(LOCATION_DECK,0)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e2:SetTarget(function(e,c)
			local dg=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_DECK,0)
			if #dg==0 then return false end
			local minc=dg:GetMinGroup(Card.GetSequence):GetFirst()
			return c==minc
		end)
		e2:SetLabelObject(e1)
	end)
end

local function phaseSkill(code, phase, op, con, both)
	wrapDeckSkill(code, function(e1)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCountLimit(1,0x7ffffff-code-phase)
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			return (both or Duel.GetTurnPlayer()==tp) and Duel.GetCurrentPhase()==phase and (not con or con(e,tp,eg,ep,ev,re,r,rp))
		end)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			Duel.Hint(HINT_CARD,0,code)
			op(e,tp,eg,ep,ev,re,r,rp)
		end)
	end)
end

local function mainphaseSkill(code, op, con, both)
	wrapDeckSkill(code, function(e1)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCountLimit(1)
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			return (both or Duel.GetTurnPlayer()==tp) and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and (not con or con(e,tp,eg,ep,ev,re,r,rp))
		end)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			Duel.Hint(HINT_CARD,0,code)
			op(e,tp,eg,ep,ev,re,r,rp)
		end)
	end)
end

local function mainphaseSkillEx(code, op, con, both , count , countid ,duellimit,desc)
	if not countid then countid=code end
	wrapDeckSkill(code, function(e1)
		if desc then e1:SetDescription(desc) end
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			if count and Duel.GetFlagEffect(tp,countid)>=count then return false end
			return (both or Duel.GetTurnPlayer()==tp) and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and (not con or con(e,tp,eg,ep,ev,re,r,rp))
		end)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			Duel.Hint(HINT_CARD,0,code)
			op(e,tp,eg,ep,ev,re,r,rp)
			if count then
				if duellimit then
					Duel.RegisterFlagEffect(tp,countid,0,0,1)
				else
					Duel.RegisterFlagEffect(tp,countid,RESET_PHASE+PHASE_END,0,1)
				end
			end
		end)
	end)
end

local function mainphaseSkillList(code,...)
	local configs = {...}
	wrapDeckSkill(code, function(e1)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			if not Duel.IsMainPhase() then return false end
			for _, config in ipairs(configs) do
				if (config.both or Duel.GetTurnPlayer()==tp) and (not config.con or config.con(e,tp,eg,ep,ev,re,r,rp)) and (not config.count or Duel.GetFlagEffect(tp,config.countid)<config.count) then
					return true
				end
			end
			return false
		end)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			Duel.Hint(HINT_CARD,0,code)
			local available = {}
			for _, config in ipairs(configs) do
				local both = config.both
				local turn_cond = both or (Duel.GetTurnPlayer() == tp)
				if turn_cond then
					local count = config.count
					local countid = config.countid or code
					if count and Duel.GetFlagEffect(tp, countid) >= count then
					else
						local con = config.con
						if not con or con(e,tp,eg,ep,ev,re,r,rp) then
							table.insert(available, config)
						end
					end
				end
			end
			local options={}
			for i, config in ipairs(configs) do
				local enabled=(config.both or Duel.GetTurnPlayer()==tp) and (not config.con or config.con(e,tp,eg,ep,ev,re,r,rp)) and (not config.count or Duel.GetFlagEffect(tp,config.countid)<config.count)
				table.insert(options,{enabled,config.desc})
			end
			local selected=aux.SelectFromOptions(tp,table.unpack(options))
			local config=configs[selected]
			if config then
				if config.count then
					if config.duellimit then
						Duel.RegisterFlagEffect(tp,config.countid,0,0,1)
					else
						Duel.RegisterFlagEffect(tp,config.countid,RESET_PHASE+PHASE_END,0,1)
					end
				end
				config.op(e,tp,eg,ep,ev,re,r,rp)
				if config.count and config.count>1 then
					Duel.AdjustAll()
				end
			end
		end)
	end)
end

local onetimeSkillResolveOperationsPrior={
	[0]={},
	[1]={},
}
local onetimeSkillResolveOperations={
	[0]={},
	[1]={},
}
local function oneTimeSkill(code, op, prior)
	addSkill(code, function(e1,tp)
		local oneTimeSkillObject={
			code=code,
			op=op,
			tp=tp,
		}
		if prior then
			table.insert(onetimeSkillResolveOperationsPrior[tp], oneTimeSkillObject)
		else
			table.insert(onetimeSkillResolveOperations[tp], oneTimeSkillObject)
		end
	end)
end

local function standbyPhaseSkill(code, op, con, both)
	phaseSkill(code, PHASE_STANDBY, op, con, both)
end

local function endPhaseSkill(code, op, con, both)
	phaseSkill(code, PHASE_END, op, con, both)
end

--重新开始
--[[
oneTimeSkill(85852291, function(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(43227,0)) then return end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local ct=#g
	Duel.SendtoDeck(g,nil,0,REASON_RULE)
	Duel.ShuffleDeck(tp)
	Duel.Draw(tp,ct,REASON_RULE)
end)

--青眼白龙
local function lvcheck(c)
	return c:IsFaceup() and c:IsLevelAbove(5)
end
mainphaseSkill(89631139,
function(ce,ctp)
	local g=Duel.GetMatchingGroup(lvcheck,ctp,LOCATION_MZONE,0,nil)
	local atk=g:GetCount()*300
	local ag=Duel.GetMatchingGroup(Card.IsFaceup,ctp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(ag) do
		local e3=Effect.CreateEffect(ce:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(atk)
		tc:RegisterEffect(e3)
	end
	Duel.RegisterFlagEffect(ctp,89631139,RESET_PHASE+PHASE_END,0,1)
end,
function(ce,ctp) 
	local g=Duel.GetMatchingGroup(lvcheck,ctp,LOCATION_MZONE,0,nil)
	return Duel.GetFlagEffect(ctp,89631139)==0 and #g>0 
end,
false)

--黑魔术师
local function lvcheck(c)
	return c:IsFaceup()
end
mainphaseSkill(46986414,
function(ce,ctp)
	local g=Duel.GetMatchingGroup(nil,ctp,LOCATION_MZONE,0,nil)
	local atk=g:GetCount()*100
	local ag=Duel.GetMatchingGroup(Card.IsFaceup,ctp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(ag) do
		local e3=Effect.CreateEffect(ce:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(atk)
		tc:RegisterEffect(e3)
	end
	Duel.RegisterFlagEffect(ctp,46986414,RESET_PHASE+PHASE_END,0,1)
end,
function(ce,ctp) 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,ctp,LOCATION_MZONE,0,nil)
	return Duel.GetFlagEffect(ctp,46986414)==0 and #g>0 
end,
false)

--注定一抽
local function repcon(e,tp,eg,ep,ev,re,r,rp)
	local cur_lp = Duel.GetLP(tp)
	return Duel.GetDrawCount(tp)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) and lp_record[tp] - cur_lp >= 2000 and Duel.GetTurnPlayer()==tp
end
local function repop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,1108) then
		Duel.Hint(HINT_CARD,0,2295831)
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	lp_record[tp] = Duel.GetLP(tp)
	e:Reset()
end

wrapDeckSkill(2295831, function(e7)
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e7:SetCode(EVENT_PREDRAW)
	e7:SetCountLimit(1)
	e7:SetCondition(repcon)
	e7:SetOperation(repop)
end)

oneTimeSkill(2295831, function(e,tp,eg,ep,ev,re,r,rp)
	lp_record[tp]=Duel.GetLP(tp)
end)
]]
--传说的渔夫
local function activate_check(c,tp)
	return c:GetActivateEffect():IsActivatable(tp,true,true)
end
oneTimeSkill(3643300, function(e,tp,eg,ep,ev,re,r,rp)
	local field_1=Duel.CreateToken(tp,43175858)
	local field_2=Duel.CreateToken(tp,37694547)
	local field_3=Duel.CreateToken(tp,295517)
	local field_4=Duel.CreateToken(tp,712559)
	local field_5=Duel.CreateToken(tp,10080320)
	local field_6=Duel.CreateToken(tp,73206827)
	local field_7=Duel.CreateToken(tp,90011152)
	local field_8=Duel.CreateToken(tp,75782277)

	local field_group=Group.FromCards(field_1,field_2,field_3,field_4,field_5,field_6,field_7,field_8)
	field_group:KeepAlive()
	Duel.SendtoDeck(field_group,tp,0,REASON_RULE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=field_group:FilterSelect(tp,activate_check,1,1,nil,tp):GetFirst()
	if tc then
		field_group:RemoveCard(tc)
		Duel.Exile(field_group,REASON_RULE)
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEDOWN,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end)
--毅力
oneTimeSkill(74677422, function(e,tp,eg,ep,ev,re,r,rp)
	local rc=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil):GetFirst()
	local ge1=Effect.CreateEffect(rc)
	ge1:SetType(EFFECT_TYPE_FIELD)
	ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	ge1:SetCode(EFFECT_CANNOT_LOSE_KOISHI)
	ge1:SetTargetRange(1,0)
	ge1:SetValue(1)
	Duel.RegisterEffect(ge1,tp)
	local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_DUEL)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCondition(function(...) 
		return Duel.GetLP(tp) <= 0 
	end)
	e1:SetOperation(function(...)
		local ge2=Effect.CreateEffect(rc)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE+PHASE_END)
		ge2:SetCountLimit(1)
		ge2:SetReset(RESET_PHASE+PHASE_END)
		ge2:SetOperation(function(...)
			Duel.SetLP(tp,1) 
			ge1:Reset()
		end)
		Duel.RegisterEffect(ge2,tp)


		local function skipcon(ge)
			return Duel.GetTurnCount()~=ge:GetLabel()
		end
		local e1=Effect.CreateEffect(rc)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)

		local ph=Duel.GetCurrentPhase()
		local e1=Effect.CreateEffect(rc)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_BP)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetTargetRange(1,0)
		if Duel.GetTurnPlayer()==tp and ph>PHASE_MAIN1 and ph<PHASE_MAIN2 then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(skipcon)
			e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,1)
		end
		Duel.RegisterEffect(e1,tp)
	end
	)
	Duel.RegisterEffect(e1,tp)
end)
--抽卡放弃
--[[
local function skipdrcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return aux.IsPlayerCanNormalDraw(tp) and Duel.IsPlayerCanDiscardDeck(tp,1) and Duel.GetTurnPlayer()==tp
end
local function skipdrop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(49838105,1)) then
		aux.GiveUpNormalDraw(e,tp)
		Duel.Recover(tp,600,REASON_RULE)
		Duel.DiscardDeck(tp,1,REASON_RULE)
	end
end
oneTimeSkill(3701074, function(e,tp,eg,ep,ev,re,r,rp)
	local rc=Duel.GetMatchingGroup(nil,tp,0xff,0,nil):GetFirst()
	local ge1=Effect.CreateEffect(rc)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_PREDRAW)
	ge1:SetCondition(skipdrcon)
	ge1:SetOperation(skipdrop)
	Duel.RegisterEffect(ge1,tp)
end,true)
]]

--生命增加
oneTimeSkill(47852924, function(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,Duel.GetLP(tp)+1500)
end)

--最后的赌博
local function dicecon(e,tp)
	return Duel.GetTurnCount()>=3 and Duel.GetTurnPlayer()==tp and Duel.GetFlagEffect(tp,3280747)==0 and Duel.GetMatchingGroupCount(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)>=2
end
local function diceop(e,tp)
	Duel.RegisterFlagEffect(tp,3280747,0,0,0)
	local lp=Duel.GetLP(tp)
	Duel.SetLP(tp,100)
	Duel.DiscardHand(tp,aux.TRUE,2,2,REASON_COST,nil)

	local dice=Duel.TossDice(tp,1)
	Duel.Draw(tp,dice,REASON_RULE)
end
standbyPhaseSkill(3280747, diceop, dicecon, false)

----幸运的朋友
local function coincon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and Duel.GetLP(tp)<=1000
end
local function coinop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,37812118)
	local res={Duel.GetCoinResult()}
	local ct=ev
	for i=1,ct do
		res[i]=1
	end
	Duel.SetCoinResult(table.unpack(res))
end
oneTimeSkill(37812118, function(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,37812118,0,0,0)
	local rc=Duel.GetMatchingGroup(nil,tp,0xff,0,nil):GetFirst()
	local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TOSS_COIN_NEGATE)
	e1:SetCondition(coincon)
	e1:SetOperation(coinop)
	Duel.RegisterEffect(e1,tp)
end)

--神秘抽卡
local function hdchangecon(e,tp)
	return Duel.GetTurnPlayer()==tp and Duel.GetMatchingGroupCount(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)>=1 and Duel.GetFlagEffect(tp,48712196)==0 and Duel.GetFlagEffect(tp,48712195)<3
end
local function hdchangeop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(sg,nil,2,REASON_RULE)
	Duel.Draw(tp,1,REASON_RULE)
	Duel.RegisterFlagEffect(tp,48712195,0,0,0)
	Duel.RegisterFlagEffect(tp,48712196,RESET_PHASE+PHASE_END,0,0)
end
mainphaseSkill(48712195, hdchangeop, hdchangecon, false)

--成金
oneTimeSkill(70368879, function(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_RULE)
	Duel.Draw(1-tp,1,REASON_RULE)
end)

--天平
oneTimeSkill(67443336, function(e,tp,eg,ep,ev,re,r,rp)
	need_shuffle[tp]=false
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local hand_count=#hg
	Duel.SendtoDeck(hg,nil,0,REASON_RULE)
	Duel.ShuffleDeck(tp)
	local dg=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local deck_count=#dg
	local type_cards={}
	local type_count={}
	local current_type=TYPE_MONSTER
	while current_type<=TYPE_TRAP do
		type_cards[current_type]=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_DECK,0,nil,current_type)
		type_count[current_type]=#type_cards[current_type]
		current_type=current_type<<1
	end

	local draw_type_count={}
	local draw_type_count_precise={}
	local draw_type_count_tweaked={}
	current_type=TYPE_MONSTER
	local total_draw_count=0
	while current_type<=TYPE_TRAP do
		draw_type_count_precise[current_type]=type_count[current_type]*hand_count/deck_count
		draw_type_count[current_type]=math.floor(draw_type_count_precise[current_type] + 0.5)
		draw_type_count_tweaked[current_type]=draw_type_count[current_type]-draw_type_count_precise[current_type]
		total_draw_count=total_draw_count+draw_type_count[current_type]
		current_type=current_type<<1
	end

	local difference=total_draw_count-hand_count
	-- 这里是四舍五入的结果，但是可能有偏差
	while difference>0 do
		-- 抽多了，需要找一个偏差最大的少抽
		local max_tweaked=0
		local max_tweaked_type=0
		current_type=TYPE_MONSTER
		while current_type<=TYPE_TRAP do
			if draw_type_count_tweaked[current_type]>max_tweaked then
				max_tweaked=draw_type_count_tweaked[current_type]
				max_tweaked_type=current_type
			end
			current_type=current_type<<1
		end
		draw_type_count[max_tweaked_type]=draw_type_count[max_tweaked_type]-1
		draw_type_count_tweaked[max_tweaked_type]=draw_type_count[max_tweaked_type]-draw_type_count_precise[max_tweaked_type]
		difference=difference-1
	end

	while difference<0 do
		-- 抽少了，需要找一个偏差最小的多抽
		local min_tweaked=0
		local min_tweaked_type=0
		current_type=TYPE_MONSTER
		while current_type<=TYPE_TRAP do
			if draw_type_count_tweaked[current_type]<min_tweaked then
				min_tweaked=draw_type_count_tweaked[current_type]
				min_tweaked_type=current_type
			end
			current_type=current_type<<1
		end
		draw_type_count[min_tweaked_type]=draw_type_count[min_tweaked_type]+1
		draw_type_count_tweaked[min_tweaked_type]=draw_type_count[min_tweaked_type]-draw_type_count_precise[min_tweaked_type]
		difference=difference+1
	end

	current_type=TYPE_TRAP
	while current_type>=TYPE_MONSTER do
		local g=type_cards[current_type]
		local sg=g:RandomSelect(tp,draw_type_count[current_type])
		for tc in aux.Next(sg) do
			Duel.MoveSequence(tc,SEQ_DECKTOP)
		end
		current_type=current_type>>1
	end
	Duel.Draw(tp,hand_count,REASON_RULE)
end,true)

local function addMakerPool(code, codeList)
	table.sort(codeList)
	oneTimeSkill(code, function (e,tp,eg,ep,ev,re,r,rp)
		local afilter = {codeList[1], OPCODE_ISCODE}
		for i = 2, #codeList do
			table.insert(afilter,codeList[i])
			table.insert(afilter,OPCODE_ISCODE)
			table.insert(afilter,OPCODE_OR)
		end
		local g = Group.CreateGroup()
		for i = 1, 3 do
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_CODE)
			local ac=Duel.AnnounceCard(tp, table.unpack(afilter))
			g:AddCard(Duel.CreateToken(tp, ac))
		end
		Duel.SendtoDeck(g, tp, 2, REASON_RULE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0, 1)
		e1:SetValue(HALF_DAMAGE)
		e1:SetCondition(function (_e)
			local ph=Duel.GetCurrentPhase()
			local _tp = _e:GetHandlerPlayer()
			return (ph >= PHASE_BATTLE_START and ph <= PHASE_BATTLE) and Duel.GetTurnPlayer() == _tp
		end)
			Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE + PHASE_BATTLE)
		e2:SetCondition(function (_e, _tp)
			return Duel.GetTurnPlayer() == _tp
		end)
			e2:SetOperation(function (_e)
			e1:Reset()
			_e:Reset()
		end)
			Duel.RegisterEffect(e2,tp)
	end,true)
	oneTimeSkill(code, function (e,tp,eg,ep,ev,re,r,rp)
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_HAND_LIMIT)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(3)
		Duel.RegisterEffect(e1,tp)
	end)
end

--幻惑之眼
addMakerPool(23446369, {32731036,94689206,72270339,76794549,4928565,6637331,33854624,72656408,60764609,572850,65734501,73956664,36521307,35844557,34022970,78872731,37961969,81275020,13533678,76145933,74078255,17266660,9674034,90241276,44362883,52947044,85106525,98567237,77103950,93729896,21076084,92714517,80453041,48905153,24094258,29301450,49867899,2463794})
--无脸幻想魔术师
addMakerPool(15173384, {68304193,1845204,2295440,18144506,32807846,35261759,35726888,49238328,72892473,73628505,81439173,83764718,84211599,24224830,48130397,65681983,67723438,73468603,45112597,38342335,45819647,2857636,8264361,9839945,30674956,48815792,73309655,97661969,75452921,34755994,41999284,60303245,94259633,74586817,90953320,93039339,75433814,6983839,90590303,46772449,66011101,86066372})

--霸道灵摆
local function emcheck(c)
	return c:IsSetCard(0x99,0x98,0x9f,0x20f8,0x10f8)
end
oneTimeSkill(76840111, function(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(emcheck,tp,LOCATION_DECK+LOCATION_HAND,0,10,nil) then
		Duel.RegisterFlagEffect(tp,76840111,0,0,1)
		local pc1=Duel.CreateToken(tp,24094258)
		local pc2=Duel.CreateToken(tp,76794549)
		Duel.Remove(pc1,POS_FACEDOWN,REASON_RULE)
		Duel.SendtoDeck(pc1,tp,0,REASON_RULE)
		Duel.Remove(pc2,POS_FACEDOWN,REASON_RULE)
		Duel.SendtoDeck(pc2,tp,2,REASON_RULE)
		local pc1=Duel.CreateToken(tp,94415058)
		local pc2=Duel.CreateToken(tp,20409757)
		if Duel.SelectYesNo(tp,97) then
			Duel.MoveToField(pc1,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			Duel.MoveToField(pc2,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end)
local function pmcheck(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsAbleToHand()
end
mainphaseSkillEx(76840111,
function(e,tp)
	local g=Duel.GetMatchingGroup(pmcheck,tp,LOCATION_EXTRA,0,nil)
	Duel.SendtoHand(g:Select(tp,1,1,nil),tp,REASON_RULE)
end,
function(e,tp)
	local g=Duel.GetMatchingGroup(pmcheck,tp,LOCATION_EXTRA,0,nil)
	return #g>0 and Duel.GetFlagEffect(tp,76840111)>0
end,
false,1,76840112)

--三幻神
local function MRcheck(c)
	return c:IsCode(83764718) and c:IsAbleToHand()
end
local exgodlist={79339613,85182315,85758066,59094601,79868386,269012,39913299,5253985,7373632,32247099,79387392,42166000}
local function godcheck(c)
	local bool=false
	local code=c:GetCode()
	for i,v in ipairs(exgodlist) do
		if v==code then bool=true break end
	end
	if aux.IsCodeOrListed(c,10000000) or aux.IsCodeOrListed(c,10000010) or aux.IsCodeOrListed(c,10000020) then bool=true end
	return bool
end
local function godthcheck(c)
	return godcheck(c) and c:IsAbleToHand()
end
local function disgodcheck(c)
	return godcheck(c) and c:IsDiscardable()
end
mainphaseSkillList(78665705,
{
	op=function(e,tp)
		local g=Duel.GetMatchingGroup(MRcheck,tp,LOCATION_GRAVE,0,nil)
		Duel.SendtoHand(g:Select(tp,1,1,nil),tp,REASON_RULE)
	end,
	con=function(e,tp) 
		local g=Duel.GetMatchingGroup(MRcheck,tp,LOCATION_GRAVE,0,nil)
		return #g>0
	end,
	count=1,
	countid=78665705,
	duellimit=true,
	desc=1110
},
{
	op=function(e,tp)
		local g=Duel.GetMatchingGroup(godthcheck,tp,LOCATION_DECK,0,nil)
		if Duel.DiscardHand(tp,disgodcheck,1,1,REASON_RULE+REASON_DISCARD,nil,REASON_EFFECT)>0 then
			Duel.SendtoHand(g:Select(tp,1,1,nil),tp,REASON_RULE)
		end
	end,
		con=function(e,tp) 
		local g=Duel.GetMatchingGroup(godthcheck,tp,LOCATION_DECK,0,nil)
		return #g>0 and Duel.IsExistingMatchingCard(disgodcheck,tp,LOCATION_HAND,0,1,nil,REASON_RULE)
	end,
	count=3,
	countid=78665706,
	desc=1104
}
)
local function godaclimit(e,re,tp)
	local rc=re:GetHandler()
	return not godcheck(rc) and rc:IsType(TYPE_MONSTER+TYPE_TRAP)
end
local function godsplimit(e,c)
	return not godcheck(c)
end
oneTimeSkill(78665705, function(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(godaclimit)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(godsplimit)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e3,tp)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e4,tp)
	local gc1=Duel.CreateToken(tp,12930501)
	local gc2=Duel.CreateToken(tp,10000010)
	Duel.Remove(gc1,POS_FACEDOWN,REASON_RULE)
	Duel.SendtoGrave(gc1,REASON_RULE)
	Duel.Remove(gc2,POS_FACEDOWN,REASON_RULE)
	Duel.SendtoGrave(gc2,REASON_RULE)
end)

--电子龙
local function cyberfilter(c)
	return c:IsSetCard(0x93) and c:IsType(TYPE_MONSTER)
end
oneTimeSkill(77565204, function(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cyberfilter,tp,LOCATION_DECK+LOCATION_HAND,0,10,nil) then
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_MACHINE))
		e1:SetValue(5)
		Duel.RegisterEffect(e1,tp)
		local ec1=Duel.CreateToken(tp,1546123)
		local ec2=Duel.CreateToken(tp,84058253)
		local ec3=Duel.CreateToken(tp,46724542)
		local g=Group.FromCards(ec1,ec2,ec3)
		Duel.Remove(g,POS_FACEDOWN,REASON_RULE)
		Duel.SendtoDeck(g,tp,2,REASON_RULE)
		Duel.RegisterFlagEffect(tp,77565204,0,0,1)
	end
end)
local function msplimit1(e,re,tp)
	local c=re:GetHandler()
	return c:IsType(TYPE_MONSTER) and not c:IsRace(RACE_MACHINE+RACE_DRAGON)
end
local function msplimit2(e,re,tp)
	local c=re:GetHandler()
	return c:IsType(TYPE_MONSTER) and not c:IsRace(RACE_MACHINE)
end
local function cybertograve(c,tp)
	return c:IsRace(RACE_MACHINE) and c:IsAbleToGrave() and Duel.GetMZoneCount(tp,c,tp)>=2
end
mainphaseSkillList(77565204,
{
	op=function(e,tp)
		local gc1=Duel.CreateToken(tp,77625948)
		local gc2=Duel.CreateToken(tp,41230939)
		local gc3=Duel.CreateToken(tp,3019642)
		local gc4=Duel.CreateToken(tp,70095154)
		local g=Group.FromCards(gc1,gc2,gc3,gc4)
		Duel.Remove(g,POS_FACEDOWN,REASON_RULE)
		Duel.SendtoGrave(g,REASON_RULE)
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(msplimit1)
		Duel.RegisterEffect(e1,tp)
	end,
	con=function(e,tp) 
		return Duel.GetFlagEffect(tp,77565204)>0
	end,
	count=1,
	countid=77565205,
	duellimit=true,
	desc=1103
},
{
	op=function(e,tp)
		local g=Duel.GetMatchingGroup(cybertograve,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,tp)
		if Duel.SendtoGrave(g:Select(tp,1,1,nil),REASON_RULE)>0 then
			for i=1,2 do
				local token=Duel.CreateToken(tp,26439287)
				Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
			end
			Duel.SpecialSummonComplete()
		end
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,0)
		e1:SetValue(msplimit2)
		Duel.RegisterEffect(e1,tp)
	end,
		con=function(e,tp) 
		local g=Duel.GetMatchingGroup(cybertograve,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,tp)
		return Duel.GetFlagEffect(tp,77565204)>0 and #g>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,26439287,0x1093,TYPES_TOKEN_MONSTER,1100,600,3,RACE_MACHINE,ATTRIBUTE_LIGHT,POS_FACEUP_ATTACK) and not Duel.IsPlayerAffectedByEffect(tp,59822133)
	end,
	count=1,
	countid=77565205,
	duellimit=true,
	desc=1075
}
)

--革命的时花
local function fleurfilter(c)
	return c:IsAttack(2900) and c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_MONSTER)
end
oneTimeSkill(19642774, function(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(fleurfilter,tp,LOCATION_DECK+LOCATION_HAND,0,7,nil) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SUMMON_PROC)
		e1:SetTargetRange(LOCATION_HAND,0)
		e1:SetCondition(function(e,c,minc)
			if c==nil then return true end
			return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		end)
		e1:SetTarget(function (e,c)
			return c:IsAttack(2900) and c:IsRace(RACE_SPELLCASTER)
		end)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,19642774,0,0,1)
	end
end)
function fleurtoDeckfilter(c,tp)
	return c:IsAbleToDeck() and Duel.GetMZoneCount(tp,c,tp)>0
end
function fleurtoLvfilter(c,tp)
	return c:IsFaceup() and c:IsLevelAbove(2)
end
mainphaseSkillList(19642774,
{
	op=function(e,tp) 
		local g=Duel.GetMatchingGroup(fleurtoDeckfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,tp)
		if Duel.SendtoDeck(g:Select(tp,1,1,nil),tp,2,REASON_RULE)>0 then
			local token=Duel.CreateToken(tp,48421595)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
			local g=Duel.GetMatchingGroup(fleurtoLvfilter,tp,LOCATION_MZONE,0,nil):CancelableSelect(tp,1,1,nil)
			if g then
				local tc=g:GetFirst()
				local lv=1
				if tc:IsLevelAbove(3) then lv=Duel.AnnounceNumber(tp,1,2) end
				local e1=Effect.CreateEffect(token)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_LEVEL)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(-lv)
				tc:RegisterEffect(e1)
			end
		end
	end,
	con=function(e,tp) 
		local g=Duel.GetMatchingGroup(fleurtoDeckfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,tp)
		return Duel.GetFlagEffect(tp,19642774)>0 and #g>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,48421595,0x1017,TYPES_TOKEN_MONSTER+TYPE_TUNER,200,400,2,RACE_MACHINE,ATTRIBUTE_DARK,POS_FACEUP)
	end,
	count=1,
	countid=19642775,
	duellimit=true,
	desc=1118
},
{
	op=function(e,tp) 
		local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,TYPE_MONSTER)
		if Duel.SendtoGrave(g:Select(tp,1,1,nil),REASON_RULE)>0 then
			local token=Duel.CreateToken(tp,36405256)
			Duel.SendtoHand(token,tp,REASON_RULE)
		end
	end,
	con=function(e,tp) 
		local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,TYPE_MONSTER)
		return Duel.GetFlagEffect(tp,19642774)>0 and #g>0 
	end,
	count=1,
	countid=19642776,
	desc=1190
}
)

--蓝天使
oneTimeSkill(91706817, function(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK+LOCATION_HAND,0,8,nil,0xfb) then
		local e1=Effect.GlobalEffect()
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetCondition(Duel.IsBattlePhase)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsOriginalCodeRule,35199656))
		e1:SetValue(61283655)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,91706817,0,0,1)
	end
end)
function tricktoGravefilter(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xfb) and c:IsType(TYPE_MONSTER)
end
function trickspfilter(c,e,tp)
	return c:IsCode(32448765) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
mainphaseSkillList(91706817,
{
	op=function(e,tp) 
		local token=Duel.CreateToken(tp,35199656)
		Duel.SendtoHand(token,tp,REASON_RULE)
	end,
	con=function(e,tp) 
		return Duel.GetFlagEffect(tp,91706817)>0
	end,
	count=1,
	countid=91706818,
	desc=1190
},
{
	op=function(e,tp) 
		local g1=Duel.GetMatchingGroup(tricktoGravefilter,tp,LOCATION_DECK,0,nil)
		local g2=Duel.GetMatchingGroup(trickspfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		if Duel.SendtoGrave(g1:Select(tp,2,2,nil),REASON_RULE)>0 then
			Duel.SpecialSummon(g2:Select(tp,1,1,nil),0,tp,tp,false,false,POS_FACEUP)
		end
	end,
	con=function(e,tp) 
		local g1=Duel.GetMatchingGroup(tricktoGravefilter,tp,LOCATION_DECK,0,nil)
		local g2=Duel.GetMatchingGroup(trickspfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		return Duel.GetFlagEffect(tp,91706817)>0 and #g1>=2 and #g2>0
	end,
	count=1,
	countid=91706819,
	duellimit=true,
	desc=1118
}
)
local function beastfilter(c)
	return c:IsCode(69890967,32491822,6007213)
end
--幻魔
oneTimeSkill(93224848, function(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(beastfilter,tp,0xff,0,nil)
	for tc in aux.Next(g) do
		local re1={tc:IsHasEffect(EFFECT_SPSUMMON_CONDITION)}
		for _,te in pairs(re1) do
			if te:GetOwner()==tc then
				local value=te:GetValue()
				te:SetValue(function (e,se,sp,st)
					return sp==e:GetHandler():GetControler() or value(e,se,sp,st)
				end)
			end
		end
		local re2={tc:IsHasEffect(EFFECT_REVIVE_LIMIT)}
		for _,te in pairs(re2) do
			if te:GetOwner()==tc then
				te:Reset()
			end
		end
	end
end)
function beastthfilter(c)
	return (c:IsCode(6007213,32491822,69890967)
		or aux.IsCodeListed(c,6007213) or aux.IsCodeListed(c,32491822) or aux.IsCodeListed(c,69890967)) and c:IsAbleToHand()
end
function beasttdfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck() and Duel.GetMZoneCount(tp,c,tp)>0
end
function beastspfilter(c,e,tp)
	return c:IsCode(6007213,32491822,69890967) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
mainphaseSkillList(93224848,
{
	op=function(e,tp)
		local cg=Duel.GetMatchingGroup(beastfilter,tp,LOCATION_HAND,0,nil)
		if #cg>1 then cg=cg:Select(tp,1,1,nil) end
		Duel.ConfirmCards(1-tp,cg)
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
		if Duel.SendtoDeck(g:Select(tp,1,1,nil),tp,2,REASON_RULE)>0 then
			local tg=Duel.GetMatchingGroup(beastthfilter,tp,LOCATION_DECK,0,nil)
			Duel.SendtoHand(tg:Select(tp,1,1,nil),tp,REASON_RULE)
		end	   
	end,
	con=function(e,tp)
		local cg=Duel.GetMatchingGroup(beastfilter,tp,LOCATION_HAND,0,nil)
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
		local tg=Duel.GetMatchingGroup(beastthfilter,tp,LOCATION_DECK,0,nil)
		return #cg>0 and #g>0 and #tg>0
	end,
	count=2,
	countid=93224848,
	desc=1190
},
{
	op=function(e,tp) 
		local g1=Duel.GetMatchingGroup(beasttdfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,tp)		
		if Duel.SendtoDeck(g1:Select(tp,1,1,nil),tp,2,REASON_RULE)>0 then
			local g2=Duel.GetMatchingGroup(beastspfilter,tp,LOCATION_DECK,0,nil,e,tp)
			Duel.SpecialSummon(g2:Select(tp,1,1,nil),0,tp,tp,false,false,POS_FACEUP)
		end
	end,
	con=function(e,tp) 
		local g1=Duel.GetMatchingGroup(beasttdfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,tp)
		local g2=Duel.GetMatchingGroup(beastspfilter,tp,LOCATION_DECK,0,nil,e,tp)
		return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_GRAVE)>0 and #g1>=2 and #g2>0
	end,
	count=1,
	countid=93224849,
	desc=1118
}
)

local function initialize(e,_tp,eg,ep,ev,re,r,rp)
	local skillCodes=getAllSkillCodes()
	for tp=0,1 do
		local codes={}
		for _,code in ipairs(skillCodes) do
			table.insert(codes,code)
		end
		table.sort(codes)
		local afilter={codes[1],OPCODE_ISCODE}
		if #codes>1 then
			for i=2,#codes do
				table.insert(afilter,codes[i])
				table.insert(afilter,OPCODE_ISCODE)
				table.insert(afilter,OPCODE_OR)
			end
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		local ac=Duel.AnnounceCardSilent(tp,table.unpack(afilter))
		skillSelections[tp]=ac
	end
	for tp=0,1 do
		registerSkillForPlayer(tp,skillSelections[tp])
	end
	-- resolve onetime skills
	-- for _,onetimeSkillList in ipairs({onetimeSkillResolveOperationsPrior,onetimeSkillResolveOperations}) do
	local function resolveOnetimeSkill(onetimeSkillList)
		for tp=0,1 do
			for _,onetimeSkillObject in ipairs(onetimeSkillList[tp]) do
				Duel.Hint(HINT_CARD,0,onetimeSkillObject.code)
				onetimeSkillObject.op(e,onetimeSkillObject.tp,eg,ep,ev,re,r,rp)
			end
		end
	end
	resolveOnetimeSkill(onetimeSkillResolveOperationsPrior)
	for tp=0,1 do
		if need_shuffle[tp] then
			local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
			local hand_count=#hg
			Duel.SendtoDeck(hg,nil,0,REASON_RULE)
			Duel.ShuffleDeck(tp)
			Duel.Draw(tp,hand_count,REASON_RULE)
		end
	end
	resolveOnetimeSkill(onetimeSkillResolveOperations)
end

function Auxiliary.PreloadUds()
	-- disable field
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetValue(0x110011)
	Duel.RegisterEffect(e1,0)

	-- skip m2
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SKIP_M2)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	Duel.RegisterEffect(e1,0)

	-- half effect damage
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(function(e,re,val,r,rp,rc)
		if bit.band(r,REASON_EFFECT)~=0 then return math.floor(val/2)
		else return val end
	end)
	Duel.RegisterEffect(e1,0)

	-- skill init
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		initialize(e,tp,eg,ep,ev,re,r,rp)
		e:Reset()
	end)
	Duel.RegisterEffect(e1,0)
end

-- disable EFFECT_SKIP_M1
EFFECT_SKIP_M1=0

-- 正对面的自身的主要怪兽区域（群豪）
function aux.FrontSequence(c)
	local seq = c:GetSequence()
	local list = {}
	if c:IsLocation(LOCATION_PZONE) then
		list = {
			[0] = 1,
			[4] = 3
		}
	end
	return 1 << (list[seq] or seq)
end
