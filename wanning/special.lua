local skillLists={}

local function addSkill(code, skill)
  skillLists[code]=skill
end

local function getAllSkillCodes()
  local skillCodes={}
  for code,_ in pairs(skillLists) do
    table.insert(skillCodes, code)
  end
  return skillCodes
end

local function registerSkillForPlayer(tp, c)
  local skill=skillLists[c:GetOriginalCode()]
  local e1=Effect.GlobalEffect()
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
  skill(e1)
  Duel.RegisterEffect(e1,tp)
end

local function phaseSkill(code, phase, op, con)
  addSkill(code, function(e1)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+phase)
    e1:SetCountLimit(1)
    e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
      return Duel.GetTurnPlayer()==tp and (not con or con(e,tp,eg,ep,ev,re,r,rp))
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

local function drawPhaseSkill(code, op, con)
  phaseSkill(code, PHASE_DRAW, op, con)
end

local function standbyPhaseSkill(code, op, con)
  phaseSkill(code, PHASE_STANDBY, op, con)
end

local function endPhaseSkill(code, op, con)
  phaseSkill(code, PHASE_END, op, con)
end

drawPhaseSkill(48356796, function(e,tp,eg,ep,ev,re,r,rp)
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
  Duel.Recover(tp,4000,REASON_EFFECT)
end)

endPhaseSkill(19523799, function(e,tp,eg,ep,ev,re,r,rp)
  Duel.Damage(1-tp,3200,REASON_EFFECT)
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

function c18144506_filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end

standbyPhaseSkill(18144506, function(e,tp,eg,ep,ev,re,r,rp)
  local sg=Duel.GetMatchingGroup(c18144506_filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(sg,REASON_RULE)
end, function(e,tp)
  return Duel.IsExistingMatchingCard(c18144506_filter,tp,0,LOCATION_ONFIELD,1,nil)
end)

function c12580477_filter(c)
	return true
end

standbyPhaseSkill(12580477, function(e,tp,eg,ep,ev,re,r,rp)
  local sg=Duel.GetMatchingGroup(c12580477_filter,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_RULE)
end, function(e,tp)
  return Duel.IsExistingMatchingCard(c12580477_filter,tp,0,LOCATION_MZONE,1,nil)
end)

addSkill(9952083, function(e1)
  e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(3)
end)

addSkill(47529357, function(e1)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_DESTROY_REPLACE)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return eg:IsExists(Card.IsControler,1,nil,tp) end
    return true
  end)
	e1:SetValue(function(e,c)
    return c:IsControler(e:GetHandlerPlayer())
  end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,47529357)
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
    skillSelections[tp]=tc
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
