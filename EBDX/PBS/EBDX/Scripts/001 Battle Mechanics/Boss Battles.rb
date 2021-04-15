#===============================================================================
#  Extra additions for generating battlers as well as initializing boss battles
#===============================================================================
module EliteBattle
  #-----------------------------------------------------------------------------
  # generates Pokemon based on hashtable
  #-----------------------------------------------------------------------------
  def self.generateWild(data)
    species = randomizeSpecies(data.get_key(:species), !$nonStaticEncounter)
    level = data.get_key(:level)
    basestats = data.has_key?(:basestats) ? data.get_key(:basestats) : nil
    boss = data.has_key?(:bossboost) ? data.get_key(:bossboost) : false
    # raises error if critical data is not present
    raise "No species defined for Pokemon!" if !species
    raise "No level defined for Pokemon!" if !level
    # converts species to proper numeric value
    species = self.const(species)
    raise "Invalid species constant!" if species.nil?
    species = randomizeSpecies(species,true)
    # generates Pokemon for battle
    genwildpoke = pbGenerateWildPokemon(species, level)
    # applies modifiers to generated Pokemon
    genwildpoke.makeShiny if data.get_key(:shiny) || data.get_key(:superShiny)
    genwildpoke.forceSuper = true if data.get_key(:superShiny)
    genwildpoke.ev = data.get_key(:ev) if data.has_key?(:ev) && data[:ev].is_a?(Array)
    genwildpoke.iv = data.get_key(:iv) if data.has_key?(:iv) && data[:iv].is_a?(Array)
    genwildpoke.setAbility(data.get_key(:ability)) if data.has_key?(:ability)
    genwildpoke.calcStats(basestats, boss)
    genwildpoke.setGender(data.get_key(:gender)) if data.has_key?(:gender)
    genwildpoke.setNature(data.get_key(:nature)) if data.has_key?(:nature)
    genwildpoke.givePokerus if data.try_key?(:pokerus)
    genwildpoke.setItem(data.get_key(:item)) if data.has_key?(:item)
    genwildpoke.forcedForm = data.get_key(:form) if data.has_key?(:form)
    genwildpoke.resetMoves
    # adds moves
    if data.has_key?(:moves) && data[:moves].is_a?(Array)
      genwildpoke.pbDeleteAllMoves
      for move in data.get_key(:moves)
        genwildpoke.pbLearnMove(move)
      end
    end
    # adds ribbons
    if data.has_key?(:ribbons) && data[:ribbons].is_a?(Array)
      for ribbon in data.get_key(:ribbons)
        genwildpoke.giveRibbon(ribbon)
      end
    end
    return genwildpoke
  end
  #-----------------------------------------------------------------------------
  # customizable wild battles
  #-----------------------------------------------------------------------------
  def self.wildBattle(data, partysize = 1, canescape = true, canlose = false, playersize = 1)
    # assigns wild battler
    genwildpoke = data.is_a?(PokeBattle_Pokemon) ? data : self.generateWild(data)
    # skip battle if in debug
    if (Input.press?(Input::CTRL) && $DEBUG) || $Trainer.pokemonCount == 0
      if $Trainer.pokemonCount > 0
        pbMessage(_INTL("SKIPPING BATTLE..."))
      end
      $PokemonGlobal.nextBattleBGM  = nil
      $PokemonGlobal.nextBattleME   = nil
      $PokemonGlobal.nextBattleBack = nil
      return 1
    end
    # battle override proc
    handled = [nil]
    Events.onWildBattleOverride.trigger(nil, genwildpoke.species, genwildpoke.level, handled)
    return handled[0] if handled[0] != nil
    # caches species number
    EliteBattle.set(:wildSpecies, genwildpoke.species)
    # caches species level
    EliteBattle.set(:wildLevel, genwildpoke.level)
    # caches species form
    EliteBattle.set(:wildForm, genwildpoke.form)
    # try to load the next battle speech
    speech = EliteBattle.getData(genwildpoke.species, PBSpecies, :BATTLESCRIPT, (genwildpoke.form rescue 0))
    EliteBattle.set(:nextBattleScript, speech.to_sym) if !speech.nil?
    # sets battle rules
    setBattleRule(sprintf("%dv%d", partysize, playersize))
    setBattleRule(canlose ? "canlose" : "cannotlose")
    setBattleRule(canescape ? "canrun" : "cannotrun")
    # starts battle scene
    Events.onStartBattle.trigger(nil, genwildpoke)
    scene = pbNewBattleScene
    battle = PokeBattle_Battle.new(scene, $Trainer.party, [genwildpoke], $Trainer, nil)
    pbPrepareBattle(battle)
    decision = 0
    # triggers battle intro animation
    pbBattleAnimation(pbGetWildBattleBGM(genwildpoke.species), 0, [genwildpoke]) {
      pbSceneStandby {
        decision = battle.pbStartBattle
      }
      pbSet(data.get_key(:variable), decision) if data.is_a?(Hash) && data.has_key?(:variable)
      pbAfterBattle(decision, canlose)
    }
    Input.update
    # battle end proc
    Events.onWildBattleEnd.trigger(nil, genwildpoke.species, genwildpoke.level, decision)
    pbSet($PokemonTemp.battleRules["outcomeVar"] || 1, decision)
    $PokemonTemp.clearBattleRules
    $PokemonGlobal.nextBattleBGM       = nil
    $PokemonGlobal.nextBattleME        = nil
    $PokemonGlobal.nextBattleCaptureME = nil
    $PokemonGlobal.nextBattleBack      = nil
    return decision
  end
  #-----------------------------------------------------------------------------
  # 2v1 boss battle
  #-----------------------------------------------------------------------------
  def self.bossBattle(species, level, partysize = 2, cancatch = false, options = {})
    # set boss parameter to true
    EliteBattle.set(:setBoss, true)
    data = {
      :species => randomizeSpecies(species, true),
      :level => level,
      :ev => [255, 255, 255, 255, 255, 255],
      :iv => [31, 31, 31, 31, 31, 31],
      :bossboost => [1.75, 1.25, 1.25, 1.25, 1.25, 1.25]
    }
    # adds additional option data
    for key in options.keys
      data[key] = options[key]
    end
    # prevent catching
    self.set(:nextBattleData, { :CATCH_RATE => -1 }) if !cancatch
    # sets next UI
    d = EliteBattle.getData(:BOSSDATABOX, PBMetrics, :METRICS)
    EliteBattle.set(:nextUI, d ? d : {
      :ENEMYDATABOX => {
        :BITMAP => "dataBoxBoss",
        :CONTAINER => "containersBoss"
        #:SHOWHP => true
      }#, :PLAYERDATABOX => {
      #  :EXPANDINDOUBLES => true
      #}
    })
    # safety parameter
    partysize = 3 if partysize > 3; partysize = 1 if partysize < 1
    # run battle
    return self.wildBattle(data, partysize, false, false)
  end
  #-----------------------------------------------------------------------------
end
