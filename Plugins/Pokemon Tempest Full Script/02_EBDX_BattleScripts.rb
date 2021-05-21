module BattleScripts
  #Rampaging Pokémon
  METANG = {
    "turnStart0" => proc do

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
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  CHERRIM = {
    "turnStart0" => proc do

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
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  ARIADOS = {
    "turnStart0" => proc do

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
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  ELECTRODE = {
    "turnStart0" => proc do

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
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  MACHOKE = {
    "turnStart0" => proc do

      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("The Machoke is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Machoke's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Machoke's anger is shaking the caverns!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  XATU = {
    "turnStart0" => proc do

      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("The Xatu is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Xatu's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Xatu's anger is shaking the lab!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  ABSOL = {
    "turnStart0" => proc do

      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("Absol is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Absol's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Absol's anger is shaking the area!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  SIDEQUEST = {
    "turnStart0" => proc do

      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("The Pokémon is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("The Pokémon's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("The Pokémon's anger is shaking the area!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  GROUDON = {
    "turnStart0" => proc do

      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("Groudon is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Groudon's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Groudon's anger is shaking the mountain!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  KYOGRE = {
    "turnStart0" => proc do

      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("Kyogre is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Kyogre's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Kyogre's anger is shaking the cave!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  DIALGA1 = {
    "turnStart0" => proc do
      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("Dialga is carefully eyeing you...")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Dialga's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Dialga is raring to go!")
      @scene.pbShowAllDataboxes
    end
  }

  PALKIA = {
    "turnStart0" => proc do
      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("Palkia is carefully eyeing you...")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Palkia's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Palkia is raring to go!")
      @scene.pbShowAllDataboxes
    end
  }

  CLEFABLE = {
    "turnStart0" => proc do

      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("The Clefable is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Clefable's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Clefable's anger is shaking the caverns!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  ELECTIVIRE = {
    "turnStart0" => proc do

      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("The Electivire is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Electivire's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Electivire's anger is shaking the lab!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  DUSKNOIR = {
    "turnStart0" => proc do

      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("The Dusknoir is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Dusknoir's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Dusknoir's anger is shaking the forest!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  WEAVILE = {
    "turnStart0" => proc do

      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("The Weavile is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Weavile's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Weavile's anger is shaking the lab!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }
#Important Trainer Battles
      AARON = {
        "turnStart0" => "I'll humor you this time, child.",
        "lastOpp" => "Hmm. You have become a rather puzzling problem."
      }
      AARONLOSS = {
        "turnStart0" => "Clearly you do not understand when to give up.",
        "lastOpp" => "Hmm. You appear to have gotten a little stronger."
      }
      AARON2 = {
        "turnStart0" => "You have interfered for the last time.",
        "lastOpp" => "Hmm. You appear to have gotten a little stronger."
      }
      #Rival Battles
        RIVAL = {
          "turnStart0" => "You're going to regret challenging me!",
          "lastOpp" => "Ugh. You are so irritating!"
        }

        RIVAL1 = {
          "turnStart0" => "You're going to pay for beating me last time!",
          "lastOpp" => "Ugh. This can NOT be happening again!"
        }

        RIVAL2 = {
          "turnStart0" => "You are going down again! Just like last time!",
          "lastOpp" => "Ugh. This can NOT be happening!"
        }

        CYNTHIA = {
          "turnStart0" => "Come at me with everything! I want to know just how strong your team is!",
          "lastOpp" => "It's been a long time since I was backed into a corner like this."
        }
end
