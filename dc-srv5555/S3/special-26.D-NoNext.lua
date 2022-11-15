--村规决斗：下不为例
--所有含有次数限制的效果，变为决斗中X次的效果。
--X的数量是原限制次数*3。

CUNGUI = {}
local scl = Effect.SetCountLimit
Effect.SetCountLimit = function(e,count,code)
	if not code then
		code = EFFECT_COUNT_CODE_DUEL
	else
		code = code | EFFECT_COUNT_CODE_DUEL
	end
	count = count * 3
	scl(e,count,code)
end