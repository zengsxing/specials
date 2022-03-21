--村规决斗：你也是龙
--仅在卡片效果判定时：
--所有卡都具有全属性。
--所有卡都视为全种族。
--所有卡都视为正面朝上。
--（背面朝上的场合，同时视为正面朝上+背面朝上）
--所有卡都视为是任意攻击力·守备力。
--所有卡都视为是任意等级。

CUNGUI = {}

Card.IsFaceup = function() return true end
Card.IsRace = function() return true end
Card.GetRace = function() return RACE_ALL end
Card.IsAttribute = function() return true end
Card.GetAttribute = function() return 0x7f end
Card.IsFaceup = function() return true end
Card.IsAttackAbove = function() return true end
Card.IsAttackBelow = function() return true end
Card.IsDefenseAbove = function() return true end
Card.IsDefenseBelow = function() return true end
Card.IsLevelAbove = function() return true end
Card.IsLevelBelow = function() return true end
Card.IsAttack = function() return true end
Card.IsDefense = function() return true end
Card.IsLevel = function() return true end

function Auxiliary.PreloadUds()
end
