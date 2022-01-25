--村规决斗：爷爷的卡
--开局时，双方将手卡返回卡组，将【被封印的艾克佐迪亚】5件套加入卡组。
--双方选各自卡组中最多20张卡里侧表示除外，但不能选择上述的五件套。
--【这个选卡时间限定为35秒（包含播放除外动画的时间）】
--双方抽5张卡。

CUNGUI = {}
CUNGUI.CardList = {7902349,8124921,33396948,44519536,70903634}


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
	local g=Group.CreateGroup()
	for _,id in ipairs(CUNGUI.CardList) do
		local token = Duel.CreateToken(0,id)
		Duel.SendtoDeck(token,nil,0,REASON_RULE)
		g:AddCard(token)
		token = Duel.CreateToken(1,id)
		Duel.SendtoDeck(token,nil,0,REASON_RULE)
		g:AddCard(token)
	end
	Duel.SendtoDeck(Duel.GetFieldGroup(0,LOCATION_HAND,LOCATION_HAND),nil,0,REASON_RULE)
	Duel.ResetTimeLimit(0,30)
	local g2=Duel.SelectMatchingCard(0,Card.IsAbleToRemove,0,LOCATION_DECK,0,0,20,g)
	if g2 then Duel.Remove(g2,POS_FACEDOWN,REASON_RULE) end
	Duel.ResetTimeLimit(0,180)
	Duel.ResetTimeLimit(1,30)
	g2=Duel.SelectMatchingCard(1,Card.IsAbleToRemove,1,LOCATION_DECK,0,0,20,g)
	if g2 then Duel.Remove(g2,POS_FACEDOWN,REASON_RULE) end
	Duel.ResetTimeLimit(1,180)
	Duel.Draw(0,5,REASON_RULE)
	Duel.Draw(1,5,REASON_RULE)
end

