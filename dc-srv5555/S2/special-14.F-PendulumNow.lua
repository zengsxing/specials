--村规决斗：即刻开摆
--游戏开始时，各自从卡组外将1张【霸王门 零】和1张【霸王门 无限】在灵摆区域发动。
--这些卡的所有效果和效果外文本在这场决斗中不适用（改变过位置也不适用）；
--因任何原因不在灵摆区域的场合，那个控制者灵摆区域的这两张卡以外的卡送去额外卡组，那些不在的卡在灵摆区域发动。

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
CUNGUI.Exceptions=Group.CreateGroup()
CUNGUI.origE=Card.RegisterEffect
Card.RegisterEffect = function(c,e,forced)
	if CUNGUI.Exceptions:IsContains(c) then return false end
	return CUNGUI.origE(c,e,forced)
end

function CUNGUI.AdjustOperation2(e,tp,eg,ep,ev,re,r,rp)
	local g = Duel.GetMatchingGroup(Card.IsCode,0,0x7f-LOCATION_HAND-LOCATION_ONFIELD,0x7f-LOCATION_HAND-LOCATION_ONFIELD,nil,10000)
	if #g > 0 then
		Duel.SendtoHand(g,REASON_RULE+REASON_RETURN)
	end
end

function CUNGUI.EnablePendulumAttribute(c,reg)
	if not Auxiliary.PendulumChecklist then
		Auxiliary.PendulumChecklist=0
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(Auxiliary.PendulumReset)
		Duel.RegisterEffect(ge1,0)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1163)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(Auxiliary.PendCondition())
	e1:SetOperation(Auxiliary.PendOperation())
	e1:SetValue(SUMMON_TYPE_PENDULUM)
	CUNGUI.origE(c,e1)
	--register by default
	if reg==nil or reg then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(1160)
		e2:SetType(EFFECT_TYPE_ACTIVATE)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetRange(LOCATION_HAND)
		CUNGUI.origE(c,e2)
	end
end
function CUNGUI.InitPlayer(tp)
	local xre=Card.RegisterEffect
	Card.RegisterEffect = function() return false end
	local card1 = Duel.CreateToken(tp,22211622)
	local card2 = Duel.CreateToken(tp,96227613)
	Card.RegisterEffect = xre
	CUNGUI.EnablePendulumAttribute(card1)
	CUNGUI.EnablePendulumAttribute(card2)
	Duel.MoveToField(card1,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	Duel.MoveToField(card2,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	local g=Group.CreateGroup()
	g:AddCard(card1)
	g:AddCard(card2)
	g:KeepAlive()
	CUNGUI.Exceptions:AddCard(card1)
	CUNGUI.Exceptions:AddCard(card2)
	--return
	local e2=Effect.CreateEffect(card1)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetLabelObject(g)
	e2:SetOperation(CUNGUI.PCardReturnToField)
	Duel.RegisterEffect(e2,tp)
end

function CUNGUI.PCardReturnToField(e,tp)
	local g=e:GetLabelObject()
	local pzcard=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	for tc in aux.Next(pzcard) do
		if not g:IsContains(tc) then
			Duel.SendtoExtraP(tc,nil,REASON_RULE)
		end
	end
	for tc in aux.Next(g) do
		if not tc:IsLocation(LOCATION_PZONE) then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
	if not CUNGUI.INIT then
		CUNGUI.INIT = true
		CUNGUI.InitPlayer(0)
		CUNGUI.InitPlayer(1)
	end
end