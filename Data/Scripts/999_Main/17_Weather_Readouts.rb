PluginManager.register({
  :name => "Weather Readouts",
  :version => "1.0",
  :credits => "Phantombass",
  :link => "No link yet"
})

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
    pbSetSelfSwitch(@event_id,"A",true)
  end
end
