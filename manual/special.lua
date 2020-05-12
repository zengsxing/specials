Duel.LoadScript("underscore.lua")
local function grantAll(e,tg,r)
	local e3=Effect.GlobalEffect()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetProperty((r and 0 or EFFECT_FLAG_IGNORE_RANGE)+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	local tr=r or 0xff
	e3:SetTargetRange(tr,tr)
	e3:SetLabelObject(e)
	if tg then
		e3:SetTarget(tg)
	end
	Duel.RegisterEffect(e3,0)
end

local function grantDecktop(e)
	local e3=Effect.GlobalEffect()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTargetRange(LOCATION_DECK,LOCATION_DECK)
	e3:SetTarget(function(e,c)
		local tp=c:GetControler()
		local dg=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
		local g=dg:GetMinGroup(Card.GetSequence)
		return g:GetFirst()==c
	end)
	e3:SetLabelObject(e)
	Duel.RegisterEffect(e3,0)
end

local function fieldEffect(r)
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(r)
	return e1
end

local function deckEffect()
	return fieldEffect(LOCATION_DECK)
end

function Auxiliary.PreloadUds()
	--deck effects for card
	local e1=deckEffect()
	e1:SetDescription(1105)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0xff-LOCATION_DECK,0xff,1,99,nil)
		if #g>0 then
			local pos=Duel.SelectPosition(tp,g:GetFirst(),POS_ATTACK)
			Duel.SendtoDeck(g,tp,pos==POS_FACEUP_ATTACK and 0 or 1,REASON_RULE)
		end
	end)
	grantDecktop(e1)
	local e1=deckEffect()
	e1:SetDescription(1104)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0xff-LOCATION_HAND,0xff,1,99,nil)
		if #g>0 then
			Duel.SendtoHand(g,tp,REASON_RULE)
		end
	end)
	grantDecktop(e1)
	local e1=deckEffect()
	e1:SetDescription(1103)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0xff-LOCATION_GRAVE,0,1,99,nil)
		if #g>0 then
			Duel.SendtoGrave(g,REASON_RULE)
		end
	end)
	grantDecktop(e1)
	local e1=deckEffect()
	e1:SetDescription(1102)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0xff-LOCATION_REMOVED,0,1,99,nil)
		if #g>0 then
			local pos=Duel.SelectPosition(tp,g:GetFirst(),POS_ATTACK)
			Duel.Remove(g,pos,REASON_RULE)
		end
	end)
	grantDecktop(e1)
	local e1=deckEffect()
	e1:SetDescription(1118)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0xff-LOCATION_MZONE,0xff-LOCATION_MZONE,1,99,nil)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP+POS_FACEDOWN)
		end
	end)
	grantDecktop(e1)
	local e1=deckEffect()
	e1:SetDescription(1159)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0xff-LOCATION_SZONE,0xff,1,1,nil)
		if #g>0 then
			local tc=g:GetFirst()
			local loc=LOCATION_SZONE
			if tc:IsType(TYPE_FIELD) then
				loc=LOCATION_FZONE
			elseif tc:IsType(TYPE_PENDULUM) then
				loc=LOCATION_PZONE
			end
			local pos=Duel.SelectPosition(tp,tc,POS_ATTACK)
			Duel.MoveToField(tc,tp,tp,loc,pos,true)
		end
	end)
	grantDecktop(e1)
	local e1=deckEffect()
	e1:SetDescription(1111)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
		if #g>0 then
			local tc=g:GetFirst()
			local pos=Duel.SelectPosition(tp,tc,POS_FACEUP+POS_FACEDOWN)
			Duel.ChangePosition(tc,pos)
		end
	end)
	grantDecktop(e1)
	--deck effects for global
	local e1=deckEffect()
	e1:SetDescription(1297)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		Duel.ShuffleDeck(tp)
		Duel.ShuffleHand(tp)
	end)
	grantDecktop(e1)
	local e1=deckEffect()
	e1:SetDescription(1123)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local acs={}
		for i=-2000,2000,100 do
			if i~=0 then
				_.push(acs,i)
			end
		end
		local _,_ac=Duel.AnnounceNumber(tp,table.unpack(acs))
		local ac=acs[_ac+1]
		if ac>0 then
			Duel.Recover(tp,ac,REASON_RULE)
		elseif ac<0 then
			Duel.Damage(tp,-ac,REASON_RULE)
		end
	end)
	grantDecktop(e1)
	local e1=deckEffect()
	e1:SetDescription(1108)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local ac=Duel.AnnounceNumber(tp,1,2,3,4,5,6,7,8,9,10,11,12)
		Duel.Draw(tp,ac,REASON_RULE)
	end)
	grantDecktop(e1)
	local e1=deckEffect()
	e1:SetDescription(1119)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local ac=Duel.AnnounceCard(tp)
		local tc=Duel.CreateToken(tp,ac)
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
	end)
	grantDecktop(e1)

	--single card effects
	local e1=fieldEffect(LOCATION_ONFIELD)
	e1:SetDescription(1111)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local pos=Duel.SelectPosition(tp,c,POS_FACEUP+POS_FACEDOWN)
		Duel.ChangePosition(c,pos)
	end)
	grantAll(e1,nil,LOCATION_ONFIELD)

	local e1=fieldEffect(LOCATION_MZONE)
	e1:SetDescription(1112)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		Duel.GetControl(c,1-tp)
	end)
	grantAll(e1,nil,LOCATION_MZONE)

	local e1=fieldEffect(LOCATION_MZONE)
	e1:SetDescription(1113)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local acs={}
		for i=-2000,2000,100 do
			if i~=0 then
				_.push(acs,i)
			end
		end
		local _,_ac=Duel.AnnounceNumber(tp,table.unpack(acs))
		local ac=acs[_ac+1]
		local ex=Effect.CreateEffect(c)
		ex:SetType(EFFECT_TYPE_SINGLE)
		ex:SetCode(EFFECT_UPDATE_ATTACK)
		ex:SetValue(ac)
		ex:SetReset(0x1fe1000)
		Card.RegisterEffect(c,ex,true)
		local ex=Effect.CreateEffect(c)
		ex:SetType(EFFECT_TYPE_SINGLE)
		ex:SetCode(EFFECT_UPDATE_DEFENSE)
		ex:SetValue(ac)
		ex:SetReset(0x1fe1000)
		Card.RegisterEffect(c,ex,true)
	end)
	grantAll(e1,nil,LOCATION_MZONE)

	local e1=fieldEffect(LOCATION_MZONE)
	e1:SetDescription(1113)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local g=Duel.SelectMatchingCard(tp,nil,tp,0xff,0xff,1,99,c)
		local og=g:Filter(Card.IsLocation,nil,LOCATION_OVERLAY)
		g:Sub(og)
		local tog=Group.CreateGroup()
		for tc in Auxiliary.Next(g) do
			for oc in Auxiliary.Next(tc:GetOverlayGroup()) do
				if og:IsContains(oc) then
					og:RemoveCard(oc)
					tog:AddCard(oc)
				end
			end
		end
		Duel.Overlay(c,tog)
		Duel.SendtoGrave(og,REASON_RULE)
		Duel.Overlay(tc,g)
	end)
	grantAll(e1,function(e,c) return c:IsType(TYPE_XYZ) end,LOCATION_MZONE)
	local loc=LOCATION_HAND+LOCATION_ONFIELD
	local e1=fieldEffect(loc)
	e1:SetDescription(1105)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Group.FromCards(e:GetHandler())
		if #g>0 then
			local pos=Duel.SelectPosition(tp,g:GetFirst(),POS_ATTACK)
			Duel.SendtoDeck(g,tp,pos==POS_FACEUP_ATTACK and 0 or 1,REASON_RULE)
		end
	end)
	grantAll(e1,nil,loc)
	local loc=LOCATION_ONFIELD
	local e1=fieldEffect(loc)
	e1:SetDescription(1104)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Group.FromCards(e:GetHandler())
		if #g>0 then
			Duel.SendtoHand(g,tp,REASON_RULE)
		end
	end)
	grantAll(e1,nil,loc)
	local loc=LOCATION_HAND+LOCATION_ONFIELD
	local e1=fieldEffect(loc)
	e1:SetDescription(1103)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Group.FromCards(e:GetHandler())
		if #g>0 then
			Duel.SendtoGrave(g,REASON_RULE)
		end
	end)
	grantAll(e1,nil,loc)
	local loc=LOCATION_HAND+LOCATION_ONFIELD
	local e1=fieldEffect(loc)
	e1:SetDescription(1102)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Group.FromCards(e:GetHandler())
		if #g>0 then
			local pos=Duel.SelectPosition(tp,g:GetFirst(),POS_ATTACK)
			Duel.Remove(g,pos,REASON_RULE)
		end
	end)
	grantAll(e1,nil,loc)
	local loc=LOCATION_HAND+LOCATION_SZONE
	local e1=fieldEffect(loc)
	e1:SetDescription(1118)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Group.FromCards(e:GetHandler())
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP+POS_FACEDOWN)
		end
	end)
	grantAll(e1,function(e,c) return c:IsType(TYPE_MONSTER) or (c:GetOriginalType()&TYPE_MONSTER)>0 end,loc)
	local loc=LOCATION_HAND+LOCATION_MZONE
	local e1=fieldEffect(loc)
	e1:SetDescription(1159)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Group.FromCards(e:GetHandler())
		if #g>0 then
			local tc=g:GetFirst()
			local loc=LOCATION_SZONE
			if tc:IsType(TYPE_FIELD) then
				loc=LOCATION_FZONE
			elseif tc:IsType(TYPE_PENDULUM) then
				loc=LOCATION_PZONE
			end
			local pos=Duel.SelectPosition(tp,tc,POS_ATTACK)
			Duel.MoveToField(tc,tp,tp,loc,pos,true)
		end
	end)
	grantAll(e1,nil,loc)

	--spells and traps
	local e1=Effect.GlobalEffect()
	e1:SetDescription(65)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		c:CancelToGrave()
	end)
	grantAll(e1,function(e,c) return c:IsType(TYPE_SPELL+TYPE_TRAP+TYPE_PENDULUM) end)
	local loc=LOCATION_HAND+LOCATION_EXTRA --LOCATION_DECK+LOCATION_GRAVE
	local e1=Effect.GlobalEffect()
	e1:SetDescription(1118)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(loc)
	e1:SetCondition(function(e,c)
		if c==nil then return true end
		local tp=c:GetControler()
		if c:IsLocation(LOCATION_EXTRA) then
			return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		else
			return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		end
	end)
	grantAll(e1,function(e,c) return c:IsType(TYPE_MONSTER) end,loc)
	--effect codes
	for code,value in pairs({
		[EFFECT_QP_ACT_IN_NTPHAND]=1,
		[EFFECT_QP_ACT_IN_SET_TURN]=1,
		[EFFECT_TRAP_ACT_IN_HAND]=1,
		[EFFECT_TRAP_ACT_IN_SET_TURN]=1,
		[EFFECT_DEFENSE_ATTACK]=1,
		[EFFECT_EXTRA_ATTACK]=99,
	}) do
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(code)
		e1:SetValue(value)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	end
	grantAll(e1)

	for tc in aux.Next(Duel.GetFieldGroup(0,0xff,0xff)) do
		local mt=getmetatable(tc)
		mt.initial_effect=Auxiliary.NULL
	end
end
