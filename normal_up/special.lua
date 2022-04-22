--村规决斗：十倍凡骨
--双方场上的通常怪兽的攻击力·防御力上升那个原本攻击力x9。

CUNGUI = {}

function CUNGUI.Init()
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetLabel(0)
	e1:SetValue(CUNGUI.val)
	Duel.RegisterEffect(e1,0)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetLabel(1)
	Duel.RegisterEffect(e2,0)
end

function CUNGUI.filter(c,race)
	return c:IsFaceup() and c:IsRace(race)
end

function CUNGUI.val(e,c)
	if (c:GetOriginalType() & TYPE_NORMAL)==0 or (c:GetOriginalType() & (TYPE_PENDULUM+TYPE_TOKEN))>0 then return 0 end
	local baseValue = c:GetBaseAttack()
	if e:GetLabel()==1 then baseValue = c:GetBaseDefense() end
	return c:IsOriginalCodeRule(89631139,74677422,46986414) and baseValue*99 or baseValue*9
end

function Auxiliary.PreloadUds()
	-- one more draw
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function(e)
		CUNGUI.Init()
		e:Reset()
	end)
	Duel.RegisterEffect(e1,0)
end
