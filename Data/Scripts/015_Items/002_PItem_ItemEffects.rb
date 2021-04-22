#===============================================================================
# UseText handlers
#===============================================================================
ItemHandlers::UseText.add(:BICYCLE,proc { |item|
  next ($PokemonGlobal.bicycle) ? _INTL("Walk") : _INTL("Use")
})

ItemHandlers::UseText.copy(:BICYCLE,:MACHBIKE,:ACROBIKE)

#===============================================================================
# UseFromBag handlers
# Return values: 0 = not used
#                1 = used, item not consumed
#                2 = close the Bag to use, item not consumed
#                3 = used, item consumed
#                4 = close the Bag to use, item consumed
# If there is no UseFromBag handler for an item being used from the Bag (not on
# a Pokémon and not a TM/HM), calls the UseInField handler for it instead.
#===============================================================================

ItemHandlers::UseFromBag.add(:HONEY,proc { |item|
  next 4
})

ItemHandlers::UseFromBag.add(:ESCAPEROPE,proc { |item|
  if $game_player.pbHasDependentEvents?
    pbMessage(_INTL("It can't be used when you have someone with you."))
    next 0
  end
  if ($PokemonGlobal.escapePoint rescue false) && $PokemonGlobal.escapePoint.length>0
    next 2   # End screen and not consume item
  end
  pbMessage(_INTL("Can't use that here."))
  next 0
})

ItemHandlers::UseFromBag.add(:BICYCLE,proc { |item|
  next (pbBikeCheck) ? 2 : 0
})

ItemHandlers::UseFromBag.copy(:BICYCLE,:MACHBIKE,:ACROBIKE)

ItemHandlers::UseFromBag.add(:OLDROD,proc { |item|
  terrain = pbFacingTerrainTag
  notCliff = $game_map.passable?($game_player.x,$game_player.y,$game_player.direction,$game_player)
  if (PBTerrain.isWater?(terrain) && !$PokemonGlobal.surfing && notCliff) ||
     (PBTerrain.isWater?(terrain) && $PokemonGlobal.surfing)
    next 2
  end
  pbMessage(_INTL("Can't use that here."))
  next 0
})

ItemHandlers::UseFromBag.copy(:OLDROD,:GOODROD,:SUPERROD)

ItemHandlers::UseFromBag.add(:ITEMFINDER,proc { |item|
  next 2
})

ItemHandlers::UseFromBag.copy(:ITEMFINDER,:DOWSINGMCHN,:DOWSINGMACHINE)

#===============================================================================
# ConfirmUseInField handlers
# Return values: true/false
# Called when an item is used from the Ready Menu.
# If an item does not have this handler, it is treated as returning true.
#===============================================================================

ItemHandlers::ConfirmUseInField.add(:ESCAPEROPE,proc { |item|
  escape = ($PokemonGlobal.escapePoint rescue nil)
  if !escape || escape==[]
    pbMessage(_INTL("Can't use that here."))
    next false
  end
  if $game_player.pbHasDependentEvents?
    pbMessage(_INTL("It can't be used when you have someone with you."))
    next false
  end
  mapname = pbGetMapNameFromId(escape[0])
  next pbConfirmMessage(_INTL("Want to escape from here and return to {1}?",mapname))
})

#===============================================================================
# UseInField handlers
# Return values: 0 = not used
#                1 = used, item not consumed
#                3 = used, item consumed
# Called if an item is used from the Bag (not on a Pokémon and not a TM/HM) and
# there is no UseFromBag handler above.
# If an item has this handler, it can be registered to the Ready Menu.
#===============================================================================

def pbRepel(item,steps)
  if $PokemonGlobal.repel>0
    pbMessage(_INTL("But a repellent's effect still lingers from earlier."))
    return 0
  end
  pbUseItemMessage(item)
  $PokemonGlobal.repel = steps
  return 3
end

ItemHandlers::UseInField.add(:REPEL,proc { |item|
  next pbRepel(item,100)
})

ItemHandlers::UseInField.add(:SUPERREPEL,proc { |item|
  next pbRepel(item,200)
})

ItemHandlers::UseInField.add(:MAXREPEL,proc { |item|
  next pbRepel(item,250)
})

Events.onStepTaken += proc{
  if !PBTerrain.isIce?($game_player.terrain_tag) # Shouldn't count down if on ice
    if $PokemonGlobal.repel>0
      $PokemonGlobal.repel -= 1
      if $PokemonGlobal.repel<=0
        if $PokemonBag.pbHasItem?(:REPEL) ||
           $PokemonBag.pbHasItem?(:SUPERREPEL) ||
           $PokemonBag.pbHasItem?(:MAXREPEL)
          if pbConfirmMessage(_INTL("The repellent's effect wore off! Would you like to use another one?"))
            if $PokemonBag.pbHasItem?(:REPEL) && !$PokemonBag.pbHasItem?(:SUPERREPEL) && !$PokemonBag.pbHasItem?(:MAXREPEL)
              pbMessage(_INTL("Which one?\\ch[34,2,Repel]"))
              if pbGet(34) == 0
                pbUseItem($PokemonBag,:REPEL)
              end
            elsif !$PokemonBag.pbHasItem?(:REPEL) && $PokemonBag.pbHasItem?(:SUPERREPEL) && !$PokemonBag.pbHasItem?(:MAXREPEL)
              pbMessage(_INTL("\\ch[34,2,Super Repel]"))
              if pbGet(34) == 0
                pbUseItem($PokemonBag,:SUPERREPEL)
              end
            elsif !$PokemonBag.pbHasItem?(:REPEL) && !$PokemonBag.pbHasItem?(:SUPERREPEL) && $PokemonBag.pbHasItem?(:MAXREPEL)
              pbMessage(_INTL("\\ch[34,2,Max Repel]"))
              if pbGet(34) == 0
                pbUseItem($PokemonBag,:MAXREPEL)
              end
            elsif $PokemonBag.pbHasItem?(:REPEL) && $PokemonBag.pbHasItem?(:SUPERREPEL) && !$PokemonBag.pbHasItem?(:MAXREPEL)
              pbMessage(_INTL("\\ch[34,3,Repel,Super Repel]"))
              if pbGet(34) == 0
                pbUseItem($PokemonBag,:REPEL)
              elsif pbGet(34) == 1
                pbUseItem($PokemonBag,:SUPERREPEL)
              end
            elsif !$PokemonBag.pbHasItem?(:REPEL) && $PokemonBag.pbHasItem?(:SUPERREPEL) && $PokemonBag.pbHasItem?(:MAXREPEL)
              pbMessage(_INTL("\\ch[34,3,Super Repel,Max Repel]"))
              if pbGet(34) == 0
                pbUseItem($PokemonBag,:SUPERREPEL)
              elsif pbGet(34) == 1
                pbUseItem($PokemonBag,:MAXREPEL)
              end
            elsif $PokemonBag.pbHasItem?(:REPEL) && !$PokemonBag.pbHasItem?(:SUPERREPEL) && $PokemonBag.pbHasItem?(:MAXREPEL)
              pbMessage(_INTL("\\ch[34,3,Repel,Max Repel]"))
              if pbGet(34) == 0
                pbUseItem($PokemonBag,:REPEL)
              elsif pbGet(34) == 1
                pbUseItem($PokemonBag,:MAXREPEL)
              end
            elsif $PokemonBag.pbHasItem?(:REPEL) && $PokemonBag.pbHasItem?(:SUPERREPEL) && $PokemonBag.pbHasItem?(:MAXREPEL)
              pbMessage(_INTL("\\ch[34,3,Repel,Super Repel,Max Repel]"))
              if pbGet(34) == 0
                pbUseItem($PokemonBag,:REPEL)
              elsif pbGet(34) == 1
                pbUseItem($PokemonBag,:SUPERREPEL)
              elsif pbGet(34) == 2
                pbUseItem($PokemonBag,:MAXREPEL)
              end
            end
          end
        else
          pbMessage(_INTL("The repellent's effect wore off!"))
        end
      end
    end
  end
}

ItemHandlers::UseInField.add(:BLACKFLUTE,proc { |item|
  pbUseItemMessage(item)
  pbMessage(_INTL("Wild Pokémon will be repelled."))
  $PokemonMap.blackFluteUsed = true
  $PokemonMap.whiteFluteUsed = false
  next 1
})

ItemHandlers::UseInField.add(:WHITEFLUTE,proc { |item|
  pbUseItemMessage(item)
  pbMessage(_INTL("Wild Pokémon will be lured."))
  $PokemonMap.blackFluteUsed = false
  $PokemonMap.whiteFluteUsed = true
  next 1
})

ItemHandlers::UseInField.add(:HONEY,proc { |item|
  pbUseItemMessage(item)
  pbSweetScent
  next 3
})

ItemHandlers::UseInField.add(:ESCAPEROPE,proc { |item|
  escape = ($PokemonGlobal.escapePoint rescue nil)
  if !escape || escape==[]
    pbMessage(_INTL("Can't use that here."))
    next 0
  end
  if $game_player.pbHasDependentEvents?
    pbMessage(_INTL("It can't be used when you have someone with you."))
    next 0
  end
  pbUseItemMessage(item)
  pbFadeOutIn {
    $game_temp.player_new_map_id    = escape[0]
    $game_temp.player_new_x         = escape[1]
    $game_temp.player_new_y         = escape[2]
    $game_temp.player_new_direction = escape[3]
    pbCancelVehicles
    $scene.transfer_player
    $game_map.autoplay
    $game_map.refresh
  }
  pbEraseEscapePoint
  next 2
})

ItemHandlers::UseInField.add(:SACREDASH,proc { |item|
  if $Trainer.pokemonCount==0
    pbMessage(_INTL("There is no Pokémon."))
    next 0
  end
  if $game_switches[73] == true
    pbMessage(_INTL("It won't have any effect."))
    next 0
  end
  canrevive = false
  for i in $Trainer.pokemonParty
    next if !i.fainted?
    canrevive = true; break
  end
  if !canrevive
    pbMessage(_INTL("It won't have any effect."))
    next 0
  end
  revived = 0
  pbFadeOutIn {
    scene = PokemonParty_Scene.new
    screen = PokemonPartyScreen.new(scene,$Trainer.party)
    screen.pbStartScene(_INTL("Using item..."),false)
    for i in 0...$Trainer.party.length
      if $Trainer.party[i].fainted?
        revived += 1
        $Trainer.party[i].heal
        screen.pbRefreshSingle(i)
        screen.pbDisplay(_INTL("{1}'s HP was restored.",$Trainer.party[i].name))
      end
    end
    if revived==0
      screen.pbDisplay(_INTL("It won't have any effect."))
    end
    screen.pbEndScene
  }
  next (revived==0) ? 0 : 3
})

ItemHandlers::UseInField.add(:BICYCLE,proc { |item|
  if pbBikeCheck
    if $PokemonGlobal.bicycle
      pbDismountBike
    else
      pbMountBike
    end
    next 1
  end
  next 0
})

ItemHandlers::UseInField.copy(:BICYCLE,:MACHBIKE,:ACROBIKE)

ItemHandlers::UseInField.add(:OLDROD,proc { |item|
  terrain = pbFacingTerrainTag
  notCliff = $game_map.passable?($game_player.x,$game_player.y,$game_player.direction,$game_player)
  if !PBTerrain.isWater?(terrain) || (!notCliff && !$PokemonGlobal.surfing)
    pbMessage(_INTL("Can't use that here."))
    next 0
  end
  encounter = $PokemonEncounters.hasEncounter?(EncounterTypes::OldRod)
  if pbFishing(encounter,1)
    pbEncounter(EncounterTypes::OldRod)
  end
  next 1
})

ItemHandlers::UseInField.add(:GOODROD,proc { |item|
  terrain = pbFacingTerrainTag
  notCliff = $game_map.passable?($game_player.x,$game_player.y,$game_player.direction,$game_player)
  if !PBTerrain.isWater?(terrain) || (!notCliff && !$PokemonGlobal.surfing)
    pbMessage(_INTL("Can't use that here."))
    next 0
  end
  encounter = $PokemonEncounters.hasEncounter?(EncounterTypes::GoodRod)
  if pbFishing(encounter,2)
    pbEncounter(EncounterTypes::GoodRod)
  end
  next 1
})

ItemHandlers::UseInField.add(:SUPERROD,proc { |item|
  terrain = pbFacingTerrainTag
  notCliff = $game_map.passable?($game_player.x,$game_player.y,$game_player.direction,$game_player)
  if !PBTerrain.isWater?(terrain) || (!notCliff && !$PokemonGlobal.surfing)
    pbMessage(_INTL("Can't use that here."))
    next 0
  end
  encounter = $PokemonEncounters.hasEncounter?(EncounterTypes::SuperRod)
  if pbFishing(encounter,3)
    pbEncounter(EncounterTypes::SuperRod)
  end
  next 1
})

ItemHandlers::UseInField.add(:ITEMFINDER,proc { |item|
  event = pbClosestHiddenItem
  if !event
    pbMessage(_INTL("... \\wt[10]... \\wt[10]... \\wt[10]...\\wt[10]Nope! There's no response."))
  else
    offsetX = event.x-$game_player.x
    offsetY = event.y-$game_player.y
    if offsetX==0 && offsetY==0   # Standing on the item, spin around
      4.times do
        pbWait(Graphics.frame_rate*2/10)
        $game_player.turn_right_90
      end
      pbWait(Graphics.frame_rate*3/10)
      pbMessage(_INTL("The {1}'s indicating something right underfoot!",PBItems.getName(item)))
    else   # Item is nearby, face towards it
      direction = $game_player.direction
      if offsetX.abs>offsetY.abs
        direction = (offsetX<0) ? 4 : 6
      else
        direction = (offsetY<0) ? 8 : 2
      end
      case direction
      when 2; $game_player.turn_down
      when 4; $game_player.turn_left
      when 6; $game_player.turn_right
      when 8; $game_player.turn_up
      end
      pbWait(Graphics.frame_rate*3/10)
      pbMessage(_INTL("Huh? The {1}'s responding!\1",PBItems.getName(item)))
      pbMessage(_INTL("There's an item buried around here!"))
    end
  end
  next 1
})

ItemHandlers::UseInField.copy(:ITEMFINDER,:DOWSINGMCHN,:DOWSINGMACHINE)

ItemHandlers::UseInField.add(:TOWNMAP,proc { |item|
  pbShowMap(-1,false)
  next 1
})

ItemHandlers::UseInField.add(:COINCASE,proc { |item|
  pbMessage(_INTL("Coins: {1}",$PokemonGlobal.coins.to_s_formatted))
  next 1
})

ItemHandlers::UseInField.add(:EXPALL,proc { |item|
  $PokemonBag.pbChangeItem(:EXPALL,:EXPALLOFF)
  pbMessage(_INTL("The Exp Share was turned off."))
  next 1
})

ItemHandlers::UseInField.add(:EXPALLOFF,proc { |item|
  $PokemonBag.pbChangeItem(:EXPALLOFF,:EXPALL)
  pbMessage(_INTL("The Exp Share was turned on."))
  next 1
})

#===============================================================================
# UseOnPokemon handlers
#===============================================================================

# Applies to all items defined as an evolution stone.
# No need to add more code for new ones.
ItemHandlers::UseOnPokemon.addIf(proc { |item| pbIsEvolutionStone?(item)},
  proc { |item,pkmn,scene|
    if pkmn.shadowPokemon?
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    newspecies = pbCheckEvolution(pkmn,item)
    if newspecies<=0
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    else
      pbFadeOutInWithMusic {
        evo = PokemonEvolutionScene.new
        evo.pbStartScreen(pkmn,newspecies)
        evo.pbEvolution(false)
        evo.pbEndScreen
        if scene.is_a?(PokemonPartyScreen)
          scene.pbRefreshAnnotations(proc { |p| pbCheckEvolution(p,item)>0 })
          scene.pbRefresh
        end
      }
      next true
    end
  }
)

ItemHandlers::UseOnPokemon.add(:POTION,proc { |item,pkmn,scene|
  next pbHPItem(pkmn,20,scene)
})

ItemHandlers::UseOnPokemon.copy(:POTION,:BERRYJUICE,:SWEETHEART)
ItemHandlers::UseOnPokemon.copy(:POTION,:RAGECANDYBAR) if !NEWEST_BATTLE_MECHANICS

ItemHandlers::UseOnPokemon.add(:SUPERPOTION,proc { |item,pkmn,scene|
  next pbHPItem(pkmn,50,scene)
})

ItemHandlers::UseOnPokemon.add(:HYPERPOTION,proc { |item,pkmn,scene|
  next pbHPItem(pkmn,200,scene)
})

ItemHandlers::UseOnPokemon.add(:MAXPOTION,proc { |item,pkmn,scene|
  next pbHPItem(pkmn,pkmn.totalhp-pkmn.hp,scene)
})

ItemHandlers::UseOnPokemon.add(:FRESHWATER,proc { |item,pkmn,scene|
  next pbHPItem(pkmn,50,scene)
})

ItemHandlers::UseOnPokemon.add(:SODAPOP,proc { |item,pkmn,scene|
  next pbHPItem(pkmn,60,scene)
})

ItemHandlers::UseOnPokemon.add(:LEMONADE,proc { |item,pkmn,scene|
  next pbHPItem(pkmn,80,scene)
})

ItemHandlers::UseOnPokemon.add(:MOOMOOMILK,proc { |item,pkmn,scene|
  next pbHPItem(pkmn,100,scene)
})

ItemHandlers::UseOnPokemon.add(:ORANBERRY,proc { |item,pkmn,scene|
  next pbHPItem(pkmn,10,scene)
})

ItemHandlers::UseOnPokemon.add(:SITRUSBERRY,proc { |item,pkmn,scene|
  next pbHPItem(pkmn,pkmn.totalhp/4,scene)
})

ItemHandlers::UseOnPokemon.add(:AWAKENING,proc { |item,pkmn,scene|
  if pkmn.fainted? || pkmn.status!=PBStatuses::SLEEP
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.healStatus
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1} woke up.",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.copy(:AWAKENING,:CHESTOBERRY,:BLUEFLUTE,:POKEFLUTE)

ItemHandlers::UseOnPokemon.add(:ANTIDOTE,proc { |item,pkmn,scene|
  if pkmn.fainted? || pkmn.status!=PBStatuses::POISON
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.healStatus
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1} was cured of its poisoning.",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.copy(:ANTIDOTE,:PECHABERRY)

ItemHandlers::UseOnPokemon.add(:BURNHEAL,proc { |item,pkmn,scene|
  if pkmn.fainted? || pkmn.status!=PBStatuses::BURN
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.healStatus
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1}'s burn was healed.",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.copy(:BURNHEAL,:RAWSTBERRY)

ItemHandlers::UseOnPokemon.add(:PARLYZHEAL,proc { |item,pkmn,scene|
  if pkmn.fainted? || pkmn.status!=PBStatuses::PARALYSIS
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.healStatus
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1} was cured of paralysis.",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.copy(:PARLYZHEAL,:PARALYZEHEAL,:CHERIBERRY)

ItemHandlers::UseOnPokemon.add(:ICEHEAL,proc { |item,pkmn,scene|
  if pkmn.fainted? || pkmn.status!=PBStatuses::FROZEN
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.healStatus
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1} was thawed out.",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.copy(:ICEHEAL,:ASPEARBERRY)

ItemHandlers::UseOnPokemon.add(:FULLHEAL,proc { |item,pkmn,scene|
  if pkmn.fainted? || pkmn.status==PBStatuses::NONE
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.healStatus
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1} became healthy.",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.copy(:FULLHEAL,
   :LAVACOOKIE,:OLDGATEAU,:CASTELIACONE,:LUMIOSEGALETTE,:SHALOURSABLE,
   :BIGMALASADA,:LUMBERRY)
ItemHandlers::UseOnPokemon.copy(:FULLHEAL,:RAGECANDYBAR) if NEWEST_BATTLE_MECHANICS

ItemHandlers::UseOnPokemon.add(:FULLRESTORE,proc { |item,pkmn,scene|
  if pkmn.fainted? || (pkmn.hp==pkmn.totalhp && pkmn.status==PBStatuses::NONE)
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  hpgain = pbItemRestoreHP(pkmn,pkmn.totalhp-pkmn.hp)
  pkmn.healStatus
  scene.pbRefresh
  if hpgain>0
    scene.pbDisplay(_INTL("{1}'s HP was restored by {2} points.",pkmn.name,hpgain))
  else
    scene.pbDisplay(_INTL("{1} became healthy.",pkmn.name))
  end
  next true
})

ItemHandlers::UseOnPokemon.add(:REVIVE,proc { |item,pkmn,scene|
  if !pkmn.fainted? || $game_switches[73] == true
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.hp = (pkmn.totalhp/2).floor
  pkmn.hp = 1 if pkmn.hp<=0
  pkmn.healStatus
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1}'s HP was restored.",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:MAXREVIVE,proc { |item,pkmn,scene|
  if !pkmn.fainted? || $game_switches[73] == true
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.healHP
  pkmn.healStatus
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1}'s HP was restored.",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:ENERGYPOWDER,proc { |item,pkmn,scene|
  if pbHPItem(pkmn,50,scene)
    pkmn.changeHappiness("powder")
    next true
  end
  next false
})

ItemHandlers::UseOnPokemon.add(:ENERGYROOT,proc { |item,pkmn,scene|
  if pbHPItem(pkmn,200,scene)
    pkmn.changeHappiness("energyroot")
    next true
  end
  next false
})

ItemHandlers::UseOnPokemon.add(:HEALPOWDER,proc { |item,pkmn,scene|
  if pkmn.fainted? || pkmn.status==PBStatuses::NONE
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.healStatus
  pkmn.changeHappiness("powder")
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1} became healthy.",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:REVIVALHERB,proc { |item,pkmn,scene|
  if !pkmn.fainted? || $game_switches[73] == true
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.healHP
  pkmn.healStatus
  pkmn.changeHappiness("revivalherb")
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1}'s HP was restored.",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:ETHER,proc { |item,pkmn,scene|
  move = scene.pbChooseMove(pkmn,_INTL("Restore which move?"))
  next false if move<0
  if pbRestorePP(pkmn,move,10)==0
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("PP was restored."))
  next true
})

ItemHandlers::UseOnPokemon.copy(:ETHER,:LEPPABERRY)

ItemHandlers::UseOnPokemon.add(:MAXETHER,proc { |item,pkmn,scene|
  move = scene.pbChooseMove(pkmn,_INTL("Restore which move?"))
  next false if move<0
  if pbRestorePP(pkmn,move,pkmn.moves[move].totalpp-pkmn.moves[move].pp)==0
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("PP was restored."))
  next true
})

ItemHandlers::UseOnPokemon.add(:ELIXIR,proc { |item,pkmn,scene|
  pprestored = 0
  for i in 0...pkmn.moves.length
    pprestored += pbRestorePP(pkmn,i,10)
  end
  if pprestored==0
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("PP was restored."))
  next true
})

ItemHandlers::UseOnPokemon.add(:MAXELIXIR,proc { |item,pkmn,scene|
  pprestored = 0
  for i in 0...pkmn.moves.length
    pprestored += pbRestorePP(pkmn,i,pkmn.moves[i].totalpp-pkmn.moves[i].pp)
  end
  if pprestored==0
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("PP was restored."))
  next true
})

ItemHandlers::UseOnPokemon.add(:PPUP,proc { |item,pkmn,scene|
  move = scene.pbChooseMove(pkmn,_INTL("Boost PP of which move?"))
  if move>=0
    if pkmn.moves[move].totalpp<=1 || pkmn.moves[move].ppup>=3
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    pkmn.moves[move].ppup += 1
    movename = PBMoves.getName(pkmn.moves[move].id)
    scene.pbDisplay(_INTL("{1}'s PP increased.",movename))
    next true
  end
  next false
})

ItemHandlers::UseOnPokemon.add(:PPMAX,proc { |item,pkmn,scene|
  move = scene.pbChooseMove(pkmn,_INTL("Boost PP of which move?"))
  if move>=0
    if pkmn.moves[move].totalpp<=1 || pkmn.moves[move].ppup>=3
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    pkmn.moves[move].ppup = 3
    movename = PBMoves.getName(pkmn.moves[move].id)
    scene.pbDisplay(_INTL("{1}'s PP increased.",movename))
    next true
  end
  next false
})

ItemHandlers::UseOnPokemon.add(:HPUP,proc { |item,pkmn,scene|
  if pbRaiseEffortValues(pkmn,PBStats::HP)==0
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1}'s HP increased.",pkmn.name))
  pkmn.changeHappiness("vitamin")
  next true
})

ItemHandlers::UseOnPokemon.add(:PROTEIN,proc { |item,pkmn,scene|
  if pbRaiseEffortValues(pkmn,PBStats::ATTACK)==0
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("{1}'s Attack increased.",pkmn.name))
  pkmn.changeHappiness("vitamin")
  next true
})

ItemHandlers::UseOnPokemon.add(:IRON,proc { |item,pkmn,scene|
  if pbRaiseEffortValues(pkmn,PBStats::DEFENSE)==0
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("{1}'s Defense increased.",pkmn.name))
  pkmn.changeHappiness("vitamin")
  next true
})

ItemHandlers::UseOnPokemon.add(:CALCIUM,proc { |item,pkmn,scene|
  if pbRaiseEffortValues(pkmn,PBStats::SPATK)==0
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("{1}'s Special Attack increased.",pkmn.name))
  pkmn.changeHappiness("vitamin")
  next true
})

ItemHandlers::UseOnPokemon.add(:ZINC,proc { |item,pkmn,scene|
  if pbRaiseEffortValues(pkmn,PBStats::SPDEF)==0
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("{1}'s Special Defense increased.",pkmn.name))
  pkmn.changeHappiness("vitamin")
  next true
})

ItemHandlers::UseOnPokemon.add(:CARBOS,proc { |item,pkmn,scene|
  if pbRaiseEffortValues(pkmn,PBStats::SPEED)==0
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("{1}'s Speed increased.",pkmn.name))
  pkmn.changeHappiness("vitamin")
  next true
})

ItemHandlers::UseOnPokemon.add(:HEALTHWING,proc { |item,pkmn,scene|
  if pbRaiseEffortValues(pkmn,PBStats::HP,1,false)==0
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1}'s HP increased.",pkmn.name))
  pkmn.changeHappiness("wing")
  next true
})

ItemHandlers::UseOnPokemon.add(:MUSCLEWING,proc { |item,pkmn,scene|
  if pbRaiseEffortValues(pkmn,PBStats::ATTACK,1,false)==0
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("{1}'s Attack increased.",pkmn.name))
  pkmn.changeHappiness("wing")
  next true
})

ItemHandlers::UseOnPokemon.add(:RESISTWING,proc { |item,pkmn,scene|
  if pbRaiseEffortValues(pkmn,PBStats::DEFENSE,1,false)==0
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("{1}'s Defense increased.",pkmn.name))
  pkmn.changeHappiness("wing")
  next true
})

ItemHandlers::UseOnPokemon.add(:GENIUSWING,proc { |item,pkmn,scene|
  if pbRaiseEffortValues(pkmn,PBStats::SPATK,1,false)==0
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("{1}'s Special Attack increased.",pkmn.name))
  pkmn.changeHappiness("wing")
  next true
})

ItemHandlers::UseOnPokemon.add(:CLEVERWING,proc { |item,pkmn,scene|
  if pbRaiseEffortValues(pkmn,PBStats::SPDEF,1,false)==0
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("{1}'s Special Defense increased.",pkmn.name))
  pkmn.changeHappiness("wing")
  next true
})

ItemHandlers::UseOnPokemon.add(:SWIFTWING,proc { |item,pkmn,scene|
  if pbRaiseEffortValues(pkmn,PBStats::SPEED,1,false)==0
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  scene.pbDisplay(_INTL("{1}'s Speed increased.",pkmn.name))
  pkmn.changeHappiness("wing")
  next true
})

ItemHandlers::UseOnPokemon.add(:RARECANDY,proc { |item,pkmn,scene|
  if pkmn.level>=PBExperience.maxLevel || pkmn.shadowPokemon? || pkmn.level >= $game_variables[Level::Cap]
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pbChangeLevel(pkmn,pkmn.level+1,scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:ADAMANTMINT,proc { |item,pkmn,scene|
  if pkmn.nature==PBNatures::ADAMANT
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(PBNatures::ADAMANT)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:BRAVEMINT,proc { |item,pkmn,scene|
  if pkmn.nature==PBNatures::BRAVE
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(PBNatures::BRAVE)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:NAUGHTYMINT,proc { |item,pkmn,scene|
  if pkmn.nature==PBNatures::NAUGHTY
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(PBNatures::NAUGHTY)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:LONELYMINT,proc { |item,pkmn,scene|
  if pkmn.nature==PBNatures::LONELY
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(PBNatures::LONELY)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:BOLDMINT,proc { |item,pkmn,scene|
  if pkmn.nature==PBNatures::BOLD
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(PBNatures::BOLD)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:IMPISHMINT,proc { |item,pkmn,scene|
  if pkmn.nature==PBNatures::IMPISH
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(PBNatures::IMPISH)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:LAXMINT,proc { |item,pkmn,scene|
  if pkmn.nature==PBNatures::LAX
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(PBNatures::LAX)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:RELAXEDMINT,proc { |item,pkmn,scene|
  if pkmn.nature==PBNatures::RELAXED
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(PBNatures::RELAXED)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:MODESTMINT,proc { |item,pkmn,scene|
  if pkmn.nature==PBNatures::MODEST
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(PBNatures::MODEST)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:MILDMINT,proc { |item,pkmn,scene|
  if pkmn.nature==PBNatures::MILD
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(PBNatures::MILD)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:RASHMINT,proc { |item,pkmn,scene|
  if pkmn.nature==PBNatures::RASH
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(PBNatures::RASH)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:QUIETMINT,proc { |item,pkmn,scene|
  if pkmn.nature==PBNatures::QUIET
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(PBNatures::QUIET)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:CALMMINT,proc { |item,pkmn,scene|
  if pkmn.nature==PBNatures::CALM
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(PBNatures::CALM)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:GENTLEMINT,proc { |item,pkmn,scene|
  if pkmn.nature==PBNatures::GENTLE
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(PBNatures::GENTLE)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:CAREFULMINT,proc { |item,pkmn,scene|
  if pkmn.nature==PBNatures::CAREFUL
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(PBNatures::CAREFUL)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:SASSYMINT,proc { |item,pkmn,scene|
  if pkmn.nature==PBNatures::SASSY
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(PBNatures::SASSY)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:TIMIDMINT,proc { |item,pkmn,scene|
  if pkmn.nature==PBNatures::TIMID
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(PBNatures::TIMID)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:HASTYMINT,proc { |item,pkmn,scene|
  if pkmn.nature==PBNatures::HASTY
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(PBNatures::HASTY)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:JOLLYMINT,proc { |item,pkmn,scene|
  if pkmn.nature==PBNatures::JOLLY
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(PBNatures::JOLLY)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:NAIVEMINT,proc { |item,pkmn,scene|
  if pkmn.nature==PBNatures::NAIVE
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(PBNatures::NAIVE)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:BASHFULMINT,proc { |item,pkmn,scene|
  if pkmn.nature==PBNatures::BASHFUL
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(PBNatures::BASHFUL)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:HARDYMINT,proc { |item,pkmn,scene|
  if pkmn.nature==PBNatures::HARDY
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(PBNatures::HARDY)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:DOCILEMINT,proc { |item,pkmn,scene|
  if pkmn.nature==PBNatures::DOCILE
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(PBNatures::DOCILE)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:QUIRKYMINT,proc { |item,pkmn,scene|
  if pkmn.nature==PBNatures::QUIRKY
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(PBNatures::QUIRKY)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:SERIOUSMINT,proc { |item,pkmn,scene|
  if pkmn.nature==PBNatures::SERIOUS
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(PBNatures::SERIOUS)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:IVMAXSTONE,proc { |item,pkmn,scene|
  choices = []
  for i in 0...6
    stat = PBStats
    choices.push(_INTL(stat.getName(i)))
  end
  choices.push(_INTL("Cancel"))
  command = pbMessage("Which IV would you like to max out?",choices,choices.length)
  statChoice = (command == 6) ? -1 : command
  next false if statChoice == -1
  if pkmn.iv[statChoice] == 31
    scene.pbDisplay(_INTL("This stat is already maxed out!"))
    return false
  end
  statDisp = stat.getName(statChoice)
    pkmn.iv[statChoice] = 31
    pkmn.calcStats
    scene.pbDisplay(_INTL("{1}'s {2} IVs were maxed out!",pkmn.name,statDisp))
  next true
})

ItemHandlers::UseOnPokemon.add(:IVMINSTONE,proc { |item,pkmn,scene|
  choices = []
  for i in 0...6
    stat = PBStats
    choices.push(_INTL(stat.getName(i)))
  end
  choices.push(_INTL("Cancel"))
  command = pbMessage("Which IV would you like to zero out?",choices,choices.length)
  statChoice = (command == 6) ? -1 : command
  next false if statChoice == -1
  if pkmn.iv[statChoice] == 0
    scene.pbDisplay(_INTL("This stat is already zeroed out!"))
    return false
  end
  statDisp = stat.getName(statChoice)
    pkmn.iv[statChoice] = 0
    pkmn.calcStats
    scene.pbDisplay(_INTL("{1}'s {2} IVs were zeroed out!",pkmn.name,statDisp))
  next true
})

ItemHandlers::UseOnPokemon.add(:POMEGBERRY,proc { |item,pkmn,scene|
  next pbRaiseHappinessAndLowerEV(pkmn,scene,PBStats::HP,[
     _INTL("{1} adores you! Its base HP fell!",pkmn.name),
     _INTL("{1} became more friendly. Its base HP can't go lower.",pkmn.name),
     _INTL("{1} became more friendly. However, its base HP fell!",pkmn.name)
  ])
})

ItemHandlers::UseOnPokemon.add(:KELPSYBERRY,proc { |item,pkmn,scene|
  next pbRaiseHappinessAndLowerEV(pkmn,scene,PBStats::ATTACK,[
     _INTL("{1} adores you! Its base Attack fell!",pkmn.name),
     _INTL("{1} became more friendly. Its base Attack can't go lower.",pkmn.name),
     _INTL("{1} became more friendly. However, its base Attack fell!",pkmn.name)
  ])
})

ItemHandlers::UseOnPokemon.add(:QUALOTBERRY,proc { |item,pkmn,scene|
  next pbRaiseHappinessAndLowerEV(pkmn,scene,PBStats::DEFENSE,[
     _INTL("{1} adores you! Its base Defense fell!",pkmn.name),
     _INTL("{1} became more friendly. Its base Defense can't go lower.",pkmn.name),
     _INTL("{1} became more friendly. However, its base Defense fell!",pkmn.name)
  ])
})

ItemHandlers::UseOnPokemon.add(:HONDEWBERRY,proc { |item,pkmn,scene|
  next pbRaiseHappinessAndLowerEV(pkmn,scene,PBStats::SPATK,[
     _INTL("{1} adores you! Its base Special Attack fell!",pkmn.name),
     _INTL("{1} became more friendly. Its base Special Attack can't go lower.",pkmn.name),
     _INTL("{1} became more friendly. However, its base Special Attack fell!",pkmn.name)
  ])
})

ItemHandlers::UseOnPokemon.add(:GREPABERRY,proc { |item,pkmn,scene|
  next pbRaiseHappinessAndLowerEV(pkmn,scene,PBStats::SPDEF,[
     _INTL("{1} adores you! Its base Special Defense fell!",pkmn.name),
     _INTL("{1} became more friendly. Its base Special Defense can't go lower.",pkmn.name),
     _INTL("{1} became more friendly. However, its base Special Defense fell!",pkmn.name)
  ])
})

ItemHandlers::UseOnPokemon.add(:TAMATOBERRY,proc { |item,pkmn,scene|
  next pbRaiseHappinessAndLowerEV(pkmn,scene,PBStats::SPEED,[
     _INTL("{1} adores you! Its base Speed fell!",pkmn.name),
     _INTL("{1} became more friendly. Its base Speed can't go lower.",pkmn.name),
     _INTL("{1} became more friendly. However, its base Speed fell!",pkmn.name)
  ])
})

ItemHandlers::UseOnPokemon.add(:GRACIDEA,proc { |item,pkmn,scene|
  if !pkmn.isSpecies?(:SHAYMIN) || pkmn.form!=0 ||
     pkmn.status==PBStatuses::FROZEN || PBDayNight.isNight?
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  end
  if pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
    next false
  end
  pkmn.setForm(1) {
    scene.pbRefresh
    scene.pbDisplay(_INTL("{1} changed Forme!",pkmn.name))
  }
  next true
})

ItemHandlers::UseOnPokemon.add(:REDNECTAR,proc { |item,pkmn,scene|
  if !pkmn.isSpecies?(:ORICORIO) || pkmn.form==0
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  end
  if pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
  end
  pkmn.setForm(0) {
    scene.pbRefresh
    scene.pbDisplay(_INTL("{1} changed form!",pkmn.name))
  }
  next true
})

ItemHandlers::UseOnPokemon.add(:YELLOWNECTAR,proc { |item,pkmn,scene|
  if !pkmn.isSpecies?(:ORICORIO) || pkmn.form==1
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  end
  if pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
  end
  pkmn.setForm(1) {
    scene.pbRefresh
    scene.pbDisplay(_INTL("{1} changed form!",pkmn.name))
  }
  next true
})

ItemHandlers::UseOnPokemon.add(:PINKNECTAR,proc { |item,pkmn,scene|
  if !pkmn.isSpecies?(:ORICORIO) || pkmn.form==2
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  end
  if pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
  end
  pkmn.setForm(2) {
    scene.pbRefresh
    scene.pbDisplay(_INTL("{1} changed form!",pkmn.name))
  }
  next true
})

ItemHandlers::UseOnPokemon.add(:PURPLENECTAR,proc { |item,pkmn,scene|
  if !pkmn.isSpecies?(:ORICORIO) || pkmn.form==3
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  end
  if pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
  end
  pkmn.setForm(3) {
    scene.pbRefresh
    scene.pbDisplay(_INTL("{1} changed form!",pkmn.name))
  }
  next true
})

ItemHandlers::UseOnPokemon.add(:REVEALGLASS,proc { |item,pkmn,scene|
  if !pkmn.isSpecies?(:TORNADUS) &&
     !pkmn.isSpecies?(:THUNDURUS) &&
     !pkmn.isSpecies?(:LANDORUS)
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  end
  if pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
    next false
  end
  newForm = (pkmn.form==0) ? 1 : 0
  pkmn.setForm(newForm) {
    scene.pbRefresh
    scene.pbDisplay(_INTL("{1} changed Forme!",pkmn.name))
  }
  next true
})

ItemHandlers::UseOnPokemon.add(:PRISONBOTTLE,proc { |item,pkmn,scene|
  if !pkmn.isSpecies?(:HOOPA)
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  end
  if pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
  end
  newForm = (pkmn.form==0) ? 1 : 0
  pkmn.setForm(newForm) {
    scene.pbRefresh
    scene.pbDisplay(_INTL("{1} changed Forme!",pkmn.name))
  }
  next true
})

ItemHandlers::UseOnPokemon.add(:DNASPLICERS,proc { |item,pkmn,scene|
  if !pkmn.isSpecies?(:KYUREM)
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  end
  if pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
  end
  # Fusing
  if pkmn.fused==nil
    chosen = scene.pbChoosePokemon(_INTL("Fuse with which Pokémon?"))
    next false if chosen<0
    poke2 = $Trainer.party[chosen]
    if pkmn==poke2
      scene.pbDisplay(_INTL("It cannot be fused with itself."))
    elsif poke2.egg?
      scene.pbDisplay(_INTL("It cannot be fused with an Egg."))
    elsif poke2.fainted?
      scene.pbDisplay(_INTL("It cannot be fused with that fainted Pokémon."))
    elsif !poke2.isSpecies?(:RESHIRAM) &&
          !poke2.isSpecies?(:ZEKROM)
      scene.pbDisplay(_INTL("It cannot be fused with that Pokémon."))
    end
    newForm = 0
    newForm = 1 if poke2.isSpecies?(:RESHIRAM)
    newForm = 2 if poke2.isSpecies?(:ZEKROM)
    pkmn.setForm(newForm) {
      pkmn.fused = poke2
      pbRemovePokemonAt(chosen)
      scene.pbHardRefresh
      scene.pbDisplay(_INTL("{1} changed Forme!",pkmn.name))
    }
    next true
  end
  # Unfusing
  if $Trainer.party.length>=6
    scene.pbDisplay(_INTL("You have no room to separate the Pokémon."))
    next false
  end
  pkmn.setForm(0) {
    $Trainer.party[$Trainer.party.length] = pkmn.fused
    pkmn.fused = nil
    scene.pbHardRefresh
    scene.pbDisplay(_INTL("{1} changed Forme!",pkmn.name))
  }
  next true
})

ItemHandlers::UseOnPokemon.add(:NSOLARIZER,proc { |item,pkmn,scene|
  if !pkmn.isSpecies?(:NECROZMA) || pkmn.form==0
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  end
  if pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
  end
  # Fusing
  if pkmn.fused==nil
    chosen = scene.pbChoosePokemon(_INTL("Fuse with which Pokémon?"))
    next false if chosen<0
    poke2 = $Trainer.party[chosen]
    if pkmn==poke2
      scene.pbDisplay(_INTL("It cannot be fused with itself."))
    elsif poke2.egg?
      scene.pbDisplay(_INTL("It cannot be fused with an Egg."))
    elsif poke2.fainted?
      scene.pbDisplay(_INTL("It cannot be fused with that fainted Pokémon."))
    elsif !poke2.isSpecies?(:SOLGALEO)
      scene.pbDisplay(_INTL("It cannot be fused with that Pokémon."))
    end
    pkmn.setForm(1) {
      pkmn.fused = poke2
      pbRemovePokemonAt(chosen)
      scene.pbHardRefresh
      scene.pbDisplay(_INTL("{1} changed Forme!",pkmn.name))
    }
    next true
  end
  # Unfusing
  if $Trainer.party.length>=6
    scene.pbDisplay(_INTL("You have no room to separate the Pokémon."))
    next false
  end
  pkmn.setForm(0) {
    $Trainer.party[$Trainer.party.length] = pkmn.fused
    pkmn.fused = nil
    scene.pbHardRefresh
    scene.pbDisplay(_INTL("{1} changed Forme!",pkmn.name))
  }
  next true
})

ItemHandlers::UseOnPokemon.add(:NLUNARIZER,proc { |item,pkmn,scene|
  if !pkmn.isSpecies?(:NECROZMA) || pkmn.form==1
    scene.pbDisplay(_INTL("It had no effect."))
    next false
  end
  if pkmn.fainted?
    scene.pbDisplay(_INTL("This can't be used on the fainted Pokémon."))
  end
  # Fusing
  if pkmn.fused==nil
    chosen = scene.pbChoosePokemon(_INTL("Fuse with which Pokémon?"))
    next false if chosen<0
    poke2 = $Trainer.party[chosen]
    if pkmn==poke2
      scene.pbDisplay(_INTL("It cannot be fused with itself."))
    elsif poke2.egg?
      scene.pbDisplay(_INTL("It cannot be fused with an Egg."))
    elsif poke2.fainted?
      scene.pbDisplay(_INTL("It cannot be fused with that fainted Pokémon."))
    elsif !poke2.isSpecies?(:LUNALA)
      scene.pbDisplay(_INTL("It cannot be fused with that Pokémon."))
    end
    pkmn.setForm(2) {
      pkmn.fused = poke2
      pbRemovePokemonAt(chosen)
      scene.pbHardRefresh
      scene.pbDisplay(_INTL("{1} changed Forme!",pkmn.name))
    }
    next true
  end
  # Unfusing
  if $Trainer.party.length>=6
    scene.pbDisplay(_INTL("You have no room to separate the Pokémon."))
    next false
  end
  pkmn.setForm(0) {
    $Trainer.party[$Trainer.party.length] = pkmn.fused
    pkmn.fused = nil
    scene.pbHardRefresh
    scene.pbDisplay(_INTL("{1} changed Forme!",pkmn.name))
  }
  next true
})

ItemHandlers::UseOnPokemon.add(:ABILITYCAPSULE,proc { |item,pkmn,scene|
  abils = pkmn.getAbilityList
  abil1 = 0; abil2 = 0
  for i in abils
    abil1 = i[0] if i[1]==0
    abil2 = i[0] if i[1]==1
  end
  if abil1<=0 || abil2<=0 || pkmn.hasHiddenAbility? || pkmn.isSpecies?(:ZYGARDE)
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  newabil = (pkmn.abilityIndex+1)%2
  newabilname = PBAbilities.getName((newabil==0) ? abil1 : abil2)
  if scene.pbConfirm(_INTL("Would you like to change {1}'s Ability to {2}?",
     pkmn.name,newabilname))
    pkmn.setAbility(newabil)
    scene.pbRefresh
    scene.pbDisplay(_INTL("{1}'s Ability changed to {2}!",pkmn.name,
       PBAbilities.getName(pkmn.ability)))
    next true
  end
  next false
})

ItemHandlers::UseOnPokemon.add(:ABILITYPATCH,proc { |item,pkmn,scene|
  abils = pkmn.getAbilityList
  abil1 = 0; abil2 = 0; hAbil = 0
  for i in abils
    abil1 = i[0] if i[1]==0
    abil2 = i[0] if i[1]==1
    hAbil = i[0] if i[1]==2
  end
  if pkmn.isSpecies?(:HOPPALM) || pkmn.isSpecies?(:PAPYRUN) || pkmn.isSpecies?(:NEFLORA) || pkmn.isSpecies?(:CHARPHINCH) || pkmn.isSpecies?(:PHIRUNDO) || pkmn.isSpecies?(:PHIRENIX) || pkmn.isSpecies?(:BARBOL) || pkmn.isSpecies?(:BOWLTISIS) || pkmn.isSpecies?(:SATURABTU) || pkmn.isSpecies?(:APOPHICARY) || pkmn.isSpecies?(:FALKMUNRA) || pkmn.isSpecies?(:CASTFORM) || pkmn.isSpecies?(:FORMETEOS) || pkmn.isSpecies?(:UNOWN) || pkmn.isSpecies?(:EYEROGLYPH) || pkmn.isSpecies?(:SPOOKLOTH) || pkmn.isSpecies?(:RELICLOTH) || pkmn.isSpecies?(:CORPUSCUFF) || pkmn.isSpecies?(:YAMASK) || pkmn.isSpecies?(:COFAGRIGUS) || pkmn.isSpecies?(:RUNERIGUS)
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.hasHiddenAbility? && abil2 != nil
  abilChoose = rand(2)+1
  newabil = pkmn.abilityIndex-abilChoose
  newabilname = PBAbilities.getName((newabil==0) ? abil1 : abil2)
  if scene.pbConfirm(_INTL("Would you like to change {1}'s Ability to {2}?",
     pkmn.name,newabilname))
    pkmn.setAbility(newabil)
    scene.pbRefresh
    scene.pbDisplay(_INTL("{1}'s Ability changed to {2}!",pkmn.name,
       PBAbilities.getName(pkmn.ability)))
    next true
  end
elsif pkmn.hasHiddenAbility? && abil2 == nil
  newabil = pkmn.abilityIndex-2
  newabilname = PBAbilities.getName((newabil==0) ? abil1 : abil2)
  if scene.pbConfirm(_INTL("Would you like to change {1}'s Ability to {2}?",
     pkmn.name,newabilname))
    pkmn.setAbility(newabil)
    scene.pbRefresh
    scene.pbDisplay(_INTL("{1}'s Ability changed to {2}!",pkmn.name,
       PBAbilities.getName(pkmn.ability)))
    next true
  end
else
  !pkmn.hasHiddenAbility?
  newabilname = PBAbilities.getName(hAbil)
  if scene.pbConfirm(_INTL("Would you like to change {1}'s Ability to {2}?",
     pkmn.name,newabilname))
    pkmn.setAbility(2)
    scene.pbRefresh
    scene.pbDisplay(_INTL("{1}'s Ability changed to {2}!",pkmn.name,
       PBAbilities.getName(pkmn.ability)))
    next true
  end
  next false
end
})

ItemHandlers::UseFromBag.add(:CHAINSAW,proc{|item|
   next canUseMoveCut? ? 2 : 0
})

ItemHandlers::UseInField.add(:CHAINSAW,proc{|item|
   useMoveCut if canUseMoveCut?
})
ItemHandlers::UseFromBag.add(:SCUBATANK,proc{|item|
   next canUseMoveDive? ? 2 : 0
})

ItemHandlers::UseInField.add(:SCUBATANK,proc{|item|
   useMoveDive if canUseMoveDive?
})
ItemHandlers::UseFromBag.add(:TORCH,proc{|item|
   next canUseMoveFlash? ? 2 : 0
})

ItemHandlers::UseInField.add(:TORCH,proc{|item|
   useMoveFlash if canUseMoveFlash?
})
ItemHandlers::UseFromBag.add(:WINGSUIT,proc{|item|
   next canUseMoveFly? ? 2 : 0
})

ItemHandlers::UseInField.add(:WINGSUIT,proc{|item|
   useMoveFly if canUseMoveFly?
})
ItemHandlers::UseInField.add(:ITEMCRAFTER,proc{|item|
   useItemCrafter
})
ItemHandlers::UseFromBag.add(:HAMMER,proc{|item|
   next canUseMoveRockSmash? ? 2 : 0
})

ItemHandlers::UseInField.add(:HAMMER,proc{|item|
   useMoveRockSmash if canUseMoveRockSmash?
})
ItemHandlers::UseFromBag.add(:STRENGTHITEM,proc{|item|
   next canUseMoveStrength? ? 2 : 0
})

ItemHandlers::UseInField.add(:STRENGTHITEM,proc{|item|
   useMoveStrength if canUseMoveStrength?
})
ItemHandlers::UseFromBag.add(:HOVERCRAFT,proc{|item|
   next canUseMoveSurf? ? 2 : 0
})

ItemHandlers::UseInField.add(:HOVERCRAFT,proc{|item|
   useMoveSurf if canUseMoveSurf?
})
ItemHandlers::UseFromBag.add(:AQUAROCKET,proc{|item|
   next canUseMoveWaterfall? ? 2 : 0
})

ItemHandlers::UseInField.add(:AQUAROCKET,proc{|item|
   useMoveWaterfall if canUseMoveWaterfall?
})

ItemHandlers::UseFromBag.add(:HIKINGGEAR,proc{|item|
   next canUseMoveRockClimb? ? 2 : 0
})

ItemHandlers::UseInField.add(:HIKINGGEAR,proc{|item|
   useMoveRockClimb if canUseMoveRockClimb?
})
