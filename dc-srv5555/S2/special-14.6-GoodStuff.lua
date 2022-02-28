--村规决斗：传世经典
--开局时，双方查看对方卡组，相互选2张卡。
--双方选好后，那些卡加入各自的额外卡组。
--那些因此加入额外卡组的卡和同名的卡，
--仅限其持有者，在决斗中不能使用。

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
function CUNGUI.ForbidCard(c)
	local tp=c:GetControler()
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_FORBIDDEN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0x7f,0x7f)
	e1:SetTarget(CUNGUI.bantg)
	e1:SetLabel(c:GetCode())
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_TARGET)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetValue(TYPE_PENDULUM)
	c:RegisterEffect(e2)
end
function CUNGUI.bantg(e,c)
	local code1,code2=c:GetOriginalCodeRule()
	local fcode=e:GetLabel()
	return (code1==fcode or code2==fcode)
end
function CUNGUI.AdjustOperation(e)
	local g=Group.CreateGroup()
	for tp=0,1 do
		if #Duel.GetFieldGroup(tp,0,LOCATION_DECK)>1 then
			Duel.ConfirmCards(tp,Duel.GetFieldGroup(tp,0,LOCATION_DECK))
			g:Merge(Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_DECK,2,2,nil))
		end
	end
	g:ForEach(CUNGUI.ForbidCard)
	Duel.SendtoExtraP(g,nil,REASON_RULE)
	e:Reset()
end