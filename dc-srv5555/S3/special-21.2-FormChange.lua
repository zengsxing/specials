--村规决斗：形态变化
--【三形金字塔】卡不在任何场地区域表侧表示存在的场合，
--那个场地区域的控制者从卡组外选1张【三形金字塔】场地，表侧放置到场地区域。

--三型金字塔场地效果修改：

--三形金字塔·大要塞
--①：自己场上怪兽的守备力上升500。
--②：自己场上的怪兽不会被效果破坏。
--③：场地区域的表侧表示的这张卡被送去墓地的场合，以自己墓地1张卡为对象才能发动。那只怪兽加入手卡。

--三形金字塔·巡航机
--①：只要这张卡在场地区域存在，每次怪兽召唤·特殊召唤，自己回复500基本分。
--②：场上有怪兽召唤的场合才能发动。自己从卡组抽1张，那之后选1张手卡丢弃。
--③：场地区域的表侧表示的这张卡被送去墓地的场合才能发动。从卡组把1张卡加入手卡。

--三形金字塔·巨人王
--①：自己场上怪兽的攻击力上升2000。
--②：自己的怪兽进行战斗的场合，直到伤害步骤结束时对方不能把魔法·陷阱·怪兽的效果发动。
--③：场地区域的表侧表示的这张卡被送去墓地的场合才能发动。从手卡把1只怪兽特殊召唤。

CUNGUI = {}

function Auxiliary.PreloadUds()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(CUNGUI.AdjustOperation)
	Duel.RegisterEffect(e1,0)
	e1=e1:Clone()
	Duel.RegisterEffect(e1,1)
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SSET)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(CUNGUI.setlimit)
	Duel.RegisterEffect(e2,0)
	--cannot activate
	local e3=Effect.GlobalEffect()
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetValue(CUNGUI.filter)
	Duel.RegisterEffect(e3,0)
end
function CUNGUI.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function CUNGUI.filter(e,re,tp)
	return re:GetHandler():IsType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function CUNGUI.AdjustFilter(c)
	return c:IsCode(9989792,45383307,72772445) and c:IsFaceup()
end
function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()>0 then return end
	if Duel.GetMatchingGroupCount(CUNGUI.AdjustFilter,tp,LOCATION_FZONE,0,nil)<1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		local code=Duel.AnnounceCard(tp,9989792,OPCODE_ISCODE,45383307,OPCODE_ISCODE,OPCODE_OR,72772445,OPCODE_ISCODE,OPCODE_OR)
		local tc=Duel.CreateToken(tp,code)
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	end
end

