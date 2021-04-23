  module Level
    Cap = 106
  end

  module Chapter
    Count = 502
  end

Events.onMapUpdate += proc {| sender, e |
    case $game_variables[Chapter::Count]
    when 1
      $game_variables[Level::Cap] = 13
    when 2
      if $game_variables[Mission::Mission2] < 2
        $game_variables[Level::Cap] = 13
      else
        $game_variables[Level::Cap] = 20
      end
    when 3
      if $game_variables[Mission::Mission3]<3
        $game_variables[Level::Cap] = 26
      elsif $game_variables[Mission::Mission3]>=3
        if $game_variables[Mission::Mission3]<6
          $game_variables[Level::Cap] = 30
        end
      elsif $game_variables[Mission::Mission3]>=6
        $game_variables[Level::Cap] = 35
      end
    end
}

Events.onStepTaken += proc {| sender, e |
    case $game_variables[Chapter::Count]
    when 1
      $game_variables[Level::Cap] = 13
    when 2
      if $game_variables[Mission::Mission2] < 2
        $game_variables[Level::Cap] = 13
      else
        $game_variables[Level::Cap] = 20
      end
    when 3
      if $game_variables[Mission::Mission3]<3
        $game_variables[Level::Cap] = 26
      elsif $game_variables[Mission::Mission3]>=3
          if $game_variables[Mission::Mission3]<6
            $game_variables[Level::Cap] = 30
          end
      elsif $game_variables[Mission::Mission3]>=6
        $game_variables[Level::Cap] = 35
      end
    end
}

def pbHoneyTree
  if pbConfirmMessage("There may be a Pokémon in this tree!\\nWould you like to use a Honey?")
    if vHI("Honey")
      vDI("Honey",1)
      honeyEnc = rand(100)+1
      if honeyEnc < 51
        pbMessage(_INTL("You didn't manage to find anything."))
      elsif honeyEnc >= 51 && honeyEnc < 81
        vWB("Yanma",19)
      elsif honeyEnc >= 81 && honeyEnc < 96
        vWB("Heracross",20)
      elsif honeyEnc >= 96
        vWB("Scyther",21)
      end
    elsif !vHI("Honey")
      pbMessage(_INTL("You don't have any Honey..."))
    end
  end
end

def poisonAllPokemon(event=nil)
    for pkmn in $Trainer.ablePokemonParty
       next if pkmn.hasType?(:POISON)  || pkmn.hasType?(:STEEL) ||
          pkmn.hasAbility?(:COMATOSE)  || pkmn.hasAbility?(:SHIELDSDOWN) || pkmn.hasAbility?(:IMMUNITY)
          pkmn.status!=0
       pkmn.status = 2
       pkmn.statusCount = 1
     end
end

def paralyzeAllPokemon(event=nil)
    for pkmn in $Trainer.ablePokemonParty
       next if pkmn.hasType?(:ELECTRIC) ||
          pkmn.hasAbility?(:COMATOSE)  || pkmn.hasAbility?(:SHIELDSDOWN) || pkmn.hasAbility?(:LIMBER)
          pkmn.status!=0
       pkmn.status = 4
     end
end

def burnAllPokemon(event=nil)
    for pkmn in $Trainer.ablePokemonParty
       next if pkmn.hasType?(:FIRE) ||
          pkmn.hasAbility?(:COMATOSE)  || pkmn.hasAbility?(:SHIELDSDOWN) || pkmn.hasAbility?(:WATERBUBBLE) || pkmn.hasAbility?(:WATERVEIL)
          pkmn.status!=0
       pkmn.status = 3
     end
end

class PokeBattle_Battle
  def removeAllHazards
    if @battlers[0].pbOwnSide.effects[PBEffects::StealthRock] || @battlers[0].pbOpposingSide.effects[PBEffects::StealthRock]
      @battlers[0].pbOwnSide.effects[PBEffects::StealthRock]      = false
      @battlers[0].pbOpposingSide.effects[PBEffects::StealthRock] = false
    end
    if @battlers[0].pbOwnSide.effects[PBEffects::Spikes]>0 || @battlers[0].pbOpposingSide.effects[PBEffects::Spikes]>0
      @battlers[0].pbOwnSide.effects[PBEffects::Spikes]      = 0
      @battlers[0].pbOpposingSide.effects[PBEffects::Spikes] = 0
    end
    if @battlers[0].pbOwnSide.effects[PBEffects::CometShards] || @battlers[0].pbOpposingSide.effects[PBEffects::CometShards]
      @battlers[0].pbOwnSide.effects[PBEffects::CometShards]      = false
      @battlers[0].pbOpposingSide.effects[PBEffects::CometShards] = false
    end
    if @battlers[0].pbOwnSide.effects[PBEffects::ToxicSpikes]>0 || @battlers[0].pbOpposingSide.effects[PBEffects::ToxicSpikes]>0
      @battlers[0].pbOwnSide.effects[PBEffects::ToxicSpikes]      = 0
      @battlers[0].pbOpposingSide.effects[PBEffects::ToxicSpikes] = 0
    end
    if @battlers[0].pbOwnSide.effects[PBEffects::StickyWeb] || @battlers[0].pbOpposingSide.effects[PBEffects::StickyWeb]
      @battlers[0].pbOwnSide.effects[PBEffects::StickyWeb]      = false
      @battlers[0].pbOpposingSide.effects[PBEffects::StickyWeb] = false
    end
  end
end
