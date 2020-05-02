Duel.LoadScript("underscore.lua")
local _FORBID_LIST={}
local function elimateExisting()
	local formattedOpcodes=_.map(_FORBID_LIST,function(m)
		return {m,OPCODE_ISCODE,OPCODE_NOT}
	end)
	for i=2,#formattedOpcodes do
		_.push(formattedOpcodes[i],OPCODE_AND)
	end
	return _.flattern(formattedOpcodes)
end
function Auxiliary.PreloadUds()
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCondition(function()
		local turnc=Duel.GetTurnCount()
		return turnc>1 and turnc<=10
	end)
	e1:SetOperation(function()
		local tp=Duel.GetTurnPlayer()
		local ac=Duel.AnnounceCard(tp,table.unpack(elimateExisting()))
		_.push(_FORBID_LIST,ac)
	end)
	Duel.RegisterEffect(e1,0)
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_FORBIDDEN)
	e2:SetTargetRange(0x7f,0x7f)
	e2:SetTarget(function(e,c)
		local code1,code2=c:GetOriginalCodeRule()
		return _.any(_FORBID_LIST,function(code)
			return code1==code or code2==code
		end)
	end)
	Duel.RegisterEffect(e2,0)
end
