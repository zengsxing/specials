--超级抽卡
--当一个玩家抽卡时：
--对方怪兽卡>3 -> 多抽张雷击
--对方后场>3 -> 多抽张羽毛扫
--对方LP<=1000 -> 多抽2张火球
--对方手卡>=5 -> 多抽张强引的番兵
--（以上可叠加）
--自己LP<=1000 -> 抽卡固定为5
--以上条件全部不满足 ->多抽1张

--以上叠加后，若自己会把自己抽死：
--抽卡固定为5，且抽到5老艾

local CUNGUI={}
function Auxiliary.PreloadUds()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(CUNGUI.CheckAI)
	Duel.RegisterEffect(e1,0)
end

function CUNGUI.CheckAI(e)
    local a0 = Duel.GetFieldGroupCount(0, LOCATION_EXTRA, 0)
    local a1 = Duel.GetFieldGroupCount(1, LOCATION_EXTRA, 0)
    local c0 = Duel.GetMatchingGroup(Card.IsCode, 0, LOCATION_EXTRA, 0, nil, 37818794)
    local c1 = Duel.GetMatchingGroup(Card.IsCode, 0, LOCATION_EXTRA, 0, nil, 37818794)
    local ex0 = a0 == 2 and c0 == 2
    local ex1 = a1 == 2 and c1 == 2
    a0 = a0 == 16 or a0 == 1
    a1 = a1 == 16 or a1 == 1
    if true then
    --if a0 and #c0>0 then
        CUNGUI.StartAI(0,false)
    end
    if true then
    --if a0 and #c0>0 then
        CUNGUI.StartAI(1,false)
    end
    e:Reset()
end

function CUNGUI.StartAI(tp,ex)
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
    e1:SetCountLimit(1)
	e1:SetOperation(CUNGUI.BeforeDraw)
    if ex then
        e1:SetLabel(1)
    end
	Duel.RegisterEffect(e1,tp)
	--Draw
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
    e2:SetLabel(1)
	e2:SetValue(CUNGUI.DrawCount)
    e1:SetLabelObject(e2)
	Duel.RegisterEffect(e2,tp)
end
function CUNGUI.CreateCard(tp,code)
    local c=Duel.CreateToken(tp, code)
    Duel.SendtoDeck(c,tp,SEQ_DECKTOP,REASON_RULE)
end
function CUNGUI.BeforeDraw(e,tp)
    if Duel.GetTurnCount()==1 then return end
    if Duel.GetTurnPlayer()~=tp then
        e:GetLabelObject():SetLabel(1)
        return
    end
    local draw=Duel.GetDrawCount(tp)
    if Duel.GetFieldGroupCount(tp, 0, LOCATION_MZONE)>3 then
        CUNGUI.CreateCard(tp,12580477)
        draw=draw + 1
    end
    if Duel.GetFieldGroupCount(tp, 0, LOCATION_SZONE)>3 then
        CUNGUI.CreateCard(tp,18144506)
        draw=draw + 1
    end
    if Duel.GetFieldGroupCount(tp, 0, LOCATION_HAND)>=5 then
        CUNGUI.CreateCard(tp,42829885)
        draw=draw + 1
    end
    if Duel.GetLP(1-tp)<=1000 then
        CUNGUI.CreateCard(tp,46130346)
        CUNGUI.CreateCard(tp,46130346)
        draw=draw + 2
    end
    if Duel.GetLP(tp)<=1000 then
        draw=5
    elseif draw == Duel.GetDrawCount(tp) then
        draw = draw + 1
    end
    if draw>Duel.GetFieldGroupCount(tp,LOCATION_DECK,0) then
        CUNGUI.CreateCard(tp,8124921)
        CUNGUI.CreateCard(tp,44519536)
        CUNGUI.CreateCard(tp,70903634)
        CUNGUI.CreateCard(tp,7902349)
        CUNGUI.CreateCard(tp,33396948)
        e:GetLabelObject():SetLabel(5)
        return
    end
    e:GetLabelObject():SetLabel(draw)
end

function CUNGUI.DrawCount(e)
	return e:GetLabel() or 1
end