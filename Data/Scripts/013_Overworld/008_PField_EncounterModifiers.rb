################################################################################
# This section was created solely for you to put various bits of code that
# modify various wild Pokémon and trainers immediately prior to battling them.
# Be sure that any code you use here ONLY applies to the Pokémon/trainers you
# want it to apply to!
################################################################################

# Make all wild Pokémon shiny while a certain Switch is ON (see Settings).
Events.onWildPokemonCreate += proc { |_sender, e|
  pokemon = e[0]
  if $game_switches[SHINY_WILD_POKEMON_SWITCH]
    pokemon.makeShiny
  end
}

# Used in the random dungeon map.  Makes the levels of all wild Pokémon in that
# map depend on the levels of Pokémon in the player's party.
# This is a simple method, and can/should be modified to account for evolutions
# and other such details.  Of course, you don't HAVE to use this code.
Events.onWildPokemonCreate += proc { |_sender, e|
  pokemon = e[0]
  if $game_switches[110] == true && $game_switches[112] == false
     setlevel = pbBalancedLevel($Trainer.party) - 2 + rand(5)
     newlevel = 1 if setlevel < 1
     newlevel  =PBExperience.maxLevel if setlevel>PBExperience.maxLevel
     pokemon.level = newlevel
     #now we evolve the pokémon, if applicable
     species = pokemon.species
     newspecies = pbGetBabySpecies(species) # revert to the first evolution
     evoflag=0 #used to track multiple evos not done by lvl
     endevo=false
     loop do #beginning of loop to evolve species
      nl = newlevel
      nl = MAXIMUM_LEVEL if nl > MAXIMUM_LEVEL
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
        if evo && cevo < 1 && rand(50) <= newlevel
          if evo[0] < 1 && rand(50) <= newlevel || evo[0] > 1 && rand(50) <= newlevel
          newspecies = evo[2]
             if evoflag == 0 && rand(50) <= newlevel
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
      if  cevo == -1 || rand(50) > newlevel
        # Breaks if there no more evolutions or randomnly
        # Randomness applies only if the level is under 50
        break
      else
        newspecies = evo[2]
      end
      end
    end
    #fixing some things such as Bellossom would turn into Vileplume
    #check if original species could evolve (Bellosom couldn't)
    couldevo = pbGetEvolvedFormData(species)
    #check if current species can evolve
    evo = pbGetEvolvedFormData(newspecies)
      if evo.length==0 && couldevo.length==0
      else
         species=newspecies
      end
     pokemon.name=PBSpecies.getName(species)
     pokemon.species=species
     pokemon.calcStats
     pokemon.resetMoves
   elsif $game_switches[112] == true && $game_switches[110] == true
     newlevel = pbBalancedLevel($Trainer.party) - 2 + rand(5)
     newlevel = 1 if newlevel < 1
     max_level = $game_variables[106]
     newlevel = max_level if newlevel > max_level
     pokemon.level = newlevel
     #now we evolve the pokémon, if applicable
     species = pokemon.species
     newspecies = pbGetBabySpecies(species) # revert to the first evolution
     evoflag=0 #used to track multiple evos not done by lvl
     endevo=false
     loop do #beginning of loop to evolve species
      nl = pokemon.level
      ml = $game_variables[106]
      nl = ml if nl > ml
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
        if evo && cevo < 1 && rand(50) <= nl
          if evo[0] < 1 && rand(50) <= nl || evo[0] > 1 && rand(50) <= nl
          newspecies = evo[2]
             if evoflag == 0 && rand(50) <= nl
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
      if  cevo == -1 || rand(50) > nl
        # Breaks if there no more evolutions or randomnly
        # Randomness applies only if the level is under 50
        break
      else
        newspecies = evo[2]
      end
      end
    end
    #fixing some things such as Bellossom would turn into Vileplume
    #check if original species could evolve (Bellosom couldn't)
    couldevo=pbGetEvolvedFormData(species)
    #check if current species can evolve
    evo = pbGetEvolvedFormData(newspecies)
      if evo.length==0 && couldevo.length==0
        species = species
      else
        species = newspecies
      end
     pokemon.name=PBSpecies.getName(species)
     pokemon.species = species
     pokemon.calcStats
     pokemon.resetMoves
   end
}

# This is the basis of a trainer modifier.  It works both for trainers loaded
# when you battle them, and for partner trainers when they are registered.
# Note that you can only modify a partner trainer's Pokémon, and not the trainer
# themselves nor their items this way, as those are generated from scratch
# before each battle.
#Events.onTrainerPartyLoad += proc { |_sender, e|
#  if e[0] # Trainer data should exist to be loaded, but may not exist somehow
#    trainer = e[0][0] # A PokeBattle_Trainer object of the loaded trainer
#    items = e[0][1]   # An array of the trainer's items they can use
#    party = e[0][2]   # An array of the trainer's Pokémon
#    YOUR CODE HERE
#  end
#}
