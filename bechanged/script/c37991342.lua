--クリフォート・ゲノム
function c37991342.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c37991342.splimit)
	c:RegisterEffect(e2)
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(-300)
	c:RegisterEffect(e3)
	--summon with no tribute
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(37991342,0))
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SUMMON_PROC)
	e4:SetCondition(c37991342.ntcon)
	c:RegisterEffect(e4)
	--change level
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SUMMON_COST)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetOperation(c37991342.lvop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_SPSUMMON_COST)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetOperation(c37991342.lvop2)
	c:RegisterEffect(e6)
	--immune
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(c37991342.immcon)
	e7:SetValue(aux.qlifilter)
	c:RegisterEffect(e7)
	--destroy
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(37991342,1))
	e8:SetCategory(CATEGORY_DESTROY)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_RELEASE)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e8:SetTarget(c37991342.destg)
	e8:SetOperation(c37991342.desop)
	c:RegisterEffect(e8)
	--to pzone
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_HAND)
	e9:SetCondition(c37991342.pzcon)
	e9:SetTarget(c37991342.pztg)
	e9:SetOperation(c37991342.pzop)
	c:RegisterEffect(e9)
end
function c37991342.splimit(e,c)
	return not c:IsSetCard(0xaa)
end
function c37991342.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c37991342.lvcon(e)
	return e:GetHandler():GetMaterialCount()==0
end
function c37991342.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c37991342.lvcon)
	e1:SetValue(4)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c37991342.lvcon)
	e2:SetValue(1800)
	e2:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e2)
end
function c37991342.lvop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(4)
	e1:SetReset(RESET_EVENT+0x7f0000)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1800)
	e2:SetReset(RESET_EVENT+0x7f0000)
	c:RegisterEffect(e2)
end
function c37991342.immcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_NORMAL)
end
function c37991342.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c37991342.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c37991342.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c37991342.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c37991342.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c37991342.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c37991342.pzfilter(c)
	return c:IsSetCard(0xaa)
end
function c37991342.pzcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c37991342.pzfilter,tp,LOCATION_PZONE,0,2,nil)
end
function c37991342.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(1-tp,LOCATION_PZONE,0) or Duel.CheckLocation(1-tp,LOCATION_PZONE,1) end
end
function c37991342.pzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not (Duel.CheckLocation(1-tp,LOCATION_PZONE,0) or Duel.CheckLocation(1-tp,LOCATION_PZONE,1)) then return end
	Duel.MoveToField(c,tp,1-tp,LOCATION_PZONE,POS_FACEUP,true)
end
