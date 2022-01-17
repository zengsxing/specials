--村规决斗：二权分立
--因选择各类召唤素材、是否发动诱发效果【以外】而进行各种选择时，那个原本玩家的对方进行选择。

--细则：
--不包括替对方宣言卡名、种族等。
CUNGUI = {}

function Auxiliary.PreloadUds()
	local SelectMatchingCard = Duel.SelectMatchingCard
	Duel.SelectMatchingCard = function(tp,...)
		return SelectMatchingCard(1-tp,...)
	end
	local GroupSelect = Group.Select
	Group.Select = function(g,tp,...)
		return GroupSelect(g,1-tp,...)
	end
	local GroupSelectUnselect = Group.SelectUnselect
	Group.SelectUnselect = function(cg,sg,tp,...)
		return GroupSelectUnselect(cg,sg,1-tp,...)
	end
	local GroupSelectWithSumEqual = Group.SelectWithSumEqual
	Group.SelectWithSumEqual = function(g,tp,...)
		return GroupSelectWithSumEqual(g,1-tp,...)
	end
	local GroupSelectWithSumGreater = Group.SelectWithSumGreater
	Group.SelectWithSumGreater = function(g,tp,...)
		return GroupSelectWithSumGreater(g,1-tp,...)
	end
	local SelectTarget = Duel.SelectTarget
	Duel.SelectTarget = function(tp,...)
		return SelectTarget(1-tp,...)
	end
	local SelectYesNo = Duel.SelectYesNo
	Duel.SelectYesNo = function(tp,...)
		return SelectYesNo(1-tp,...)
	end
	local SelectDisableField = Duel.SelectDisableField
	Duel.SelectDisableField = function(tp,...)
		return SelectDisableField(1-tp,...)
	end
	local SelectOption = Duel.SelectOption
	Duel.SelectOption = function(tp,...)
		return SelectOption(1-tp,...)
	end
	local SelectPosition = Duel.SelectPosition
	Duel.SelectPosition = function(tp,...)
		return SelectPosition(1-tp,...)
	end
end