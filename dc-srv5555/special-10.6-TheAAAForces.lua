--村规决斗：大联合军
--双方场上的怪兽攻防上升各自场上那个种族的怪兽数量*200。
--这个基数每回合都会上升200点。

CUNGUI = {}

function CUNGUI.Init()
    local e1=Effect.GlobalEffect()
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
    e1:SetValue(CUNGUI.val)
    Duel.RegisterEffect(e1,0)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    Duel.RegisterEffect(e2,0)
end

function CUNGUI.filter(c,race)
    return c:IsFaceup() and c:IsRace(race)
end

function CUNGUI.val(e,c)
    return Duel.GetMatchingGroupCount(CUNGUI.filter,c:GetControler(),LOCATION_MZONE,0,nil,c:GetRace())
        * 200 * Duel.GetTurnCount()
end

function Auxiliary.PreloadUds()
    -- one more draw
    local e1=Effect.GlobalEffect()
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetCode(EVENT_ADJUST)
    e1:SetOperation(function(e)
        CUNGUI.Init()
        e:Reset()
    end)
    Duel.RegisterEffect(e1,0)
end