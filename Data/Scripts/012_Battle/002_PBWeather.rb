begin
  module PBWeather
    None        = 0
    Sun         = 1
    Rain        = 2
    Sandstorm   = 3
    Hail        = 4
    HarshSun    = 5
    HeavyRain   = 6
    StrongWinds = 7
    ShadowSky   = 8
    Starstorm   = 9
    Overcast    = 10
    Sleet       = 11
    Fog         = 12
    Eclipse     = 13
    SolarFlare  = 14
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
    Storm       = 29
    TimeWarp    = 30 #Temporal Rift
    Reverb      = 31 #Echo Chamber


    def self.animationName(weather)
      case weather
      when Sun;         return "Sun"
      when Rain;        return "Rain"
      when Sandstorm;   return "Sandstorm"
      when Hail;        return "Hail"
      when HarshSun;    return "Sun"
      when HeavyRain;   return "HeavyRain"
      when Storm;       return "HeavyRain"
      when StrongWinds; return "StrongWinds"
      when ShadowSky;   return "ShadowSky"
      when Starstorm;   return "ShadowSky"
      when Thunder;     return nil
      when Windy;       return "Windy"
      when DustDevil;   return "Sandstorm"
      when Sleet;       return "Hail"
      when SolarFlare;  return "HarshSun"
      when HeatLight;   return nil
      when Fog;         return "Fog"
	    when Overcast;	  return nil
      when VolcanicAsh; return "VolcanicAsh"
      when Borealis;    return nil
      end
      return nil
    end
  end

rescue Exception
  if $!.is_a?(SystemExit) || "#{$!.class}"=="Reset"
    raise $!
  end
end
