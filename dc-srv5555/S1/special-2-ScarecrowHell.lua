--村规决斗：稻草地狱
--通常魔法卡·速攻魔法卡·通常陷阱卡·反击陷阱卡发动后不送去墓地，直接盖伏。
--那些盖伏的卡当回合不能再次发动。
CUNGUI = {}

function Auxiliary.PreloadUds()
    --Duel Start
    local e1=Effect.GlobalEffect()
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
    e1:SetOperation(function(e)
        local e2=Effect.GlobalEffect()
        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e2:SetCode(EVENT_CHAINING)
        e2:SetCondition(CUNGUI.condition)
        e2:SetTarget(CUNGUI.target)
        e2:SetOperation(CUNGUI.operation)
        Duel.RegisterEffect(e2,0)
        e:Reset()
    end)
    local ex = e1:Clone()
    ex:SetOperation(function(e)
        if Duel.GetTurnCount() > 1 then
            Duel.Draw(Duel.GetTurnPlayer(), 1, REASON_RULE)
            e:Reset()
        end
    end)
    Duel.RegisterEffect(e1,0)
    Duel.RegisterEffect(ex,0)
end

function CUNGUI.condition(e,tp,eg,ep,ev,re,r,rp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE) and not re:GetHandler():IsType(TYPE_CONTINUOUS) and not re:GetHandler():IsType(TYPE_PENDULUM)
        and not re:GetHandler():IsType(TYPE_FIELD)
end
function CUNGUI.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return re:GetHandler():IsCanTurnSet() end
end
function CUNGUI.operation(e,tp,eg,ep,ev,re,r,rp)
    local rc=re:GetHandler()
    if rc:IsRelateToEffect(re) then
        rc:CancelToGrave()
        if Duel.ChangePosition(rc,POS_FACEDOWN) then
            rc:SetStatus(STATUS_SET_TURN,false)
            Duel.RaiseEvent(rc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
            local e1=Effect.CreateEffect(rc)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
            e1:SetCode(EFFECT_CANNOT_TRIGGER)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            rc:RegisterEffect(e1)
        end
    end
end