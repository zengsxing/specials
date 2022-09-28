Duel.LoadScript("lodash.lua")
-- not finished

function Group.Levels(g)
  local levels = {}
  for c in aux.Next(g) do
    table.insert(levels, c:GetLevel())
  end
  table.sort(levels)
  return levels
end

function Group.IsFlush(g)
  return g:GetClassCount(Card.IsAttribute) == 1
end

function Group.IsStraight(g)
  local levels = g:Levels()
  for i = 1, #levels - 1 do
    if levels[i + 1] ~= levels[i] + 1 then
      return false
    end
  end
end

function Group.HighCardValue(g) -- 20 bits
  local levels = {}
  for c in aux.Next(g) do
    table.insert(levels, c:GetLevel())
  end
  table.sort(levels)
  return levels[1] + (levels[2] << 4) + (levels[3] << 8) + (levels[4] << 12) + (levels[5] << 16) 
end

function Group.FindSameLevel(g, count)
  
end

local cardTypes = {
  {
    name = "straight flush",
    level = 9,
    condition = function(g)
      return isFlush(g) and isStraight(g)
    end,
    value = Group.HighCardValue,
  },
  {
    name = "4 of a kind",
    level = 8,
    condition = function(g)
      return g:CheckSubGroup(g, function(sg) return sg:GetClassCount(Card.GetLevel) == 1 end, 4, 4)
    end,
    value = function(g)
      local uniqueCard = g:SearchCard(function(c) 
        return not g:IsExists(function(c2) 
          return c:GetLevel() == c2:GetLevel()
        end, c) 
      end)
      local g2=g-c
      return (g2:GetFirst():GetLevel() << 4) + uniqueCard:GetLevel()
    end,
  },
  {
    name = "full house",
    level = 7,
    condition = function(g)
      return g:CheckSubGroup(g, function(sg) return sg:GetClassCount(Card.GetLevel) == 1 and (sg-g):GetClassCount(Card.GetLevel) == 1 end, 3, 3) and
    end,
    value = function(g)
      local uniqueCard = g:SearchCard(function(c) 
        return not g:IsExists(function(c2) 
          return c:GetLevel() == c2:GetLevel()
        end, c) 
      end)
      local g2=g-c
      return (g2:GetFirst():GetLevel() << 4) + uniqueCard:GetLevel()
    end,
  },
  {
    name = "flush",
    level = 6,
    condition = function(g)
      return isFlush(g)
    end,
    value = Group.HighCardValue,
  },
  {
    name = "straight",
    level = 5,
    condition = function(g)
      return isStraight(g)
    end,
    value = Group.HighCardValue,
  },
  {
    name = "3 of a kind",
    level = 4,
    condition = function(g)
      return g:CheckSubGroup(g, function(sg) return sg:GetClassCount(Card.GetLevel) == 1 end, 3, 3)
    end,
    value = function(g)
      local uniqueCard = g:SearchCard(function(c) 
        return not g:IsExists(function(c2) 
          return c:GetLevel() == c2:GetLevel()
        end, c) 
      end)
      local g2=g-c
      return (g2:GetFirst():GetLevel() << 4) + uniqueCard:GetLevel()
    end,
  },
  {
    name = "2 pair",
    level = 3,
    condition = function(g)
      return g:CheckSubGroup(g, function(sg) return sg:GetClassCount(Card.GetLevel) == 1 end, 2, 2) and
        g:CheckSubGroup(g, function(sg) return sg:GetClassCount(Card.GetLevel) == 1 end, 2, 2)
    end,
  }
}
