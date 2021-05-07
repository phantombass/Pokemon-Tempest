#===============================================================================
#  Elite Battle: DX
#    by Luka S.J.
# ----------------
#  Battle Scripts
#===============================================================================
module BattleScripts
  # example scripted battle for PIDGEY
  # you can define other scripted battles in here or make your own section
  # with the BattleScripts module for better organization as to not clutter the
  # main EBDX cofiguration script (or keep it here if you want to, your call)
  PIDGEY = {
    "turnStart0" => {
      :text => [
        "Wow! This here Pidgey is among the top percentage of Pidgey.",
        "I have never seen such a strong Pidgey!",
        "Btw, this feature works even during wild battles.",
        "Pretty exciting, right?"
      ],
      :file => "trainer024"
    }
  }
  # to call this battle script run the script from an event jusst before the
  # desired battle:
  #    EliteBattle.set(:nextBattleScript, :PIDGEY)
  #-----------------------------------------------------------------------------
  # example scripted battle for BROCK
  # this one is added to the EBDX trainers PBS as a BattleScript parameter
  # for the specific battle of LEADER_Brock "Brock" trainer
  BROCK = {
    "turnStart0" => proc do
      pname = @battlers[1].name
      tname = @battle.opponent[0].name
      # begin code block for the first turn
      @scene.pbTrainerSpeak(["Time to set this battle into motion!",
                             "Let's see if you'll be able to handle my #{pname} after I give him this this!"
                           ])
      # play common animation for Item use args(anim_name, scene, index)
      @scene.pbDisplay("#{tname} tossed an item to the #{pname} ...")
      EliteBattle.playCommonAnimation(:USEITEM, @scene, 1)
      # play aura flare
      @scene.pbDisplay("Immense energy is swelling up in the #{pname}")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @battlers[1].pbRaiseStatStageBasic(:ATTACK, 2)
      # show trainer speaking additional text
      @scene.pbTrainerSpeak("My #{pname} will not falter!")
      # show generic text
      @scene.pbDisplay("The battle is getting intense! You see the lights and stage around you shift.")
      # change Battle Environment (with white fade)
      pbBGMPlay("Battle Elite")
      @sprites["battlebg"].reconfigure(:STAGE, Color.white)
    end,
    "damageOpp" => "Woah! A powerful move!",
    "damageOpp2" => "Another powerful move ...",
    "lastOpp" => "This is it! Let's make it count!",
    "lowHPOpp" => "Hang in there!",
    "attack" => "Whatever you throw at me, my team can take it!",
    "attackOpp" => "How about you try this one on for size!",
    "fainted" => "That's how we do it in this gym!",
    "faintedOpp" => "Arghh. You did well my friend...",
    "loss" => "You can come back and challenge me any time you want."
  }
  #-----------------------------------------------------------------------------
  # example Dialga fight
  DIALGA = {
    "turnStart0" => proc do
      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("The ruler of time itself; Dialga starts to radiate tremendous amounts of energy!")
      @scene.pbDisplay("Something is about to happen ...")
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Dialga's roar is pressurizing the air around you! You feel its intensity!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(:DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its roar distorted the dimensions!")
      @scene.pbDisplay("Dialga is controlling the domain.")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }
  #-----------------------------------------------------------------------------
  BORIS = {
    "lastOpp" => proc do
      @scene.pbTrainerSpeak("Don't think this is over just yet, \\PN!")
      @sprites["battlebg"].reconfigure(:SKY, :DISTORTION)
      @scene.wait(16, false)
      @battle.field.weather = :Windy
      @battle.field.weatherDuration = 8
      @scene.pbDisplay("The wind picked back up!")
      @battle.removeAllHazards
    end,
    "turnStart0" => "Let's see just how prepared you are!"
  }

  SETH = {
    "lastOpp" => proc do
      @scene.pbTrainerSpeak("Hoho! Just see what trickery we have for you!")
      @sprites["battlebg"].reconfigure(:DARKNESS, :DISTORTION)
      @battle.field.weather = :Eclipse
      @battle.field.weatherDuration = 8
      @scene.pbDisplay("The darkness returned!")
      @scene.wait(16, false)
      EliteBattle.playCommonAnimation(:POISON,@scene,0)
      @battle.battlers[0].status = :POISON
      @battle.battlers[0].effects[PBEffects::Toxic]
      poisonAllPokemon(nil)
      @scene.pbDisplay("Seth's underhanded tactics badly poisoned \\PN's party!")

  end,
  "turnStart0" => "Let's get this madness started!"
}

  OZZY = {
    "lastOpp" => proc do
      @scene.pbTrainerSpeak("This battle may be saved yet! Observe, \\PN!")
      @sprites["battlebg"].reconfigure(:CAVE, :DISTORTION)
      @battle.pbAnimation(getID(GameData::Move,:SANDSTORM),battle.battlers[1],battle.battlers[0])
      @battle.field.weather = :Sandstorm
      @battle.field.weatherDuration = 8
      @scene.pbDisplay("The sandstorm resurged!")
      @scene.wait(8,false)
      if @battle.battlers[0].pbOwnSide.effects[PBEffects::StealthRock] == false
        @battle.pbAnimation(getID(GameData::Move,:STEALTHROCK),battle.battlers[1],battle.battlers[0])
        @battle.battlers[0].pbOwnSide.effects[PBEffects::StealthRock] = true
        @scene.pbDisplay("Ozzy set Stealth Rocks on \\PN's side!")
      end
    end,
    "turnStart0" => "Let's see just what you're made of!"
    }

  RIVAL1 = { "turnStart0" => "I'm so stoked to see your Pokémon!",
             "lowHPOpp" => "Whoa, that little guy is strong!"
  }
end
