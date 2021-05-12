################################################################################
# Advanced Pokemon Level Balancing
# By Joltik
#Inspired by Umbreon's code
#Tweaked by Phantombass for use in Pokémon Promenade
################################################################################
################################################################################


module LvlCap
  Switch = 111               #Switch that turns on Trainer Difficulty Control
  LevelCap = 106             #Variable for the Level Cap
  Gym = 70                   #Switch for Gym Battles
  Rival = 69                 #Switch for Rival Battles
  Ace = 129                  #Switch for Ace Trainer Battles
end


Events.onTrainerPartyLoad+=proc {| sender, trainer |
   if trainer # Trainer data should exist to be loaded, but may not exist somehow
     party = trainer[0].party   # An array of the trainer's Pokémon
    if $game_switches && $game_switches[LvlCap::Switch] && $Trainer
       levelcap = $game_variables[LvlCap::LevelCap]
       badges = $Trainer.badge_count
       mlv = $Trainer.party.map { |e| e.level  }.max
      for i in 0...party.length
        level = 0
        level=1 if level<1
      if $game_switches[LvlCap::Gym] == true
        level = levelcap - 5
      elsif mlv<levelcap && mlv>party[i].level && $game_switches[LvlCap::Rival] == true
        level = mlv
      elsif mlv<levelcap && mlv<=party[i].level && $game_switches[LvlCap::Rival] == true
        level = party[i].level
      elsif mlv<levelcap && mlv <= party[i].level
        level = party[i].level
        level = levelcap if level > levelcap
      elsif mlv<levelcap && mlv > party[i].level
        level = (mlv - 2) + rand(5)
        level = levelcap if level > levelcap
      elsif mlv <= 1 && $game_switches[LvlCap::Rival] == true
        level = party[i].level
      else
        level = levelcap
      end
      party[i].level = level
      #now we evolve the pokémon, if applicable
      species = party[i].species
      party[i].name=GameData::Species.get(species).name
      party[i].species=species
      party[i].calc_stats
      if $game_switches[LvlCap::Gym] == false && $game_switches[LvlCap::Ace] == false
        party[i].reset_moves
      end
      end #end of for
     end
     end
}
