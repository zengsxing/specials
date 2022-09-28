--村规决斗：殊途同归
--所有怪兽得到以下效果外文本：
--这张卡也当作连接2·等级2的怪兽使用。
--所有额外怪兽得到【巨大喷流卫星闪灵（54498517）】
--【卫星闪灵·淘气精灵（27381364）】的效果。

local il = Card.IsLevel
Card.IsLevel = function(c,...)
	local arg={...}
	for i,v in ipairs(arg) do
	  if v==2 then return true end
	end
	return il(c,...)
end
local ila = Card.IsLevelAbove
Card.IsLevelAbove = function(c,lv)
	return lv<=2 or ila(c,lv)
end
local ilb = Card.IsLevelBelow
Card.IsLevelBelow = function(c,lv)
	return lv>=2 or ilb(c,lv)
end
local ilk=Card.IsLink
Card.IsLink = function(c,...)
	local arg={...}
	for i,v in ipairs(arg) do
	  if v==2 then return true end
	end
	return ilk(c,...)
end
local ilka=Card.IsLinkAbove
Card.IsLinkAbove = function(c,lv)
	return lv<=2 or ilka(c,lv)
end
local ilkb=Card.IsLinkBelow
Card.IsLinkBelow = function(c,lv)
	return lv>=2 or ilkb(c,lv)
end

CUNGUI = {}

function Auxiliary.PreloadUds()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetOperation(CUNGUI.AdjustOperation)
	Duel.RegisterEffect(e1,0)
end

CUNGUI.RegisteredMonsters = Group.CreateGroup()

function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
	if not CUNGUI.Init then
		Duel.CreateToken(0,54498517)
		Duel.CreateToken(0,27381364)
	end
	local g = Duel.GetMatchingGroup(Card.IsType,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,TYPE_MONSTER)
	g:ForEach(CUNGUI.RegisterMonsterSpecialEffects)
end

function CUNGUI.RegisterMonsterSpecialEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
	if not c:IsExtraDeckMonster() then return end
	c54498517.initial_effect(c)
	c27381364.initial_effect(c)
end
