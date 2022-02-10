
function Auxiliary.PreloadUds()
    --adjust
    local e1=Effect.GlobalEffect()
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e1:SetCode(EVENT_ADJUST)
    e1:SetOperation(CUNGUI.AdjustOperation)
    Duel.RegisterEffect(e1,0)
end

CUNGUI = {}

function CUNGUI.IsCard(c)
    return Auxiliary.GetValueType(c) == "Card"
end

OrigPayLPCost = Duel.CheckLPCost
Duel.CheckLPCost = function(tp,cost)
    return true
end

OrigPayLPCost = Duel.PayLPCost
Duel.PayLPCost = function(player,cost)
    Duel.Recover(player,cost,REASON_COST)
end

OrigIsAbleToDeckAsCost = Card.IsAbleToDeckAsCost
Card.IsAbleToDeckAsCost = function(c)
    local tc = Duel.GetFieldGroup(c:GetControler(),LOCATION_DECK,0):GetFirst()
    if c:IsLocation(LOCATION_GRAVE) then return tc and OrigIsAbleToGraveAsCost(tc) end
    if c:IsLocation(LOCATION_ONFIELD) then return false end
    if c:IsLocation(LOCATION_HAND) then return Duel.IsPlayerCanDraw(c:GetControler(),1) end
    if c:IsLocation(LOCATION_REMOVED) then
        return tc and OrigIsAbleToRemoveAsCost(tc)
    end
    if c:IsLocation(LOCATION_OVERLAY) then
        local oc = c:GetOverlayTarget()
        return tc and tc:IsCanBeXyzMaterial(oc)
    end
    return false
end

function CUNGUI.SendtoDeckOperation(c,reason)
    local tp = c:GetControler()
    local tc = Duel.GetFieldGroup(tp,LOCATION_DECK,0):GetFirst()
    if c:IsLocation(LOCATION_GRAVE) then return OrigSendtoGrave(tc,reason) end
    if c:IsLocation(LOCATION_ONFIELD) then return false end
    if c:IsLocation(LOCATION_HAND) then return Duel.Draw(tp,1,reason) end
    if c:IsLocation(LOCATION_REMOVED) then return OrigRemove(tc,c:GetPosition(),reason) end
    if c:IsLocation(LOCATION_OVERLAY) then
        local oc = c:GetOverlayTarget()
        Duel.Overlay(oc,tc)
    end
end

OrigSendtoDeck = Duel.SendtoDeck
Duel.SendtoDeck = function(tg,tp,seq,reason)
    if not (reason & REASON_COST)>0 then return OrigSendtoDeck(tg,tp,seq,reason) end
    if CUNGUI.IsCard(tg) then tg = Group.FromCards(tg) end
    for c in aux.Next(tg) do
        CUNGUI.SendtoDeckOperation(c,reason)
    end
end

OrigIsDiscardable = Card.IsDiscardable
Card.IsDiscardable = function(card,reason)
    if not reason then reason = REASON_COST end
    if (reason & REASON_COST)==0 then return OrigIsDiscardable(card,reason) end
    local tp = card:GetControler()
    local loc = LOCATION_GRAVE
    if Duel.IsPlayerAffectedByEffect(tp,EFFECT_TO_GRAVE_REDIRECT) then loc = LOCATION_REMOVED end
    return Duel.IsExistingMatchingCard(Card.IsAbleToHandAsCost,tp,loc,0,1,nil)
end

OrigDiscardHand = Duel.DiscardHand
Duel.DiscardHand = function(tp,f,min,max,reason,ex,...)
    if not reason then reason = REASON_COST end
    if (reason & REASON_COST)==0 then return OrigDiscardHand(tp,f,min,max,reason,ex,...) end
    local loc = LOCATION_GRAVE
    if Duel.IsPlayerAffectedByEffect(tp,EFFECT_TO_GRAVE_REDIRECT) then loc = LOCATION_REMOVED end
    local g = Duel.SelectMatchingCard(tp,Card.IsAbleToHandAsCost,tp,loc,0,min,max,ex,...)
    if not g or #g == 0 then return end
    return OrigSendtoHand(g,nil,reason)
end

OrigIsPlayerCanDiscardDeckAsCost = Duel.IsPlayerCanDiscardDeckAsCost
Duel.IsPlayerCanDiscardDeckAsCost = function(tp,count)
    local loc = LOCATION_GRAVE
    if Duel.IsPlayerAffectedByEffect(tp,EFFECT_TO_GRAVE_REDIRECT) then loc = LOCATION_REMOVED end
    local g=Duel.GetMatchingGroup(nil,tp,loc,0,nil)
    local g2=Group.CreateGroup()
    local tc = g:GetFirst()
    count = count - 1
    while count > 0 do
        g2:AddCard(tc)
        tc=g:GetNext()
        count = count - 1
    end
    local g3=g2:Filter(OrigIsAbleToDeckAsCost,nil)
    return #g3 == count
end

OrigDiscardDeck = Duel.DiscardDeck
Duel.DiscardDeck = function(tp,count,reason)
    if not (reason & REASON_COST) == 0 then return OrigDiscardDeck(tp,count,reason) end
    local loc = LOCATION_GRAVE
    if Duel.IsPlayerAffectedByEffect(tp,EFFECT_TO_GRAVE_REDIRECT) then loc = LOCATION_REMOVED end
    local g=Duel.GetMatchingGroup(nil,tp,loc,0,nil)
    local g2=Group.CreateGroup()
    local tc = g:GetFirst()
    count = count - 1
    while count > 0 do
        g2:AddCard(tc)
        tc=g:GetNext()
        count = count - 1
    end
    local g3=g2:Filter(OrigIsAbleToDeckAsCost,nil)
    return OrigSendtoDeck(g3,nil,0,reason)
end

OrigIsAbleToRemoveAsCost = Card.IsAbleToRemoveAsCost
Card.IsAbleToRemoveAsCost = function(c)
    local tp = c:GetControler()
    local tg = Duel.GetFieldGroup(tp,LOCATION_REMOVED,0)
    if c:IsLocation(LOCATION_ONFIELD) then return false end
    if c:IsLocation(LOCATION_DECK) then
        return tg:IsExists(OrigIsAbleToDeckAsCost,1,nil)
    end
    if c:IsLocation(LOCATION_EXTRA) then
        return tg:IsExists(OrigIsAbleToExtraAsCost,1,nil)
    end
    if c:IsLocation(LOCATION_HAND) then
        return tg:IsExists(OrigIsAbleToHandAsCost,1,nil)
    end
    if c:IsLocation(LOCATION_GRAVE) then
        return tg:IsExists(OrigIsAbleToGraveAsCost,1,nil)
    end
    if c:IsLocation(LOCATION_OVERLAY) then
        local oc = c:GetOverlayTarget()
        return tg:IsExists(Card.IsCanBeXyzMaterial,1,nil,oc)
    end
    return false
end

function CUNGUI.RemoveOperations(c)
    local tp = c:GetControler()
    local tg = Duel.GetFieldGroup(tp,LOCATION_REMOVED,0)
    if c:IsLocation(LOCATION_ONFIELD) then return false end
    if c:IsLocation(LOCATION_DECK) then
        local g2 = tg:Filter(OrigIsAbleToDeckAsCost,nil)
        g2 = g2:Select(tp,1,1,nil)
        if not g2 then
            return 0
        end
        CUNGUI.OperationedCards = CUNGUI.OperationedCards + 1
        return OrigSendtoDeck(g2,nil,2,CUNGUI.RemoveOperationReason)
    end
    if c:IsLocation(LOCATION_EXTRA) then
        local g2 = tg:Filter(OrigIsAbleToExtraAsCost,nil)
        g2 = g2:Select(tp,1,1,nil)
        if not g2 then
            return 0
        end
        CUNGUI.OperationedCards = CUNGUI.OperationedCards + 1
        return OrigSendtoDeck(g2,nil,2,CUNGUI.RemoveOperationReason)
    end
    if c:IsLocation(LOCATION_HAND) then
        local g2 = tg:Filter(OrigIsAbleToHandAsCost,nil)
        g2 = g2:Select(tp,1,1,nil)
        if not g2 then
            return 0
        end
        CUNGUI.OperationedCards = CUNGUI.OperationedCards + 1
        return OrigSendtoHand(g2,nil,CUNGUI.RemoveOperationReason)
    end
    if c:IsLocation(LOCATION_GRAVE) then
        local g2 = tg:Filter(OrigIsAbleToGraveAsCost,nil)
        g2 = g2:Select(tp,1,1,nil)
        if not g2 then
            return 0
        end
        CUNGUI.OperationedCards = CUNGUI.OperationedCards + 1
        return OrigSendtoGrave(g2,CUNGUI.RemoveOperationReason)
    end
    if c:IsLocation(LOCATION_OVERLAY) then
        local oc = c:GetOverlayTarget()
        local g2 = tg:Filter(Card.IsCanBeXyzMaterial,nil,oc)
        g2 = tg:Select(tp,1,1,nil)
        if not g2 then
            return 0
        end
        CUNGUI.OperationedCards = CUNGUI.OperationedCards + 1
        Duel.Overlay(oc,g2)
    end
end

OrigRemove = Duel.Remove
Duel.Remove = function(tg,pos,reason)
    if (reason & REASON_COST) == 0 then return OrigRemove(tg,pos,reason) end
    if CUNGUI.IsCard(tg) then tg=Group.FromCards(tg) end
    CUNGUI.OperationedCards = 0
    CUNGUI.RemoveOperationReason = reason
    for c in aux.Next(tg) do
        CUNGUI.RemoveOperations(c)
    end
    return CUNGUI.OperationedCards
end

OrigIsAbleToGraveAsCost = Card.IsAbleToGraveAsCost
Card.IsAbleToGraveAsCost = function(c)
    local tp = c:GetControler()
    local tg = Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
    if c:IsLocation(LOCATION_ONFIELD) then return false end
    if c:IsLocation(LOCATION_DECK) then
        return tg:IsExists(OrigIsAbleToDeckAsCost,1,nil)
    end
    if c:IsLocation(LOCATION_EXTRA) then
        return tg:IsExists(OrigIsAbleToExtraAsCost,1,nil)
    end
    if c:IsLocation(LOCATION_HAND) then
        return tg:IsExists(OrigIsAbleToHandAsCost,1,nil)
    end
    if c:IsLocation(LOCATION_REMOVED) then
        return tg:IsExists(OrigIsAbleToRemoveAsCost,1,nil)
    end
    if c:IsLocation(LOCATION_OVERLAY) then
        local oc = c:GetOverlayTarget()
        return tg:IsExists(Card.IsCanBeXyzMaterial,1,nil,oc)
    end
    return false
end

function CUNGUI.SendtoGraveOperations(c,reason)
    local tp = c:GetControler()
    local tg = Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
    if c:IsLocation(LOCATION_ONFIELD) then return false end
    if c:IsLocation(LOCATION_DECK) then
        local g2 = tg:Filter(OrigIsAbleToDeckAsCost,nil)
        g2 = g2:Select(tp,1,1,nil)
        if not g2 then
            return 0
        end
        CUNGUI.OperationedCards = CUNGUI.OperationedCards + 1
        return OrigSendtoDeck(g2,nil,2,reason)
    end
    if c:IsLocation(LOCATION_EXTRA) then
        local g2 = tg:Filter(OrigIsAbleToExtraAsCost,nil)
        g2 = g2:Select(tp,1,1,nil)
        if not g2 then
            return 0
        end
        CUNGUI.OperationedCards = CUNGUI.OperationedCards + 1
        return OrigSendtoDeck(g2,nil,2,reason)
    end
    if c:IsLocation(LOCATION_HAND) then
        local g2 = tg:Filter(OrigIsAbleToHandAsCost,nil)
        Duel.DisableActionCheck(true)
        g2 = g2:Select(tp,1,1,nil)
        Duel.DisableActionCheck(false)
        if not g2 then
            return 0
        end
        CUNGUI.OperationedCards = CUNGUI.OperationedCards + 1
        return OrigSendtoHand(g2,nil,reason)
    end
    if c:IsLocation(LOCATION_REMOVED) then
        local g2 = tg:Filter(OrigIsAbleToRemoveAsCost,nil)
        g2 = g2:Select(tp,1,1,nil)
        if not g2 then
            return 0
        end
        CUNGUI.OperationedCards = CUNGUI.OperationedCards + 1
        return OrigRemove(g2,c:GetPosition(),reason)
    end
    if c:IsLocation(LOCATION_OVERLAY) then
        local oc = c:GetOverlayTarget()
        local g2 = tg:Filter(Card.IsCanBeXyzMaterial,nil,oc)
        g2 = tg:Select(tp,1,1,nil)
        if not g2 then
            return 0
        end
        CUNGUI.OperationedCards = CUNGUI.OperationedCards + 1
        Duel.Overlay(oc,g2)
    end
end

OrigSendtoGrave = Duel.SendtoGrave
Duel.SendtoGrave = function(tg,reason)
    if (reason & REASON_COST) == 0 then return OrigSendtoGrave(tg,reason) end
    if CUNGUI.IsCard(tg) then tg = Group.FromCards(tg) end
    CUNGUI.OperationedCards = 0
    for c in aux.Next(tg) do
        CUNGUI.SendtoGraveOperations(c,reason)
    end
    return CUNGUI.OperationedCards
end

OrigIsAbleToHandAsCost = Card.IsAbleToHandAsCost
Card.IsAbleToHandAsCost = function(c)
    local tp = c:GetControler()
    local tg = Duel.GetFieldGroup(tp,LOCATION_HAND,0)
    if c:IsLocation(LOCATION_ONFIELD+LOCATION_EXTRA) then return false end
    if c:IsLocation(LOCATION_DECK) then
        return tg:IsExists(OrigIsAbleToDeckAsCost,1,nil)
    end
    if c:IsLocation(LOCATION_GRAVE) then
        return tg:IsExists(OrigIsAbleToGraveAsCost,1,nil)
    end
    if c:IsLocation(LOCATION_REMOVED) then
        return tg:IsExists(OrigIsAbleToRemoveAsCost,1,nil)
    end
    if c:IsLocation(LOCATION_OVERLAY) then
        local oc = c:GetOverlayTarget()
        return tg:IsExists(Card.IsCanBeXyzMaterial,1,nil,oc)
    end
    return false
end

function CUNGUI.SendtoHandOperations(c)
    local tp = c:GetControler()
    local tg = Duel.GetFieldGroup(tp,LOCATION_HAND,0)
    if c:IsLocation(LOCATION_ONFIELD+LOCATION_EXTRA) then return false end
    if c:IsLocation(LOCATION_DECK) then
        local g2 = tg:Filter(OrigIsAbleToDeckAsCost,nil)
        g2 = g2:Select(tp,1,1,nil)
        if not g2 then
            return 0
        end
        CUNGUI.OperationedCards = CUNGUI.OperationedCards + 1
        return OrigSendtoDeck(g2,nil,2,CUNGUI.SendtoHandOperationReason)
    end
    if c:IsLocation(LOCATION_EXTRA) then
        local g2 = tg:Filter(OrigIsAbleToExtraAsCost,nil)
        g2 = g2:Select(tp,1,1,nil)
        if not g2 then
            return 0
        end
        CUNGUI.OperationedCards = CUNGUI.OperationedCards + 1
        return OrigSendtoDeck(g2,nil,2,CUNGUI.SendtoHandOperationReason)
    end
    if c:IsLocation(LOCATION_GRAVE) then
        local g2 = tg:Filter(OrigIsAbleToGraveAsCost,nil)
        g2 = g2:Select(tp,1,1,nil)
        if not g2 then
            return 0
        end
        CUNGUI.OperationedCards = CUNGUI.OperationedCards + 1
        return OrigSendtoGrave(g2,CUNGUI.RemoveOperationReason)
    end
    if c:IsLocation(LOCATION_REMOVED) then
        local g2 = tg:Filter(OrigIsAbleToRemoveAsCost,nil)
        g2 = g2:Select(tp,1,1,nil)
        if not g2 then
            return 0
        end
        CUNGUI.OperationedCards = CUNGUI.OperationedCards + 1
        return OrigRemove(g2,c:GetPosition(),CUNGUI.SendtoHandOperationReason)
    end
    if c:IsLocation(LOCATION_OVERLAY) then
        local oc = c:GetOverlayTarget()
        local g2 = tg:Filter(Card.IsCanBeXyzMaterial,nil,oc)
        g2 = tg:Select(tp,1,1,nil)
        if not g2 then
            return 0
        end
        CUNGUI.OperationedCards = CUNGUI.OperationedCards + 1
        Duel.Overlay(oc,g2)
    end
end

OrigSendtoHand = Duel.SendtoHand
Duel.SendtoHand = function(tg,tp,reason)
    if (reason & REASON_COST) == 0 then return OrigSendtoHand(tg,tp,reason) end
    if CUNGUI.IsCard(tg) then tg = Group.FromCards(tg) end
    CUNGUI.SendtoHandOperationReason = reason
    CUNGUI.OperationedCards = 0
    for c in aux.Next(tg) do
        CUNGUI.SendtoHandOperations(c)
    end
    return CUNGUI.OperationedCards
end

function CUNGUI.CheckRemoveOverlayCardFilter(c,tp,loc)
    local g=Duel.GetMatchingGroup(Card.IsCanBeXyzMaterial,tp,loc,0,nil,c)
    Group.Merge(g,CUNGUI.DuelRemoveOverlayCardTargets)
    return #g>0
end

OrigCheckRemoveOverlayCard = Duel.CheckRemoveOverlayCard
Duel.CheckRemoveOverlayCard = function(c,tp,count,reason)
    if (reason & REASON_COST) == 0 then return OrigCheckRemoveOverlayCard(c,tp,count,reason) end
    local loc = LOCATION_GRAVE
    if Duel.IsPlayerAffectedByEffect(tp,EFFECT_TO_GRAVE_REDIRECT) then loc = LOCATION_REMOVED end
    CUNGUI.DuelRemoveOverlayCardTargets = Group.CreateGroup()
    local tg = Duel.GetMatchingGroup(CUNGUI.CheckRemoveOverlayCardFilter,tp,loc,0,nil,tp,loc)
    return #tg>0 and #CUNGUI.DuelRemoveOverlayCardTargets>=#tg
end

function CUNGUI.DuelRemoveOverlayCardFilter2(c,tc)
    return tc:IsCanBeXyzMaterial(c)
end

OrigDuelRemoveOverlayCard = Duel.RemoveOverlayCard
Duel.RemoveOverlayCard = function(tp,s,o,min,max,reason)
    if (reason & REASON_COST) == 0 then return OrigDuelRemoveOverlayCard(tp,s,o,min,max,reason) end
    CUNGUI.DuelRemoveOverlayCardTargets = Group.CreateGroup()
    local tg = Duel.GetMatchingGroup(CUNGUI.CheckRemoveOverlayCardFilter,tp,s,o,nil,tp,LOCATION_GRAVE)
    local selected = 0
    while #CUNGUI.DuelRemoveOverlayCardTargets > 0
        and (selected < min or (selected < max and Duel.SelectYesNo(tp,aux.Stringid(71867500,0)))) do
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
        local tc = CUNGUI.DuelRemoveOverlayCardTargets:Select(tp,1,1,nil)
        Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(HINTMSG_TOZONE))
        local oc = Duel.SelectMatchingCard(tp,CUNGUI.DuelRemoveOverlayCardFilter2,tp,s,o,1,1,nil,tc)
        Duel.Overlay(oc,tc)
        CUNGUI.DuelRemoveOverlayCardTargets:RemoveCard(tc)
    end
end

OrigCardRemoveOverlayCard = Card.RemoveOverlayCard
Card.RemoveOverlayCard = function(c,tp,min,max,reason)
    if (reason & REASON_COST) == 0 then return OrigCardRemoveOverlayCard(c,tp,min,max,reason) end
    local loc = LOCATION_GRAVE
    if Duel.IsPlayerAffectedByEffect(tp,EFFECT_TO_GRAVE_REDIRECT) then loc = LOCATION_REMOVED end
    local tg = Duel.GetMatchingGroup(Card.IsCanBeXyzMaterial,tp,loc,0,nil,c)
    local selected = 0
    while #tg > 0
        and (selected < min or (selected < max and Duel.SelectYesNo(tp,aux.Stringid(71867500,0)))) do
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
        local tc = tg:Select(tp,1,1,nil)
        Duel.Overlay(c,tc)
        CUNGUI.DuelRemoveOverlayCardTargets:RemoveCard(tc)
    end
end


OrigIsAbleToExtraAsCost = Card.IsAbleToExtraAsCost
Card.IsAbleToExtraAsCost = function(c)
    local tp = c:GetControler()
    local tg = Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
    tg = tg:Filter(Card.IsType,nil,TYPE_PENDULUM)
    if c:IsLocation(LOCATION_ONFIELD) then return false end
    if c:IsLocation(LOCATION_DECK) then
        return tg:IsExists(OrigIsAbleToDeckAsCost,1,nil)
    end
    if c:IsLocation(LOCATION_HAND) then
        return tg:IsExists(OrigIsAbleToHandAsCost,1,nil)
    end
    if c:IsLocation(LOCATION_GRAVE) then
        return tg:IsExists(OrigIsAbleToGraveAsCost,1,nil)
    end
    if c:IsLocation(LOCATION_REMOVED) then
        return tg:IsExists(OrigIsAbleToRemoveAsCost,1,nil)
    end
    if c:IsLocation(LOCATION_OVERLAY) then
        local oc = c:GetOverlayTarget()
        return tg:IsExists(Card.IsCanBeXyzMaterial,1,nil,oc)
    end
    return false
end

function CUNGUI.SendtoExtraPFilter(c)
    return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end

OrigSendtoExtra = Duel.SendtoExtraP
Duel.SendtoExtraP = function(targets,player,reason)
    if not (reason & REASON_COST)>0 then return OrigSendtoExtra(targets,player,reason) end
    if CUNGUI.IsCard(targets) then targets = Group.FromCards(targets) end
    local opCards = 0
    local og = Group.CreateGroup()
    for tc in aux.Next(targets) do
        local tp = tc:GetControler()
        local g = Duel.SelectMatchingCard(tp,CUNGUI.SendtoExtraPFilter,player,LOCATION_EXTRA,0,1,1,og)
        if g and #g > 0 then
            og:Merge(g)
            if tc:IsLocation(LOCATION_DECK) then opCards = opCards + OrigSendtoDeck(g,nil,2,reason)
            elseif tc:IsLocation(LOCATION_OVERLAY) then opCards = opCards + Duel.Overlay(tc:GetOverlayTarget(),g)
            elseif tc:IsLocation(LOCATION_GRAVE) then opCards = opCards + OrigSendtoGrave(g,reason)
            elseif tc:IsLocation(LOCATION_REMOVED) then opCards = opCards + OrigRemove(g,g:GetFirst():GetPosition(),reason)
            elseif tc:IsLocation(LOCATION_HAND) then opCards = opCards + OrigSendtoHand(g,nil,reason)
            end
        end
    end
    return opCards
end

function CUNGUI.AdjustOperation(e,tp,eg,ep,ev,re,r,rp)
    Duel.Draw(1,1,REASON_RULE)
    --Duel.DisableActionCheck(true)
    e:Reset()
end
