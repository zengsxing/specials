--村规决斗：携手共尽
--所有起动效果和诱发即时效果变为双方都能使用的效果。
--后攻开局时多抽1张。

local OrigSetType = Effect.SetType

function Auxiliary.PreloadUds()
    Effect.SetType = function(e,typ)
        if (typ & EFFECT_TYPE_IGNITION)+(typ & EFFECT_TYPE_QUICK_O)>0 then
            e:SetProperty((e:GetProperty() or 0) | EFFECT_FLAG_BOTH_SIDE)
        end
        OrigSetType(e,typ)
    end
	-- 1 more draw
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function(e)
	    Duel.Draw(1,1,REASON_RULE)
		e:Reset()
	end)
	Duel.RegisterEffect(e1,0)
end