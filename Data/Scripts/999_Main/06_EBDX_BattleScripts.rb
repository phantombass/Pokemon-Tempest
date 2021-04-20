module BattleScripts
  #Rampaging Pokémon
  METANG = {
    "turnStart0" => proc do
      $game_switches[81] = true
      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("The Metang is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Metang's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Metang's anger is shaking the cave!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EBEnvironment::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  CHERRIM = {
    "turnStart0" => proc do
      $game_switches[81] = true
      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("The Cherrim is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Cherrim's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Cherrim's anger is shaking the cliffs!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EBEnvironment::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  ARIADOS = {
    "turnStart0" => proc do
      $game_switches[81] = true
      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("The Ariados is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Ariados's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Ariados's anger is shaking the forest!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EBEnvironment::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  ELECTRODE = {
    "turnStart0" => proc do
      $game_switches[81] = true
      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("The Electrode is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Electrode's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Electrode's anger is shaking the lab!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EBEnvironment::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  HAUNTER = {
    "turnStart0" => proc do
      $game_switches[81] = true
      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("The Haunter is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Haunter's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Haunter's anger is shaking the caverns!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EBEnvironment::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }
#Important Trainer Battles

#Rival Battles
  RIVAL1 = {
    "turnStart0" => "You're going to regret challenging me!",
    "lastOpp" => "Ugh. You are so irritating!"
  }
end
