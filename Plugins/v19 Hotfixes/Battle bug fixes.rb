#==============================================================================
# "v19 Hotfixes" plugin
# This file contains fixes for bugs relating to battles.
# These bug fixes are also in the master branch of the GitHub version of
# Essentials:
# https://github.com/Maruno17/pokemon-essentials
#==============================================================================



#==============================================================================
# Fix for pseudo-moves not working due to having invalid types.
#==============================================================================
class PokeBattle_Confusion < PokeBattle_Move
  def initialize(battle,move)
    @battle     = battle
    @realMove   = move
    @id         = 0
    @name       = ""
    @function   = "000"
    @baseDamage = 40
    @type       = nil
    @category   = 0
    @accuracy   = 100
    @pp         = -1
    @target     = 0
    @priority   = 0
    @flags      = ""
    @addlEffect = 0
    @calcType   = nil
    @powerBoost = false
    @snatched   = false
  end
end

class PokeBattle_Struggle < PokeBattle_Move
  def initialize(battle,move)
    @battle     = battle
    @realMove   = nil                     # Not associated with a move
    @id         = (move) ? move.id : :STRUGGLE
    @name       = (move) ? move.name : _INTL("Struggle")
    @function   = "002"
    @baseDamage = 50
    @type       = nil
    @category   = 0
    @accuracy   = 0
    @pp         = -1
    @target     = 0
    @priority   = 0
    @flags      = ""
    @addlEffect = 0
    @calcType   = nil
    @powerBoost = false
    @snatched   = false
  end
end

#==============================================================================
# Fix for AI breaking and causing it to not do anything.
#==============================================================================
class PokeBattle_AI
  def pbRoughDamage(move,user,target,skill,baseDmg)
    # Fixed damage moves
    return baseDmg if move.is_a?(PokeBattle_FixedDamageMove)
    # Get the move's type
    type = pbRoughType(move,user,skill)
    ##### Calculate user's attack stat #####
    atk = pbRoughStat(user,:ATTACK,skill)
    if move.function=="121"   # Foul Play
      atk = pbRoughStat(target,:ATTACK,skill)
    elsif move.specialMove?(type)
      if move.function=="121"   # Foul Play
        atk = pbRoughStat(target,:SPECIAL_ATTACK,skill)
      else
        atk = pbRoughStat(user,:SPECIAL_ATTACK,skill)
      end
    end
    ##### Calculate target's defense stat #####
    defense = pbRoughStat(target,:DEFENSE,skill)
    if move.specialMove?(type) && move.function!="122"   # Psyshock
      defense = pbRoughStat(target,:SPECIAL_DEFENSE,skill)
    end
    ##### Calculate all multiplier effects #####
    multipliers = {
      :base_damage_multiplier  => 1.0,
      :attack_multiplier       => 1.0,
      :defense_multiplier      => 1.0,
      :final_damage_multiplier => 1.0
    }
    # Ability effects that alter damage
    moldBreaker = false
    if skill>=PBTrainerAI.highSkill && target.hasMoldBreaker?
      moldBreaker = true
    end
    if skill>=PBTrainerAI.mediumSkill && user.abilityActive?
      # NOTE: These abilities aren't suitable for checking at the start of the
      #       round.
      abilityBlacklist = [:ANALYTIC,:SNIPER,:TINTEDLENS,:AERILATE,:PIXILATE,:REFRIGERATE]
      canCheck = true
      abilityBlacklist.each do |m|
        next if move.id != m
        canCheck = false
        break
      end
      if canCheck
        BattleHandlers.triggerDamageCalcUserAbility(user.ability,
           user,target,move,multipliers,baseDmg,type)
      end
    end
    if skill>=PBTrainerAI.mediumSkill && !moldBreaker
      user.eachAlly do |b|
        next if !b.abilityActive?
        BattleHandlers.triggerDamageCalcUserAllyAbility(b.ability,
           user,target,move,multipliers,baseDmg,type)
      end
    end
    if skill>=PBTrainerAI.bestSkill && !moldBreaker && target.abilityActive?
      # NOTE: These abilities aren't suitable for checking at the start of the
      #       round.
      abilityBlacklist = [:FILTER,:SOLIDROCK]
      canCheck = true
      abilityBlacklist.each do |m|
        next if move.id != m
        canCheck = false
        break
      end
      if canCheck
        BattleHandlers.triggerDamageCalcTargetAbility(target.ability,
           user,target,move,multipliers,baseDmg,type)
      end
    end
    if skill>=PBTrainerAI.bestSkill && !moldBreaker
      target.eachAlly do |b|
        next if !b.abilityActive?
        BattleHandlers.triggerDamageCalcTargetAllyAbility(b.ability,
           user,target,move,multipliers,baseDmg,type)
      end
    end
    # Item effects that alter damage
    # NOTE: Type-boosting gems aren't suitable for checking at the start of the
    #       round.
    if skill>=PBTrainerAI.mediumSkill && user.itemActive?
      # NOTE: These items aren't suitable for checking at the start of the
      #       round.
      itemBlacklist = [:EXPERTBELT,:LIFEORB]
      if !itemBlacklist.include?(user.item_id)
        BattleHandlers.triggerDamageCalcUserItem(user.item,
           user,target,move,multipliers,baseDmg,type)
      end
    end
    if skill>=PBTrainerAI.bestSkill && target.itemActive?
      # NOTE: Type-weakening berries aren't suitable for checking at the start
      #       of the round.
      if target.item && !target.item.is_berry?
        BattleHandlers.triggerDamageCalcTargetItem(target.item,
           user,target,move,multipliers,baseDmg,type)
      end
    end
    # Global abilities
    if skill>=PBTrainerAI.mediumSkill
      if (@battle.pbCheckGlobalAbility(:DARKAURA) && type == :DARK) ||
         (@battle.pbCheckGlobalAbility(:FAIRYAURA) && type == :FAIRY)
        if @battle.pbCheckGlobalAbility(:AURABREAK)
          multipliers[:base_damage_multiplier] *= 2 / 3.0
        else
          multipliers[:base_damage_multiplier] *= 4 / 3.0
        end
      end
    end
    # Parental Bond
    if skill>=PBTrainerAI.mediumSkill && user.hasActiveAbility?(:PARENTALBOND)
      multipliers[:base_damage_multiplier] *= 1.25
    end
    # Me First
    # TODO
    # Helping Hand - n/a
    # Charge
    if skill>=PBTrainerAI.mediumSkill
      if user.effects[PBEffects::Charge]>0 && type == :ELECTRIC
        multipliers[:base_damage_multiplier] *= 2
      end
    end
    # Mud Sport and Water Sport
    if skill>=PBTrainerAI.mediumSkill
      if type == :ELECTRIC
        @battle.eachBattler do |b|
          next if !b.effects[PBEffects::MudSport]
          multipliers[:base_damage_multiplier] /= 3
          break
        end
        if @battle.field.effects[PBEffects::MudSportField]>0
          multipliers[:base_damage_multiplier] /= 3
        end
      end
      if type == :FIRE
        @battle.eachBattler do |b|
          next if !b.effects[PBEffects::WaterSport]
          multipliers[:base_damage_multiplier] /= 3
          break
        end
        if @battle.field.effects[PBEffects::WaterSportField]>0
          multipliers[:base_damage_multiplier] /= 3
        end
      end
    end
    # Terrain moves
    if skill>=PBTrainerAI.mediumSkill
      case @battle.field.terrain
      when :Electric
        multipliers[:base_damage_multiplier] *= 1.5 if type == :ELECTRIC && user.affectedByTerrain?
      when :Grassy
        multipliers[:base_damage_multiplier] *= 1.5 if type == :GRASS && user.affectedByTerrain?
      when :Psychic
        multipliers[:base_damage_multiplier] *= 1.5 if type == :PSYCHIC && user.affectedByTerrain?
      when :Misty
        multipliers[:base_damage_multiplier] /= 2 if type == :DRAGON && target.affectedByTerrain?
      end
    end
    # Badge multipliers
    if skill>=PBTrainerAI.highSkill
      if @battle.internalBattle
        # Don't need to check the Atk/Sp Atk-boosting badges because the AI
        # won't control the player's Pokémon.
        if target.pbOwnedByPlayer?
          if move.physicalMove?(type) && @battle.pbPlayer.badge_count >= Settings::NUM_BADGES_BOOST_DEFENSE
            multipliers[:defense_multiplier] *= 1.1
          elsif move.specialMove?(type) && @battle.pbPlayer.badge_count >= Settings::NUM_BADGES_BOOST_SPDEF
            multipliers[:defense_multiplier] *= 1.1
          end
        end
      end
    end
    # Multi-targeting attacks
    if skill>=PBTrainerAI.highSkill
      if pbTargetsMultiple?(move,user)
        multipliers[:final_damage_multiplier] *= 0.75
      end
    end
    # Weather
    if skill>=PBTrainerAI.mediumSkill
      case @battle.pbWeather
      when :Sun, :HarshSun
        if type == :FIRE
          multipliers[:final_damage_multiplier] *= 1.5
        elsif type == :WATER
          multipliers[:final_damage_multiplier] /= 2
        end
      when :Rain, :HeavyRain
        if type == :FIRE
          multipliers[:final_damage_multiplier] /= 2
        elsif type == :WATER
          multipliers[:final_damage_multiplier] *= 1.5
        end
      when :Sandstorm
        if target.pbHasType?(:ROCK) && move.specialMove?(type) && move.function != "122"   # Psyshock
          multipliers[:defense_multiplier] *= 1.5
        end
      end
    end
    # Critical hits - n/a
    # Random variance - n/a
    # STAB
    if skill>=PBTrainerAI.mediumSkill
      if type && user.pbHasType?(type)
        if user.hasActiveAbility?(:ADAPTABILITY)
          multipliers[:final_damage_multiplier] *= 2
        else
          multipliers[:final_damage_multiplier] *= 1.5
        end
      end
    end
    # Type effectiveness
    if skill>=PBTrainerAI.mediumSkill
      typemod = pbCalcTypeMod(type,user,target)
      multipliers[:final_damage_multiplier] *= typemod.to_f / Effectiveness::NORMAL_EFFECTIVE
    end
    # Burn
    if skill>=PBTrainerAI.highSkill
      if user.status == :BURN && move.physicalMove?(type) &&
         !user.hasActiveAbility?(:GUTS) &&
         !(Settings::MECHANICS_GENERATION >= 6 && move.function == "07E")   # Facade
        multipliers[:final_damage_multiplier] /= 2
      end
    end
    # Aurora Veil, Reflect, Light Screen
    if skill>=PBTrainerAI.highSkill
      if !move.ignoresReflect? && !user.hasActiveAbility?(:INFILTRATOR)
        if target.pbOwnSide.effects[PBEffects::AuroraVeil] > 0
          if @battle.pbSideBattlerCount(target) > 1
            multipliers[:final_damage_multiplier] *= 2 / 3.0
          else
            multipliers[:final_damage_multiplier] /= 2
          end
        elsif target.pbOwnSide.effects[PBEffects::Reflect] > 0 && move.physicalMove?(type)
          if @battle.pbSideBattlerCount(target) > 1
            multipliers[:final_damage_multiplier] *= 2 / 3.0
          else
            multipliers[:final_damage_multiplier] /= 2
          end
        elsif target.pbOwnSide.effects[PBEffects::LightScreen] > 0 && move.specialMove?(type)
          if @battle.pbSideBattlerCount(target) > 1
            multipliers[:final_damage_multiplier] *= 2 / 3.0
          else
            multipliers[:final_damage_multiplier] /= 2
          end
        end
      end
    end
    # Minimize
    if skill>=PBTrainerAI.highSkill
      if target.effects[PBEffects::Minimize] && move.tramplesMinimize?(2)
        multipliers[:final_damage_multiplier] *= 2
      end
    end
    # Move-specific base damage modifiers
    # TODO
    # Move-specific final damage modifiers
    # TODO
    ##### Main damage calculation #####
    baseDmg = [(baseDmg * multipliers[:base_damage_multiplier]).round, 1].max
    atk     = [(atk     * multipliers[:attack_multiplier]).round, 1].max
    defense = [(defense * multipliers[:defense_multiplier]).round, 1].max
    damage  = (((2.0 * user.level / 5 + 2).floor * baseDmg * atk / defense).floor / 50).floor + 2
    damage  = [(damage  * multipliers[:final_damage_multiplier]).round, 1].max
    # "AI-specific calculations below"
    # Increased critical hit rates
    if skill>=PBTrainerAI.mediumSkill
      c = 0
      # Ability effects that alter critical hit rate
      if c>=0 && user.abilityActive?
        c = BattleHandlers.triggerCriticalCalcUserAbility(user.ability,user,target,c)
      end
      if skill>=PBTrainerAI.bestSkill
        if c>=0 && !moldBreaker && target.abilityActive?
          c = BattleHandlers.triggerCriticalCalcTargetAbility(target.ability,user,target,c)
        end
      end
      # Item effects that alter critical hit rate
      if c>=0 && user.itemActive?
        c = BattleHandlers.triggerCriticalCalcUserItem(user.item,user,target,c)
      end
      if skill>=PBTrainerAI.bestSkill
        if c>=0 && target.itemActive?
          c = BattleHandlers.triggerCriticalCalcTargetItem(target.item,user,target,c)
        end
      end
      # Other efffects
      c = -1 if target.pbOwnSide.effects[PBEffects::LuckyChant]>0
      if c>=0
        c += 1 if move.highCriticalRate?
        c += user.effects[PBEffects::FocusEnergy]
        c += 1 if user.inHyperMode? && move.type == :SHADOW
      end
      if c>=0
        c = 4 if c>4
        damage += damage*0.1*c
      end
    end
    return damage.floor
  end
end

#==============================================================================
# Fix for crash when trying to battle against two trainers that noticed the
# player at the same time.
#==============================================================================
def pbTrainerBattleCore(*args)
  outcomeVar = $PokemonTemp.battleRules["outcomeVar"] || 1
  canLose    = $PokemonTemp.battleRules["canLose"] || false
  # Skip battle if the player has no able Pokémon, or if holding Ctrl in Debug mode
  if $Trainer.able_pokemon_count == 0 || ($DEBUG && Input.press?(Input::CTRL))
    pbMessage(_INTL("SKIPPING BATTLE...")) if $DEBUG
    pbMessage(_INTL("AFTER WINNING...")) if $DEBUG && $Trainer.able_pokemon_count > 0
    pbSet(outcomeVar,($Trainer.able_pokemon_count == 0) ? 0 : 1)   # Treat it as undecided/a win
    $PokemonTemp.clearBattleRules
    $PokemonGlobal.nextBattleBGM       = nil
    $PokemonGlobal.nextBattleME        = nil
    $PokemonGlobal.nextBattleCaptureME = nil
    $PokemonGlobal.nextBattleBack      = nil
    return ($Trainer.able_pokemon_count == 0) ? 0 : 1   # Treat it as undecided/a win
  end
  # Record information about party Pokémon to be used at the end of battle (e.g.
  # comparing levels for an evolution check)
  Events.onStartBattle.trigger(nil)
  # Generate trainers and their parties based on the arguments given
  foeTrainers    = []
  foeItems       = []
  foeEndSpeeches = []
  foeParty       = []
  foePartyStarts = []
  for arg in args
    raise _INTL("Expected an array of trainer data, got {1}.",arg) if !arg.is_a?(Array)
    if arg[0].is_a?(NPCTrainer)
      foeTrainers.push(arg[0])
      foePartyStarts.push(foeParty.length)
      arg[0].party.each { |pkmn| foeParty.push(pkmn) }
      foeEndSpeeches.push(arg[0].lose_text)
      foeItems.push(arg[0].items)
    else
      # [trainer type, trainer name, ID, speech (optional)]
      trainer = pbLoadTrainer(arg[0],arg[1],arg[2])
      pbMissingTrainer(arg[0],arg[1],arg[2]) if !trainer
      return 0 if !trainer
      Events.onTrainerPartyLoad.trigger(nil,trainer)
      foeTrainers.push(trainer)
      foePartyStarts.push(foeParty.length)
      trainer.party.each { |pkmn| foeParty.push(pkmn) }
      foeEndSpeeches.push(arg[3] || trainer.lose_text)
      foeItems.push(trainer.items)
    end
  end
  # Calculate who the player trainer(s) and their party are
  playerTrainers    = [$Trainer]
  playerParty       = $Trainer.party
  playerPartyStarts = [0]
  room_for_partner = (foeParty.length > 1)
  if !room_for_partner && $PokemonTemp.battleRules["size"] &&
     !["single", "1v1", "1v2", "1v3"].include?($PokemonTemp.battleRules["size"])
    room_for_partner = true
  end
  if $PokemonGlobal.partner && !$PokemonTemp.battleRules["noPartner"] && room_for_partner
    ally = NPCTrainer.new($PokemonGlobal.partner[1], $PokemonGlobal.partner[0])
    ally.id    = $PokemonGlobal.partner[2]
    ally.party = $PokemonGlobal.partner[3]
    playerTrainers.push(ally)
    playerParty = []
    $Trainer.party.each { |pkmn| playerParty.push(pkmn) }
    playerPartyStarts.push(playerParty.length)
    ally.party.each { |pkmn| playerParty.push(pkmn) }
    setBattleRule("double") if !$PokemonTemp.battleRules["size"]
  end
  # Create the battle scene (the visual side of it)
  scene = pbNewBattleScene
  # Create the battle class (the mechanics side of it)
  battle = PokeBattle_Battle.new(scene,playerParty,foeParty,playerTrainers,foeTrainers)
  battle.party1starts = playerPartyStarts
  battle.party2starts = foePartyStarts
  battle.items        = foeItems
  battle.endSpeeches  = foeEndSpeeches
  # Set various other properties in the battle class
  pbPrepareBattle(battle)
  $PokemonTemp.clearBattleRules
  # End the trainer intro music
  Audio.me_stop
  # Perform the battle itself
  decision = 0
  pbBattleAnimation(pbGetTrainerBattleBGM(foeTrainers),(battle.singleBattle?) ? 1 : 3,foeTrainers) {
    pbSceneStandby {
      decision = battle.pbStartBattle
    }
    pbAfterBattle(decision,canLose)
  }
  Input.update
  # Save the result of the battle in a Game Variable (1 by default)
  #    0 - Undecided or aborted
  #    1 - Player won
  #    2 - Player lost
  #    3 - Player or wild Pokémon ran from battle, or player forfeited the match
  #    5 - Draw
  pbSet(outcomeVar,decision)
  return decision
end

#==============================================================================
# Fixed learning a move in battle just replacing the first known move instead
# of learning it properly.
#==============================================================================
class PokeBattle_Battle
  def pbLearnMove(idxParty,newMove)
    pkmn = pbParty(0)[idxParty]
    return if !pkmn
    pkmnName = pkmn.name
    battler = pbFindBattler(idxParty)
    moveName = GameData::Move.get(newMove).name
    # Pokémon already knows the move
    return if pkmn.moves.any? { |m| m && m.id == newMove }
    # Pokémon has space for the new move; just learn it
    if pkmn.moves.length < Pokemon::MAX_MOVES
      pkmn.moves.push(Pokemon::Move.new(newMove))
      pbDisplay(_INTL("{1} learned {2}!",pkmnName,moveName)) { pbSEPlay("Pkmn move learnt") }
      if battler
        battler.moves.push(PokeBattle_Move.from_pokemon_move(self, pkmn.moves.last))
        battler.pbCheckFormOnMovesetChange
      end
      return
    end
    # Pokémon already knows the maximum number of moves; try to forget one to learn the new move
    loop do
      pbDisplayPaused(_INTL("{1} wants to learn {2}, but it already knows four moves.",pkmnName,moveName))
      if pbDisplayConfirm(_INTL("Forget a move to learn {1}?",moveName))
        pbDisplayPaused(_INTL("Which move should be forgotten?"))
        forgetMove = @scene.pbForgetMove(pkmn,newMove)
        if forgetMove>=0
          oldMoveName = pkmn.moves[forgetMove].name
          pkmn.moves[forgetMove] = Pokemon::Move.new(newMove)   # Replaces current/total PP
          battler.moves[forgetMove] = PokeBattle_Move.from_pokemon_move(self, pkmn.moves[forgetMove]) if battler
          pbDisplayPaused(_INTL("1, 2, and... ... ... Ta-da!"))
          pbDisplayPaused(_INTL("{1} forgot how to use {2}. And...",pkmnName,oldMoveName))
          pbDisplay(_INTL("{1} learned {2}!",pkmnName,moveName)) { pbSEPlay("Pkmn move learnt") }
          battler.pbCheckFormOnMovesetChange if battler
          break
        elsif pbDisplayConfirm(_INTL("Give up on learning {1}?",moveName))
          pbDisplay(_INTL("{1} did not learn {2}.",pkmnName,moveName))
          break
        end
      elsif pbDisplayConfirm(_INTL("Give up on learning {1}?",moveName))
        pbDisplay(_INTL("{1} did not learn {2}.",pkmnName,moveName))
        break
      end
    end
  end
end

#==============================================================================
# Fixed Illusion not working properly.
#==============================================================================
class PokeBattle_Battle
  def pbLastInTeam(idxBattler)
    party       = pbParty(idxBattler)
    partyOrders = pbPartyOrder(idxBattler)
    idxPartyStart, idxPartyEnd = pbTeamIndexRangeFromBattlerIndex(idxBattler)
    ret = -1
    party.each_with_index do |pkmn,i|
      next if i<idxPartyStart || i>=idxPartyEnd   # Check the team only
      next if !pkmn || !pkmn.able?   # Can't copy a non-fainted Pokémon or egg
      ret = i if ret < 0 || partyOrders[i] > partyOrders[ret]
    end
    return ret
  end

  def pbEORSwitch(favorDraws=false)
    return if @decision>0 && !favorDraws
    return if @decision==5 && favorDraws
    pbJudge
    return if @decision>0
    # Check through each fainted battler to see if that spot can be filled.
    switched = []
    loop do
      switched.clear
      @battlers.each do |b|
        next if !b || !b.fainted?
        idxBattler = b.index
        next if !pbCanChooseNonActive?(idxBattler)
        if !pbOwnedByPlayer?(idxBattler)   # Opponent/ally is switching in
          next if wildBattle? && opposes?(idxBattler)   # Wild Pokémon can't switch
          idxPartyNew = pbSwitchInBetween(idxBattler)
          opponent = pbGetOwnerFromBattlerIndex(idxBattler)
          # NOTE: The player is only offered the chance to switch their own
          #       Pokémon when an opponent replaces a fainted Pokémon in single
          #       battles. In double battles, etc. there is no such offer.
          if @internalBattle && @switchStyle && trainerBattle? && pbSideSize(0)==1 &&
             opposes?(idxBattler) && !@battlers[0].fainted? && !switched.include?(0) &&
             pbCanChooseNonActive?(0) && @battlers[0].effects[PBEffects::Outrage]==0
            idxPartyForName = idxPartyNew
            enemyParty = pbParty(idxBattler)
            if enemyParty[idxPartyNew].ability == :ILLUSION
              new_index = pbLastInTeam(idxBattler)
              idxPartyForName = new_index if new_index >= 0 && new_index != idxPartyNew
            end
            if pbDisplayConfirm(_INTL("{1} is about to send in {2}. Will you switch your Pokémon?",
               opponent.full_name, enemyParty[idxPartyForName].name))
              idxPlayerPartyNew = pbSwitchInBetween(0,false,true)
              if idxPlayerPartyNew>=0
                pbMessageOnRecall(@battlers[0])
                pbRecallAndReplace(0,idxPlayerPartyNew)
                switched.push(0)
              end
            end
          end
          pbRecallAndReplace(idxBattler,idxPartyNew)
          switched.push(idxBattler)
        elsif trainerBattle?   # Player switches in in a trainer battle
          idxPlayerPartyNew = pbGetReplacementPokemonIndex(idxBattler)   # Owner chooses
          pbRecallAndReplace(idxBattler,idxPlayerPartyNew)
          switched.push(idxBattler)
        else   # Player's Pokémon has fainted in a wild battle
          switch = false
          if !pbDisplayConfirm(_INTL("Use next Pokémon?"))
            switch = (pbRun(idxBattler,true)<=0)
          else
            switch = true
          end
          if switch
            idxPlayerPartyNew = pbGetReplacementPokemonIndex(idxBattler)   # Owner chooses
            pbRecallAndReplace(idxBattler,idxPlayerPartyNew)
            switched.push(idxBattler)
          end
        end
      end
      break if switched.length==0
      pbPriority(true).each do |b|
        b.pbEffectsOnSwitchIn(true) if switched.include?(b.index)
      end
    end
  end

  def pbMessagesOnReplace(idxBattler,idxParty)
    party = pbParty(idxBattler)
    newPkmnName = party[idxParty].name
    if party[idxParty].ability == :ILLUSION
      new_index = pbLastInTeam(idxBattler)
      newPkmnName = party[new_index].name if new_index >= 0 && new_index != idxParty
    end
    if pbOwnedByPlayer?(idxBattler)
      opposing = @battlers[idxBattler].pbDirectOpposing
      if opposing.fainted? || opposing.hp==opposing.totalhp
        pbDisplayBrief(_INTL("You're in charge, {1}!",newPkmnName))
      elsif opposing.hp>=opposing.totalhp/2
        pbDisplayBrief(_INTL("Go for it, {1}!",newPkmnName))
      elsif opposing.hp>=opposing.totalhp/4
        pbDisplayBrief(_INTL("Just a little more! Hang in there, {1}!",newPkmnName))
      else
        pbDisplayBrief(_INTL("Your opponent's weak! Get 'em, {1}!",newPkmnName))
      end
    else
      owner = pbGetOwnerFromBattlerIndex(idxBattler)
      pbDisplayBrief(_INTL("{1} sent out {2}!",owner.full_name,newPkmnName))
    end
  end
end

#==============================================================================
# Fix for Pokémon not recognising they are a Mega Evolution once they become
# one. Fix for inadequate code checking if a Mega Stone is unlosable by a
# Pokémon.
#==============================================================================
class PokeBattle_Battler
  def unlosableItem?(check_item)
    return false if !check_item
    return true if GameData::Item.get(check_item).is_mail?
    return false if @effects[PBEffects::Transform]
    # Items that change a Pokémon's form
    if mega?   # Check if item was needed for this Mega Evolution
      return true if @pokemon.species_data.mega_stone == check_item
    else   # Check if item could cause a Mega Evolution
      GameData::Species.each do |data|
        next if data.species != @species || data.unmega_form != @form
        return true if data.mega_stone == check_item
      end
    end
    # Other unlosable items
    return GameData::Item.get(check_item).unlosable?(@species, self.ability)
  end
end

class Pokemon
  def getMegaForm
    ret = 0
    GameData::Species.each do |data|
      next if data.species != @species || data.unmega_form != form_simple
      if data.mega_stone && hasItem?(data.mega_stone)
        ret = data.form
        break
      elsif data.mega_move && hasMove?(data.mega_move)
        ret = data.form
        break
      end
    end
    return ret   # form number, or 0 if no accessible Mega form
  end

  def mega?
    return (species_data.mega_stone || species_data.mega_move) ? true : false
  end
end

#==============================================================================
# Fixed bug when using Metronome.
#==============================================================================
class PokeBattle_Move_0B6 < PokeBattle_Move
  def pbMoveFailed?(user,targets)
    @metronomeMove = nil
    move_keys = GameData::Move::DATA.keys
    # NOTE: You could be really unlucky and roll blacklisted moves 1000 times in
    #       a row. This is too unlikely to care about, though.
    1000.times do
      move_id = move_keys[@battle.pbRandom(move_keys.length)]
      move_data = GameData::Move.get(move_id)
      next if @moveBlacklist.include?(move_data.function_code)
      next if @moveBlacklistSignatures.include?(move_data.id)
      next if move_data.type == :SHADOW
      @metronomeMove = move_data.id
      break
    end
    if !@metronomeMove
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end
end

#==============================================================================
# Fixed broken AI for Conversio, Conversion 2 and Camouflage.
#==============================================================================
class PokeBattle_AI
  alias __hotfixes__pbGetMoveScoreFunctionCode pbGetMoveScoreFunctionCode

  def pbGetMoveScoreFunctionCode(score,move,user,target,skill=100)
    case move.function
    when "05E"
      if !user.canChangeType?
        score -= 90
      else
        has_possible_type = false
        user.eachMoveWithIndex do |m,i|
          break if Settings::MECHANICS_GENERATION >= 6 && i>0
          next if GameData::Type.get(m.type).pseudo_type
          next if user.pbHasType?(m.type)
          has_possible_type = true
          break
        end
        score -= 90 if !has_possible_type
      end
    #---------------------------------------------------------------------------
    when "05F"
      if !user.canChangeType?
        score -= 90
      elsif !target.lastMoveUsed || !target.lastMoveUsedType ||
         GameData::Type.get(target.lastMoveUsedType).pseudo_type
        score -= 90
      else
        aType = nil
        target.eachMove do |m|
          next if m.id!=target.lastMoveUsed
          aType = m.pbCalcType(user)
          break
        end
        if !aType
          score -= 90
        else
          has_possible_type = false
          GameData::Type.each do |t|
            next if t.pseudo_type || user.pbHasType?(t.id) ||
                    !Effectiveness.resistant_type?(target.lastMoveUsedType, t.id)
            has_possible_type = true
            break
          end
          score -= 90 if !has_possible_type
        end
      end
    when "060"
      if !user.canChangeType?
        score -= 90
      elsif skill>=PBTrainerAI.mediumSkill
        new_type = nil
        case @battle.field.terrain
        when :Electric
          new_type = :ELECTRIC if GameData::Type.exists?(:ELECTRIC)
        when :Grassy
          new_type = :GRASS if GameData::Type.exists?(:GRASS)
        when :Misty
          new_type = :FAIRY if GameData::Type.exists?(:FAIRY)
        when :Psychic
          new_type = :PSYCHIC if GameData::Type.exists?(:PSYCHIC)
        end
        if !new_type
          envtypes = {
             :None        => :NORMAL,
             :Grass       => :GRASS,
             :TallGrass   => :GRASS,
             :MovingWater => :WATER,
             :StillWater  => :WATER,
             :Puddle      => :WATER,
             :Underwater  => :WATER,
             :Cave        => :ROCK,
             :Rock        => :GROUND,
             :Sand        => :GROUND,
             :Forest      => :BUG,
             :ForestGrass => :BUG,
             :Snow        => :ICE,
             :Ice         => :ICE,
             :Volcano     => :FIRE,
             :Graveyard   => :GHOST,
             :Sky         => :FLYING,
             :Space       => :DRAGON,
             :UltraSpace  => :PSYCHIC
          }
          new_type = envtypes[@battle.environment]
          new_type = nil if !GameData::Type.exists?(new_type)
          new_type ||= :NORMAL
        end
        score -= 90 if !user.pbHasOtherType?(new_type)
      end
    else
	  score = __hotfixes__pbGetMoveScoreFunctionCode(score,move,user,target,skill)
	end
	return score
  end
end

#==============================================================================
# Fixed misnamed variables in Effectiveness methods.
#==============================================================================
module Effectiveness
  module_function

  def ineffective_type?(attack_type, defend_type1, defend_type2 = nil, defend_type3 = nil)
    value = calculate(attack_type, defend_type1, defend_type2, defend_type3)
    return ineffective?(value)
  end

  def not_very_effective_type?(attack_type, defend_type1, defend_type2 = nil, defend_type3 = nil)
    value = calculate(attack_type, defend_type1, defend_type2, defend_type3)
    return not_very_effective?(value)
  end

  def resistant_type?(attack_type, defend_type1, defend_type2 = nil, defend_type3 = nil)
    value = calculate(attack_type, defend_type1, defend_type2, defend_type3)
    return resistant?(value)
  end

  def normal_type?(attack_type, defend_type1, defend_type2 = nil, defend_type3 = nil)
    value = calculate(attack_type, defend_type1, defend_type2, defend_type3)
    return normal?(value)
  end

  def super_effective_type?(attack_type, defend_type1, defend_type2 = nil, defend_type3 = nil)
    value = calculate(attack_type, defend_type1, defend_type2, defend_type3)
    return super_effective?(value)
  end
end

#==============================================================================
# Fixed Sketch not working.
#==============================================================================
class PokeBattle_Move_05D < PokeBattle_Move
  def pbFailsAgainstTarget?(user,target)
    lastMoveData = GameData::Move.try_get(target.lastRegularMoveUsed)
    if !lastMoveData ||
       user.pbHasMove?(target.lastRegularMoveUsed) ||
       @moveBlacklist.include?(lastMoveData.function_code) ||
       lastMoveData.type == :SHADOW
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end
end

#==============================================================================
# Fixed Poké Flute not working in battle if it has an effect.
#==============================================================================
ItemHandlers::UseInBattle.add(:POKEFLUTE,proc { |item,battler,battle|
  battle.eachBattler do |b|
    next if b.status != :SLEEP || b.hasActiveAbility?(:SOUNDPROOF)
    b.pbCureStatus(false)
  end
  battle.pbDisplay(_INTL("All Pokémon were roused by the tune!"))
})
