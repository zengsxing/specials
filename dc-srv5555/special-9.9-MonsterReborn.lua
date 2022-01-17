CUNGUI = {}
Card.EnableReviveLimit = function(card) end
Card.SetUniqueOnField = function(c,s,o,code,loc) end

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

function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnCount() > 1 then
		local tp = Duel.GetTurnPlayer()
		local card = Duel.CreateToken(tp,83764718)
		if Duel.SendtoHand(card,nil,REASON_RULE)<1 then return end
		local e1=Effect.CreateEffect(card)
		e1:SetDescription(aux.Stringid(51196805,1))
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(card)
		e1:SetOperation(CUNGUI.rmop)
		Duel.RegisterEffect(e1,tp)
	end
end

function CUNGUI.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	e:Reset()
end
