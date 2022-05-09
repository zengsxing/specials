--村规决斗：贤者之石
--所有魔法·陷阱卡发动时的效果处理可以变为：
--宣言1个卡名。那个卡名的怪兽从卡组外加入卡组·额外卡组。
--加入了主卡组，且这个回合第一次以此类效果将怪兽加入主卡组的场合，再从卡组选1只怪兽加入手卡（对方不能确认这个效果加入手卡的卡）。
--所有陷阱卡都可以在自己的回合从手卡发动。
--后攻多抽2张。
CUNGUI = {}
CUNGUI.turn = {}
CUNGUI.registered = {}
CUNGUI.turn[0] = 0
CUNGUI.turn[1] = 0

Register = Card.RegisterEffect
Card.RegisterEffect = function(c,e,forced)
	if (e:GetType() & EFFECT_TYPE_ACTIVATE) > 0 and not CUNGUI.registered[c] then
		if not e:GetDescription() or e:GetDescription()==0 then
			e:SetDescription(7)
		end
		CUNGUI.registered[c] = true
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_ACTIVATE)
		e1:SetCategory(CATEGORY_TOEXTRA)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCountLimit(10000)
		e1:SetDescription(aux.Stringid(66666004,4))
		e1:SetCondition(aux.TRUE)
		e1:SetCost(aux.TRUE)
		e1:SetTarget(aux.TRUE)
		e1:SetOperation(CUNGUI.Operation)
		Register(c,e1)
	end
	Register(c,e,forced)
end
function CUNGUI.Condition(e)
	return Duel.GetTurnPlayer() == e:GetHandler():GetControler()
end
function CUNGUI.filter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function CUNGUI.Operation(e,tp,eg,ep,ev,re,r,rp)
	local card = Duel.AnnounceCard(tp,TYPE_MONSTER)
	local token = Duel.CreateToken(tp,card)
	Duel.SendtoDeck(token,nil,2,REASON_RULE)
	if token:IsLocation(LOCATION_DECK) and CUNGUI.turn[tp]~=Duel.GetTurnCount() then
		CUNGUI.turn[tp]=Duel.GetTurnCount()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,CUNGUI.filter,tp,LOCATION_DECK,0,1,1,nil)
		if tc then
			if Duel.SendtoHand(tc,nil,REASON_EFFECT) > 0 then
				Duel.ConfirmCards(1-tp,tc)
			end
		end
	end
end