--村规决斗：自由主义
--所有回合发动次数限制变为3倍。

CUNGUI = {}

local SetCountLimit = Effect.SetCountLimit

Effect.SetCountLimit = function(e,count,code)
	count = count * 3
	SetCountLimit(e,count,code)
end

function Auxiliary.PreloadUds()
end
