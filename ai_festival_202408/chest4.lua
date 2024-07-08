CHEST={}

--宝物名称。CHEST.Name与CHEST.Message与CHEST.MessageAbsolute只能选一个，优先级Name>Message>MessageAbsolute。
--Debug.Message(name .. "打开了宝箱，发现里面的宝物是" .. CHEST.Name .. "！")
--Debug.Message(name .. "打开了宝箱，" .. CHEST.Message)
--Debug.Message(CHEST.MessageAbsolute(rp))
CHEST.Name = "缝合针线套装"

function CHEST.EffectMessageAbsolute(rp)
    local name="你"
    local name2="你的对手"
    if rp == CUNGUI.AI then name2,name = name,name2 end
    return name .. "帮" .. name2 .."进行了细心缝合！"
end

--战斗破坏时发动的效果。
function CHEST.BattleDestroyedEffect(e,rp)
    Duel.SetLP(1-rp,Duel.GetLP(1-rp) * 2)
end