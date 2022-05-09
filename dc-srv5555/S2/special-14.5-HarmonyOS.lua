--村规决斗：万物互联
--进行各种选卡动作时，
--可以选择双方的任何卡。
--每个回合把手卡抽到5张（最少为1）。

--细则：
--大部分情况下，并不改变卡片的发动条件；
--只是在选取对象和处理卡的选择时可以任意选。

CUNGUI = {}

local SelectMatchingCard = Duel.SelectMatchingCard
Duel.SelectMatchingCard = function(tp,f,tp2,s,o,min,max,ex,...)
	local g3=Group.CreateGroup()
	repeat
	local g1=SelectMatchingCard(tp,nil,tp2,0x7f,0,0,max,nil,...) or Group.CreateGroup()
	local g2=SelectMatchingCard(tp,nil,tp2,0,0x7f,0,max,nil,...) or Group.CreateGroup()
	g3=Group.CreateGroup()
	g3:Merge(g1)
	g3:Merge(g2)
	until g3 and #g3>=min and #g3<=max
	return g3
end
local SelectTarget = Duel.SelectTarget
Duel.SelectTarget = function(tp,f,tp2,s,o,min,max,ex,...)
	local g3=Group.CreateGroup()
	repeat
	local g1=SelectTarget(tp,nil,tp2,0x7f,0,0,max,nil,...) or Group.CreateGroup()
	local g2=SelectTarget(tp,nil,tp2,0,0x7f,0,max,nil,...) or Group.CreateGroup()
	g3=Group.CreateGroup()
	g3:Merge(g1)
	g3:Merge(g2)
	until g3 and #g3>=min and #g3<=max
	return g3
end
local DiscardHand = Duel.DiscardHand
Duel.DiscardHand = function(tp,f,min,max,reason)
	local g3=Group.CreateGroup()
	repeat
	local g1=SelectMatchingCard(tp,Card.IsDiscardable,tp,0x7f,0,0,max,nil) or Group.CreateGroup()
	local g2=SelectMatchingCard(tp,Card.IsDiscardable,tp,0,0x7f,0,max,nil) or Group.CreateGroup()
	g3=Group.CreateGroup()

	g3:Merge(g1)
	g3:Merge(g2)
	until g3 and #g3>=min and #g3<=max
	Duel.SendtoGrave(g3,reason | REASON_DISCARD)
end
local SelectReleaseGroup = Duel.SelectReleaseGroup
Duel.SelectReleaseGroup = function(tp,f,min,max,ex,...)
	local g3=Group.CreateGroup()
	repeat
	local g1=SelectMatchingCard(tp,Card.IsReleasable,tp,0x7f,0,0,max,nil) or Group.CreateGroup()
	local g2=SelectMatchingCard(tp,Card.IsReleasable,tp,0,0x7f,0,max,nil) or Group.CreateGroup()
	g3=Group.CreateGroup()

	g3:Merge(g1)
	g3:Merge(g2)
	until g3 and #g3>=min and #g3<=max
	return g3
end

local SelectReleaseGroupEx = Duel.SelectReleaseGroupEx
Duel.SelectReleaseGroupEx = function(tp,f,min,max,ex,...)
	local g3=Group.CreateGroup()
	repeat
	local g1=SelectMatchingCard(tp,Card.IsReleasable,tp,0x7f,0,0,max,nil) or Group.CreateGroup()
	local g2=SelectMatchingCard(tp,Card.IsReleasable,tp,0,0x7f,0,max,nil) or Group.CreateGroup()
	g3=Group.CreateGroup()

	g3:Merge(g1)
	g3:Merge(g2)
	until g3 and #g3>=min and #g3<=max
	return g3
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