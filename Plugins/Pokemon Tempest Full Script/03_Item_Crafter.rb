################################################################################
# Item Crafter
# By Phantombass
# Designed to simplify the Item Crafter Events in Pokemon Tempest
# This is merely an example of how this script works as far as items go. Make your
# own item combinations and add them in their respective sections of this script.
# Then to call in an event, simply add a Script command that says:
#
# pbItemcraft(GameData::Item.get(item)), where item is the internal name of the item.
################################################################################
################################################################################

module Items
  #These are all the variables associated with the HM Items we will be crafting,
  #in order to make the variable reference process easier.
  Choice = 34
  Wingsuit = 79
  Hammer = 80
  Torch = 81
  Chainsaw = 82
  Hovercraft = 83
  ScubaTank = 84
  AquaRocket = 85
  Fulcrum = 86
  HikingGear = 88
end

ItemHandlers::UseFromBag.add(:ITEMCRAFTER,proc { |item|
  next 2
})

ItemHandlers::UseInField.add(:ITEMCRAFTER,proc { |item|
  useItemCrafter
})

def useItemCrafter
  pbMessage(_INTL("What would you like to Craft?\\ch[34,11,Chainsaw,Torch,Fulcrum,Hiking Gear,Aqua Rocket, Scuba Tank,Hovercraft,Escape Rope,Hammer,Wingsuit]"))
  choice = $game_variables[Items::Choice]
  case choice
  when 0; pbItemcraft(GameData::Item.get(:CHAINSAW))
  when 1; pbItemcraft(GameData::Item.get(:TORCH))
  when 2; pbItemcraft(GameData::Item.get(:FULCRUM))
  when 3; pbItemcraft(GameData::Item.get(:HIKINGGEAR))
  when 4; pbItemcraft(GameData::Item.get(:AQUAROCKET))
  when 5; pbItemcraft(GameData::Item.get(:SCUBATANK))
  when 6; pbItemcraft(GameData::Item.get(:HOVERCRAFT))
  when 7; pbItemcraft(GameData::Item.get(:ESCAPEROPE))
  when 8; pbItemcraft(GameData::Item.get(:HAMMER))
  when 9; pbItemcraft(GameData::Item.get(:WINGSUIT))
  end
end

def canItemCraft?(item)
  itemName = GameData::Item.get(item).name
  return false if $PokemonBag.pbHasItem?(item)
  case itemName
  when "Wingsuit"
    return true if $PokemonBag.pbHasItem?(:WINGSUIT1) && $PokemonBag.pbHasItem?(:WINGSUIT2) && $PokemonBag.pbHasItem?(:WINGSUIT3)
  when "Torch"
    return true if $PokemonBag.pbHasItem?(:TORCH1) && $PokemonBag.pbHasItem?(:TORCH2) && $PokemonBag.pbHasItem?(:TORCH3)
  when "Chainsaw"
    return true if $PokemonBag.pbHasItem?(:CHAINSAW1) && $PokemonBag.pbHasItem?(:CHAINSAW2) && $PokemonBag.pbHasItem?(:CHAINSAW3)
  when "Hammer"
    return true if $PokemonBag.pbHasItem?(:HAMMER1) && $PokemonBag.pbHasItem?(:HAMMER2) && $PokemonBag.pbHasItem?(:HAMMER3)
  when "Hovercraft"
    return true if $PokemonBag.pbHasItem?(:HOVER1) && $PokemonBag.pbHasItem?(:HOVER2) && $PokemonBag.pbHasItem?(:HOVER3)
  when "Aqua Rocket"
    return true if $PokemonBag.pbHasItem?(:ROCKET1) && $PokemonBag.pbHasItem?(:ROCKET2) && $PokemonBag.pbHasItem?(:ROCKET3)
  when "Scuba Tank"
    return true if $PokemonBag.pbHasItem?(:SCUBA1) && $PokemonBag.pbHasItem?(:SCUBA2) && $PokemonBag.pbHasItem?(:SCUBA3)
  when "Fulcrum"
    return true if $PokemonBag.pbHasItem?(:FULCRUM1) && $PokemonBag.pbHasItem?(:FULCRUM2) && $PokemonBag.pbHasItem?(:FULCRUM3)
  when "Hiking Gear"
    return true if $PokemonBag.pbHasItem?(:HIKE1) && $PokemonBag.pbHasItem?(:HIKE2) && $PokemonBag.pbHasItem?(:HIKE3)
  when "Escape Rope"
    return true if $PokemonBag.pbHasItem?(:ESCAPE1) && $PokemonBag.pbHasItem?(:ESCAPE2) && $PokemonBag.pbHasItem?(:ESCAPE3)
  end
end

def pbItemcraft(item)
  itemName = GameData::Item.get(item).name
  if !canItemCraft?(item)
    if $PokemonBag.pbHasItem?(item)
      pbMessage(_INTL("You already have a {1}! You do not need another!",itemName))
    else
      pbMessage(_INTL("It appears you do not have the required items to craft the {1} yet.",itemName))
    end
  end
  if canItemCraft?(item)
  case itemName
  when "Wingsuit"
    $PokemonBag.pbDeleteItem(:WINGSUIT1,1)
    $PokemonBag.pbDeleteItem(:WINGSUIT2,1)
    $PokemonBag.pbDeleteItem(:WINGSUIT3,1)
    pbReceiveItem(:WINGSUIT)
    $game_variables[Items::Wingsuit] = 1
  when "Torch"
    $PokemonBag.pbDeleteItem(:TORCH1,1)
    $PokemonBag.pbDeleteItem(:TORCH2,1)
    $PokemonBag.pbDeleteItem(:TORCH3,1)
    pbReceiveItem(:TORCH)
    $game_variables[Items::Torch] = 1
  when "Chainsaw"
    $PokemonBag.pbDeleteItem(:CHAINSAW1,1)
    $PokemonBag.pbDeleteItem(:CHAINSAW2,1)
    $PokemonBag.pbDeleteItem(:CHAINSAW3,1)
    pbReceiveItem(:CHAINSAW)
    $game_variables[Items::Chainsaw] = 1
  when "Hammer"
    $PokemonBag.pbDeleteItem(:HAMMER1,1)
    $PokemonBag.pbDeleteItem(:HAMMER2,1)
    $PokemonBag.pbDeleteItem(:HAMMER3,1)
    pbReceiveItem(:HAMMER)
    $game_variables[Items::Hammer] = 1
  when "Hovercraft"
    $PokemonBag.pbDeleteItem(:HOVER1,1)
    $PokemonBag.pbDeleteItem(:HOVER2,1)
    $PokemonBag.pbDeleteItem(:HOVER3,1)
    pbReceiveItem(:HOVERCRAFT)
    $game_variables[Items::Hovercraft] = 1
  when "Aqua Rocket"
    $PokemonBag.pbDeleteItem(:MYSTICWATER,1)
    $PokemonBag.pbDeleteItem(:DESTINYKNOT,1)
    $PokemonBag.pbDeleteItem(:EJECTBUTTON,1)
    pbReceiveItem(:AQUAROCKET)
    $game_variables[Items::AquaRocket] = 1
  when "Scuba Tank"
    $PokemonBag.pbDeleteItem(:PROTECTIVEPADS,1)
    $PokemonBag.pbDeleteItem(:METALCOAT,1)
    $PokemonBag.pbDeleteItem(:MYSTICWATER,1)
    pbReceiveItem(:SCUBATANK)
    $game_variables[Items::ScubaTank] = 1
  when "Fulcrum"
    $PokemonBag.pbDeleteItem(:FULCRUM1,1)
    $PokemonBag.pbDeleteItem(:FULCRUM2,1)
    $PokemonBag.pbDeleteItem(:FULCRUM3,1)
    pbReceiveItem(:FULCRUM)
    $game_variables[Items::Fulcrum] = 1
  when "Hiking Gear"
    $PokemonBag.pbDeleteItem(:DESTINYKNOT,1)
    $PokemonBag.pbDeleteItem(:STICKYBARB,1)
    $PokemonBag.pbDeleteItem(:IRON,1)
    pbReceiveItem(:HIKINGGEAR)
    $game_variables[Items::HikingGear] = 1
  when "Escape Rope"
    $PokemonBag.pbDeleteItem(:ESCAPE1,1)
    $PokemonBag.pbDeleteItem(:ESCAPE2,1)
    $PokemonBag.pbDeleteItem(:ESCAPE3,1)
    pbReceiveItem(:ESCAPEROPE)
  end
end
end
