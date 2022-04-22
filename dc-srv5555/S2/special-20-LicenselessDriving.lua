--村规决斗：无证驾驶
--进行各种选卡动作时，
--不再过滤特定的卡。
--每个回合把手卡抽到5张（最少为1）。

--细则：
--大部分情况下，并不改变卡片的发动条件；
--只是在选取对象和处理卡的选择时可以任意选。
--不会扩大选取范围。

CUNGUI = {}

local SelectMatchingCard = Duel.SelectMatchingCard
Duel.SelectMatchingCard = function(tp,f,tp2,s,o,min,max,ex,...)
	return SelectMatchingCard(tp,aux.TRUE,tp2,s,o,min,max,nil,...)
end
local SelectTarget = Duel.SelectTarget
Duel.SelectTarget = function(tp,f,tp2,s,o,min,max,ex,...)
	return SelectTarget(tp,aux.TRUE,tp2,s,o,min,max,nil,...)
end
local DiscardHand = Duel.DiscardHand
Duel.DiscardHand = function(tp,f,min,max,reason)
	return DiscardHand(tp,aux.TRUE,min,max,reason)
end
local SelectReleaseGroup = Duel.SelectReleaseGroup
Duel.SelectReleaseGroup = function(tp,f,min,max,ex,...)
	return SelectReleaseGroup(tp,aux.TRUE,min,max,nil,...)
end

local SelectReleaseGroupEx = Duel.SelectReleaseGroupEx
Duel.SelectReleaseGroupEx = function(tp,f,min,max,ex,...)
	return SelectReleaseGroupEx(tp,aux.TRUE,min,max,nil,...)
end

local SelectSubGroup = Group.SelectSubGroup
Group.SelectSubGroup = function(g,tp,f,cancelable,min,max,...)
	return SelectSubGroup(g,tp,aux.TRUE,cancelable,min,max,...)
end

local GetFirstMatchingCard = Duel.GetFirstMatchingCard
Duel.GetFirstMatchingCard = function(f,tp,s,o,ex,...)
	return SelectMatchingCard(tp,aux.TRUE,tp,s,o,1,1,nil,...)
end

function Auxiliary.PreloadUds()
	--Draw
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetValue(CUNGUI.DrawCount)
	Duel.RegisterEffect(e2,0)
end
function CUNGUI.DrawCount(e)
	if Duel.GetTurnCount()==1 then return 0 end
	local p=Duel.GetTurnPlayer()
	local ct=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
	if ct>4 then return 1
	else return 5-ct end
end