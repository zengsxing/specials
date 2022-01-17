--村规决斗：魔法圣界
--怪兽因对方原因以战斗以外的方式离场时，
--给予对方那个原本攻击力数值的伤害。
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

function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
	--special summon
	local e1=Effect.GlobalEffect()
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetOperation(CUNGUI.spop)
	Duel.RegisterEffect(e1,0)
	e:Reset()
end

function CUNGUI.cfilter(c)
	local tp=c:GetOwner()
	local rp=c:GetReasonPlayer()
	return rp==1-tp and not c:IsReason(REASON_BATTLE)
end
function CUNGUI.spop(e,tp,eg,ep,ev,re,r,rp)
	if not eg then return end
	local g = eg:Filter(CUNGUI.cfilter,nil)
	local dam0=0
	local dam1=0
	local tc=g:GetFirst()
	while tc do
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		if tc:GetOwner() == 1 then
			dam0=dam0+atk
		else
			dam1=dam1+atk
		end
		tc=eg:GetNext()
	end
	Duel.Damage(0,dam0,REASON_RULE)
	Duel.Damage(1,dam1,REASON_RULE)
end
