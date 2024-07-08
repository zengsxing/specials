CHEST={}

--宝物名称。CHEST.Name与CHEST.Message与CHEST.MessageAbsolute只能选一个，优先级Name>Message>MessageAbsolute。
--Debug.Message(name .. "打开了宝箱，发现里面的宝物是" .. CHEST.Name .. "！")
--Debug.Message(name .. "打开了宝箱，" .. CHEST.Message)
--Debug.Message(CHEST.MessageAbsolute(rp))
CHEST.Name = "一场雷暴"

--效果名称。同样二选一，EffectMessage优先级更高。
--Debug.Message(name .. CHEST.EffectMessage)
--Debug.Message(CHEST.EffectMessageAbsolute(rp))
CHEST.EffectMessage = "场上的怪兽被雷劈了！"

--战斗破坏时发动的效果。
function CHEST.BattleDestroyedEffect(e,rp)
    local g=Duel.GetFieldGroup(rp,LOCATION_MZONE,0)
    Duel.Destroy(g,REASON_RULE)
end