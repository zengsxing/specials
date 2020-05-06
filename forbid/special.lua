Duel.LoadScript("underscore.lua")
local _FORBID_LIST={}
local function elimateExisting()
	local formattedOpcodes=_.map(_FORBID_LIST,function(m)
		return {m.code,OPCODE_ISCODE,OPCODE_NOT}
	end)
	for i=2,#formattedOpcodes do
		_.push(formattedOpcodes[i],OPCODE_AND)
	end
	return _.flatten(formattedOpcodes)
end
function Auxiliary.PreloadUds()
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCondition(function()
		local turnc=Duel.GetTurnCount()
		return turnc<=10
	end)
	e1:SetOperation(function()
		local tp=Duel.GetTurnPlayer()
		local ac=Duel.AnnounceCard(1-tp,table.unpack(elimateExisting()))
		_.push(_FORBID_LIST,{
			code=ac,
			turn=Duel.GetTurnCount()
		})
		if not _FORBID_INITIALIZED then
			_FORBID_INITIALIZED=true
			for p=0,1 do
				local tempc=Duel.CreateToken(p,10000000)
				local e2=Effect.CreateEffect(tempc)
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
				e2:SetCode(EFFECT_FORBIDDEN)
				e2:SetTargetRange(0xff,0xff)
				e2:SetTarget(function(e,c)
					local codes={c:GetOriginalCodeRule()}
					return _.any(_FORBID_LIST,function(m)
						return _.include(codes,m.code) and (not c:IsOnField() or c:GetTurnID()>=m.turn)
					end)
				end)
				Duel.RegisterEffect(e2,p)
			end
		end
		Duel.AdjustInstantly()
	end)
	Duel.RegisterEffect(e1,0)
end
