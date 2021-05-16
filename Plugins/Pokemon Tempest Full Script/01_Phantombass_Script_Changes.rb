#===================================
# Level Cap Scripts
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
    elsif $game_variables[Mission::Mission5] >= 4 && $game_variables[Mission::Mission5] <=6
      $game_variables[Level::Cap] = 66
    elsif $game_variables[Mission::Mission5] >= 8 && $game_variables[Mission::Mission4]< 9
      $game_variables[Level::Cap] = 70
    elsif $game_variables[Mission::Mission5] >= 9
      $game_variables[Level::Cap] = 75
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
    elsif $game_variables[Mission::Mission5] >= 4 && $game_variables[Mission::Mission5] <=6
      $game_variables[Level::Cap] = 66
    elsif $game_variables[Mission::Mission5] >= 8 && $game_variables[Mission::Mission4]< 9
      $game_variables[Level::Cap] = 70
    elsif $game_variables[Mission::Mission5] >= 9
      $game_variables[Level::Cap] = 75
    end
  end
}

#===================================
# Chapter Release Scripts
#===================================
module ChapterRelease
  Four = 525
  Five = 540
  Constant = 1000
end

Events.onMapChange += proc {| sender, e |
    $game_switches[ChapterRelease::Four] = true
    $game_switches[ChapterRelease::Five] = true
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
    $game_variables[ChapterRelease::Constant]+=1
  elsif $game_switches[ChapterRelease::Five] && $game_switches[538] && $game_variables[ChapterRelease::Constant] == 1
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
    $game_variables[ChapterRelease::Constant]+=1
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

#===================================
# Mid Battle Status Scripts
#===================================
def poisonAllPokemon(event=nil)
    for pkmn in $Trainer.ablePokemonParty
       next if pkmn.hasType?(:POISON)  || pkmn.hasType?(:STEEL) ||
          pkmn.hasAbility?(:COMATOSE)  || pkmn.hasAbility?(:SHIELDSDOWN) || pkmn.hasAbility?(:IMMUNITY)
          pkmn.status!=0
       pkmn.status = 2
       pkmn.statusCount = 1
     end
end

def paralyzeAllPokemon(event=nil)
    for pkmn in $Trainer.ablePokemonParty
       next if pkmn.hasType?(:ELECTRIC) ||
          pkmn.hasAbility?(:COMATOSE)  || pkmn.hasAbility?(:SHIELDSDOWN) || pkmn.hasAbility?(:LIMBER)
          pkmn.status!=0
       pkmn.status = 4
     end
end

def burnAllPokemon(event=nil)
    for pkmn in $Trainer.ablePokemonParty
       next if pkmn.hasType?(:FIRE) ||
          pkmn.hasAbility?(:COMATOSE)  || pkmn.hasAbility?(:SHIELDSDOWN) || pkmn.hasAbility?(:WATERBUBBLE) || pkmn.hasAbility?(:WATERVEIL)
          pkmn.status!=0
       pkmn.status = 3
     end
end

class PokeBattle_Battle
  def removeAllHazards
    if @battlers[0].pbOwnSide.effects[PBEffects::StealthRock] || @battlers[0].pbOpposingSide.effects[PBEffects::StealthRock]
      @battlers[0].pbOwnSide.effects[PBEffects::StealthRock]      = false
      @battlers[0].pbOpposingSide.effects[PBEffects::StealthRock] = false
    end
    if @battlers[0].pbOwnSide.effects[PBEffects::Spikes]>0 || @battlers[0].pbOpposingSide.effects[PBEffects::Spikes]>0
      @battlers[0].pbOwnSide.effects[PBEffects::Spikes]      = 0
      @battlers[0].pbOpposingSide.effects[PBEffects::Spikes] = 0
    end
    if @battlers[0].pbOwnSide.effects[PBEffects::CometShards] || @battlers[0].pbOpposingSide.effects[PBEffects::CometShards]
      @battlers[0].pbOwnSide.effects[PBEffects::CometShards]      = false
      @battlers[0].pbOpposingSide.effects[PBEffects::CometShards] = false
    end
    if @battlers[0].pbOwnSide.effects[PBEffects::ToxicSpikes]>0 || @battlers[0].pbOpposingSide.effects[PBEffects::ToxicSpikes]>0
      @battlers[0].pbOwnSide.effects[PBEffects::ToxicSpikes]      = 0
      @battlers[0].pbOpposingSide.effects[PBEffects::ToxicSpikes] = 0
    end
    if @battlers[0].pbOwnSide.effects[PBEffects::StickyWeb] || @battlers[0].pbOpposingSide.effects[PBEffects::StickyWeb]
      @battlers[0].pbOwnSide.effects[PBEffects::StickyWeb]      = false
      @battlers[0].pbOpposingSide.effects[PBEffects::StickyWeb] = false
    end
  end
end
#===================================
# Weather Scripts
#===================================
begin
  module PBFieldWeather
    None        = 0   # None must be 0 (preset RMXP weather)
    Rain        = 1   # Rain must be 1 (preset RMXP weather)
    Storm       = 2   # Storm must be 2 (preset RMXP weather)
    Snow        = 3   # Snow must be 3 (preset RMXP weather)
    Blizzard    = 4
    Sandstorm   = 5
    HeavyRain   = 6
    Sun = Sunny = 7 #8 is ShadowSky so we leave that blank
    ShadowSky   = 8
    Starstorm   = 9
    Overcast    = 10
    Sleet       = 11
    Fog         = 12
    Eclipse     = 13
    StrongWinds = 14
    Windy       = 15
    Thunder     = 16 # Thunderstorm
    AcidRain    = 17
    Humid       = 18
    Supercell   = 19
    HeatLight   = 20 # Heat Lightning
    Rainbow     = 21
    DustDevil   = 22
    DClear      = 23 # Distortion World - Clear
    DWind       = 24 # Distortion World - Windy
    DAshfall    = 25 # Distortion World - Ashfall
    DRain       = 26 # Distortion World - Rain
    VolcanicAsh = 27
    Borealis    = 28 # Northern Lights
    TimeWarp    = 29
    Reverb      = 30
    HarshSun    = 31

    def PBFieldWeather.maxValue; return 31; end
  end

rescue Exception
  if $!.is_a?(SystemExit) || "#{$!.class}"=="Reset"
    raise $!
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

module PBEffects
  GorillaTactics      = 114
  BallFetch           = 115
  LashOut             = 118
  BurningJealousy     = 119
  NoRetreat           = 120
  Obstruct            = 121
  JawLock             = 122
  JawLockUser         = 123
  TarShot             = 124
  Octolock            = 125
  OctolockUser        = 126
  BlunderPolicy       = 127
  EchoChamber         = 128
  #=
  StickyWebUser      = 22
  CometShards        = 23
  #=
  NeutralizingGas = 13
end


MultipleForms.register(:ALTEMPER,{
  "getFormOnLeavingBattle" => proc { |pkmn,battle,usedInBattle,endBattle|
    next 0 if endBattle
    next 0 if pkmn.form <= 20
    next 21 if pkmn.form <= 41
    next 42 if pkmn.form >= 42
  }
})

MultipleForms.register(:BAGON,{
  "getFormOnCreation" => proc { |pkmn|
    next if pkmn.form_simple>=3
    if $game_map
      map_metadata = GameData::MapMetadata.try_get($game_map.map_id)
      next 2 if map_metadata && map_metadata.town_map_position &&
                map_metadata.town_map_position[0] == 0   # Ufara region
    end
    next 0
  }
})

MultipleForms.copy(:BAGON,:SHELGON,:SALAMENCE,:MACHOP,:MACHOKE,:MACHAMP,:HIPPOPOTAS,:HIPPOWDON,:GIBLE,:GABITE,:GARCHOMP,:PINSIR,:TREECKO,:GROVYLE,:SCEPTILE,:TORCHIC,:COMBUSKEN,:BLAZIKEN,:MUDKIP,:MARSHTOMP,:SWAMPERT,:PIDOVE,:TRANQUILL,:UNFEZANT)

MultipleForms.register(:GASTLY,{
  "getFormOnCreation" => proc { |pkmn|
    next if pkmn.form_simple>=4
    if $game_map
      map_metadata = GameData::MapMetadata.try_get($game_map.map_id)
      next 3 if map_metadata && map_metadata.town_map_position &&
                map_metadata.town_map_position[0] == 0   # Ufara region
    end
    next 0
  }
})

MultipleForms.copy(:GASTLY,:HAUNTER,:GENGAR)

MultipleForms.register(:DREEPY,{
  "getFormOnCreation" => proc { |pkmn|
    next if pkmn.form_simple>=2
    if $game_map
      map_metadata = GameData::MapMetadata.try_get($game_map.map_id)   # Map IDs for Ufaran Forme
      next 1 if map_metadata && map_metadata.town_map_position &&
                map_metadata.town_map_position[0] == 0   # Ufara region
    end
    next 0
  }
})

MultipleForms.copy(:DREEPY,:DRAKLOAK,:DRAGAPULT,:DRAGALGE,:SNEASEL,:WEAVILE,:NIDORANmA,:NIDORINO,:NIDOKING,:NIDORANfE,:NIDORINA,:NIDOQUEEN,:BELLSPROUT,:WEEPINBELL,:VICTREEBEL,:SPINARAK,:ARIADOS,:PANSAGE,:SIMISAGE,:PANSEAR,:SIMISEAR,:PANPOUR,:SIMIPOUR,:SKRELP,:DRAGALGE)

MultipleForms.register(:ALTEMPER,{
  "getPrimalForm" => proc { |pkmn|
    next 42 if pkmn.hasItem?(:TEMPESTSTONE)
    next
  }
})

MultipleForms.register(:DIALGA,{
  "getPrimalForm" => proc { |pkmn|
    next 1 if pkmn.hasItem?(:ADAMANTORB)
    next
  }
})

MultipleForms.register(:PALKIA,{
  "getPrimalForm" => proc { |pkmn|
    next 1 if pkmn.hasItem?(:LUSTROUSORB)
    next
  }
})

MultipleForms.register(:GIRATINA,{
  "getPrimalForm" => proc { |pkmn|
    next 2 if pkmn.hasItem?(:DEVIANTORB)
    next
  }
})

class PokeBattle_Battler
  def pbCheckFormOnWeatherChange
    return if fainted? || @effects[PBEffects::Transform] || (!isSpecies?(:ALTEMPER) && !isSpecies?(:CASTFORM) && !isSpecies?(:CHERRIM))
    # Castform - Forecast
      if isSpecies?(:CASTFORM)
        if self.ability == :FORECAST
          newForm = 0
          case @battle.pbWeather
          when :Fog then                        newForm = 4
          when :Overcast then                   newForm = 5
          when :Starstorm then   			        	newForm = 6
          when :DClear then 				          	newForm = 6
          when :Eclipse then                    newForm = 7
          when :Windy then                      newForm = 8
          when :HeatLight then                  newForm = 9
          when :StrongWinds then                newForm = 10
          when :AcidRain then                   newForm = 11
          when :Sandstorm then                  newForm = 12
          when :Rainbow then                    newForm = 13
          when :DustDevil then                  newForm = 14
          when :DAshfall then                   newForm = 15
          when :VolcanicAsh then                newForm = 16
          when :Borealis then                   newForm = 17
          when :Humid then                      newForm = 18
          when :TimeWarp then                   newForm = 19
          when :Reverb then                     newForm = 20
          when :Sun, :HarshSun then             newForm = 1
          when :Rain, :Storm, :HeavyRain then   newForm = 2
          when :Hail, :Sleet then               newForm = 3
          end
          if @form!=newForm
            @battle.pbShowAbilitySplash(self,true)
            @battle.pbHideAbilitySplash(self)
            pbChangeForm(newForm,_INTL("{1} transformed!",pbThis))
          end
        else
          pbChangeForm(0,_INTL("{1} transformed!",pbThis))
      end
    end
        if isSpecies?(:ALTEMPER)
          if self.ability == :BAROMETRIC
            newForm = 0
            case @battle.pbWeather
            when :Fog then                        newForm = 4
            when :Overcast then                   newForm = 5
            when :Starstorm then   			        	newForm = 6
            when :DClear then 				          	newForm = 6
            when :Eclipse then                    newForm = 7
            when :Windy then                      newForm = 8
            when :HeatLight then                  newForm = 9
            when :StrongWinds then                newForm = 10
            when :AcidRain then                   newForm = 11
            when :Sandstorm then                  newForm = 12
            when :Rainbow then                    newForm = 13
            when :DustDevil then                  newForm = 14
            when :DAshfall then                   newForm = 15
            when :VolcanicAsh then                newForm = 16
            when :Borealis then                   newForm = 17
            when :Humid then                      newForm = 18
            when :TimeWarp then                   newForm = 19
            when :Reverb then                     newForm = 20
            when :Sun, :HarshSun then             newForm = 1
            when :Rain, :Storm, :HeavyRain then   newForm = 2
            when :Hail, :Sleet then               newForm = 3
            end
              if @form >= 21
                if @form >= 42
                  newForm += 42
                else
                  newForm += 21
                end
              end
            case newForm
            when 4 then                       self.effects[PBEffects::Type3] = :FAIRY
            when 0 then                       self.effects[PBEffects::Type3] = :NORMAL
            when 5 then                       self.effects[PBEffects::Type3] = :GHOST
            when 7 then                       self.effects[PBEffects::Type3] = :DARK
            when 8 then                       self.effects[PBEffects::Type3] = :FLYING
            when 9 then                       self.effects[PBEffects::Type3] = :ELECTRIC
            when 10 then                      self.effects[PBEffects::Type3] = :DRAGON
            when 11 then                      self.effects[PBEffects::Type3] = :POISON
            when 12 then                      self.effects[PBEffects::Type3] = :ROCK
            when 13 then                      self.effects[PBEffects::Type3] = :GRASS
            when 14 then                      self.effects[PBEffects::Type3] = :GROUND
            when 15 then                      self.effects[PBEffects::Type3] = :FIGHTING
            when 16 then                      self.effects[PBEffects::Type3] = :STEEL
            when 17 then                      self.effects[PBEffects::Type3] = :PSYCHIC
            when 18 then                      self.effects[PBEffects::Type3] = :BUG
            when 20 then                      self.effects[PBEffects::Type3] = :SOUND
            when 1 then                       self.effects[PBEffects::Type3] = :FIRE
            when 2 then                       self.effects[PBEffects::Type3] = :WATER
            when 3 then                       self.effects[PBEffects::Type3] = :ICE
            when 25 then                       self.effects[PBEffects::Type3] = :FAIRY
            when 21 then                       self.effects[PBEffects::Type3] = :NORMAL
            when 26 then                       self.effects[PBEffects::Type3] = :GHOST
            when 28 then                       self.effects[PBEffects::Type3] = :DARK
            when 29 then                       self.effects[PBEffects::Type3] = :FLYING
            when 30 then                       self.effects[PBEffects::Type3] = :ELECTRIC
            when 31 then                      self.effects[PBEffects::Type3] = :DRAGON
            when 32 then                      self.effects[PBEffects::Type3] = :POISON
            when 33 then                      self.effects[PBEffects::Type3] = :ROCK
            when 34 then                      self.effects[PBEffects::Type3] = :GRASS
            when 35 then                      self.effects[PBEffects::Type3] = :GROUND
            when 36 then                      self.effects[PBEffects::Type3] = :FIGHTING
            when 37 then                      self.effects[PBEffects::Type3] = :STEEL
            when 38 then                      self.effects[PBEffects::Type3] = :PSYCHIC
            when 39 then                      self.effects[PBEffects::Type3] = :BUG
            when 41 then                      self.effects[PBEffects::Type3] = :SOUND
            when 22 then                       self.effects[PBEffects::Type3] = :FIRE
            when 23 then                       self.effects[PBEffects::Type3] = :WATER
            when 24 then                       self.effects[PBEffects::Type3] = :ICE
            end
            if @form!=newForm
              @battle.pbShowAbilitySplash(self,true)
              @battle.pbHideAbilitySplash(self)
              pbChangeForm(newForm,_INTL("{1} transformed!",pbThis))
            end
          else
          pbChangeForm(0,_INTL("{1} transformed!",pbThis))
        end
      end
    # Cherrim - Flower Gift
    if isSpecies?(:CHERRIM)
      if self.ability == :FLOWERGIFT
        newForm = 0
        case @battle.pbWeather
        when :Sun, :HarshSun, :Rainbow then newForm = 1
        end
        if @form!=newForm
          @battle.pbShowAbilitySplash(self,true)
          @battle.pbHideAbilitySplash(self)
          pbChangeForm(newForm,_INTL("{1} transformed!",pbThis))
        end
      else
        pbChangeForm(0,_INTL("{1} transformed!",pbThis))
      end
    end
  end
end

class PokeBattle_Move_087 < PokeBattle_Move
  def pbBaseDamage(baseDmg,user,target)
    baseDmg *= 2 if @battle.pbWeather != :None
    return baseDmg
  end

  def pbBaseType(user)
    ret = :NORMAL
    case @battle.pbWeather
    when :Sun, :HarshSun
      ret = :FIRE if GameData::Type.exists?(:FIRE)
    when :Rain, :HeavyRain, :Storm
      ret = :WATER if GameData::Type.exists?(:WATER)
    when :Sandstorm
      ret = :ROCK if GameData::Type.exists?(:ROCK)
    when :Hail, :Sleet
      ret = :ICE if GameData::Type.exists?(:ICE)
    when :Starstorm
      ret = :COSMIC if GameData::Type.exists?(:COSMIC)
    when :Fog
      ret = :FAIRY if GameData::Type.exists?(:FAIRY)
    when :Humid
      ret = :BUG if GameData::Type.exists?(:BUG)
    when :Overcast
      ret = :GHOST if GameData::Type.exists?(:GHOST)
    when :Eclipse
      ret = :DARK if GameData::Type.exists?(:DARK)
    when :Windy
      ret = :FLYING if GameData::Type.exists?(:FLYING)
    when :HeatLight
      ret = :ELECTRIC if GameData::Type.exists?(:ELECTRIC)
    when :AcidRain
      ret = :POISON if GameData::Type.exists?(:POISON)
    when :StrongWinds
      ret = :DRAGON if GameData::Type.exists?(:DRAGON)
    when :Rainbow
      ret = :GRASS if GameData::Type.exists?(:GRASS)
    when :DustDevil
      ret = :GROUND if GameData::Type.exists?(:GROUND)
    when :DAshfall
      ret = :FIGHTING if GameData::Type.exists?(:FIGHTING)
    when :VolcanicAsh
      ret = :STEEL if GameData::Type.exists?(:STEEL)
    when :Borealis
      ret = :PSYCHIC if GameData::Type.exists?(:PSYCHIC)
    when :TimeWarp
      ret = :TIME if GameData::Type.exists?(:TIME)
    when :Reverb
      ret = :SOUND if GameData::Type.exists?(:SOUND)
    end
    return ret
  end

  def pbShowAnimation(id,user,targets,hitNum=0,showAnimation=true)
    t = pbBaseType(user)
    hitNum = 1 if t == :FIRE   # Type-specific anims
    hitNum = 2 if t == :WATER
    hitNum = 3 if t == :ROCK
    hitNum = 4 if t == :ICE
    super
  end
end

BattleHandlers::EORWeatherAbility.add(:ACCLIMATE,
  proc { |ability,weather,battler,battle|
    next if battler.fainted?
    newWeather = 0
    oldWeather = battle.pbWeather
    newForm = battler.form
    if newForm >= 21
      if newForm >= 42
        newForm -= 42
      else
        newForm -= 21
      end
    end
    newWeather = newForm
    battle.eachOtherSideBattler(battler.index) do |b|
      type1 = b.type1
      type2 = b.type2
      case type1
      when :NORMAL
        case type2
        when :GHOST, :PSYCHIC, :TIME; newWeather = 7
        when :FAIRY; newWeather = 16
        when :FLYING, :SOUND; newWeather = 3
        when :BUG; newWeather = 1
        when :NORMAL,:FIGHTING,:POISON,:GROUND,:ROCK,:STEEL,:FIRE,:WATER,:GRASS,:ELECTRIC,:ICE,:DRAGON,:DARK,:COSMIC, type1; newWeather = 15
        end
      when :FIGHTING
        case type2
        when :POISON, :COSMIC; newWeather = 17
        when :STEEL; newWeather = 20
        when :FLYING, :FIRE; newWeather = 19
        when :NORMAL,:FIGHTING,:GROUND,:ROCK,:BUG,:GHOST,:WATER,:GRASS,:ELECTRIC,:PSYCHIC,:ICE,:DRAGON,:DARK,:FAIRY,:TIME,:SOUND, type1; newWeather = 4
        end
      when :FLYING
        case type2
        when :GROUND, :DRAGON, :SOUND, :COSMIC, :GHOST; newWeather = 3
        when :FIRE, :ICE, :ROCK, :POISON, :BUG; newWeather = 12
        when :NORMAL,:FIGHTING,:STEEL,:WATER,:GRASS,:ELECTRIC,:PSYCHIC,:DARK,:FAIRY,:TIME, type1; newWeather = 20
        end
      when :ROCK
        case type2
        when :ICE, :DARK; newWeather = 15
        when :FLYING, :BUG, :GRASS, :TIME, :FAIRY; newWeather = 16
        when :WATER, :GROUND, :SOUND; newWeather = 13
        when :FIRE; newWeather = 2
        when :COSMIC; newWeather = 19
        when :NORMAL, :FIGHTING, :POISON, :GHOST, :STEEL, :ELECTRIC, :DRAGON, :PSYCHIC, type1; newWeather = 14
        end
      when :GROUND
        case type2
        when :WATER, :ROCK, :ELECTRIC, type1; newWeather = 13
        when :DRAGON, :FLYING, :SOUND, :GRASS; newWeather = 3
        when :COSMIC; newWeather = 17
        when :TIME; newWeather = 5
        when :NORMAL,:FIGHTING,:POISON,:BUG,:GHOST,:STEEL,:FIRE,:PSYCHIC,:ICE,:DARK,:FAIRY; newWeather = 2
        end
      when :POISON
        case type2
        when :DARK, :STEEL, :ELECTRIC, :ROCK, :FIRE; newWeather = 14
        when :TIME, :PSYCHIC, :GHOST; newWeather = 7
        when :SOUND, :BUG, :ICE, :FLYING; newWeather = 12
        when :NORMAL,:FIGHTING,:POISON,:GROUND,:WATER,:GRASS,:DRAGON,:FAIRY,:COSMIC, type1; newWeather = 17
        end
      when :BUG
        case type2
        when :GROUND, :WATER, :FIGHTING; newWeather = 8
        when :GRASS, :STEEL, :COSMIC; newWeather = 1
        when :TIME; newWeather = 16
        when :NORMAL,:FLYING,:POISON,:ROCK,:GHOST,:FIRE,:ELECTRIC,:PSYCHIC,:ICE,:DRAGON,:DARK,:FAIRY,:SOUND, type1; newWeather = 12
        end
      when :GHOST
        case type2
        when :FIGHTING, :DARK; newWeather = 4
        when :FAIRY; newWeather = 16
        when :BUG; newWeather = 1
        when :NORMAL,:FLYING,:POISON,:GROUND,:ROCK,:STEEL,:FIRE,:WATER,:GRASS,:ELECTRIC,:PSYCHIC,:ICE,:DRAGON,:COSMIC,:TIME,:SOUND, type1; newWeather = 7
        end
      when :STEEL
        case type2
        when :WATER; newWeather = 9
        when :TIME, :GROUND; newWeather = 20
        when :FIRE, :ROCK; newWeather = 14
        when :DARK, :NORMAL; newWeather = 15
        when :DRAGON, :SOUND; newWeather = 6
        when :FLYING,:POISON,:BUG,:GHOST,:STEEL,:GRASS,:ELECTRIC,:PSYCHIC,:ICE,:FAIRY,:COSMIC, type1; newWeather = 1
        end
      when :GRASS
        case type2
        when :STEEL, :COSMIC, :ICE; newWeather = 1
        when :TIME, :FAIRY, :SOUND; newWeather = 11
        when :DRAGON, :GROUND, :FLYING, :ELECTRIC; newWeather = 3
        when :DARK, :PSYCHIC; newWeather = 18
        when :ROCK; newWeather = 16
        when :NORMAL, :FIGHTING, :POISON, :BUG, :GHOST, :FIRE, :WATER, type1; newWeather = 8
        end
      when :FIRE
        case type2
        when :GRASS; newWeather = 8
        when :WATER; newWeather = 9
        when :COSMIC, :ROCK, :FIGHTING, :FLYING; newWeather = 19
        when :DRAGON, :ELECTRIC, :TIME; newWeather = 14
        when :SOUND; newWeather = 12
        when :NORMAL,:POISON,:GROUND,:BUG,:GHOST,:STEEL,:FIRE,:PSYCHIC,:ICE,:DARK,:FAIRY, type1; newWeather = 2
        end
      when :WATER
        case type2
        when :FIRE, :FLYING; newWeather = 9
        when :GHOST; newWeather = 7
        when :GROUND, :ROCK; newWeather = 13
        when :PSYCHIC, :TIME; newWeather = 20
        when :NORMAL,:FIGHTING,:POISON,:BUG,:STEEL,:GRASS,:ELECTRIC,:ICE,:DRAGON,:DARK,:FAIRY,:COSMIC,:SOUND, type1; newWeather = 6
        end
      when :ELECTRIC
        case type2
        when :FLYING, :GRASS; newWeather = 3
        when :TIME,:WATER; newWeather = 20
        when :BUG,:ICE; newWeather = 1
        when :NORMAL,:FIGHTING,:POISON,:GROUND,:ROCK,:GHOST,:STEEL,:FIRE,:PSYCHIC,:DRAGON,:DARK,:FAIRY,:COSMIC,:SOUND, type1; newWeather = 14
        end
      when :ICE
        case type2
        when :GHOST, :PSYCHIC, :TIME, :FAIRY, :ROCK, type1; newWeather = 16
        when :SOUND, :FIRE, :FLYING, :POISON; newWeather = 12
        when :GRASS, :BUG, :STEEL, :COSMIC; newWeather = 1
        when :NORMAL, :FIGHTING, :GROUND, :WATER, :DRAGON, :ELECTRIC, :DARK; newWeather = 15
        end
      when :PSYCHIC
        case type2
        when :DARK, :GRASS; newWeather = 18
        when :FLYING, :WATER; newWeather = 20
        when :FIGHTING; newWeather = 19
        when :SOUND; newWeather = 5
        when :ICE, :FAIRY; newWeather = 16
        when :NORMAL,:POISON,:GROUND,:ROCK,:BUG,:GHOST,:STEEL,:FIRE,:ELECTRIC,:DRAGON,:COSMIC,:TIME, type1; newWeather = 7
        end
      when :DRAGON
        case type2
        when :SOUND, :GROUND, :FLYING, :GRASS; newWeather = 3
        when :DARK, :FIGHTING, :TIME, type1; newWeather = 4
        when :FIRE; newWeather = 12
        when :PSYCHIC; newWeather = 7
        when :NORMAL,:POISON,:ROCK,:BUG,:GHOST,:STEEL,:WATER,:ELECTRIC,:ICE,:DRAGON,:FAIRY,:COSMIC; newWeather = 6
        end
      when :DARK
        case type2
        when :NORMAL,:FIGHTING,:FLYING,:GROUND,:BUG,:GHOST,:WATER,:ELECTRIC,:DRAGON,:FAIRY,:TIME,:SOUND,type1; newWeather = 4
        when :POISON,:FIRE; newWeather = 14
        when :GRASS,:PSYCHIC,:COSMIC; newWeather = 18
        when :ROCK,:STEEL,:ICE; newWeather = 15
        end
      when :FAIRY
        case type2
        when :FIRE; newWeather = 12
        when :COSMIC; newWeather = 1
        when :GRASS, :SOUND, :TIME; newWeather = 11
        when :ROCK, :ICE; newWeather = 16
        when :NORMAL,:FIGHTING,:FLYING,:POISON,:GROUND,:BUG,:STEEL,:WATER,:GRASS,:ELECTRIC,:DRAGON,:DARK, type1; newWeather = 6
        end
      when :COSMIC
        case type2
        when :GROUND, :SOUND; newWeather = 3
        when :GHOST, :TIME; newWeather = 7
        when :POISON, :FIGHTING; newWeather = 17
        when :DRAGON then newWeather = 6
        when :ICE, :GRASS, :BUG, :STEEL, :FAIRY; newWeather = 1
        when :NORMAL,:FLYING,:ROCK,:FIRE,:WATER,:ELECTRIC,:PSYCHIC, type1; newWeather = 19
        end
      when :TIME
        case type2
        when :NORMAL, :DARK, :SOUND, :GRASS, :FAIRY; newWeather = 11
        when :GHOST, :ROCK, :ICE, :COSMIC; newWeather = 7
        when :FIGHTING,:FLYING,:POISON,:GROUND,:BUG,:STEEL,:FIRE,:WATER,:ELECTRIC,:PSYCHIC,:DRAGON, type1; newWeather = 20
        end
      when :SOUND
        case type2
        when :GROUND, :FLYING, :GRASS, :DRAGON, :COSMIC; newWeather = 3
        when :POISON, :ROCK, :STEEL; newWeather = 14
        when :GHOST; newWeather = 7
        when :TIME; newWeather = 5
        when :WATER; newWeather = 6
        when :FIGHTING; newWeather = 11
        when :NORMAL,:BUG,:GHOST,:FIRE,:ELECTRIC,:PSYCHIC,:ICE,:DRAGON,:DARK,:FAIRY, type1; newWeather = 12
        end
      end
    end
  if newWeather==newForm
    weatherChange = battle.pbWeather
  else
    case newWeather
    when 1 then weatherChange = :Sun  if weather != :Sun
    when 2 then weatherChange = :Rain  if weather != :Rain
    when 3 then weatherChange = :Sleet  if weather != :Sleet
    when 4 then weatherChange = :Fog  if weather != :Fog
    when 5 then weatherChange = :Overcast  if weather != :Overcast
    when 6 then weatherChange = :Starstorm  if weather != :Starstorm
    when 7 then weatherChange = :Eclipse  if weather != :Eclipse
    when 8 then weatherChange = :Windy  if weather != :Windy
    when 9 then weatherChange = :HeatLight  if weather != :HeatLight
    when 10 then weatherChange = :StrongWinds  if weather != :StrongWinds
    when 11 then weatherChange = :AcidRain  if weather != :AcidRain
    when 12 then weatherChange = :Sandstorm  if weather != :Sandstorm
    when 13 then weatherChange = :Rainbow  if weather != :Rainbow
    when 14 then weatherChange = :DustDevil  if weather != :DustDevil
    when 15 then weatherChange = :DAshfall  if weather != :DAshfall
    when 16 then weatherChange = :VolcanicAsh  if weather != :VolcanicAsh
    when 17 then weatherChange = :Borealis  if weather != :Borealis
    when 18 then weatherChange = :Humid  if weather != :Humid
    when 19 then weatherChange = :TimeWarp  if weather != :TimeWarp
    when 20 then weatherChange = :Reverb  if weather != :Reverb
    end
    battle.pbShowAbilitySplash(battler)
    battle.field.weather = weatherChange
    battle.field.weatherDuration = 5
    case weatherChange
    when :Starstorm then   battle.pbDisplay(_INTL("Stars fill the sky."))
    when :Thunder then     battle.pbDisplay(_INTL("Lightning flashes in th sky."))
    when :Humid then       battle.pbDisplay(_INTL("The air is humid."))
    when :Overcast then    battle.pbDisplay(_INTL("The sky is overcast."))
    when :Eclipse then     battle.pbDisplay(_INTL("The sky is dark."))
    when :Fog then         battle.pbDisplay(_INTL("The fog is deep."))
    when :AcidRain then    battle.pbDisplay(_INTL("Acid rain is falling."))
    when :VolcanicAsh then battle.pbDisplay(_INTL("Volcanic Ash sprinkles down."))
    when :Rainbow then     battle.pbDisplay(_INTL("A rainbow crosses the sky."))
    when :Borealis then    battle.pbDisplay(_INTL("The sky is ablaze with color."))
    when :TimeWarp then    battle.pbDisplay(_INTL("Time has stopped."))
    when :Reverb then      battle.pbDisplay(_INTL("A dull echo hums."))
    when :DClear then      battle.pbDisplay(_INTL("The sky is distorted."))
    when :DRain then       battle.pbDisplay(_INTL("Rain is falling upward."))
    when :DWind then       battle.pbDisplay(_INTL("The wind is haunting."))
    when :DAshfall then    battle.pbDisplay(_INTL("Ash floats in midair."))
    when :Sleet then       battle.pbDisplay(_INTL("Sleet began to fall."))
    when :Windy then       battle.pbDisplay(_INTL("There is a slight breeze."))
    when :HeatLight then   battle.pbDisplay(_INTL("Static fills the air."))
    when :DustDevil then   battle.pbDisplay(_INTL("A dust devil approaches."))
    when :Sun then         battle.pbDisplay(_INTL("The sunlight is strong."))
    when :Rain then        battle.pbDisplay(_INTL("It is raining."))
    when :Sandstorm then   battle.pbDisplay(_INTL("A sandstorm is raging."))
    when :Hail then        battle.pbDisplay(_INTL("Hail is falling."))
    when :HarshSun then    battle.pbDisplay(_INTL("The sunlight is extremely harsh."))
    when :HeavyRain then   battle.pbDisplay(_INTL("It is raining heavily."))
    when :StrongWinds then battle.pbDisplay(_INTL("The wind is strong."))
    when :ShadowSky then   battle.pbDisplay(_INTL("The sky is shadowy."))
    end
    newForm = newWeather
    case newForm
    when 4 then                       battler.effects[PBEffects::Type3] = :FAIRY
    when 0 then                       battler.effects[PBEffects::Type3] = :NORMAL
    when 5 then                       battler.effects[PBEffects::Type3] = :GHOST
    when 7 then                       battler.effects[PBEffects::Type3] = :DARK
    when 8 then                       battler.effects[PBEffects::Type3] = :FLYING
    when 9 then                       battler.effects[PBEffects::Type3] = :ELECTRIC
    when 10 then                      battler.effects[PBEffects::Type3] = :DRAGON
    when 11 then                      battler.effects[PBEffects::Type3] = :POISON
    when 12 then                      battler.effects[PBEffects::Type3] = :ROCK
    when 13 then                      battler.effects[PBEffects::Type3] = :GRASS
    when 14 then                      battler.effects[PBEffects::Type3] = :GROUND
    when 15 then                      battler.effects[PBEffects::Type3] = :FIGHTING
    when 16 then                      battler.effects[PBEffects::Type3] = :STEEL
    when 17 then                      battler.effects[PBEffects::Type3] = :PSYCHIC
    when 18 then                      battler.effects[PBEffects::Type3] = :BUG
    when 20 then                      battler.effects[PBEffects::Type3] = :SOUND
    when 1 then                       battler.effects[PBEffects::Type3] = :FIRE
    when 2 then                       battler.effects[PBEffects::Type3] = :WATER
    when 3 then                       battler.effects[PBEffects::Type3] = :ICE
    end
  end
    if battler.form >= 21 && battler.isSpecies?(:ALTEMPER)
      if battler.form >= 42 && battler.isSpecies?(:ALTEMPER)
        newForm += 42
      else
        newForm += 21
      end
    end
    if battler.form != newForm
      battler.pbChangeForm(newForm,_INTL("{1} transformed!",battler.pbThis))
    end
    oldWeather = weatherChange
    battle.pbHideAbilitySplash(battler)
    battle.eachBattler { |b| b.pbCheckFormOnWeatherChange }
  }
)

BattleHandlers::EORWeatherAbility.copy(:ACCLIMATE,:BAROMETRIC)

BattleHandlers::EORHealingAbility.add(:RESURGENCE,
  proc { |ability,battler,battle|
    next if !battler.canHeal?
    battle.pbShowAbilitySplash(battler)
    battler.pbRecoverHP(battler.totalhp/16)
    if PokeBattle_SceneConstants::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("{1}'s HP was restored.",battler.pbThis))
    else
      battle.pbDisplay(_INTL("{1}'s {2} restored its HP.",battler.pbThis,battler.abilityName))
    end
    battle.pbHideAbilitySplash(battler)
  }
)

BattleHandlers::EORHealingAbility.add(:ASPIRANT,
  proc { |ability,battler,battle|
    wishHeal = $game_variables[103]
    $game_variables[101] -= 1
    if $game_variables[101]==0
      wishMaker = $game_variables[102]
      battler.pbRecoverHP(wishHeal)
      battle.pbDisplay(_INTL("{1}'s wish came true!",wishMaker))
    end
    next if $game_variables[101]>0
    if $game_variables[101]<0
      battle.pbShowAbilitySplash(battler)
      if PokeBattle_SceneConstants::USE_ABILITY_SPLASH
        $game_variables[103] = (battler.totalhp/2)
        $game_variables[102] = battler.pbThis
        $game_variables[101] += 2
        battle.pbDisplay(_INTL("{1} made a wish!",battler.pbThis))
      else
        battle.pbDisplay(_INTL("{1} made a wish with {2}",battler.pbThis,battler.abilityName))
      end
    end
    battle.pbHideAbilitySplash(battler)
  }
)

BattleHandlers::EORHealingAbility.add(:HOPEFULTOLL,
  proc { |ability,battler,battle|
    battler.status = 0
    def pbAromatherapyHeal(pkmn,battler=nil)
      oldStatus = (battler) ? battler.status : pkmn.status
      curedName = (battler) ? battler.pbThis : pkmn.name
      if battler
        battler.pbCureStatus(false)
      else
        pkmn.status      = 0
        pkmn.statusCount = 0
      end
    end
    battle.pbShowAbilitySplash(battler)
    if PokeBattle_SceneConstants::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("{1} rang a healing bell!",battler.pbThis))
    else
      battle.pbDisplay(_INTL("{1} sounded a {2}",battler.pbThis,battler.abilityName))
    end
    battle.pbParty(battler.index).each_with_index do |pkmn,i|
      next if !pkmn || !pkmn.able? || pkmn.status==0
      pkmn.status = 0
    end
    battle.pbHideAbilitySplash(battler)
  }
)

BattleHandlers::EORWeatherAbility.add(:ACIDDRAIN,
  proc { |ability,weather,battler,battle|
    next unless weather==:AcidRain
    next if !battler.canHeal?
    battle.pbShowAbilitySplash(battler)
    battler.pbRecoverHP(battler.totalhp/16)
    if PokeBattle_SceneConstants::USE_ABILITY_SPLASH
      battle.pbDisplay(_INTL("{1}'s HP was restored.",battler.pbThis))
    else
      battle.pbDisplay(_INTL("{1}'s {2} restored its HP.",battler.pbThis,battler.abilityName))
    end
    battle.pbHideAbilitySplash(battler)
  }
)

BattleHandlers::EORWeatherAbility.copy(:POISONHEAL,:ACIDDRAIN)

BattleHandlers::AbilityOnSwitchIn.add(:GAIAFORCE,
  proc { |ability,battler,battle|
    battle.pbShowAbilitySplash(battler)
    battle.pbDisplay(_INTL("{1} is gathering power from the earth!",battler.pbThis))
    battle.pbHideAbilitySplash(battler)
  }
)

BattleHandlers::AbilityOnSwitchIn.add(:DUAT,
  proc { |ability,battler,battle|
    battler.effects[PBEffects::Type3] = :TIME
    battle.pbShowAbilitySplash(battler)
    battle.pbDisplay(_INTL("{1} is shrouded in the Duat!",battler.pbThis))
    battle.pbHideAbilitySplash(battler)
  }
)

BattleHandlers::AbilityOnSwitchIn.add(:SHADOWGUARD,
  proc { |ability,battler,battle|
    battler.effects[PBEffects::Type3] = :DARK
    battle.pbShowAbilitySplash(battler)
    battle.pbDisplay(_INTL("{1} is shrouded in the shadows!",battler.pbThis))
    battle.pbHideAbilitySplash(battler)
  }
)

BattleHandlers::AbilityOnSwitchIn.add(:EQUINOX,
  proc { |ability,battler,battle|
    pbBattleWeatherAbility(:Starstorm, battler, battle)
  }
)

BattleHandlers::AbilityOnSwitchIn.add(:URBANCLOUD,
  proc { |ability,battler,battle|
    pbBattleWeatherAbility(:AcidRain, battler, battle)
  }
)

BattleHandlers::AbilityOnSwitchIn.add(:FIGHTERSWRATH,
  proc { |ability,battler,battle|
    pbBattleWeatherAbility(:DAshfall, battler, battle)
  }
)

BattleHandlers::AbilityOnSwitchIn.add(:MUGGYAIR,
  proc { |ability,battler,battle|
    pbBattleWeatherAbility(:Humid, battler, battle)
  }
)

BattleHandlers::AbilityOnSwitchIn.add(:ELECTROSTATIC,
  proc { |ability,battler,battle|
    pbBattleWeatherAbility(:HeatLight, battler, battle)
  }
)

BattleHandlers::AbilityOnSwitchIn.add(:FLOWERGIFT,
  proc { |ability,battler,battle|
    pbBattleWeatherAbility(:Rainbow, battler, battle)
    #battler.pbChangeForm(1,_INTL("{1} transformed!",battler.name))
  }
)

BattleHandlers::AbilityOnSwitchIn.add(:RAGINGSEA,
  proc { |ability,battler,battle|
    pbBattleWeatherAbility(:Storm, battler, battle)
  }
)

BattleHandlers::AbilityOnSwitchIn.add(:DESERTSTORM,
  proc { |ability,battler,battle|
    pbBattleWeatherAbility(:DustDevil, battler, battle)
  }
)

BattleHandlers::AbilityOnSwitchIn.add(:ASHCOVER,
  proc { |ability,battler,battle|
    pbBattleWeatherAbility(:VolcanicAsh, battler, battle)
  }
)

BattleHandlers::AbilityOnSwitchIn.add(:NIGHTFALL,
  proc { |ability,battler,battle|
    pbBattleWeatherAbility(:Eclipse, battler, battle)
  }
)

BattleHandlers::AbilityOnSwitchIn.add(:SHROUD,
  proc { |ability,battler,battle|
    pbBattleWeatherAbility(:Fog, battler, battle)
  }
)

BattleHandlers::AbilityOnSwitchIn.add(:BOREALIS,
  proc { |ability,battler,battle|
    pbBattleWeatherAbility(:Borealis, battler, battle)
  }
)

BattleHandlers::AbilityOnSwitchIn.add(:HAILSTORM,
  proc { |ability,battler,battle|
    pbBattleWeatherAbility(:Sleet, battler, battle)
  }
)

BattleHandlers::AbilityOnSwitchIn.add(:CLOUDCOVER,
  proc { |ability,battler,battle|
    pbBattleWeatherAbility(:Overcast, battler, battle)
  }
)

BattleHandlers::DamageCalcUserAbility.add(:WINDRAGE,
  proc { |ability,user,target,move,mults,baseDmg,type|
    if (user.battle.pbWeather == :Windy || user.battle.pbWeather == :StrongWinds) &&
       [:FLYING, :DRAGON].include?(type)
      mults[:base_damage_multiplier] *= 1.3
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:SOOTSURGE,
  proc { |ability,user,target,move,mults,baseDmg,type|
    if (user.battle.pbWeather == :VolcanicAsh || user.battle.pbWeather == :DAshfall) &&
       [:STEEL, :FIGHTING].include?(type)
      mults[:base_damage_multiplier] *= 1.3
    end
  }
)

BattleHandlers::AbilityOnSwitchIn.add(:TOXICSURGE,
  proc { |ability,battler,battle|
    next if battle.field.terrain == :Poison
    battle.pbShowAbilitySplash(battler)
    battle.pbStartTerrain(battler, :Poison)
    # NOTE: The ability splash is hidden again in def pbStartTerrain.
  }
)

BattleHandlers::AbilityOnSwitchIn.add(:GALEFORCE,
  proc { |ability,battler,battle|
    pbBattleWeatherAbility(:Windy, battler, battle)
  }
)

BattleHandlers::AbilityOnSwitchIn.add(:PINDROP,
  proc { |ability,battler,battle|
    pbBattleWeatherAbility(:Reverb, battler, battle)
  }
)

BattleHandlers::AbilityOnSwitchIn.add(:WORMHOLE,
  proc { |ability,battler,battle|
    pbBattleWeatherAbility(:TimeWarp, battler, battle)
  }
)

BattleHandlers::AbilityOnSwitchIn.add(:MINDGAMES,
  proc { |ability,battler,battle|
    battle.pbShowAbilitySplash(battler)
    battle.eachOtherSideBattler(battler.index) do |b|
      next if !b.near?(battler)
      b.pbLowerSpAtkStatStageMindGames(battler)
      b.pbItemOnIntimidatedCheck
    end
    battle.pbHideAbilitySplash(battler)
  }
)

BattleHandlers::AbilityOnSwitchIn.add(:MEDUSOID,
  proc { |ability,battler,battle|
    battle.pbShowAbilitySplash(battler)
    battle.eachOtherSideBattler(battler.index) do |b|
      next if !b.near?(battler)
      b.pbLowerSpeedStatStageMedusoid(battler)
      b.pbItemOnIntimidatedCheck
    end
    battle.pbHideAbilitySplash(battler)
  }
)

BattleHandlers::AbilityOnSwitchIn.add(:DIMENSIONSHIFT,
  proc { |ability,battler,battle|
    battle.pbShowAbilitySplash(battler)
    if battle.field.effects[PBEffects::TrickRoom] > 0
      battle.field.effects[PBEffects::TrickRoom] = 0
      battle.pbDisplay(_INTL("{1} reverted the dimensions!",battler.pbThis))
    end
    if battle.field.weather == :TimeWarp
      battle.field.effects[PBEffects::TrickRoom] = 7
      battle.pbDisplay(_INTL("{1} twisted the dimensions!",battler.pbThis))
    else
      battle.field.effects[PBEffects::TrickRoom] = 5
      battle.pbDisplay(_INTL("{1} twisted the dimensions!",battler.pbThis))
    end
    battle.pbHideAbilitySplash(battler)
  }
)

BattleHandlers::AbilityOnSwitchIn.add(:CACOPHONY,
  proc { |ability,battler,battle|
    battle.pbShowAbilitySplash(battler)
    battle.pbDisplay(_INTL("{1} is creating an uproar!",battler.pbThis))
    battle.pbHideAbilitySplash(battler)
  }
)

BattleHandlers::DamageCalcUserAbility.add(:FLOWERGIFT,
  proc { |ability,user,target,move,mults,baseDmg,type|
    if move.specialMove? && [:Sun, :HarshSun].include?(user.battle.pbWeather)
      mults[:attack_multiplier] *= 1.5
    end
  }
)

BattleHandlers::DamageCalcUserAllyAbility.add(:FLOWERGIFT,
  proc { |ability,user,target,move,mults,baseDmg,type|
    if move.specialMove? && [:Sun, :HarshSun].include?(user.battle.pbWeather)
      mults[:attack_multiplier] *= 1.5
    end
  }
)

BattleHandlers::DamageCalcTargetAbility.add(:FLOWERGIFT,
  proc { |ability,user,target,move,mults,baseDmg,type|
    if [:Sun, :HarshSun].include?(user.battle.pbWeather)
      mults[:defense_multiplier] *= 1.5
    end
  }
)
#===================================
# Item Scripts
#===================================
module ItemHandlers
  def pbRaiseEffortValues(pkmn, stat, evGain = 10, ev_limit = true)
    stat = GameData::Stat.get(stat).id
    return 0 if ev_limit && pkmn.ev[stat] >= 252
    evTotal = 0
    GameData::Stat.each_main { |s| evTotal += pkmn.ev[s.id] }
    evGain = evGain.clamp(0, Pokemon::EV_STAT_LIMIT - pkmn.ev[stat])
    evGain = evGain.clamp(0, 252 - pkmn.ev[stat]) if ev_limit
    evGain = evGain.clamp(0, Pokemon::EV_LIMIT - evTotal)
    if evGain > 0
      pkmn.ev[stat] += evGain
      pkmn.calc_stats
    end
    return evGain
  end

  def pbRaiseHappinessAndLowerEV(pkmn,scene,stat,messages)
    h = pkmn.happiness<255
    e = pkmn.ev[stat]>0
    if !h && !e
      scene.pbDisplay(_INTL("It won't have any effect."))
      return false
    end
    if h
      pkmn.changeHappiness("evberry")
    end
    if e
      pkmn.ev[stat] = 0
      pkmn.calc_stats
    end
    scene.pbRefresh
    scene.pbDisplay(messages[2-(h ? 0 : 2)-(e ? 0 : 1)])
    return true
  end
end
def canUseMoveCut?
  showmsg = true
   return false if !$PokemonBag.pbHasItem?(:CHAINSAW)
   facingEvent = $game_player.pbFacingEvent
   if !facingEvent || !facingEvent.name[/cuttree/i]
     pbMessage(_INTL("Can't use that here.")) if showmsg
     return false
   end
   return true
end

def useMoveCut
  if !pbHiddenMoveAnimation(nil)
    pbMessage(_INTL("{1} used a {2}!",$Trainer.name,GameData::Item.get(:CHAINSAW).name))
  end
  facingEvent = $game_player.pbFacingEvent
  if facingEvent
    pbSmashEvent(facingEvent)
  end
  return true
end

def canUseMoveDive?
   showmsg = true
   return false if !$PokemonBag.pbQuantity(:SCUBATANK)==0
   if $PokemonGlobal.diving
     surface_map_id = nil
     GameData::MapMetadata.each do |map_data|
       next if !map_data.dive_map_id || map_data.dive_map_id != $game_map.map_id
       surface_map_id = map_data.id
       break
     end
     if !surface_map_id ||
        !$MapFactory.getTerrainTag(surface_map_id, $game_player.x, $game_player.y).can_dive
       pbMessage(_INTL("Can't use that here.")) if showmsg
       return false
     end
   else
     if !GameData::MapMetadata.exists?($game_map.map_id) ||
        !GameData::MapMetadata.get($game_map.map_id).dive_map_id
       pbMessage(_INTL("Can't use that here.")) if showmsg
       return false
     end
     if !$game_player.terrain_tag.can_dive
       pbMessage(_INTL("Can't use that here.")) if showmsg
       return false
     end
   end
   return true
end
def useMoveDive
  wasdiving = $PokemonGlobal.diving
  if $PokemonGlobal.diving
    dive_map_id = nil
    GameData::MapMetadata.each do |map_data|
      next if !map_data.dive_map_id || map_data.dive_map_id != $game_map.map_id
      dive_map_id = map_data.id
      break
    end
  else
    map_metadata = GameData::MapMetadata.try_get($game_map.map_id)
    dive_map_id = map_metadata.dive_map_id if map_metadata
  end
  return false if !dive_map_id
  if !pbHiddenMoveAnimation(pokemon)
    pbMessage(_INTL("{1} used a {2}!",$Trainer.name,GameData::Item.get(:SCUBATANK).name))
  end
  pbFadeOutIn {
    $game_temp.player_new_map_id    = dive_map_id
    $game_temp.player_new_x         = $game_player.x
    $game_temp.player_new_y         = $game_player.y
    $game_temp.player_new_direction = $game_player.direction
    $PokemonGlobal.surfing = wasdiving
    $PokemonGlobal.diving  = !wasdiving
    pbUpdateVehicle
    $scene.transfer_player(false)
    $game_map.autoplay
    $game_map.refresh
  }
  return true
end

def canUseMoveFlash?
   showmsg = true
   if !GameData::MapMetadata.exists?($game_map.map_id) ||
      !GameData::MapMetadata.get($game_map.map_id).dark_map
     pbMessage(_INTL("Can't use that here.")) if showmsg
     return false
   end
   if $PokemonGlobal.flashUsed
     pbMessage(_INTL("Flash is already being used.")) if showmsg
     return false
   end
   return true
end
def useMoveFlash
  darkness = $PokemonTemp.darknessSprite
  return false if !darkness || darkness.disposed?
  if !pbHiddenMoveAnimation(nil)
    pbMessage(_INTL("{1} used a {2}!",$Trainer.name,GameData::Item.get(:TORCH).name))
  end
  $PokemonGlobal.flashUsed = true
  radiusDiff = 8*20/Graphics.frame_rate
  while darkness.radius<darkness.radiusMax
    Graphics.update
    Input.update
    pbUpdateSceneMap
    darkness.radius += radiusDiff
    darkness.radius = darkness.radiusMax if darkness.radius>darkness.radiusMax
  end
  return true
end

def canUseMoveFly?
  showmsg = true
  if $game_player.pbHasDependentEvents?
    pbMessage(_INTL("It can't be used when you have someone with you.")) if showmsg
    return false
  end
  if !GameData::MapMetadata.exists?($game_map.map_id) ||
     !GameData::MapMetadata.get($game_map.map_id).outdoor_map
    pbMessage(_INTL("Can't use that here.")) if showmsg
    return false
  end
  return true
end

def useMoveFly
  if !$PokemonTemp.flydata
    pbMessage(_INTL("Can't use that here."))
    return false
  end
  pbMessage(_INTL("{1} used the {2}!",$Trainer.name,GameData::Item.get(:WINGSUIT).name))
  pbFadeOutIn {
    $game_temp.player_new_map_id    = $PokemonTemp.flydata[0]
    $game_temp.player_new_x         = $PokemonTemp.flydata[1]
    $game_temp.player_new_y         = $PokemonTemp.flydata[2]
    $game_temp.player_new_direction = 2
    $PokemonTemp.flydata = nil
    $scene.transfer_player
    $game_map.autoplay
    $game_map.refresh
  }
  pbEraseEscapePoint
  return true
end

class PokemonReadyMenu
  def pbStartReadyMenu(moves,items)
    commands = [[],[]]   # Moves, items
    for i in moves
      commands[0].push([i[0], GameData::Move.get(i[0]).name, true, i[1]])
    end
    commands[0].sort! { |a,b| a[1]<=>b[1] }
    for i in items
      commands[1].push([i, GameData::Item.get(i).name, false])
    end
    commands[1].sort! { |a,b| a[1]<=>b[1] }
    @scene.pbStartScene(commands)
    loop do
      command = @scene.pbShowCommands
      break if command==-1
      if command[0]==0   # Use a move
        move = commands[0][command[1]][0]
        user = $Trainer.party[commands[0][command[1]][3]]
        if move == :FLY
          ret = nil
          pbFadeOutInWithUpdate(99999,@scene.sprites) {
            pbHideMenu
            scene = PokemonRegionMap_Scene.new(-1,false)
            screen = PokemonRegionMapScreen.new(scene)
            ret = screen.pbStartFlyScreen
            pbShowMenu if !ret
          }
          if ret
            $PokemonTemp.flydata = ret
            $game_temp.in_menu = false
            pbUseHiddenMove(user,move)
            break
          end
        else
          pbHideMenu
          if pbConfirmUseHiddenMove(user,move)
            $game_temp.in_menu = false
            pbUseHiddenMove(user,move)
            break
          else
            pbShowMenu
          end
        end
      else   # Use an item
        item = commands[1][command[1]][0]
        if item == :WINGSUIT
          if !canUseMoveFly?
            break
          else
          ret = nil
          pbFadeOutInWithUpdate(99999,@scene.sprites) {
            pbHideMenu
            scene = PokemonRegionMap_Scene.new(-1,false)
            screen = PokemonRegionMapScreen.new(scene)
            ret = screen.pbStartFlyScreen
            pbShowMenu if !ret
          }
          if ret
            $PokemonTemp.flydata = ret
            $game_temp.in_menu = false
            useMoveFly
            break
          end
          end
        else
          pbHideMenu
          if ItemHandlers.triggerConfirmUseInField(item)
            $game_temp.in_menu = false
            break if pbUseKeyItemInField(item)
            $game_temp.in_menu = true
          end
          if pbConfirmUseHiddenMove(user,move)
            $game_temp.in_menu = false
            pbUseHiddenMove(user,move)
            break
          else
            pbShowMenu
          end
        end
        pbHideMenu
      end
      pbShowMenu
    end
    @scene.pbEndScene
  end
end

def canUseMoveRockSmash?
  showmsg = true
  return false if !$PokemonBag.pbQuantity(:HAMMER)==0
  facingEvent = $game_player.pbFacingEvent
  if !facingEvent || !facingEvent.name[/smashrock/i]
    pbMessage(_INTL("Can't use that here.")) if showmsg
    return false
  end
  return true
end
def useMoveRockSmash
  if !pbHiddenMoveAnimation(nil)
    pbMessage(_INTL("{1} used a {2}!",$Trainer.name,GameData::Item.get(:HAMMER).name))
  end
  facingEvent = $game_player.pbFacingEvent
  if facingEvent
    pbSmashEvent(facingEvent)
    pbRockSmashRandomEncounter
  end
  return true
end

def canUseMoveStrength?
   showmsg = true
   return false if !$PokemonBag.pbQuantity(:FULCRUM)==0
   if $PokemonMap.strengthUsed
     pbMessage(_INTL("The Fulcrum is already being used.")) if showmsg
     return false
   end
   return true
end
def useMoveStrength
  if !pbHiddenMoveAnimation(nil)
    pbMessage(_INTL("{1} used a {2}!\1",$Trainer.name,GameData::Item.get(:FULCRUM).name))
  end
  pbMessage(_INTL("{1}'s {2} made it possible to move boulders around!",$Trainer.name,GameData::Item.get(:FULCRUM).name))
  $PokemonMap.strengthUsed = true
  return true
end

def canUseMoveSurf?
   showmsg = true
   return false if !$PokemonBag.pbQuantity(:HOVERCRAFT)==0
   if $PokemonGlobal.surfing
     pbMessage(_INTL("You're already surfing.")) if showmsg
     return false
   end
   if $game_player.pbHasDependentEvents?
     pbMessage(_INTL("It can't be used when you have someone with you.")) if showmsg
     return false
   end
   if GameData::MapMetadata.exists?($game_map.map_id) &&
      GameData::MapMetadata.get($game_map.map_id).always_bicycle
     pbMessage(_INTL("Let's enjoy cycling!")) if showmsg
     return false
   end
   if !$game_player.pbFacingTerrainTag.can_surf_freely ||
      !$game_map.passable?($game_player.x,$game_player.y,$game_player.direction,$game_player)
     pbMessage(_INTL("No surfing here!")) if showmsg
     return false
   end
   return true
end
def useMoveSurf
  $game_temp.in_menu = false
  pbCancelVehicles
  if !pbHiddenMoveAnimation(nil)
    pbMessage(_INTL("{1} used {2}!",$Trainer.name,GameData::Item.get(:HOVERCRAFT).name))
  end
  surfbgm = GameData::Metadata.get.surf_BGM
  pbCueBGM(surfbgm,0.5) if surfbgm
  pbStartSurfing
  return true
end

def canUseMoveWaterfall?
  showmsg = true
  if !$game_player.pbFacingTerrainTag.waterfall
    pbMessage(_INTL("Can't use that here.")) if showmsg
    return false
  end
  return true
end
def useMoveWaterfall
  if !pbHiddenMoveAnimation(pokemon)
    pbMessage(_INTL("{1} used an {2}!",$Trainer.name,GameData::Item.get(:AQUAROCKET).name))
  end
  pbAscendWaterfall
  return true
end

module GameData
  class TerrainTag
    attr_reader :rock_climb
    def initialize(hash)
      @id                     = hash[:id]
      @id_number              = hash[:id_number]
      @real_name              = hash[:id].to_s                || "Unnamed"
      @can_surf               = hash[:can_surf]               || false
      @waterfall              = hash[:waterfall]              || false
      @rock_climb             = hash[:rock_climb]             || false
      @waterfall_crest        = hash[:waterfall_crest]        || false
      @can_fish               = hash[:can_fish]               || false
      @can_dive               = hash[:can_dive]               || false
      @deep_bush              = hash[:deep_bush]              || false
      @shows_grass_rustle     = hash[:shows_grass_rustle]     || false
      @land_wild_encounters   = hash[:land_wild_encounters]   || false
      @double_wild_encounters = hash[:double_wild_encounters] || false
      @battle_environment     = hash[:battle_environment]
      @ledge                  = hash[:ledge]                  || false
      @ice                    = hash[:ice]                    || false
      @bridge                 = hash[:bridge]                 || false
      @shows_reflections      = hash[:shows_reflections]      || false
      @must_walk              = hash[:must_walk]              || false
      @ignore_passability     = hash[:ignore_passability]     || false
    end
  end
end

def canUseMoveRockClimb?
  showmsg = true
  return false if !$PokemonBag.pbQuantity(:HIKINGGEAR)==0
   if !$game_player.pbFacingTerrainTag.rock_climb
     pbMessage(_INTL("Can't use that here.")) if showmsg
     return false
   end
   return true
end
def useMoveRockClimb
   if !pbHiddenMoveAnimation(nil)
     pbMessage(_INTL("{1} uses the {2}!",$Trainer.name,GameData::Item.get(:HIKINGGEAR).name))
   end
   if event.direction=8
     pbRockClimbUp
   elsif event.direction=2
     pbRockClimbDown
   end
   return true
end
def pbRockSmashRandomItem
  randItem = rand(100)+1
  return nil if randItem < 51
  if randItem < 76
    pbExclaim(get_character(-1))
    pbWait(8)
    pbMessage(_INTL("Oh, there was an item!"))
    pbItemBall(:HARDSTONE)
  elsif randItem < 86
    pbExclaim(get_character(-1))
    pbWait(8)
    pbMessage(_INTL("Oh, there was an item!"))
    pbItemBall(:NUGGET)
  elsif randItem < 96
    pbExclaim(get_character(-1))
    pbWait(8)
    pbMessage(_INTL("Oh, there was an item!"))
    randFossil = rand(2)
      if randFossil == 1
        pbItemBall(:TOMBSEAL)
      else
        pbItemBall(:ANCIENTTOTEM)
      end
    else
      pbExclaim(get_character(-1))
      pbWait(8)
      pbMessage(_INTL("Oh, there was an item!"))
      pbItemBall(:BIGNUGGET)
  end
end

def pbRockClimbUp(event=nil)
  event = $game_player if !event
  return if !event
  return if event.direction != 8   # can't ascend if not facing up
  oldthrough   = event.through
  oldmovespeed = event.move_speed
  return if !$game_player.pbFacingTerrainTag.rock_climb
  event.through = true
  event.move_speed += 2
  loop do
    event.move_up
    if !$game_player.pbFacingTerrainTag.rock_climb
      event.move_up
      break
    end
  end
  event.through    = oldthrough
  event.move_speed = oldmovespeed
end

def pbRockClimbDown(event=nil)
  event = $game_player if !event
  return if !event
  return if event.direction != 2    # Can't descend if not facing down
  oldthrough   = event.through
  oldmovespeed = event.move_speed
  return if !$game_player.pbFacingTerrainTag.rock_climb
  event.through = true
  event.move_speed += 2
  loop do
    event.move_down
    if !$game_player.pbFacingTerrainTag.rock_climb
      event.move_down
      break
    end
  end
  event.through    = oldthrough
  event.move_speed = oldmovespeed
end

def pbRockClimb
  event = $game_player if !event
  if $PokemonBag.pbQuantity(:HIKINGGEAR)==0
    pbMessage(_INTL("These rocks look climbable."))
    return false
  end
  if pbConfirmMessage(_INTL("It's a large rock wall. Would you like to climb it?"))
    if $PokemonBag.pbQuantity(:HIKINGGEAR)>0
      pbMessage(_INTL("{1} used the {2}!",$Trainer.name,GameData::Item.get(:HIKINGGEAR).name))
      pbHiddenMoveAnimation(nil)
    end
    if event.direction==8
      pbRockClimbUp
    elsif event.direction==2
      pbRockClimbDown
    end
    return true
  end
  return false
end

Events.onAction += proc { |_sender,_e|
  if $game_player.pbFacingTerrainTag.rock_climb
    pbRockClimb
  end
}

def pbCut
  if !$PokemonBag.pbHasItem?(:CHAINSAW)
    pbMessage(_INTL("This tree looks like it can be cut down."))
    return false
  end
  pbMessage(_INTL("This tree looks like it can be cut down!\1"))
  if pbConfirmMessage(_INTL("Would you like to cut it?"))
    speciesname = $Trainer.name
    pbMessage(_INTL("{1} used {2}!",speciesname,GameData::Item.get(:CHAINSAW).name))
    return true
  end
  return false
end

def pbSmashEvent(event)
  return if !event
  if event.name[/cuttree/i]
    pbSEPlay("Cut",80)
  elsif event.name[/smashrock/i]
    pbSEPlay("Rock Smash",80)
  end
  pbMoveRoute(event,[
     PBMoveRoute::Wait,2,
     PBMoveRoute::TurnLeft,
     PBMoveRoute::Wait,2,
     PBMoveRoute::TurnRight,
     PBMoveRoute::Wait,2,
     PBMoveRoute::TurnUp,
     PBMoveRoute::Wait,2
  ])
  pbWait(Graphics.frame_rate*4/10)
  event.erase
  $PokemonMap.addErasedEvent(event.id) if $PokemonMap
end



#===============================================================================
# Dig
#===============================================================================
HiddenMoveHandlers::CanUseMove.add(:DIG,proc { |move,pkmn,showmsg|
  escape = ($PokemonGlobal.escapePoint rescue nil)
  if !escape || escape==[]
    pbMessage(_INTL("Can't use that here.")) if showmsg
    next false
  end
  if $game_player.pbHasDependentEvents?
    pbMessage(_INTL("It can't be used when you have someone with you.")) if showmsg
    next false
  end
  next true
})

HiddenMoveHandlers::ConfirmUseMove.add(:DIG,proc { |move,pkmn|
  escape = ($PokemonGlobal.escapePoint rescue nil)
  next false if !escape || escape==[]
  mapname = pbGetMapNameFromId(escape[0])
  next pbConfirmMessage(_INTL("Want to escape from here and return to {1}?",mapname))
})

HiddenMoveHandlers::UseMove.add(:DIG,proc { |move,pokemon|
  escape = ($PokemonGlobal.escapePoint rescue nil)
  if escape
    if !pbHiddenMoveAnimation(pokemon)
      pbMessage(_INTL("{1} used {2}!",pokemon.name,GameData::Move.get(move).name))
    end
    pbFadeOutIn {
      $game_temp.player_new_map_id    = escape[0]
      $game_temp.player_new_x         = escape[1]
      $game_temp.player_new_y         = escape[2]
      $game_temp.player_new_direction = escape[3]
      $scene.transfer_player
      $game_map.autoplay
      $game_map.refresh
    }
    pbEraseEscapePoint
    next true
  end
  next false
})



#===============================================================================
# Dive
#===============================================================================
def pbDive
  return false if $game_player.pbFacingEvent
  map_metadata = GameData::MapMetadata.try_get($game_map.map_id)
  return false if !map_metadata || !map_metadata.dive_map_id
  if !$PokemonBag.pbHasItem?(:SCUBATANK)
    pbMessage(_INTL("The sea is deep here. A Pokémon may be able to go underwater."))
    return false
  end
  if pbConfirmMessage(_INTL("The sea is deep here. Would you like to use Dive?"))
    speciesname = $Trainer.name
    pbMessage(_INTL("{1} used {2}!",speciesname,GameData::Item.get(:SCUBATANK).name))
    pbFadeOutIn {
       $game_temp.player_new_map_id    = map_metadata.dive_map_id
       $game_temp.player_new_x         = $game_player.x
       $game_temp.player_new_y         = $game_player.y
       $game_temp.player_new_direction = $game_player.direction
       $PokemonGlobal.surfing = false
       $PokemonGlobal.diving  = true
       pbUpdateVehicle
       $scene.transfer_player(false)
       $game_map.autoplay
       $game_map.refresh
    }
    return true
  end
  return false
end

def pbSurfacing
  return if !$PokemonGlobal.diving
  return false if $game_player.pbFacingEvent
  surface_map_id = nil
  GameData::MapMetadata.each do |map_data|
    next if !map_data.dive_map_id || map_data.dive_map_id != $game_map.map_id
    surface_map_id = map_data.id
    break
  end
  return if !surface_map_id
  move = :DIVE
  movefinder = $Trainer.get_pokemon_with_move(move)
  if !$PokemonBag.pbHasItem?(:SCUBATANK)
    pbMessage(_INTL("Light is filtering down from above. A Pokémon may be able to surface here."))
    return false
  end
  if pbConfirmMessage(_INTL("Light is filtering down from above. Would you like to use Dive?"))
    speciesname = $Trainer.name
    pbMessage(_INTL("{1} used {2}!",speciesname,GameData::Item.get(:SCUBATANK).name))
    pbFadeOutIn {
       $game_temp.player_new_map_id    = surface_map_id
       $game_temp.player_new_x         = $game_player.x
       $game_temp.player_new_y         = $game_player.y
       $game_temp.player_new_direction = $game_player.direction
       $PokemonGlobal.surfing = true
       $PokemonGlobal.diving  = false
       pbUpdateVehicle
       $scene.transfer_player(false)
       surfbgm = GameData::Metadata.get.surf_BGM
       (surfbgm) ?  pbBGMPlay(surfbgm) : $game_map.autoplayAsCue
       $game_map.refresh
    }
    return true
  end
  return false
end

def pbTransferUnderwater(mapid,x,y,direction=$game_player.direction)
  pbFadeOutIn {
    $game_temp.player_new_map_id    = mapid
    $game_temp.player_new_x         = x
    $game_temp.player_new_y         = y
    $game_temp.player_new_direction = direction
    $scene.transfer_player(false)
    $game_map.autoplay
    $game_map.refresh
  }
end

Events.onAction += proc { |_sender, _e|
  if $PokemonGlobal.diving
    surface_map_id = nil
    GameData::MapMetadata.each do |map_data|
      next if !map_data.dive_map_id || map_data.dive_map_id != $game_map.map_id
      surface_map_id = map_data.id
      break
    end
    if surface_map_id &&
       $MapFactory.getTerrainTag(surface_map_id, $game_player.x, $game_player.y).can_dive
      pbSurfacing
    end
  else
    pbDive if $game_player.terrain_tag.can_dive
  end
}

HiddenMoveHandlers::CanUseMove.add(:DIVE,proc { |move,pkmn,showmsg|
  next false if !pbCheckHiddenMoveBadge(Settings::BADGE_FOR_DIVE,showmsg)
  if $PokemonGlobal.diving
    surface_map_id = nil
    GameData::MapMetadata.each do |map_data|
      next if !map_data.dive_map_id || map_data.dive_map_id != $game_map.map_id
      surface_map_id = map_data.id
      break
    end
    if !surface_map_id ||
       !$MapFactory.getTerrainTag(surface_map_id, $game_player.x, $game_player.y).can_dive
      pbMessage(_INTL("Can't use that here.")) if showmsg
      next false
    end
  else
    if !GameData::MapMetadata.exists?($game_map.map_id) ||
       !GameData::MapMetadata.get($game_map.map_id).dive_map_id
      pbMessage(_INTL("Can't use that here.")) if showmsg
      next false
    end
    if !$game_player.terrain_tag.can_dive
      pbMessage(_INTL("Can't use that here.")) if showmsg
      next false
    end
  end
  next true
})

HiddenMoveHandlers::UseMove.add(:DIVE,proc { |move,pokemon|
  wasdiving = $PokemonGlobal.diving
  if $PokemonGlobal.diving
    dive_map_id = nil
    GameData::MapMetadata.each do |map_data|
      next if !map_data.dive_map_id || map_data.dive_map_id != $game_map.map_id
      dive_map_id = map_data.id
      break
    end
  else
    map_metadata = GameData::MapMetadata.try_get($game_map.map_id)
    dive_map_id = map_metadata.dive_map_id if map_metadata
  end
  next false if !dive_map_id
  if !pbHiddenMoveAnimation(pokemon)
    pbMessage(_INTL("{1} used {2}!",pokemon.name,GameData::Move.get(move).name))
  end
  pbFadeOutIn {
    $game_temp.player_new_map_id    = dive_map_id
    $game_temp.player_new_x         = $game_player.x
    $game_temp.player_new_y         = $game_player.y
    $game_temp.player_new_direction = $game_player.direction
    $PokemonGlobal.surfing = wasdiving
    $PokemonGlobal.diving  = !wasdiving
    pbUpdateVehicle
    $scene.transfer_player(false)
    $game_map.autoplay
    $game_map.refresh
  }
  next true
})



#===============================================================================
# Flash
#===============================================================================
HiddenMoveHandlers::CanUseMove.add(:FLASH,proc { |move,pkmn,showmsg|
  next false if !pbCheckHiddenMoveBadge(Settings::BADGE_FOR_FLASH,showmsg)
  if !GameData::MapMetadata.exists?($game_map.map_id) ||
     !GameData::MapMetadata.get($game_map.map_id).dark_map
    pbMessage(_INTL("Can't use that here.")) if showmsg
    next false
  end
  if $PokemonGlobal.flashUsed
    pbMessage(_INTL("Flash is already being used.")) if showmsg
    next false
  end
  next true
})

HiddenMoveHandlers::UseMove.add(:FLASH,proc { |move,pokemon|
  darkness = $PokemonTemp.darknessSprite
  next false if !darkness || darkness.disposed?
  if !pbHiddenMoveAnimation(pokemon)
    pbMessage(_INTL("{1} used {2}!",pokemon.name,GameData::Move.get(move).name))
  end
  $PokemonGlobal.flashUsed = true
  radiusDiff = 8*20/Graphics.frame_rate
  while darkness.radius<darkness.radiusMax
    Graphics.update
    Input.update
    pbUpdateSceneMap
    darkness.radius += radiusDiff
    darkness.radius = darkness.radiusMax if darkness.radius>darkness.radiusMax
  end
  next true
})



#===============================================================================
# Fly
#===============================================================================
HiddenMoveHandlers::CanUseMove.add(:FLY,proc { |move,pkmn,showmsg|
  next false if !$PokemonBag.pbHasItem?(:WINGSUIT)
  if $game_player.pbHasDependentEvents?
    pbMessage(_INTL("It can't be used when you have someone with you.")) if showmsg
    next false
  end
  if !GameData::MapMetadata.exists?($game_map.map_id) ||
     !GameData::MapMetadata.get($game_map.map_id).outdoor_map
    pbMessage(_INTL("Can't use that here.")) if showmsg
    next false
  end
  next true
})

HiddenMoveHandlers::UseMove.add(:FLY,proc { |move,pokemon|
  if !$PokemonTemp.flydata
    pbMessage(_INTL("Can't use that here."))
    next false
  end
  if !pbHiddenMoveAnimation(pokemon)
    pbMessage(_INTL("{1} used {2}!",pokemon.name,GameData::Item.get(:WINGSUIT).name))
  end
  pbFadeOutIn {
    $game_temp.player_new_map_id    = $PokemonTemp.flydata[0]
    $game_temp.player_new_x         = $PokemonTemp.flydata[1]
    $game_temp.player_new_y         = $PokemonTemp.flydata[2]
    $game_temp.player_new_direction = 2
    $PokemonTemp.flydata = nil
    $scene.transfer_player
    $game_map.autoplay
    $game_map.refresh
  }
  pbEraseEscapePoint
  next true
})



#===============================================================================
# Headbutt
#===============================================================================
def pbHeadbuttEffect(event=nil)
  event = $game_player.pbFacingEvent(true) if !event
  a = (event.x+(event.x/24).floor+1)*(event.y+(event.y/24).floor+1)
  a = (a*2/5)%10   # Even 2x as likely as odd, 0 is 1.5x as likely as odd
  b = $Trainer.public_ID % 10   # Practically equal odds of each value
  chance = 1                             # ~50%
  if a==b;                  chance = 8   # 10%
  elsif a>b && (a-b).abs<5; chance = 5   # ~30.3%
  elsif a<b && (a-b).abs>5; chance = 5   # ~9.7%
  end
  if rand(10)>=chance
    pbMessage(_INTL("Nope. Nothing..."))
  else
    enctype = (chance==1) ? :HeadbuttLow : :HeadbuttHigh
    if !pbEncounter(enctype)
      pbMessage(_INTL("Nope. Nothing..."))
    end
  end
end

def pbHeadbutt(event=nil)
  move = :HEADBUTT
  movefinder = $Trainer.get_pokemon_with_move(move)
  if !$DEBUG && !movefinder
    pbMessage(_INTL("A Pokémon could be in this tree. Maybe a Pokémon could shake it."))
    return false
  end
  if pbConfirmMessage(_INTL("A Pokémon could be in this tree. Would you like to use Headbutt?"))
    speciesname = (movefinder) ? movefinder.name : $Trainer.name
    pbMessage(_INTL("{1} used {2}!",speciesname,GameData::Move.get(move).name))
    pbHiddenMoveAnimation(movefinder)
    pbHeadbuttEffect(event)
    return true
  end
  return false
end

HiddenMoveHandlers::CanUseMove.add(:HEADBUTT,proc { |move,pkmn,showmsg|
  facingEvent = $game_player.pbFacingEvent
  if !facingEvent || !facingEvent.name[/headbutttree/i]
    pbMessage(_INTL("Can't use that here.")) if showmsg
    next false
  end
  next true
})

HiddenMoveHandlers::UseMove.add(:HEADBUTT,proc { |move,pokemon|
  if !pbHiddenMoveAnimation(pokemon)
    pbMessage(_INTL("{1} used {2}!",pokemon.name,GameData::Move.get(move).name))
  end
  facingEvent = $game_player.pbFacingEvent
  pbHeadbuttEffect(facingEvent)
})



#===============================================================================
# Rock Smash
#===============================================================================
def pbRockSmashRandomEncounter
  if $PokemonEncounters.encounter_triggered?(:RockSmash, false, false)
    pbEncounter(:RockSmash)
  end
end

def pbRockSmash
  if !$PokemonBag.pbHasItem?(:HAMMER)
    pbMessage(_INTL("It's a rugged rock, but a Pokémon may be able to smash it."))
    return false
  end
  if pbConfirmMessage(_INTL("This rock appears to be breakable. Would you like to use Rock Smash?"))
    speciesname = $Trainer.name
    pbMessage(_INTL("{1} used {2}!",speciesname,GameData::Item.get(:HAMMER).name))
    return true
  end
  return false
end

HiddenMoveHandlers::CanUseMove.add(:ROCKSMASH,proc { |move,pkmn,showmsg|
  next false if !pbCheckHiddenMoveBadge(Settings::BADGE_FOR_ROCKSMASH,showmsg)
  facingEvent = $game_player.pbFacingEvent
  if !facingEvent || !facingEvent.name[/smashrock/i]
    pbMessage(_INTL("Can't use that here.")) if showmsg
    next false
  end
  next true
})

HiddenMoveHandlers::UseMove.add(:ROCKSMASH,proc { |move,pokemon|
  if !pbHiddenMoveAnimation(pokemon)
    pbMessage(_INTL("{1} used {2}!",pokemon.name,GameData::Item.get(:HAMMER).name))
  end
  facingEvent = $game_player.pbFacingEvent
  if facingEvent
    pbSmashEvent(facingEvent)
    pbRockSmashRandomEncounter
    pbRockSmashRandomItem
  end
  next true
})



#===============================================================================
# Strength
#===============================================================================
def pbStrength
  if $PokemonMap.strengthUsed
    pbMessage(_INTL("Strength made it possible to move boulders around."))
    return false
  end
  if !$PokemonBag.pbHasItem?(:FULCRUM)
    pbMessage(_INTL("It's a big boulder, but a Pokémon may be able to push it aside."))
    return false
  end
  pbMessage(_INTL("It's a big boulder, but a Pokémon may be able to push it aside.\1"))
  if pbConfirmMessage(_INTL("Would you like to use Strength?"))
    speciesname = $Trainer.name
    pbMessage(_INTL("{1} used {2}!",speciesname,GameData::Item.get(:FULCRUM).name))
    pbMessage(_INTL("{1}'s Strength made it possible to move boulders around!",speciesname))
    $PokemonMap.strengthUsed = true
    return true
  end
  return false
end

Events.onAction += proc { |_sender,_e|
  facingEvent = $game_player.pbFacingEvent
  pbStrength if facingEvent && facingEvent.name[/strengthboulder/i]
}

HiddenMoveHandlers::CanUseMove.add(:STRENGTH,proc { |move,pkmn,showmsg|
  next false if !$PokemonBag.pbHasItem?(:FULCRUM)
  if $PokemonMap.strengthUsed
    pbMessage(_INTL("Strength is already being used.")) if showmsg
    next false
  end
  next true
})

HiddenMoveHandlers::UseMove.add(:STRENGTH,proc { |move,pokemon|
  if !pbHiddenMoveAnimation(pokemon)
    pbMessage(_INTL("{1} used {2}!",$Trainer.name,GameData::Item.get(:FULCRUM).name))
  end
  pbMessage(_INTL("The {1}'s Strength made it possible to move boulders around!",GameData::Item.get(:FULCRUM).name))
  $PokemonMap.strengthUsed = true
  next true
})



#===============================================================================
# Surf
#===============================================================================
def pbSurf
  return false if $game_player.pbFacingEvent
  return false if $game_player.pbHasDependentEvents?
  if !$PokemonBag.pbHasItem?(:HOVERCRAFT)
    return false
  end
  if pbConfirmMessage(_INTL("The water is a deep blue...\nWould you like to surf on it?"))
    speciesname = $Trainer.name
    pbMessage(_INTL("{1} used {2}!",speciesname,GameData::Item.get(:HOVERCRAFT).name))
    pbCancelVehicles
    surfbgm = GameData::Metadata.get.surf_BGM
    pbCueBGM(surfbgm,0.5) if surfbgm
    pbStartSurfing
    return true
  end
  return false
end

def pbStartSurfing
  pbCancelVehicles
  $PokemonEncounters.reset_step_count
  $PokemonGlobal.surfing = true
  pbUpdateVehicle
  $PokemonTemp.surfJump = $MapFactory.getFacingCoords($game_player.x,$game_player.y,$game_player.direction)
  pbJumpToward
  $PokemonTemp.surfJump = nil
  $game_player.check_event_trigger_here([1,2])
end

def pbEndSurf(_xOffset,_yOffset)
  return false if !$PokemonGlobal.surfing
  x = $game_player.x
  y = $game_player.y
  if $game_map.terrain_tag(x,y).can_surf && !$game_player.pbFacingTerrainTag.can_surf
    $PokemonTemp.surfJump = [x,y]
    if pbJumpToward(1,false,true)
      $game_map.autoplayAsCue
      $game_player.increase_steps
      result = $game_player.check_event_trigger_here([1,2])
      pbOnStepTaken(result)
    end
    $PokemonTemp.surfJump = nil
    return true
  end
  return false
end

def pbTransferSurfing(mapid,xcoord,ycoord,direction=$game_player.direction)
  pbFadeOutIn {
    $game_temp.player_new_map_id    = mapid
    $game_temp.player_new_x         = xcoord
    $game_temp.player_new_y         = ycoord
    $game_temp.player_new_direction = direction
    $scene.transfer_player(false)
    $game_map.autoplay
    $game_map.refresh
  }
end

Events.onAction += proc { |_sender,_e|
  next if $PokemonGlobal.surfing
  next if GameData::MapMetadata.exists?($game_map.map_id) &&
          GameData::MapMetadata.get($game_map.map_id).always_bicycle
  next if !$game_player.pbFacingTerrainTag.can_surf_freely
  next if !$game_map.passable?($game_player.x,$game_player.y,$game_player.direction,$game_player)
  pbSurf
}

HiddenMoveHandlers::CanUseMove.add(:SURF,proc { |move,pkmn,showmsg|
  next false if !$PokemonBag.pbHasItem?(:HOVERCRAFT)
  if $PokemonGlobal.surfing
    pbMessage(_INTL("You're already surfing.")) if showmsg
    next false
  end
  if $game_player.pbHasDependentEvents?
    pbMessage(_INTL("It can't be used when you have someone with you.")) if showmsg
    next false
  end
  if GameData::MapMetadata.exists?($game_map.map_id) &&
     GameData::MapMetadata.get($game_map.map_id).always_bicycle
    pbMessage(_INTL("Let's enjoy cycling!")) if showmsg
    next false
  end
  if !$game_player.pbFacingTerrainTag.can_surf_freely ||
     !$game_map.passable?($game_player.x,$game_player.y,$game_player.direction,$game_player)
    pbMessage(_INTL("No surfing here!")) if showmsg
    next false
  end
  next true
})

HiddenMoveHandlers::UseMove.add(:SURF,proc { |move,pokemon|
  $game_temp.in_menu = false
  pbCancelVehicles
  if !pbHiddenMoveAnimation(pokemon)
      pbMessage(_INTL("{1} used {2}!",$Trainer.name,GameData::Item.get(:HOVERCRAFT).name))
  end
  surfbgm = GameData::Metadata.get.surf_BGM
  pbCueBGM(surfbgm,0.5) if surfbgm
  pbStartSurfing
  next true
})


#===============================================================================
# Waterfall
#===============================================================================
def pbAscendWaterfall
  return if $game_player.direction != 8   # Can't ascend if not facing up
  terrain = $game_player.pbFacingTerrainTag
  return if !terrain.waterfall && !terrain.waterfall_crest
  oldthrough   = $game_player.through
  oldmovespeed = $game_player.move_speed
  $game_player.through    = true
  $game_player.move_speed = 2
  loop do
    $game_player.move_up
    terrain = $game_player.pbTerrainTag
    break if !terrain.waterfall && !terrain.waterfall_crest
  end
  $game_player.through    = oldthrough
  $game_player.move_speed = oldmovespeed
end

def pbDescendWaterfall
  return if $game_player.direction != 2   # Can't descend if not facing down
  terrain = $game_player.pbFacingTerrainTag
  return if !terrain.waterfall && !terrain.waterfall_crest
  oldthrough   = $game_player.through
  oldmovespeed = $game_player.move_speed
  $game_player.through    = true
  $game_player.move_speed = 2
  loop do
    $game_player.move_down
    terrain = $game_player.pbTerrainTag
    break if !terrain.waterfall && !terrain.waterfall_crest
  end
  $game_player.through    = oldthrough
  $game_player.move_speed = oldmovespeed
end

def pbWaterfall
  if !$PokemonBag.pbHasItem?(:AQUAROCKET)
    pbMessage(_INTL("A wall of water is crashing down with a mighty roar."))
    return false
  end
  if pbConfirmMessage(_INTL("It's a large waterfall. Would you like to use Waterfall?"))
    speciesname = $Trainer.name
    pbMessage(_INTL("{1} used {2}!",speciesname,GameData::Item.get(:AQUAROCKET).name))
    pbAscendWaterfall
    return true
  end
  return false
end

Events.onAction += proc { |_sender,_e|
  terrain = $game_player.pbFacingTerrainTag
  if terrain.waterfall
    pbWaterfall
  elsif terrain.waterfall_crest
    pbMessage(_INTL("A wall of water is crashing down with a mighty roar."))
  end
}

ItemHandlers::UseFromBag.add(:CHAINSAW,proc{|item|
  next canUseMoveCut? ? 2 : 0
})

ItemHandlers::UseInField.add(:CHAINSAW,proc{|item|
  useMoveCut if canUseMoveCut?
})

ItemHandlers::UseFromBag.add(:SCUBATANK,proc{|item|
   next canUseMoveDive? ? 2 : 0
})

ItemHandlers::UseInField.add(:SCUBATANK,proc{|item|
   useMoveDive if canUseMoveDive?
})

ItemHandlers::UseFromBag.add(:TORCH,proc{|item|
   next canUseMoveFlash? ? 2 : 0
})

ItemHandlers::UseInField.add(:TORCH,proc{|item|
   useMoveFlash if canUseMoveFlash?
})

ItemHandlers::UseFromBag.add(:WINGSUIT,proc{|item|
  ret = nil
    pbFadeOutIn{
    scene = PokemonRegionMap_Scene.new(-1,false)
    screen = PokemonRegionMapScreen.new(scene)
    ret = screen.pbStartFlyScreen
    next 0 if !ret
  if ret
    $PokemonTemp.flydata = ret
    $game_temp.in_menu = false
    useMoveFly
  end
  next 2
}
})

ItemHandlers::UseInField.add(:WINGSUIT,proc{|item|
   useMoveFly if canUseMoveFly?
})

ItemHandlers::UseFromBag.add(:HAMMER,proc{|item|
   next canUseMoveRockSmash? ? 2 : 0
})

ItemHandlers::UseInField.add(:HAMMER,proc{|item|
   useMoveRockSmash if canUseMoveRockSmash?
})

ItemHandlers::UseFromBag.add(:FULCRUM,proc{|item|
   next canUseMoveStrength? ? 2 : 0
})

ItemHandlers::UseInField.add(:FULCRUM,proc{|item|
   useMoveStrength if canUseMoveStrength?
})

ItemHandlers::UseFromBag.add(:HOVERCRAFT,proc{|item|
   next canUseMoveSurf? ? 2 : 0
})

ItemHandlers::UseInField.add(:HOVERCRAFT,proc{|item|
   useMoveSurf if canUseMoveSurf?
})

ItemHandlers::UseFromBag.add(:AQUAROCKET,proc{|item|
   next canUseMoveWaterfall? ? 2 : 0
})

ItemHandlers::UseInField.add(:AQUAROCKET,proc{|item|
   useMoveWaterfall if canUseMoveWaterfall?
})

ItemHandlers::UseFromBag.add(:HIKINGGEAR,proc{|item|
   next canUseMoveRockClimb? ? 2 : 0
})

ItemHandlers::UseInField.add(:HIKINGGEAR,proc{|item|
   useMoveRockClimb if canUseMoveRockClimb?
})
ItemHandlers::UseFromBag.add(:ESCAPEROPE,proc { |item|
  if $game_player.pbHasDependentEvents?
    pbMessage(_INTL("It can't be used when you have someone with you."))
    next 0
  end
  if ($PokemonGlobal.escapePoint rescue false) && $PokemonGlobal.escapePoint.length>0
    next 2   # End screen and consume item
  end
  pbMessage(_INTL("Can't use that here."))
  next 0
})
ItemHandlers::UseInField.add(:ESCAPEROPE,proc { |item|
  escape = ($PokemonGlobal.escapePoint rescue nil)
  if !escape || escape==[]
    pbMessage(_INTL("Can't use that here."))
    next 0
  end
  if $game_player.pbHasDependentEvents?
    pbMessage(_INTL("It can't be used when you have someone with you."))
    next 0
  end
  pbUseItemMessage(item)
  pbFadeOutIn {
    $game_temp.player_new_map_id    = escape[0]
    $game_temp.player_new_x         = escape[1]
    $game_temp.player_new_y         = escape[2]
    $game_temp.player_new_direction = escape[3]
    pbCancelVehicles
    $scene.transfer_player
    $game_map.autoplay
    $game_map.refresh
  }
  pbEraseEscapePoint
  next 2
})

Events.onStepTaken += proc {
  if $PokemonGlobal.repel > 0 && !$game_player.terrain_tag.ice   # Shouldn't count down if on ice
    $PokemonGlobal.repel -= 1
    if $PokemonGlobal.repel <= 0
      if $PokemonBag.pbHasItem?(:REPEL) ||
         $PokemonBag.pbHasItem?(:SUPERREPEL) ||
         $PokemonBag.pbHasItem?(:MAXREPEL)
         if pbConfirmMessage(_INTL("The repellent's effect wore off! Would you like to use another one?"))
           if $PokemonBag.pbHasItem?(:REPEL) && !$PokemonBag.pbHasItem?(:SUPERREPEL) && !$PokemonBag.pbHasItem?(:MAXREPEL)
             pbMessage(_INTL("Which one?\\ch[34,2,Repel]"))
             if pbGet(34) == 0
               pbUseItem($PokemonBag,:REPEL)
             end
           elsif !$PokemonBag.pbHasItem?(:REPEL) && $PokemonBag.pbHasItem?(:SUPERREPEL) && !$PokemonBag.pbHasItem?(:MAXREPEL)
             pbMessage(_INTL("\\ch[34,2,Super Repel]"))
             if pbGet(34) == 0
               pbUseItem($PokemonBag,:SUPERREPEL)
             end
           elsif !$PokemonBag.pbHasItem?(:REPEL) && !$PokemonBag.pbHasItem?(:SUPERREPEL) && $PokemonBag.pbHasItem?(:MAXREPEL)
             pbMessage(_INTL("\\ch[34,2,Max Repel]"))
             if pbGet(34) == 0
               pbUseItem($PokemonBag,:MAXREPEL)
             end
           elsif $PokemonBag.pbHasItem?(:REPEL) && $PokemonBag.pbHasItem?(:SUPERREPEL) && !$PokemonBag.pbHasItem?(:MAXREPEL)
             pbMessage(_INTL("\\ch[34,3,Repel,Super Repel]"))
             if pbGet(34) == 0
               pbUseItem($PokemonBag,:REPEL)
             elsif pbGet(34) == 1
               pbUseItem($PokemonBag,:SUPERREPEL)
             end
           elsif !$PokemonBag.pbHasItem?(:REPEL) && $PokemonBag.pbHasItem?(:SUPERREPEL) && $PokemonBag.pbHasItem?(:MAXREPEL)
             pbMessage(_INTL("\\ch[34,3,Super Repel,Max Repel]"))
             if pbGet(34) == 0
               pbUseItem($PokemonBag,:SUPERREPEL)
             elsif pbGet(34) == 1
               pbUseItem($PokemonBag,:MAXREPEL)
             end
           elsif $PokemonBag.pbHasItem?(:REPEL) && !$PokemonBag.pbHasItem?(:SUPERREPEL) && $PokemonBag.pbHasItem?(:MAXREPEL)
             pbMessage(_INTL("\\ch[34,3,Repel,Max Repel]"))
             if pbGet(34) == 0
               pbUseItem($PokemonBag,:REPEL)
             elsif pbGet(34) == 1
               pbUseItem($PokemonBag,:MAXREPEL)
             end
           elsif $PokemonBag.pbHasItem?(:REPEL) && $PokemonBag.pbHasItem?(:SUPERREPEL) && $PokemonBag.pbHasItem?(:MAXREPEL)
             pbMessage(_INTL("\\ch[34,3,Repel,Super Repel,Max Repel]"))
             if pbGet(34) == 0
               pbUseItem($PokemonBag,:REPEL)
             elsif pbGet(34) == 1
               pbUseItem($PokemonBag,:SUPERREPEL)
             elsif pbGet(34) == 2
               pbUseItem($PokemonBag,:MAXREPEL)
             end
           end
         end
       else
        pbMessage(_INTL("The repellent's effect wore off!"))
      end
    end
  end
}

ItemHandlers::UseOnPokemon.add(:RARECANDY,proc { |item,pkmn,scene|
  if pkmn.level>=GameData::GrowthRate.max_level || pkmn.shadowPokemon? || pkmn.level>=$game_variables[106]
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pbChangeLevel(pkmn,pkmn.level+1,scene)
  scene.pbHardRefresh
  next true
})

ItemHandlers::UseOnPokemon.add(:ADAMANTMINT,proc { |item,pkmn,scene|
  if pkmn.nature==:ADAMANT
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(:ADAMANT)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:BRAVEMINT,proc { |item,pkmn,scene|
  if pkmn.nature==:BRAVE
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(:BRAVE)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:NAUGHTYMINT,proc { |item,pkmn,scene|
  if pkmn.nature==:NAUGHTY
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(:NAUGHTY)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:LONELYMINT,proc { |item,pkmn,scene|
  if pkmn.nature==:LONELY
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(:LONELY)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:BOLDMINT,proc { |item,pkmn,scene|
  if pkmn.nature==:BOLD
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(:BOLD)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:IMPISHMINT,proc { |item,pkmn,scene|
  if pkmn.nature==:IMPISH
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(:IMPISH)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:LAXMINT,proc { |item,pkmn,scene|
  if pkmn.nature==:LAX
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(:LAX)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:RELAXEDMINT,proc { |item,pkmn,scene|
  if pkmn.nature==:RELAXED
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(:RELAXED)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:MODESTMINT,proc { |item,pkmn,scene|
  if pkmn.nature==:MODEST
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(:MODEST)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:MILDMINT,proc { |item,pkmn,scene|
  if pkmn.nature==:MILD
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(:MILD)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:RASHMINT,proc { |item,pkmn,scene|
  if pkmn.nature==:RASH
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(:RASH)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:QUIETMINT,proc { |item,pkmn,scene|
  if pkmn.nature==:QUIET
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(:QUIET)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:CALMMINT,proc { |item,pkmn,scene|
  if pkmn.nature==:CALM
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(:CALM)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:GENTLEMINT,proc { |item,pkmn,scene|
  if pkmn.nature==:GENTLE
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(:GENTLE)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:CAREFULMINT,proc { |item,pkmn,scene|
  if pkmn.nature==:CAREFUL
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(:CAREFUL)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:SASSYMINT,proc { |item,pkmn,scene|
  if pkmn.nature==:SASSY
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(:SASSY)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:TIMIDMINT,proc { |item,pkmn,scene|
  if pkmn.nature==:TIMID
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(:TIMID)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:HASTYMINT,proc { |item,pkmn,scene|
  if pkmn.nature==:HASTY
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(:HASTY)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:JOLLYMINT,proc { |item,pkmn,scene|
  if pkmn.nature==:JOLLY
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(:JOLLY)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:NAIVEMINT,proc { |item,pkmn,scene|
  if pkmn.nature==:NAIVE
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(:NAIVE)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:BASHFULMINT,proc { |item,pkmn,scene|
  if pkmn.nature==:BASHFUL
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(:BASHFUL)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:HARDYMINT,proc { |item,pkmn,scene|
  if pkmn.nature==:HARDY
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(:HARDY)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:DOCILEMINT,proc { |item,pkmn,scene|
  if pkmn.nature==:DOCILE
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(:DOCILE)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:QUIRKYMINT,proc { |item,pkmn,scene|
  if pkmn.nature==:QUIRKY
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(:QUIRKY)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:SERIOUSMINT,proc { |item,pkmn,scene|
  if pkmn.nature==:SERIOUS
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  pkmn.setNature(:SERIOUS)
  pkmn.calcStats
  scene.pbDisplay(_INTL("{1}'s Nature changed!",pkmn.name))
  next true
})

ItemHandlers::UseOnPokemon.add(:IVMAXSTONE,proc { |item,pkmn,scene|
  choices = []
  for i in 0...6
    stat = PBStats
    choices.push(_INTL(stat.getName(i)))
  end
  choices.push(_INTL("Cancel"))
  command = pbMessage("Which IV would you like to max out?",choices,choices.length)
  statChoice = (command == 6) ? -1 : command
  next false if statChoice == -1
  if pkmn.iv[statChoice] == 31
    scene.pbDisplay(_INTL("This stat is already maxed out!"))
    return false
  end
  statDisp = stat.getName(statChoice)
    pkmn.iv[statChoice] = 31
    pkmn.calcStats
    scene.pbDisplay(_INTL("{1}'s {2} IVs were maxed out!",pkmn.name,statDisp))
  next true
})

ItemHandlers::UseOnPokemon.add(:IVMINSTONE,proc { |item,pkmn,scene|
  choices = []
  for i in 0...6
    stat = PBStats
    choices.push(_INTL(stat.getName(i)))
  end
  choices.push(_INTL("Cancel"))
  command = pbMessage("Which IV would you like to zero out?",choices,choices.length)
  statChoice = (command == 6) ? -1 : command
  next false if statChoice == -1
  if pkmn.iv[statChoice] == 0
    scene.pbDisplay(_INTL("This stat is already zeroed out!"))
    return false
  end
  statDisp = stat.getName(statChoice)
    pkmn.iv[statChoice] = 0
    pkmn.calcStats
    scene.pbDisplay(_INTL("{1}'s {2} IVs were zeroed out!",pkmn.name,statDisp))
  next true
})

ItemHandlers::UseOnPokemon.add(:POMEGBERRY,proc { |item,pkmn,scene|
  next pbRaiseHappinessAndLowerEV(pkmn,scene,:HP,[
     _INTL("{1} adores you! Its base HP fell!",pkmn.name),
     _INTL("{1} became more friendly. Its base HP can't go lower.",pkmn.name),
     _INTL("{1} became more friendly. However, its base HP fell!",pkmn.name)
  ])
})

ItemHandlers::UseOnPokemon.add(:KELPSYBERRY,proc { |item,pkmn,scene|
  next pbRaiseHappinessAndLowerEV(pkmn,scene,:ATTACK,[
     _INTL("{1} adores you! Its base Attack fell!",pkmn.name),
     _INTL("{1} became more friendly. Its base Attack can't go lower.",pkmn.name),
     _INTL("{1} became more friendly. However, its base Attack fell!",pkmn.name)
  ])
})

ItemHandlers::UseOnPokemon.add(:QUALOTBERRY,proc { |item,pkmn,scene|
  next pbRaiseHappinessAndLowerEV(pkmn,scene,:DEFENSE,[
     _INTL("{1} adores you! Its base Defense fell!",pkmn.name),
     _INTL("{1} became more friendly. Its base Defense can't go lower.",pkmn.name),
     _INTL("{1} became more friendly. However, its base Defense fell!",pkmn.name)
  ])
})

ItemHandlers::UseOnPokemon.add(:HONDEWBERRY,proc { |item,pkmn,scene|
  next pbRaiseHappinessAndLowerEV(pkmn,scene,:SPECIAL_ATTACK,[
     _INTL("{1} adores you! Its base Special Attack fell!",pkmn.name),
     _INTL("{1} became more friendly. Its base Special Attack can't go lower.",pkmn.name),
     _INTL("{1} became more friendly. However, its base Special Attack fell!",pkmn.name)
  ])
})

ItemHandlers::UseOnPokemon.add(:GREPABERRY,proc { |item,pkmn,scene|
  next pbRaiseHappinessAndLowerEV(pkmn,scene,:SPECIAL_DEFENSE,[
     _INTL("{1} adores you! Its base Special Defense fell!",pkmn.name),
     _INTL("{1} became more friendly. Its base Special Defense can't go lower.",pkmn.name),
     _INTL("{1} became more friendly. However, its base Special Defense fell!",pkmn.name)
  ])
})

ItemHandlers::UseOnPokemon.add(:TAMATOBERRY,proc { |item,pkmn,scene|
  next pbRaiseHappinessAndLowerEV(pkmn,scene,:SPEED,[
     _INTL("{1} adores you! Its base Speed fell!",pkmn.name),
     _INTL("{1} became more friendly. Its base Speed can't go lower.",pkmn.name),
     _INTL("{1} became more friendly. However, its base Speed fell!",pkmn.name)
  ])
})

ItemHandlers::UseOnPokemon.add(:ABILITYPATCH,proc { |item,pkmn,scene|
  abils = pkmn.getAbilityList
  abil1 = 0; abil2 = 0; hAbil = 0
  for i in abils
    abil1 = i[0] if i[1]==0
    abil2 = i[0] if i[1]==1
    hAbil = i[0] if i[1]==2
  end
  if pkmn.isSpecies?(:HOPPALM) || pkmn.isSpecies?(:PAPYRUN) || pkmn.isSpecies?(:NEFLORA) || pkmn.isSpecies?(:CHARPHINCH) || pkmn.isSpecies?(:PHIRUNDO) || pkmn.isSpecies?(:PHIRENIX) || pkmn.isSpecies?(:BARBOL) || pkmn.isSpecies?(:BOWLTISIS) || pkmn.isSpecies?(:SATURABTU) || pkmn.isSpecies?(:APOPHICARY) || pkmn.isSpecies?(:FALKMUNRA) || pkmn.isSpecies?(:CASTFORM) || pkmn.isSpecies?(:FORMETEOS) || pkmn.isSpecies?(:UNOWN) || pkmn.isSpecies?(:EYEROGLYPH) || pkmn.isSpecies?(:SPOOKLOTH) || pkmn.isSpecies?(:RELICLOTH) || pkmn.isSpecies?(:CORPUSCUFF) || pkmn.isSpecies?(:YAMASK) || pkmn.isSpecies?(:COFAGRIGUS) || pkmn.isSpecies?(:RUNERIGUS)
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  if pkmn.hasHiddenAbility? && abil2 != nil
    abilChoose = rand(2)+1
    newabil = pkmn.abilityIndex-abilChoose
    newabilname = GameData::Ability.get((newabil==0) ? abil1 : abil2)
      if scene.pbConfirm(_INTL("Would you like to change {1}'s Ability to {2}?",pkmn.name,newabilname))
        pkmn.setAbility(newabil)
        scene.pbRefresh
        scene.pbDisplay(_INTL("{1}'s Ability changed to {2}!",pkmn.name,newabilname))
        next true
      end
  elsif pkmn.hasHiddenAbility? && abil2 == nil
    newabil = pkmn.abilityIndex-2
    newabilname = GameData::Ability.get((newabil==0) ? abil1 : abil2)
    if scene.pbConfirm(_INTL("Would you like to change {1}'s Ability to {2}?",pkmn.name,newabilname))
      pkmn.setAbility(newabil)
      scene.pbRefresh
      scene.pbDisplay(_INTL("{1}'s Ability changed to {2}!",pkmn.name,newabilname))
      next true
    end
  else
    !pkmn.hasHiddenAbility?
    newabilname = GameData::Ability.get(hAbil)
    if scene.pbConfirm(_INTL("Would you like to change {1}'s Ability to {2}?",pkmn.name,newabilname))
      pkmn.setAbility(2)
      scene.pbRefresh
      scene.pbDisplay(_INTL("{1}'s Ability changed to {2}!",pkmn.name,newabilname))
      next true
    end
    next false
  end
})

BattleHandlers::DamageCalcUserItem.add(:STELLARPLATE,
  proc { |item,user,target,move,mults,baseDmg,type|
    mults[:base_damage_multiplier] *= 1.2 if type == :COSMIC
  }
)

BattleHandlers::DamageCalcUserItem.add(:SONARPLATE,
  proc { |item,user,target,move,mults,baseDmg,type|
    mults[:base_damage_multiplier] *= 1.2 if type == :SOUND
  }
)

BattleHandlers::DamageCalcUserItem.add(:TEMPORALPLATE,
  proc { |item,user,target,move,mults,baseDmg,type|
    mults[:base_damage_multiplier] *= 1.2 if type == :TIME
  }
)


#===================================
# Misc
#===================================


class PokemonEncounters
  def has_sandy_encounters?
    GameData::EncounterType.each do |enc_type|
      return true if enc_type.type == :sand && has_encounter_type?(enc_type.id)
    end
    return false
  end
  def has_graveyard_encounters?
    GameData::EncounterType.each do |enc_type|
      return true if enc_type.type == :graveyard && has_encounter_type?(enc_type.id)
    end
    return false
  end
  def has_snow_encounters?
    GameData::EncounterType.each do |enc_type|
      return true if enc_type.type == :snow && has_encounter_type?(enc_type.id)
    end
    return false
  end
  def has_high_bridge_encounters?
    GameData::EncounterType.each do |enc_type|
      return true if enc_type.type == :highbridge && has_encounter_type?(enc_type.id)
    end
    return false
  end
  def has_distortion_encounters?
    GameData::EncounterType.each do |enc_type|
      return true if enc_type.type == :distortion && has_encounter_type?(enc_type.id)
    end
    return false
  end
end

GameData::TerrainTag.register({
  :id                     => :Distortion,
  :id_number              => 17,
  :land_wild_encounters   => true,
  :battle_environment     => :Distortion
})

GameData::TerrainTag.register({
  :id                     => :HighBridge,
  :id_number              => 18,
  :land_wild_encounters   => true
})

GameData::TerrainTag.register({
  :id                     => :RockClimb,
  :id_number              => 19,
  :rock_climb             => true
})

GameData::TerrainTag.register({
  :id                     => :Sandy,
  :id_number              => 20,
  :land_wild_encounters   => true,
  :battle_environment     => :Sand
})

GameData::TerrainTag.register({
  :id                     => :Graveyard,
  :id_number              => 21,
  :land_wild_encounters   => true,
  :battle_environment     => :Graveyard
})

GameData::TerrainTag.register({
  :id                     => :Snow,
  :id_number              => 22,
  :land_wild_encounters   => true,
  :battle_environment     => :Ice
})

GameData::EncounterType.register({
  :id             => :Distortion,
  :type           => :distortion,
  :trigger_chance => 5,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :HighBridge,
  :type           => :highbridge,
  :trigger_chance => 5,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :Graveyard,
  :type           => :graveyard,
  :trigger_chance => 5,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :Snow,
  :type           => :snow,
  :trigger_chance => 5,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :Sand,
  :type           => :sand,
  :trigger_chance => 5,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

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

EliteBattle::REPLACE_MISSING_ANIM = true
EliteBattle.defineMoveAnimation(:STELLARWIND) do
  vector = @scene.getRealVector(@targetIndex, @targetIsPlayer)
  vector2 = @scene.getRealVector(@userIndex, @userIsPlayer)
  # set up animation
  fp = {}
  rndx = []; prndx = []
  rndy = []; prndy = []
  rangl = []
  dx = []
  dy = []
  for i in 0...128
    fp["#{i}"] = Sprite.new(@viewport)
    fp["#{i}"].bitmap = pbBitmap("Graphics/EBDX/Animations/Moves/eb423")
    fp["#{i}"].ox = fp["#{i}"].bitmap.width/2
    fp["#{i}"].oy = fp["#{i}"].bitmap.height/2
    fp["#{i}"].visible = false
    fp["#{i}"].z = @targetSprite.z + 1
    rndx.push(rand(256)); prndx.push(rand(72))
    rndy.push(rand(256)); prndy.push(rand(72))
    rangl.push(rand(9))
    dx.push(0)
    dy.push(0)
  end
  shake = 4
  # start animation
  @vector.set(vector2)
  pbSEPlay("Anim/Whirlwind")
  for i in 0...72
    ax, ay = @userSprite.getCenter
    cx, cy = @targetSprite.getCenter(true)
    for j in 0...128
      next if j>(i*2)
      if !fp["#{j}"].visible
        dx[j] = ax - 46*@userSprite.zoom_x*0.5 + prndx[j]*@userSprite.zoom_x*0.5
        dy[j] = ay - 46*@userSprite.zoom_y*0.5 + prndy[j]*@userSprite.zoom_y*0.5
        fp["#{j}"].x = dx[j]
        fp["#{j}"].y = dy[j]
        fp["#{j}"].visible = true
      end
      x0 = ax - 46*@userSprite.zoom_x*0.5 + prndx[j]*@userSprite.zoom_x*0.5
      y0 = ay - 46*@userSprite.zoom_y*0.5 + prndy[j]*@userSprite.zoom_y*0.5
      x2 = cx - 128*@targetSprite.zoom_x*0.5 + rndx[j]*@targetSprite.zoom_x*0.5
      y2 = cy - 128*@targetSprite.zoom_y*0.5 + rndy[j]*@targetSprite.zoom_y*0.5
      fp["#{j}"].x += (x2 - x0)*0.1
      fp["#{j}"].y += (y2 - y0)*0.1
      fp["#{j}"].angle += rangl[j]*2
      nextx = fp["#{j}"].x
      nexty = fp["#{j}"].y
      if !@targetIsPlayer
        fp["#{j}"].opacity -= 51 if nextx > cx && nexty < cy
      else
        fp["#{j}"].opacity -= 51 if nextx < cx && nexty > cy
      end
    end
    if i >= 64
  #    @targetSprite.x += 64*(@targetIsPlayer ? -1 : 1)
    elsif i >= 52
      @targetSprite.ox += shake
      shake = -4 if @targetSprite.ox > @targetSprite.bitmap.width/2 + 2
      shake = 4 if @targetSprite.ox < @targetSprite.bitmap.width/2 - 2
      @targetSprite.still
    end
    @vector.set(vector) if i == 16
    @vector.inc = 0.1 if i == 16
    @scene.wait(1,i < 64)
  end
#  @targetSprite.visible = false
#  @targetSprite.hidden = true
#  @targetSprite.ox = @targetSprite.bitmap.width/2
  pbDisposeSpriteHash(fp)
  @vector.reset
  @vector.inc = 0.2
  @scene.wait(16,true)
end
EliteBattle.defineMoveAnimation(:TIMEWIND) do
  vector = @scene.getRealVector(@targetIndex, @targetIsPlayer)
  vector2 = @scene.getRealVector(@userIndex, @userIsPlayer)
  # set up animation
  fp = {}
  rndx = []; prndx = []
  rndy = []; prndy = []
  rangl = []
  dx = []
  dy = []
  for i in 0...128
    fp["#{i}"] = Sprite.new(@viewport)
    fp["#{i}"].bitmap = pbBitmap("Graphics/EBDX/Animations/Moves/eb423")
    fp["#{i}"].ox = fp["#{i}"].bitmap.width/2
    fp["#{i}"].oy = fp["#{i}"].bitmap.height/2
    fp["#{i}"].visible = false
    fp["#{i}"].z = @targetSprite.z + 1
    rndx.push(rand(256)); prndx.push(rand(72))
    rndy.push(rand(256)); prndy.push(rand(72))
    rangl.push(rand(9))
    dx.push(0)
    dy.push(0)
  end
  shake = 4
  # start animation
  @vector.set(vector2)
  pbSEPlay("Anim/Whirlwind")
  for i in 0...72
    ax, ay = @userSprite.getCenter
    cx, cy = @targetSprite.getCenter(true)
    for j in 0...128
      next if j>(i*2)
      if !fp["#{j}"].visible
        dx[j] = ax - 46*@userSprite.zoom_x*0.5 + prndx[j]*@userSprite.zoom_x*0.5
        dy[j] = ay - 46*@userSprite.zoom_y*0.5 + prndy[j]*@userSprite.zoom_y*0.5
        fp["#{j}"].x = dx[j]
        fp["#{j}"].y = dy[j]
        fp["#{j}"].visible = true
      end
      x0 = ax - 46*@userSprite.zoom_x*0.5 + prndx[j]*@userSprite.zoom_x*0.5
      y0 = ay - 46*@userSprite.zoom_y*0.5 + prndy[j]*@userSprite.zoom_y*0.5
      x2 = cx - 128*@targetSprite.zoom_x*0.5 + rndx[j]*@targetSprite.zoom_x*0.5
      y2 = cy - 128*@targetSprite.zoom_y*0.5 + rndy[j]*@targetSprite.zoom_y*0.5
      fp["#{j}"].x += (x2 - x0)*0.1
      fp["#{j}"].y += (y2 - y0)*0.1
      fp["#{j}"].angle += rangl[j]*2
      nextx = fp["#{j}"].x
      nexty = fp["#{j}"].y
      if !@targetIsPlayer
        fp["#{j}"].opacity -= 51 if nextx > cx && nexty < cy
      else
        fp["#{j}"].opacity -= 51 if nextx < cx && nexty > cy
      end
    end
    if i >= 64
  #    @targetSprite.x += 64*(@targetIsPlayer ? -1 : 1)
    elsif i >= 52
      @targetSprite.ox += shake
      shake = -4 if @targetSprite.ox > @targetSprite.bitmap.width/2 + 2
      shake = 4 if @targetSprite.ox < @targetSprite.bitmap.width/2 - 2
      @targetSprite.still
    end
    @vector.set(vector) if i == 16
    @vector.inc = 0.1 if i == 16
    @scene.wait(1,i < 64)
  end
#  @targetSprite.visible = false
#  @targetSprite.hidden = true
#  @targetSprite.ox = @targetSprite.bitmap.width/2
  pbDisposeSpriteHash(fp)
  @vector.reset
  @vector.inc = 0.2
  @scene.wait(16,true)
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
    cmdWeather = -1
    cmdDebug    = -1
    cmdQuit     = -1
    cmdEndGame  = -1
    if $Trainer.has_pokedex && $Trainer.pokedex.accessible_dexes.length > 0
      commands[cmdPokedex = commands.length] = _INTL("Pokédex")
    end
    commands[cmdPokemon = commands.length]   = _INTL("Pokémon") if $Trainer.party_count > 0
    commands[cmdBag = commands.length]       = _INTL("Bag") if !pbInBugContest?
    commands[cmdWeather = commands.length]  = _INTL("Weather Reader") if $game_switches[400]
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

class PokeBattle_Move
  def pbChangeUsageCounters(user,specialUsage)
    user.effects[PBEffects::FuryCutter]   = 0
    user.effects[PBEffects::ParentalBond] = 0
    user.effects[PBEffects::ProtectRate]  = 1
    user.effects[PBEffects::EchoChamber] = 0
    @battle.field.effects[PBEffects::FusionBolt]  = false
    @battle.field.effects[PBEffects::FusionFlare] = false
  end

  def pbBeamMove?;            return beamMove?; end
  def pbSoundMove?;           return soundMove?; end

  def pbNumHits(user,targets)
    if user.hasActiveAbility?(:PARENTALBOND) && pbDamagingMove? &&
       !chargingTurnMove? && targets.length==1
      # Record that Parental Bond applies, to weaken the second attack
      user.effects[PBEffects::ParentalBond] = 3
      return 2
    elsif pbSoundMove? && @battle.field.weather == :Reverb &&
       !chargingTurnMove? && targets.length==1
      # Record that Parental Bond applies, to weaken the second attack
      user.effects[PBEffects::EchoChamber] = 3
      return 2
    else
      return 1
    end
    return 1
  end

  def pbShowAnimation(id,user,targets,hitNum=0,showAnimation=true)
    return if !showAnimation
    if user.effects[PBEffects::ParentalBond]==1 || user.effects[PBEffects::EchoChamber]==1
      @battle.pbCommonAnimation("ParentalBond",user,targets)
    else
      @battle.pbAnimation(id,user,targets,hitNum)
    end
  end
  #=============================================================================
  # Move's type calculation
  #=============================================================================
  def pbBaseType(user)
    ret = @type
    if ret && user.abilityActive?
      ret = BattleHandlers.triggerMoveBaseTypeModifierAbility(user.ability,user,self,ret)
    end
    return ret
  end

  def pbCalcType(user)
    @powerBoost = false
    ret = pbBaseType(user)
    if ret && GameData::Type.exists?(:ELECTRIC)
      if @battle.field.effects[PBEffects::IonDeluge] && ret == :NORMAL
        ret = :ELECTRIC
        @powerBoost = false
      end
      if user.effects[PBEffects::Electrify]
        ret = :ELECTRIC
        @powerBoost = false
      end
    end
    return ret
  end

  #=============================================================================
  # Type effectiveness calculation
  #=============================================================================
  def pbCalcTypeModSingle(moveType,defType,user,target)
    ret = Effectiveness.calculate_one(moveType, defType)
    # Ring Target
    if target.hasActiveItem?(:RINGTARGET)
      ret = Effectiveness::NORMAL_EFFECTIVE_ONE if Effectiveness.ineffective_type?(moveType, defType)
    end
    # Foresight
    if user.hasActiveAbility?(:SCRAPPY) || target.effects[PBEffects::Foresight]
      ret = Effectiveness::NORMAL_EFFECTIVE_ONE if defType == :GHOST &&
                                                   Effectiveness.ineffective_type?(moveType, defType)
    end
    # Miracle Eye
    if target.effects[PBEffects::MiracleEye]
      ret = Effectiveness::NORMAL_EFFECTIVE_ONE if defType == :DARK &&
                                                   Effectiveness.ineffective_type?(moveType, defType)
    end
    # Delta Stream's weather
    if @battle.pbWeather == :StrongWinds
      ret = Effectiveness::NORMAL_EFFECTIVE_ONE if defType == :FLYING &&
                                                   Effectiveness.super_effective_type?(moveType, defType)
    end
    if @battle.pbWeather == :StrongWinds
      ret = Effectiveness::NORMAL_EFFECTIVE_ONE if defType == :DRAGON &&
                                                   Effectiveness.super_effective_type?(moveType, defType)
    end
    # Volcanic Ash's weather
    if @battle.pbWeather == :VolcanicAsh
      ret = Effectiveness::NORMAL_EFFECTIVE_ONE if defType == :STEEL &&
                                                   Effectiveness.super_effective_type?(moveType, defType)
    end
    # Grounded Flying-type Pokémon become susceptible to Ground moves
    if !target.airborne?
      ret = Effectiveness::NORMAL_EFFECTIVE_ONE if defType == :FLYING && moveType == :GROUND
    end
    return ret
  end

  def pbCalcTypeMod(moveType,user,target)
    return Effectiveness::NORMAL_EFFECTIVE if !moveType
    return Effectiveness::NORMAL_EFFECTIVE if moveType == :GROUND &&
       target.pbHasType?(:FLYING) && target.hasActiveItem?(:IRONBALL)
    # Determine types
    tTypes = target.pbTypes(true)
    # Get effectivenesses
    typeMods = [Effectiveness::NORMAL_EFFECTIVE_ONE] * 3   # 3 types max
    if moveType == :SHADOW
      if target.shadowPokemon?
        typeMods[0] = Effectiveness::NOT_VERY_EFFECTIVE_ONE
      else
        typeMods[0] = Effectiveness::SUPER_EFFECTIVE_ONE
      end
    else
      tTypes.each_with_index do |type,i|
        typeMods[i] = pbCalcTypeModSingle(moveType,type,user,target)
      end
    end
    # Multiply all effectivenesses together
    ret = 1
    typeMods.each { |m| ret *= m }
    return ret
  end

  #=============================================================================
  # Accuracy check
  #=============================================================================
  def pbBaseAccuracy(user,target); return @accuracy; end

  # Accuracy calculations for one-hit KO moves and "always hit" moves are
  # handled elsewhere.
  def pbAccuracyCheck(user,target)
    # "Always hit" effects and "always hit" accuracy
    return true if target.effects[PBEffects::Telekinesis]>0
    return true if target.effects[PBEffects::Minimize] && tramplesMinimize?(1)
    baseAcc = pbBaseAccuracy(user,target)
    return true if baseAcc==0
    # Calculate all multiplier effects
    modifiers = {}
    modifiers[:base_accuracy]  = baseAcc
    modifiers[:accuracy_stage] = user.stages[:ACCURACY]
    modifiers[:evasion_stage]  = target.stages[:EVASION]
    modifiers[:accuracy_multiplier] = 1.0
    modifiers[:evasion_multiplier]  = 1.0
    pbCalcAccuracyModifiers(user,target,modifiers)
    # Check if move can't miss
    return true if modifiers[:base_accuracy] == 0
    # Calculation
    accStage = [[modifiers[:accuracy_stage], -6].max, 6].min + 6
    evaStage = [[modifiers[:evasion_stage], -6].max, 6].min + 6
    stageMul = [3,3,3,3,3,3, 3, 4,5,6,7,8,9]
    stageDiv = [9,8,7,6,5,4, 3, 3,3,3,3,3,3]
    accuracy = 100.0 * stageMul[accStage] / stageDiv[accStage]
    evasion  = 100.0 * stageMul[evaStage] / stageDiv[evaStage]
    accuracy = (accuracy * modifiers[:accuracy_multiplier]).round
    evasion  = (evasion  * modifiers[:evasion_multiplier]).round
    evasion = 1 if evasion < 1
    # Calculation
    return @battle.pbRandom(100) < modifiers[:base_accuracy] * accuracy / evasion
  end

  def pbCalcAccuracyModifiers(user,target,modifiers)
    # Ability effects that alter accuracy calculation
    if user.abilityActive?
      BattleHandlers.triggerAccuracyCalcUserAbility(user.ability,
         modifiers,user,target,self,@calcType)
    end
    user.eachAlly do |b|
      next if !b.abilityActive?
      BattleHandlers.triggerAccuracyCalcUserAllyAbility(b.ability,
         modifiers,user,target,self,@calcType)
    end
    if target.abilityActive? && !@battle.moldBreaker
      BattleHandlers.triggerAccuracyCalcTargetAbility(target.ability,
         modifiers,user,target,self,@calcType)
    end
    # Item effects that alter accuracy calculation
    if user.itemActive?
      BattleHandlers.triggerAccuracyCalcUserItem(user.item,
         modifiers,user,target,self,@calcType)
    end
    if target.itemActive?
      BattleHandlers.triggerAccuracyCalcTargetItem(target.item,
         modifiers,user,target,self,@calcType)
    end
    # Other effects, inc. ones that set accuracy_multiplier or evasion_stage to
    # specific values
    if @battle.field.effects[PBEffects::Gravity] > 0
      modifiers[:accuracy_multiplier] *= 5 / 3.0
    end
    if @battle.pbWeather == :Fog
      if !user.pbHasType?(:FAIRY)
        modifiers[:accuracy_multiplier] *= 0.75
      end
    end
    if user.effects[PBEffects::MicleBerry]
      user.effects[PBEffects::MicleBerry] = false
      modifiers[:accuracy_multiplier] *= 1.2
    end
    modifiers[:evasion_stage] = 0 if target.effects[PBEffects::Foresight] && modifiers[:evasion_stage] > 0
    modifiers[:evasion_stage] = 0 if target.effects[PBEffects::MiracleEye] && modifiers[:evasion_stage] > 0
  end

  #=============================================================================
  # Critical hit check
  #=============================================================================
  # Return values:
  #   -1: Never a critical hit.
  #    0: Calculate normally.
  #    1: Always a critical hit.
  def pbCritialOverride(user,target); return 0; end

  # Returns whether the move will be a critical hit.
  def pbIsCritical?(user,target)
    return false if target.pbOwnSide.effects[PBEffects::LuckyChant]>0
    # Set up the critical hit ratios
    ratios = (Settings::NEW_CRITICAL_HIT_RATE_MECHANICS) ? [24,8,2,1] : [16,8,4,3,2]
    c = 0
    # Ability effects that alter critical hit rate
    if c>=0 && user.abilityActive?
      c = BattleHandlers.triggerCriticalCalcUserAbility(user.ability,user,target,c)
    end
    if c>=0 && target.abilityActive? && !@battle.moldBreaker
      c = BattleHandlers.triggerCriticalCalcTargetAbility(target.ability,user,target,c)
    end
    # Item effects that alter critical hit rate
    if c>=0 && user.itemActive?
      c = BattleHandlers.triggerCriticalCalcUserItem(user.item,user,target,c)
    end
    if c>=0 && target.itemActive?
      c = BattleHandlers.triggerCriticalCalcTargetItem(target.item,user,target,c)
    end
    return false if c<0
    # Move-specific "always/never a critical hit" effects
    case pbCritialOverride(user,target)
    when 1  then return true
    when -1 then return false
    end
    # Other effects
    return true if c>50   # Merciless
    return true if user.effects[PBEffects::LaserFocus]>0
    c += 1 if highCriticalRate?
    c += user.effects[PBEffects::FocusEnergy]
    c += 1 if user.inHyperMode? && @type == :SHADOW
    c = ratios.length-1 if c>=ratios.length
    # Calculation
    return @battle.pbRandom(ratios[c])==0
  end

  #=============================================================================
  # Damage calculation
  #=============================================================================
  def pbBaseDamage(baseDmg,user,target);              return baseDmg;    end
  def pbBaseDamageMultiplier(damageMult,user,target); return damageMult; end
  def pbModifyDamage(damageMult,user,target);         return damageMult; end

  def pbGetAttackStats(user,target)
    if specialMove?
      return user.spatk, user.stages[:SPECIAL_ATTACK]+6
    end
    return user.attack, user.stages[:ATTACK]+6
  end

  def pbGetDefenseStats(user,target)
    if specialMove?
      return target.spdef, target.stages[:SPECIAL_DEFENSE]+6
    end
    return target.defense, target.stages[:DEFENSE]+6
  end

  def pbCalcDamage(user,target,numTargets=1)
    return if statusMove?
    if target.damageState.disguise
      target.damageState.calcDamage = 1
      return
    end
    stageMul = [2,2,2,2,2,2, 2, 3,4,5,6,7,8]
    stageDiv = [8,7,6,5,4,3, 2, 2,2,2,2,2,2]
    # Get the move's type
    type = @calcType   # nil is treated as physical
    # Calculate whether this hit deals critical damage
    target.damageState.critical = pbIsCritical?(user,target)
    # Calcuate base power of move
    baseDmg = pbBaseDamage(@baseDamage,user,target)
    # Calculate user's attack stat
    atk, atkStage = pbGetAttackStats(user,target)
    if !target.hasActiveAbility?(:UNAWARE) || @battle.moldBreaker
      atkStage = 6 if target.damageState.critical && atkStage<6
      atk = (atk.to_f*stageMul[atkStage]/stageDiv[atkStage]).floor
    end
    # Calculate target's defense stat
    defense, defStage = pbGetDefenseStats(user,target)
    if !user.hasActiveAbility?(:UNAWARE)
      defStage = 6 if target.damageState.critical && defStage>6
      defense = (defense.to_f*stageMul[defStage]/stageDiv[defStage]).floor
    end
    # Calculate all multiplier effects
    multipliers = {
      :base_damage_multiplier  => 1.0,
      :attack_multiplier       => 1.0,
      :defense_multiplier      => 1.0,
      :final_damage_multiplier => 1.0
    }
    pbCalcDamageMultipliers(user,target,numTargets,type,baseDmg,multipliers)
    # Main damage calculation
    baseDmg = [(baseDmg * multipliers[:base_damage_multiplier]).round, 1].max
    atk     = [(atk     * multipliers[:attack_multiplier]).round, 1].max
    defense = [(defense * multipliers[:defense_multiplier]).round, 1].max
    damage  = (((2.0 * user.level / 5 + 2).floor * baseDmg * atk / defense).floor / 50).floor + 2
    damage  = [(damage  * multipliers[:final_damage_multiplier]).round, 1].max
    target.damageState.calcDamage = damage
  end

  def pbCalcDamageMultipliers(user,target,numTargets,type,baseDmg,multipliers)
    # Global abilities
    if (@battle.pbCheckGlobalAbility(:DARKAURA) && type == :DARK) ||
       (@battle.pbCheckGlobalAbility(:FAIRYAURA) && type == :FAIRY) ||
       (@battle.pbCheckGlobalAbility(:GAIAFORCE) && type == :GROUND) ||
       (@battle.pbCheckGlobalAbility(:FEVERPITCH) && type == :POISON)
      if @battle.pbCheckGlobalAbility(:AURABREAK)
        multipliers[:base_damage_multiplier] *= 2 / 3.0
      else
        multipliers[:base_damage_multiplier] *= 4 / 3.0
      end
    end
    # Ability effects that alter damage
    if user.abilityActive?
      BattleHandlers.triggerDamageCalcUserAbility(user.ability,
         user,target,self,multipliers,baseDmg,type)
    end
    if !@battle.moldBreaker
      # NOTE: It's odd that the user's Mold Breaker prevents its partner's
      #       beneficial abilities (i.e. Flower Gift boosting Atk), but that's
      #       how it works.
      user.eachAlly do |b|
        next if !b.abilityActive?
        BattleHandlers.triggerDamageCalcUserAllyAbility(b.ability,
           user,target,self,multipliers,baseDmg,type)
      end
      if target.abilityActive?
        BattleHandlers.triggerDamageCalcTargetAbility(target.ability,
           user,target,self,multipliers,baseDmg,type) if !@battle.moldBreaker
        BattleHandlers.triggerDamageCalcTargetAbilityNonIgnorable(target.ability,
           user,target,self,multipliers,baseDmg,type)
      end
      target.eachAlly do |b|
        next if !b.abilityActive?
        BattleHandlers.triggerDamageCalcTargetAllyAbility(b.ability,
           user,target,self,multipliers,baseDmg,type)
      end
    end
    # Item effects that alter damage
    if user.itemActive?
      BattleHandlers.triggerDamageCalcUserItem(user.item,
         user,target,self,multipliers,baseDmg,type)
    end
    if target.itemActive?
      BattleHandlers.triggerDamageCalcTargetItem(target.item,
         user,target,self,multipliers,baseDmg,type)
    end
    # Parental Bond's second attack
    if user.effects[PBEffects::ParentalBond]==1
      multipliers[:base_damage_multiplier] /= 4
    end
    if user.effects[PBEffects::EchoChamber]==1
      multipliers[:base_damage_multiplier] /= 4
    end
    # Other
    if user.effects[PBEffects::MeFirst]
      multipliers[:base_damage_multiplier] *= 1.5
    end
    if user.effects[PBEffects::HelpingHand] && !self.is_a?(PokeBattle_Confusion)
      multipliers[:base_damage_multiplier] *= 1.5
    end
    if user.effects[PBEffects::Charge]>0 && type == :ELECTRIC
      multipliers[:base_damage_multiplier] *= 2
    end
    # Mud Sport
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
    # Water Sport
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
    # Terrain moves
    case @battle.field.terrain
    when :Electric
      multipliers[:base_damage_multiplier] *= 1.5 if type == :ELECTRIC && user.affectedByTerrain?
    when :Grassy
      multipliers[:base_damage_multiplier] *= 1.5 if type == :GRASS && user.affectedByTerrain?
    when :Psychic
      multipliers[:base_damage_multiplier] *= 1.5 if type == :PSYCHIC && user.affectedByTerrain?
    when :Poison
      multipliers[:base_damage_multiplier] *= 1.5 if type == :POISON && user.affectedByTerrain?
    when :Misty
      multipliers[:base_damage_multiplier] /= 2 if type == :DRAGON && target.affectedByTerrain?
    end
    # Badge multipliers
    if @battle.internalBattle
      if user.pbOwnedByPlayer?
        if physicalMove? && @battle.pbPlayer.badge_count >= Settings::NUM_BADGES_BOOST_ATTACK
          multipliers[:attack_multiplier] *= 1.1
        elsif specialMove? && @battle.pbPlayer.badge_count >= Settings::NUM_BADGES_BOOST_SPATK
          multipliers[:attack_multiplier] *= 1.1
        end
      end
      if target.pbOwnedByPlayer?
        if physicalMove? && @battle.pbPlayer.badge_count >= Settings::NUM_BADGES_BOOST_DEFENSE
          multipliers[:defense_multiplier] *= 1.1
        elsif specialMove? && @battle.pbPlayer.badge_count >= Settings::NUM_BADGES_BOOST_SPDEF
          multipliers[:defense_multiplier] *= 1.1
        end
      end
    end
    # Multi-targeting attacks
    if numTargets>1
      multipliers[:final_damage_multiplier] *= 0.75
    end
    # Weather
    case @battle.pbWeather
    when :Sun, :HarshSun
      if type == :FIRE
        multipliers[:final_damage_multiplier] *= 1.5
      elsif type == :WATER && !target.hasActiveAbility?(:STEAMPOWERED)
        multipliers[:final_damage_multiplier] /= 2
      end
    when :Rain, :HeavyRain
      if type == :FIRE && !target.hasActiveAbility?(:STEAMPOWERED)
        multipliers[:final_damage_multiplier] /= 2
      elsif type == :WATER
        multipliers[:final_damage_multiplier] *= 1.5
      end
    when :Starstorm
     if type == :COSMIC
       multipliers[:final_damage_multiplier] *= 1.5
     elsif type == :STEEL
       multipliers[:final_damage_multiplier] /= 2
     elsif target.pbHasType?(:COSMIC) && (physicalMove? || @function="122")
	     multipliers[:defense_multiplier] *= 1.5
     end
    when :Windy
      if type == :FLYING
        multipliers[:final_damage_multiplier] *= 1.5
	    elsif type == :ROCK
        multipliers[:final_damage_multiplier] /= 2
      end
    when :Fog
      if type == :FAIRY
        multipliers[:final_damage_multiplier] *= 1.5
      elsif type == :DRAGON
	      multipliers[:final_damage_multiplier] /= 2
      end
    when :Eclipse
      if type == :DARK
        multipliers[:final_damage_multiplier] *= 1.5
      elsif type == :GHOST
        multipliers[:final_damage_multiplier] *= 1.5
      elsif type == :FAIRY
        multipliers[:final_damage_multiplier] /= 2
      elsif type == :PSYCHIC
        multipliers[:final_damage_multiplier] /= 2
      end
    when :Borealis
      if type == :PSYCHIC
        multipliers[:final_damage_multiplier] *= 1.5
      elsif type == :DARK
        multipliers[:final_damage_multiplier] /= 2
      end
    when :Rainbow
      if type == :GRASS
        multipliers[:final_damage_multiplier] *= 1.5
      elsif type == :ICE
        multipliers[:final_damage_multiplier] /= 2
      end
    when :Overcast
      if type == :GHOST
        multipliers[:final_damage_multiplier] *= 1.5
      end
    when :VolcanicAsh
      if type == :STEEL
        multipliers[:final_damage_multiplier] *= 1.5
      end
    when :Storm
      if type == :FIRE && !target.hasActiveAbility?(:STEAMPOWERED)
        multipliers[:final_damage_multiplier] /= 2
      elsif type == :WATER
        multipliers[:final_damage_multiplier] *= 1.5
      elsif type == :ELECTRIC
        multipliers[:final_damage_multiplier] *= 1.5
      end
    when :Humid
      if type == :BUG
        multipliers[:final_damage_multiplier] *= 1.5
      elsif type == :FIRE
        multipliers[:final_damage_multiplier] /= 2
      end
    when :TimeWarp
      if type == :TIME
        multipliers[:final_damage_multiplier] *= 1.5
      elsif type == :POISON
        multipliers[:final_damage_multiplier] /= 2
      elsif type == :DARK
        multipliers[:final_damage_multiplier] /= 2
      end
    when :Reverb
      if type == :SOUND
        multipliers[:final_damage_multiplier] *= 1.5
      elsif soundMove?
        multipliers[:final_damage_multiplier] *= 1.5
      elsif target.pbHasType?(:SOUND) && (physicalMove? || @function="122")
        multipliers[:defense_multiplier] *= 1.5
      end
    when :Sleet
      if type == :FIRE
        multipliers[:final_damage_multiplier] /= 2
      end
    when :DClear
      if type == :COSMIC
        multipliers[:final_damage_multiplier] *= 1.5
      end
    when :AcidRain
      if type == :POISON
        multipliers[:final_damage_multiplier] *= 1.5
      end
    when :Sandstorm
      if target.pbHasType?(:ROCK) && specialMove? && @function != "122"   # Psyshock
        multipliers[:defense_multiplier] *= 1.5
      end
    end
    # Critical hits
    if target.damageState.critical
      if Settings::NEW_CRITICAL_HIT_RATE_MECHANICS
        multipliers[:final_damage_multiplier] *= 1.5
      else
        multipliers[:final_damage_multiplier] *= 2
      end
    end
    # Random variance
    if !self.is_a?(PokeBattle_Confusion)
      random = 85+@battle.pbRandom(16)
      multipliers[:final_damage_multiplier] *= random / 100.0
    end
    # STAB
    if type && user.pbHasType?(type)
      if user.hasActiveAbility?(:ADAPTABILITY)
        multipliers[:final_damage_multiplier] *= 2
      else
        multipliers[:final_damage_multiplier] *= 1.5
      end
    end
    # Type effectiveness
    multipliers[:final_damage_multiplier] *= target.damageState.typeMod.to_f / Effectiveness::NORMAL_EFFECTIVE
    # Burn
    if user.status == :BURN && physicalMove? && damageReducedByBurn? &&
       !user.hasActiveAbility?(:GUTS)
      multipliers[:final_damage_multiplier] /= 2
    end
    # Aurora Veil, Reflect, Light Screen
    if !ignoresReflect? && !target.damageState.critical &&
       !user.hasActiveAbility?(:INFILTRATOR)
      if target.pbOwnSide.effects[PBEffects::AuroraVeil] > 0
        if @battle.pbSideBattlerCount(target)>1
          multipliers[:final_damage_multiplier] *= 2 / 3.0
        else
          multipliers[:final_damage_multiplier] /= 2
        end
      elsif target.pbOwnSide.effects[PBEffects::Reflect] > 0 && physicalMove?
        if @battle.pbSideBattlerCount(target)>1
          multipliers[:final_damage_multiplier] *= 2 / 3.0
        else
          multipliers[:final_damage_multiplier] /= 2
        end
      elsif target.pbOwnSide.effects[PBEffects::LightScreen] > 0 && specialMove?
        if @battle.pbSideBattlerCount(target) > 1
          multipliers[:final_damage_multiplier] *= 2 / 3.0
        else
          multipliers[:final_damage_multiplier] /= 2
        end
      end
    end
    # Minimize
    if target.effects[PBEffects::Minimize] && tramplesMinimize?(2)
      multipliers[:final_damage_multiplier] *= 2
    end
    # Move-specific base damage modifiers
    multipliers[:base_damage_multiplier] = pbBaseDamageMultiplier(multipliers[:base_damage_multiplier], user, target)
    # Move-specific final damage modifiers
    multipliers[:final_damage_multiplier] = pbModifyDamage(multipliers[:final_damage_multiplier], user, target)
  end

  #=============================================================================
  # Additional effect chance
  #=============================================================================
  def pbAdditionalEffectChance(user,target,effectChance=0)
    return 0 if target.hasActiveAbility?(:SHIELDDUST) && !@battle.moldBreaker
    ret = (effectChance>0) ? effectChance : @addlEffect
    if Settings::MECHANICS_GENERATION >= 6 || @function != "0A4"   # Secret Power
      ret *= 2 if user.hasActiveAbility?(:SERENEGRACE) ||
                  user.pbOwnSide.effects[PBEffects::Rainbow]>0
    end
    ret = 100 if $DEBUG && Input.press?(Input::CTRL)
    return ret
  end

  # NOTE: Flinching caused by a move's effect is applied in that move's code,
  #       not here.
  def pbFlinchChance(user,target)
    return 0 if flinchingMove?
    return 0 if target.hasActiveAbility?(:SHIELDDUST) && !@battle.moldBreaker
    ret = 0
    if user.hasActiveAbility?(:STENCH,true)
      ret = 10
    elsif user.hasActiveItem?([:KINGSROCK,:RAZORFANG],true)
      ret = 10
    end
    ret *= 2 if user.hasActiveAbility?(:SERENEGRACE) ||
                user.pbOwnSide.effects[PBEffects::Rainbow]>0
    return ret
  end
end


BattleHandlers::SpeedCalcAbility.add(:SANDRUSH,
  proc { |ability,battler,mult|
    next mult * 2 if [:Sandstorm, :DustDevil].include?(battler.battle.pbWeather)
  }
)

BattleHandlers::SpeedCalcAbility.add(:SLUSHRUSH,
  proc { |ability,battler,mult|
    next mult * 2 if [:Hail, :Sleet].include?(battler.battle.pbWeather)
  }
)

BattleHandlers::SpeedCalcAbility.add(:STARSPRINT,
  proc { |ability,battler,mult|
    next mult * 2 if [:Starstorm].include?(battler.battle.pbWeather)
  }
)

BattleHandlers::SpeedCalcAbility.add(:ASHRUSH,
  proc { |ability,battler,mult|
    next mult * 2 if [:VolcanicAsh, :DAshfall].include?(battler.battle.pbWeather)
  }
)

BattleHandlers::SpeedCalcAbility.add(:TOXICRUSH,
  proc { |ability,battler,mult|
    next mult * 2 if [:AcidRain].include?(battler.battle.pbWeather)
  }
)

BattleHandlers::StatusImmunityAbility.copy(:WATERVEIL,:FEVERPITCH)
BattleHandlers::StatusCureAbility.copy(:WATERVEIL,:FEVERPITCH)

BattleHandlers::DamageCalcUserAbility.add(:SUBWOOFER,
  proc { |ability,user,target,move,mults,baseDmg,type|
    if user.index != target.index && move && move.soundMove? && (baseDmg * mults[:base_damage_multiplier] <= 70)
      mults[:base_damage_multiplier]*1.5
    end
  }
)

BattleHandlers::DamageCalcUserAbility.add(:FAIRYBUBBLE,
  proc { |ability,user,target,move,mults,baseDmg,type|
    mults[:attack_multiplier] *= 2 if type == :FAIRY
  }
)

BattleHandlers::DamageCalcTargetAbility.add(:FEVERPITCH,
  proc { |ability,user,target,move,mults,baseDmg,type|
    if type == :PSYCHIC
      mults[:final_damage_multiplier] *= 0.5
    end
  }
)

module BattleHandlers
  StatLossImmunityAbilityNonIgnorableSandy = AbilityHandlerHash.new   # Unshaken
  def self.triggerStatLossImmunityAbilityNonIgnorableSandy(ability,battler,stat,battle,showMessages)
    ret = StatLossImmunityAbilityNonIgnorableSandy.trigger(ability,battler,stat,battle,showMessages)
    return (ret!=nil) ? ret : false
  end
end

BattleHandlers::StatLossImmunityAbilityNonIgnorableSandy.add(:UNSHAKEN,
  proc { |ability,battler,stat,battle,showMessages|
    if showMessages
      battle.pbShowAbilitySplash(battler)
      if PokeBattle_SceneConstants::USE_ABILITY_SPLASH
        battle.pbDisplay(_INTL("{1}'s stats cannot be lowered!",battler.pbThis))
      else
        battle.pbDisplay(_INTL("{1}'s {2} prevents stat loss!",battler.pbThis,battler.abilityName))
      end
      battle.pbHideAbilitySplash(battler)
    end
    next true
  }
)

BattleHandlers::MoveImmunityTargetAbility.add(:WATERCOMPACTION,
  proc { |ability,user,target,move,type,battle|
    next pbBattleMoveImmunityStatAbility(user,target,move,type,:WATER,:SPECIAL_DEFENSE,2,battle)
  }
)

BattleHandlers::MoveImmunityTargetAbility.add(:LEGENDARMOR,
  proc { |ability,user,target,move,type,battle|
    next pbBattleMoveImmunityHealAbility(user,target,move,type,:DRAGON,battle)
  }
)

BattleHandlers::MoveImmunityTargetAbility.add(:UNTAINTED,
  proc { |ability,user,target,move,type,battle|
    next pbBattleMoveImmunityHealAbility(user,target,move,type,:DARK,battle)
  }
)

BattleHandlers::MoveImmunityTargetAbility.add(:CORRUPTION,
  proc { |ability,user,target,move,type,battle|
    next pbBattleMoveImmunityHealAbility(user,target,move,type,:FAIRY,battle)
  }
)

BattleHandlers::MoveImmunityTargetAbility.add(:DIMENSIONBLOCK,
  proc { |ability,user,target,move,type,battle|
    next pbBattleMoveImmunityHealAbility(user,target,move,type,:COSMIC,battle)
  }
)

BattleHandlers::MoveImmunityTargetAbility.add(:MENTALBLOCK,
  proc { |ability,user,target,move,type,battle|
    next pbBattleMoveImmunityHealAbility(user,target,move,type,:PSYCHIC,battle)
  }
)

BattleHandlers::MoveBaseTypeModifierAbility.add(:STELLARIZE,
  proc { |ability,user,move,type|
    next if type != :NORMAL || !GameData::Type.exists?(:COSMIC)
    move.powerBoost = true
    next :COSMIC
  }
)

BattleHandlers::MoveBaseTypeModifierAbility.add(:ENTYMATE,
  proc { |ability,user,move,type|
    next if type != :NORMAL || !GameData::Type.exists?(:BUG)
    move.powerBoost = true
    next :BUG
  }
)

BattleHandlers::DamageCalcUserAbility.copy(:AERILATE,:PIXILATE,:REFRIGERATE,:GALVANIZE,:ENTYMATE,:STELLARIZE)

BattleHandlers::DamageCalcUserAbility.add(:COMPOSURE,
  proc { |ability,user,target,move,mults,baseDmg,type|
    mults[:attack_multiplier] *= 2 if move.specialMove?
  }
)

BattleHandlers::DamageCalcUserAbility.add(:AMPLIFIER,
  proc { |ability,user,target,move,mults,baseDmg,type|
    mults[:base_damage_multiplier] = (mults[:base_damage_multiplier]*1.5).round if move.soundMove?
  }
)

BattleHandlers::DamageCalcUserAbility.add(:TIGHTFOCUS,
  proc { |ability,user,target,move,mults,baseDmg,type|
    mults[:base_damage_multiplier] = (mults[:base_damage_multiplier]*1.5).round if move.beamMove?
  }
)

BattleHandlers::DamageCalcUserAbility.add(:VAMPIRIC,
  proc { |ability,user,target,move,mults,baseDmg,type|
  mults[:base_damage_multiplier] = (mults[:base_damage_multiplier]*1.5).round if move.function=="14F" || move.function=="0DD"
  }
)

BattleHandlers::DamageCalcTargetAbility.add(:ICESCALES,
  proc { |ability,user,target,move,mults,baseDmg,type|
    mults[:defense_multiplier] *= 2 if move.specialMove? || !move.function=="122"   # Psyshock
  }
)

class PokeBattle_Battler
  def pbLowerSpAtkStatStageMindGames(user)
    return false if fainted?
    # NOTE: Substitute intentially blocks Intimidate even if self has Contrary.
    if @effects[PBEffects::Substitute]>0
      if PokeBattle_SceneConstants::USE_ABILITY_SPLASH
        @battle.pbDisplay(_INTL("{1} is protected by its substitute!",pbThis))
      else
        @battle.pbDisplay(_INTL("{1}'s substitute protected it from {2}'s {3}!",
           pbThis,user.pbThis(true),user.abilityName))
      end
      return false
    end
    if PokeBattle_SceneConstants::USE_ABILITY_SPLASH
      return pbLowerStatStageByAbility(:SPECIAL_ATTACK,1,user,false)
    end
    # NOTE: These checks exist to ensure appropriate messages are shown if
    #       Intimidate is blocked somehow (i.e. the messages should mention the
    #       Intimidate ability by name).
    if !hasActiveAbility?(:CONTRARY)
      if pbOwnSide.effects[PBEffects::Mist]>0
        @battle.pbDisplay(_INTL("{1} is protected from {2}'s {3} by Mist!",
           pbThis,user.pbThis(true),user.abilityName))
        return false
      end
      if abilityActive?
        if BattleHandlers.triggerStatLossImmunityAbility(@ability,self,:SPECIAL_ATTACK,@battle,false) ||
           BattleHandlers.triggerStatLossImmunityAbilityNonIgnorable(@ability,self,:SPECIAL_ATTACK,@battle,false) ||
           BattleHandlers.triggerStatLossImmunityAbilityNonIgnorableSandy(@ability,self,:SPECIAL_ATTACK,@battle,false)
          @battle.pbDisplay(_INTL("{1}'s {2} prevented {3}'s {4} from working!",
             pbThis,abilityName,user.pbThis(true),user.abilityName))
          return false
        end
      end
      eachAlly do |b|
        next if !b.abilityActive?
        if BattleHandlers.triggerStatLossImmunityAllyAbility(b.ability,b,self,:SPECIAL_ATTACK,@battle,false)
          @battle.pbDisplay(_INTL("{1} is protected from {2}'s {3} by {4}'s {5}!",
             pbThis,user.pbThis(true),user.abilityName,b.pbThis(true),b.abilityName))
          return false
        end
      end
    end
    return false if !pbCanLowerStatStage?(:SPECIAL_ATTACK,user)
    return pbLowerStatStageByCause(:SPECIAL_ATTACK,1,user,user.abilityName)
  end
  def pbLowerSpeedStatStageMedusoid(user)
    return false if fainted?
    # NOTE: Substitute intentially blocks Intimidate even if self has Contrary.
    if @effects[PBEffects::Substitute]>0
      if PokeBattle_SceneConstants::USE_ABILITY_SPLASH
        @battle.pbDisplay(_INTL("{1} is protected by its substitute!",pbThis))
      else
        @battle.pbDisplay(_INTL("{1}'s substitute protected it from {2}'s {3}!",
           pbThis,user.pbThis(true),user.abilityName))
      end
      return false
    end
    if PokeBattle_SceneConstants::USE_ABILITY_SPLASH
      return pbLowerStatStageByAbility(:SPEED,1,user,false)
    end
    # NOTE: These checks exist to ensure appropriate messages are shown if
    #       Intimidate is blocked somehow (i.e. the messages should mention the
    #       Intimidate ability by name).
    if !hasActiveAbility?(:CONTRARY)
      if pbOwnSide.effects[PBEffects::Mist]>0
        @battle.pbDisplay(_INTL("{1} is protected from {2}'s {3} by Mist!",
           pbThis,user.pbThis(true),user.abilityName))
        return false
      end
      if abilityActive?
        if BattleHandlers.triggerStatLossImmunityAbility(@ability,self,:SPEED,@battle,false) ||
           BattleHandlers.triggerStatLossImmunityAbilityNonIgnorable(@ability,self,:SPEED,@battle,false) ||
           BattleHandlers.triggerStatLossImmunityAbilityNonIgnorableSandy(@ability,self,:SPEED,@battle,false)
          @battle.pbDisplay(_INTL("{1}'s {2} prevented {3}'s {4} from working!",
             pbThis,abilityName,user.pbThis(true),user.abilityName))
          return false
        end
      end
      eachAlly do |b|
        next if !b.abilityActive?
        if BattleHandlers.triggerStatLossImmunityAllyAbility(b.ability,b,self,:SPEED,@battle,false)
          @battle.pbDisplay(_INTL("{1} is protected from {2}'s {3} by {4}'s {5}!",
             pbThis,user.pbThis(true),user.abilityName,b.pbThis(true),b.abilityName))
          return false
        end
      end
    end
    return false if !pbCanLowerStatStage?(:SPEED,user)
    return pbLowerStatStageByCause(:SPEED,1,user,user.abilityName)
  end
  def pbCanInflictStatus?(newStatus,user,showMessages,move=nil,ignoreStatus=false)
    return false if fainted?
    selfInflicted = (user && user.index==@index)
    # Already have that status problem
    if self.status==newStatus && !ignoreStatus
      if showMessages
        msg = ""
        case self.status
        when :SLEEP     then msg = _INTL("{1} is already asleep!", pbThis)
        when :POISON    then msg = _INTL("{1} is already poisoned!", pbThis)
        when :BURN      then msg = _INTL("{1} already has a burn!", pbThis)
        when :PARALYSIS then msg = _INTL("{1} is already paralyzed!", pbThis)
        when :FROZEN    then msg = _INTL("{1} is already frozen solid!", pbThis)
        end
        @battle.pbDisplay(msg)
      end
      return false
    end
    # Trying to replace a status problem with another one
    if self.status != :NONE && !ignoreStatus && !selfInflicted
      @battle.pbDisplay(_INTL("It doesn't affect {1}...",pbThis(true))) if showMessages
      return false
    end
    # Trying to inflict a status problem on a Pokémon behind a substitute
    if @effects[PBEffects::Substitute]>0 && !(move && move.ignoresSubstitute?(user)) &&
       !selfInflicted
      @battle.pbDisplay(_INTL("It doesn't affect {1}...",pbThis(true))) if showMessages
      return false
    end
    # Weather immunity
    if newStatus == :FROZEN && [:Sun, :HarshSun].include?(@battle.pbWeather)
      @battle.pbDisplay(_INTL("It doesn't affect {1}...",pbThis(true))) if showMessages
      return false
    end
    # Terrains immunity
    if affectedByTerrain?
      case @battle.field.terrain
      when :Electric
        if newStatus == :SLEEP
          @battle.pbDisplay(_INTL("{1} surrounds itself with electrified terrain!",
             pbThis(true))) if showMessages
          return false
        end
      when :Misty
        @battle.pbDisplay(_INTL("{1} surrounds itself with misty terrain!",pbThis(true))) if showMessages
        return false
      end
    end
    # Uproar immunity
    if newStatus == :SLEEP && !(hasActiveAbility?(:SOUNDPROOF) && !@battle.moldBreaker)
      @battle.eachBattler do |b|
        next if b.effects[PBEffects::Uproar]==0
        @battle.pbDisplay(_INTL("But the uproar kept {1} awake!",pbThis(true))) if showMessages
        return false
      end
    end
    # Cacophony Immunity
    if newStatus == :SLEEP && hasActiveAbility?(:CACOPHONY)
      @battle.eachBattler do |b|
        next if hasActiveAbility?(:SOUNDPROOF)
        @battle.pbDisplay(_INTL("But the uproar kept {1} awake!",pbThis(true))) if showMessages
        return false
      end
    end
    # Type immunities
    hasImmuneType = false
    case newStatus
    when :SLEEP
      # No type is immune to sleep
    when :POISON
      if !(user && user.hasActiveAbility?(:CORROSION))
        hasImmuneType |= pbHasType?(:POISON)
        hasImmuneType |= pbHasType?(:STEEL)
      end
    when :BURN
      hasImmuneType |= pbHasType?(:FIRE)
    when :PARALYSIS
      hasImmuneType |= pbHasType?(:ELECTRIC) && Settings::MORE_TYPE_EFFECTS
    when :FROZEN
      hasImmuneType |= pbHasType?(:ICE)
    end
    if hasImmuneType
      @battle.pbDisplay(_INTL("It doesn't affect {1}...",pbThis(true))) if showMessages
      return false
    end
    # Ability immunity
    immuneByAbility = false; immAlly = nil
    if BattleHandlers.triggerStatusImmunityAbilityNonIgnorable(self.ability,self,newStatus)
      immuneByAbility = true
    elsif selfInflicted || !@battle.moldBreaker
      if abilityActive? && BattleHandlers.triggerStatusImmunityAbility(self.ability,self,newStatus)
        immuneByAbility = true
      else
        eachAlly do |b|
          next if !b.abilityActive?
          next if !BattleHandlers.triggerStatusImmunityAllyAbility(b.ability,self,newStatus)
          immuneByAbility = true
          immAlly = b
          break
        end
      end
    end
    if immuneByAbility
      if showMessages
        @battle.pbShowAbilitySplash(immAlly || self)
        msg = ""
        if PokeBattle_SceneConstants::USE_ABILITY_SPLASH
          case newStatus
          when :SLEEP     then msg = _INTL("{1} stays awake!", pbThis)
          when :POISON    then msg = _INTL("{1} cannot be poisoned!", pbThis)
          when :BURN      then msg = _INTL("{1} cannot be burned!", pbThis)
          when :PARALYSIS then msg = _INTL("{1} cannot be paralyzed!", pbThis)
          when :FROZEN    then msg = _INTL("{1} cannot be frozen solid!", pbThis)
          end
        elsif immAlly
          case newStatus
          when :SLEEP
            msg = _INTL("{1} stays awake because of {2}'s {3}!",
               pbThis,immAlly.pbThis(true),immAlly.abilityName)
          when :POISON
            msg = _INTL("{1} cannot be poisoned because of {2}'s {3}!",
               pbThis,immAlly.pbThis(true),immAlly.abilityName)
          when :BURN
            msg = _INTL("{1} cannot be burned because of {2}'s {3}!",
               pbThis,immAlly.pbThis(true),immAlly.abilityName)
          when :PARALYSIS
            msg = _INTL("{1} cannot be paralyzed because of {2}'s {3}!",
               pbThis,immAlly.pbThis(true),immAlly.abilityName)
          when :FROZEN
            msg = _INTL("{1} cannot be frozen solid because of {2}'s {3}!",
               pbThis,immAlly.pbThis(true),immAlly.abilityName)
          end
        else
          case newStatus
          when :SLEEP     then msg = _INTL("{1} stays awake because of its {2}!", pbThis, abilityName)
          when :POISON    then msg = _INTL("{1}'s {2} prevents poisoning!", pbThis, abilityName)
          when :BURN      then msg = _INTL("{1}'s {2} prevents burns!", pbThis, abilityName)
          when :PARALYSIS then msg = _INTL("{1}'s {2} prevents paralysis!", pbThis, abilityName)
          when :FROZEN    then msg = _INTL("{1}'s {2} prevents freezing!", pbThis, abilityName)
          end
        end
        @battle.pbDisplay(msg)
        @battle.pbHideAbilitySplash(immAlly || self)
      end
      return false
    end
    # Safeguard immunity
    if pbOwnSide.effects[PBEffects::Safeguard]>0 && !selfInflicted && move &&
       !(user && user.hasActiveAbility?(:INFILTRATOR))
      @battle.pbDisplay(_INTL("{1}'s team is protected by Safeguard!",pbThis)) if showMessages
      return false
    end
    return true
  end
  def unstoppableAbility?(abil = nil)
    abil = @ability_id if !abil
    abil = GameData::Ability.try_get(abil)
    return false if !abil
    ability_blacklist = [
      # Form-changing abilities
      :BATTLEBOND,
      :DISGUISE,
#      :FLOWERGIFT,                                        # This can be stopped
      :FORECAST,
      :MULTITYPE,
      :POWERCONSTRUCT,
      :SCHOOLING,
      :SHIELDSDOWN,
      :STANCECHANGE,
      :ZENMODE,
      :DUAT,
      :BAROMETRIC,
      :ACCLIMATE,
      # Abilities intended to be inherent properties of a certain species
      :COMATOSE,
      :RKSSYSTEM
    ]
    return ability_blacklist.include?(abil.id)
  end
  def ungainableAbility?(abil = nil)
    abil = @ability_id if !abil
    abil = GameData::Ability.try_get(abil)
    return false if !abil
    ability_blacklist = [
      # Form-changing abilities
      :BATTLEBOND,
      :DISGUISE,
      :FLOWERGIFT,
      :FORECAST,
      :MULTITYPE,
      :POWERCONSTRUCT,
      :SCHOOLING,
      :SHIELDSDOWN,
      :STANCECHANGE,
      :ZENMODE,
      :ACCLIMATE,
      :BAROMETRIC,
      :DUAT,
      # Appearance-changing abilities
      :ILLUSION,
      :IMPOSTER,
      # Abilities intended to be inherent properties of a certain species
      :COMATOSE,
      :RKSSYSTEM
    ]
    return ability_blacklist.include?(abil.id)
  end
  def takesDustDevilDamage?
    return false if hasActiveAbility?(:BAROMETRIC)
    return false if !takesIndirectDamage?
    return false if pbHasType?(:GROUND) || pbHasType?(:FLYING)
    return false if inTwoTurnAttack?("0CA","0CB")   # Dig, Dive
    return false if hasActiveAbility?([:OVERCOAT,:SANDFORCE,:SANDRUSH,:SANDVEIL])
    return false if hasActiveItem?(:SAFETYGOGGLES)
    return true
  end
  def takesAcidRainDamage?
    return false if hasActiveAbility?(:BAROMETRIC)
    return false if !takesIndirectDamage?
    return false if pbHasType?(:POISON) || pbHasType?(:STEEL)
    return false if inTwoTurnAttack?("0CA","0CB")   # Dig, Dive
    return false if hasActiveAbility?([:OVERCOAT,:SANDFORCE,:SANDRUSH,:SANDVEIL])
    return false if hasActiveItem?(:SAFETYGOGGLES)
    return true
  end
  def takesStarstormDamage?
    return false if hasActiveAbility?(:BAROMETRIC)
    return false if !takesIndirectDamage?
    return false if pbHasType?(:COSMIC)
    return false if inTwoTurnAttack?("0CA","0CB")   # Dig, Dive
    return false if hasActiveAbility?([:OVERCOAT,:ICEBODY,:SNOWCLOAK])
    return false if hasActiveItem?(:SAFETYGOGGLES)
    return true
  end
end

class PokeBattle_Move
    def beamMove?;          return @flags[/p/]; end
end

class PokeBattle_Move_049 < PokeBattle_TargetStatDownMove
  def ignoresSubstitute?(user); return true; end

  def initialize(battle,move)
    super
    @statDown = [:EVASION,1]
  end

  def pbFailsAgainstTarget?(user,target)
    targetSide = target.pbOwnSide
    targetOpposingSide = target.pbOpposingSide
    return false if targetSide.effects[PBEffects::AuroraVeil]>0 ||
                    targetSide.effects[PBEffects::LightScreen]>0 ||
                    targetSide.effects[PBEffects::Reflect]>0 ||
                    targetSide.effects[PBEffects::Mist]>0 ||
                    targetSide.effects[PBEffects::Safeguard]>0
    return false if targetSide.effects[PBEffects::StealthRock] ||
                    targetSide.effects[PBEffects::Spikes]>0 ||
                    targetSide.effects[PBEffects::ToxicSpikes]>0 ||
                    targetSide.effects[PBEffects::StickyWeb]
    return false if Settings::MECHANICS_GENERATION >= 6 &&
                    (targetOpposingSide.effects[PBEffects::StealthRock] ||
                    targetOpposingSide.effects[PBEffects::Spikes]>0 ||
                    targetOpposingSide.effects[PBEffects::ToxicSpikes]>0 ||
                    targetOpposingSide.effects[PBEffects::StickyWeb] ||
                    targetOpposingSide.effects[PBEffects::CometShards])
    return false if Settings::MECHANICS_GENERATION >= 8 && @battle.field.terrain != :None
    return super
  end

  def pbEffectAgainstTarget(user,target)
    if target.pbCanLowerStatStage?(@statDown[0],user,self)
      target.pbLowerStatStage(@statDown[0],@statDown[1],user)
    end
    if target.pbOwnSide.effects[PBEffects::AuroraVeil]>0
      target.pbOwnSide.effects[PBEffects::AuroraVeil] = 0
      @battle.pbDisplay(_INTL("{1}'s Aurora Veil wore off!",target.pbTeam))
    end
    if target.pbOwnSide.effects[PBEffects::LightScreen]>0
      target.pbOwnSide.effects[PBEffects::LightScreen] = 0
      @battle.pbDisplay(_INTL("{1}'s Light Screen wore off!",target.pbTeam))
    end
    if target.pbOwnSide.effects[PBEffects::Reflect]>0
      target.pbOwnSide.effects[PBEffects::Reflect] = 0
      @battle.pbDisplay(_INTL("{1}'s Reflect wore off!",target.pbTeam))
    end
    if target.pbOwnSide.effects[PBEffects::Mist]>0
      target.pbOwnSide.effects[PBEffects::Mist] = 0
      @battle.pbDisplay(_INTL("{1}'s Mist faded!",target.pbTeam))
    end
    if target.pbOwnSide.effects[PBEffects::Safeguard]>0
      target.pbOwnSide.effects[PBEffects::Safeguard] = 0
      @battle.pbDisplay(_INTL("{1} is no longer protected by Safeguard!!",target.pbTeam))
    end
    if target.pbOwnSide.effects[PBEffects::StealthRock] ||
       (Settings::MECHANICS_GENERATION >= 6 &&
       target.pbOpposingSide.effects[PBEffects::StealthRock])
      target.pbOwnSide.effects[PBEffects::StealthRock]      = false
      target.pbOpposingSide.effects[PBEffects::StealthRock] = false if Settings::MECHANICS_GENERATION >= 6
      @battle.pbDisplay(_INTL("{1} blew away stealth rocks!",user.pbThis))
    end
    if target.pbOwnSide.effects[PBEffects::Spikes]>0 ||
       (Settings::MECHANICS_GENERATION >= 6 &&
       target.pbOpposingSide.effects[PBEffects::Spikes]>0)
      target.pbOwnSide.effects[PBEffects::Spikes]      = 0
      target.pbOpposingSide.effects[PBEffects::Spikes] = 0 if Settings::MECHANICS_GENERATION >= 6
      @battle.pbDisplay(_INTL("{1} blew away spikes!",user.pbThis))
    end
    if target.pbOwnSide.effects[PBEffects::ToxicSpikes]>0 ||
       (Settings::MECHANICS_GENERATION >= 6 &&
       target.pbOpposingSide.effects[PBEffects::ToxicSpikes]>0)
      target.pbOwnSide.effects[PBEffects::ToxicSpikes]      = 0
      target.pbOpposingSide.effects[PBEffects::ToxicSpikes] = 0 if Settings::MECHANICS_GENERATION >= 6
      @battle.pbDisplay(_INTL("{1} blew away poison spikes!",user.pbThis))
    end
    if target.pbOwnSide.effects[PBEffects::StickyWeb] ||
       (Settings::MECHANICS_GENERATION >= 6 &&
       target.pbOpposingSide.effects[PBEffects::StickyWeb])
      target.pbOwnSide.effects[PBEffects::StickyWeb]      = false
      target.pbOpposingSide.effects[PBEffects::StickyWeb] = false if Settings::MECHANICS_GENERATION >= 6
      @battle.pbDisplay(_INTL("{1} blew away sticky webs!",user.pbThis))
    end
    if target.pbOwnSide.effects[PBEffects::CometShards] ||
       (Settings::MECHANICS_GENERATION >= 6 &&
       target.pbOpposingSide.effects[PBEffects::CometShards])
      target.pbOwnSide.effects[PBEffects::CometShards]      = false
      target.pbOpposingSide.effects[PBEffects::CometShards] = false if Settings::MECHANICS_GENERATION >= 6
      @battle.pbDisplay(_INTL("{1} blew away stealth rocks!",user.pbThis))
    end
    if Settings::MECHANICS_GENERATION >= 8 && @battle.field.terrain != :None
      case @battle.field.terrain
      when :Electric
        @battle.pbDisplay(_INTL("The electricity disappeared from the battlefield."))
      when :Grassy
        @battle.pbDisplay(_INTL("The grass disappeared from the battlefield."))
      when :Misty
        @battle.pbDisplay(_INTL("The mist disappeared from the battlefield."))
      when :Psychic
        @battle.pbDisplay(_INTL("The weirdness disappeared from the battlefield."))
      when :Poison
        @battle.pbDisplay(_INTL("The toxic waste disappeared from the battlefield."))
      end
      @battle.field.terrain = :None
    end
  end
end


class PokeBattle_Move_103 < PokeBattle_Move
  def pbMoveFailed?(user,targets)
    if user.pbOpposingSide.effects[PBEffects::Spikes]>=3
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if battle.field.weather==:Windy
      @battle.pbDisplay(_INTL("The Wind prevented the hazards from being set!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbOpposingSide.effects[PBEffects::Spikes] += 1
    @battle.pbDisplay(_INTL("Spikes were scattered all around {1}'s feet!",
       user.pbOpposingTeam(true)))
  end
end

class PokeBattle_Move_104 < PokeBattle_Move
  def pbMoveFailed?(user,targets)
    if user.pbOpposingSide.effects[PBEffects::ToxicSpikes]>=2
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if battle.field.weather==:Windy
      @battle.pbDisplay(_INTL("The Wind prevented the hazards from being set!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbOpposingSide.effects[PBEffects::ToxicSpikes] += 1
    @battle.pbDisplay(_INTL("Poison spikes were scattered all around {1}'s feet!",
       user.pbOpposingTeam(true)))
  end
end

class PokeBattle_Move_105 < PokeBattle_Move
  def pbMoveFailed?(user,targets)
    if user.pbOpposingSide.effects[PBEffects::StealthRock] || user.pbOpposingSide.effects[PBEffects::CometShards]
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if battle.field.weather==:Windy
      @battle.pbDisplay(_INTL("The Wind prevented the hazards from being set!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbOpposingSide.effects[PBEffects::StealthRock] = true
    @battle.pbDisplay(_INTL("Pointed stones float in the air around {1}!",
       user.pbOpposingTeam(true)))
  end
end

class PokeBattle_Move_153 < PokeBattle_Move
  def pbMoveFailed?(user,targets)
    if user.pbOpposingSide.effects[PBEffects::StickyWeb]
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if battle.field.weather==:Windy
      @battle.pbDisplay(_INTL("The Wind prevented the hazards from being set!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbOpposingSide.effects[PBEffects::StickyWeb] = true
    @battle.pbDisplay(_INTL("A sticky web has been laid out beneath {1}'s feet!",
       user.pbOpposingTeam(true)))
  end
end

class PokeBattle_Move_178 < PokeBattle_Move
  def pbBaseDamage(baseDmg,user,target)
    if @battle.choices[target.index][0]!=:None &&
       ((@battle.choices[target.index][0]!=:UseMove &&
       @battle.choices[target.index][0]==:Shift) || target.movedThisRound?)
    else
      baseDmg *= 2
    end
    return baseDmg
  end
end

class PokeBattle_Move_17C < PokeBattle_Move_0BD
  def pbNumHits(user,targets)
    return 1 if targets.length > 1
    return 2
  end
end

class PokeBattle_Move_17D < PokeBattle_Move
  def pbEffectAgainstTarget(user,target)
    if target.effects[PBEffects::JawLockUser] ==-1 && !target.effects[PBEffects::JawLock] &&
      user.effects[PBEffects::JawLockUser] ==-1 && !user.effects[PBEffects::JawLock]
      user.effects[PBEffects::JawLock] = true
      target.effects[PBEffects::JawLock] = true
      user.effects[PBEffects::JawLockUser] = user.index
      target.effects[PBEffects::JawLockUser] = user.index
      @battle.pbDisplay(_INTL("Neither Pokémon can run away!"))
    end
  end
end

class PokeBattle_Move_17E < PokeBattle_Move
  def healingMove?; return true; end
  def worksWithNoTargets?; return true; end

  def pbMoveFailed?(user,targets)
    failed = true
    @battle.eachSameSideBattler(user) do |b|
      next if b.hp == b.totalhp
      failed = false
      break
    end
    if failed
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    return false
  end

  def pbFailsAgainstTarget?(user,target)
    if target.hp==target.totalhp
      @battle.pbDisplay(_INTL("{1}'s HP is full!",target.pbThis))
      return true
    elsif !target.canHeal?
      @battle.pbDisplay(_INTL("{1} is unaffected!",target.pbThis))
      return true
    end
    return false
  end

  def pbEffectAgainstTarget(user,target)
    hpGain = (target.totalhp/4.0).round
    target.pbRecoverHP(hpGain)
    @battle.pbDisplay(_INTL("{1}'s HP was restored.",target.pbThis))
  end

  def pbHealAmount(user)
    return (user.totalhp/4.0).round
  end
end

class PokeBattle_Move_188 < PokeBattle_Move_0A0
  def multiHitMove?;           return true; end
  def pbNumHits(user,targets); return 3;    end
end

class PokeBattle_Move_18C < PokeBattle_Move
end

class PokeBattle_Move_18D < PokeBattle_Move
  def pbBaseDamage(baseDmg,user,target)
    baseDmg *= 2 if @battle.field.terrain==:Electric &&
                    !target.airborne?
    return baseDmg
  end
end

class PokeBattle_Move_190 < PokeBattle_Move
  def pbBaseDamage(baseDmg,user,target)
    baseDmg *= 1.5 if @battle.field.terrain==:Psychic
    return baseDmg
  end
end

class PokeBattle_Move_500 < PokeBattle_Move
  def pbMoveFailed?(user,targets)
    if user.pbOpposingSide.effects[PBEffects::CometShards] || user.pbOpposingSide.effects[PBEffects::StealthRock]
      @battle.pbDisplay(_INTL("But it failed!"))
      return true
    end
    if battle.field.weather==:Windy
      @battle.pbDisplay(_INTL("The Wind prevented the hazards from being set!"))
      return true
    end
    return false
  end

  def pbEffectGeneral(user)
    user.pbOpposingSide.effects[PBEffects::CometShards] = true
    @battle.pbDisplay(_INTL("Comet shards float in the air around {1}!",
       user.pbOpposingTeam(true)))
  end
end

class PokeBattle_Move_501 < PokeBattle_Move_163

  def pbCalcTypeModSingle(moveType,defType,user,target)
    retur Effectiveness::NORMAL_EFFECTIVE_ONE if moveType == :ELECTRIC &&
                                                        defType == :GROUND
    return super
  end
end

class PokeBattle_Move_502 <PokeBattle_WeatherMove
  def initialize(battle,move)
    super
    @weatherType = :Starstorm
  end
end

class PokeBattle_Move_503 < PokeBattle_TwoTurnMove
  def pbIsChargingTurn?(user)
    ret = super
    if user.effects[PBEffects::TwoTurnAttack]==0
      w = @battle.pbWeather
      if w==:Starstorm
        @powerHerb = false
        @chargingTurn = true
        @damagingTurn = true
        return false
      end
    end
    return ret
  end

  def pbChargingTurnMessage(user,targets)
    @battle.pbDisplay(_INTL("{1} took in starlight!",user.pbThis))
  end
end

class PokeBattle_Move_504 < PokeBattle_Move_163

  def pbCalcTypeModSingle(moveType,defType,user,target)
    return Effectiveness::NORMAL_EFFECTIVE_ONE if moveType == :DRAGON &&
                                                        defType == :FAIRY
    return super
  end
end

class PokeBattle_Move_505 < PokeBattle_Move
  def pbCalcTypeModSingle(moveType,defType,user,target)
    return Effectiveness::SUPER_EFFECTIVE_ONE if defType == :ELECTRIC
    return super
  end
end

class PokeBattle_Move_506 < PokeBattle_HealingMove
  def pbHealAmount(user)
    return (user.totalhp*2/3.0).round if user.effects[PBEffects::Charge] > 0
    return (user.totalhp/2.0).round
  end
end

class PokeBattle_Move_507 < PokeBattle_Move
  def pbEffectAgainstTarget(user,target)
    target.effects[PBEffects::LeechSeed] = user.index
    @battle.pbDisplay(_INTL("{1} was sapped!",target.pbThis))
  end
end

class PokeBattle_Move_508 < PokeBattle_HealingMove
  def pbOnStartUse(user,targets)
    case @battle.pbWeather
    when :Overcast, :Eclipse, :Fog, :Starstorm, :DClear, :Borealis
      @healAmount = (user.totalhp*2/3.0).round
    when :None, :StrongWinds, :Windy
      @healAmount = (user.totalhp/2.0).round
    else
      @healAmount = (user.totalhp/4.0).round
    end
  end

  def pbHealAmount(user)
    return @healAmount
  end
end

class PokeBattle_Move_0D8 < PokeBattle_HealingMove
  def pbOnStartUse(user,targets)
    case @battle.pbWeather
    when :Sun, :HarshSun, :Rainbow, :Borealis
      @healAmount = (user.totalhp*2/3.0).round
    when :None, :StrongWinds, :Windy, :HeatLight
      @healAmount = (user.totalhp/2.0).round
    else
      @healAmount = (user.totalhp/4.0).round
    end
  end

  def pbHealAmount(user)
    return @healAmount
  end
end

class PokeBattle_Move_509 <PokeBattle_WeatherMove
  def initialize(battle,move)
    super
    @weatherType = :TimeWarp
  end
end

class PokeBattle_Move_510 <PokeBattle_WeatherMove
  def initialize(battle,move)
    super
    @weatherType = :Reverb
  end
end

class PokeBattle_Move_511 < PokeBattle_StatUpMove
  def initialize(battle,move)
    super
    @statUp = [:ATTACK,3]
  end
end

class PokeBattle_Battle
  def pbRecallAndReplace(idxBattler,idxParty,randomReplacement=false,batonPass=false)
    @scene.pbRecall(idxBattler) if !@battlers[idxBattler].fainted?
    @battlers[idxBattler].pbAbilitiesOnSwitchOut   # Inc. primordial weather check
    if (@battlers[idxBattler].ability == :BAROMETRIC && @battlers[idxBattler].isSpecies?(:ALTEMPER)) || (@battlers[idxBattler].ability == :FORECAST && @battlers[idxBattler].isSpecies?(:CASTFORM))
      if @battlers[idxBattler].form >= 21
        if @battlers[idxBattler].form >= 42
          @battlers[idxBattler].form = 42
        else
          @battlers[idxBattler].form = 21
        end
      else
        @battlers[idxBattler].form = 0
      end
    end
    @scene.pbShowPartyLineup(idxBattler&1) if pbSideSize(idxBattler)==1
    pbMessagesOnReplace(idxBattler,idxParty) if !randomReplacement
    pbReplace(idxBattler,idxParty,batonPass)
  end

  alias pbReplace_ebdx pbReplace unless self.method_defined?(:pbReplace_ebdx)
  def pbReplace(index, *args)
    # displays trainer dialogue if applicable
    opt = playerBattler?(@battlers[index]) ? ["last", "beforeLast"] : ["lastOpp", "beforeLastOpp"]
    @scene.pbTrainerBattleSpeech(*opt)
    if !@replaced
      if !@battlers[index].isSpecies?(:ALTEMPER) && !@battlers[index].isSpecies?(:CASTFORM) && !@battlers[index].isSpecies?(:CHERRIM)
        @battlers[index].form = @battlers[index].form
      else
        if @battlers[index].form <= 20
          @battlers[index].form = 0
        elsif @battlers[index].form >= 21 && @battlers[index].form <= 41
          @battlers[index].form = 21
        elsif @battlers[index].form >= 42
          @battlers[index].form = 42
        end
      end
      if !@battlers[index].fainted?
        @scene.pbRecall(index)
      end
    end
    pbReplace_ebdx(index, *args)
    @replaced = false
    opt = playerBattler?(@battlers[index]) ? "afterLast" : "afterLastOpp"
    @scene.pbTrainerBattleSpeech(opt)
  end
  def pbStartWeather(user,newWeather,fixedDuration=false,showAnim=true)
    return if @field.weather==newWeather
    @field.weather = newWeather
    duration = (fixedDuration) ? 5 : -1
    if duration>0 && user && user.itemActive?
      duration = BattleHandlers.triggerWeatherExtenderItem(user.item,
         @field.weather,duration,user,self)
    end
    @field.weatherDuration = duration
    weather_data = GameData::BattleWeather.try_get(@field.weather)
    pbCommonAnimation(weather_data.animation) if showAnim && weather_data
    pbHideAbilitySplash(user) if user
    case @field.weather
    when :Sun         then pbDisplay(_INTL("The sunlight turned harsh!"))
    when :Rain        then pbDisplay(_INTL("It started to rain!"))
    when :Sandstorm   then pbDisplay(_INTL("A sandstorm brewed!"))
    when :Hail        then pbDisplay(_INTL("It started to hail!"))
    when :HarshSun    then pbDisplay(_INTL("The sunlight turned extremely harsh!"))
    when :HeavyRain   then pbDisplay(_INTL("A heavy rain began to fall!"))
    when :StrongWinds then pbDisplay(_INTL("Mysterious strong winds are protecting Flying-type Pokémon!"))
    when :ShadowSky   then pbDisplay(_INTL("A shadow sky appeared!"))
    when :Starstorm   then pbDisplay(_INTL("Stars fill the sky."))
    when :Thunder     then pbDisplay(_INTL("Lightning flashes in th sky."))
    when :Storm       then pbDisplay(_INTL("A thunderstorm rages. The ground became electrified!"))
    when :Humid       then pbDisplay(_INTL("The air is humid."))
    when :Overcast    then pbDisplay(_INTL("The sky is overcast."))
    when :Eclipse     then pbDisplay(_INTL("The sky is dark."))
    when :Fog         then pbDisplay(_INTL("The fog is deep."))
    when :AcidRain    then pbDisplay(_INTL("Acid rain is falling."))
    when :VolcanicAsh then pbDisplay(_INTL("Volcanic Ash sprinkles down."))
    when :Rainbow     then pbDisplay(_INTL("A rainbow crosses the sky."))
    when :Borealis    then pbDisplay(_INTL("The sky is ablaze with color."))
    when :TimeWarp    then pbDisplay(_INTL("Time has stopped."))
    when :Reverb      then pbDisplay(_INTL("A dull echo hums."))
    when :DClear      then pbDisplay(_INTL("The sky is distorted."))
    when :DRain       then pbDisplay(_INTL("Rain is falling upward."))
    when :DWind       then pbDisplay(_INTL("The wind is haunting."))
    when :DAshfall    then pbDisplay(_INTL("Ash floats in midair."))
    when :Sleet       then pbDisplay(_INTL("Sleet began to fall."))
    when :Windy       then pbDisplay(_INTL("There is a slight breeze."))
    when :HeatLight   then pbDisplay(_INTL("Static fills the air."))
    when :DustDevil   then pbDisplay(_INTL("A dust devil approaches."))
    end
    # Check for end of primordial weather, and weather-triggered form changes
    eachBattler { |b| b.pbCheckFormOnWeatherChange }
    pbEndPrimordialWeather
  end

  def pbEORTerrain
    # Count down terrain duration
    @field.terrainDuration -= 1 if @field.terrainDuration>0
    # Terrain wears off
    if @field.terrain != :None && @field.terrainDuration == 0
      case @field.terrain
      when :Electric
        pbDisplay(_INTL("The electric current disappeared from the battlefield!"))
      when :Grassy
        pbDisplay(_INTL("The grass disappeared from the battlefield!"))
      when :Misty
        pbDisplay(_INTL("The mist disappeared from the battlefield!"))
      when :Psychic
        pbDisplay(_INTL("The weirdness disappeared from the battlefield!"))
      when :Poison
        pbDisplay(_INTL("The toxic waste disappeared from the battlefield!"))
      end
      @field.terrain = :None
      # Start up the default terrain
      pbStartTerrain(nil, @field.defaultTerrain, false) if @field.defaultTerrain != :None
      return if @field.terrain == :None
    end
    # Terrain continues
    terrain_data = GameData::BattleTerrain.try_get(@field.terrain)
    pbCommonAnimation(terrain_data.animation) if terrain_data
    case @field.terrain
    when :Electric then pbDisplay(_INTL("An electric current is running across the battlefield."))
    when :Grassy   then pbDisplay(_INTL("Grass is covering the battlefield."))
    when :Misty    then pbDisplay(_INTL("Mist is swirling about the battlefield."))
    when :Psychic  then pbDisplay(_INTL("The battlefield is weird."))
    when :Poison  then pbDisplay(_INTL("Toxic waste covers the battlefield."))
    end
  end

  def pbEndOfRoundPhase
    PBDebug.log("")
    PBDebug.log("[End of round]")
    @endOfRound = true
    @scene.pbBeginEndOfRoundPhase
    pbCalculatePriority           # recalculate speeds
    priority = pbPriority(true)   # in order of fastest -> slowest speeds only
    # Weather
    pbEORWeather(priority)
    # Future Sight/Doom Desire
    @positions.each_with_index do |pos,idxPos|
      next if !pos || pos.effects[PBEffects::FutureSightCounter]==0
      pos.effects[PBEffects::FutureSightCounter] -= 1
      next if pos.effects[PBEffects::FutureSightCounter]>0
      next if !@battlers[idxPos] || @battlers[idxPos].fainted?   # No target
      moveUser = nil
      eachBattler do |b|
        next if b.opposes?(pos.effects[PBEffects::FutureSightUserIndex])
        next if b.pokemonIndex!=pos.effects[PBEffects::FutureSightUserPartyIndex]
        moveUser = b
        break
      end
      next if moveUser && moveUser.index==idxPos   # Target is the user
      if !moveUser   # User isn't in battle, get it from the party
        party = pbParty(pos.effects[PBEffects::FutureSightUserIndex])
        pkmn = party[pos.effects[PBEffects::FutureSightUserPartyIndex]]
        if pkmn && pkmn.able?
          moveUser = PokeBattle_Battler.new(self,pos.effects[PBEffects::FutureSightUserIndex])
          moveUser.pbInitDummyPokemon(pkmn,pos.effects[PBEffects::FutureSightUserPartyIndex])
        end
      end
      next if !moveUser   # User is fainted
      move = pos.effects[PBEffects::FutureSightMove]
      pbDisplay(_INTL("{1} took the {2} attack!",@battlers[idxPos].pbThis,
         GameData::Move.get(move).name))
      # NOTE: Future Sight failing against the target here doesn't count towards
      #       Stomping Tantrum.
      userLastMoveFailed = moveUser.lastMoveFailed
      @futureSight = true
      moveUser.pbUseMoveSimple(move,idxPos)
      @futureSight = false
      moveUser.lastMoveFailed = userLastMoveFailed
      @battlers[idxPos].pbFaint if @battlers[idxPos].fainted?
      pos.effects[PBEffects::FutureSightCounter]        = 0
      pos.effects[PBEffects::FutureSightMove]           = nil
      pos.effects[PBEffects::FutureSightUserIndex]      = -1
      pos.effects[PBEffects::FutureSightUserPartyIndex] = -1
    end
    # Wish
    @positions.each_with_index do |pos,idxPos|
      next if !pos || pos.effects[PBEffects::Wish]==0
      pos.effects[PBEffects::Wish] -= 1
      next if pos.effects[PBEffects::Wish]>0
      next if !@battlers[idxPos] || !@battlers[idxPos].canHeal?
      wishMaker = pbThisEx(idxPos,pos.effects[PBEffects::WishMaker])
      @battlers[idxPos].pbRecoverHP(pos.effects[PBEffects::WishAmount])
      pbDisplay(_INTL("{1}'s wish came true!",wishMaker))
    end
    # Sea of Fire damage (Fire Pledge + Grass Pledge combination)
    curWeather = pbWeather
    for side in 0...2
      next if sides[side].effects[PBEffects::SeaOfFire]==0
      next if [:Rain, :HeavyRain].include?(curWeather)
      @battle.pbCommonAnimation("SeaOfFire") if side==0
      @battle.pbCommonAnimation("SeaOfFireOpp") if side==1
      priority.each do |b|
        next if b.opposes?(side)
        next if !b.takesIndirectDamage? || b.pbHasType?(:FIRE)
        oldHP = b.hp
        @scene.pbDamageAnimation(b)
        b.pbReduceHP(b.totalhp/8,false)
        pbDisplay(_INTL("{1} is hurt by the sea of fire!",b.pbThis))
        b.pbItemHPHealCheck
        b.pbAbilitiesOnDamageTaken(oldHP)
        b.pbFaint if b.fainted?
      end
    end
    # Status-curing effects/abilities and HP-healing items
    priority.each do |b|
      next if b.fainted?
      # Grassy Terrain (healing)
      if @field.terrain == :Grassy && b.affectedByTerrain? && b.canHeal?
        PBDebug.log("[Lingering effect] Grassy Terrain heals #{b.pbThis(true)}")
        b.pbRecoverHP(b.totalhp/16)
        pbDisplay(_INTL("{1}'s HP was restored.",b.pbThis))
      elsif @field.terrain == :Poison && b.affectedByTerrain? && b.pbCanPoison?(b,false,nil)
          PBDebug.log("[Lingering effect] Poison Terrain poisons #{b.pbThis(true)}")
          b.pbInflictStatus(:POISON)
          pbDisplay(_INTL("{1}'s HP was poisoned by the toxic waste!",b.pbThis))
      end
      # Healer, Hydration, Shed Skin
      BattleHandlers.triggerEORHealingAbility(b.ability,b,self) if b.abilityActive?
      # Black Sludge, Leftovers
      BattleHandlers.triggerEORHealingItem(b.item,b,self) if b.itemActive?
    end
    # Aqua Ring
    priority.each do |b|
      next if !b.effects[PBEffects::AquaRing]
      next if !b.canHeal?
      hpGain = b.totalhp/16
      hpGain = (hpGain*1.3).floor if b.hasActiveItem?(:BIGROOT)
      b.pbRecoverHP(hpGain)
      pbDisplay(_INTL("Aqua Ring restored {1}'s HP!",b.pbThis(true)))
    end
    # Ingrain
    priority.each do |b|
      next if !b.effects[PBEffects::Ingrain]
      next if !b.canHeal?
      hpGain = b.totalhp/16
      hpGain = (hpGain*1.3).floor if b.hasActiveItem?(:BIGROOT)
      b.pbRecoverHP(hpGain)
      pbDisplay(_INTL("{1} absorbed nutrients with its roots!",b.pbThis))
    end
    # Leech Seed
    priority.each do |b|
      next if b.effects[PBEffects::LeechSeed]<0
      next if !b.takesIndirectDamage?
      recipient = @battlers[b.effects[PBEffects::LeechSeed]]
      next if !recipient || recipient.fainted?
      oldHP = b.hp
      oldHPRecipient = recipient.hp
      pbCommonAnimation("LeechSeed",recipient,b)
      hpLoss = b.pbReduceHP(b.totalhp/8)
      recipient.pbRecoverHPFromDrain(hpLoss,b,
         _INTL("{1}'s health is sapped by Leech Seed!",b.pbThis))
      recipient.pbAbilitiesOnDamageTaken(oldHPRecipient) if recipient.hp<oldHPRecipient
      b.pbItemHPHealCheck
      b.pbAbilitiesOnDamageTaken(oldHP)
      b.pbFaint if b.fainted?
      recipient.pbFaint if recipient.fainted?
    end
    # Damage from Hyper Mode (Shadow Pokémon)
    priority.each do |b|
      next if !b.inHyperMode? || @choices[b.index][0]!=:UseMove
      hpLoss = b.totalhp/24
      @scene.pbDamageAnimation(b)
      b.pbReduceHP(hpLoss,false)
      pbDisplay(_INTL("The Hyper Mode attack hurts {1}!",b.pbThis(true)))
      b.pbFaint if b.fainted?
    end
    # Damage from poisoning
    priority.each do |b|
      next if b.fainted?
      next if b.status != :POISON
      if b.statusCount>0
        b.effects[PBEffects::Toxic] += 1
        b.effects[PBEffects::Toxic] = 15 if b.effects[PBEffects::Toxic]>15
      end
      if b.hasActiveAbility?(:POISONHEAL)
        if b.canHeal?
          anim_name = GameData::Status.get(:POISON).animation
          pbCommonAnimation(anim_name, b) if anim_name
          pbShowAbilitySplash(b)
          b.pbRecoverHP(b.totalhp/8)
          if PokeBattle_SceneConstants::USE_ABILITY_SPLASH
            pbDisplay(_INTL("{1}'s HP was restored.",b.pbThis))
          else
            pbDisplay(_INTL("{1}'s {2} restored its HP.",b.pbThis,b.abilityName))
          end
          pbHideAbilitySplash(b)
        end
      elsif b.takesIndirectDamage?
        oldHP = b.hp
        dmg = (b.statusCount==0) ? b.totalhp/8 : b.totalhp*b.effects[PBEffects::Toxic]/16
        b.pbContinueStatus { b.pbReduceHP(dmg,false) }
        b.pbItemHPHealCheck
        b.pbAbilitiesOnDamageTaken(oldHP)
        b.pbFaint if b.fainted?
      end
    end
    # Damage from burn
    priority.each do |b|
      next if b.status != :BURN || !b.takesIndirectDamage?
      oldHP = b.hp
      dmg = (Settings::MECHANICS_GENERATION >= 7) ? b.totalhp/16 : b.totalhp/8
      dmg = (dmg/2.0).round if b.hasActiveAbility?(:HEATPROOF)
      b.pbContinueStatus { b.pbReduceHP(dmg,false) }
      b.pbItemHPHealCheck
      b.pbAbilitiesOnDamageTaken(oldHP)
      b.pbFaint if b.fainted?
    end
    # Damage from sleep (Nightmare)
    priority.each do |b|
      b.effects[PBEffects::Nightmare] = false if !b.asleep?
      next if !b.effects[PBEffects::Nightmare] || !b.takesIndirectDamage?
      oldHP = b.hp
      b.pbReduceHP(b.totalhp/4)
      pbDisplay(_INTL("{1} is locked in a nightmare!",b.pbThis))
      b.pbItemHPHealCheck
      b.pbAbilitiesOnDamageTaken(oldHP)
      b.pbFaint if b.fainted?
    end
    # Curse
    priority.each do |b|
      next if !b.effects[PBEffects::Curse] || !b.takesIndirectDamage?
      oldHP = b.hp
      b.pbReduceHP(b.totalhp/4)
      pbDisplay(_INTL("{1} is afflicted by the curse!",b.pbThis))
      b.pbItemHPHealCheck
      b.pbAbilitiesOnDamageTaken(oldHP)
      b.pbFaint if b.fainted?
    end
    # Trapping attacks (Bind/Clamp/Fire Spin/Magma Storm/Sand Tomb/Whirlpool/Wrap)
    priority.each do |b|
      next if b.fainted? || b.effects[PBEffects::Trapping]==0
      b.effects[PBEffects::Trapping] -= 1
      moveName = GameData::Move.get(b.effects[PBEffects::TrappingMove]).name
      if b.effects[PBEffects::Trapping]==0
        pbDisplay(_INTL("{1} was freed from {2}!",b.pbThis,moveName))
      else
        case b.effects[PBEffects::TrappingMove]
        when :BIND        then pbCommonAnimation("Bind", b)
        when :CLAMP       then pbCommonAnimation("Clamp", b)
        when :FIRESPIN    then pbCommonAnimation("FireSpin", b)
        when :MAGMASTORM  then pbCommonAnimation("MagmaStorm", b)
        when :SANDTOMB    then pbCommonAnimation("SandTomb", b)
        when :WRAP        then pbCommonAnimation("Wrap", b)
        when :INFESTATION then pbCommonAnimation("Infestation", b)
        else                   pbCommonAnimation("Wrap", b)
        end
        if b.takesIndirectDamage?
          hpLoss = (Settings::MECHANICS_GENERATION >= 6) ? b.totalhp/8 : b.totalhp/16
          if @battlers[b.effects[PBEffects::TrappingUser]].hasActiveItem?(:BINDINGBAND)
            hpLoss = (Settings::MECHANICS_GENERATION >= 6) ? b.totalhp/6 : b.totalhp/8
          end
          @scene.pbDamageAnimation(b)
          b.pbReduceHP(hpLoss,false)
          pbDisplay(_INTL("{1} is hurt by {2}!",b.pbThis,moveName))
          b.pbItemHPHealCheck
          # NOTE: No need to call pbAbilitiesOnDamageTaken as b can't switch out.
          b.pbFaint if b.fainted?
        end
      end
    end
    # Taunt
    pbEORCountDownBattlerEffect(priority,PBEffects::Taunt) { |battler|
      pbDisplay(_INTL("{1}'s taunt wore off!",battler.pbThis))
    }
    # Encore
    priority.each do |b|
      next if b.fainted? || b.effects[PBEffects::Encore]==0
      idxEncoreMove = b.pbEncoredMoveIndex
      if idxEncoreMove>=0
        b.effects[PBEffects::Encore] -= 1
        if b.effects[PBEffects::Encore]==0 || b.moves[idxEncoreMove].pp==0
          b.effects[PBEffects::Encore] = 0
          pbDisplay(_INTL("{1}'s encore ended!",b.pbThis))
        end
      else
        PBDebug.log("[End of effect] #{b.pbThis}'s encore ended (encored move no longer known)")
        b.effects[PBEffects::Encore]     = 0
        b.effects[PBEffects::EncoreMove] = nil
      end
    end
    # Disable/Cursed Body
    pbEORCountDownBattlerEffect(priority,PBEffects::Disable) { |battler|
      battler.effects[PBEffects::DisableMove] = nil
      pbDisplay(_INTL("{1} is no longer disabled!",battler.pbThis))
    }
    # Magnet Rise
    pbEORCountDownBattlerEffect(priority,PBEffects::MagnetRise) { |battler|
      pbDisplay(_INTL("{1}'s electromagnetism wore off!",battler.pbThis))
    }
    # Telekinesis
    pbEORCountDownBattlerEffect(priority,PBEffects::Telekinesis) { |battler|
      pbDisplay(_INTL("{1} was freed from the telekinesis!",battler.pbThis))
    }
    # Heal Block
    pbEORCountDownBattlerEffect(priority,PBEffects::HealBlock) { |battler|
      pbDisplay(_INTL("{1}'s Heal Block wore off!",battler.pbThis))
    }
    # Embargo
    pbEORCountDownBattlerEffect(priority,PBEffects::Embargo) { |battler|
      pbDisplay(_INTL("{1} can use items again!",battler.pbThis))
      battler.pbItemTerrainStatBoostCheck
    }
    # Yawn
    pbEORCountDownBattlerEffect(priority,PBEffects::Yawn) { |battler|
      if battler.pbCanSleepYawn?
        PBDebug.log("[Lingering effect] #{battler.pbThis} fell asleep because of Yawn")
        battler.pbSleep
      end
    }
    # Perish Song
    perishSongUsers = []
    priority.each do |b|
      next if b.fainted? || b.effects[PBEffects::PerishSong]==0
      b.effects[PBEffects::PerishSong] -= 1
      pbDisplay(_INTL("{1}'s perish count fell to {2}!",b.pbThis,b.effects[PBEffects::PerishSong]))
      if b.effects[PBEffects::PerishSong]==0
        perishSongUsers.push(b.effects[PBEffects::PerishSongUser])
        b.pbReduceHP(b.hp)
      end
      b.pbItemHPHealCheck
      b.pbFaint if b.fainted?
    end
    if perishSongUsers.length>0
      # If all remaining Pokemon fainted by a Perish Song triggered by a single side
      if (perishSongUsers.find_all { |idxBattler| opposes?(idxBattler) }.length==perishSongUsers.length) ||
         (perishSongUsers.find_all { |idxBattler| !opposes?(idxBattler) }.length==perishSongUsers.length)
        pbJudgeCheckpoint(@battlers[perishSongUsers[0]])
      end
    end
    # Check for end of battle
    if @decision>0
      pbGainExp
      return
    end
    for side in 0...2
      # Reflect
      pbEORCountDownSideEffect(side,PBEffects::Reflect,
         _INTL("{1}'s Reflect wore off!",@battlers[side].pbTeam))
      # Light Screen
      pbEORCountDownSideEffect(side,PBEffects::LightScreen,
         _INTL("{1}'s Light Screen wore off!",@battlers[side].pbTeam))
      # Safeguard
      pbEORCountDownSideEffect(side,PBEffects::Safeguard,
         _INTL("{1} is no longer protected by Safeguard!",@battlers[side].pbTeam))
      # Mist
      pbEORCountDownSideEffect(side,PBEffects::Mist,
         _INTL("{1} is no longer protected by mist!",@battlers[side].pbTeam))
      # Tailwind
      pbEORCountDownSideEffect(side,PBEffects::Tailwind,
         _INTL("{1}'s Tailwind petered out!",@battlers[side].pbTeam))
      # Lucky Chant
      pbEORCountDownSideEffect(side,PBEffects::LuckyChant,
         _INTL("{1}'s Lucky Chant wore off!",@battlers[side].pbTeam))
      # Pledge Rainbow
      pbEORCountDownSideEffect(side,PBEffects::Rainbow,
         _INTL("The rainbow on {1}'s side disappeared!",@battlers[side].pbTeam(true)))
      # Pledge Sea of Fire
      pbEORCountDownSideEffect(side,PBEffects::SeaOfFire,
         _INTL("The sea of fire around {1} disappeared!",@battlers[side].pbTeam(true)))
      # Pledge Swamp
      pbEORCountDownSideEffect(side,PBEffects::Swamp,
         _INTL("The swamp around {1} disappeared!",@battlers[side].pbTeam(true)))
      # Aurora Veil
      pbEORCountDownSideEffect(side,PBEffects::AuroraVeil,
         _INTL("{1}'s Aurora Veil wore off!",@battlers[side].pbTeam(true)))
    end
    # Trick Room
    pbEORCountDownFieldEffect(PBEffects::TrickRoom,
       _INTL("The twisted dimensions returned to normal!"))
    # Gravity
    pbEORCountDownFieldEffect(PBEffects::Gravity,
       _INTL("Gravity returned to normal!"))
    # Water Sport
    pbEORCountDownFieldEffect(PBEffects::WaterSportField,
       _INTL("The effects of Water Sport have faded."))
    # Mud Sport
    pbEORCountDownFieldEffect(PBEffects::MudSportField,
       _INTL("The effects of Mud Sport have faded."))
    # Wonder Room
    pbEORCountDownFieldEffect(PBEffects::WonderRoom,
       _INTL("Wonder Room wore off, and Defense and Sp. Def stats returned to normal!"))
    # Magic Room
    pbEORCountDownFieldEffect(PBEffects::MagicRoom,
       _INTL("Magic Room wore off, and held items' effects returned to normal!"))
    # End of terrains
    pbEORTerrain
    priority.each do |b|
      next if b.fainted?
      # Hyper Mode (Shadow Pokémon)
      if b.inHyperMode?
        if pbRandom(100)<10
          b.pokemon.hyper_mode = false
          b.pokemon.adjustHeart(-50)
          pbDisplay(_INTL("{1} came to its senses!",b.pbThis))
        else
          pbDisplay(_INTL("{1} is in Hyper Mode!",b.pbThis))
        end
      end
      # Uproar
      if b.effects[PBEffects::Uproar]>0
        b.effects[PBEffects::Uproar] -= 1
        if b.effects[PBEffects::Uproar]==0
          pbDisplay(_INTL("{1} calmed down.",b.pbThis))
        else
          pbDisplay(_INTL("{1} is making an uproar!",b.pbThis))
        end
      end
      # Slow Start's end message
      if b.effects[PBEffects::SlowStart]>0
        b.effects[PBEffects::SlowStart] -= 1
        if b.effects[PBEffects::SlowStart]==0
          pbDisplay(_INTL("{1} finally got its act together!",b.pbThis))
        end
      end
      # Bad Dreams, Moody, Speed Boost
      BattleHandlers.triggerEOREffectAbility(b.ability,b,self) if b.abilityActive?
      # Flame Orb, Sticky Barb, Toxic Orb
      BattleHandlers.triggerEOREffectItem(b.item,b,self) if b.itemActive?
      # Harvest, Pickup
      BattleHandlers.triggerEORGainItemAbility(b.ability,b,self) if b.abilityActive?
    end
    pbGainExp
    return if @decision>0
    # Form checks
    priority.each { |b| b.pbCheckForm(true) }
    # Switch Pokémon in if possible
    pbEORSwitch
    return if @decision>0
    # In battles with at least one side of size 3+, move battlers around if none
    # are near to any foes
    pbEORShiftDistantBattlers
    # Try to make Trace work, check for end of primordial weather
    priority.each { |b| b.pbContinualAbilityChecks }
    # Reset/count down battler-specific effects (no messages)
    eachBattler do |b|
      b.effects[PBEffects::BanefulBunker]    = false
      b.effects[PBEffects::Charge]           -= 1 if b.effects[PBEffects::Charge]>0
      b.effects[PBEffects::Counter]          = -1
      b.effects[PBEffects::CounterTarget]    = -1
      b.effects[PBEffects::Electrify]        = false
      b.effects[PBEffects::Endure]           = false
      b.effects[PBEffects::FirstPledge]      = 0
      b.effects[PBEffects::Flinch]           = false
      b.effects[PBEffects::FocusPunch]       = false
      b.effects[PBEffects::FollowMe]         = 0
      b.effects[PBEffects::HelpingHand]      = false
      b.effects[PBEffects::HyperBeam]        -= 1 if b.effects[PBEffects::HyperBeam]>0
      b.effects[PBEffects::KingsShield]      = false
      b.effects[PBEffects::LaserFocus]       -= 1 if b.effects[PBEffects::LaserFocus]>0
      if b.effects[PBEffects::LockOn]>0   # Also Mind Reader
        b.effects[PBEffects::LockOn]         -= 1
        b.effects[PBEffects::LockOnPos]      = -1 if b.effects[PBEffects::LockOn]==0
      end
      b.effects[PBEffects::MagicBounce]      = false
      b.effects[PBEffects::MagicCoat]        = false
      b.effects[PBEffects::MirrorCoat]       = -1
      b.effects[PBEffects::MirrorCoatTarget] = -1
      b.effects[PBEffects::Powder]           = false
      b.effects[PBEffects::Prankster]        = false
      b.effects[PBEffects::PriorityAbility]  = false
      b.effects[PBEffects::PriorityItem]     = false
      b.effects[PBEffects::Protect]          = false
      b.effects[PBEffects::RagePowder]       = false
      b.effects[PBEffects::Roost]            = false
      b.effects[PBEffects::Snatch]           = 0
      b.effects[PBEffects::SpikyShield]      = false
      b.effects[PBEffects::Spotlight]        = 0
      b.effects[PBEffects::ThroatChop]       -= 1 if b.effects[PBEffects::ThroatChop]>0
      b.lastHPLost                           = 0
      b.lastHPLostFromFoe                    = 0
      b.tookDamage                           = false
      b.tookPhysicalHit                      = false
      b.lastRoundMoveFailed                  = b.lastMoveFailed
      b.lastAttacker.clear
      b.lastFoeAttacker.clear
    end
    # Reset/count down side-specific effects (no messages)
    for side in 0...2
      @sides[side].effects[PBEffects::CraftyShield]         = false
      if !@sides[side].effects[PBEffects::EchoedVoiceUsed]
        @sides[side].effects[PBEffects::EchoedVoiceCounter] = 0
      end
      @sides[side].effects[PBEffects::EchoedVoiceUsed]      = false
      @sides[side].effects[PBEffects::MatBlock]             = false
      @sides[side].effects[PBEffects::QuickGuard]           = false
      @sides[side].effects[PBEffects::Round]                = false
      @sides[side].effects[PBEffects::WideGuard]            = false
    end
    # Reset/count down field-specific effects (no messages)
    @field.effects[PBEffects::IonDeluge]   = false
    @field.effects[PBEffects::FairyLock]   -= 1 if @field.effects[PBEffects::FairyLock]>0
    @field.effects[PBEffects::FusionBolt]  = false
    @field.effects[PBEffects::FusionFlare] = false
    @endOfRound = false
  end

  def pbEndPrimordialWeather
    oldWeather = @field.weather
    # End Primordial Sea, Desolate Land, Delta Stream
    case @field.weather
    when :HarshSun
      if !pbCheckGlobalAbility(:DESOLATELAND) && @field.weather != :HarshSun
        @field.weather = :None
        pbDisplay("The harsh sunlight faded!")
      end
    when :HeavyRain
      if !pbCheckGlobalAbility(:PRIMORDIALSEA) && @field.weather != :HeavyRain
        @field.weather = :None
        pbDisplay("The heavy rain has lifted!")
      end
    when :StrongWinds
      if !pbCheckGlobalAbility(:DELTASTREAM) && @field.weather != :StrongWinds
        @field.weather = :None
        pbDisplay("The mysterious air current has dissipated!")
      end
    end
    if @field.weather!=oldWeather
      # Check for form changes caused by the weather changing
      eachBattler { |b| b.pbCheckFormOnWeatherChange }
      # Start up the default weather
      pbStartWeather(nil,$game_screen.weather_type) if $game_screen.weather_type!= :None
    end
  end

  def pbEORWeather(priority)
    # NOTE: Primordial weather doesn't need to be checked here, because if it
    #       could wear off here, it will have worn off already.
    # Count down weather duration
    curWeather = @field.weather
    priority.each do |b|
      # Weather-related abilities
      if b.ability == :BAROMETRIC
        BattleHandlers.triggerEORWeatherAbility(b.ability,curWeather,b,self)
        b.pbFaint if b.fainted?
      end
    end
    if @field.weather != $game_screen.weather_type
      @field.weatherDuration -= 1 if @field.weatherDuration>0
    else
      @field.weatherDuration = 1
    end
    # Weather wears off
    if @field.weatherDuration==0
      case @field.weather
      when :Sun       then pbDisplay(_INTL("The sunlight faded."))
      when :Rain      then pbDisplay(_INTL("The rain stopped."))
      when :Sandstorm then pbDisplay(_INTL("The sandstorm subsided."))
      when :Hail      then pbDisplay(_INTL("The hail stopped."))
      when :ShadowSky then pbDisplay(_INTL("The shadow sky faded."))
      when :Starstorm then pbDisplay(_INTL("The stars have faded."))
      when :Storm then pbDisplay(_INTL("The storm has calmed."))
      when :Humid then pbDisplay(_INTL("The humidity has lowered."))
      when :Overcast then pbDisplay(_INTL("The clouds have cleared."))
      when :Eclipse then pbDisplay(_INTL("The sky brightened."))
      when :Fog then pbDisplay(_INTL("The fog has lifted."))
      when :AcidRain then pbDisplay(_INTL("The acid rain has stopped."))
      when :VolcanicAsh then pbDisplay(_INTL("The ash dissolved."))
      when :Rainbow then pbDisplay(_INTL("The rainbow disappeared."))
      when :Borealis then pbDisplay(_INTL("The sky has calmed."))
      when :DClear then pbDisplay(_INTL("The sky returned to normal."))
      when :DRain then pbDisplay(_INTL("The rain has stopped."))
      when :DWind then pbDisplay(_INTL("The wind has passed."))
      when :DAshfall then pbDisplay(_INTL("The ash disintegrated."))
      when :Sleet then pbDisplay(_INTL("The sleet lightened."))
      when :Windy then pbDisplay(_INTL("The wind died down."))
      when :HeatLight then pbDisplay(_INTL("The air has calmed."))
      when :TimeWarp then pbDisplay(_INTL("Time began to move again."))
      when :Reverb then pbDisplay(_INTL("Silence fell once more."))
      when :DustDevil then pbDisplay(_INTL("The dust devil dissipated."))
      end
      @field.weather= :None
      # Check for form changes caused by the weather changing
      eachBattler { |b| b.pbCheckFormOnWeatherChange }
      # Start up the default weather
      pbStartWeather(nil,$game_screen.weather_type) if $game_screen.weather_type != :None
      return if @field.weather == :None
    end
    # Weather continues
    weather_data = GameData::BattleWeather.try_get(@field.weather)
    pbCommonAnimation(weather_data.animation) if weather_data
    case @field.weather
#    when :Sun;         pbDisplay(_INTL("The sunlight is strong."))
#    when :Rain;        pbDisplay(_INTL("Rain continues to fall."))
    when :Sandstorm;   pbDisplay(_INTL("The sandstorm is raging."))
    when :Hail;        pbDisplay(_INTL("The hail is crashing down."))
#    when :HarshSun;    pbDisplay(_INTL("The sunlight is extremely harsh."))
#    when :HeavyRain;   pbDisplay(_INTL("It is raining heavily."))
#    when :StrongWinds; pbDisplay(_INTL("The wind is strong."))
    when :ShadowSky;   pbDisplay(_INTL("The shadow sky continues."));
    end
    # Effects due to weather
    curWeather = @field.weather
    priority.each do |b|
      # Weather damage
      # NOTE:
      if b.isSpecies?(:CASTFORM)
        b.pbCheckFormOnWeatherChange
      end
      b.pbFaint if b.fainted?
      if !b.isSpecies?(:ALTEMPER)
        BattleHandlers.triggerEORWeatherAbility(b.ability,curWeather,b,self)
      end
      case curWeather
      when :Sandstorm
        next if !b.takesSandstormDamage? ||  b.isSpecies?(:ALTEMPER)
        pbDisplay(_INTL("{1} is buffeted by the sandstorm!",b.pbThis))
        @scene.pbDamageAnimation(b)
        b.pbReduceHP(b.totalhp/16,false)
        b.pbItemHPHealCheck
        b.pbFaint if b.fainted?
      when :AcidRain
        next if !b.takesAcidRainDamage? ||  b.isSpecies?(:ALTEMPER)
        pbDisplay(_INTL("{1} is scathed by Acid Rain!",b.pbThis))
        @scene.pbDamageAnimation(b)
        b.pbReduceHP(b.totalhp/16,false)
        b.pbItemHPHealCheck
        b.pbFaint if b.fainted?
      when :DWind
        next if !b.takesDWindDamage? ||  b.isSpecies?(:ALTEMPER)
        pbDisplay(_INTL("{1} is whipped by the Distorted Wind!",b.pbThis))
        @scene.pbDamageAnimation(b)
        b.pbReduceHP(b.totalhp/16,false)
        b.pbItemHPHealCheck
        b.pbFaint if b.fainted?
      when :DustDevil
        next if !b.takesDustDevilDamage? ||  b.isSpecies?(:ALTEMPER)
        pbDisplay(_INTL("{1} is buffeted by the Dust Devil!",b.pbThis))
        @scene.pbDamageAnimation(b)
        b.pbReduceHP(b.totalhp/16,false)
        b.pbItemHPHealCheck
        b.pbFaint if b.fainted?
      when :Hail
        next if !b.takesHailDamage? ||  b.isSpecies?(:ALTEMPER)
        pbDisplay(_INTL("{1} is buffeted by the hail!",b.pbThis))
        @scene.pbDamageAnimation(b)
        b.pbReduceHP(b.totalhp/16,false)
        b.pbItemHPHealCheck
        b.pbFaint if b.fainted?
      when :Sleet
        next if !b.takesHailDamage? ||  b.isSpecies?(:ALTEMPER)
        pbDisplay(_INTL("{1} is buffeted by the Sleet!",b.pbThis))
        @scene.pbDamageAnimation(b)
        b.pbReduceHP(b.totalhp/8,false)
        b.pbItemHPHealCheck
        b.pbFaint if b.fainted?
      when :Starstorm
        next if !b.takesStarstormDamage? ||  b.isSpecies?(:ALTEMPER)
        pbDisplay(_INTL("{1} is hurt by the Starstorm!",b.pbThis))
        @scene.pbDamageAnimation(b)
        b.pbReduceHP(b.totalhp/8,false)
        b.pbItemHPHealCheck
        b.pbFaint if b.fainted?
      when :ShadowSky
        next if !b.takesShadowSkyDamage? ||  b.isSpecies?(:ALTEMPER)
        pbDisplay(_INTL("{1} is hurt by the shadow sky!",b.pbThis))
        @scene.pbDamageAnimation(b)
        b.pbReduceHP(b.totalhp/16,false)
        b.pbItemHPHealCheck
        b.pbFaint if b.fainted?
      when :Windy
        next if !b.pbOwnSide.effects[PBEffects::StealthRock] && b.pbOwnSide.effects[PBEffects::Spikes] == 0 && !b.pbOwnSide.effects[PBEffects::CometShards] && !b.pbOwnSide.effects[PBEffects::StickyWeb] && b.pbOwnSide.effects[PBEffects::ToxicSpikes] == 0
        if b.pbOwnSide.effects[PBEffects::StealthRock] || b.pbOpposingSide.effects[PBEffects::StealthRock]
          b.pbOwnSide.effects[PBEffects::StealthRock]      = false
          b.pbOpposingSide.effects[PBEffects::StealthRock] = false
        end
        if b.pbOwnSide.effects[PBEffects::Spikes]>0 || b.pbOpposingSide.effects[PBEffects::Spikes]>0
          b.pbOwnSide.effects[PBEffects::Spikes]      = 0
          target.pbOpposingSide.effects[PBEffects::Spikes] = 0
        end
        if b.pbOwnSide.effects[PBEffects::CometShards] || b.pbOpposingSide.effects[PBEffects::CometShards]
          b.pbOwnSide.effects[PBEffects::CometShards]      = false
          b.pbOpposingSide.effects[PBEffects::CometShards] = false
        end
        if b.pbOwnSide.effects[PBEffects::ToxicSpikes]>0 || b.pbOpposingSide.effects[PBEffects::ToxicSpikes]>0
          b.pbOwnSide.effects[PBEffects::ToxicSpikes]      = 0
          b.pbOpposingSide.effects[PBEffects::ToxicSpikes] = 0
        end
        if b.pbOwnSide.effects[PBEffects::StickyWeb] || b.pbOpposingSide.effects[PBEffects::StickyWeb]
          b.pbOwnSide.effects[PBEffects::StickyWeb]      = false
          b.pbOpposingSide.effects[PBEffects::StickyWeb] = false
        end
      end
    end
  end
end

GameData::Weather.register({
  :id               => :AcidRain,
  :id_number        => 17,
  :category         => :AcidRain,
  :graphics         => [["acidrain_1", "acidrain_2", "acidrain_3", "acidrain_4"]],   # Last is splash
  :particle_delta_x => -300,
  :particle_delta_y => 1200,
  :tone_proc        => proc { |strength|
    next Tone.new(-strength * 3 / 4, -strength * 3 / 4, -strength * 3 / 4, 10)
  }
})
GameData::Weather.register({
  :id               => :VolcanicAsh,
  :id_number        => 27,
  :category         => :VolcanicAsh,
  :graphics         => [["volc_1", "volc_2", "volc_3"]],
  :particle_delta_x => -120,
  :particle_delta_y => 120,
  :tone_proc        => proc { |strength|
    next Tone.new(-strength * 3 / 4, -strength * 3 / 4, -strength * 3 / 4, 20)
  }
})
GameData::Weather.register({
  :id               => :DAshfall,
  :id_number        => 25,
  :category         => :DAshfall,
  :graphics         => [["volc_1", "volc_2", "volc_3"]],
  :particle_delta_x => -2400,
  :particle_delta_y => -480,
  :tone_proc        => proc { |strength|
    next Tone.new(-strength * 6 / 4, -strength * 6 / 4, -strength * 6 / 4, 20)
  }
})
GameData::Weather.register({
  :id               => :Starstorm,
  :id_number        => 9,
  :category         => :Starstorm,
  :graphics         => [["hail_1", "hail_2", "hail_3"]],
  :particle_delta_x => -240,
  :particle_delta_y => 10,
  :tone_proc        => proc { |strength|
    next Tone.new(-strength * 3 / 2, -strength * 3 / 2, -strength * 3 / 2, 20)
  }
})
GameData::Weather.register({
  :id               => :HarshSun,
  :id_number        => 31,
  :category         => :HarshSun,
  :tone_proc        => proc { |strength|
    next Tone.new(172, 64, 32, 0)
  }
})
GameData::Weather.register({
  :id               => :Overcast,
  :id_number        => 8,
  :category         => :Overcast,
  :tone_proc        => proc{ |strength|
    next Tone.new(-strength * 6 / 4, -strength * 6 / 4, -strength * 6 / 4, 20)
  }
})
GameData::Weather.register({
  :id               => :Eclipse,
  :id_number        => 13,
  :category         => :Eclipse,
  :tone_proc        => proc{ |strength|
    next Tone.new(-strength * 11 / 4, -strength * 11 / 4, -strength * 11 / 4, 20)
  }
})
GameData::Weather.register({
  :id               => :Windy,
  :id_number        => 15,   # Must be 1 (preset RMXP weather)
  :category         => :Windy,
  :graphics         => [["windy_1", "windy_2", "windy_3"]],   # Last is splash
  :particle_delta_x => -120,
  :particle_delta_y => 10,
  :tone_proc        => proc { |strength|
    next Tone.new(-strength * 3 / 4, -strength * 3 / 4, -strength * 3 / 4, 20)
  }
})
GameData::Weather.register({
  :id               => :Humid,
  :id_number        => 18,
  :category         => :Humid,
  :graphics         => [["hail_1", "hail_2", "hail_3"]],
  :particle_delta_x => -10,
  :particle_delta_y => 10,
  :tone_proc        => proc { |strength|
    next Tone.new(0,128,45,0)
  }
})
GameData::Weather.register({
  :id               => :Sleet,
  :id_number        => 11,
  :category         => :Sleet,
  :graphics         => [["blizzard_1", "blizzard_2", "blizzard_3", "blizzard_4"], ["blizzard_tile"]],
  :particle_delta_x => -960,
  :particle_delta_y => 240,
  :tile_delta_x     => -1440,
  :tile_delta_y     => 0,
  :tone_proc        => proc { |strength|
    next Tone.new(strength * 3 / 4, strength * 3 / 4, strength * 3 / 4, 0)
  }
})
GameData::Weather.register({
  :id               => :Storm,
  :id_number        => 2,   # Must be 2 (preset RMXP weather)
  :category         => :Storm,
  :graphics         => [["storm_1", "storm_2", "storm_3", "storm_4"]],   # Last is splash
  :particle_delta_x => -4800,
  :particle_delta_y => 4800,
  :tone_proc        => proc { |strength|
    next Tone.new(-strength * 3 / 2, -strength * 3 / 2, -strength * 3 / 2, 20)
  }
})
GameData::Weather.register({
  :id               => :DustDevil,
  :id_number        => 22,
  :category         => :DustDevil,
  :graphics         => [["sandstorm_1", "sandstorm_2", "sandstorm_3", "sandstorm_4"], ["sandstorm_tile"]],
  :particle_delta_x => -150,
  :particle_delta_y => -15,
  :tile_delta_x     => -320,
  :tile_delta_y     => 0,
  :tone_proc        => proc { |strength|
    next Tone.new(strength / 2, 0, -strength / 2, 0)
  }
})
GameData::Weather.register({
  :id               => :StrongWinds,
  :id_number        => 15,   # Must be 1 (preset RMXP weather)
  :category         => :StrongWinds,
  :graphics         => [["windy_1", "windy_2", "windy_3"]],   # Last is splash
  :particle_delta_x => -650,
  :particle_delta_y => 20,
  :tone_proc        => proc { |strength|
    next Tone.new(0,76,36,15)
  }
})
GameData::Weather.register({
  :id               => :Fog,
  :category         => :Fog,
  :id_number        => 12,
  :tile_delta_x     => -32,
  :tile_delta_y     => 0,
  :graphics         => [nil, ["fog_tile"]]
})
GameData::Weather.register({
  :id               => :Rainbow,
  :category         => :Rainbow,
  :id_number        => 21,
  :tile_delta_x     => 0,
  :tile_delta_y     => 0,
  :graphics         => [nil, ["rainbow_tile"]]
})
GameData::Weather.register({
  :id               => :HeatLight,
  :id_number        => 20,   # Must be 2 (preset RMXP weather)
  :category         => :HeatLight,
  :tone_proc        => proc { |strength|
    next Tone.new(255,0,0,100)
  }
})
GameData::Weather.register({
  :id               => :Borealis,
  :id_number        => 28,
  :category         => :Borealis,
  :graphics         => [["hail_1", "hail_2", "hail_3"],["borealis_tile"]],
  :particle_delta_x => -10,
  :particle_delta_y => 10,
  :tone_proc        => proc { |strength|
    next Tone.new(64,0,255,15)
  }
})
GameData::Weather.register({
  :id               => :TimeWarp,
  :id_number        => 29,
  :category         => :TimeWarp,
  :tone_proc        => proc { |strength|
    next Tone.new(20,-74,-60,0)
  }
})
GameData::Weather.register({
  :id               => :Reverb,
  :id_number        => 30,
  :category         => :Reverb,
  :tone_proc        => proc { |strength|
    next Tone.new(20,44,80,0)
  }
})

GameData::BattleWeather.register({
  :id        => :Starstorm,
  :name      => _INTL("Starstorm"),
  :animation => "ShadowSky"
})
GameData::BattleWeather.register({
  :id        => :Overcast,
  :name      => _INTL("Overcast"),
})
GameData::BattleWeather.register({
  :id        => :Sleet,
  :name      => _INTL("Sleet"),
  :animation => "Hail"
})
GameData::BattleWeather.register({
  :id        => :Fog,
  :name      => _INTL("Fog"),
  :animation => "Fog"
})
GameData::BattleWeather.register({
  :id        => :Eclipse,
  :name      => _INTL("Eclipse"),
  :animation => "ShadowSky"
})
GameData::BattleWeather.register({
  :id        => :Windy,
  :name      => _INTL("Windy"),
})
GameData::BattleWeather.register({
  :id        => :Storm,
  :name      => _INTL("Storm"),
  :animation => "HeavyRain"
})
GameData::BattleWeather.register({
  :id        => :AcidRain,
  :name      => _INTL("Acid Rain"),
  :animation => "Rain"
})
GameData::BattleWeather.register({
  :id        => :Humid,
  :name      => _INTL("Humid"),
})
GameData::BattleWeather.register({
  :id        => :HeatLight,
  :name      => _INTL("Heat Lightning"),
})
GameData::BattleWeather.register({
  :id        => :Rainbow,
  :name      => _INTL("Rainbow"),
})
GameData::BattleWeather.register({
  :id        => :DustDevil,
  :name      => _INTL("Dust Devil"),
  :animation => "Sandstorm"
})
GameData::BattleWeather.register({
  :id        => :DAshfall,
  :name      => _INTL("Distorted Ashfall")
})
GameData::BattleWeather.register({
  :id        => :VolcanicAsh,
  :name      => _INTL("Volcanic Ash"),
})
GameData::BattleWeather.register({
  :id        => :Borealis,
  :name      => _INTL("Northern Lights"),
})
GameData::BattleWeather.register({
  :id        => :TimeWarp,
  :name      => _INTL("Temporal Rift"),
})
GameData::BattleWeather.register({
  :id        => :Reverb,
  :name      => _INTL("Echo Chamber"),
})

Settings::TIME_SHADING = false
Settings::SPEECH_WINDOWSKINS = [
#    "speech hgss 1",
#    "speech hgss 2",
#    "speech hgss 3",
#    "speech hgss 4",
#    "speech hgss 5",
#    "speech hgss 6",
#    "speech hgss 7",
#    "speech hgss 8",
#    "speech hgss 9",
#    "speech hgss 10",
#    "speech hgss 11",
#    "speech hgss 12",
#    "speech hgss 13",
#    "speech hgss 14",
#    "speech hgss 15",
#    "speech hgss 16",
#    "speech hgss 17",
#    "speech hgss 18",
#    "speech hgss 19",
#    "speech hgss 20",
#    "speech pl 18",
    "frlgtextskin"
  ]
Settings::MENU_WINDOWSKINS = [
#    "choice 1",
#    "choice 2",
#    "choice 3",
#    "choice 4",
#    "choice 5",
#    "choice 6",
#    "choice 7",
#    "choice 8",
#    "choice 9",
#    "choice 10",
#    "choice 11",
#    "choice 12",
#    "choice 13",
#    "choice 14",
#    "choice 15",
#    "choice 16",
#    "choice 17",
#    "choice 18",
#    "choice 19",
#    "choice 20",
#    "choice 21",
#    "choice 22",
#    "choice 23",
#    "choice 24",
#    "choice 25",
#    "choice 26",
#    "choice 27",
#    "choice 28",
    "frlgtextskin"
  ]
Settings::FIELD_MOVES_COUNT_BADGES = false
Settings::GAME_VERSION = "1.2.18"

module Settings
  def self.storage_creator_name
    return _INTL("Lyptus")
  end

  def self.pokedex_names
    return [
      [_INTL("Ufara Pokédex"), 0],
      _INTL("National Pokédex")
    ]
  end
end

module Readouts
  Count = 29
  Rain = 52
  Hail = 53
  Sun = 54
  Sand = 55
  HeavyRain = 56
  HarshSun = 57
  StrongWinds = 58
  Starstorm = 59
  Overcast = 60
  Sleet = 75
  Fog = 72
  Eclipse = 61
  Windy = 63
  AcidRain = 62
  Humid = 65
  HeatLightning = 64
  Rainbow = 66
  DustDevil = 67
  DClear = 68
  DRain = 70
  DWind = 69
  DAshfall = 71
  VolcanicAsh = 73
  NorthernLights = 74
  TemporalRift = 111
  EchoChamber = 112
  Readout = 400
end

def hasReadout?
  return $game_switches[Readouts::Readout]
end

def pbReadout(text)
  if hasReadout? == false
    pbMessage(_INTL("You do not have the Weather Reader to install this Readout into!"))
  else
    case text
    when "Rain"
      readoutName = text
      $game_variables[Readouts::Rain] = 1
    when "Hail"
      readoutName = text
      $game_variables[Readouts::Hail] = 1
    when "Sun"
      readoutName = text
      $game_variables[Readouts::Sun] = 1
    when "Sandstorm"
      readoutName = text
      $game_variables[Readouts::Sand] = 1
    when "Sleet"
      readoutName = text
      $game_variables[Readouts::Sleet] = 1
    when "Starstorm"
      readoutName = text
      $game_variables[Readouts::Starstorm] = 1
    when "Overcast"
      readoutName = text
      $game_variables[Readouts::Overcast] = 1
    when "Humid"
      readoutName = text
      $game_variables[Readouts::Humid] = 1
    when "Fog"
      readoutName = text
      $game_variables[Readouts::Fog] = 1
    when "Windy"
      readoutName = text
      $game_variables[Readouts::Windy] = 1
    when "Eclipse"
      readoutName = text
      $game_variables[Readouts::Eclipse] = 1
    when "Rainbow"
      readoutName = text
      $game_variables[Readouts::Rainbow] = 1
    when "HeavyRain"
      readoutName = "Heavy Rain"
      $game_variables[Readouts::HeavyRain] = 1
    when "HarshSun"
      readoutName = "Harsh Sun"
      $game_variables[Readouts::HarshSun] = 1
    when "StrongWinds"
      readoutName = "Strong Winds"
      $game_variables[Readouts::StrongWinds] = 1
    when "AcidRain"
      readoutName = "Acid Rain"
      $game_variables[Readouts::AcidRain] = 1
    when "HeatLightning"
      readoutName = "Heat Lightning"
      $game_variables[Readouts::HeatLightning] = 1
    when "DustDevil"
      readoutName = "Dust Devil"
      $game_variables[Readouts::DustDevil] = 1
    when "DAshfall"
      readoutName = "Distorted Ashfall"
      $game_variables[Readouts::DAshfall] = 1
    when "VolcanicAsh"
      readoutName = "Volcanic Ash"
      $game_variables[Readouts::VolcanicAsh] = 1
    when "NorthernLights"
      readoutName = "Northern Lights"
      $game_variables[Readouts::NorthernLights] = 1
    when "TemporalRift"
      readoutName = "Temporal Rift"
      $game_variables[Readouts::TemporalRift] = 1
    when "EchoChamber"
      readoutName = "Echo Chamber"
      $game_variables[Readouts::EchoChamber] = 1
    end
    meName = "Key item get"
    pbMessage(_INTL("\\me[{1}]\\PN found a Readout for \\c[1]{2}\\c[0] Weather!\\wtnp[30]",meName,readoutName))
    pbMessage(_INTL("\\PN installed it into the \\c[1]Weather Reader\\c[0]!"))
    $game_variables[Readouts::Count] += 1
    if $game_variables[Readouts::Count] == 24
      meComplete = "Voltorb flip win"
      pbMessage(_INTL("\\me[{1}]\\PN has found all of the \\c[1]Weather Readouts\\c[0]!"))
      completeQuest(0)
    end
    pbSetSelfSwitch(@event_id,"A",true)
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

class PokemonWeather_Scene
  def pbUpdate
    pbUpdateSpriteHash(@sprites)
  end

  def pbStartScene(commands)
    @commands = commands
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    @sprites["background"] = IconSprite.new(0,0,@viewport)
    @sprites["background"].setBitmap("Graphics/Pictures/Pokegear/bg")
    @sprites["header"] = Window_UnformattedTextPokemon.newWithSize(
       _INTL("Weather Reader"),2,-18,256,64,@viewport)
    @sprites["header"].baseColor   = Color.new(248,248,248)
    @sprites["header"].shadowColor = Color.new(0,0,0)
    @sprites["header"].windowskin  = nil
    @sprites["commands"] = Window_CommandPokemon.newWithSize(@commands,
       14,92,324,224,@viewport)
    @sprites["commands"].baseColor   = Color.new(248,248,248)
    @sprites["commands"].shadowColor = Color.new(0,0,0)
    @sprites["commands"].windowskin = nil
    pbFadeInAndShow(@sprites) { pbUpdate }
  end


  def pbScene
    ret = -1
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if Input.trigger?(Input::B)
        break
      elsif Input.trigger?(Input::C)
        ret = @sprites["commands"].index
        break
      end
    end
    return ret
  end

  def pbSetCommands(newcommands,newindex)
    @sprites["commands"].commands = (!newcommands) ? @commands : newcommands
    @sprites["commands"].index    = newindex
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end

class PokemonWeatherScreen

  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen
    commands = []
    cmdNone    = -1
    cmdRain    = -1
    cmdSnow    = -1
    cmdSun     = -1
    cmdSand    = -1
    cmdHeavyR  = -1
    cmdHarshS  = -1
    cmdDelta   = -1
    cmdStar    = -1
    cmdOver    = -1
    cmdSleet   = -1
    cmdFog     = -1
    cmdEclipse = -1
    cmdWindy   = -1
    cmdAcidR   = -1
    cmdHumid   = -1
    cmdHeatL   = -1
    cmdRainbow = -1
    cmdDust    = -1
    cmdDClear  = -1
    cmdDRain   = -1
    cmdDWind   = -1
    cmdDAsh    = -1
    cmdVolc    = -1
    cmdNLight  = -1
    cmdRift    = -1
    cmdEcho    = -1
    @typebitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/Pokedex/icon_types"))
    @viewport3 = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport3.z = 999999
    @sprites = {}
    commands[cmdNone = commands.length]   = _INTL("Clear")
    commands[cmdRain = commands.length] = _INTL("Rain") if $game_variables[52] >0
    commands[cmdSnow = commands.length]     = _INTL("Hail") if $game_variables[53]>0
    commands[cmdSun = commands.length]  = _INTL("Sun") if $game_variables[54]>0
    commands[cmdSand = commands.length]  = _INTL("Sand") if $game_variables[55] >0
    commands[cmdHeavyR = commands.length]  = _INTL("Heavy Rain") if $game_variables[56] >0
    commands[cmdHarshS = commands.length]  = _INTL("Harsh Sun") if $game_variables[57] >0
    commands[cmdDelta = commands.length] = _INTL("Strong Winds") if $game_variables[58] >0
    commands[cmdStar = commands.length]  = _INTL("Starstorm") if $game_variables[59] >0
    commands[cmdOver = commands.length]  = _INTL("Overcast") if $game_variables[60] >0
    commands[cmdSleet = commands.length]  = _INTL("Sleet") if $game_variables[75] >0
    commands[cmdFog = commands.length]  = _INTL("Fog") if $game_variables[72] >0
    commands[cmdEclipse = commands.length]  = _INTL("Eclipse") if $game_variables[61] >0
    commands[cmdWindy = commands.length]  = _INTL("Windy") if $game_variables[63] >0
    commands[cmdAcidR = commands.length]  = _INTL("Acid Rain") if $game_variables[62] >0
    commands[cmdHumid = commands.length]  = _INTL("Humid") if $game_variables[65] >0
    commands[cmdHeatL = commands.length]  = _INTL("Heat Lightning") if $game_variables[64] >0
    commands[cmdRainbow = commands.length]  = _INTL("Rainbow") if $game_variables[66] >0
    commands[cmdDust = commands.length]  = _INTL("Dust Devil") if $game_variables[67] >0
    commands[cmdDClear = commands.length]  = _INTL("Distortion World - Clear") if $game_variables[68] >0
    commands[cmdDRain = commands.length]  = _INTL("Distortion World - Rain") if $game_variables[70] >0
    commands[cmdDWind = commands.length]  = _INTL("Distortion World - Windy") if $game_variables[69] >0
    commands[cmdDAsh = commands.length]  = _INTL("Distortion World - Ashfall") if $game_variables[71] >0
    commands[cmdVolc = commands.length]  = _INTL("Volcanic Ash") if $game_variables[73] >0
    commands[cmdNLight = commands.length]  = _INTL("Northern Lights") if $game_variables[74] >0
    commands[cmdRift = commands.length]  = _INTL("Temporal Rift") if $game_variables[111] >0
    commands[cmdEcho = commands.length]  = _INTL("Echo Chamber") if $game_variables[112] >0
    commands[commands.length]              = _INTL("Exit")
    @scene.pbStartScene(commands)
    loop do
      cmd = @scene.pbScene
        if cmd<0
        pbPlayCloseMenuSE
          break
        elsif cmdNone>=0 && cmd==cmdNone
          pbPlayDecisionSE
          pbMessage(_INTL("Weather: Clear"))
          pbMessage(_INTL("Weather Ball Type: Normal"))
          pbMessage(_INTL("Additional Effects: None"))
#         @sprites["weather"]=IconSprite.new(240,120,@viewport3)
#         @sprites["weather"].setBitmap("Graphics/Pictures/testfront")
        elsif cmdNone>=0 && cmd==cmdRain
          pbPlayDecisionSE
          if $game_variables[52]>=1
          pbMessage(_INTL("Weather: Rain"))
          pbMessage(_INTL("Weather Ball Type: Water"))
          pbMessage(_INTL("Additional Effects: Water x 1.5, Fire x .5"))
          pbMessage(_INTL("Thunder and Hurricane 100% accurate"))
          else
            pbMessage(_INTL("No Readout Installed for this Weather"))
          end
        elsif cmdNone>=0 && cmd==cmdSnow
          pbPlayDecisionSE
          if $game_variables[53]>=1
          pbMessage(_INTL("Weather: Hail"))
          pbMessage(_INTL("Weather Ball Type: Ice"))
          pbMessage(_INTL("Additional Effects: Non-Ice types take 1/16 damage"))
          pbMessage(_INTL("Blizzard 100% accurate"))
          else
            pbMessage(_INTL("No Readout Installed for this Weather"))
          end
        elsif cmdNone>=0 && cmd==cmdSun
          pbPlayDecisionSE
          if $game_variables[54]>=1
          pbMessage(_INTL("Weather: Sun"))
          pbMessage(_INTL("Weather Ball Type: Fire"))
          pbMessage(_INTL("Additional Effects: Fire x 1.5, Water x .5"))
          pbMessage(_INTL("Solar Beam and Solar Blade require no charge"))
          else
            pbMessage(_INTL("No Readout Installed for this Weather"))
          end
        elsif cmdNone>=0 && cmd==cmdSand
          pbPlayDecisionSE
          if $game_variables[55]>=1
          pbMessage(_INTL("Weather: Sandstorm"))
          pbMessage(_INTL("Weather Ball Type: Rock"))
          pbMessage(_INTL("Additional Effects: Non-Rock Ground or Steel types take 1/16 damage"))
          pbMessage(_INTL("Rock types gain 30% SpDef boost"))
          else
            pbMessage(_INTL("No Readout Installed for this Weather"))
          end
        elsif cmdNone>=0 && cmd==cmdHeavyR
          pbPlayDecisionSE
	  if $game_variables[56]>=1
          pbMessage(_INTL("Weather: Heavy Rain"))
          pbMessage(_INTL("Weather Ball Type: Water"))
          pbMessage(_INTL("Additional Effects: Water x 1.5, Fire ineffective"))
          pbMessage(_INTL("Thunder and Hurricane 100% accurate"))
          else
            pbMessage(_INTL("No Readout Installed for this Weather"))
          end
        elsif cmdNone>=0 && cmd==cmdHarshS
          pbPlayDecisionSE
	  if $game_variables[57]>=1
          pbMessage(_INTL("Weather: Harsh Sun"))
          pbMessage(_INTL("Weather Ball Type: Fire"))
          pbMessage(_INTL("Additional Effects: Fire x 1.5, Water ineffective"))
          pbMessage(_INTL("Solar Beam and Solar blade require no charge"))
          else
            pbMessage(_INTL("No Readout Installed for this Weather"))
          end
        elsif cmdNone>=0 && cmd==cmdDelta
          pbPlayDecisionSE
	  if $game_variables[58]>=1
          pbMessage(_INTL("Weather: Strong Winds"))
          pbMessage(_INTL("Weather Ball Type: Dragon"))
          pbMessage(_INTL("Additional Effects: Dragon's and Flying's weaknesses are removed"))
          else
            pbMessage(_INTL("No Readout Installed for this Weather"))
          end
        elsif cmdNone>=0 && cmd==cmdStar
          pbPlayDecisionSE
	  if $game_variables[59]>=1
          pbMessage(_INTL("Weather: Starstorm"))
          pbMessage(_INTL("Weather Ball Type: Cosmic"))
          pbMessage(_INTL("Additional Effects: Non-Cosmic types take 1/16 damage"))
          pbMessage(_INTL("Cosmic x 1.5, Fairy/Dragon/Steel x .5"))
          pbMessage(_INTL("Meteor Shower requires no charge"))
          else
            pbMessage(_INTL("No Readout Installed for this Weather"))
          end
        elsif cmdNone>=0 && cmd==cmdOver
          pbPlayDecisionSE
	  if $game_variables[60]>=1
          pbMessage(_INTL("Weather: Overcast"))
          pbMessage(_INTL("Weather Ball Type: Ghost"))
          pbMessage(_INTL("Additional Effects: Ghost x 1.5, Dark x .5"))
          pbMessage(_INTL("Shadow Force and Phantom Force require no charge"))
          else
            pbMessage(_INTL("No Readout Installed for this Weather"))
          end
        elsif cmdNone>=0 && cmd==cmdSleet
          pbPlayDecisionSE
	  if $game_variables[75]>=1
          pbMessage(_INTL("Weather: Sleet"))
          pbMessage(_INTL("Weather Ball Type: Ice"))
          pbMessage(_INTL("Additional Effects: Non-Ice types take 1/8 damage"))
          pbMessage(_INTL("Blizzard 100% accurate"))
          else
            pbMessage(_INTL("No Readout Installed for this Weather"))
          end
        elsif cmdNone>=0 && cmd==cmdFog
          pbPlayDecisionSE
	  if $game_variables[72]>=1
          pbMessage(_INTL("Weather: Fog"))
          pbMessage(_INTL("Weather Ball Type: Fairy"))
          pbMessage(_INTL("Additional Effects: Fairy x 1.5, Dragon x .5"))
          pbMessage(_INTL("All moves that check accuracy are 67% accurate"))
          else
            pbMessage(_INTL("No Readout Installed for this Weather"))
          end
        elsif cmdNone>=0 && cmd==cmdEclipse
          pbPlayDecisionSE
	  if $game_variables[61]>=1
          pbMessage(_INTL("Weather: Eclipse"))
          pbMessage(_INTL("Weather Ball Type: Dark"))
          pbMessage(_INTL("Additional Effects: Dark x 1.5, Ghost x 1.5"))
          pbMessage(_INTL("Additional Effects: Fairy x .5, Psychic x .5"))
          else
            pbMessage(_INTL("No Readout Installed for this Weather"))
          end
        elsif cmdNone>=0 && cmd==cmdWindy
          pbPlayDecisionSE
	  if $game_variables[63]>=1
          pbMessage(_INTL("Weather: Windy"))
          pbMessage(_INTL("Weather Ball Type: Flying"))
          pbMessage(_INTL("Additional Effects: Flying x 1.5, Rock x .5"))
          pbMessage(_INTL("Hazards fail to be set, and all hazards are removed"))
          else
            pbMessage(_INTL("No Readout Installed for this Weather"))
          end
        elsif cmdNone>=0 && cmd==cmdAcidR
          pbPlayDecisionSE
	  if $game_variables[62]>=1
          pbMessage(_INTL("Weather: Acid Rain"))
          pbMessage(_INTL("Weather Ball Type: Poison"))
          pbMessage(_INTL("Additional Effects: Non-Poison and Steel types take 1/16 damage"))
          pbMessage(_INTL("Poison types gain 30% Defense boost"))
          else
            pbMessage(_INTL("No Readout Installed for this Weather"))
          end
        elsif cmdNone>=0 && cmd==cmdHumid
          pbPlayDecisionSE
	  if $game_variables[65]>=1
          pbMessage(_INTL("Weather: Humid"))
          pbMessage(_INTL("Weather Ball Type: Bug"))
          pbMessage(_INTL("Fire x .5"))
          else
            pbMessage(_INTL("No Readout Installed for this Weather"))
          end
        elsif cmdNone>=0 && cmd==cmdHeatL
          pbPlayDecisionSE
	  if $game_variables[64]>=1
          pbMessage(_INTL("Weather: Heat Lightning"))
          pbMessage(_INTL("Weather Ball Type: Electric"))
          pbMessage(_INTL("Additional Effects: Electric x 1.5"))
          else
            pbMessage(_INTL("No Readout Installed for this Weather"))
          end
        elsif cmdNone>=0 && cmd==cmdRainbow
          pbPlayDecisionSE
	  if $game_variables[66]>=1
          pbMessage(_INTL("Weather: Rainbow"))
          pbMessage(_INTL("Weather Ball Type: Grass"))
          pbMessage(_INTL("Additional Effects: Grass x 1.5, Dark and Ghost x .5"))
          else
            pbMessage(_INTL("No Readout Installed for this Weather"))
          end
        elsif cmdNone>=0 && cmd==cmdDust
          pbPlayDecisionSE
	  if $game_variables[67]>=1
          pbMessage(_INTL("Weather: Dust Devil"))
          pbMessage(_INTL("Weather Ball Type: Ground"))
          pbMessage(_INTL("Additional Effects: Non-Ground and Flying types take 1/16 damage"))
          else
            pbMessage(_INTL("No Readout Installed for this Weather"))
          end
        elsif cmdNone>=0 && cmd==cmdDClear
          pbPlayDecisionSE
	  if $game_variables[68]>=1
          pbMessage(_INTL("Weather: Distortion World - Clear"))
          pbMessage(_INTL("Weather Ball Type: Cosmic"))
          pbMessage(_INTL("Additional Effects: Cosmic x 1.5"))
          else
            pbMessage(_INTL("No Readout Installed for this Weather"))
          end
        elsif cmdNone>=0 && cmd==cmdDRain
          pbPlayDecisionSE
	  if $game_variables[70]>=1
          pbMessage(_INTL("Weather: Distortion World - Rain"))
          pbMessage(_INTL("Weather Ball Type: Poison"))
          pbMessage(_INTL("Additional Effects: All non-Poison and Steel types take 1/16 damage"))
          else
            pbMessage(_INTL("No Readout Installed for this Weather"))
          end
        elsif cmdNone>=0 && cmd==cmdDWind
          pbPlayDecisionSE
	  if $game_variables[69]>=1
          pbMessage(_INTL("Weather: Distortion World - Windy"))
          pbMessage(_INTL("Weather Ball Type: Ghosts"))
          pbMessage(_INTL("Additional Effects: All non-Cosmic, Ghost or Flying types take 1/16 damage"))
          else
            pbMessage(_INTL("No Readout Installed for this Weather"))
          end
        elsif cmdNone>=0 && cmd==cmdDAsh
          pbPlayDecisionSE
	  if $game_variables[71]>=1
          pbMessage(_INTL("Weather: Distortion World - Ashfall"))
          pbMessage(_INTL("Weather Ball Type: Fighting"))
          pbMessage(_INTL("Additional Effects: Fighting types gain a 30% boost in Defense"))
          else
            pbMessage(_INTL("No Readout Installed for this Weather"))
          end
        elsif cmdNone>=0 && cmd==cmdVolc
          pbPlayDecisionSE
	  if $game_variables[73]>=1
          pbMessage(_INTL("Weather: Distorted Ashfall"))
          pbMessage(_INTL("Weather Ball Type: Steel"))
          pbMessage(_INTL("Additional Effects: Removes Steel's weaknesses"))
          else
            pbMessage(_INTL("No Readout Installed for this Weather"))
          end
        elsif cmdNone>=0 && cmd==cmdNLight
          pbPlayDecisionSE
	  if $game_variables[74]>=1
          pbMessage(_INTL("Weather: Northern Lights"))
          pbMessage(_INTL("Weather Ball Type: Psychic"))
          pbMessage(_INTL("Additional Effects: Psychic x 1.5, Ghost and Dark x .5"))
          else
            pbMessage(_INTL("No Readout Installed for this Weather"))
          end
        elsif cmdNone>=0 && cmd==cmdRift
          pbPlayDecisionSE
    if $game_variables[111]>=1
          pbMessage(_INTL("Weather: Temporal Rift"))
          pbMessage(_INTL("Weather Ball Type: Time"))
          pbMessage(_INTL("Additional Effects: Time x 1.5, Poison and Dark x .5"))
          pbMessage(_INTL("Trick Room lasts 2 more turns when set in this weather."))
          else
            pbMessage(_INTL("No Readout Installed for this Weather"))
          end
        elsif cmdNone>=0 && cmd==cmdEcho
            pbPlayDecisionSE
      if $game_variables[112]>=1
            pbMessage(_INTL("Weather: Echo Chamber"))
            pbMessage(_INTL("Weather Ball Type: Sound"))
            pbMessage(_INTL("Additional Effects: Sound x 1.5"))
            pbMessage(_INTL("Sound moves hit a second time at a lesser power."))
            else
              pbMessage(_INTL("No Readout Installed for this Weather"))
            end
        else# Exit
        pbPlayCloseMenuSE
        break
      end
    end
    @scene.pbEndScene
  end
end

class Pokemon
  def getMegaForm(checkItemOnly = false)
    ret = 0
    GameData::Species.each do |data|
      if data.species != :ALTEMPER
        next if data.species != @species || data.unmega_form != form_simple
      end
      if data.mega_stone && hasItem?(data.mega_stone)
        ret = data.form
        break
      elsif !checkItemOnly && data.mega_move && hasMove?(data.mega_move)
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
      @sprites["mega"].bitmap = @prKyogre.clone if @battler.isSpecies?(:ALTEMPER)
    elsif @sprites["mega"].bitmap
      @sprites["mega"].bitmap.clear
      @sprites["mega"].bitmap = nil
    end
    self.updateHpBar
    self.updateExpBar
  end
end


 GameData::BattleTerrain.register({
   :id        => :Poison,
   :name      => _INTL("Poison"),
   :animation => "PsychicTerrain"
 })

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
