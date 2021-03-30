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
        $game_map.fog_name = nil
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
