#=======================
#Various Screen Changes
#=======================

class PokemonSave_Scene
  def pbStartScreen
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @sprites={}
    totalsec = Graphics.frame_count / Graphics.frame_rate
    hour = totalsec / 60 / 60
    min = totalsec / 60 % 60
    mapname=$game_map.name
    textColor = ["7FE00000","463F0000","7FE00000"][$Trainer.gender]
    locationColor = "90F090,000000"   # green
    loctext=_INTL("<ac><c3={1}>{2}</c3></ac>",locationColor,mapname)
    loctext+=_INTL("Player<r><c2={1}>{2}</c2><br>",textColor,$Trainer.name)
    if hour>0
      loctext+=_INTL("Time<r><c2={1}>{2}h {3}m</c2><br>",textColor,hour,min)
    else
      loctext+=_INTL("Time<r><c2={1}>{2}m</c2><br>",textColor,min)
    end
    loctext+=_INTL("Chapter<r><c2={1}>{2}</c2><br>",textColor,$Trainer.badge_count)
    if $Trainer.has_pokedex
      loctext+=_INTL("Pokédex<r><c2={1}>{2}/{3}</c2><br>",textColor,$Trainer.pokedex.owned_count,$Trainer.pokedex.seen_count)
    end
    if $game_switches[Readouts::Readout]
      loctext+=_INTL("Readouts<r><c2={1}>{2}</c2>",textColor,$game_variables[Readouts::Count])
    end
    @sprites["locwindow"]=Window_AdvancedTextPokemon.new(loctext)
    @sprites["locwindow"].viewport=@viewport
    @sprites["locwindow"].x=0
    @sprites["locwindow"].y=0
    @sprites["locwindow"].width=228 if @sprites["locwindow"].width<228
    @sprites["locwindow"].visible=true
  end
end

class PokemonPauseMenu_Scene
  def pbStartScene
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    @sprites["cmdwindow"] = Window_CommandPokemon.new([])
    @sprites["cmdwindow"].visible = false
    @sprites["cmdwindow"].viewport = @viewport
    @sprites["infowindow"] = Window_UnformattedTextPokemon.newWithSize("",0,0,32,32,@viewport)
    @sprites["infowindow"].visible = false
    @sprites["helpwindow"] = Window_UnformattedTextPokemon.newWithSize("",0,0,32,32,@viewport)
    @sprites["helpwindow"].visible = false
    @sprites["levelcapwindow"] = Window_UnformattedTextPokemon.newWithSize("Level Cap: #{$game_variables[LvlCap::LevelCap]}",0,0,200,64,@viewport)
    @sprites["levelcapwindow"].visible = true
    @infostate = false
    @helpstate = false
    $viewport4 = @viewport
    pbSEPlay("GUI menu open")
  end

  def pbShowInfo(text)
    @sprites["infowindow"].resizeToFit(text,Graphics.height)
    @sprites["infowindow"].text    = text
    @sprites["infowindow"].visible = true
    @infostate = true
  end

  def pbShowHelp(text)
    @sprites["helpwindow"].resizeToFit(text,Graphics.height)
    @sprites["helpwindow"].text    = text
    @sprites["helpwindow"].visible = true
    pbBottomLeft(@sprites["helpwindow"])
    @helpstate = true
  end

  def pbShowMenu
    @sprites["cmdwindow"].visible = true
    @sprites["infowindow"].visible = @infostate
    @sprites["helpwindow"].visible = @helpstate
  end

  def pbHideMenu
    @sprites["cmdwindow"].visible = false
    @sprites["infowindow"].visible = false
    @sprites["helpwindow"].visible = false
  end

  def pbShowCommands(commands)
    ret = -1
    cmdwindow = @sprites["cmdwindow"]
    cmdwindow.commands = commands
    cmdwindow.index    = $PokemonTemp.menuLastChoice
    cmdwindow.resizeToFit(commands)
    cmdwindow.x        = Graphics.width-cmdwindow.width
    cmdwindow.y        = 0
    cmdwindow.visible  = true
    loop do
      cmdwindow.update
      Graphics.update
      Input.update
      pbUpdateSceneMap
      if Input.trigger?(Input::BACK)
        ret = -1
        break
      elsif Input.trigger?(Input::USE)
        ret = cmdwindow.index
        $PokemonTemp.menuLastChoice = ret
        break
      end
    end
    return ret
  end

  def pbEndScene
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end

  def pbRefresh; end
end

class PokemonPauseMenu
  def initialize(scene)
    @scene = scene
  end

  def pbShowMenu
    @scene.pbRefresh
    @scene.pbShowMenu
  end

  def pbStartPokemonMenu
    if !$Trainer
      if $DEBUG
        pbMessage(_INTL("The player trainer was not defined, so the pause menu can't be displayed."))
        pbMessage(_INTL("Please see the documentation to learn how to set up the trainer player."))
      end
      return
    end
    @scene.pbStartScene
    endscene = true
    commands = []
    cmdPokedex  = -1
    cmdPokemon  = -1
    cmdBag      = -1
    cmdTrainer  = -1
    cmdSave     = -1
    cmdOption   = -1
    cmdWeather  = -1
    cmdQuest    = -1
    cmdDebug    = -1
    cmdQuit     = -1
    cmdEndGame  = -1
    if $Trainer.has_pokedex && $Trainer.pokedex.accessible_dexes.length > 0
      commands[cmdPokedex = commands.length] = _INTL("Pokédex")
    end
    commands[cmdPokemon = commands.length]   = _INTL("Pokémon") if $Trainer.party_count > 0
    commands[cmdBag = commands.length]       = _INTL("Bag") if !pbInBugContest?
    commands[cmdWeather = commands.length]  = _INTL("Weather Reader") if $game_switches[400]
    commands[cmdQuest = commands.length]  = _INTL("Mission Log") if $game_switches[Mission::One]
    commands[cmdTrainer = commands.length]   = $Trainer.name
    if pbInSafari?
      if Settings::SAFARI_STEPS <= 0
        @scene.pbShowInfo(_INTL("Balls: {1}",pbSafariState.ballcount))
      else
        @scene.pbShowInfo(_INTL("Steps: {1}/{2}\nBalls: {3}",
           pbSafariState.steps, Settings::SAFARI_STEPS, pbSafariState.ballcount))
      end
      commands[cmdQuit = commands.length]    = _INTL("Quit")
    elsif pbInBugContest?
      if pbBugContestState.lastPokemon
        @scene.pbShowInfo(_INTL("Caught: {1}\nLevel: {2}\nBalls: {3}",
           pbBugContestState.lastPokemon.speciesName,
           pbBugContestState.lastPokemon.level,
           pbBugContestState.ballcount))
      else
        @scene.pbShowInfo(_INTL("Caught: None\nBalls: {1}",pbBugContestState.ballcount))
      end
      commands[cmdQuit = commands.length]    = _INTL("Quit Contest")
    else
      commands[cmdSave = commands.length]    = _INTL("Save") if $game_system && !$game_system.save_disabled
    end
    commands[cmdOption = commands.length]    = _INTL("Options")
    commands[cmdDebug = commands.length]     = _INTL("Debug") if $DEBUG
    commands[cmdEndGame = commands.length]   = _INTL("Quit Game")
    loop do
      command = @scene.pbShowCommands(commands)
      if cmdPokedex>=0 && command==cmdPokedex
        pbPlayDecisionSE
        if Settings::USE_CURRENT_REGION_DEX
          pbFadeOutIn {
            scene = PokemonPokedex_Scene.new
            screen = PokemonPokedexScreen.new(scene)
            screen.pbStartScreen
            @scene.pbRefresh
          }
        else
          if $Trainer.pokedex.accessible_dexes.length == 1
            $PokemonGlobal.pokedexDex = $Trainer.pokedex.accessible_dexes[0]
            pbFadeOutIn {
              scene = PokemonPokedex_Scene.new
              screen = PokemonPokedexScreen.new(scene)
              screen.pbStartScreen
              @scene.pbRefresh
            }
          else
            pbFadeOutIn {
              scene = PokemonPokedexMenu_Scene.new
              screen = PokemonPokedexMenuScreen.new(scene)
              screen.pbStartScreen
              @scene.pbRefresh
            }
          end
        end
      elsif cmdPokemon>=0 && command==cmdPokemon
        pbPlayDecisionSE
        hiddenmove = nil
        pbFadeOutIn {
          sscene = PokemonParty_Scene.new
          sscreen = PokemonPartyScreen.new(sscene,$Trainer.party)
          hiddenmove = sscreen.pbPokemonScreen
          (hiddenmove) ? @scene.pbEndScene : @scene.pbRefresh
        }
        if hiddenmove
          $game_temp.in_menu = false
          pbUseHiddenMove(hiddenmove[0],hiddenmove[1])
          return
        end
      elsif cmdBag>=0 && command==cmdBag
        pbPlayDecisionSE
        item = nil
        pbFadeOutIn {
          scene = PokemonBag_Scene.new
          screen = PokemonBagScreen.new(scene,$PokemonBag)
          item = screen.pbStartScreen
          (item) ? @scene.pbEndScene : @scene.pbRefresh
        }
        if item
          $game_temp.in_menu = false
          pbUseKeyItemInField(item)
          return
        end
      elsif cmdWeather>=0 && command==cmdWeather
        pbPlayDecisionSE
        pbFadeOutIn {
          scene = PokemonWeather_Scene.new
          screen = PokemonWeatherScreen.new(scene)
          screen.pbStartScreen
          @scene.pbRefresh
        }
      elsif cmdQuest>=0 && command==cmdQuest
        pbPlayDecisionSE
        pbFadeOutIn {
          pbViewQuests
          @scene.pbRefresh
        }
      elsif cmdTrainer>=0 && command==cmdTrainer
        pbPlayDecisionSE
        pbFadeOutIn {
          scene = PokemonTrainerCard_Scene.new
          screen = PokemonTrainerCardScreen.new(scene)
          screen.pbStartScreen
          @scene.pbRefresh
        }
      elsif cmdQuit>=0 && command==cmdQuit
        @scene.pbHideMenu
        if pbInSafari?
          if pbConfirmMessage(_INTL("Would you like to leave the Safari Game right now?"))
            @scene.pbEndScene
            pbSafariState.decision = 1
            pbSafariState.pbGoToStart
            return
          else
            pbShowMenu
          end
        else
          if pbConfirmMessage(_INTL("Would you like to end the Contest now?"))
            @scene.pbEndScene
            pbBugContestState.pbStartJudging
            return
          else
            pbShowMenu
          end
        end
      elsif cmdSave>=0 && command==cmdSave
        @scene.pbHideMenu
        scene = PokemonSave_Scene.new
        screen = PokemonSaveScreen.new(scene)
        if screen.pbSaveScreen
          @scene.pbEndScene
          endscene = false
          break
        else
          pbShowMenu
        end
      elsif cmdOption>=0 && command==cmdOption
        pbPlayDecisionSE
        pbFadeOutIn {
          scene = PokemonOption_Scene.new
          screen = PokemonOptionScreen.new(scene)
          screen.pbStartScreen
          pbUpdateSceneMap
          @scene.pbRefresh
        }
      elsif cmdDebug>=0 && command==cmdDebug
        pbPlayDecisionSE
        pbFadeOutIn {
          pbDebugMenu
          @scene.pbRefresh
        }
      elsif cmdEndGame>=0 && command==cmdEndGame
        @scene.pbHideMenu
        if pbConfirmMessage(_INTL("Are you sure you want to quit the game?"))
          scene = PokemonSave_Scene.new
          screen = PokemonSaveScreen.new(scene)
          if screen.pbSaveScreen
            @scene.pbEndScene
          end
          @scene.pbEndScene
          $scene = nil
          return
        else
          pbShowMenu
        end
      else
        pbPlayCloseMenuSE
        break
      end
    end
    @scene.pbEndScene if endscene
  end
end

class PokemonPokegearScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen
    commands = []
    cmdMap     = -1
    cmdPhone   = -1
    cmdJukebox = -1
    cmdBoxLink = -1
    commands[cmdMap = commands.length]     = ["map",_INTL("Map")]
    if $PokemonGlobal.phoneNumbers && $PokemonGlobal.phoneNumbers.length>0
      commands[cmdPhone = commands.length] = ["phone",_INTL("Phone")]
    end
    commands[cmdJukebox = commands.length] = ["jukebox",_INTL("Jukebox")]
    commands[cmdBoxLink = commands.length] = ["pc",_INTL("PC Box Link")] if $game_switches[115] == false
    @scene.pbStartScene(commands)
    loop do
      cmd = @scene.pbScene
      if cmd<0
        break
      elsif cmdMap>=0 && cmd==cmdMap
        pbShowMap(-1,false)
      elsif cmdPhone>=0 && cmd==cmdPhone
        pbFadeOutIn {
          PokemonPhoneScene.new.start
        }
      elsif cmdJukebox>=0 && cmd==cmdJukebox
        pbFadeOutIn {
          scene = PokemonJukebox_Scene.new
          screen = PokemonJukeboxScreen.new(scene)
          screen.pbStartScreen
        }
      elsif cmdBoxLink>=0 && cmd==cmdBoxLink
        pbPokeCenterPC
      end
    end
    @scene.pbEndScene
  end
end

class PokemonSummary_Scene
  def drawPage(page)
    if @pokemon.egg?
      drawPageOneEgg
      return
    end
    @sprites["itemicon"].item = @pokemon.item_id
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    base   = Color.new(248,248,248)
    shadow = Color.new(104,104,104)
    # Set background image
    @sprites["background"].setBitmap("Graphics/Pictures/Summary/bg_#{page}")
    imagepos=[]
    # Show the Poké Ball containing the Pokémon
    ballimage = sprintf("Graphics/Pictures/Summary/icon_ball_%s", @pokemon.poke_ball)
    if !pbResolveBitmap(ballimage)
      ballimage = sprintf("Graphics/Pictures/Summary/icon_ball_%02d", pbGetBallType(@pokemon.poke_ball))
    end
    imagepos.push([ballimage,14,60])
    # Show status/fainted/Pokérus infected icon
    status = 0
    if @pokemon.fainted?
      status = GameData::Status::DATA.keys.length / 2
    elsif @pokemon.status != :NONE
      status = GameData::Status.get(@pokemon.status).id_number
    elsif @pokemon.pokerusStage == 1
      status = GameData::Status::DATA.keys.length / 2 + 1
    end
    status -= 1
    if status >= 0
      imagepos.push(["Graphics/Pictures/statuses",124,100,0,16*status,44,16])
    end
    # Show Pokérus cured icon
    if @pokemon.pokerusStage==2
      imagepos.push([sprintf("Graphics/Pictures/Summary/icon_pokerus"),176,100])
    end
    # Show shininess star
    if @pokemon.shiny?
      imagepos.push([sprintf("Graphics/Pictures/shiny"),2,134])
    end
    # Draw all images
    pbDrawImagePositions(overlay,imagepos)
    # Write various bits of text
    pagename = [_INTL("INFO"),
                _INTL("TRAINER MEMO"),
                _INTL("SKILLS"),
                _INTL("EVs/IVs"),
                _INTL("MOVES")][page-1]
    textpos = [
       [pagename,26,10,0,base,shadow],
       [@pokemon.name,46,56,0,base,shadow],
       [@pokemon.level.to_s,46,86,0,Color.new(64,64,64),Color.new(176,176,176)],
       [_INTL("Item"),66,312,0,base,shadow]
    ]
    # Write the held item's name
    if @pokemon.hasItem?
      textpos.push([@pokemon.item.name,16,346,0,Color.new(64,64,64),Color.new(176,176,176)])
    else
      textpos.push([_INTL("None"),16,346,0,Color.new(192,200,208),Color.new(208,216,224)])
    end
    # Write the gender symbol
    if @pokemon.male?
      textpos.push([_INTL("♂"),178,56,0,Color.new(24,112,216),Color.new(136,168,208)])
    elsif @pokemon.female?
      textpos.push([_INTL("♀"),178,56,0,Color.new(248,56,32),Color.new(224,152,144)])
    end
    # Draw all text
    pbDrawTextPositions(overlay,textpos)
    # Draw the Pokémon's markings
    drawMarkings(overlay,84,292)
    # Draw page-specific information
    case page
    when 1 then drawPageOne
    when 2 then drawPageTwo
    when 3 then drawPageThree
    when 4 then drawPageFour
    when 5 then drawPageFive
    end
  end

  def drawPageFour
   overlay = @sprites["overlay"].bitmap
    base   = Color.new(248,248,248)
    shadow = Color.new(104,104,104)
    statshadows = {}
    GameData::Stat.each_main { |s| statshadows[s.id] = shadow }
    if !@pokemon.shadowPokemon? || @pokemon.heartStage > 3
      @pokemon.nature_for_stats.stat_changes.each do |change|
        statshadows[change[0]] = Color.new(136,96,72) if change[1] > 0
        statshadows[change[0]] = Color.new(64,120,152) if change[1] < 0
      end
    end
    evtable = Marshal.load(Marshal.dump(@pokemon.ev))
    ivtable = Marshal.load(Marshal.dump(@pokemon.iv))
    evHP = evtable[@pokemon.ev.keys[0]]
    ivHP = ivtable[@pokemon.iv.keys[0]]
    evAt = evtable[@pokemon.ev.keys[1]]
    ivAt = ivtable[@pokemon.iv.keys[1]]
    evDf = evtable[@pokemon.ev.keys[2]]
    ivDf = ivtable[@pokemon.iv.keys[2]]
    evSd = evtable[@pokemon.ev.keys[4]]
    ivSd = ivtable[@pokemon.iv.keys[4]]
    evSp = evtable[@pokemon.ev.keys[5]]
    ivSp = ivtable[@pokemon.iv.keys[5]]
    evSa = evtable[@pokemon.ev.keys[3]]
    ivSa = ivtable[@pokemon.iv.keys[3]]
    textpos = [
       [_INTL("HP"),292,70,2,base,statshadows[:HP]],
       [sprintf("%d/%d",evHP,ivHP),462,70,1,Color.new(64,64,64),Color.new(176,176,176)],
       [_INTL("Attack"),248,114,0,base,statshadows[:ATTACK]],
       [sprintf("%d/%d",evAt,ivAt),456,114,1,Color.new(64,64,64),Color.new(176,176,176)],
       [_INTL("Defense"),248,146,0,base,statshadows[:DEFENSE]],
       [sprintf("%d/%d",evDf,ivDf),456,146,1,Color.new(64,64,64),Color.new(176,176,176)],
       [_INTL("Sp. Atk"),248,178,0,base,statshadows[:SPECIAL_ATTACK]],
       [sprintf("%d/%d",evSa,ivSa),456,178,1,Color.new(64,64,64),Color.new(176,176,176)],
       [_INTL("Sp. Def"),248,210,0,base,statshadows[:SPECIAL_DEFENSE]],
       [sprintf("%d/%d",evSd,ivSd),456,210,1,Color.new(64,64,64),Color.new(176,176,176)],
       [_INTL("Speed"),248,242,0,base,statshadows[:SPEED]],
       [sprintf("%d/%d",evSp,ivSp),456,242,1,Color.new(64,64,64),Color.new(176,176,176)],
       [_INTL("Ability"),224,278,0,base,shadow]
    ]
    ability = @pokemon.ability
    if ability
      textpos.push([ability.name,362,278,0,Color.new(64,64,64),Color.new(176,176,176)])
      drawTextEx(overlay,224,320,282,2,ability.description,Color.new(64,64,64),Color.new(176,176,176))
    end
    pbDrawTextPositions(overlay,textpos)
  end

  def drawPageFive
    overlay = @sprites["overlay"].bitmap
    moveBase   = Color.new(64,64,64)
    moveShadow = Color.new(176,176,176)
    ppBase   = [moveBase,                # More than 1/2 of total PP
                Color.new(248,192,0),    # 1/2 of total PP or less
                Color.new(248,136,32),   # 1/4 of total PP or less
                Color.new(248,72,72)]    # Zero PP
    ppShadow = [moveShadow,             # More than 1/2 of total PP
                Color.new(144,104,0),   # 1/2 of total PP or less
                Color.new(144,72,24),   # 1/4 of total PP or less
                Color.new(136,48,48)]   # Zero PP
    @sprites["pokemon"].visible  = true
    @sprites["pokeicon"].visible = false
    @sprites["itemicon"].visible = true
    textpos  = []
    imagepos = []
    # Write move names, types and PP amounts for each known move
    yPos = 92
    for i in 0...Pokemon::MAX_MOVES
      move=@pokemon.moves[i]
      if move
        type_number = GameData::Type.get(move.type).id_number
        imagepos.push(["Graphics/Pictures/types", 248, yPos + 8, 0, type_number * 28, 64, 28])
        textpos.push([move.name,316,yPos,0,moveBase,moveShadow])
        if move.total_pp>0
          textpos.push([_INTL("PP"),342,yPos+32,0,moveBase,moveShadow])
          ppfraction = 0
          if move.pp==0;                  ppfraction = 3
          elsif move.pp*4<=move.total_pp; ppfraction = 2
          elsif move.pp*2<=move.total_pp; ppfraction = 1
          end
          textpos.push([sprintf("%d/%d",move.pp,move.total_pp),460,yPos+32,1,ppBase[ppfraction],ppShadow[ppfraction]])
        end
      else
        textpos.push(["-",316,yPos,0,moveBase,moveShadow])
        textpos.push(["--",442,yPos+32,1,moveBase,moveShadow])
      end
      yPos += 64
    end
    # Draw all text and images
    pbDrawTextPositions(overlay,textpos)
    pbDrawImagePositions(overlay,imagepos)
  end
  def drawPageFiveSelecting(move_to_learn)
    overlay = @sprites["overlay"].bitmap
    overlay.clear
    base   = Color.new(248,248,248)
    shadow = Color.new(104,104,104)
    moveBase   = Color.new(64,64,64)
    moveShadow = Color.new(176,176,176)
    ppBase   = [moveBase,                # More than 1/2 of total PP
                Color.new(248,192,0),    # 1/2 of total PP or less
                Color.new(248,136,32),   # 1/4 of total PP or less
                Color.new(248,72,72)]    # Zero PP
    ppShadow = [moveShadow,             # More than 1/2 of total PP
                Color.new(144,104,0),   # 1/2 of total PP or less
                Color.new(144,72,24),   # 1/4 of total PP or less
                Color.new(136,48,48)]   # Zero PP
    # Set background image
    if move_to_learn
      @sprites["background"].setBitmap("Graphics/Pictures/Summary/bg_learnmove")
    else
      @sprites["background"].setBitmap("Graphics/Pictures/Summary/bg_movedetail")
    end
    # Write various bits of text
    textpos = [
       [_INTL("MOVES"),26,10,0,base,shadow],
       [_INTL("CATEGORY"),20,116,0,base,shadow],
       [_INTL("POWER"),20,148,0,base,shadow],
       [_INTL("ACCURACY"),20,180,0,base,shadow]
    ]
    imagepos = []
    # Write move names, types and PP amounts for each known move
    yPos = 92
    yPos -= 76 if move_to_learn
    limit = (move_to_learn) ? Pokemon::MAX_MOVES + 1 : Pokemon::MAX_MOVES
    for i in 0...limit
      move = @pokemon.moves[i]
      if i==Pokemon::MAX_MOVES
        move = move_to_learn
        yPos += 20
      end
      if move
        type_number = GameData::Type.get(move.type).id_number
        imagepos.push(["Graphics/Pictures/types", 248, yPos + 8, 0, type_number * 28, 64, 28])
        textpos.push([move.name,316,yPos,0,moveBase,moveShadow])
        if move.total_pp>0
          textpos.push([_INTL("PP"),342,yPos+32,0,moveBase,moveShadow])
          ppfraction = 0
          if move.pp==0;                  ppfraction = 3
          elsif move.pp*4<=move.total_pp; ppfraction = 2
          elsif move.pp*2<=move.total_pp; ppfraction = 1
          end
          textpos.push([sprintf("%d/%d",move.pp,move.total_pp),460,yPos+32,1,ppBase[ppfraction],ppShadow[ppfraction]])
        end
      else
        textpos.push(["-",316,yPos,0,moveBase,moveShadow])
        textpos.push(["--",442,yPos+32,1,moveBase,moveShadow])
      end
      yPos += 64
    end
    # Draw all text and images
    pbDrawTextPositions(overlay,textpos)
    pbDrawImagePositions(overlay,imagepos)
    # Draw Pokémon's type icon(s)
    type1_number = GameData::Type.get(@pokemon.type1).id_number
    type2_number = GameData::Type.get(@pokemon.type2).id_number
    type1rect = Rect.new(0, type1_number * 28, 64, 28)
    type2rect = Rect.new(0, type2_number * 28, 64, 28)
    if @pokemon.type1==@pokemon.type2
      overlay.blt(130,78,@typebitmap.bitmap,type1rect)
    else
      overlay.blt(96,78,@typebitmap.bitmap,type1rect)
      overlay.blt(166,78,@typebitmap.bitmap,type2rect)
    end
  end
  def drawSelectedMove(move_to_learn, selected_move)
    # Draw all of page four, except selected move's details
    drawPageFiveSelecting(move_to_learn)
    # Set various values
    overlay = @sprites["overlay"].bitmap
    base = Color.new(64, 64, 64)
    shadow = Color.new(176, 176, 176)
    @sprites["pokemon"].visible = false if @sprites["pokemon"]
    @sprites["pokeicon"].pokemon = @pokemon
    @sprites["pokeicon"].visible = true
    @sprites["itemicon"].visible = false if @sprites["itemicon"]
    textpos = []
    # Write power and accuracy values for selected move
    case selected_move.base_damage
    when 0 then textpos.push(["---", 216, 148, 1, base, shadow])   # Status move
    when 1 then textpos.push(["???", 216, 148, 1, base, shadow])   # Variable power move
    else        textpos.push([selected_move.base_damage.to_s, 216, 148, 1, base, shadow])
    end
    if selected_move.accuracy == 0
      textpos.push(["---", 216, 180, 1, base, shadow])
    else
      textpos.push(["#{selected_move.accuracy}%", 216 + overlay.text_size("%").width, 180, 1, base, shadow])
    end
    # Draw all text
    pbDrawTextPositions(overlay, textpos)
    # Draw selected move's damage category icon
    imagepos = [["Graphics/Pictures/category", 166, 124, 0, selected_move.category * 28, 64, 28]]
    pbDrawImagePositions(overlay, imagepos)
    # Draw selected move's description
    drawTextEx(overlay, 4, 222, 230, 5, selected_move.description, base, shadow)
  end
  def pbScene
    GameData::Species.play_cry_from_pokemon(@pokemon)
    loop do
      Graphics.update
      Input.update
      pbUpdate
      dorefresh = false
      if Input.trigger?(Input::ACTION)
        pbSEStop
        GameData::Species.play_cry_from_pokemon(@pokemon)
      elsif Input.trigger?(Input::BACK)
        pbPlayCloseMenuSE
        break
      elsif Input.trigger?(Input::USE)
        if @page==5
          pbPlayDecisionSE
          pbMoveSelection
          dorefresh = true
        elsif !@inbattle
          pbPlayDecisionSE
          dorefresh = pbOptions
        end
      elsif Input.trigger?(Input::UP) && @partyindex>0
        oldindex = @partyindex
        pbGoToPrevious
        if @partyindex!=oldindex
          pbChangePokemon
          @ribbonOffset = 0
          dorefresh = true
        end
      elsif Input.trigger?(Input::DOWN) && @partyindex<@party.length-1
        oldindex = @partyindex
        pbGoToNext
        if @partyindex!=oldindex
          pbChangePokemon
          @ribbonOffset = 0
          dorefresh = true
        end
      elsif Input.trigger?(Input::LEFT) && !@pokemon.egg?
        oldpage = @page
        @page -= 1
        @page = 1 if @page<1
        @page = 5 if @page>5
        if @page!=oldpage   # Move to next page
          pbSEPlay("GUI summary change page")
          @ribbonOffset = 0
          dorefresh = true
        end
      elsif Input.trigger?(Input::RIGHT) && !@pokemon.egg?
        oldpage = @page
        @page += 1
        @page = 1 if @page<1
        @page = 5 if @page>5
        if @page!=oldpage   # Move to next page
          pbSEPlay("GUI summary change page")
          @ribbonOffset = 0
          dorefresh = true
        end
      end
      if dorefresh
        drawPage(@page)
      end
    end
    return @partyindex
  end
end

class BattleSceneRoom
  def setWeather
    # loop once
    for wth in [["Rain", [:Rain, :HeavyRain, :Storm, :AcidRain,]],["Snow", [:Hail, :Sleet]], ["StrongWind", [:StrongWinds, :Windy]], ["Sunny", [:Sun, :HarshSun]], ["Sandstorm", [:Sandstorm, :DustDevil]],["Overcast", [:Overcast]],["Starstorm", [:Starstorm]],["VolcanicAsh", [:VolcanicAsh, :DAshfall]]]
      proceed = false
      for cond in (wth[1].is_a?(Array) ? wth[1] : [wth[1]])
        proceed = true if @battle.pbWeather == cond
      end
      eval("delete" + wth[0]) unless proceed
      eval("draw"  + wth[0]) if proceed
    end
  end
  #-----------------------------------------------------------------------------
  # frame update for the weather particles
  #-----------------------------------------------------------------------------
  def updateWeather
    self.setWeather
    harsh = [:HEAVYRAIN, :HARSHSUN].include?(@battle.pbWeather)
    # snow particles
    for j in 0...72
      next if !@sprites["w_snow#{j}"]
      if @sprites["w_snow#{j}"].opacity <= 0
        z = rand(32)
        @sprites["w_snow#{j}"].param = 0.24 + 0.01*rand(z/2)
        @sprites["w_snow#{j}"].ey = -rand(64)
        @sprites["w_snow#{j}"].ex = 32 + rand(@sprites["bg"].bitmap.width - 64)
        @sprites["w_snow#{j}"].end_x = @sprites["w_snow#{j}"].ex
        @sprites["w_snow#{j}"].toggle = rand(2) == 0 ? 1 : -1
        @sprites["w_snow#{j}"].speed = 1 + 2/((rand(5) + 1)*0.4)
        @sprites["w_snow#{j}"].z = z - (@focused ? 0 : 100)
        @sprites["w_snow#{j}"].opacity = 255
      end
      min = @sprites["bg"].bitmap.height/4
      max = @sprites["bg"].bitmap.height/2
      scale = (2*Math::PI)/((@sprites["w_snow#{j}"].bitmap.width/64.0)*(max - min) + min)
      @sprites["w_snow#{j}"].opacity -= @sprites["w_snow#{j}"].speed
      @sprites["w_snow#{j}"].ey += @sprites["w_snow#{j}"].speed
      @sprites["w_snow#{j}"].ex = @sprites["w_snow#{j}"].end_x + @sprites["w_snow#{j}"].bitmap.width*0.25*Math.sin(@sprites["w_snow#{j}"].ey*scale)*@sprites["w_snow#{j}"].toggle
    end
    # rain particles
    for j in 0...72
      next if !@sprites["w_rain#{j}"]
      if @sprites["w_rain#{j}"].opacity <= 0
        z = rand(32)
        @sprites["w_rain#{j}"].param = 0.24 + 0.01*rand(z/2)
        @sprites["w_rain#{j}"].ox = 0
        @sprites["w_rain#{j}"].ey = -rand(64)
        @sprites["w_rain#{j}"].ex = 32 + rand(@sprites["bg"].bitmap.width - 64)
        @sprites["w_rain#{j}"].speed = 3 + 2/((rand(5) + 1)*0.4)
        @sprites["w_rain#{j}"].z = z - (@focused ? 0 : 100)
        @sprites["w_rain#{j}"].opacity = 255
      end
      @sprites["w_rain#{j}"].opacity -= @sprites["w_rain#{j}"].speed*(harsh ? 3 : 2)
      @sprites["w_rain#{j}"].ox += @sprites["w_rain#{j}"].speed*(harsh ? 8 : 6)
    end
    # starstorm particles
    for j in 0...72
      next if !@sprites["w_starstorm#{j}"]
      if @sprites["w_starstorm#{j}"].opacity <= 0
        z = rand(32)
        @sprites["w_starstorm#{j}"].param = 0.24 + 0.01*rand(z/2)
        @sprites["w_starstorm#{j}"].ox = 32 + rand(@sprites["bg"].bitmap.width - 64)
        @sprites["w_starstorm#{j}"].ey = 0
        @sprites["w_starstorm#{j}"].ex = 0
        @sprites["w_starstorm#{j}"].speed = 3 + 2/((rand(5) + 1)*0.4)
        @sprites["w_starstorm#{j}"].z = z - (@focused ? 0 : 100)
        @sprites["w_starstorm#{j}"].opacity = 255
      end
      @sprites["w_starstorm#{j}"].opacity -= @sprites["w_starstorm#{j}"].speed
      @sprites["w_starstorm#{j}"].ex += @sprites["w_starstorm#{j}"].speed*2
    end
    # volcanic ash particles
    for j in 0...72
      next if !@sprites["w_volc#{j}"]
      if @sprites["w_volc#{j}"].opacity <= 0
        z = rand(32)
        @sprites["w_volc#{j}"].param = 0.24 + 0.01*rand(z/2)
        @sprites["w_volc#{j}"].ox = 0
        @sprites["w_volc#{j}"].ey = -rand(64)
        @sprites["w_volc#{j}"].ex = 32 + rand(@sprites["bg"].bitmap.width - 64)
        @sprites["w_volc#{j}"].speed = 3 + 1/((rand(8) + 1)*0.4)
        @sprites["w_volc#{j}"].z = z - (@focused ? 0 : 100)
        @sprites["w_volc#{j}"].opacity = 255
      end
      @sprites["w_volc#{j}"].opacity -= @sprites["w_volc#{j}"].speed
      @sprites["w_volc#{j}"].ox += @sprites["w_volc#{j}"].speed*2
    end
    # sun particles
    for j in 0...3
      next if !@sprites["w_sunny#{j}"]
      #next if j > @shine["count"]/6
      @sprites["w_sunny#{j}"].zoom_x += 0.04*[0.5, 0.8, 0.7][j]
      @sprites["w_sunny#{j}"].zoom_y += 0.03*[0.5, 0.8, 0.7][j]
      @sprites["w_sunny#{j}"].opacity += @sprites["w_sunny#{j}"].zoom_x < 1 ? 8 : -12
      if @sprites["w_sunny#{j}"].opacity <= 0
        @sprites["w_sunny#{j}"].zoom_x = 0
        @sprites["w_sunny#{j}"].zoom_y = 0
        @sprites["w_sunny#{j}"].opacity = 0
      end
    end
    # sandstorm particles
    for j in 0...2
      next if !@sprites["w_sand#{j}"]
      @sprites["w_sand#{j}"].update
    end
  end
  #-----------------------------------------------------------------------------
  # sunny weather handlers
  #-----------------------------------------------------------------------------
  def drawSunny
    @sunny = true
    # refresh daylight tinting
    if @weather != @battle.pbWeather
      @weather = @battle.pbWeather
      self.daylightTint
    end
    # apply sky tone
    if @sprites["sky"]
      @sprites["sky"].tone.all += 16 if @sprites["sky"].tone.all < 96
      for i in 0..1
        @sprites["cloud#{i}"].tone.all += 16 if @sprites["cloud#{i}"].tone.all < 96
      end
    end
    # draw particles
    for i in 0...3
      next if @sprites["w_sunny#{i}"]
      @sprites["w_sunny#{i}"] = Sprite.new(@viewport)
      @sprites["w_sunny#{i}"].z = 100
      @sprites["w_sunny#{i}"].bitmap = pbBitmap("Graphics/EBDX/Animations/Weather/ray001")
      @sprites["w_sunny#{i}"].oy = @sprites["w_sunny#{i}"].bitmap.height/2
      @sprites["w_sunny#{i}"].angle = 290 + [-10, 32, 10][i]
      @sprites["w_sunny#{i}"].zoom_x = 0
      @sprites["w_sunny#{i}"].zoom_y = 0
      @sprites["w_sunny#{i}"].opacity = 0
      @sprites["w_sunny#{i}"].x = [-2, 20, 10][i]
      @sprites["w_sunny#{i}"].y = [-4, -24, -2][i]
    end
  end
  def deleteSunny
    @sunny = false
    # refresh daylight tinting
    if @weather != @battle.pbWeather
      @weather = @battle.pbWeather
      self.daylightTint
    end
    # apply sky tone
    if @sprites["sky"] && !weatherTint?
      @sprites["sky"].tone.all -= 4 if @sprites["sky"].tone.all > 0
      for i in 0..1
        @sprites["cloud#{i}"].tone.all -= 4 if @sprites["cloud#{i}"].tone.all > 0
      end
    end
    for j in 0...3
      next if !@sprites["w_sunny#{j}"]
      @sprites["w_sunny#{j}"].dispose
      @sprites.delete("w_sunny#{j}")
    end
  end
  #-----------------------------------------------------------------------------
  # snow weather handlers
  #-----------------------------------------------------------------------------
  def drawSandstorm
    for j in 0...2
      next if @sprites["w_sand#{j}"]
      @sprites["w_sand#{j}"] = ScrollingSprite.new(@viewport)
      @sprites["w_sand#{j}"].default!
      @sprites["w_sand#{j}"].z = 100
      @sprites["w_sand#{j}"].setBitmap("Graphics/EBDX/Animations/Weather/Sandstorm#{j}")
      @sprites["w_sand#{j}"].speed = 32
      @sprites["w_sand#{j}"].direction = j == 0 ? 1 : -1
    end
  end
  def deleteSandstorm
    for j in 0...2
      next if !@sprites["w_sand#{j}"]
      @sprites["w_sand#{j}"].dispose
      @sprites.delete("w_sand#{j}")
    end
  end
  #-----------------------------------------------------------------------------
  # sandstorm weather handlers
  #-----------------------------------------------------------------------------
  def drawSnow
    for j in 0...72
      next if @sprites["w_snow#{j}"]
      @sprites["w_snow#{j}"] = Sprite.new(@viewport)
      @sprites["w_snow#{j}"].bitmap = pbBitmap("Graphics/EBDX/Battlebacks/elements/snow")
      @sprites["w_snow#{j}"].center!
      @sprites["w_snow#{j}"].default!
      @sprites["w_snow#{j}"].opacity = 0
    end
  end
  def deleteSnow
    for j in 0...72
      next if !@sprites["w_snow#{j}"]
      @sprites["w_snow#{j}"].dispose
      @sprites.delete("w_snow#{j}")
    end
  end
  #-----------------------------------------------------------------------------
  # rain weather handlers
  #-----------------------------------------------------------------------------
  def drawRain
    harsh = @battle.pbWeather == :HEAVYRAIN
    # apply sky tone
    if @sprites["sky"]
      @sprites["sky"].tone.all -= 2 if @sprites["sky"].tone.all > -16
      @sprites["sky"].tone.gray += 16 if @sprites["sky"].tone.gray < 128
      for i in 0..1
        @sprites["cloud#{i}"].tone.all -= 2 if @sprites["cloud#{i}"].tone.all > -16
        @sprites["cloud#{i}"].tone.gray += 16 if @sprites["cloud#{i}"].tone.gray < 128
      end
    end
    for j in 0...72
      next if @sprites["w_rain#{j}"]
      @sprites["w_rain#{j}"] = Sprite.new(@viewport)
      if @battle.pbWeather == :AcidRain
        @sprites["w_rain#{j}"].create_rect(24, 3, Color.blue)
      else
        @sprites["w_rain#{j}"].create_rect(harsh ? 28 : 24, 3, Color.white)
      end
      @sprites["w_rain#{j}"].default!
      @sprites["w_rain#{j}"].angle = 80
      @sprites["w_rain#{j}"].oy = 2
      @sprites["w_rain#{j}"].opacity = 0
    end
  end
  def deleteRain
    # apply sky tone
    if @sprites["sky"]
      @sprites["sky"].tone.all += 2 if @sprites["sky"].tone.all < 0
      @sprites["sky"].tone.gray -= 16 if @sprites["sky"].tone.gray > 0
      for i in 0..1
        @sprites["cloud#{i}"].tone.all += 2 if @sprites["cloud#{i}"].tone.all < 0
        @sprites["cloud#{i}"].tone.gray -= 16 if @sprites["cloud#{i}"].tone.gray > 0
      end
    end
    for j in 0...72
      next if !@sprites["w_rain#{j}"]
      @sprites["w_rain#{j}"].dispose
      @sprites.delete("w_rain#{j}")
    end
  end
  #-----------------------------------------------------------------------------
  # strong wind weather handlers
  #-----------------------------------------------------------------------------
  def drawStrongWind; @strongwind = true; end
  def deleteStrongWind; @strongwind = false; end
  #-----------------------------------------------------------------------------
  # overcast weather handlers
  #-----------------------------------------------------------------------------
  def drawOvercast
    if @sprites["sky"]
      @sprites["sky"].tone.all -= 10 if @sprites["sky"].tone.all > -100
      @sprites["sky"].tone.gray += 16 if @sprites["sky"].tone.gray < 172
      for i in 0..1
        @sprites["cloud#{i}"].tone.all -= 10 if @sprites["cloud#{i}"].tone.all > -100
        @sprites["cloud#{i}"].tone.gray += 16 if @sprites["cloud#{i}"].tone.gray < 172
      end
    end
  end

  def deleteOvercast
    if @sprites["sky"]
      @sprites["sky"].tone.all += 10 if @sprites["sky"].tone.all < 0
      @sprites["sky"].tone.gray -= 16 if @sprites["sky"].tone.gray > 0
      for i in 0..1
        @sprites["cloud#{i}"].tone.all += 10 if @sprites["cloud#{i}"].tone.all < 0
        @sprites["cloud#{i}"].tone.gray -= 16 if @sprites["cloud#{i}"].tone.gray > 0
      end
    end
  end
  #-----------------------------------------------------------------------------
  # starstorm weather handlers
  #-----------------------------------------------------------------------------
  def drawStarstorm
    # apply sky tone
    if @sprites["sky"]
      @sprites["sky"].tone.all -= 10 if @sprites["sky"].tone.all > -120
      @sprites["sky"].tone.gray += 16 if @sprites["sky"].tone.gray < 128
      for i in 0..1
        @sprites["cloud#{i}"].tone.all -= 10 if @sprites["cloud#{i}"].tone.all > -120
        @sprites["cloud#{i}"].tone.gray += 16 if @sprites["cloud#{i}"].tone.gray < 128
      end
    end
    for j in 0...72
      next if @sprites["w_starstorm#{j}"]
      @sprites["w_starstorm#{j}"] = Sprite.new(@viewport)
      @sprites["w_starstorm#{j}"].create_rect(7, 7, Color.white)
      @sprites["w_starstorm#{j}"].default!
      @sprites["w_starstorm#{j}"].angle = 90
      @sprites["w_starstorm#{j}"].oy = -rand(64)
      @sprites["w_starstorm#{j}"].opacity = 0
    end
  end
  def deleteStarstorm
    # apply sky tone
    if @sprites["sky"]
      @sprites["sky"].tone.all += 2 if @sprites["sky"].tone.all < 0
      @sprites["sky"].tone.gray -= 16 if @sprites["sky"].tone.gray > 0
      for i in 0..1
        @sprites["cloud#{i}"].tone.all += 2 if @sprites["cloud#{i}"].tone.all < 0
        @sprites["cloud#{i}"].tone.gray -= 16 if @sprites["cloud#{i}"].tone.gray > 0
      end
    end
    for j in 0...72
      next if !@sprites["w_starstorm#{j}"]
      @sprites["w_starstorm#{j}"].dispose
      @sprites.delete("w_starstorm#{j}")
    end
  end
  #-----------------------------------------------------------------------------
  # volcanic ash weather handlers
  #-----------------------------------------------------------------------------
  def drawVolcanicAsh
    # apply sky tone
    if @sprites["sky"]
      @sprites["sky"].tone.all -= 4 if @sprites["sky"].tone.all > -100
      @sprites["sky"].tone.gray += 16 if @sprites["sky"].tone.gray < 128
      for i in 0..1
        @sprites["cloud#{i}"].tone.all -= 4 if @sprites["cloud#{i}"].tone.all > -100
        @sprites["cloud#{i}"].tone.gray += 16 if @sprites["cloud#{i}"].tone.gray < 128
      end
    end
    for j in 0...72
      next if @sprites["w_volc#{j}"]
      @sprites["w_volc#{j}"] = Sprite.new(@viewport)
      @sprites["w_volc#{j}"].create_rect(5, 5, Color.black)
      @sprites["w_volc#{j}"].default!
      @sprites["w_volc#{j}"].angle = 90
      @sprites["w_volc#{j}"].oy = 2
      @sprites["w_volc#{j}"].opacity = 0
    end
  end
  def deleteVolcanicAsh
    # apply sky tone
    if @sprites["sky"]
      @sprites["sky"].tone.all += 2 if @sprites["sky"].tone.all < 0
      @sprites["sky"].tone.gray -= 16 if @sprites["sky"].tone.gray > 0
      for i in 0..1
        @sprites["cloud#{i}"].tone.all += 2 if @sprites["cloud#{i}"].tone.all < 0
        @sprites["cloud#{i}"].tone.gray -= 16 if @sprites["cloud#{i}"].tone.gray > 0
      end
    end
    for j in 0...72
      next if !@sprites["w_volc#{j}"]
      @sprites["w_volc#{j}"].dispose
      @sprites.delete("w_volc#{j}")
    end
  end
end

class DataBoxEBDX
  def refresh
    return if self.disposed?
    # refreshes data
    @pokemon = @battler.displayPokemon
    # failsafe
    return if @pokemon.nil?
    @hidden = EliteBattle.get_data(@pokemon.species, :Species, :HIDENAME, (@pokemon.form rescue 0)) && !$Trainer.owned[@pokemon.species]
    # exits the refresh if the databox isn't fully set up yet
    return if !@loaded
    # update for HP/EXP bars
    self.updateHpBar
    # clears the current bitmap containing text and adjusts its font
    @sprites["textName"].bitmap.clear
    # used to calculate the potential offset of elements should they exceed the
    # width of the HP bar
    str = ""
    str = _INTL("♂") if @pokemon.gender == 0 && !@hidden
    str = _INTL("♀") if @pokemon.gender == 1 && !@hidden
    w = @sprites["textName"].bitmap.text_size("#{@battler.name.force_encoding("UTF-8")}#{str.force_encoding("UTF-8")}Lv.#{@pokemon.level}").width
    o = (w > @hpBarWidth + 4) ? (w-(@hpBarWidth + 4))/2.0 : 0; o = o.ceil
    # writes the Pokemon's name
    str = @battler.name.nil? ? "" : @battler.name
    str += " "
    color = @pokemon.shiny? ? Color.new(222,197,95) : Color.white
    pbDrawOutlineText(@sprites["textName"].bitmap,18-o,3,@sprites["textName"].bitmap.width-40,@sprites["textName"].bitmap.height,str,color,Color.new(0,0,0,125),0)
    # writes the Pokemon's gender
    x = @sprites["textName"].bitmap.text_size(str).width + 18
    str = ""
    str = _INTL("♂") if @pokemon.gender == 0 && !@hidden
    str = _INTL("♀") if @pokemon.gender == 1 && !@hidden
    color = (@pokemon.gender == 0) ? Color.new(53,107,208) : Color.new(180,37,77)
    pbDrawOutlineText(@sprites["textName"].bitmap,x-o,3,@sprites["textName"].bitmap.width-40,@sprites["textName"].bitmap.height,str,color,Color.new(0,0,0,125),0)
    # writes the Pokemon's level
    str = "Lv.#{@battler.level}"
    pbDrawOutlineText(@sprites["textName"].bitmap,18+o,3,@sprites["textName"].bitmap.width-40,@sprites["textName"].bitmap.height,str,Color.white,Color.new(0,0,0,125),2)
    # changes the Mega symbol graphics (depending on Mega or Primal)
    if @battler.mega? || (@battler.form >= 21 && @battler.form <= 41)
      @sprites["mega"].bitmap = @megaBmp.clone
    elsif @battler.primal? || (@battler.form >= 42)
      @sprites["mega"].bitmap = @prKyogre.clone if @battler.isSpecies?(:KYOGRE)
      @sprites["mega"].bitmap = @prGroudon.clone if @battler.isSpecies?(:GROUDON)
      @sprites["mega"].bitmap = @prKyogre.clone if @battler.isSpecies?(:PALKIA)
      @sprites["mega"].bitmap = @prGroudon.clone if @battler.isSpecies?(:DIALGA)
      @sprites["mega"].bitmap = @prKyogre.clone if @battler.isSpecies?(:ALTEMPER)
    elsif @sprites["mega"].bitmap
      @sprites["mega"].bitmap.clear
      @sprites["mega"].bitmap = nil
    end
    self.updateHpBar
    self.updateExpBar
  end
end

class PokemonSaveScreen
  def pbStartScreen
    @viewport=Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z=99999
    @sprites={}
    totalsec = Graphics.frame_count / Graphics.frame_rate
    hour = totalsec / 60 / 60
    min = totalsec / 60 % 60
    mapname=$game_map.name
    textColor = ["0070F8,78B8E8","E82010,F8A8B8","0070F8,78B8E8"][$Trainer.gender]
    locationColor = "209808,90F090"   # green
    loctext=_INTL("<ac><c3={1}>{2}</c3></ac>",locationColor,mapname)
    loctext+=_INTL("Player<r><c3={1}>{2}</c3><br>",textColor,$Trainer.name)
    if hour>0
      loctext+=_INTL("Time<r><c3={1}>{2}h {3}m</c3><br>",textColor,hour,min)
    else
      loctext+=_INTL("Time<r><c3={1}>{2}m</c3><br>",textColor,min)
    end
    loctext+=_INTL("Chapter<r><c3={1}>{2}</c3><br>",textColor,$Trainer.badge_count)
    if $Trainer.has_pokedex
      loctext+=_INTL("Pokédex<r><c3={1}>{2}/{3}</c3>",textColor,$Trainer.pokedex.owned_count,$Trainer.pokedex.seen_count)
    end
    if $game_switches[400]
      loctext+=_INTL("Readouts<r><c3={1}>{2}</c3><br>",textColor,$game_variables[Readouts::Count])
    end
    @sprites["locwindow"]=Window_AdvancedTextPokemon.new(loctext)
    @sprites["locwindow"].viewport=@viewport
    @sprites["locwindow"].x=0
    @sprites["locwindow"].y=0
    @sprites["locwindow"].width=228 if @sprites["locwindow"].width<228
    @sprites["locwindow"].visible=true
  end
end

class PokemonLoadScreen
  def initialize(scene)
    @scene = scene
    if SaveData.exists?
      @save_data = load_save_file(SaveData::FILE_PATH)
    else
      @save_data = {}
    end
  end

  # @param file_path [String] file to load save data from
  # @return [Hash] save data
  def load_save_file(file_path)
    save_data = SaveData.read_from_file(file_path)
    unless SaveData.valid?(save_data)
      if File.file?(file_path + '.bak')
        pbMessage(_INTL('The save file is corrupt. A backup will be loaded.'))
        save_data = load_save_file(file_path + '.bak')
      else
        self.prompt_save_deletion
        return {}
      end
    end
    return save_data
  end

  # Called if all save data is invalid.
  # Prompts the player to delete the save files.
  def prompt_save_deletion
    pbMessage(_INTL('The save file is corrupt, or is incompatible with this game.'))
    exit unless pbConfirmMessageSerious(
      _INTL('Do you want to delete the save file and start anew?')
    )
    self.delete_save_data
    $game_system   = Game_System.new
    $PokemonSystem = PokemonSystem.new
  end

  def pbStartDeleteScreen
    @scene.pbStartDeleteScene
    @scene.pbStartScene2
    if SaveData.exists?
      if pbConfirmMessageSerious(_INTL("Delete all saved data?"))
        pbMessage(_INTL("Once data has been deleted, there is no way to recover it.\1"))
        if pbConfirmMessageSerious(_INTL("Delete the saved data anyway?"))
          pbMessage(_INTL("Deleting all data. Don't turn off the power.\\wtnp[0]"))
          self.delete_save_data
        end
      end
    else
      pbMessage(_INTL("No save file was found."))
    end
    @scene.pbEndScene
    $scene = pbCallTitle
  end

  def delete_save_data
    begin
      SaveData.delete_file
      pbMessage(_INTL('The saved data was deleted.'))
    rescue SystemCallError
      pbMessage(_INTL('All saved data could not be deleted.'))
    end
  end

  def pbStartLoadScreen
    commands = []
    cmd_continue     = -1
    cmd_new_game     = -1
    cmd_options      = -1
    cmd_language     = -1
    cmd_mystery_gift = -1
    cmd_debug        = -1
    cmd_quit         = -1
    show_continue = !@save_data.empty?
    if show_continue
      commands[cmd_continue = commands.length] = _INTL('Continue')
      if @save_data[:player].mystery_gift_unlocked
        commands[cmd_mystery_gift = commands.length] = _INTL('Mystery Gift')
      end
    end
    commands[cmd_new_game = commands.length]  = _INTL('New Game')
    commands[cmd_options = commands.length]   = _INTL('Options')
    commands[cmd_language = commands.length]  = _INTL('Language') if Settings::LANGUAGES.length >= 2
    commands[cmd_debug = commands.length]     = _INTL('Debug') if $DEBUG
    commands[cmd_quit = commands.length]      = _INTL('Quit Game')
    map_id = show_continue ? @save_data[:map_factory].map.map_id : 0
    @scene.pbStartScene(commands, show_continue, @save_data[:player],
                        @save_data[:frame_count] || 0, map_id)
    @scene.pbSetParty(@save_data[:player]) if show_continue
    @scene.pbStartScene2
    loop do
      command = @scene.pbChoose(commands)
      pbPlayDecisionSE if command != cmd_quit
      case command
      when cmd_continue
        $currentDexSearch = nil
        @scene.pbEndScene
        Game.load(@save_data)
        return
      when cmd_new_game
        @scene.pbEndScene
        Game.start_new
        return
      when cmd_mystery_gift
        pbFadeOutIn { pbDownloadMysteryGift(@save_data[:player]) }
      when cmd_options
        pbFadeOutIn do
          scene = PokemonOption_Scene.new
          screen = PokemonOptionScreen.new(scene)
          screen.pbStartScreen(true)
        end
      when cmd_language
        @scene.pbEndScene
        $PokemonSystem.language = pbChooseLanguage
        pbLoadMessages('Data/' + Settings::LANGUAGES[$PokemonSystem.language][1])
        if show_continue
          @save_data[:pokemon_system] = $PokemonSystem
          File.open(SaveData::FILE_PATH, 'wb') { |file| Marshal.dump(@save_data, file) }
        end
        $scene = pbCallTitle
        return
      when cmd_debug
        pbFadeOutIn { pbDebugMenu(false) }
      when cmd_quit
        pbPlayCloseMenuSE
        @scene.pbEndScene
        $scene = nil
        return
      else
        pbPlayBuzzerSE
      end
    end
  end
end

class PokemonLoadPanel
  def refresh
    return if @refreshing
    return if disposed?
    @refreshing = true
    if !self.bitmap || self.bitmap.disposed?
      self.bitmap = BitmapWrapper.new(@bgbitmap.width,111*2)
      pbSetSystemFont(self.bitmap)
    end
    if @refreshBitmap
      @refreshBitmap = false
      self.bitmap.clear if self.bitmap
      if @isContinue
        self.bitmap.blt(0,0,@bgbitmap.bitmap,Rect.new(0,(@selected) ? 111*2 : 0,@bgbitmap.width,111*2))
      else
        self.bitmap.blt(0,0,@bgbitmap.bitmap,Rect.new(0,111*2*2+((@selected) ? 23*2 : 0),@bgbitmap.width,23*2))
      end
      textpos = []
      if @isContinue
        textpos.push([@title,16*2,2*2,0,TEXTCOLOR,TEXTSHADOWCOLOR])
        textpos.push([_INTL("Chapter:"),16*2,53*2,0,TEXTCOLOR,TEXTSHADOWCOLOR])
        textpos.push([@trainer.badge_count.to_s,103*2,53*2,1,TEXTCOLOR,TEXTSHADOWCOLOR])
        textpos.push([_INTL("Pokédex:"),16*2,69*2,0,TEXTCOLOR,TEXTSHADOWCOLOR])
        textpos.push([@trainer.pokedex.seen_count.to_s,103*2,69*2,1,TEXTCOLOR,TEXTSHADOWCOLOR])
        textpos.push([_INTL("Time:"),16*2,85*2,0,TEXTCOLOR,TEXTSHADOWCOLOR])
        hour = @totalsec / 60 / 60
        min  = @totalsec / 60 % 60
        if hour>0
          textpos.push([_INTL("{1}h {2}m",hour,min),103*2,85*2,1,TEXTCOLOR,TEXTSHADOWCOLOR])
        else
          textpos.push([_INTL("{1}m",min),103*2,85*2,1,TEXTCOLOR,TEXTSHADOWCOLOR])
        end
        if @trainer.male?
          textpos.push([@trainer.name,56*2,29*2,0,MALETEXTCOLOR,MALETEXTSHADOWCOLOR])
        elsif @trainer.female?
          textpos.push([@trainer.name,56*2,29*2,0,FEMALETEXTCOLOR,FEMALETEXTSHADOWCOLOR])
        else
          textpos.push([@trainer.name,56*2,29*2,0,TEXTCOLOR,TEXTSHADOWCOLOR])
        end
        mapname = pbGetMapNameFromId(@mapid)
        mapname.gsub!(/\\PN/,@trainer.name)
        textpos.push([mapname,193*2,2*2,1,TEXTCOLOR,TEXTSHADOWCOLOR])
      else
        textpos.push([@title,16*2,1*2,0,TEXTCOLOR,TEXTSHADOWCOLOR])
      end
      pbDrawTextPositions(self.bitmap,textpos)
    end
    @refreshing = false
  end
end

class PokemonPartyScreen
  def pbPokemonScreen
    @scene.pbStartScene(@party,
       (@party.length>1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel."),nil)
    loop do
      @scene.pbSetHelpText((@party.length>1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel."))
      pkmnid = @scene.pbChoosePokemon(false,-1,1)
      break if (pkmnid.is_a?(Numeric) && pkmnid<0) || (pkmnid.is_a?(Array) && pkmnid[1]<0)
      if pkmnid.is_a?(Array) && pkmnid[0]==1   # Switch
        @scene.pbSetHelpText(_INTL("Move to where?"))
        oldpkmnid = pkmnid[1]
        pkmnid = @scene.pbChoosePokemon(true,-1,2)
        if pkmnid>=0 && pkmnid!=oldpkmnid
          pbSwitch(oldpkmnid,pkmnid)
        end
        next
      end
      pkmn = @party[pkmnid]
      commands   = []
      cmdSummary = -1
      cmdDebug   = -1
      cmdMoves   = [-1] * pkmn.numMoves
      cmdSwitch  = -1
      cmdName    = -1
      cmdMail    = -1
      cmdItem    = -1
      # Build the commands
      commands[cmdSummary = commands.length]      = _INTL("Summary")
      commands[cmdDebug = commands.length]        = _INTL("Debug") if $DEBUG
      if !pkmn.egg?
        # Check for hidden moves and add any that were found
        pkmn.moves.each_with_index do |m, i|
          if [:MILKDRINK, :SOFTBOILED].include?(m.id) ||
             HiddenMoveHandlers.hasHandler(m.id)
            commands[cmdMoves[i] = commands.length] = [m.name, 1]
          end
        end
      end
      commands[cmdSwitch = commands.length]       = _INTL("Switch") if @party.length>1
      if !pkmn.egg?
        if pkmn.mail
          commands[cmdMail = commands.length]     = _INTL("Mail")
          commands[cmdName = commands.length]     = _INTL("Nickname")
        else
          commands[cmdItem = commands.length]     = _INTL("Item")
          commands[cmdName = commands.length]     = _INTL("Nickname")
        end
      end
      commands[commands.length]                   = _INTL("Cancel")
      command = @scene.pbShowCommands(_INTL("Do what with {1}?",pkmn.name),commands)
      havecommand = false
      cmdMoves.each_with_index do |cmd, i|
        next if cmd < 0 || cmd != command
        havecommand = true
        if [:MILKDRINK, :SOFTBOILED].include?(pkmn.moves[i].id)
          amt = [(pkmn.totalhp/5).floor,1].max
          if pkmn.hp<=amt
            pbDisplay(_INTL("Not enough HP..."))
            break
          end
          @scene.pbSetHelpText(_INTL("Use on which Pokémon?"))
          oldpkmnid = pkmnid
          loop do
            @scene.pbPreSelect(oldpkmnid)
            pkmnid = @scene.pbChoosePokemon(true,pkmnid)
            break if pkmnid<0
            newpkmn = @party[pkmnid]
            movename = pkmn.moves[i].name
            if pkmnid==oldpkmnid
              pbDisplay(_INTL("{1} can't use {2} on itself!",pkmn.name,movename))
            elsif newpkmn.egg?
              pbDisplay(_INTL("{1} can't be used on an Egg!",movename))
            elsif newpkmn.hp==0 || newpkmn.hp==newpkmn.totalhp
              pbDisplay(_INTL("{1} can't be used on that Pokémon.",movename))
            else
              pkmn.hp -= amt
              hpgain = pbItemRestoreHP(newpkmn,amt)
              @scene.pbDisplay(_INTL("{1}'s HP was restored by {2} points.",newpkmn.name,hpgain))
              pbRefresh
            end
            break if pkmn.hp<=amt
          end
          @scene.pbSelect(oldpkmnid)
          pbRefresh
          break
        elsif pbCanUseHiddenMove?(pkmn,pkmn.moves[i].id)
          if pbConfirmUseHiddenMove(pkmn,pkmn.moves[i].id)
            @scene.pbEndScene
            if pkmn.moves[i].id == :FLY
              scene = PokemonRegionMap_Scene.new(-1,false)
              screen = PokemonRegionMapScreen.new(scene)
              ret = screen.pbStartFlyScreen
              if ret
                $PokemonTemp.flydata=ret
                return [pkmn,pkmn.moves[i].id]
              end
              @scene.pbStartScene(@party,
                 (@party.length>1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel."))
              break
            end
            return [pkmn,pkmn.moves[i].id]
          end
        end
      end
      next if havecommand
      if cmdSummary>=0 && command==cmdSummary
        @scene.pbSummary(pkmnid) {
          @scene.pbSetHelpText((@party.length>1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel."))
        }
      elsif cmdDebug>=0 && command==cmdDebug
        pbPokemonDebug(pkmn,pkmnid)
      elsif cmdSwitch>=0 && command==cmdSwitch
        @scene.pbSetHelpText(_INTL("Move to where?"))
        oldpkmnid = pkmnid
        pkmnid = @scene.pbChoosePokemon(true)
        if pkmnid>=0 && pkmnid!=oldpkmnid
          pbSwitch(oldpkmnid,pkmnid)
        end
      elsif cmdName>=0 && command==cmdName
        speciesname = pkmn.speciesName
        nickname = pbEnterPokemonName(_INTL("{1}'s nickname?", speciesname),
                                      0, Pokemon::MAX_NAME_SIZE, "", pkmn)
        pkmn.name = nickname
      elsif cmdMail>=0 && command==cmdMail
        command = @scene.pbShowCommands(_INTL("Do what with the mail?"),
           [_INTL("Read"),_INTL("Take"),_INTL("Cancel")])
        case command
        when 0   # Read
          pbFadeOutIn {
            pbDisplayMail(pkmn.mail,pkmn)
            @scene.pbSetHelpText((@party.length>1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel."))
          }
        when 1   # Take
          if pbTakeItemFromPokemon(pkmn,self)
            pbRefreshSingle(pkmnid)
          end
        end
      elsif cmdItem>=0 && command==cmdItem
        itemcommands = []
        cmdUseItem   = -1
        cmdGiveItem  = -1
        cmdTakeItem  = -1
        cmdMoveItem  = -1
        # Build the commands
        itemcommands[cmdUseItem=itemcommands.length]  = _INTL("Use")
        itemcommands[cmdGiveItem=itemcommands.length] = _INTL("Give")
        itemcommands[cmdTakeItem=itemcommands.length] = _INTL("Take") if pkmn.hasItem?
        itemcommands[cmdMoveItem=itemcommands.length] = _INTL("Move") if pkmn.hasItem? &&
                                                                         !GameData::Item.get(pkmn.item).is_mail?
        itemcommands[itemcommands.length]             = _INTL("Cancel")
        command = @scene.pbShowCommands(_INTL("Do what with an item?"),itemcommands)
        if cmdUseItem>=0 && command==cmdUseItem   # Use
          item = @scene.pbUseItem($PokemonBag,pkmn) {
            @scene.pbSetHelpText((@party.length>1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel."))
          }
          if item
            pbUseItemOnPokemon(item,pkmn,self)
            pbRefreshSingle(pkmnid)
          end
        elsif cmdGiveItem>=0 && command==cmdGiveItem   # Give
          item = @scene.pbChooseItem($PokemonBag) {
            @scene.pbSetHelpText((@party.length>1) ? _INTL("Choose a Pokémon.") : _INTL("Choose Pokémon or cancel."))
          }
          if item
            if pbGiveItemToPokemon(item,pkmn,self,pkmnid)
              pbRefreshSingle(pkmnid)
            end
          end
        elsif cmdTakeItem>=0 && command==cmdTakeItem   # Take
          if pbTakeItemFromPokemon(pkmn,self)
            pbRefreshSingle(pkmnid)
          end
        elsif cmdMoveItem>=0 && command==cmdMoveItem   # Move
          item = pkmn.item
          itemname = item.name
          @scene.pbSetHelpText(_INTL("Move {1} to where?",itemname))
          oldpkmnid = pkmnid
          loop do
            @scene.pbPreSelect(oldpkmnid)
            pkmnid = @scene.pbChoosePokemon(true,pkmnid)
            break if pkmnid<0
            newpkmn = @party[pkmnid]
            break if pkmnid==oldpkmnid
            if newpkmn.egg?
              pbDisplay(_INTL("Eggs can't hold items."))
            elsif !newpkmn.hasItem?
              newpkmn.item = item
              pkmn.item = nil
              @scene.pbClearSwitching
              pbRefresh
              pbDisplay(_INTL("{1} was given the {2} to hold.",newpkmn.name,itemname))
              break
            elsif GameData::Item.get(newpkmn.item).is_mail?
              pbDisplay(_INTL("{1}'s mail must be removed before giving it an item.",newpkmn.name))
            else
              newitem = newpkmn.item
              newitemname = newitem.name
              if newitem == :LEFTOVERS
                pbDisplay(_INTL("{1} is already holding some {2}.\1",newpkmn.name,newitemname))
              elsif newitemname.starts_with_vowel?
                pbDisplay(_INTL("{1} is already holding an {2}.\1",newpkmn.name,newitemname))
              else
                pbDisplay(_INTL("{1} is already holding a {2}.\1",newpkmn.name,newitemname))
              end
              if pbConfirm(_INTL("Would you like to switch the two items?"))
                newpkmn.item = item
                pkmn.item = newitem
                @scene.pbClearSwitching
                pbRefresh
                pbDisplay(_INTL("{1} was given the {2} to hold.",newpkmn.name,itemname))
                pbDisplay(_INTL("{1} was given the {2} to hold.",pkmn.name,newitemname))
                break
              end
            end
          end
        end
      end
    end
    @scene.pbEndScene
    return nil
  end
end

class Scene_Credits
  CREDIT = <<_END_

  Scripting: Phantombass

  Regional Variant and Fakemon Sprites: Phantombass

  Professor Elm Sprite: necrolichmon

  Mapping: Phantombass

  Eventing: Phantombass

  Tilesets:
  WesleyFG
  lichenprincess

  Playtesting:

  DarkDevil26
  ThatWelshOne_
  RGTheAwesome
  ItzMiller
  PokeMaster Mike
  Kyle
  CloudEnvy
  WMAR
  Beta20x
  pizzatacoburger1234
  ChuTheWoop
  TenaciousFoxYT
  FlameHorizon

  Dedicated to:

  Megan and Sophia

  Also thanks to:

  Tilly...for walking all over my keyboard many times during development.

{INSERTS_PLUGIN_CREDITS_DO_NOT_REMOVE}

"Pokémon Essentials" was created by:
Flameguru
Poccil (Peter O.)
Maruno

With contributions from:
AvatarMonkeyKirby<s>Marin
Boushy<s>MiDas Mike
Brother1440<s>Near Fantastica
FL.<s>PinkMan
Genzai Kawakami<s>Popper
Golisopod User<s>Rataime
help-14<s>Savordez
IceGod64<s>SoundSpawn
Jacob O. Wobbrock<s>the__end
KitsuneKouta<s>Venom12
Lisa Anthony<s>Wachunga
Luka S.J.<s>
and everyone else who helped out

"mkxp-z" by:
Roza
Based on MKXP by Ancurio et al.

"RPG Maker XP" by:
Enterbrain

Pokémon is owned by:
The Pokémon Company
Nintendo
Affiliated with Game Freak



This is a non-profit fan-made game.
No copyright infringements intended.
Please support the official games!

_END_
end
