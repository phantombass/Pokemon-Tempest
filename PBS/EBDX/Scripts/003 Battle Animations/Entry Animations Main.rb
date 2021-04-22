#===============================================================================
#  Main battle animation processing
#===============================================================================
def pbBattleAnimation(bgm = nil, battletype = 0, foe = nil)
  # gets trainer ID
  trainerid = (foe[0].trainertype rescue -1)
  # sets up starting variables
  handled = false
  playingBGS = nil
  playingBGM = nil
  # memorizes currently playing BGM and BGS
  if $game_system && $game_system.is_a?(Game_System)
    playingBGS = $game_system.getPlayingBGS
    playingBGM = $game_system.getPlayingBGM
    $game_system.bgm_pause
    $game_system.bgs_pause
  end
  # stops currently playing ME
  pbMEFade(0.25)
  pbWait(8)
  pbMEStop
  # checks if battle BGM is registered for species or trainer
  mapBGM = EliteBattle.getData($game_map.map_id, PBMap, :BGM)
  bgm = mapBGM if !mapBGM.nil?
  pkmnBGM = EliteBattle.nextBattleBGM?(EliteBattle.get(:wildSpecies), EliteBattle.get(:wildForm), 0, PBSpecies)
  bgm = pkmnBGM if !pkmnBGM.nil? && trainerid < 0
  trBGM = trainerid >= 0 ? EliteBattle.nextBattleBGM?(trainerid, foe[0].name, foe[0].partyID, PBTrainers) : nil
  bgm = trBGM if !trBGM.nil?
  # plays battle BGM
  if bgm
    pbBGMPlay(bgm)
  else
    pbBGMPlay(pbGetWildBattleBGM(0))
  end
  # initialize viewport
  viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
  viewport.z = 99999
  # flashes viewport to gray a few times.
  viewport.color = Color.white
  2.times do
    viewport.color.alpha = 0
    for i in 0...16
      viewport.color.alpha += 32 * (i < 8 ? 1 : -1)
      pbWait(1)
    end
  end
  # checks if the Sun & Moon styled VS sequence is to be played
  EliteBattle.smTransition?(trainerid, false, (foe[0].name rescue 0), (foe[0].partyID rescue 0)) if trainerid >= 0
  EliteBattle.smTransition?(EliteBattle.get(:wildSpecies), true, EliteBattle.get(:wildForm)) if trainerid < 0
  $timenow = Time.now
  # plays custom transition if applicable
  handled = EliteBattle.playNextTransition(viewport, trainerid)
  # plays basic trainer intro animation
  if !handled && trainerid >= 0
    handled = EliteBattle_BasicTrainerAnimations.new(viewport, battletype, foe)
  end
  if !handled
    handled = EliteBattle_BasicWildAnimations.new(viewport)
  end
  #viewport.color = Color.new(0, 0, 0, 0)
  # battle processing
  #pbPushFade
  yield if block_given?
  #pbPopFade
  # resumes memorized BGM and BGS
  if $game_system && $game_system.is_a?(Game_System)
    $game_system.bgm_resume(playingBGM)
    $game_system.bgs_resume(playingBGS)
  end
  # resets cache variables
  $PokemonGlobal.nextBattleBGM = nil
  $PokemonGlobal.nextBattleME = nil
  $PokemonGlobal.nextBattleBack = nil
  $PokemonEncounters.clearStepCount
  # fades in viewport
  for j in 0..17
    viewport.color = Color.new(0, 0, 0, (17-j)*15)
    Graphics.update
    Input.update
    pbUpdateSceneMap
  end
  viewport.dispose
end
