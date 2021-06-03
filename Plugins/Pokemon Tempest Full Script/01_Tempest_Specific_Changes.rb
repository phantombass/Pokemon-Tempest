#===================================
# Level Cap
#===================================
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
    if $game_variables[Mission::Mission3]<=0
      $game_variables[Level::Cap] = 20
    elsif $game_variables[Mission::Mission3]>0 && $game_variables[Mission::Mission3]<=2
      $game_variables[Level::Cap] = 26
    elsif $game_variables[Mission::Mission3]>=3 && $game_variables[Mission::Mission3]<=5
      $game_variables[Level::Cap] = 30
    elsif $game_variables[Mission::Mission3]>=6
      $game_variables[Level::Cap] = 35
    end
  when 4
    if $game_variables[Mission::Mission4] <= 0
      $game_variables[Level::Cap] = 35
    elsif $game_variables[Mission::Mission4]>0 && $game_variables[Mission::Mission4]<=2
      $game_variables[Level::Cap] = 42
    elsif $game_variables[Mission::Mission4]>=3 && $game_variables[Mission::Mission4]<=5
      $game_variables[Level::Cap] = 46
    elsif $game_variables[Mission::Mission4]>=6 && $game_variables[Mission::Mission4]<=7
      $game_variables[Level::Cap] = 50
    elsif $game_variables[Mission::Mission4]>=8
      $game_variables[Level::Cap] = 55
    end
  when 5
    if $game_variables[Mission::Mission5] <= 0
      $game_variables[Level::Cap] = 55
    elsif $game_variables[Mission::Mission5] >= 1 && $game_variables[Mission::Mission5] <=3
      $game_variables[Level::Cap] = 60
    elsif $game_variables[Mission::Mission5] >= 4 && $game_variables[Mission::Mission5] <=7
      $game_variables[Level::Cap] = 66
    elsif $game_variables[Mission::Mission5] >= 8 && $game_variables[Mission::Mission5]< 9
      $game_variables[Level::Cap] = 70
    elsif $game_variables[Mission::Mission5] >= 9
      $game_variables[Level::Cap] = 75
    end
  when 6
    if $game_variables[Mission::Mission6] <= 0
      $game_variables[Level::Cap] = 75
    elsif $game_variables[Mission::Mission6] >= 1 && $game_variables[Mission::Mission6] <=3
      $game_variables[Level::Cap] = 82
    elsif $game_variables[Mission::Mission6] >= 4 && $game_variables[Mission::Mission6] <=7
      $game_variables[Level::Cap] = 89
    elsif $game_variables[Mission::Mission6] >= 8
      $game_variables[Level::Cap] = 100
    end
  end
  #Weather Setting
  time = pbGetTimeNow
  $game_variables[99] = time.day
  dailyWeather = $game_variables[27]
  if $game_variables[28] > $game_variables[99] || $game_variables[28]<$game_variables[99]
    $game_variables[27] = 1+rand(100)
    $game_variables[28] = $game_variables[99]
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
    if $game_variables[Mission::Mission3]<=0
      $game_variables[Level::Cap] = 20
    elsif $game_variables[Mission::Mission3]>0 && $game_variables[Mission::Mission3]<=2
      $game_variables[Level::Cap] = 26
    elsif $game_variables[Mission::Mission3]>=3 && $game_variables[Mission::Mission3]<=5
      $game_variables[Level::Cap] = 30
    elsif $game_variables[Mission::Mission3]>=6
      $game_variables[Level::Cap] = 35
    end
  when 4
    if $game_variables[Mission::Mission4] <= 0
      $game_variables[Level::Cap] = 35
    elsif $game_variables[Mission::Mission4]>=0 && $game_variables[Mission::Mission4]<=2
      $game_variables[Level::Cap] = 42
    elsif $game_variables[Mission::Mission4]>=3 && $game_variables[Mission::Mission4]<=5
      $game_variables[Level::Cap] = 46
    elsif $game_variables[Mission::Mission4]>=6 && $game_variables[Mission::Mission4]<=7
      $game_variables[Level::Cap] = 50
    elsif $game_variables[Mission::Mission4]>=8
      $game_variables[Level::Cap] = 55
    end
  when 5
    if $game_variables[Mission::Mission5] <= 0
      $game_variables[Level::Cap] = 55
    elsif $game_variables[Mission::Mission5] >= 1 && $game_variables[Mission::Mission5] <=3
      $game_variables[Level::Cap] = 60
    elsif $game_variables[Mission::Mission5] >= 4 && $game_variables[Mission::Mission5] <=7
      $game_variables[Level::Cap] = 66
    elsif $game_variables[Mission::Mission5] >= 8 && $game_variables[Mission::Mission5]< 9
      $game_variables[Level::Cap] = 70
    elsif $game_variables[Mission::Mission5] >= 9
      $game_variables[Level::Cap] = 75
    end
  when 6
    if $game_variables[Mission::Mission6] <= 0
      $game_variables[Level::Cap] = 75
    elsif $game_variables[Mission::Mission6] >= 1 && $game_variables[Mission::Mission6] <=3
      $game_variables[Level::Cap] = 82
    elsif $game_variables[Mission::Mission6] >= 4 && $game_variables[Mission::Mission6] <=7
      $game_variables[Level::Cap] = 89
    elsif $game_variables[Mission::Mission6] >= 8
      $game_variables[Level::Cap] = 100
    end
  end
}

#===================================
# Chapter Release
#===================================
module ChapterRelease
  Four = 525
  Five = 540
  Six = 556
  Constant = 1000
end

Events.onMapChange += proc {| sender, e |
    $game_switches[ChapterRelease::Four] = true
    $game_switches[ChapterRelease::Five] = true
    $game_switches[ChapterRelease::Six] = true
}

def pbChapterRelease
  meName = "Voltorb flip win"
  if $game_switches[ChapterRelease::Four] && $game_switches[405] && $game_variables[ChapterRelease::Constant] == 0
    textColor = "7FE00000"
    if $game_switches[Mission::Vinny]
      leader = "Vinny"
    elsif $game_switches[Mission::Stella]
      leader = "Stella"
    end
    pbWait(64)
    pbCommonEvent(6)
    pbMessage(_INTL("\\me[{3}]<c2={1}>\\PN! It's {2}! Meet me at HQ for our next mission!</c2>",textColor,leader,meName))
    pbCommonEvent(7)
    $game_variables[ChapterRelease::Constant]=1
  elsif $game_switches[ChapterRelease::Five] && $game_switches[539] && $game_variables[ChapterRelease::Constant] == 1
    textColor = "7FE00000"
    if $game_switches[Mission::Vinny]
      leader = "Vinny"
    elsif $game_switches[Mission::Stella]
      leader = "Stella"
    end
    pbWait(64)
    pbCommonEvent(6)
    pbMessage(_INTL("\\me[{3}]<c2={1}>\\PN! It's {2}! Meet me at HQ for our next mission!</c2>",textColor,leader,meName))
    pbCommonEvent(7)
    $game_variables[ChapterRelease::Constant]=2
  elsif $game_switches[ChapterRelease::Six] && $game_switches[577] && $game_variables[ChapterRelease::Constant] == 2
    textColor = "7FE00000"
    if $game_switches[Mission::Vinny]
      leader = "Vinny"
    elsif $game_switches[Mission::Stella]
      leader = "Stella"
    end
    pbWait(64)
    pbCommonEvent(6)
    pbMessage(_INTL("\\me[{3}]<c2={1}>\\PN! It's {2}! Meet me and Cynthia at her villa in Coastal Steppes for your next mission!</c2>",textColor,leader,meName))
    pbCommonEvent(7)
    $game_variables[ChapterRelease::Constant]=3
    #elsif
  end
end
#===================================
# Honey Tree
#===================================
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

#=======================
#Various Modifications to fit Tempest specifically
#=======================

class Pokemon
  def getMegaForm(checkItemOnly = false)
    ret = 0
    GameData::Species.each do |data|
      if data.species != :ALTEMPER && data.species != :SALAMENCE && data.species != :PINSIR && data.species != :GENGAR && data.species != :GARCHOMP
        next if data.species != @species || data.unmega_form != form_simple
      end
      if data.mega_stone && hasItem?(data.mega_stone)
        ret = data.form
        break
      elsif !checkItemOnly && data.mega_move && hasMove?(data.mega_move) && form <= 41
        ret = data.form
        break
      end
    end
    return ret   # form number, or 0 if no accessible Mega form
  end
  def can_relearn_move?
    return false if egg? || shadowPokemon?
    this_level = self.level
    getMoveList.each { |m| return true if m[0] <= this_level && !hasMove?(m[1]) }
    @first_moves.each { |m| return true if !hasMove?(m) }
    return false
  end
end

class PokemonTemp
  def pbPrepareBattle(battle)
    battleRules = $PokemonTemp.battleRules
    # The size of the battle, i.e. how many Pokémon on each side (default: "single")
    battle.setBattleMode(battleRules["size"]) if !battleRules["size"].nil?
    # Whether the game won't black out even if the player loses (default: false)
    battle.canLose = battleRules["canLose"] if !battleRules["canLose"].nil?
    # Whether the player can choose to run from the battle (default: true)
    battle.canRun = battleRules["canRun"] if !battleRules["canRun"].nil?
    # Whether wild Pokémon always try to run from battle (default: nil)
    battle.rules["alwaysflee"] = battleRules["roamerFlees"]
    # Whether Pokémon gain Exp/EVs from defeating/catching a Pokémon (default: true)
    battle.expGain = battleRules["expGain"] if !battleRules["expGain"].nil?
    # Whether the player gains/loses money at the end of the battle (default: true)
    battle.moneyGain = battleRules["moneyGain"] if !battleRules["moneyGain"].nil?
    # Whether the player is able to switch when an opponent's Pokémon faints
    battle.switchStyle = ($PokemonSystem.battlestyle==0)
    battle.switchStyle = battleRules["switchStyle"] if !battleRules["switchStyle"].nil?
    # Whether battle animations are shown
    battle.showAnims = ($PokemonSystem.battlescene==0)
    battle.showAnims = battleRules["battleAnims"] if !battleRules["battleAnims"].nil?
    # Terrain
    battle.defaultTerrain = battleRules["defaultTerrain"] if !battleRules["defaultTerrain"].nil?
    # Weather
    if battleRules["defaultWeather"].nil?
      battle.defaultWeather = $game_screen.weather_type
    else
      battle.defaultWeather = battleRules["defaultWeather"]
    end
    # Environment
    if battleRules["environment"].nil?
      battle.environment = pbGetEnvironment
    else
      battle.environment = battleRules["environment"]
    end
    # Backdrop graphic filename
    if !battleRules["backdrop"].nil?
      backdrop = battleRules["backdrop"]
    elsif $PokemonGlobal.nextBattleBack
      backdrop = $PokemonGlobal.nextBattleBack
    elsif $PokemonGlobal.surfing
      backdrop = "water"   # This applies wherever you are, including in caves
    elsif GameData::MapMetadata.exists?($game_map.map_id)
      back = GameData::MapMetadata.get($game_map.map_id).battle_background
      backdrop = back if back && back != ""
    end
    backdrop = "indoor1" if !backdrop
    battle.backdrop = backdrop
    # Choose a name for bases depending on environment
    if battleRules["base"].nil?
      environment_data = GameData::Environment.try_get(battle.environment)
      base = environment_data.battle_base if environment_data
    else
      base = battleRules["base"]
    end
    battle.backdropBase = base if base
    # Time of day
    if GameData::MapMetadata.exists?($game_map.map_id) &&
       GameData::MapMetadata.get($game_map.map_id).battle_environment == :Cave
      battle.time = 2   # This makes Dusk Balls work properly in caves
    elsif Settings::TIME_SHADING
      timeNow = pbGetTimeNow
      if PBDayNight.isNight?(timeNow);      battle.time = 2
      elsif PBDayNight.isEvening?(timeNow); battle.time = 1
      else;                                 battle.time = 0
      end
    end
  end
end

class PokeBattle_Battle
  def pbMegaEvolve(idxBattler)
    battler = @battlers[idxBattler]
    return if !battler || !battler.pokemon
    return if !battler.hasMega? || battler.mega?
    trainerName = pbGetOwnerName(idxBattler)
    # Break Illusion
    if battler.hasActiveAbility?(:ILLUSION)
      BattleHandlers.triggerTargetAbilityOnHit(battler.ability,nil,battler,nil,self)
    end
    # Mega Evolve
    case battler.pokemon.megaMessage
    when 1   # Rayquaza
      pbDisplay(_INTL("{1}'s fervent wish has reached {2}!",trainerName,battler.pbThis))
    else
      pbDisplay(_INTL("{1}'s {2} is reacting to {3}'s {4}!",
         battler.pbThis,battler.itemName,trainerName,pbGetMegaRingName(idxBattler)))
    end
    pbCommonAnimation("MegaEvolution",battler)
    battler.pokemon.makeMega
    battler.form = battler.pokemon.form
    battler.pbUpdate(true)
    @scene.pbChangePokemon(battler,battler.pokemon)
    @scene.pbRefreshOne(idxBattler)
    pbCommonAnimation("MegaEvolution2",battler)
    megaName = battler.pokemon.megaName
    if !megaName || megaName==""
      megaName = _INTL("Mega {1}", battler.pokemon.speciesName)
    end
    pbDisplay(_INTL("{1} has Mega Evolved into {2}!",battler.pbThis,megaName))
    side  = battler.idxOwnSide
    owner = pbGetOwnerIndexFromBattlerIndex(idxBattler)
    @megaEvolution[side][owner] = -2
    if battler.isSpecies?(:GENGAR) && battler.mega?
      battler.effects[PBEffects::Telekinesis] = 0
    end
    pbCalculatePriority(false,[idxBattler]) if Settings::RECALCULATE_TURN_ORDER_AFTER_MEGA_EVOLUTION
    # Trigger ability
    battler.pbEffectsOnSwitchIn
    battler.pbCheckFormOnWeatherChange
  end
  def pbOnActiveOne(battler)
    return false if battler.fainted?
    # Introduce Shadow Pokémon
    if battler.opposes? && battler.shadowPokemon?
      pbCommonAnimation("Shadow",battler)
      pbDisplay(_INTL("Oh!\nA Shadow Pokémon!"))
    end
    # Record money-doubling effect of Amulet Coin/Luck Incense
    if !battler.opposes? && [:AMULETCOIN, :LUCKINCENSE].include?(battler.item_id)
      @field.effects[PBEffects::AmuletCoin] = true
    end
    # Update battlers' participants (who will gain Exp/EVs when a battler faints)
    eachBattler { |b| b.pbUpdateParticipants }
    # Healing Wish
    if @positions[battler.index].effects[PBEffects::HealingWish]
      pbCommonAnimation("HealingWish",battler)
      pbDisplay(_INTL("The healing wish came true for {1}!",battler.pbThis(true)))
      battler.pbRecoverHP(battler.totalhp)
      battler.pbCureStatus(false)
      @positions[battler.index].effects[PBEffects::HealingWish] = false
    end
    # Lunar Dance
    if @positions[battler.index].effects[PBEffects::LunarDance]
      pbCommonAnimation("LunarDance",battler)
      pbDisplay(_INTL("{1} became cloaked in mystical moonlight!",battler.pbThis))
      battler.pbRecoverHP(battler.totalhp)
      battler.pbCureStatus(false)
      battler.eachMove { |m| m.pp = m.total_pp }
      @positions[battler.index].effects[PBEffects::LunarDance] = false
    end
    # Entry hazards
    # Stealth Rock
    if battler.pbOwnSide.effects[PBEffects::CometShards] && battler.takesIndirectDamage? &&
       GameData::Type.exists?(:COSMIC)
      bTypes = battler.pbTypes(true)
      if battler.pbHasType?(:COSMIC)
        battler.pbOwnSide.effects[PBEffects::CometShards] = false
        pbDisplay(_INTL("{1} dissipated the Comet Shards!",battler.pbThis))
      else
        eff = Effectiveness.calculate(:COSMIC, bTypes[0], bTypes[1], bTypes[2])
        if !Effectiveness.ineffective?(eff)
          eff = eff.to_f / Effectiveness::NORMAL_EFFECTIVE
          oldHP = battler.hp
          battler.pbReduceHP(battler.totalhp*eff/8,false)
          pbDisplay(_INTL("Pointed stones dug into {1}!",battler.pbThis))
          battler.pbItemHPHealCheck
          if battler.pbAbilitiesOnDamageTaken(oldHP)   # Switched out
            return pbOnActiveOne(battler)   # For replacement battler
          end
        end
      end
    end
    #Comet Shards
    if battler.pbOwnSide.effects[PBEffects::StealthRock] && battler.takesIndirectDamage? &&
       GameData::Type.exists?(:ROCK)
      bTypes = battler.pbTypes(true)
      eff = Effectiveness.calculate(:ROCK, bTypes[0], bTypes[1], bTypes[2])
      if !Effectiveness.ineffective?(eff)
        eff = eff.to_f / Effectiveness::NORMAL_EFFECTIVE
        oldHP = battler.hp
        battler.pbReduceHP(battler.totalhp*eff/8,false)
        pbDisplay(_INTL("Pointed stones dug into {1}!",battler.pbThis))
        battler.pbItemHPHealCheck
        if battler.pbAbilitiesOnDamageTaken(oldHP)   # Switched out
          return pbOnActiveOne(battler)   # For replacement battler
        end
      end
    end
    # Spikes
    if battler.pbOwnSide.effects[PBEffects::Spikes]>0 && battler.takesIndirectDamage? &&
       !battler.airborne?
      spikesDiv = [8,6,4][battler.pbOwnSide.effects[PBEffects::Spikes]-1]
      oldHP = battler.hp
      battler.pbReduceHP(battler.totalhp/spikesDiv,false)
      pbDisplay(_INTL("{1} is hurt by the spikes!",battler.pbThis))
      battler.pbItemHPHealCheck
      if battler.pbAbilitiesOnDamageTaken(oldHP)   # Switched out
        return pbOnActiveOne(battler)   # For replacement battler
      end
    end
    # Toxic Spikes
    if battler.pbOwnSide.effects[PBEffects::ToxicSpikes]>0 && !battler.fainted? &&
       !battler.airborne?
      if battler.pbHasType?(:POISON)
        battler.pbOwnSide.effects[PBEffects::ToxicSpikes] = 0
        pbDisplay(_INTL("{1} absorbed the poison spikes!",battler.pbThis))
      elsif battler.pbCanPoison?(nil,false)
        if battler.pbOwnSide.effects[PBEffects::ToxicSpikes]==2
          battler.pbPoison(nil,_INTL("{1} was badly poisoned by the poison spikes!",battler.pbThis),true)
        else
          battler.pbPoison(nil,_INTL("{1} was poisoned by the poison spikes!",battler.pbThis))
        end
      end
    end
    # Sticky Web
    if battler.pbOwnSide.effects[PBEffects::StickyWeb] && !battler.fainted? &&
       !battler.airborne?
      pbDisplay(_INTL("{1} was caught in a sticky web!",battler.pbThis))
      if battler.pbCanLowerStatStage?(:SPEED)
        battler.pbLowerStatStage(:SPEED,1,nil)
        battler.pbItemStatRestoreCheck
      end
    end
    # Battler faints if it is knocked out because of an entry hazard above
    if battler.fainted?
      battler.pbFaint
      pbGainExp
      pbJudge
      return false
    end
    battler.pbCheckForm
    return true
  end

  def pbStartTerrain(user,newTerrain,fixedDuration=true)
    return if @field.terrain==newTerrain
    @field.terrain = newTerrain
    duration = (fixedDuration) ? 5 : -1
    if duration>0 && user && user.itemActive?
      duration = BattleHandlers.triggerTerrainExtenderItem(user.item,
         newTerrain,duration,user,self)
    end
    @field.terrainDuration = duration
    terrain_data = GameData::BattleTerrain.try_get(@field.terrain)
    pbCommonAnimation(terrain_data.animation) if terrain_data
    pbHideAbilitySplash(user) if user
    case @field.terrain
    when :Electric
      pbDisplay(_INTL("An electric current runs across the battlefield!"))
    when :Grassy
      pbDisplay(_INTL("Grass grew to cover the battlefield!"))
    when :Misty
      pbDisplay(_INTL("Mist swirled about the battlefield!"))
    when :Psychic
      pbDisplay(_INTL("The battlefield got weird!"))
    when :Poison
      pbDisplay(_INTL("Toxic waste covers the battlefield!"))
    end
    # Check for terrain seeds that boost stats in a terrain
    eachBattler { |b| b.pbItemTerrainStatBoostCheck }
  end
  def pbEndOfBattle
    oldDecision = @decision
    @decision = 4 if @decision==1 && wildBattle? && @caughtPokemon.length>0
    case oldDecision
    ##### WIN #####
    when 1
      PBDebug.log("")
      PBDebug.log("***Player won***")
      if trainerBattle?
        @scene.pbTrainerBattleSuccess
        case @opponent.length
        when 1
          pbDisplayPaused(_INTL("You defeated {1}!",@opponent[0].full_name))
        when 2
          pbDisplayPaused(_INTL("You defeated {1} and {2}!",@opponent[0].full_name,
             @opponent[1].full_name))
        when 3
          pbDisplayPaused(_INTL("You defeated {1}, {2} and {3}!",@opponent[0].full_name,
             @opponent[1].full_name,@opponent[2].full_name))
        end
        @opponent.each_with_index do |_t,i|
          @scene.pbShowOpponent(i)
          msg = (@endSpeeches[i] && @endSpeeches[i]!="") ? @endSpeeches[i] : "..."
          pbDisplayPaused(msg.gsub(/\\[Pp][Nn]/,pbPlayer.name))
        end
      end
      # Gain money from winning a trainer battle, and from Pay Day
      pbGainMoney if @decision!=4
      # Hide remaining trainer
      @scene.pbShowOpponent(@opponent.length) if trainerBattle? && @caughtPokemon.length>0
    ##### LOSE, DRAW #####
    when 2, 5
      PBDebug.log("")
      PBDebug.log("***Player lost***") if @decision==2
      PBDebug.log("***Player drew with opponent***") if @decision==5
      if @internalBattle
        pbDisplayPaused(_INTL("You have no more Pokémon that can fight!"))
        if trainerBattle?
          case @opponent.length
          when 1
            pbDisplayPaused(_INTL("You lost against {1}!",@opponent[0].full_name))
          when 2
            pbDisplayPaused(_INTL("You lost against {1} and {2}!",
               @opponent[0].full_name,@opponent[1].full_name))
          when 3
            pbDisplayPaused(_INTL("You lost against {1}, {2} and {3}!",
               @opponent[0].full_name,@opponent[1].full_name,@opponent[2].full_name))
          end
        end
        # Lose money from losing a battle
        pbLoseMoney
        pbDisplayPaused(_INTL("You blacked out!")) if !@canLose
      elsif @decision==2
        if @opponent
          @opponent.each_with_index do |_t,i|
            @scene.pbShowOpponent(i)
            msg = (@endSpeechesWin[i] && @endSpeechesWin[i]!="") ? @endSpeechesWin[i] : "..."
            pbDisplayPaused(msg.gsub(/\\[Pp][Nn]/,pbPlayer.name))
          end
        end
      end
    ##### CAUGHT WILD POKÉMON #####
    when 4
      @scene.pbWildBattleSuccess if !Settings::GAIN_EXP_FOR_CAPTURE
    end
    # Register captured Pokémon in the Pokédex, and store them
    pbRecordAndStoreCaughtPokemon
    # Collect Pay Day money in a wild battle that ended in a capture
    pbGainMoney if @decision==4
    # Pass on Pokérus within the party
    if @internalBattle
      infected = []
      $Trainer.party.each_with_index do |pkmn,i|
        infected.push(i) if pkmn.pokerusStage==1
      end
      infected.each do |idxParty|
        strain = $Trainer.party[idxParty].pokerusStrain
        if idxParty>0 && $Trainer.party[idxParty-1].pokerusStage==0
          $Trainer.party[idxParty-1].givePokerus(strain) if rand(3)==0   # 33%
        end
        if idxParty<$Trainer.party.length-1 && $Trainer.party[idxParty+1].pokerusStage==0
          $Trainer.party[idxParty+1].givePokerus(strain) if rand(3)==0   # 33%
        end
      end
    end
    # Clean up battle stuff
    @scene.pbEndBattle(@decision)
    @battlers.each do |b|
      next if !b
      if b.ability == :BAROMETRIC
        b.form = 0
      end
      pbCancelChoice(b.index)   # Restore unused items to Bag
      BattleHandlers.triggerAbilityOnSwitchOut(b.ability,b,true) if b.abilityActive?
    end
    pbParty(0).each_with_index do |pkmn,i|
      next if !pkmn
      @peer.pbOnLeavingBattle(self,pkmn,@usedInBattle[0][i],true)   # Reset form
      pkmn.item = @initialItems[0][i]
    end
    @scene.pbTrainerBattleSpeech("loss") if @decision == 2
    # reset all the EBDX queues
    EliteBattle.reset(:nextBattleScript, :wildSpecies, :wildLevel, :wildForm, :nextBattleBack, :nextUI, :nextBattleData,
                     :wildSpecies, :wildLevel, :wildForm, :setBoss, :cachedBattler, :tviewport)
    EliteBattle.set(:setBoss, false)
    EliteBattle.set(:colorAlpha, 0)
    EliteBattle.set(:smAnim, false)
    # return final output
    return @decision
  end

  def pbStartBattleCore
    # Set up the battlers on each side
    sendOuts = pbSetUpSides
    # Create all the sprites and play the battle intro animation
    @field.weather = $game_screen.weather_type
    @scene.pbStartBattle(self)
    # Show trainers on both sides sending out Pokémon
    pbStartBattleSendOut(sendOuts)
    # Weather announcement
    weather_data = GameData::BattleWeather.try_get(@field.weather)
    pbCommonAnimation(weather_data.animation) if weather_data
    case @field.weather
    when :Sun         then pbDisplay(_INTL("The sunlight is strong."))
    when :Rain        then pbDisplay(_INTL("It is raining."))
    when :Sandstorm   then pbDisplay(_INTL("A sandstorm is raging."))
    when :Hail        then pbDisplay(_INTL("Hail is falling."))
    when :HarshSun    then pbDisplay(_INTL("The sunlight is extremely harsh."))
    when :HeavyRain   then pbDisplay(_INTL("It is raining heavily."))
    when :StrongWinds then pbDisplay(_INTL("The wind is strong."))
    when :ShadowSky   then pbDisplay(_INTL("The sky is shadowy."))
    when :Starstorm  then pbDisplay(_INTL("Stars fill the sky."))
    when :Thunder    then pbDisplay(_INTL("Lightning flashes in the sky."))
    when :Storm      then pbDisplay(_INTL("A thunderstorm rages. The ground became electrified!"))
    when :Humid      then pbDisplay(_INTL("The air is humid."))
    when :Overcast   then pbDisplay(_INTL("The sky is overcast."))
    when :Eclipse    then pbDisplay(_INTL("The sky is dark."))
    when :Fog        then pbDisplay(_INTL("The fog is deep."))
    when :AcidRain   then pbDisplay(_INTL("Acid rain is falling."))
    when :VolcanicAsh then pbDisplay(_INTL("Volcanic Ash sprinkles down."))
    when :Rainbow    then pbDisplay(_INTL("A rainbow crosses the sky."))
    when :Borealis   then pbDisplay(_INTL("The sky is ablaze with color."))
    when :TimeWarp   then pbDisplay(_INTL("Time has stopped."))
    when :Reverb     then pbDisplay(_INTL("A dull echo hums."))
    when :DClear     then pbDisplay(_INTL("The sky is distorted."))
    when :DRain      then pbDisplay(_INTL("Rain is falling upward."))
    when :DWind      then pbDisplay(_INTL("The wind is haunting."))
    when :DAshfall   then pbDisplay(_INTL("Ash floats in midair."))
    when :Sleet      then pbDisplay(_INTL("Sleet began to fall."))
    when :Windy      then pbDisplay(_INTL("There is a slight breeze."))
    when :HeatLight  then pbDisplay(_INTL("Static fills the air."))
    when :DustDevil  then pbDisplay(_INTL("A dust devil approaches."))
    end
    # Terrain announcement
    terrain_data = GameData::BattleTerrain.try_get(@field.terrain)
    pbCommonAnimation(terrain_data.animation) if terrain_data
    case @field.terrain
    when :Electric
      pbDisplay(_INTL("An electric current runs across the battlefield!"))
    when :Grassy
      pbDisplay(_INTL("Grass is covering the battlefield!"))
    when :Misty
      pbDisplay(_INTL("Mist swirls about the battlefield!"))
    when :Psychic
      pbDisplay(_INTL("The battlefield is weird!"))
    end
    # Abilities upon entering battle
    pbOnActiveAll
    # Main battle loop
    pbBattleLoop
  end

  def pbGainExpOne(idxParty,defeatedBattler,numPartic,expShare,expAll,showMessages=true)
    pkmn = pbParty(0)[idxParty]   # The Pokémon gaining EVs from defeatedBattler
    growth_rate = pkmn.growth_rate
    # Don't bother calculating if gainer is already at max Exp
    if pkmn.exp>=growth_rate.maximum_exp
      pkmn.calc_stats   # To ensure new EVs still have an effect
      return
    end
    isPartic    = defeatedBattler.participants.include?(idxParty)
    hasExpShare = expShare.include?(idxParty)
    level = defeatedBattler.level
    # Main Exp calculation
    exp = 0
    a = level*defeatedBattler.pokemon.base_exp
    if expShare.length>0 && (isPartic || hasExpShare)
      if numPartic==0   # No participants, all Exp goes to Exp Share holders
        exp = a / (Settings::SPLIT_EXP_BETWEEN_GAINERS ? expShare.length : 1)
      elsif Settings::SPLIT_EXP_BETWEEN_GAINERS   # Gain from participating and/or Exp Share
        exp = a/(2*numPartic) if isPartic
        exp += a/(2*expShare.length) if hasExpShare
      else   # Gain from participating and/or Exp Share (Exp not split)
        if pkmn.level >= $game_variables[106]
          exp = a/1000
        else
          exp = (isPartic) ? a : a/2
        end
      end
    elsif isPartic   # Participated in battle, no Exp Shares held by anyone
      if pkmn.level >= $game_variables[106]
        exp = a/1000
      else
        exp = a / (Settings::SPLIT_EXP_BETWEEN_GAINERS ? numPartic : 1)
      end
    elsif expAll   # Didn't participate in battle, gaining Exp due to Exp All
      # NOTE: Exp All works like the Exp Share from Gen 6+, not like the Exp All
      #       from Gen 1, i.e. Exp isn't split between all Pokémon gaining it.
      if pkmn.level >= $game_variables[106]
        exp = a/1000
      else
        exp = a/2
      end
    end
    return if exp<=0
    # Pokémon gain more Exp from trainer battles
    exp = (exp*1.5).floor if trainerBattle?
    # Scale the gained Exp based on the gainer's level (or not)
    if Settings::SCALED_EXP_FORMULA
      exp /= 5
      levelAdjust = (2*level+10.0)/(pkmn.level+level+10.0)
      levelAdjust = levelAdjust**5
      levelAdjust = Math.sqrt(levelAdjust)
      exp *= levelAdjust
      exp = exp.floor
      exp += 1 if isPartic || hasExpShare
    else
      exp /= 7
    end
    # Foreign Pokémon gain more Exp
    isOutsider = (pkmn.owner.id != pbPlayer.id ||
                 (pkmn.owner.language != 0 && pkmn.owner.language != pbPlayer.language))
    if isOutsider
      if pkmn.owner.language != 0 && pkmn.owner.language != pbPlayer.language
        exp = (exp*1.7).floor
      else
        exp = (exp*1.5).floor
      end
    end
    # Modify Exp gain based on pkmn's held item
    i = BattleHandlers.triggerExpGainModifierItem(pkmn.item,pkmn,exp)
    if i<0
      i = BattleHandlers.triggerExpGainModifierItem(@initialItems[0][idxParty],pkmn,exp)
    end
    exp = i if i>=0
    # Make sure Exp doesn't exceed the maximum
    expFinal = growth_rate.add_exp(pkmn.exp, exp)
    expGained = expFinal-pkmn.exp
    return if expGained<=0
    # "Exp gained" message
    if showMessages
      if isOutsider
        pbDisplayPaused(_INTL("{1} got a boosted {2} Exp. Points!",pkmn.name,expGained))
      else
        pbDisplayPaused(_INTL("{1} got {2} Exp. Points!",pkmn.name,expGained))
      end
    end
    curLevel = pkmn.level
    newLevel = growth_rate.level_from_exp(expFinal)
    if newLevel<curLevel
      debugInfo = "Levels: #{curLevel}->#{newLevel} | Exp: #{pkmn.exp}->#{expFinal} | gain: #{expGained}"
      raise RuntimeError.new(
         _INTL("{1}'s new level is less than its\r\ncurrent level, which shouldn't happen.\r\n[Debug: {2}]",
         pkmn.name,debugInfo))
    end
    # Give Exp
    if pkmn.shadowPokemon?
      pkmn.exp += expGained
      return
    end
    tempExp1 = pkmn.exp
    battler = pbFindBattler(idxParty)
    loop do   # For each level gained in turn...
      # EXP Bar animation
      levelMinExp = growth_rate.minimum_exp_for_level(curLevel)
      levelMaxExp = growth_rate.minimum_exp_for_level(curLevel + 1)
      tempExp2 = (levelMaxExp<expFinal) ? levelMaxExp : expFinal
      pkmn.exp = tempExp2
      @scene.pbEXPBar(battler,levelMinExp,levelMaxExp,tempExp1,tempExp2)
      tempExp1 = tempExp2
      curLevel += 1
      if curLevel>newLevel
        # Gained all the Exp now, end the animation
        pkmn.calc_stats
        battler.pbUpdate(false) if battler
        @scene.pbRefreshOne(battler.index) if battler
        break
      end
      # Levelled up
      pbCommonAnimation("LevelUp",battler) if battler
      oldTotalHP = pkmn.totalhp
      oldAttack  = pkmn.attack
      oldDefense = pkmn.defense
      oldSpAtk   = pkmn.spatk
      oldSpDef   = pkmn.spdef
      oldSpeed   = pkmn.speed
      if battler && battler.pokemon
        battler.pokemon.changeHappiness("levelup")
      end
      pkmn.calc_stats
      battler.pbUpdate(false) if battler
      @scene.pbRefreshOne(battler.index) if battler
      pbDisplayPaused(_INTL("{1} grew to Lv. {2}!",pkmn.name,curLevel))
      @scene.pbLevelUp(pkmn,battler,oldTotalHP,oldAttack,oldDefense,
                                    oldSpAtk,oldSpDef,oldSpeed)
      # Learn all moves learned at this level
      moveList = pkmn.getMoveList
      moveList.each { |m| pbLearnMove(idxParty,m[1]) if m[0]==curLevel }
    end
  end
end
