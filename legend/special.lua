Duel.LoadScript("underscore.lua")

function validMonster(c)
	return c:IsType(TYPE_MONSTER) 
end

local AllHints={
	70, -- monster immune
	Auxiliary.Stringid(88616795,0), -- spell immune
	Auxiliary.Stringid(88616795,1), -- trap immune
	Auxiliary.Stringid(33883834,0), -- battle destroy
	Auxiliary.Stringid(45420955,3), -- effect destroy
	1102, -- banish/hand/deck
	Auxiliary.Stringid(45420955,4), -- target
	Auxiliary.Stringid(74640994,3), -- cannot disable
	Auxiliary.Stringid(900787,0), -- atk/def up
}

local buffEffectsList={
	{
		{
			code=EFFECT_IMMUNE_EFFECT,
			value=function(e,te)
				return te:GetOwner()~=e:GetOwner() and te:IsActiveType(TYPE_MONSTER)
			end,
		}
	},
	{
		{
			code=EFFECT_IMMUNE_EFFECT,
			value=function(e,te)
				return te:GetOwner()~=e:GetOwner() and te:IsActiveType(TYPE_SPELL)
			end,
		}
	},
	{
		{
			code=EFFECT_IMMUNE_EFFECT,
			value=function(e,te)
				return te:GetOwner()~=e:GetOwner() and te:IsActiveType(TYPE_TRAP)
			end,
		}
	},
	{
		{
			code=EFFECT_INDESTRUCTABLE_BATTLE,
			value=1,
		}
	},
	{
		{
			code=EFFECT_INDESTRUCTABLE_EFFECT,
			value=1,
		}
	},
	{
		{
			code=EFFECT_CANNOT_REMOVE,
			value=1,
		},
		{
			code=EFFECT_CANNOT_TO_DECK,
			value=1,
		},
		{
			code=EFFECT_CANNOT_TO_HAND,
			value=1,
		},
	},
	{
		{
			code=EFFECT_CANNOT_BE_EFFECT_TARGET,
			value=1,
		}
	},
	{
		{
			code=EFFECT_CANNOT_DISABLE,
			value=1,
		}
	},
	{
		{
			code=EFFECT_SET_BASE_ATTACK,
			value=function(e,c)
				return math.max(c:GetTextAttack(),0)+2000
			end,
		},
		{
			code=EFFECT_SET_BASE_DEFENSE,
			value=function(e,c)
				return math.max(c:GetTextDefense(),0)+2000
			end,
		}
	},
}

function isPlayerMissedOwner(p)
	return not Duel.IsPlayerAffectedByEffect(tp,10000020+p)
end

function inititialize()
	local choices={}
	local monsters={}
	local buffOptions={}
	for p=0,1 do
		monsters[p]=Duel.GetMatchingGroup(validMonster,p,LOCATION_DECK,0,1,nil)
	end
	if _.every({monsters[0],monsters[1]}, function(g)
		return #g==0
	end) then
		Duel.Win(PLAYER_NONE,0x2)
		return
	end
	for p=0,1 do
		local g=monsters[p]
		if #g==0 then
			Duel.Win(1-p,0x2)
		end
	end
	for p=0,1 do
		Duel.Hint(MSG_HINT,p,HINTMSG_TOFIELD)
		choices[p]=monsters[p]:Select(p,1,1,nil):GetFirst()
	end
	for p=1,0,-1 do
		buffOptions[p]=Duel.SelectOption(p,table.unpack(AllHints))+1
	end
	for p=0,1 do
		local c=choices[p]
		local pos=Duel.SelectPosition(p,c,POS_FACEUP)
		Duel.MoveToField(c,p,p,LOCATION_MZONE,pos,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(10000020+p)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetRange(LOCATION_ONFIELD)
		e1:SetTargetRange(1,1)
		e1:SetDescription(1016)
		c:RegisterEffect(e1,true)
		local presetEffects={EFFECT_UNRELEASABLE_EFFECT,EFFECT_UNRELEASABLE_NONSUM,EFFECT_UNRELEASABLE_SUM,EFFECT_CANNOT_BE_FUSION_MATERIAL,EFFECT_CANNOT_BE_SYNCHRO_MATERIAL,EFFECT_CANNOT_BE_XYZ_MATERIAL,EFFECT_CANNOT_BE_LINK_MATERIAL}
		for _,effectCode in ipairs(presetEffects) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(effectCode)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetValue(1)
			c:RegisterEffect(e1,true)
		end
		local buffOption=buffOptions[p]
		--Debug.Message(buffOption)
		local buffEffects=buffEffectsList[buffOption]
		--Debug.Message(type(buffEffects))
		local hintGiven=false
		for _,buffEffect in ipairs(buffEffects) do
			local flags=EFFECT_FLAG_CANNOT_DISABLE
			if not hintGiven then
				flags=flags+EFFECT_FLAG_CLIENT_HINT
			end
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(AllHints[buffOption])
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(buffEffect.code)
			e1:SetProperty(flags)
			e1:SetValue(buffEffect.value)
			c:RegisterEffect(e1,true)
		end
	end
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function()
		if isPlayerMissedOwner(0) and isPlayerMissedOwner(1) then
			Duel.Win(PLAYER_NONE,0x13)
			return
		end
		for p=0,1 do
			if isPlayerMissedOwner(p) then
				Duel.Win(1-p,0x13)
				return
			end
		end
	end)
	Duel.RegisterEffect(e1,0)
end

function Auxiliary.PreloadUds()
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function(e)
		inititialize()
		e:Reset()
	end)
	Duel.RegisterEffect(e1,0)
end
