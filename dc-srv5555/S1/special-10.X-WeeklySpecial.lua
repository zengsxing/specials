--村规决斗：不关你事
--所有（入连锁的）效果得到以下追加文本：
--这个效果的发动是自己这个回合第一次把效果发动的场合，
--这个效果的发动和效果不能被无效化，对方不能针对这个效果的发动把魔法·陷阱·怪兽的效果发动。

CUNGUI = {}
CUNGUI.used={}

CUNGUI.Registered = Group.CreateGroup()
CUNGUI.PropertySaver = {}
local OrigRegisterEffect = Card.RegisterEffect

Card.RegisterEffect = function(c,e)
	local target = e:GetTarget()
	local typ = e:GetType()
	if typ and (typ & 0x7d0)>0 then
		e:SetTarget(CUNGUI.GetNewTarget(target))
	end
	OrigRegisterEffect(c,e)
end

function CUNGUI.GetNewTarget(target)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chk==0 then
			if not target then return true end
			return target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		end
		if CUNGUI.PropertySaver[e] then
			e:SetProperty(CUNGUI.PropertySaver[e])
			CUNGUI.PropertySaver[e]=false
		end
		if not CUNGUI.used[tp] and e:IsHasType(0x7d0) then
			CUNGUI.used[tp]=true
			if not CUNGUI.PropertySaver[e] then CUNGUI.PropertySaver[e]=e:GetProperty() end
			local prop=CUNGUI.PropertySaver[e]
			prop = prop | 0x2000600
			e:SetProperty(prop)
			Duel.SetChainLimit(CUNGUI.climit)
		end
		if not target then return true end
		return target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	end
end
function CUNGUI.climit(e,ep,tp)
	return tp==ep
end
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

function CUNGUI.AdjustOperation()
	CUNGUI.used[0]=false
	CUNGUI.used[1]=false
end