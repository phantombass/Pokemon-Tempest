#===============================================================================
#  Module core used to store and load common and move animations
#===============================================================================
module EliteBattle
  @@moveAnimations = {}
  @@commonAnimations = {}
  #-----------------------------------------------------------------------------
  #  function used to run Move Animations with implicit variables
  #-----------------------------------------------------------------------------
  def self.withMoveParams(anim, scene, userindex, targetindex, hitnum, multihit, *args)
    # initialize wrapper and pass instance variables
    scene.inMoveAnim = 0 if !anim.nil?
    wrapper = CallbackWrapper.new
    wrapper.set({ :scene => scene, :battle => scene.battle, :sprites => scene.sprites,
                 :userSprite => scene.sprites["pokemon_#{userindex}"],
                 :targetSprite => scene.sprites["pokemon_#{targetindex}"],
                 :userDatabox => scene.sprites["dataBox_#{userindex}"],
                 :targetDatabox => scene.sprites["dataBox_#{targetindex}"],
                 :multiHit => multihit, :hitNum => hitnum, :itself => (userindex == targetindex),
                 :userIsPlayer => (userindex%2 == 0), :targetIsPlayer => (targetindex%2 == 0),
                 :vector => scene.vector, :battlers => scene.battlers, :opponent => scene.battle.opponent,
                 :userIndex => userindex, :targetIndex => targetindex, :viewport => scene.viewport
    })
    # run animation code
    wrapper.execute(anim, *args)
  end
  #-----------------------------------------------------------------------------
  #  function used to run Common Animations with implicit variables
  #-----------------------------------------------------------------------------
  def self.withCommonParams(anim, scene, userindex, targetindex, hitnum, *args)
    # initialize wrapper and pass instance variables
    wrapper = CallbackWrapper.new
    wrapper.set({ :scene => scene, :battle => scene.battle, :sprites => scene.sprites,
                 :userSprite => scene.sprites["pokemon_#{userindex}"],
                 :targetSprite => scene.sprites["pokemon_#{targetindex}"],
                 :userDatabox => scene.sprites["dataBox_#{userindex}"],
                 :targetDatabox => scene.sprites["dataBox_#{targetindex}"],
                 :hitNum => hitnum, :itself => (userindex == targetindex),
                 :userIsPlayer => (userindex%2 == 0), :targetIsPlayer => (targetindex%2 == 0),
                 :vector => scene.vector, :battlers => scene.battlers, :opponent => scene.battle.opponent,
                 :userIndex => userindex, :targetIndex => targetindex, :viewport => scene.viewport
    })
    # run animation code
    wrapper.execute(anim, *args)
  end
  #-----------------------------------------------------------------------------
  #  function used to store Move Animations
  #-----------------------------------------------------------------------------
  def self.defineMoveAnimation(id, species = nil, process = nil, &block)
    if species.is_a?(Proc)
      process = species
      species = nil
    else
      species = self.returnId(PBSpecies, species) unless species.is_a?(Numeric)
    end
    # raise error message for incorrectly defined moves
    if process.nil? && block.nil?
      msg = "EBDX: No code block defined for move #{id}!"
      EliteBattle.log.error(msg)
      raise msg
    end
    id = self.returnId(PBMoves, id) unless id.is_a?(Numeric) || !hasConst?(PBMoves, id)
    # format ID for species specific move animation
    id = "#{species}=>#{id}" if !species.nil?
    # register regular move animation
    @@moveAnimations[id] = !process.nil? ? process : block
  end
  #-----------------------------------------------------------------------------
  #  function bulk copy Move Animations
  #-----------------------------------------------------------------------------
  def self.copyMoveAnimation(key, *args)
    return if !@@moveAnimations.has_key?(key)
    for k in args
      next if key == k
      @@moveAnimations[k] = key
    end
  end
  #-----------------------------------------------------------------------------
  #  function used to load Move Animations
  #-----------------------------------------------------------------------------
  def self.playMoveAnimation(id, scene, userindex, targetindex, hitnum = 0, multihit = false, species = nil, *args)
    species = self.returnId(PBSpecies, species) if !species.nil? && !species.is_a?(Numeric)
    id = self.returnId(PBMoves, id) unless id.is_a?(Numeric) || !hasConst?(PBMoves, id)
    # attempt to play species specific move animation
    if !species.nil? && @@moveAnimations.has_key?("#{species}=>#{id}")
      self.withMoveParams(@@moveAnimations["#{species}=>#{id}"], scene, userindex, targetindex, hitnum, multihit, *args)
      return true
    end
    # attempt to play regular move animation
    if !@@moveAnimations.has_key?(id)
      EliteBattle.log.debug("No EBDX Move Animation found for: #{id.to_s}")
      return false
    end
    # playback of cloned move animations
    if @@moveAnimations[id].is_a?(Symbol)
      self.withMoveParams(@@moveAnimations[@@moveAnimations[id]], scene, userindex, targetindex, hitnum, multihit, *args)
    # playback of regular move animations
    else
      self.withMoveParams(@@moveAnimations[id], scene, userindex, targetindex, hitnum, multihit, *args)
    end
    return true
  end
  #-----------------------------------------------------------------------------
  #  function used to get all defined animations (for Debug purposes)
  #-----------------------------------------------------------------------------
  def self.getDefinedAnimations
    moves = []; common = []
    for key in @@moveAnimations.keys
      key = getConstantName(PBMoves, key) if key.is_a?(Numeric)
      moves.push(key.to_s)
    end
    for key in @@commonAnimations.keys
      common.push(key.to_s)
    end
    return moves, common
  end
  #-----------------------------------------------------------------------------
  #  function used to store Common Animations
  #-----------------------------------------------------------------------------
  def self.defineCommonAnimation(symbol, process = nil, &block)
    @@commonAnimations[symbol] = !process.nil? ? process : block
  end
  #-----------------------------------------------------------------------------
  #  function bulk copy Common Animations
  #-----------------------------------------------------------------------------
  def self.copyCommonAnimation(key, *args)
    return if !@@commonAnimations.has_key?(key)
    for k in args
      next if key == k
      @@commonAnimations[k] = key
    end
  end
  #-----------------------------------------------------------------------------
  #  function used to load Common Animations
  #-----------------------------------------------------------------------------
  def self.playCommonAnimation(symbol, scene, userindex, targetindex = nil, hitnum = 0, *args)
    targetindex = userindex if targetindex.nil?
    if !@@commonAnimations.has_key?(symbol)
      EliteBattle.log.debug("No EBDX Common Animation found for: #{symbol.to_s}")
      return false
    end
    # playback of cloned common animations
    if @@commonAnimations[symbol].is_a?(Symbol)
      self.withCommonParams(@@commonAnimations[@@commonAnimations[symbol]], scene, userindex, targetindex, hitnum, *args)
    # playback of regular common animations
    else
      self.withCommonParams(@@commonAnimations[symbol], scene, userindex, targetindex, hitnum, *args)
    end
    return true
  end
  #-----------------------------------------------------------------------------
  #  map move to one of global animations
  #-----------------------------------------------------------------------------
  def self.mapMoveGlobal(scene, type, userindex, targetindex, hitnum, multihit, multitarget, category)
    type = type > -1 ? getConstantName(PBTypes, type).to_s.upcase.to_sym : nil
    return false if type.nil?
    id = nil
    id = @@allOpp[type] if id.nil? && multitarget == PBTargets::AllFoes
    id = @@nonUsr[type] if id.nil? && multitarget == PBTargets::AllNearFoes
    id = @@multihit[type] if id.nil? && multihit
    id = [@@physical, @@special, @@status][category][type] if id.nil?
    return false if id.nil?
    return false if hitnum > 0
    return EliteBattle.playMoveAnimation(id, scene, userindex, targetindex, 0, multihit)
  end
  #-----------------------------------------------------------------------------
end
#===============================================================================
#  Functional core for playing animations
#===============================================================================
class PokeBattle_Scene
  #-----------------------------------------------------------------------------
  #  Core to play Common Animations
  #-----------------------------------------------------------------------------
  alias pbCommonAnimation_ebdx pbCommonAnimation unless self.method_defined?(:pbCommonAnimation_ebdx)
  def pbCommonAnimation(animname, user = nil, targets = nil)
    # skips certain common animations from playing
    return false if ["Rain", "HeavyRain", "Hail", "Sandstorm", "Sun", "HarshSun", "StrongWinds", "ShadowSky", "HealthDown"].include?(animname)
    $skipMegaChange = true if animname == "MegaEvolution" && !COMMON_ANIMATIONS
    return false if ["MegaEvolution", "Shadow"].include?(animname) && !COMMON_ANIMATIONS
    # plays common animation unless specified to use custom ones
    unless COMMON_ANIMATIONS || animname.nil? || user.nil?
      symbol = (animname.upcase).to_sym
      targetindex = targets.nil? ? (user.respond_to?(:index) ? user.index : nil) : (targets.respond_to?(:index) ? targets.index : nil)
      return true if EliteBattle.playCommonAnimation(symbol, self, user.index, targetindex)
    end
    # falls back to original def
    return pbCommonAnimation_ebdx(animname, user, targets)
  end
  #-----------------------------------------------------------------------------
  #  New methods of displaying the fainting animation
  #-----------------------------------------------------------------------------
  def pbFaintBattler(pkmn)
    # reset variables
    @vector.reset
    # setup objects
    poke = @sprites["pokemon_#{pkmn.index}"]
    poke.resetParticles
    databox = @sprites["dataBox_#{pkmn.index}"]
    # play cry
    playBattlerCry(@battlers[pkmn.index])
    self.wait(pbCryFrameLength(pkmn.pokemon), true)
    # begin animation
    pbSEPlay("Pkmn faint")
    poke.showshadow = false
    poke.sprite.src_rect.height = poke.oy
    16.times do
      poke.still
      poke.sprite.src_rect.y -= 7
      poke.opacity -= 16
      databox.opacity -= 32
      self.wait(1, true)
    end
    clearMessageWindow(true)
    # try to remove low HP BGM
    setBGMLowHP(false)
    # reset src_rect
    poke.src_rect.set(0, 0, poke.bitmap.width, poke.bitmap.height)
    poke.fainted = true
    poke.charged = false
  end
  #-----------------------------------------------------------------------------
  #  Animate damage state for single battler
  #-----------------------------------------------------------------------------
  def ebDamageStateAnim(battler, effectiveness, i, state)
    sprite = @sprites["pokemon_#{battler.index}"]
    databox = @sprites["dataBox_#{battler.index}"]
    mult = (effectiveness == 0) ? 2 : ((effectiveness == 1) ? 1 : 3)
    # animate sprite
    if i < 2
      sprite.tone.all -= 255*(mult/3.0)
    elsif i < 4
      sprite.tone.all = 255*(mult/3.0)
    elsif i < 6
      sprite.visible = false
      sprite.tone.all = 0
    else
      sprite.visible = true
    end
    sprite.still
    # animate databox
    unless state
      databox.x += mult*(i < 4 ? 1 : -1)*(playerBattler?(battler) ? 1 : -1)
      databox.y -= mult*(i < 4 ? 1 : -1)*(playerBattler?(battler) ? 1 : -1)
    end
    databox.update
  end
  #-----------------------------------------------------------------------------
  #  New Pokemon damage animations
  #-----------------------------------------------------------------------------
  def pbHitAndHPLossAnimation(targets)
    @briefMessage = false
    self.afterAnim = false
    # wait
    self.wait(4, true)
    # prepare soundeffect
    effect = []
    indexes = []
    for t in targets
      effect.push(t[2])
      indexes.push(t[0].index)
      @sprites["dataBox_#{t[0].index}"].damage
      @sprites["dataBox_#{t[0].index}"].animateHP(t[1], t[0].hp)
    end
    # play damage SE
    case effect.max
    when 0; pbSEPlay("Battle damage normal")
    when 1; pbSEPlay("Battle damage weak")
    when 2; pbSEPlay("Battle damage super")
    end
    # begin animation
    for k in 1..(effect.max == 2 ? 3 : 2)
      for i in 0...8
        for t in targets
          next if k > (t[2] == 2 ? 3 : 2)
          ebDamageStateAnim(t[0], t[2], i, k > 1)
        end
        # wait frames
        self.wait(1, true)
      end
    end
    # animations for triggering Substitute
    self.substitueAll(indexes)
    # try set low HP BGM music
    setBGMLowHP(false)
    setBGMLowHP(true)
    # try to process the speech
    for t in targets
      # displays opposing trainer message if Pokemon falls to low HP
      hpchange = t[0].hp - t[1]
      handled = pbTrainerBattleSpeech(playerBattler?(t[0]) ? "damage" : "damageOpp") if hpchange.abs/t[0].totalhp.to_f >= 0.6 && hpchange < 0
      handled = pbTrainerBattleSpeech(playerBattler?(t[0]) ? "resist" : "resistOpp") if hpchange.abs/t[0].totalhp.to_f <= 0.1 && hpchange < 0 && !handled
      handled = pbTrainerBattleSpeech(playerBattler?(t[0]) ? "lowHP" : "lowHPOpp") if t[0].hp > 0 && (t[0].hp < t[0].totalhp*0.3) && !handled
      handled = pbTrainerBattleSpeech(playerBattler?(t[0]) ? "halfHP" : "halfHPOpp") if t[0].hp > 0 && (t[0].hp < t[0].totalhp*0.5) && !handled
      break if handled
    end
  end
  #-----------------------------------------------------------------------------
  #  Legacy Pokemon damage animation
  #-----------------------------------------------------------------------------
  def pbDamageAnimation(battler, effectiveness = 0)
    # setup variables
    @briefmessage = false
    self.afterAnim = false
    self.wait(4, true)
    # play damage SE
    case effectiveness
    when 0; pbSEPlay("Battle damage normal")
    when 1; pbSEPlay("Battle damage weak")
    when 2; pbSEPlay("Battle damage super")
    end
    # begin animation
    once = false
    @sprites["dataBox_#{battler.index}"].damage
    (effectiveness == 2 ? 3 : 2).times do
      for i in 0...8
        ebDamageStateAnim(battler, effectiveness, i, once)
        self.wait(1, true)
      end
      once = true
    end
    # animations for triggering Substitute
    self.substitueAll([battler.index])
  end
  #-----------------------------------------------------------------------------
  #  Legacy HP bar damage animation
  #-----------------------------------------------------------------------------
  def pbHPChanged(battler, oldhp, anim = false)
    # set up variables
    databox = @sprites["dataBox_#{battler.index}"]
    @briefmessage = false
    hpchange = battler.hp - oldhp
    # show common animation for health change
    if anim && @battle.battlescene
      if battler.hp > oldhp
        pbCommonAnimation("HealthUp", battler, nil)
      elsif battler.hp < oldhp
        pbCommonAnimation("HealthDown", battler, nil)
      end
    end
    databox.animateHP(oldhp, battler.hp)
    while databox.animatingHP
      databox.update
      self.wait(1, true)
    end
    # try set low HP BGM music
    setBGMLowHP(false)
    setBGMLowHP(true)
    # displays opposing trainer message if Pokemon falls to low HP
    handled = pbTrainerBattleSpeech(playerBattler?(battler) ? "damage" : "damageOpp") if hpchange.abs/battler.totalhp.to_f >= 0.6 && hpchange < 0
    handled = pbTrainerBattleSpeech(playerBattler?(battler) ? "resist" : "resistOpp") if hpchange.abs/battler.totalhp.to_f <= 0.1 && hpchange < 0 && !handled
    handled = pbTrainerBattleSpeech(playerBattler?(battler) ? "lowHP" : "lowHPOpp") if battler.hp > 0 && (battler.hp < battler.totalhp*0.3) && !handled
    handled = pbTrainerBattleSpeech(playerBattler?(battler) ? "halfHP" : "halfHPOpp") if battler.hp > 0 && (battler.hp < battler.totalhp*0.5) && !handled
    # reset vector if necessary
    @vector.reset if battler.hp <= 0
  end
  #-----------------------------------------------------------------------------
  #  override the change form function
  #-----------------------------------------------------------------------------
  alias pbChangePokemon_ebdx pbChangePokemon unless self.method_defined?(:pbChangePokemon_ebdx)
  def pbChangePokemon(index, pokemon)
    return $skipMegaChange = false if $skipMegaChange
    ndx = index.respond_to?("index") ? index.index : index
    handled = EliteBattle.playCommonAnimation(:FORMCHANGE, self, ndx, ndx, 0, pokemon)
    return pbChangePokemon_ebdx(index, pokemon) if !handled
  end
  #-----------------------------------------------------------------------------
  #  function to replace battler sprite with substitute sprite
  #-----------------------------------------------------------------------------
  def setSubstitute(index, set = true)
    EliteBattle.playCommonAnimation(:SUBSTITUTE, self, 0, 0, 0, [index], set)
  end
  #-----------------------------------------------------------------------------
  #  function to replace battler sprite with substitute sprite
  #-----------------------------------------------------------------------------
  def substitueAll(targets)
    # check if should perform substitution animation
    new = []
    for t in targets
      pkmn = @battle.battlers[t]
      new.push(t) if (pkmn.effects[PBEffects::Substitute] > 0 && !@sprites["pokemon_#{pkmn.index}"].isSub) ||
                    (pkmn.effects[PBEffects::Substitute] == 0 && @sprites["pokemon_#{pkmn.index}"].isSub)
    end
    return unless new.length > 0
    EliteBattle.playCommonAnimation(:SUBSTITUTE, self, 0, 0, 0, new, false)
  end
  #-----------------------------------------------------------------------------
  #  New EXP bar animations
  #-----------------------------------------------------------------------------
  def pbEXPBar(battler, startExp, endExp, tempExp1, tempExp2)
    return if !battler
    # calculate EXP animation
    dataBox = @sprites["dataBox_#{battler.index}"]
    dataBox.refreshExpLevel
    expRange      = endExp - startExp
    startExpLevel = expRange == 0 ? 0 : (tempExp1 - startExp)*dataBox.expBarWidth/expRange
    endExpLevel   = expRange == 0 ? 0 : (tempExp2 - startExp)*dataBox.expBarWidth/expRange
    # trigger animation
    pbSEPlay("EBDX/Experience Gain")
    dataBox.animateEXP(startExpLevel, endExpLevel)
    i = 0
    while dataBox.animatingEXP || i < 4
      dataBox.update if dataBox.animatingEXP
      self.wait(1, true); i += 1
    end
    # end animation
    Audio.se_stop
    self.wait(8, true)
  end
  #-----------------------------------------------------------------------------
  #  Play ME when leveling up
  #-----------------------------------------------------------------------------
  alias pbLevelUp_ebdx pbLevelUp unless self.method_defined?(:pbLevelUp_ebdx)
  def pbLevelUp(*args)
    pbMEPlay("EBDX/Level Up", 80)
    pbLevelUp_ebdx(*args)
  end
  #-----------------------------------------------------------------------------
end
