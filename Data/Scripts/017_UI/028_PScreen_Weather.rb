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
       94,92,324,224,@viewport)
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
          if $game_variables[51]>=1
            pbMessage(_INTL("Weather: Clear"))
            pbMessage(_INTL("Weather Ball Type: Normal"))
            pbMessage(_INTL("Additional Effects: None"))
          else
            pbMessage(_INTL("No Readout Installed for this Weather"))
          end
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
          pbMessage(_INTL("Additional Effects: Non-Bug types are at -1 Speed"))
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
