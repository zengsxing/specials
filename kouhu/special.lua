local extraTypes=TYPE_FUSION|TYPE_SYNCHRO|TYPE_XYZ|TYPE_LINK

local function announceCard(tp,extra)
  opCodes={extraTypes,OPCODE_ISTYPE}
  if not extra then
    table.insert(opCodes,OPCODE_NOT)
  end
  local code=Duel.AnnounceCard(tp,table.unpack(opCodes))
  local c=Duel.CreateToken(tp,code)
  return c
end


function Auxiliary._init(e)
  local c1=announceCard(1)
  Duel.SendtoHand(c,1,REASON_RULE)
  local c2=announceCard(0)
  Duel.SendtoHand(c,0,REASON_RULE)
  local deckCard=announceCard(0)
  Duel.SendtoDeck(c,0,0,REASON_RULE)
  local extraCard=announceCard(0,true)
  Duel.SendtoDeck(c,0,0,REASON_RULE)


  local e1=Effect.GlobalEffect()
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
  e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
  e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnCount()>1
  end)
  e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
    local p=Duel.GetTurnPlayer()
    -- announce 2 cards and 1 extra
    local c1=announceCard(p)
    local c2=announceCard(p)
    Duel.SendtoDeck(c2,p,0,REASON_RULE)
    Duel.SendtoDeck(c1,p,0,REASON_RULE)
    local extraCard=announceCard(p,true)
    Duel.SendtoDeck(extraCard,p,0,REASON_RULE)
  end)
  Duel.RegisterEffect(e1,0)

  e:Reset()
end

function Auxiliary.PreloadUds()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(Auxiliary._init)
	Duel.RegisterEffect(e1,0)
end
