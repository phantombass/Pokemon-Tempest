#===============
# Weather
#===============
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

#===================
#Overworld Weather
#===================

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

#=========================
#Battle Weather
#=========================

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

#====================
#Battle Terrain
#====================

GameData::BattleTerrain.register({
  :id        => :Poison,
  :name      => _INTL("Poison"),
  :animation => "PsychicTerrain"
})

#====================
#Weather Readouts
#====================

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
      completeQuest(:Quest2,"26CC4B56",false)
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
          pbMessage(_INTL("Weather: Volcanic Ash"))
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
