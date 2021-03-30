################################################################################
# Item Crafter
# By Phantombass
# Designed to simplify the Item Crafter Events in Pokémon Promenade
# This is merely an example of how this script works as far as items go. Make your
# own item combinations and add them in their respective sections of this script.
# Then to call in an event, simply add a Script command that says:
#
# pbItemcraft(PBItems::item), where item is the internal name of the item.
################################################################################
################################################################################
PluginManager.register({
  :name => "Item Crafter",
  :version => "1.0",
  :credits => "Phantombass",
  :link => "No link yet"
})

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
  useItemCrafter
  })

def useItemCrafter
  pbMessage(_INTL("What would you like to Craft?\\ch[34,11,Chainsaw,Torch,Fulcrum,Hiking Gear,Aqua Rocket, Scuba Tank,Hovercraft,Escape Rope,Hammer,Wingsuit]"))
  choice = $game_variables[Items::Choice]
  case choice
  when 0; pbItemcraft(PBItems::CHAINSAW)
  when 1; pbItemcraft(PBItems::TORCH)
  when 2; pbItemcraft(PBItems::FULCRUM)
  when 3; pbItemcraft(PBItems::HIKINGGEAR)
  when 4; pbItemcraft(PBItems::AQUAROCKET)
  when 5; pbItemcraft(PBItems::SCUBATANK)
  when 6; pbItemcraft(PBItems::HOVERCRAFT)
  when 7; pbItemcraft(PBItems::ESCAPEROPE)
  when 8; pbItemcraft(PBItems::HAMMER)
  when 9; pbItemcraft(PBItems::WINGSUIT)
  end
end

def canItemCraft?(item)
  itemName = PBItems.getName(item)
  return false if hasConst?(PBItems,item) && $PokemonBag.pbHasItem?(item)
  case itemName
  when "Wingsuit"
    return true if $PokemonBag.pbHasItem?(:WINGSUIT1) && $PokemonBag.pbHasItem?(:WINGSUIT2) && $PokemonBag.pbHasItem?(:WINGSUIT3)
  when "Torch"
    return true if $PokemonBag.pbHasItem?(:TORCH1) && $PokemonBag.pbHasItem?(:TORCH2) && $PokemonBag.pbHasItem?(:TORCH3)
  when "Chainsaw"
    return true if $PokemonBag.pbHasItem?(:CHAINSAW1) && $PokemonBag.pbHasItem?(:CHAINSAW2) && $PokemonBag.pbHasItem?(:CHAINSAW3)
  when "Hammer"
    return true if $PokemonBag.pbHasItem?(:LEEK) && $PokemonBag.pbHasItem?(:METALCOAT) && $PokemonBag.pbHasItem?(:THICKCLUB)
  when "Hovercraft"
    return true if $PokemonBag.pbHasItem?(:SPLASHPLATE) && $PokemonBag.pbHasItem?(:MYSTICWATER) && $PokemonBag.pbHasItem?(:FRESHWATER)
  when "Aqua Rocket"
    return true if $PokemonBag.pbHasItem?(:DESTINYKNOT) && $PokemonBag.pbHasItem?(:EJECTBUTTON) && $PokemonBag.pbHasItem?(:MYSTICWATER)
  when "Scuba Tank"
    return true if $PokemonBag.pbHasItem?(:PROTECTIVEPADS) && $PokemonBag.pbHasItem?(:METALCOAT) && $PokemonBag.pbHasItem?(:MYSTICWATER)
  when "Fulcrum"
    return true if $PokemonBag.pbHasItem?(:PROTEIN) && $PokemonBag.pbHasItem?(:HARDSTONE) && $PokemonBag.pbHasItem?(:LUCKYPUNCH)
  when "Hiking Gear"
    return true if $PokemonBag.pbHasItem?(:DESTINYKNOT) && $PokemonBag.pbHasItem?(:STICKYBARB) && $PokemonBag.pbHasItem?(:IRON)
  when "Escape Rope"
    return true if $PokemonBag.pbHasItem?(:ESCAPE1) && $PokemonBag.pbHasItem?(:ESCAPE2) && $PokemonBag.pbHasItem?(:ESCAPE3)
  end
end

def pbItemcraft(item)
  itemName = PBItems.getName(item)
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
    Kernel.pbReceiveItem(:WINGSUIT)
    $game_variables[Items::Wingsuit] = 1
  when "Torch"
    $PokemonBag.pbDeleteItem(:CELLBATTERY,1)
    $PokemonBag.pbDeleteItem(:BRIGHTPOWDER,1)
    $PokemonBag.pbDeleteItem(:IRON,1)
    Kernel.pbReceiveItem(:TORCH)
    $game_variables[Items::Torch] = 1
  when "Chainsaw"
    $PokemonBag.pbDeleteItem(:CHAINSAW1,1)
    $PokemonBag.pbDeleteItem(:CHAINSAW2,1)
    $PokemonBag.pbDeleteItem(:CHAINSAW3,1)
    Kernel.pbReceiveItem(:CHAINSAW)
    $game_variables[Items::Chainsaw] = 1
  when "Hammer"
    $PokemonBag.pbDeleteItem(:LEEK,1)
    $PokemonBag.pbDeleteItem(:METALCOAT,1)
    $PokemonBag.pbDeleteItem(:THICKCLUB,1)
    Kernel.pbReceiveItem(:HAMMER)
    $game_variables[Items::Hammer] = 1
  when "Hovercraft"
    $PokemonBag.pbDeleteItem(:FRESHWATER,1)
    $PokemonBag.pbDeleteItem(:SPLASHPLATE,1)
    $PokemonBag.pbDeleteItem(:MYSTICWATER,1)
    Kernel.pbReceiveItem(:HOVERCRAFT)
    $game_variables[Items::Hovercraft] = 1
  when "Aqua Rocket"
    $PokemonBag.pbDeleteItem(:MYSTICWATER,1)
    $PokemonBag.pbDeleteItem(:DESTINYKNOT,1)
    $PokemonBag.pbDeleteItem(:EJECTBUTTON,1)
    Kernel.pbReceiveItem(:AQUAROCKET)
    $game_variables[Items::AquaRocket] = 1
  when "Scuba Tank"
    $PokemonBag.pbDeleteItem(:PROTECTIVEPADS,1)
    $PokemonBag.pbDeleteItem(:METALCOAT,1)
    $PokemonBag.pbDeleteItem(:MYSTICWATER,1)
    Kernel.pbReceiveItem(:SCUBATANK)
    $game_variables[Items::ScubaTank] = 1
  when "Fulcrum"
    $PokemonBag.pbDeleteItem(:PROTEIN,1)
    $PokemonBag.pbDeleteItem(:HARDSTONE,1)
    $PokemonBag.pbDeleteItem(:LUCKYPUNCH,1)
    Kernel.pbReceiveItem(:FULCRUM)
    $game_variables[Items::Fulcrum] = 1
  when "Hiking Gear"
    $PokemonBag.pbDeleteItem(:DESTINYKNOT,1)
    $PokemonBag.pbDeleteItem(:STICKYBARB,1)
    $PokemonBag.pbDeleteItem(:IRON,1)
    Kernel.pbReceiveItem(:HIKINGGEAR)
    $game_variables[Items::HikingGear] = 1
  when "Escape Rope"
    $PokemonBag.pbDeleteItem(:ESCAPE1,1)
    $PokemonBag.pbDeleteItem(:ESCAPE2,1)
    $PokemonBag.pbDeleteItem(:ESCAPE3,1)
    Kernel.pbReceiveItem(:ESCAPEROPE)
  end
end
end
