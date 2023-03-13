--村规决斗：伟大领袖
--开局时，由先手-后手顺序，各自从卡组·额外卡组选1张卡。
--选好后互相确认，并洗切卡组。
--各自的所有卡得到自己选的卡的所有效果和效果外文本。
--不能选择【抒情歌鸲-独立夜莺】（76815942）【光之创造神 哈拉克提】（10000040）。

--细则：
--大部分情况下，效果会限定发动位置。
--比如在怪兽区域是不能发动【王宫的铁壁】【王宫的弹压】的效果的，反之亦然。
--需要格外注意的是，如果选的是不能通常召唤的怪兽，
--那么在此规则下，自己所有的怪兽都将带上【不能通常召唤】的标签。

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

local CRegisterEffect=Card.RegisterEffect
Card.RegisterEffect = function(c,e,forced)
	if not e:GetDescription() then
		e:SetDescription(aux.Stringid(66666004,4))
	end
	return CRegisterEffect(c,e,forced)
end

function CUNGUI.filter(c)
	return not c:IsCode(76815942,10000040)
end

function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
	CUNGUI.Init = true
	local tc=Duel.SelectMatchingCard(0,CUNGUI.filter,0,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil):GetFirst()
	Duel.ConfirmCards(1,tc)
	Duel.ShuffleDeck(0)
	local cc=Duel.SelectMatchingCard(1,CUNGUI.filter,1,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil):GetFirst()
	Duel.ConfirmCards(0,cc)
	Duel.ShuffleDeck(1)

	local tce=_G["c"..tc:GetOriginalCode()]
	if tce and tce.initial_effect then
		local g=Duel.GetMatchingGroup(nil,0,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,0,nil)
		for c in aux.Next(g) do
			tce.initial_effect(c)
		end
	end

	local cce=_G["c"..cc:GetOriginalCode()]
	if cce and cce.initial_effect then
		local g=Duel.GetMatchingGroup(nil,1,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA,0,nil)
		for c in aux.Next(g) do
			cce.initial_effect(c)
		end
	end
	
	e:Reset()
end
