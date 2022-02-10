--村规决斗：顺风飙车
--每次因通常抽卡以外抽卡的场合，那个对方从卡组抽2张。
--每次卡因抽卡以外的方式加入手卡的场合，那个原本所有者的对方（如果有多张，则取第一张的原本所有者）从卡组抽2张。

CUNGUI = {}

function Auxiliary.PreloadUds()
	local Draw0 = Duel.Draw
	Duel.Draw = function(tp, count, reason)
		Draw0(tp, count, reason)
		Draw0(1-tp, 2, reason)
	end

	local SendtoHand0 = Duel.SendtoHand
	Duel.SendtoHand = function(tg,tp,reason)
		SendtoHand0(tg,tp,reason)
		if tp==nil then
			if Auxiliary.GetValueType(tg) == "Card" then
				tp = tg:GetOwner()
			else
				tp = tg:GetFirst():GetOwner()
			end
		end
		Duel.Draw(1-tp,2)
	end
end
