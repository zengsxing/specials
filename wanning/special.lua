local skillLists={}

local function addSkill(code, skill)
  if not skillLists[code] then
    skillLists[code]={}
  end
  table.insert(skillLists[code], skill)
end

local function getAllSkillCodes()
  local skillCodes={}
  for code,_ in pairs(skillLists) do
    table.insert(skillCodes, code)
  end
  return skillCodes
end

local function registerSkillForPlayer(tp, code)
  local skills=skillLists[code]
  for _,skill in ipairs(skills) do
    local e1=Effect.GlobalEffect()
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    skill(e1)
    Duel.RegisterEffect(e1,tp)
  end
end

local function wrapDeckSkill(code, effectFactory)
  addSkill(code, function(e2)
    local e1=Effect.GlobalEffect()
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
    e1:SetRange(LOCATION_DECK)
    effectFactory(e1)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
    e2:SetTargetRange(LOCATION_DECK,0)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
    e2:SetTarget(function(e,c)
      local dg=Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_DECK,0)
      if #dg==0 then return false end
      local minc=dg:GetMinGroup(Card.GetSequence):GetFirst()
      return c==minc
    end)
    e2:SetLabelObject(e1)
  end)
end

local function phaseSkill(code, phase, op, con, both)
  wrapDeckSkill(code, function(e1)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+phase)
    e1:SetCountLimit(1,0x7ffffff-code)
    e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
      return (both or Duel.GetTurnPlayer()==tp) and (not con or con(e,tp,eg,ep,ev,re,r,rp))
    end)
    e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
      Duel.Hint(HINT_CARD,0,code)
      op(e,tp,eg,ep,ev,re,r,rp)
    end)
  end)
end

local function oneTimeSkill(code, op)
  addSkill(code, function(e1)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_ADJUST)
    e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
      Duel.Hint(HINT_CARD,0,code)
      op(e,tp,eg,ep,ev,re,r,rp)
      e:Reset()
    end)
  end)
end

local function standbyPhaseSkill(code, op, con, both)
  phaseSkill(code, PHASE_STANDBY, op, con, both)
end

local function endPhaseSkill(code, op, con, both)
  phaseSkill(code, PHASE_END, op, con, both)
end

standbyPhaseSkill(48356796, function(e,tp,eg,ep,ev,re,r,rp)
  Duel.Draw(tp,2,REASON_RULE)
end)

standbyPhaseSkill(2295831, function(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,nil,REASON_RULE)
    Duel.ConfirmCards(1-tp,g)
  end
end, function(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(Card.IsAbleToHand, tp, LOCATION_DECK, 0, 1, nil)
end)

standbyPhaseSkill(84257639, function(e,tp,eg,ep,ev,re,r,rp)
  Duel.Recover(tp,8000,REASON_EFFECT)
end)

endPhaseSkill(19523799, function(e,tp,eg,ep,ev,re,r,rp)
  Duel.Damage(1-tp,3200,REASON_EFFECT)
end)

for _,event in ipairs({EVENT_SUMMON_SUCCESS,EVENT_FLIP_SUMMON_SUCCESS,EVENT_SPSUMMON_SUCCESS}) do
  wrapDeckSkill(23434538, function(e1)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(event)
    e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
      local count = eg:FilterCount(function(c)
        return c:IsControler(1-tp) and c:IsType(TYPE_MONSTER)
      end, 1, nil)
      return ep~=tp and count>0 and Duel.GetMZoneCount(tp)>=count
    end)
    e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
      Duel.Hint(HINT_CARD,0,23434538)
      local tg=eg:Filter(function(c)
        return c:IsControler(1-tp) and c:IsType(TYPE_MONSTER)
      end, nil)
      for tc in aux.Next(tg) do
        local cc=Duel.CreateToken(tp,tc:GetOriginalCode())
        Duel.MoveToField(cc,tp,tp,LOCATION_MZONE,tc:GetPosition(),true)
      end
    end)
  end)
end

wrapDeckSkill(1372887, function(e1)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
  e1:SetCode(EVENT_CHAIN_SOLVED)
  e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp and not re:GetHandler():IsType(TYPE_TOKEN)
  end)
  e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,1372887)
    local cc=Duel.CreateToken(tp,re:GetHandler():GetOriginalCode())
    Duel.SendtoHand(cc,nil,REASON_RULE)
    if(cc:IsLocation(LOCATION_HAND)) then
      Duel.ConfirmCards(1-tp,cc)
    end
    Duel.ShuffleHand(tp)
  end)
end)

function c69015963_filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end

endPhaseSkill(69015963, function(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c69015963_filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end, function(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(c69015963_filter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
end)

standbyPhaseSkill(14532163, function(e,tp,eg,ep,ev,re,r,rp)
  local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end, function(e,tp)
  return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
end)

addSkill(9952083, function(e1)
  e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e1:SetProperty(e1:GetProperty()|EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(3)
end)

local function destroyReplaceFilter(c,tp)
  return c:IsControler(tp) and c:IsReason(REASON_EFFECT)
end

addSkill(47529357, function(e1)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(e1:GetProperty()|EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(destroyReplaceFilter,1,nil,tp) end
    return true
  end)
	e1:SetValue(function(e,c)
    return destroyReplaceFilter(c,e:GetHandlerPlayer())
  end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,47529357)
  end)
end)

standbyPhaseSkill(73915051, function(e,tp,eg,ep,ev,re,r,rp)
  local count=math.min((Duel.GetMZoneCount(tp)),4)
  for i=1,count do
    local token=Duel.CreateToken(tp,73915051+i)
    Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
  end
  Duel.SpecialSummonComplete()
end, function(e,tp,eg,ep,ev,re,r,rp)
  return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,73915052,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_BEAST,ATTRIBUTE_EARTH)
end)

addSkill(53239672, function(e1)
  e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetProperty(e1:GetProperty()|EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(function(e)
    Duel.Hint(HINT_CARD,0,53239672)
    return 0
  end)
  e1:SetCondition(function(e)
    return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)==0
  end)
end)

local function initialize()
  local skillSelections={}
  local skillCodes=getAllSkillCodes()
  for tp=0,1 do
    local g=Group.CreateGroup()
    for _,code in ipairs(skillCodes) do
      local c=Duel.CreateToken(tp,code)
      Duel.Remove(c,POS_FACEDOWN,REASON_RULE)
      g:AddCard(c)
    end
    local tc=g:Select(tp,1,1,nil):GetFirst()
    skillSelections[tp]=tc:GetOriginalCode()
    Duel.Exile(g,REASON_RULE)
  end
  for tp=0,1 do
    registerSkillForPlayer(tp,skillSelections[tp])
  end
end

function Auxiliary.PreloadUds()
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function(e)
		initialize()
		e:Reset()
	end)
	Duel.RegisterEffect(e1,0)
end
