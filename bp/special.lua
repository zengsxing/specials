local program={
  {
    player=0,
    count=1,
  },
  {
    player=1,
    count=2,
  },
  {
    player=0,
    count=2,
  },
  {
    player=1,
    count=2,
  },
  {
    player=0,
    count=2,
  },
  {
    player=1,
    count=1,
  },
  {
    player=1,
    count=-1,
  },
  {
    player=0,
    count=-1,
  },
}

local function init()
  IS_PICKING=true
  for _,task in ipairs(program) do
    if task.count<0 then
      local revCount=-task.count
      local hg=Duel.SelectMatchingCard(task.player,Card.IsAbleToDeck,task.player,0,LOCATION_HAND,revCount,revCount,nil)
      Duel.HintSelection(hg)
      Duel.SendtoDeck(hg,nil,0,REASON_RULE)
      Duel.ShuffleDeck(1-task.player)
      Duel.Draw(1-task.player,revCount,REASON_RULE)
    else
      Duel.Hint(HINT_SELECTMSG,task.player,HINTMSG_ATOHAND)
      local g=Duel.SelectMatchingCard(task.player,Card.IsAbleToHand,task.player,LOCATION_DECK,0,task.count,task.count,nil)
      Duel.SendtoHand(g,task.player,REASON_RULE)
      Duel.ConfirmCards(1-task.player,g)
    end
  end
  Duel.ShuffleHand(0)
  Duel.ShuffleHand(1)
  IS_PICKING=false
end

function Auxiliary.PreloadUds()
	--adjust
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function(e)
    e:Reset()
    init()
  end)
	Duel.RegisterEffect(e1,0)
end
