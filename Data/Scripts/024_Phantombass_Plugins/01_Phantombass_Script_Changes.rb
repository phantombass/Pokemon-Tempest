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
    end
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
  if $game_switches[ChapterRelease::Four] && $game_switches[520] && $game_variables[ChapterRelease::Constant] == 0
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
  elsif $game_switches[ChapterRelease::Five] && $game_variables[ChapterRelease::Constant] == 1
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

module RPG
  class Weather
    attr_reader :type
    attr_reader :max
    attr_reader :ox
    attr_reader :oy

    def initialize(viewport = nil)
      @type         = 0
      @max          = 0
      @ox           = 0
      @oy           = 0
      @sunValue     = 0
      @sun          = 0
      @viewport     = Viewport.new(0,0,Graphics.width,Graphics.height)
      @viewport.z   = viewport.z+1
      @origViewport = viewport
      # [array of bitmaps, +x per frame, +y per frame, +opacity per frame]
      @weatherTypes = []
      @weatherTypes[PBFieldWeather::None]      = nil
      @weatherTypes[PBFieldWeather::Rain]      = [[], -6,  24, -8]
      @weatherTypes[PBFieldWeather::AcidRain]  = [[], -6,  24, -8]
      @weatherTypes[PBFieldWeather::DRain]     = [[], -6,  24, -8]
      @weatherTypes[PBFieldWeather::HeavyRain] = [[], -24, 24, -4]
      @weatherTypes[PBFieldWeather::Storm]     = [[], -24, 24, -4]
      @weatherTypes[PBFieldWeather::Snow]      = [[], -4,   8,  0]
      @weatherTypes[PBFieldWeather::VolcanicAsh]      = [[], -2,  2, -8]
      @weatherTypes[PBFieldWeather::DAshfall]      = [[], -2,  2, -8]
      @weatherTypes[PBFieldWeather::Windy]     = [[] , 4,   1,  0]
      @weatherTypes[PBFieldWeather::StrongWinds]     = [[] , -16,   1,  0]
      @weatherTypes[PBFieldWeather::Blizzard]  = [[], -16, 16, -4]
      @weatherTypes[PBFieldWeather::Sleet]     = [[], -16, 16, -4]
      @weatherTypes[PBFieldWeather::Sandstorm] = [[], -12,  4, -2]
      @weatherTypes[PBFieldWeather::DustDevil] = [[], -12,  4, -2]
      @weatherTypes[PBFieldWeather::Sun]       = nil
      @weatherTypes[PBFieldWeather::HarshSun]  = nil
      @weatherTypes[PBFieldWeather::Reverb]       = nil
      @weatherTypes[PBFieldWeather::TimeWarp]       = nil
      @sprites = []
    end

    def dispose
      @sprites.each { |s| s.dispose }
      @viewport.dispose
      @weatherTypes.each do |weather|
        next if !weather
        weather[0].each { |bitmap| bitmap.dispose if bitmap }
      end
    end

    def ox=(ox)
      return if @ox==ox
      @ox = ox
      @sprites.each { |s| s.ox = @ox }
    end

    def oy=(oy)
      return if @oy==oy
      @oy = oy
      @sprites.each { |s| s.oy = @oy }
    end

    def prepareRainBitmap
      rainColor = Color.new(255,255,255,255)
      @rain_bitmap = Bitmap.new(32,128)
      for i in 0...16
        @rain_bitmap.fill_rect(30-(i*2),i*8,2,8,rainColor)
      end
      @weatherTypes[PBFieldWeather::Rain][0][0] = @rain_bitmap
      @weatherTypes[PBFieldWeather::DRain][0][0] = @rain_bitmap
    end

    def prepareWindyBitmap
      colorWindy = Color.new(255, 255, 255, 64)
      @windy_bitmap = Bitmap.new(96, 192)
      for i in 0...96
        @windy_bitmap.fill_rect(190-(i*2), (96-i)/10, 2, 6, colorWindy)
      end
      @weatherTypes[PBFieldWeather::Windy][0][0] = @windy_bitmap
      @weatherTypes[PBFieldWeather::StrongWinds][0][0] = @windy_bitmap
    end

    def prepareAcidRainBitmap
      arainColor = Color.new(255,0,255,255)
      @arain_bitmap = Bitmap.new(32,128)
      for i in 0...16
        @arain_bitmap.fill_rect(30-(i*2),i*8,2,8,arainColor)
      end
      @weatherTypes[PBFieldWeather::AcidRain][0][0] = @arain_bitmap
    end

    def prepareStormBitmap
      rainColor = Color.new(255,255,255,255)
      @storm_bitmap = Bitmap.new(192,192)
      for i in 0...96
        @storm_bitmap.fill_rect(190-(i*2),i*2,2,2,rainColor)
      end
      @weatherTypes[PBFieldWeather::HeavyRain][0][0] = @storm_bitmap
      @weatherTypes[PBFieldWeather::Storm][0][0]     = @storm_bitmap
    end

    def prepareSnowBitmaps
      return if @snowBitmap1
      bmWidth  = 10
      bmHeight = 10
      @snowBitmap1 = Bitmap.new(bmWidth,bmHeight)
      @snowBitmap2 = Bitmap.new(bmWidth,bmHeight)
      @snowBitmap3 = Bitmap.new(bmWidth,bmHeight)
      snowColor = Color.new(224, 232, 240)
      # Small + shape
      @snowBitmap1.fill_rect(4,2,2,2,snowColor)
      @snowBitmap1.fill_rect(2,4,6,2,snowColor)
      @snowBitmap1.fill_rect(4,6,2,2,snowColor)
      # Fatter + shape
      @snowBitmap2.fill_rect(2,0,4,2,snowColor)
      @snowBitmap2.fill_rect(0,2,8,4,snowColor)
      @snowBitmap2.fill_rect(2,6,4,2,snowColor)
      # Diamond shape
      @snowBitmap3.fill_rect(4,0,2,2,snowColor)
      @snowBitmap3.fill_rect(2,2,6,2,snowColor)
      @snowBitmap3.fill_rect(0,4,10,2,snowColor)
      @snowBitmap3.fill_rect(2,6,6,2,snowColor)
      @snowBitmap3.fill_rect(4,8,2,2,snowColor)
      @weatherTypes[PBFieldWeather::Snow][0] = [@snowBitmap1,@snowBitmap2,@snowBitmap3]
    end

    def prepareAshBitmaps
      return if @ashBitmap1
      bmWidth  = 10
      bmHeight = 10
      @ashBitmap1 = Bitmap.new(bmWidth,bmHeight)
      @ashBitmap2 = Bitmap.new(bmWidth,bmHeight)
      @ashBitmap3 = Bitmap.new(bmWidth,bmHeight)
      ashColor = Color.new(100, 122, 130)
      # Small + shape
      @ashBitmap1.fill_rect(4,2,2,2,ashColor)
      @ashBitmap1.fill_rect(2,4,6,2,ashColor)
      @ashBitmap1.fill_rect(4,6,2,2,ashColor)
      # Fatter + shape
      @ashBitmap2.fill_rect(2,0,4,2,ashColor)
      @ashBitmap2.fill_rect(0,2,8,4,ashColor)
      @ashBitmap2.fill_rect(2,6,4,2,ashColor)
      # Diamond shape
      @ashBitmap3.fill_rect(4,0,2,2,ashColor)
      @ashBitmap3.fill_rect(2,2,6,2,ashColor)
      @ashBitmap3.fill_rect(0,4,10,2,ashColor)
      @ashBitmap3.fill_rect(2,6,6,2,ashColor)
      @ashBitmap3.fill_rect(4,8,2,2,ashColor)
      @weatherTypes[PBFieldWeather::VolcanicAsh][0] = [@ashBitmap1,@ashBitmap2,@ashBitmap3]
    end

    def prepareDAshBitmaps
      return if @dashBitmap1
      bmWidth  = 10
      bmHeight = 10
      @dashBitmap1 = Bitmap.new(bmWidth,bmHeight)
      @dashBitmap2 = Bitmap.new(bmWidth,bmHeight)
      @dashBitmap3 = Bitmap.new(bmWidth,bmHeight)
      dashColor = Color.new(100, 122, 130)
      # Small + shape
      @dashBitmap1.fill_rect(4,2,2,8,dashColor)
      @dashBitmap1.fill_rect(2,4,6,8,dashColor)
      @dashBitmap1.fill_rect(4,6,2,8,dashColor)
      # Fatter + shape
      @dashBitmap2.fill_rect(2,0,4,8,dashColor)
      @dashBitmap2.fill_rect(0,2,8,4,dashColor)
      @dashBitmap2.fill_rect(2,6,4,8,dashColor)
      # Diamond shape
      @dashBitmap3.fill_rect(4,0,2,8,dashColor)
      @dashBitmap3.fill_rect(2,2,6,8,dashColor)
      @dashBitmap3.fill_rect(0,4,10,8,dashColor)
      @dashBitmap3.fill_rect(2,6,6,8,dashColor)
      @dashBitmap3.fill_rect(4,8,2,8,dashColor)
      @weatherTypes[PBFieldWeather::DAshfall][0] = [@dashBitmap1,@dashBitmap2,@dashBitmap3]
    end

    def prepareBlizzardBitmaps
      return if @blizzardBitmap1
      bmWidth = 10; bmHeight = 10
      @blizzardBitmap1 = Bitmap.new(bmWidth,bmHeight)
      @blizzardBitmap2 = Bitmap.new(bmWidth,bmHeight)
      bmWidth = 200; bmHeight = 200
      @blizzardBitmap3 = Bitmap.new(bmWidth,bmHeight)
      @blizzardBitmap4 = Bitmap.new(bmWidth,bmHeight)
      snowColor = Color.new(224,232,240,255)
      # Fatter + shape
      @blizzardBitmap1.fill_rect(2,0,4,2,snowColor)
      @blizzardBitmap1.fill_rect(0,2,8,4,snowColor)
      @blizzardBitmap1.fill_rect(2,6,4,2,snowColor)
      # Diamond shape
      @blizzardBitmap2.fill_rect(4,0,2,2,snowColor)
      @blizzardBitmap2.fill_rect(2,2,6,2,snowColor)
      @blizzardBitmap2.fill_rect(0,4,10,2,snowColor)
      @blizzardBitmap2.fill_rect(2,6,6,2,snowColor)
      @blizzardBitmap2.fill_rect(4,8,2,2,snowColor)
      for i in 0...540
        @blizzardBitmap3.fill_rect(rand(bmWidth/2)*2,rand(bmHeight/2)*2,2,2,snowColor)
        @blizzardBitmap4.fill_rect(rand(bmWidth/2)*2,rand(bmHeight/2)*2,2,2,snowColor)
      end
      @weatherTypes[PBFieldWeather::Blizzard][0][0] = @blizzardBitmap1
      @weatherTypes[PBFieldWeather::Blizzard][0][1] = @blizzardBitmap2
      @weatherTypes[PBFieldWeather::Blizzard][0][2] = @blizzardBitmap3   # Tripled to make them 3x as common
      @weatherTypes[PBFieldWeather::Blizzard][0][3] = @blizzardBitmap3
      @weatherTypes[PBFieldWeather::Blizzard][0][4] = @blizzardBitmap3
      @weatherTypes[PBFieldWeather::Blizzard][0][5] = @blizzardBitmap4   # Tripled to make them 3x as common
      @weatherTypes[PBFieldWeather::Blizzard][0][6] = @blizzardBitmap4
      @weatherTypes[PBFieldWeather::Blizzard][0][7] = @blizzardBitmap4
      @weatherTypes[PBFieldWeather::Sleet][0][0] = @blizzardBitmap1
      @weatherTypes[PBFieldWeather::Sleet][0][1] = @blizzardBitmap2
      @weatherTypes[PBFieldWeather::Sleet][0][2] = @blizzardBitmap3   # Tripled to make them 3x as common
      @weatherTypes[PBFieldWeather::Sleet][0][3] = @blizzardBitmap3
      @weatherTypes[PBFieldWeather::Sleet][0][5] = @blizzardBitmap4   # Tripled to make them 3x as common
      @weatherTypes[PBFieldWeather::Sleet][0][6] = @blizzardBitmap4
    end

    def prepareSandstormBitmaps
      return if @sandstormBitmap1
      sandstormColors = [
         Color.new(31*8, 28*8, 17*8),
         Color.new(23*8, 16*8,  9*8),
         Color.new(29*8, 24*8, 15*8),
         Color.new(26*8, 20*8, 12*8),
         Color.new(20*8, 13*8,  6*8),
         Color.new(31*8, 30*8, 20*8),
         Color.new(27*8, 25*8, 20*8)
      ]
      bmWidth  = 200
      bmHeight = 200
      @sandstormBitmap1 = Bitmap.new(bmWidth,bmHeight)
      @sandstormBitmap2 = Bitmap.new(bmWidth,bmHeight)
      for i in 0...540
        @sandstormBitmap1.fill_rect(rand(bmWidth/2)*2,rand(bmHeight/2)*2,2,2,
           sandstormColors[rand(sandstormColors.length)])
        @sandstormBitmap2.fill_rect(rand(bmWidth/2)*2,rand(bmHeight/2)*2,2,2,
           sandstormColors[rand(sandstormColors.length)])
      end
      @weatherTypes[PBFieldWeather::Sandstorm][0] = [@sandstormBitmap1]
      @weatherTypes[PBFieldWeather::DustDevil][0] = [@sandstormBitmap2]
    end

    def ensureSprites
      return if @sprites.length>=40
      for i in 0...40
        if !@sprites[i]
          sprite = Sprite.new(@origViewport)
          sprite.z       = 1000
          sprite.ox      = @ox
          sprite.oy      = @oy
          sprite.opacity = 0
          @sprites.push(sprite)
        end
        @sprites[i].visible = (i<=@max)
      end
    end

    def max=(max)
      return if @max==max
      @max = [[max,0].max,40].min
      if @max==0
        @sprites.each { |s| s.dispose }
        @sprites.clear
      else
        @sprites.each_with_index { |s,i| s.visible = (i<=@max) if s }
      end
    end

    def type=(type)
      return if @type==type
      @type = type
      case @type
      when PBFieldWeather::None
        @sprites.each { |s| s.dispose }
        @sprites.clear
        return
      when PBFieldWeather::Rain, PBFieldWeather::DRain;                             prepareRainBitmap
      when PBFieldWeather::AcidRain;                             prepareAcidRainBitmap
      when PBFieldWeather::HeavyRain, PBFieldWeather::Storm;                      prepareStormBitmap
      when PBFieldWeather::Snow;                             prepareSnowBitmaps
      when PBFieldWeather::Windy, PBFieldWeather::StrongWinds;                             prepareWindyBitmap
      when PBFieldWeather::VolcanicAsh;                             prepareAshBitmaps
      when PBFieldWeather::DAshfall;                             prepareDAshBitmaps
      when PBFieldWeather::Blizzard, PBFieldWeather::Sleet;  prepareBlizzardBitmaps
      when PBFieldWeather::Sandstorm, PBFieldWeather::DustDevil;                      prepareSandstormBitmaps
      end
      weatherBitmaps = (@type==PBFieldWeather::None || @type==PBFieldWeather::Sun || @type==PBFieldWeather::HarshSun || @type==PBFieldWeather::HeatLight || @type==PBFieldWeather::Overcast || @type==PBFieldWeather::Starstorm || @type==PBFieldWeather::Humid || @type==PBFieldWeather::Fog  || @type==PBFieldWeather::Thunder  || @type==PBFieldWeather::DClear || @type==PBFieldWeather::DWind  || @type==PBFieldWeather::Borealis  || @type==PBFieldWeather::TimeWarp || @type==PBFieldWeather::Eclipse || @type==PBFieldWeather::Reverb || @type==PBFieldWeather::Rainbow) ? nil : @weatherTypes[@type][0]
      ensureSprites
      @sprites.each_with_index do |s,i|
        next if !s
        s.mirror = false
        s.mirror = (rand(2)==0) if @type==PBFieldWeather::Blizzard || @type==PBFieldWeather::Sandstorm
        s.bitmap  = (weatherBitmaps) ? weatherBitmaps[i%weatherBitmaps.length]: nil
      end
    end

    def update
      # @max is (power+1)*4, where power is between 1 and 9
      # Set tone of viewport (general screen brightening/darkening)
      case @type
      when PBFieldWeather::None;
        @viewport.tone.set(0,0,0,0)
        $game_map.fog_name = nil
      when PBFieldWeather::Rain;      @viewport.tone.set(-@max*3/4, -@max*3/4, -@max*3/4, 10)
      when PBFieldWeather::AcidRain;
        $game_map.fog_name = nil
        @viewport.tone.set(-@max*6/4, -@max*6/4, -@max*6/4, 20)
        @viewport.color.red = 255
        @viewport.color.green = 0
        @viewport.color.blue = 255
        @viewport.color.alpha = 25
      when PBFieldWeather::DRain;
        $game_map.fog_name = nil
        @viewport.tone.set(-@max*6/4, -@max*6/4, -@max*6/4, 20)
        @viewport.color.red = 255
        @viewport.color.green = 0
        @viewport.color.blue = 255
        @viewport.color.alpha = 25
      when PBFieldWeather::HeavyRain;
        @viewport.tone.set(-@max*6/4, -@max*6/4, -@max*6/4, 20)
        @viewport.color.red = 0
        @viewport.color.green = 0
        @viewport.color.blue = 0
        $game_map.fog_name = nil
      when PBFieldWeather::Storm;
        @viewport.tone.set(-@max*6/4, -@max*6/4, -@max*6/4, 20)
        @viewport.color.red = 0
        @viewport.color.green = 0
        @viewport.color.blue = 0
        @viewport.color.alpha = 0
        $game_map.fog_name = nil
      when PBFieldWeather::Thunder;
        @viewport.tone.set(-@max*6/4, -@max*6/4, -@max*6/4, 20)
        @viewport.color.red = 0
        @viewport.color.green = 0
        @viewport.color.blue = 0
        @viewport.color.alpha = 0
        $game_map.fog_name = nil
      when PBFieldWeather::HeatLight;
        @viewport.tone.set( @max*3/4,  @max*3/4,   @max*3/4,  0)
        $game_map.fog_name = nil
        @viewport.color.red = 255
        @viewport.color.green = 0
        @viewport.color.blue = 0
        @viewport.color.alpha = 100
      when PBFieldWeather::Starstorm;
        @viewport.tone.set(-@max*6/4, -@max*6/4, -@max*6/4, 20)
        $game_map.fog_name = nil
        @viewport.color.red = 64
        @viewport.color.green = 0
        @viewport.color.blue = 255
        @viewport.color.alpha = 15
        $game_map.fog_name = "starstorm2"
        $game_map.fog_opacity = 100
        $game_map.fog_zoom = 200
        $game_map.fog_sx = 0
        $game_map.fog_sy = 0
      when PBFieldWeather::Borealis;
        @viewport.tone.set(-@max*10/4, -@max*10/4, -@max*10/4, 20)
        $game_map.fog_name = "borealis"
        @viewport.color.red = 0
        @viewport.color.green = 64
        @viewport.color.blue = 255
        @viewport.color.alpha = 15
        $game_map.fog_opacity = 120
        $game_map.fog_zoom = 100
        $game_map.fog_sx = 2
        $game_map.fog_sy = 1
      when PBFieldWeather::Rainbow;
        @viewport.tone.set(@max/2, @max/2, @max/2, 0)
        $game_map.fog_name = "rainbow"
        $game_map.fog_opacity = 220
        $game_map.fog_zoom = 300
        $game_map.fog_sx = 0
        $game_map.fog_sy = 0
      when PBFieldWeather::Snow;
        @viewport.tone.set(   @max/2,    @max/2,    @max/2,  0)
        @viewport.color.red = 0
        @viewport.color.green = 0
        @viewport.color.blue = 0
        @viewport.color.alpha = 0
      when PBFieldWeather::Blizzard;
        @viewport.tone.set( @max*3/4,  @max*3/4,   @max*3/4,  0)
        @viewport.color.red = 0
        @viewport.color.green = 0
        @viewport.color.blue = 0
        @viewport.color.alpha = 0
      when PBFieldWeather::Overcast;
        @viewport.tone.set(-@max*6/4, -@max*6/4,  -@max*6/4, 20)
        $game_map.fog_name = "better"
        $game_map.fog_opacity = 72
        $game_map.fog_sx = 2
        $game_map.fog_sy = 0
        @viewport.color.red = 0
        @viewport.color.green = 0
        @viewport.color.blue = 0
        @viewport.color.alpha = 0
      when PBFieldWeather::Windy;
        @viewport.tone.set(-@max*6/4, -@max*6/4,  -@max*6/4, 20)
        @viewport.color.red = 0
        @viewport.color.green = 0
        @viewport.color.blue = 0
        @viewport.color.alpha = 0
        $game_map.fog_name = nil
      when PBFieldWeather::Eclipse;
        @viewport.tone.set(-@max*14/4, -@max*14/4,  -@max*14/4, 20)
        @viewport.color.red = 0
        @viewport.color.green = 0
        @viewport.color.blue = 0
        @viewport.color.alpha = 0
        $game_map.fog_name = nil
      when PBFieldWeather::DClear;    @viewport.tone.set(-@max*6/4, -@max*6/4,  -@max*6/4, 20)
      when PBFieldWeather::DWind;     @viewport.tone.set(-@max*6/4, -@max*6/4,  -@max*6/4, 20)
      when PBFieldWeather::StrongWinds;
        @viewport.tone.set(@max*3/4, @max*3/4,  @max*3/4, 0)
        @viewport.color.red = 0
        @viewport.color.green = 255
        @viewport.color.blue = 120
        @viewport.color.alpha = 35
        $game_map.fog_name = nil
      when PBFieldWeather::Humid;
        @viewport.tone.set(@max*3/4, @max*3/4,  @max*3/4, 0)
        @viewport.color.red = 0
        @viewport.color.green = 255
        @viewport.color.blue = 120
        @viewport.color.alpha = 35
        $game_map.fog_name = "better"
        $game_map.fog_opacity = 72
      when PBFieldWeather::DAshfall;
        @viewport.tone.set(-@max*6/4, -@max*6/4,  -@max*6/4, 20)
        $game_map.fog_name = nil
        @viewport.color.red = 255
        @viewport.color.green = 0
        @viewport.color.blue = 255
        @viewport.color.alpha = 25
      when PBFieldWeather::VolcanicAsh;
        @viewport.tone.set(-@max*6/4, -@max*6/4,  -@max*6/4, 20)
        @viewport.color.red = 0
        @viewport.color.green = 0
        @viewport.color.blue = 0
        @viewport.color.alpha = 0
        $game_map.fog_name = nil
      when PBFieldWeather::Fog;
        @viewport.tone.set( @max*3/4,  @max*3/4,   @max*3/4,  0)
        $game_map.fog_name = "better"
        $game_map.fog_opacity = 180
        @viewport.color.red = 0
        @viewport.color.green = 0
        @viewport.color.blue = 0
        @viewport.color.alpha = 0
        $game_map.fog_sx = 2
        $game_map.fog_sy = 0
      when PBFieldWeather::Reverb;
        $game_map.fog_name = nil
        @viewport.tone.set(0,0,0,0)
        @viewport.color.red = 0
        @viewport.color.green = 0
        @viewport.color.blue = 0
        @viewport.color.alpha = 0
      when PBFieldWeather::TimeWarp;
        $game_map.fog_name = nil
        @viewport.tone.set(0,0,0,0)
        @viewport.color.red = 0
        @viewport.color.green = 0
        @viewport.color.blue = 0
        @viewport.color.alpha = 0
      when PBFieldWeather::Sandstorm; @viewport.tone.set(   @max/2,         0,   -@max/2,  0)
      when PBFieldWeather::Sun
        $game_map.fog_name = nil
        @sun = @max if @sun!=@max && @sun!=-@max
        @sun = -@sun if @sunValue>@max || @sunValue<0
        @sunValue = @sunValue+@sun/32
        @viewport.tone.set(@sunValue+63,@sunValue+63,@sunValue/2+31,0)
      when PBFieldWeather::HarshSun
        $game_map.fog_name = nil
        @viewport.color.red = 255
        @viewport.color.green = 0
        @viewport.color.blue = 0
        @viewport.color.alpha = 100
        @sun = @max if @sun!=@max && @sun!=-@max
        @sun = -@sun if @sunValue>@max || @sunValue<0
        @sunValue = @sunValue+@sun/32
        @viewport.tone.set(@sunValue+63,@sunValue+63,@sunValue/2+31,0)
      end
      # Storm flashes
      if @type==PBFieldWeather::Storm || @type==PBFieldWeather::HeatLight
        rnd = rand(300)
        @viewport.flash(Color.new(255,255,255,230),rnd*20) if rnd<4
      end
      @viewport.update
      return if @type==PBFieldWeather::None || @type==PBFieldWeather::Sun || @type==PBFieldWeather::HarshSun || @type==PBFieldWeather::TimeWarp || @type==PBFieldWeather::Borealis || @type==PBFieldWeather::Reverb || @type==PBFieldWeather::Fog  || @type==PBFieldWeather::Overcast ||  @type==PBFieldWeather::DClear || @type==PBFieldWeather::DWind || @type==PBFieldWeather::HeatLight || @type==PBFieldWeather::Humid || @type==PBFieldWeather::Rainbow || @type==PBFieldWeather::Eclipse || @type==PBFieldWeather::Starstorm
      # Update weather particles (raindrops, snowflakes, etc.)
      ensureSprites
      for i in 1..@max
        sprite = @sprites[i]
        break if sprite==nil
        sprite.x += @weatherTypes[@type][1]
        sprite.x += [2,0,0,-2][rand(4)] if @type==PBFieldWeather::Snow || @type==PBFieldWeather::Blizzard  || @type==PBFieldWeather::Windy || @type==PBFieldWeather::StrongWinds
        sprite.y -= [2,4,6,8][rand(4)] if @type==PBFieldWeather::DAshfall || @type==PBFieldWeather::DRain
        sprite.y += @weatherTypes[@type][2]
        sprite.opacity += @weatherTypes[@type][3]
        # Check if sprite is off-screen; if so, reset it]
        x = sprite.x-@ox
        y = sprite.y-@oy
        nomWidth  = Graphics.width
        nomHeight = Graphics.height
        if sprite.opacity<64 || x<-50 || x>nomWidth+128 || y<-300 || y>nomHeight+20
          sprite.x = rand(nomWidth+150)-50+@ox
          sprite.y = rand(nomHeight+150)-200+@oy
          sprite.opacity = 255
          sprite.mirror = false
          sprite.mirror = (rand(2)==0) if @type==PBFieldWeather::Blizzard || @type==PBFieldWeather::Sandstorm
        end
        pbDayNightTint(sprite)
      end
    end
  end
end

class PokemonLoadScreen
  def initialize(scene)
    @scene = scene
  end

  def pbTryLoadFile(savefile)
    trainer       = nil
    framecount    = nil
    game_system   = nil
    pokemonSystem = nil
    mapid         = nil
    File.open(savefile) { |f|
      trainer       = Marshal.load(f)
      framecount    = Marshal.load(f)
      game_system   = Marshal.load(f)
      pokemonSystem = Marshal.load(f)
      mapid         = Marshal.load(f)
    }
    raise "Corrupted file" if !trainer.is_a?(PokeBattle_Trainer)
    raise "Corrupted file" if !framecount.is_a?(Numeric)
    raise "Corrupted file" if !game_system.is_a?(Game_System)
    raise "Corrupted file" if !pokemonSystem.is_a?(PokemonSystem)
    raise "Corrupted file" if !mapid.is_a?(Numeric)
    return [trainer,framecount,game_system,pokemonSystem,mapid]
  end

  def pbStartDeleteScreen
    savefile = RTP.getSaveFileName("Game.rxdata")
    @scene.pbStartDeleteScene
    @scene.pbStartScene2
    if safeExists?(savefile)
      if pbConfirmMessageSerious(_INTL("Delete all saved data?"))
        pbMessage(_INTL("Once data has been deleted, there is no way to recover it.\1"))
        if pbConfirmMessageSerious(_INTL("Delete the saved data anyway?"))
          pbMessage(_INTL("Deleting all data. Don't turn off the power.\\wtnp[0]"))
          begin; File.delete(savefile); rescue; end
          begin; File.delete(savefile+".bak"); rescue; end
          pbMessage(_INTL("The save file was deleted."))
        end
      end
    else
      pbMessage(_INTL("No save file was found."))
    end
    @scene.pbEndScene
    $scene = pbCallTitle
  end

  def pbStartLoadScreen
    $PokemonTemp   = PokemonTemp.new
    $game_temp     = Game_Temp.new
    $game_system   = Game_System.new
    $PokemonSystem = PokemonSystem.new if !$PokemonSystem
    savefile = RTP.getSaveFileName("Game.rxdata")
    FontInstaller.install if !mkxp?
    data_system = pbLoadRxData("Data/System")
    mapfile = sprintf("Data/Map%03d.rxdata",data_system.start_map_id)
    if data_system.start_map_id==0 || !pbRgssExists?(mapfile)
      pbMessage(_INTL("No starting position was set in the map editor.\1"))
      pbMessage(_INTL("The game cannot continue."))
      @scene.pbEndScene
      $scene = nil
      return
    end
    commands = []
    cmdContinue    = -1
    cmdNewGame     = -1
    cmdOption      = -1
    cmdLanguage    = -1
    cmdMysteryGift = -1
    cmdDebug       = -1
    cmdQuit        = -1
    if safeExists?(savefile)
      trainer      = nil
      framecount   = 0
      mapid        = 0
      haveBackup   = false
      showContinue = false
      begin
        trainer, framecount, $game_system, $PokemonSystem, mapid = pbTryLoadFile(savefile)
        showContinue = true
      rescue
        if safeExists?(savefile+".bak")
          begin
            trainer, framecount, $game_system, $PokemonSystem, mapid = pbTryLoadFile(savefile+".bak")
            haveBackup   = true
            showContinue = true
          rescue
          end
        end
        if haveBackup
          pbMessage(_INTL("The save file is corrupt. The previous save file will be loaded."))
        else
          pbMessage(_INTL("The save file is corrupt, or is incompatible with this game."))
          if !pbConfirmMessageSerious(_INTL("Do you want to delete the save file and start anew?"))
            $scene = nil
            return
          end
          begin; File.delete(savefile); rescue; end
          begin; File.delete(savefile+".bak"); rescue; end
          $game_system   = Game_System.new
          $PokemonSystem = PokemonSystem.new if !$PokemonSystem
          pbMessage(_INTL("The save file was deleted."))
        end
      end
      if showContinue
        if !haveBackup
          begin; File.delete(savefile+".bak"); rescue; end
        end
      end
      commands[cmdContinue = commands.length]    = _INTL("Continue") if showContinue
      commands[cmdNewGame = commands.length]     = _INTL("New Game")
      commands[cmdMysteryGift = commands.length] = _INTL("Mystery Gift") if (trainer.mysterygiftaccess rescue false)
    else
      commands[cmdNewGame = commands.length]     = _INTL("New Game")
    end
    commands[cmdOption = commands.length]        = _INTL("Options")
    commands[cmdLanguage = commands.length]      = _INTL("Language") if LANGUAGES.length>=2
    commands[cmdDebug = commands.length]         = _INTL("Debug") if $DEBUG
    commands[cmdQuit = commands.length]          = _INTL("Quit Game")
    @scene.pbStartScene(commands,showContinue,trainer,framecount,mapid)
    @scene.pbSetParty(trainer) if showContinue
    @scene.pbStartScene2
    pbLoadBattleAnimations
    loop do
      command = @scene.pbChoose(commands)
      if cmdContinue>=0 && command==cmdContinue
        unless safeExists?(savefile)
          pbPlayBuzzerSE
          next
        end
        pbPlayDecisionSE
        @scene.pbEndScene
        metadata = nil
        File.open(savefile) { |f|
          Marshal.load(f)   # Trainer already loaded
          $Trainer             = trainer
          Graphics.frame_count = Marshal.load(f)
          $game_system         = Marshal.load(f)
          Marshal.load(f)   # PokemonSystem already loaded
          Marshal.load(f)   # Current map id no longer needed
          $game_switches       = Marshal.load(f)
          $game_variables      = Marshal.load(f)
          $game_self_switches  = Marshal.load(f)
          $game_screen         = Marshal.load(f)
          $MapFactory          = Marshal.load(f)
          $game_map            = $MapFactory.map
          $game_player         = Marshal.load(f)
          $PokemonGlobal       = Marshal.load(f)
          metadata             = Marshal.load(f)
          $PokemonBag          = Marshal.load(f)
          $PokemonStorage      = Marshal.load(f)
          $SaveVersion         = Marshal.load(f) unless f.eof?
          pbRefreshResizeFactor if !mkxp?  # To fix Game_Screen pictures
          pbDisallowSpeedup if !$DEBUG
          time = pbGetTimeNow
          $game_variables[99] = time.day
          dailyWeather = $game_variables[27]
          if $game_variables[28] > $game_variables[99] || $game_variables[28]<$game_variables[99]
            $game_variables[27] = 1+rand(100)
            $game_variables[28] = $game_variables[99]
          end
          if dailyWeather>=96
            $game_switches[72] = true
            $game_switches[71] = false
          elsif dailyWeather>=86 && dailyWeather<96
            $game_switches[71] = true
            $game_switches[72] = false
          else
            $game_switches[71] = false
            $game_switches[72] = false
          end
          magicNumberMatches = false
          if $data_system.respond_to?("magic_number")
            magicNumberMatches = ($game_system.magic_number==$data_system.magic_number)
          else
            magicNumberMatches = ($game_system.magic_number==$data_system.version_id)
          end
          if !magicNumberMatches || $PokemonGlobal.safesave
            if pbMapInterpreterRunning?
              pbMapInterpreter.setup(nil,0)
            end
            begin
              $MapFactory.setup($game_map.map_id)   # calls setMapChanged
            rescue Errno::ENOENT
              if $DEBUG
                pbMessage(_INTL("Map {1} was not found.",$game_map.map_id))
                map = pbWarpToMap
                if map
                  $MapFactory.setup(map[0])
                  $game_player.moveto(map[1],map[2])
                else
                  $game_map = nil
                  $scene = nil
                  return
                end
              else
                $game_map = nil
                $scene = nil
                pbMessage(_INTL("The map was not found. The game cannot continue."))
              end
            end
            $game_player.center($game_player.x, $game_player.y)
          else
            $MapFactory.setMapChanged($game_map.map_id)
          end
        }
        if !$game_map.events   # Map wasn't set up
          $game_map = nil
          $scene = nil
          pbMessage(_INTL("The map is corrupt. The game cannot continue."))
          return
        end
        $PokemonMap = metadata
        $PokemonEncounters = PokemonEncounters.new
        $PokemonEncounters.setup($game_map.map_id)
        pbAutoplayOnSave
        $game_map.update
        $PokemonMap.updateMap
        $scene = Scene_Map.new
        return
      elsif cmdNewGame>=0 && command==cmdNewGame
        pbPlayDecisionSE
        @scene.pbEndScene
        if $game_map && $game_map.events
          for event in $game_map.events.values
            event.clear_starting
          end
        end
        $game_temp.common_event_id = 0 if $game_temp
        $scene               = Scene_Map.new
        Graphics.frame_count = 0
        $game_system         = Game_System.new
        $game_switches       = Game_Switches.new
        $game_variables      = Game_Variables.new
        $game_self_switches  = Game_SelfSwitches.new
        $game_screen         = Game_Screen.new
        $game_player         = Game_Player.new
        $PokemonMap          = PokemonMapMetadata.new
        $PokemonGlobal       = PokemonGlobalMetadata.new
        $PokemonStorage      = PokemonStorage.new
        $PokemonEncounters   = PokemonEncounters.new
        $PokemonTemp.begunNewGame = true
        pbRefreshResizeFactor if !mkxp?  # To fix Game_Screen pictures
        $data_system         = pbLoadRxData("Data/System")
        $MapFactory          = PokemonMapFactory.new($data_system.start_map_id)   # calls setMapChanged
        $game_player.moveto($data_system.start_x, $data_system.start_y)
        $game_player.refresh
        $game_map.autoplay
        $game_map.update
        pbDisallowSpeedup if !$DEBUG
        time = pbGetTimeNow
        $game_variables[99] = time.day
        dailyWeather = $game_variables[27]
        if $game_variables[28] > $game_variables[99] || $game_variables[28]<$game_variables[99]
          $game_variables[27] = 1+rand(100)
          $game_variables[28] = $game_variables[99]
        end
        if dailyWeather>=96
          $game_switches[72] = true
          $game_switches[71] = false
        elsif dailyWeather>=86 && dailyWeather<96
          $game_switches[71] = true
          $game_switches[72] = false
        else
          $game_switches[71] = false
          $game_switches[72] = false
        end
        return
      elsif cmdMysteryGift>=0 && command==cmdMysteryGift
        pbPlayDecisionSE
        pbFadeOutIn {
          trainer = pbDownloadMysteryGift(trainer)
        }
      elsif cmdOption>=0 && command==cmdOption
        pbPlayDecisionSE
        pbFadeOutIn {
          scene = PokemonOption_Scene.new
          screen = PokemonOptionScreen.new(scene)
          screen.pbStartScreen(true)
        }
      elsif cmdLanguage>=0 && command==cmdLanguage
        pbPlayDecisionSE
        @scene.pbEndScene
        $PokemonSystem.language = pbChooseLanguage
        pbLoadMessages("Data/"+LANGUAGES[$PokemonSystem.language][1])
        savedata = []
        if safeExists?(savefile)
          File.open(savefile,"rb") { |f|
            16.times { savedata.push(Marshal.load(f)) }
          }
          savedata[3]=$PokemonSystem
          begin
            File.open(RTP.getSaveFileName("Game.rxdata"),"wb") { |f|
              16.times { |i| Marshal.dump(savedata[i],f) }
            }
          rescue
          end
        end
        $scene = pbCallTitle
        return
      elsif cmdDebug>=0 && command==cmdDebug
        pbPlayDecisionSE
        pbFadeOutIn { pbDebugMenu(false) }
      elsif cmdQuit>=0 && command==cmdQuit
        pbPlayCloseMenuSE
        @scene.pbEndScene
        $scene = nil
        return
      end
    end
  end
end
