#===============================================================================
#  Battle Scene processing start
#===============================================================================
class PokeBattle_Scene
  # additional scene attributes
  attr_accessor :idleTimer, :safaribattle, :vector
  attr_accessor :sendingOut, :afterAnim, :lowHPBGM
  attr_accessor :briefmessage, :sprites, :introdone
  attr_accessor :playerLineUp, :opponentLineUp
  attr_reader :viewport, :dexview, :battle, :battlers, :commandWindow, :fightWindow, :bagWindow
  attr_reader :smTrainerSequence, :smSpeciesSequence, :firstsendout
  def pbDisposeSprites
    pbDisposeSpriteHash(@sprites)
    @bagWindow.dispose
    @commandWindow.dispose
    @fightWindow.dispose
    @targetWindow.dispose
  end
  #-----------------------------------------------------------------------------
  #  Initialization of the battle scene
  #-----------------------------------------------------------------------------
  def pbStartBattle(battle)
    @battle = battle
    @battlers = battle.battlers
    # checks whether to display integrated VS sequence
    @integratedVS = @battle.opponent && @battle.opponent.length < 2 && !EliteBattle.get(:smAnim) && EliteBattle.canTransition?("integratedVS", @battle.opponent[0].trainertype, @battle.opponent[0].name, @battle.opponent[0].partyID)
    # check if minor trainer transition is applied
    @minorAnimation = @battle.opponent && !@integratedVS && EliteBattle.canTransition?("minorTrainer", @battle.opponent[0].trainertype, @battle.opponent[0].name, @battle.opponent[0].partyID)
    # setup for initial vector configuration
    vec = EliteBattle.getVector(:ENEMY)
    if @battle.opponent && @minorAnimation
      vec = EliteBattle.getVector(:MAIN, @battle)
      vec[0] -= Graphics.width/2
    end
    @vector = Vector.new(*vec)
    @vector.battle = @battle
    # setup for all the necessary variable
    @firstsendout = true
    @lastcmd = [0, 0, 0, 0]
    @lastmove = [0, 0, 0, 0]
    @orgPos = nil
    @shadowAngle = 60
    @idleTimer = 0
    @idleSpeed = [40, 0]
    @animationCount = 1
    @showingplayer = true
    @showingenemy = true
    @briefmessage = false
    @lowHPBGM = false
    @introdone = false
    @dataBoxesHidden = false
    @sprites = {}
    @lastCmd = Array.new(@battlers.length,0)
    @lastMove = Array.new(@battlers.length,0)
    # viewport setup
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    # dex viewport
    @dexview = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @dexview.z = 99999
    # sets up message sprite viewport
    @msgview = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @msgview.z = 99999
    # Adjust player's side for screen size
    @traineryoffset = (Graphics.height - 320)
    # Adjust foe's side for screen size
    @foeyoffset = (@traineryoffset*3/4).floor
    # special Sun & Moon styled VS sequences
    if EliteBattle.get(:smAnim) && @battle.opponent
      @smTrainerSequence = SunMoonBattleTransitions.new(@viewport, @msgview, self, @battle.opponent[0])
    end
    if EliteBattle.get(:smAnim) && !@battle.opponent && @battle.pbParty(1).length == 1
      @smSpeciesSequence = SunMoonSpeciesTransitions.new(@viewport, @msgview, self, @battle.pbParty(1)[0])
    end
    # integrated VS sequence
    if @integratedVS
      @integratedVSSequence = IntegratedVSSequence.new(@viewport, self, @battle.opponent[0].trainertype)
    end
    # loads in new battle background
    loadBackdrop
    # configures all the UI elements
    self.loadUIElements
    initializeSprites
    pbSetMessageMode(false)
    # start initial transition
    startSceneAnimation
  end
  #-----------------------------------------------------------------------------
  #  Initialize all battle sprites
  #-----------------------------------------------------------------------------
  def initializeSprites
    # initializes player sprite
    @battle.player.each_with_index do |pl, i|
      plfile = pbPlayerSpriteBackFile(pl.trainertype)
      pbAddSprite("player_#{i}", 0, 0, plfile, @viewport)
      @sprites["player_#{i}"].x = 40 + i*100
      @sprites["player_#{i}"].y = Graphics.height - @sprites["player_#{i}"].bitmap.height
      @sprites["player_#{i}"].z = 50
      @sprites["player_#{i}"].opacity = 0
      @sprites["player_#{i}"].src_rect.width /= 4
    end
    # initializes trainer sprite
    if @battle.opponent
      @battle.opponent.each_with_index do |t, i|
        trfile = pbTrainerSpriteFile(t.trainertype)
        @sprites["trainer_#{i}"] = DynamicTrainerSprite.new(@battle.doublebattle?, -1, @viewport, @battle.opponent.length > 1, t)
        @sprites["trainer_#{i}"].setTrainerBitmap
        @sprites["trainer_#{i}"].z = (@minorAnimation || @integratedVS) ? 100 : @sprites["battlebg"].battler(i*2 + 1).z
        @sprites["trainer_#{i}"].shadow.z = 98 if @minorAnimation
        @sprites["trainer_#{i}"].tone = Tone.new(-255, -255, -255, -255)
      end
    end
    # initializes Pokemon sprites
    @battlers.each_with_index do |b, i|
      next if !b
      @sprites["pokemon_#{i}"] = DynamicPokemonSprite.new(@battle.doublebattle?, i, @viewport, @battle)
      @sprites["pokemon_#{i}"].z = @sprites["battlebg"].battler(i).z
      @sprites["pokemon_#{i}"].index = i
    end
    # assign bitmaps for wild battlers
    loadWildBitmaps
  end
  #-----------------------------------------------------------------------------
  #  apply bitmaps for wild battlers
  #-----------------------------------------------------------------------------
  def loadWildBitmaps
    if @battle.wildBattle?
      # wild battle bitmaps
      @battle.pbParty(1).each_with_index do |pkmn, i|
        next if !@sprites["pokemon_#{i*2 + 1}"]
        @sprites["pokemon_#{i*2 + 1}"].setPokemonBitmap(pkmn, false)
        @sprites["pokemon_#{i*2 + 1}"].tone = Tone.new(-255, -255, -255, -255)
        @sprites["pokemon_#{i*2 + 1}"].visible = true
      end
      # renders databoxes
      for m in 0...@battle.pbParty(1).length
        next if !@sprites["dataBox_#{m*2 + 1}"]
        @sprites["dataBox_#{m*2 + 1}"].render
      end
    end
    # initialize Player battler 0 when follower enabled
    if !EliteBattle.follower(@battle).nil?
      pkmn = @battlers[EliteBattle.follower(@battle)].pokemon
      @sprites["pokemon_#{EliteBattle.follower(@battle)}"].setPokemonBitmap(pkmn, true)
      @sprites["pokemon_#{EliteBattle.follower(@battle)}"].tone = Tone.new(-255, -255, -255, -255)
      @sprites["pokemon_#{EliteBattle.follower(@battle)}"].visible = true
      @sprites["dataBox_#{EliteBattle.follower(@battle)}"].render
    end
  end
  #-----------------------------------------------------------------------------
  #  start the initial scene animation
  #-----------------------------------------------------------------------------
  def startSceneAnimation
    # Position for initial transition
    black = Sprite.new(@viewport)
    black.z = 99999
    black.full_rect(Color.black)
    # additional player sprite positioning for the Safari Zone
    if @safaribattle
      for i in 0...@battle.player.length
        @sprites["player_#{i}"].x -= 240
        @sprites["player_#{i}"].y += 120
      end
    end
    # Play battle entrance, register next vector position
    vector = EliteBattle.getVector(:MAIN, @battle)
    @vector.force
    @vector.set(vector)
    @vector.inc = 0.1
    # fade necessary sprites into scene
    for i in 0...22
      # player sprite for Safari Zone
      if @safaribattle
        for k in 0...@battle.player.length
          @sprites["player_#{k}"].opacity += 25.5
          @sprites["player_#{k}"].zoom_x = @vector.zoom1
          @sprites["player_#{k}"].zoom_y = @vector.zoom1
          @sprites["player_#{k}"].x += 10
          @sprites["player_#{k}"].y -= 5
        end
      end
      # opposing trainer sprites
      if @battle.opponent && i > 11
        for t in 0...@battle.opponent.length
          @sprites["trainer_#{t}"].tone.all += 255*0.05 if @sprites["trainer_#{t}"].tone.all < 0
          @sprites["trainer_#{t}"].tone.gray += 255*0.05 if @sprites["trainer_#{t}"].tone.gray < 0
        end
        # fade in player battler when follower is out
        if !EliteBattle.follower(@battle).nil?
          @sprites["pokemon_#{EliteBattle.follower(@battle)}"].tone.all += 255*0.1 if @sprites["pokemon_#{EliteBattle.follower(@battle)}"].tone.all < 0
          @sprites["pokemon_#{EliteBattle.follower(@battle)}"].tone.gray += 255*0.1 if @sprites["pokemon_#{EliteBattle.follower(@battle)}"].tone.gray < 0
        end
      end
      # fades screen from black
      black.opacity -= 32 if black.opacity>0
      self.wait(1, true)
    end
    @vector.inc = 0.2
    # party line up animation
    if @battle.trainerBattle? && !EliteBattle.get(:smAnim)
      pbShowPartyLineup(0)
      pbShowPartyLineup(1)
    end
    # show databox for follower
    if !EliteBattle.follower(@battle).nil?
      @sprites["dataBox_#{EliteBattle.follower(@battle)}"].appear if !EliteBattle.get(:smAnim)
    end
    # Play cry for wild Pokémon
    if @battle.wildBattle?
      @battle.pbParty(1).each_with_index do |pkmn, i|
        break if EliteBattle.get(:smAnim)
        playBattlerCry(@battlers[i*2 + 1])
      end
      pbShowPartyLineup(0) if SHOW_LINEUP_WILD && !EliteBattle.get(:smAnim)
      # makes databoxes for wild battles appear
      for m in 0...@battle.pbParty(1).length
        next if !@sprites["dataBox_#{m*2 + 1}"]
        @sprites["dataBox_#{m*2 + 1}"].appear if !EliteBattle.get(:smAnim)
      end
      # fades tone from black
      for i in 0...16
        for m in 0...@battle.pbParty(1).length
          next if !@sprites["pokemon_#{m*2 + 1}"]
          @sprites["pokemon_#{m*2 + 1}"].tone.all += 255*0.1 if @sprites["pokemon_#{m*2 + 1}"].tone.all < 0
          @sprites["pokemon_#{m*2 + 1}"].tone.gray += 255*0.1 if @sprites["pokemon_#{m*2 + 1}"].tone.gray < 0
        end
        # fade in player battler when follower is out
        if !EliteBattle.follower(@battle).nil?
          @sprites["pokemon_#{EliteBattle.follower(@battle)}"].tone.all += 255*0.1 if @sprites["pokemon_#{EliteBattle.follower(@battle)}"].tone.all < 0
          @sprites["pokemon_#{EliteBattle.follower(@battle)}"].tone.gray += 255*0.1 if @sprites["pokemon_#{EliteBattle.follower(@battle)}"].tone.gray < 0
        end
        self.wait(1, true)
      end
    end
    # for trainer sprites
    if @battle.trainerBattle?
      # calculates the number of frames of the sprite
      frames = []
      for t in 0...@battle.opponent.length
        frames.push(@sprites["trainer_#{t}"].totalFrames*2)
      end
      # animates through frames
      for i in 0...frames.max
        for t in 0...@battle.opponent.length
          @sprites["trainer_#{t}"].play
          # fades tone from black
          @sprites["trainer_#{t}"].tone.all += 255*0.1 if @sprites["trainer_#{t}"].tone.all < 0
          @sprites["trainer_#{t}"].tone.gray += 255*0.1 if @sprites["trainer_#{t}"].tone.gray < 0
        end
        self.wait(1, true)
      end
      @integratedVSSequence.start if @integratedVSSequence
    else
      # show shiny animation for wild Pokémon
      @battle.pbParty(1).each_with_index do |pkmn, i|
        next if !@sprites["pokemon_#{i*2 + 1}"]
        @sprites["dataBox_#{i*2 + 1}"].inposition = true
        battler = @battlers[i*2 + 1]
        if shinyBattler?(battler) && @battle.battlescene && !EliteBattle.get(:smAnim)
          pbCommonAnimation("Shiny", battler, nil)
        end
      end
    end
    # animates Sun/Moon styled VS sequence for trainer
    @smTrainerSequence.start if @smTrainerSequence
    # animates special VS sequence for species
    @smSpeciesSequence.start if @smSpeciesSequence
  end
  #-----------------------------------------------------------------------------
  #  Applies Aura stat raise like Totem Pokemon
  #-----------------------------------------------------------------------------
  def raiseSpeciesStats
    # cancels if opposing trainer or double wild battle
    return if @battle.opponent || @battle.pbParty(1).length > 1
    data = EliteBattle.get(:nextBattleData)
    # cancels if no stat raise queued
    return if data.nil? || !data.is_a?(Hash) || !data.has_key?(:STAT_RAISE) || !data[:STAT_RAISE].is_a?(Array)
    battler = @battlers[1]; s = nil; succeed = false; avg = 0
    # iterates through each stat raise
    for i in 0...data[:STAT_RAISE].length
      next if i%2 == 1
      stat = getConst(PBStats, data[:STAT_RAISE][i])
      # failsafe to check whether stat raise can be applied
      next if stat.nil? || (!data[:STAT_RAISE][i+1] && !data[:STAT_RAISE][i+1].is_a?(Numeric))
      # gets proper id and value for stat raise
      s = PBStats.getName(stat) if data[:STAT_RAISE].length <= 2
      inc = data[:STAT_RAISE][i+1]; avg += inc
      # applies stat raise
      battler.pbRaiseStatStageBasic(stat, inc)
      succeed = true
    end
    # failsafe for stat raise
    return if !succeed
    # shows Aura Flare animation
    clearMessageWindow(true)
    EliteBattle.playCommonAnimation(:AURAFLARE, self, battler.index, battler.index, 0)
    rsm = [_INTL("increased"), _INTL("rose sharply"), _INTL("increased drastically")]
    j = (2*avg)/data[:STAT_RAISE].length - 1; j = 0 if j < 0; j = 2 if j > 2
    # displays message of stat(s) raised
    pbDisplayPausedMessage(_INTL("{1}'s Aura flared to life!\nIts {2} {3}!", battler.pokemon.name, (s.nil? ? "stats" : s), rsm[j]))
    # resets scene
    clearMessageWindow(true); @vector.reset
    self.wait(16, true)
  end
  #-----------------------------------------------------------------------------
  #  updates scene graphics
  #-----------------------------------------------------------------------------
  def pbGraphicsUpdate
    Graphics.update
  end
  def pbUpdate(cw = nil)
    pbGraphicsUpdate
    pbInputUpdate
    pbFrameUpdate(cw)
  end
  #-----------------------------------------------------------------------------
  #  reset scene parameters
  #-----------------------------------------------------------------------------
  def pbResetParams
    @vector.reset
    @orgPos = nil
    @vector.inc = 0.2
    @vector.lock
  end
  #-----------------------------------------------------------------------------
  #  toggle data box visibility
  #-----------------------------------------------------------------------------
  def pbHideAllDataboxes(side = nil)
    return if @dataBoxesHidden
    # remove databox visibility
    @battlers.each_with_index do |b, i|
      next if !b || (!side.nil? && i%2 != side)
      @sprites["dataBox_#{i}"].visible = false
    end
    @dataBoxesHidden = true
  end
  def pbShowAllDataboxes(side = nil)
    # reset databox visibility
    @battlers.each_with_index do |b, i|
      next if !b || (!side.nil? && i%2 != side)
      @sprites["dataBox_#{i}"].visible = true
    end
    @dataBoxesHidden = false
  end
  #-----------------------------------------------------------------------------
  #  get victory themes
  #-----------------------------------------------------------------------------
  def pbWildBattleSuccess
    bgm = "EBDX/Victory Against Wild"
    bgm = $PokemonGlobal.nextBattleME.clone if $PokemonGlobal.nextBattleME
    if !@battle.opponent
      s = EliteBattle.getData(@battlers[1].species, PBSpecies, :VICTORYTHEME, (@battlers[1].form rescue 0))
      bgm = s if !s.nil?
    end
    pbBGMPlay(bgm)
  end
  def pbTrainerBattleSuccess
    bgm = "EBDX/Victory Against Trainer"
    bgm = $PokemonGlobal.nextBattleME.clone if $PokemonGlobal.nextBattleME
    if @battle.opponent
      s = EliteBattle.getTrainerData(@battle.opponent[0].trainertype, :VICTORYTHEME, @battle.opponent[0])
      bgm = s if !s.nil?
    end
    pbBGMPlay(bgm)
  end
  #-----------------------------------------------------------------------------
  #  handle the sending out animations
  #-----------------------------------------------------------------------------
  def pbSendOutBattlers(sendOuts, startBattle = false)
    return if sendOuts.length == 0
    @briefMessage = false
    # decide which sendout animation to play
    if @battle.opposes?(sendOuts[0][0])
      trainerBattlerSendOut(sendOuts, startBattle)
    else
      playerBattlerSendOut(sendOuts, startBattle)
    end
    @vector.reset
    self.wait(20, true)
    # try set low HP BGM music
    self.setBGMLowHP(true)
    @sendingOut = false
  end
  #-----------------------------------------------------------------------------
  #  End of battle processing
  #-----------------------------------------------------------------------------
  alias pbEndBattle_ebdx pbEndBattle unless self.method_defined?(:pbEndBattle_ebdx)
  def pbEndBattle(*args)
    EliteBattle.set(:nextVectors, [])
    $disableRandomizer = false
    return pbEndBattle_ebdx(*args)
  end
  #-----------------------------------------------------------------------------
end
# override to disable spriteset disposal
def pbSceneStandby
  Graphics.frame_reset; yield
  $scene.disposeSpritesets if $scene && $scene.is_a?(Scene_Map)
  $scene.createSpritesets if $scene && $scene.is_a?(Scene_Map)
end
