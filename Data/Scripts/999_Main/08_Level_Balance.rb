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


Events.onTrainerPartyLoad+=proc {|sender,e|
   if e[0] # Trainer data should exist to be loaded, but may not exist somehow
     trainer=e[0][0] # A PokeBattle_Trainer object of the loaded trainer
     items=e[0][1]   # An array of the trainer's items they can use
     party=e[0][2]   # An array of the trainer's Pokémon

    if $game_switches && $game_switches[LvlCap::Switch] && $Trainer &&
      $Trainer.party.length > 0
       levelcap = $game_variables[LvlCap::LevelCap]
       badges = $Trainer.numbadges
       mlv = $Trainer.party.map { |e| e.level  }.max
      for i in 0...party.length
        level = 0
        level=1 if level<1
      if mlv<levelcap && mlv < party[i].level && $game_switches[LvlCap::Gym] == true
        level = levelcap
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
      if badges > 4
      newspecies = pbGetBabySpecies(species) # revert to the first evolution
      evoflag=0 #used to track multiple evos not done by lvl
      endevo=false
      loop do #beginning of loop to evolve species
      nl = level + 5
      nl = levelcap if nl > levelcap
      pkmn = PokeBattle_Pokemon.new(newspecies, nl)
      cevo = Kernel.pbCheckEvolution(pkmn)
      evo = pbGetEvolvedFormData(newspecies)
      if evo
        evo = evo[rand(evo.length - 1)]
        # here we evolve things that don't evolve through level
        # that's what we check with evo[0]!=4
        #notice that such species have cevo==-1 and wouldn't pass the last check
        #to avoid it we set evoflag to 1 (with some randomness) so that
        #pokemon may have its second evolution (Raichu, for example)
        if evo && cevo < 1 && rand(50) <= level
          if evo[0] != 4 && rand(50) <= level
          newspecies = evo[2]
             if evoflag == 0 && rand(50) <= level
               evoflag=1
             else
               evoflag=0
             end
           end
        else
        endevo=true
        end
      end
      if evoflag==0 || endevo
      if  cevo == -1 || rand(50) > level
        # Breaks if there no more evolutions or randomnly
        # Randomness applies only if the level is under 50
        break
      else
        newspecies = evo[2]
      end
      end
    end #end of loop do
    #fixing some things such as Bellossom would turn into Vileplume
    #check if original species could evolve (Bellosom couldn't)
    couldevo=pbGetEvolvedFormData(species)
    #check if current species can evolve
    evo = pbGetEvolvedFormData(newspecies)
      if evo.length<1 && couldevo.length<1
      else
         species=newspecies
      end #end of evolving script
    end
      party[i].name=PBSpecies.getName(species)
      party[i].species=species
      party[i].calcStats
      if $game_switches[LvlCap::Gym] == false && $game_switches[LvlCap::Ace] == false
      party[i].resetMoves
      end
      end #end of for
     end
     end
     }
