function Auxiliary.PreloadUds()
	local ex=Effect.GlobalEffect()
	ex:SetType(EFFECT_TYPE_FIELD)
	ex:SetCode(EFFECT_DECREASE_TRIBUTE)
	ex:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_IGNORE_RANGE)
	ex:SetTargetRange(0xff,0xff)
	ex:SetTarget(function(e,c)
		return not c:IsHasEffect(EFFECT_LIMIT_SUMMON_PROC) and not c:IsHasEffect(EFFECT_LIMIT_SET_PROC)
	end)
	ex:SetValue(0xff00ff)
	Duel.RegisterEffect(ex,0)
	local ex2=ex:Clone()
	ex2:SetCode(EFFECT_DECREASE_TRIBUTE_SET)
	Duel.RegisterEffect(ex2,0)
end



function Auxiliary._PreloadUds()
	local _register=Card.RegisterEffect
	Card.RegisterEffect=function(c,e,f)
		local t=e:GetType()
		if t&EFFECT_TYPE_IGNITION>0 then
			e:SetCode(EVENT_FREE_CHAIN)
			--[[if (e:GetCategory()&(CATEGORY_ATKCHANGE|CATEGORY_DEFCHANGE))>0 then
				local pr,pr2=e:GetProperty()
				e:SetProperty(pr|EFFECT_FLAG_DAMAGE_STEP,pr2)
			end]]
			e:SetHintTiming(0,0x1e0)
			e:SetType(t&(~EFFECT_TYPE_IGNITION)|EFFECT_TYPE_QUICK_O)
			local con=e:GetCondition() or aux.TRUE
			e:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
				return con(e,tp,eg,ep,ev,re,r,rp) and not e:GetHandler():IsStatus(STATUS_CHAINING)
			end)
		elseif t&EFFECT_TYPE_ACTIVATE>0 and not c:IsType(TYPE_TRAP) and not c:IsType(TYPE_QUICKPLAY) then
			local oldcon=e:GetCondition() or aux.TRUE
			local e1=e:Clone()
			e:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				return oldcon(e,tp,eg,ep,ev,re,r,rp) and (c:IsStatus(STATUS_SET_TURN) or (Duel.GetTurnPlayer()~=tp and not c:IsLocation(LOCATION_SZONE)))
			end)
			e1:SetType(t|EFFECT_TYPE_QUICK_O)
			--[[if (e1:GetCategory()&(CATEGORY_ATKCHANGE|CATEGORY_DEFCHANGE))>0 or c:IsType(TYPE_EQUIP) then
				local pr,pr2=e1:GetProperty()
				e1:SetProperty(pr|EFFECT_FLAG_DAMAGE_STEP,pr2)
			end]]
			e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				return oldcon(e,tp,eg,ep,ev,re,r,rp) and not c:IsStatus(STATUS_SET_TURN) and (Duel.GetTurnPlayer()==tp or c:IsLocation(LOCATION_SZONE))
			end)
			_register(c,e1,f)
		end
		return _register(c,e,f)
	end
end
