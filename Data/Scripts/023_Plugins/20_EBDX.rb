#===============================================================================
#  Elite Battle: DX
#    by Luka S.J.
# ----------------
#  Script Loader & Settings
# ----------------
#  system is based off the original Essentials battle system, made by
#  Poccil & Maruno
#
#  Enjoy the script, and make sure to give credit!
#===============================================================================
#  run script as plugin
#===============================================================================
ver = "1.0.14"
# set up plugin metadata
if !defined?(PluginManager)
  raise "This script is only compatible with Essentials v18.x!"
else
  PluginManager.register({
    :name => "Elite Battle: DX",
    :version => ver,
    :link => "https://luka-sj.com/res/ebdx",
    :dependencies => [
      ["Luka's Scripting Utilities", "3.1.3"]
    ],
    :credits => [
      "Luka S.J.", "Maruno", "Marin", "Pokecheck.org",
      "PinkCatDragon", "Tebited15", "BadSamaritan", "WolfPP",
      "redblueyellow", "Damien"
    ]
  })
end
ERROR_TEXT += "[EBDX v#{ver}] \r\n"
# raise message if not compiled
if !File.safe?("Data/Plugins/EBDX.rxdata") && !$DEBUG && !File.safe?("Game.rgssad")
  raise "You need to run your game at least once from Debug, to compile all the necessary files!"
end
# compile and eval script contents (don't touch please)
File.runPlugin("PBS/EBDX/Scripts", "EBDX")
#===============================================================================
#  System Settings
#===============================================================================
# Waiting period (in seconds) before battle "camera" starts moving
BATTLE_MOTION_TIMER = 90

# used to scale the trainer bitmaps (front sprites) to 200%
TRAINER_SPRITE_SCALE = 1

# used to scale the Pokemon bitmaps (front sprites and UI) to 200%
FRONT_SPRITE_SCALE = 2

# used to scale the Pokemon bitmaps (back sprites) to 200%
BACK_SPRITE_SCALE = 2

# write the name of your capturing Pokemon BGM (as string) to play it
CAPTURE_BGM = "EBDX/Victory Against Wild"

# set this to true to use the low HP bgm when player's Pokemon HP reaches 25%
USE_LOW_HP_BGM = false

# set this to true if you want to use your own common animations from the editor
COMMON_ANIMATIONS = false

# set this to true to use animations from the Animation editor for missing move animations
REPLACE_MISSING_ANIM = true

# disables "camera" zooming and movement throughout the entire scene
DISABLE_SCENE_MOTION = false

# Chance (%) (from 0 to 100, allows up to 2 decimal places) that Shiny Pokemon
# will have a unique hue applied to them, altering their color further
# this percentage is calculated AFTER the shiny generation chance
SUPER_SHINY_RATE = 1

# Show player line up during wild battles
SHOW_LINEUP_WILD = false

# Adjust the player sendout animations based on whether or not the
# Following Pokemon EX system is present
USE_FOLLOWER_EXCEPTION = true

# add EBDX debug menu
SHOW_DEBUG_FEATURES = false
#-------------------------------------------------------------------------------
# Adds additional "camera" vectors for when the camera is idling
# vector parameters are: x, y, angle, scale, scene zoom
EliteBattle.addVector(:CAMERA_MOTION,
  [132, 408, 24, 302, 1],
  [122, 294, 20, 322, 1],
  [238, 304, 26, 322, 1],
  [0, 384, 26, 322, 1],
  [198, 298, 18, 282, 1],
  [196, 306, 26, 242, 0.6],
  [156, 280, 18, 226, 0.6],
  [60, 280, 12, 388, 1],
  [160, 286, 16, 340, 1]
)
#-------------------------------------------------------------------------------
#  additional battle system configuration
#-------------------------------------------------------------------------------
# assigns rules for what types of data to be excluded from the randomizer
# key items are always excluded and cannot appear as a randomized item
EliteBattle.addData(:RANDOMIZER, :EXCLUSIONS_ITEMS, [
  :HM01, :HM02, :HM03, :HM04, :HM05, :HM06
])

# determine the rules for boss battler immunities
# immunities added to the array will be counted as active
EliteBattle.addData(:BOSSBATTLES, :IMMUNITIES, [
  :SLEEP, :POISON, :BURN, :PARALISYS,
  :FREEZE, :CONFUSION, :ATTRACT, :FLINCH,
  :DESTINYBOND, :LEECHSEED, :OHKO, :PERISHSONG
])

# method of bulk assigning Transitions for Pokemon and Trainers
EliteBattle.assignTransition("rainbowIntro", :ALLOW_ALL)
#-------------------------------------------------------------------------------
#  Quick scripted battle definition
#-------------------------------------------------------------------------------
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
  #    EliteBattle.set(:nextBattleSpeech, :PIDGEY)
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
      @battlers[1].pbRaiseStatStageBasic(getConst(PBStats, :ATTACK), 2)
      # show trainer speaking additional text
      @scene.pbTrainerSpeak("My #{pname} will not falter!")
      # show generic text
      @scene.pbDisplay("The battle is getting intense! You see the lights and stage around you shift.")
      # change Battle Environment (with white fade)
      pbBGMPlay("Battle Elite")
      @sprites["battlebg"].reconfigure(EBEnvironment::STAGE, Color.white)
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
  #
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
      @sprites["battlebg"].reconfigure(EBEnvironment::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its roar distorted the dimensions!")
      @scene.pbDisplay("Dialga is controlling the domain.")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }
  #-----------------------------------------------------------------------------
end