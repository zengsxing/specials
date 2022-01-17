--村规决斗：公主链接
--所有额外卡组的怪兽（不包括从场上表侧表示送去额外卡组的灵摆怪兽）得到以下效果：
--（仅非连接怪兽）这张卡当作连接怪兽使用，连接数相当于等级或阶级/2（向上取整）。
--这张卡能以【怪兽2只以上】为条件作连接召唤。

--细则：
--原本不是连接怪兽，则可以在主要区域进行连接召唤。
--本来不是连接怪兽的怪兽在场时，并没有连接区。

OrigGetType = Card.GetType
Card.GetType = function(c)
	local typ = OrigGetType(c)
	if OrigIsType(c,TYPE_XYZ+TYPE_SYNCHRO+TYPE_FUSION) then
		typ = typ | TYPE_LINK
	end
	return typ
end

OrigIsType = Card.IsType
Card.IsType = function(c,typ)
	if (typ & TYPE_LINK) == 0 then return OrigIsType(c,typ) end
	if OrigIsType(c,TYPE_XYZ+TYPE_LINK+TYPE_SYNCHRO+TYPE_FUSION) then return true end
	return false
end

OrigGetLink = Card.GetLink
Card.GetLink = function(c)
	if OrigIsType(TYPE_LINK) then return OrigGetLink(c) end
	local lv = 0
	if c:IsType(TYPE_XYZ) then
		lv = c:GetOriginalRank()
	else
		lv = c:GetOriginalLevel()
	end
	return math.ceil(lv / 2)
end

OrigGetLinkMarker = Card.GetLinkMarker
Card.GetLinkMarker = function(c)
	if OrigIsType(TYPE_LINK) then return OrigGetLinkMarker(c) end
	local lv = 0
	if c:IsType(TYPE_XYZ) then
		lv = c:GetOriginalRank()
	else
		lv = c:GetOriginalLevel()
	end
	return math.ceil(lv / 2)
end

OrigIsLink = Card.IsLink
Card.IsLink = function(c,...)
	local links = {...}
	if not c:IsType(TYPE_LINK) then return OrigIsLink(c,...) end
	local lv = 0
	if c:IsType(TYPE_XYZ) then
		lv = c:GetOriginalRank()
	else
		lv = c:GetOriginalLevel()
	end
	for _,l in ipair(links) do
		if lv == l then return true end
	end
	return false
end

OrigIsLinkAbove = Card.IsLinkAbove
Card.IsLinkAbove = function(c,link)
	if not c:IsType(TYPE_LINK) then return OrigIsLinkAbove(c,link) end 
	return c:GetLink() >= link
end
OrigIsLinkBelow = Card.IsLinkBelow
Card.IsLinkBelow = function(c,link)
	if not c:IsType(TYPE_LINK) then return OrigIsLinkBelow(c,link) end 
	return c:GetLink() <= link
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
	local g = Duel.GetMatchingGroup(Card.IsType,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,TYPE_MONSTER)
	g:ForEach(CUNGUI.RegisterMonsterSpecialEffects)
end

function CUNGUI.RegisterMonsterSpecialEffects(c)
	if CUNGUI.RegisteredMonsters:IsContains(c) then return end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return end
	CUNGUI.RegisteredMonsters:AddCard(c)
	if not c:IsType(TYPE_LINK) then
		--Non-link monster
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_ADD_TYPE)
		e3:SetRange(LOCATION_MZONE+LOCATION_EXTRA)
		e3:SetValue(TYPE_LINK)
		c:RegisterEffect(e3)
	end
	if not c:IsType(TYPE_EFFECT) then
		--Normal monster
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetCode(EFFECT_ADD_TYPE)
		e4:SetRange(LOCATION_MZONE+LOCATION_EXTRA)
		e4:SetValue(TYPE_EFFECT)
		c:RegisterEffect(e4)
	end
	--Link summon
	aux.AddLinkProcedure(c,nil,2)
end