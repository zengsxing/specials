--村规决斗：五色战队
--每个回合开始时，非回合玩家从游戏外将【灰流丽】【效果遮蒙者】【原始生命态尼比鲁】【颉颃胜负】【幽鬼兔】中的随机1张加入手卡。回合结束时，那张加入的卡里侧表示除外。

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

function CUNGUI.GetRandomNumber()
	local g=Duel.GetMatchingGroup(nil,0,LOCATION_DECK+LOCATION_EXTRA,LOCATION_DECK+LOCATION_EXTRA,nil)
	local offset = Duel.TossDice(0,1)
	while offset == 6 do
		offset = Duel.TossDice(0,1)
	end
	if not g or #g==0 then return offset end
	return ((g:RandomSelect(0,1):GetFirst():GetCode() + offset) % 5) + 1
end

function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local cards = {15693423,27204311,14558127,59438930,97268402}
	local add = Duel.CreateToken(tp,cards[CUNGUI.GetRandomNumber()])
	if Duel.SendtoHand(add,nil,REASON_RULE)<1 then return end
	local e1=Effect.CreateEffect(add)
	e1:SetDescription(aux.Stringid(51196805,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabelObject(add)
	e1:SetOperation(CUNGUI.rmop)
	Duel.RegisterEffect(e1,tp)
	add:RegisterFlagEffect(23456789,RESET_EVENT+RESETS_STANDARD,0,1)
end

function CUNGUI.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(23456789)>0 then
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	end
end
