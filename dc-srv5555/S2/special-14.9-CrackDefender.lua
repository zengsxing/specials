--村规决斗：盗版卫士
--所有卡都具有全字段。
--所有卡都视为全种类卡（怪兽+魔法+陷阱+仪式+同调……），也视为任何一张特定卡。

--细则：
--并不意味着有特定卡的效果，也不意味着场上受到了那张卡的影响。
--因此例如【场上有“海”才能发动】的效果，即使有卡也仍然是不能发动的。
--另外，在绝大多数情况下，如果在怪兽区域就仍然只能视为怪兽，
--在魔法陷阱区域就仍然只能视为魔法陷阱。
--所以类似【自己场上有连接怪兽2只以上存在的场合才能发动】的效果，
--只会检查前场有没有2只（不管是不是连接怪兽的）怪兽，
--类似旋风的效果也只能破坏后场的卡。
--在极少数情况下可能有部分效果脱离这个限制？目前没有发现。

CUNGUI = {}

Card.IsSetCard = function(c,setname) return true end
Card.IsType = function(c,typ) return true end
Card.IsCode = function(c,...) return true end

function Auxiliary.PreloadUds()
end
