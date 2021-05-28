#================
#Multiple Forms
#================

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

MultipleForms.register(:RIOLU,{
  "getFormOnCreation" => proc { |pkmn|
    next if pkmn.form_simple>=3
    if $game_map
      map_metadata = GameData::MapMetadata.try_get($game_map.map_id)
      next 2 if map_metadata && map_metadata.town_map_position &&
                map_metadata.town_map_position[0] == 3   # Zharo region
    end
    next 0
  }
})

MultipleForms.copy(:RIOLU,:LUCARIO)

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

MultipleForms.register(:EXEGGCUTE,{
  "getFormOnCreation" => proc { |pkmn|
    next if pkmn.form_simple>=2
    if $game_map
      map_metadata = GameData::MapMetadata.try_get($game_map.map_id)   # Map IDs for Zharonian/Alolan Forme
      next 1 if map_metadata && map_metadata.town_map_position &&
                map_metadata.town_map_position[0] == 3   # Zharo region
    end
    next 0
  }
})

MultipleForms.copy(:EXEGGCUTE,:EXEGGUTOR,:LUVDISC,:QWILFISH)

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
    return if fainted? || @effects[PBEffects::Transform] || (!isSpecies?(:ALTEMPER) && !isSpecies?(:CASTFORM) && !isSpecies?(:CHERRIM) && !isSpecies?(:FORMETEOS))
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
                newForm += 21
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
            if @form!=newForm && @form <= 41
              @battle.pbShowAbilitySplash(self,true)
              @battle.pbHideAbilitySplash(self)
              pbChangeForm(newForm,_INTL("{1} transformed!",pbThis))
            elsif @form >= 42
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
            end
          else
          pbChangeForm(0,_INTL("{1} transformed!",pbThis))
        end
      end
      if isSpecies?(:FORMETEOS)
        if self.ability == :ACCLIMATE
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
          case newForm
          when 4 then                       self.type1 = :FAIRY
          when 0 then                       self.type1 = :NORMAL
          when 5 then                       self.type1 = :GHOST
          when 7 then                       self.type1 = :DARK
          when 8 then                       self.type1 = :FLYING
          when 9 then                       self.type1 = :ELECTRIC
          when 10 then                      self.type1 = :DRAGON
          when 11 then                      self.type1 = :POISON
          when 12 then                      self.type1 = :ROCK
          when 13 then                      self.type1 = :GRASS
          when 14 then                      self.type1 = :GROUND
          when 15 then                      self.type1 = :FIGHTING
          when 16 then                      self.type1 = :STEEL
          when 17 then                      self.type1 = :PSYCHIC
          when 18 then                      self.type1 = :BUG
          when 20 then                      self.type1 = :SOUND
          when 1 then                       self.type1 = :FIRE
          when 2 then                       self.type1 = :WATER
          when 3 then                       self.type1 = :ICE
          end
          if @form!=newForm
            @battle.pbShowAbilitySplash(self,true)
            @battle.pbHideAbilitySplash(self)
            self.form = newForm
          end
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
