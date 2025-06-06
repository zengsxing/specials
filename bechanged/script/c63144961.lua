--セイヴァー・アブソープション
function c63144961.initial_effect(c)
	aux.AddCodeList(c,44508094,7841112,21159309,63436931,70902743)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,63144961)
	e1:SetTarget(c63144961.target)
	e1:SetOperation(c63144961.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(63144961,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,63144962)
	e2:SetTarget(c63144961.target2)
	e2:SetOperation(c63144961.activate2)
	c:RegisterEffect(e2)
end
function c63144961.fffilter(c,e,tp,ft)
	return (c:IsCode(63436931) or c:IsSetCard(0x3f)) and c:IsType(TYPE_SYNCHRO) and Duel.IsExistingMatchingCard(c63144961.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c,e,tp,ft)
end
function c63144961.spfilter(c,fc,e,tp,ft)
	return (c:IsCode(70902743,44508094,21159309) or aux.IsCodeListed(c,70902743) or aux.IsCodeListed(c,44508094) or aux.IsCodeListed(c,21159309)) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function c63144961.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c63144961.fffilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp,ft) end
end
function c63144961.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,c63144961.fffilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp,ft):GetFirst()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c63144961.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tc,e,tp,ft)
		local cc=g:GetFirst()
		if cc then
			if cc:IsAbleToHand() and (not cc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 or Duel.SelectOption(tp,1190,1152)==0) then
				Duel.SendtoHand(cc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,cc)
			else
				Duel.SpecialSummon(cc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c63144961.filter(c)
	return c:IsFaceup() and (c:IsCode(44508094) or c:IsType(TYPE_SYNCHRO) and aux.IsCodeListed(c,44508094))
end
function c63144961.eqfilter(c)
	return c:IsFaceup() and c:IsAbleToChangeControler()
end
function c63144961.dafilter(c)
	return c63144961.filter(c) and not c:IsHasEffect(EFFECT_DIRECT_ATTACK)
end
function c63144961.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c63144961.filter(chkc) end
	local b1=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c63144961.eqfilter,tp,0,LOCATION_MZONE,1,nil)
	local b2=aux.bpcon(e,tp,eg,ep,ev,re,r,rp)
		and Duel.IsExistingTarget(c63144961.dafilter,tp,LOCATION_MZONE,0,1,nil)
	local b3=aux.bpcon(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return (b1 or b2 or b3)
		and Duel.IsExistingTarget(c63144961.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c63144961.filter,tp,LOCATION_MZONE,0,1,1,nil)
	b2=aux.bpcon(e,tp,eg,ep,ev,re,r,rp) and not g:GetFirst():IsHasEffect(EFFECT_DIRECT_ATTACK)
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(63144961,0)
		opval[off-1]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(63144961,1)
		opval[off-1]=1
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(63144961,2)
		opval[off-1]=2
		off=off+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local sel=Duel.SelectOption(tp,table.unpack(ops))
	local op=opval[sel]
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_EQUIP)
		Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	else
		e:SetCategory(0)
	end
end
function c63144961.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	local op=e:GetLabel()
	if op==0 then
		if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local g=Duel.SelectMatchingCard(tp,c63144961.eqfilter,tp,0,LOCATION_MZONE,1,1,nil)
			local ec=g:GetFirst()
			if ec then
				if not Duel.Equip(tp,ec,tc) then return end
				--equip limit
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetLabelObject(tc)
				e1:SetValue(c63144961.eqlimit)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				ec:RegisterEffect(e1)
			end
		end
	elseif op==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	else
		tc:RegisterFlagEffect(63144961,RESET_EVENT+RESETS_STANDARD,0,1,tc:GetFieldID())
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BATTLE_DESTROYING)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetCondition(c63144961.damcon)
		e1:SetOperation(c63144961.damop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c63144961.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c63144961.damcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local fid=tc:GetFlagEffectLabel(63144961)
	local bc=tc:GetBattleTarget()
	return fid and fid==tc:GetFieldID() and tc==eg:GetFirst() and tc:IsRelateToBattle() and bc and bc:GetPreviousControler()==1-tp
end
function c63144961.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local bc=tc:GetBattleTarget()
	if not bc then return end
	local dam=bc:GetBaseAttack()
	if dam>0 then
		Duel.Hint(HINT_CARD,0,63144961)
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end