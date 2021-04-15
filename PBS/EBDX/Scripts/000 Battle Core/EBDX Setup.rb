#===============================================================================
#  Main Utility Module for Elite Battle: DX
#-------------------------------------------------------------------------------
#  used to store and manipulate all of the configurable data and much more
#===============================================================================
module EliteBattle
  #-----------------------------------------------------------------------------
  # setup EBDX metrics
  #-----------------------------------------------------------------------------
  def self.setupData_Metrics
    # configure metrics data
    return if !File.safeData?("Data/Plugins/metrics.ebdx")
    metrics = load_data("Data/Plugins/metrics.ebdx")
    # iterate through all the sections
    for section in metrics.keys
      # configure vectors
      if section.upcase == "VECTORS"
        for vector in metrics[section].keys
          if vector == "__pk__"
            # apply room scaling
            EliteBattle.set(:roomScale, metrics[section][vector]["RoomScale"][0]) if metrics[section][vector]["RoomScale"]
          else
            # cache vector
            EliteBattle.addVector(vector.upcase.to_sym,
              metrics[section][vector]['XY'][0], metrics[section][vector]['XY'][1],
              metrics[section][vector]['ANGLE'][0],
              metrics[section][vector]['SCALE'][0],
              metrics[section][vector]['ZOOM'][0]
            )
          end
        end
      # configure battler position
      elsif section.upcase.include?("BATTLERPOS-")
        index = section.split("-")[-1].to_i
        args = [index]; sel = [:X, :Y, :Z]
        for j in 0...sel.length
          # add coordinate
          args.push(sel[j])
          for set in ['SINGLE', 'DOUBLE', 'TRIPLE']
            args.push(metrics[section][set]["XYZ"][j]) if metrics[section][set]
          end
          EliteBattle.battlerPos(*args)
        end
      # configure player databox
      elsif ["PLAYERDATABOX", "ENEMYDATABOX", "BOSSDATABOX"].include?(section.upcase)
        options = {}
        for key in metrics[section].keys
          # primary section
          if key == "__pk__"
            for smod in ['', 'HPBar', 'EXPBar']
              options[(smod.upcase + 'X').to_sym] = metrics[section][key][(smod + 'XY')][0] if metrics[section][key][(smod + 'XY')]
              options[(smod.upcase + 'Y').to_sym] = metrics[section][key][(smod + 'XY')][1] if metrics[section][key][(smod + 'XY')]
            end
            for set in ['ShowHP', 'ExpBarWidth', 'HPBarWidth', 'Bitmap', 'HPColors', 'Container', 'ExpandInDoubles']
              options[set.upcase.to_sym] = metrics[section][key][set][0] if metrics[section][key][set]
            end
          # every other section
          elsif metrics[section][key]['XYZ']
            options[key.downcase] = { :x => metrics[section][key]['XYZ'][0], :y => metrics[section][key]['XYZ'][1], :z => metrics[section][key]['XYZ'][2]}
          end
        end
        # register options
        EliteBattle.addData(section.upcase.to_sym, :METRICS, options)
      # configure command menu
      elsif section.upcase == "COMMANDMENU"
        options = {}
        # primary section
        for set in ['BarGraphic', 'SelectorGraphic', 'ButtonGraphic', 'PartyLineGraphic']
          options[set.upcase.to_sym] = metrics[section]["__pk__"][set][0] if metrics[section]["__pk__"] && metrics[section]["__pk__"][set]
        end
        # register options
        EliteBattle.addData(section.upcase.to_sym, :METRICS, options)
      # configure fight menu
      elsif section.upcase == "FIGHTMENU"
        options = {}
        # primary section
        for set in ['BarGraphic', 'SelectorGraphic', 'ButtonGraphic', 'MegaButtonGraphic', 'TypeGraphic', 'CategoryGraphic', 'ShowTypeAdvantage']
          options[set.upcase.to_sym] = metrics[section]["__pk__"][set][0] if metrics[section]["__pk__"] && metrics[section]["__pk__"][set]
        end
        # register options
        EliteBattle.addData(section.upcase.to_sym, :METRICS, options)
      # configure target menu
      elsif section.upcase == "TARGETMENU"
        options = {}
        # primary section
        for set in ['SelectorGraphic', 'ButtonGraphic']
          options[set.upcase.to_sym] = metrics[section]["__pk__"][set][0] if metrics[section]["__pk__"] && metrics[section]["__pk__"][set]
        end
        # register options
        EliteBattle.addData(section.upcase.to_sym, :METRICS, options)
      # configure bag UI
      elsif section.upcase == "BAGMENU"
        options = {}
        # primary section
        for set in ['PocketButtons', 'LastItem', 'BackButton', 'ItemFrame', 'PocketName', 'SelectorGraphic', 'ItemConfirm', 'ItemCancel', 'Shade', 'PocketIcons']
          options[set.upcase.to_sym] = metrics[section]["__pk__"][set][0] if metrics[section]["__pk__"] && metrics[section]["__pk__"][set]
        end
        # register options
        EliteBattle.addData(section.upcase.to_sym, :METRICS, options)
      end
    end
  end
  #-----------------------------------------------------------------------------
  # common configurations for PBS
  #-----------------------------------------------------------------------------
  def self.commonConfig(metrics, args, key)
    # set up common PBS configs
    confs = {
      "DATABOX" => {
        :smod => [''],
        :set => ['ShowHP', 'ExpBarWidth', 'HPBarWidth', 'Bitmap', 'HPColors', 'Container']
      },
      "COMMANDMENU" => {
        :set => ['BarGraphic', 'SelectorGraphic', 'ButtonGraphic', 'PartyLineGraphic']
      },
      "FIGHTMENU" => {
        :set => ['BarGraphic', 'SelectorGraphic', 'ButtonGraphic', 'MegaButtonGraphic', 'TypeGraphic', 'CategoryGraphic', 'ShowTypeAdvantage']
      },
      "TARGEMENU" => {
        :set => ['SelectorGraphic', 'ButtonGraphic']
      },
      "BAGMENU" => {
        :set => ['PocketButtons', 'LastItem', 'BackButton', 'ItemFrame', 'PocketName', 'SelectorGraphic', 'ItemConfirm', 'ItemCancel', 'Shade', 'PocketIcons']
      }
    }
    # go through all the common keys
    for ckey in confs.keys
      options = {}
      # additional XY modifiers
      if confs[ckey].has_key?(:smod)
        for smod in confs[ckey][:smod]
          next if !metrics[key][ckey] || !metrics[key][ckey][(smod + 'XY')]
          options[(smod.upcase + 'X').to_sym] = metrics[key][ckey][(smod + 'XY')][0]
          options[(smod.upcase + 'Y').to_sym] = metrics[key][ckey][(smod + 'XY')][1]
        end
      end
      # iterate through the sets of data
      if confs[ckey].has_key?(:set)
        for set in confs[ckey][:set]
          next if !metrics[key][ckey] || !metrics[key][ckey][set]
          options[set.upcase.to_sym] = metrics[key][ckey][set][0]
        end
      end
      # add options
      if options.keys.length > 0
        args.push((ckey + "_METRICS").to_sym); args.push(options)
      end
    end
    # return array output
    return args
  end
  #-----------------------------------------------------------------------------
  # setup Pokemon metadata
  #-----------------------------------------------------------------------------
  def self.setupData_Pokemon
    # configure metrics data
    return if !File.safeData?("Data/Plugins/pokemon.ebdx")
    metrics = load_data("Data/Plugins/pokemon.ebdx")
    for key in metrics.keys
      args = [key.gsub(/[-,\s]/, "_").to_sym]
      vals = {
        'BattlerEnemyX' => :EX,
        'BattlerEnemyY' => :EY,
        'BattlerPlayerX' => :PX,
        'BattlerPlayerY' => :PY,
        'BattlerAltitude' => :ALTITUDE,
        'BattleBGM' => :BGM,
        'LowHPBGM' => :LOWHPBGM,
        'BattleVS' => :TRANSITION,
        'BattleIntro' => :TRANSITION,
        'SpriteScaleEnemy' => :SCALE,
        'SpriteScalePlayer' => :BACKSCALE,
        'SpriteAnchorEnemy' => :ANCHOR,
        'SpriteAnchorPlayer' => :BACKANCHOR,
        'EvolutionBG' => :EVOBG,
        'HatchingBG' => :HATCHBG,
        'IsGrounded' => :GROUNDED,
        'HideName' => :HIDENAME,
        'SpriteSpeed' => :SPRITESPEED,
        'VictoryTheme' => :VICTORYTHEME,
        'BattleScript' => :BATTLESCRIPT
      }
      # failsafe
      next if !metrics[key]
      # iterate through registered metrics
      for v in vals.keys
        next if !metrics[key]["__pk__"] || !metrics[key]["__pk__"][v]
        args.push(vals[v]); args.push(metrics[key]["__pk__"][v].length > 1 ? metrics[key]["__pk__"][v] : metrics[key]["__pk__"][v][0])
      end
      # set up battle environment
      if metrics[key]["__pk__"] && metrics[key]["__pk__"]["BattleEnv"]
        ebenv = metrics[key]["__pk__"]["BattleEnv"][0]
        if hasConst?(EBEnvironment, ebenv.to_sym)
          args.push(:BACKDROP); args.push(getConst(EBEnvironment, ebenv.to_sym))
        else
          EliteBattle.log.warn("Environment #{ebenv} for Species #{key} is not defined in the ENVIRONMENTS.rb file!")
        end
      end
      # pokedex capture screen
      if metrics[key]["POKEDEXCAPTURESCREEN"]
        vals = {
          'Background' => :BACKGROUND,
          'Overlay' => :OVERLAY,
          'Highlight' => :HIGHLIGHT,
          'EndScreen' => :END_SCREEN,
          'Elements' => :ELEMENTS
        }; options = {}
        for v in vals.keys
          options[vals[v]] = metrics[key]["POKEDEXCAPTURESCREEN"][v][0]
        end
        args.push(:DEX_CAPTURE); args.push(options)
      end
      # configure common metrics
      args = self.commonConfig(metrics, args, key)
      # push arguments
      EliteBattle.addData(*args)
    end
  end
  #-----------------------------------------------------------------------------
  # setup Trainer metadata
  #-----------------------------------------------------------------------------
  def self.setupData_Trainers
    # configure metrics data
    return if !File.safeData?("Data/Plugins/trainers.ebdx")
    metrics = load_data("Data/Plugins/trainers.ebdx")
    for key in metrics.keys
      i = (key.split(",").map { |s| s.strip }).join("__i__")
      args = [i.to_sym]
      vals = {
        'TrainerPositionX' => :X,
        'TrainerPositionY' => :Y,
        'TrainerAltitude' => :ALTITUDE,
        'BattleBGM' => :BGM,
        'LowHPBGM' => :LOWHPBGM,
        'BattleVS' => :TRANSITION,
        'BattleIntro' => :TRANSITION,
        'SpriteScale' => :SCALE,
        'SpriteSpeed' => :SPRITESPEED,
        'VictoryTheme' => :VICTORYTHEME,
        'BattleScript' => :BATTLESCRIPT,
        'Ace' => :ACE
      }
      # failsafe
      next if !metrics[key]
      # iterate through registered metrics
      for v in vals.keys
        next if !metrics[key]["__pk__"] || !metrics[key]["__pk__"][v]
        args.push(vals[v]); args.push(metrics[key]["__pk__"][v].length > 1 ? metrics[key]["__pk__"][v] : metrics[key]["__pk__"][v][0])
      end
      # set up battle environment
      if metrics[key]["__pk__"] && metrics[key]["__pk__"]["BattleEnv"]
        ebenv = metrics[key]["__pk__"]["BattleEnv"][0]
        if hasConst?(EBEnvironment, ebenv.to_sym)
          args.push(:BACKDROP); args.push(getConst(EBEnvironment, ebenv.to_sym))
        else
          EliteBattle.log.warn("Environment #{ebenv} for Trainer #{key} is not defined in the ENVIRONMENTS.rb file!")
        end
      end
      # configure common metrics
      args = self.commonConfig(metrics, args, key)
      # push arguments
      EliteBattle.addData(*args)
    end
  end
  #-----------------------------------------------------------------------------
  # setup Map metadata
  #-----------------------------------------------------------------------------
  def self.setupData_Maps
    # configure metrics data
    return if !File.safeData?("Data/Plugins/maps.ebdx")
    metrics = load_data("Data/Plugins/maps.ebdx")
    for key in metrics.keys
      i = (key.split(",").map { |s| s.strip }).join("__i__")
      args = [i.to_i]
      vals = {
        'BattleBGM' => :BGM,
      }
      # failsafe
      next if !metrics[key]
      # iterate through registered metrics
      for v in vals.keys
        next if !metrics[key]["__pk__"] || !metrics[key]["__pk__"][v]
        args.push(vals[v]); args.push(metrics[key]["__pk__"][v].length > 1 ? metrics[key]["__pk__"][v] : metrics[key]["__pk__"][v][0])
      end
      # set up battle environment
      if metrics[key]["__pk__"] && metrics[key]["__pk__"]["BattleEnv"]
        ebenv = metrics[key]["__pk__"]["BattleEnv"][0]
        if hasConst?(EBEnvironment, ebenv.to_sym)
          args.push(:BACKDROP); args.push(getConst(EBEnvironment, ebenv.to_sym))
        else
          EliteBattle.log.warn("Environment #{ebenv} for Map #{key} is not defined in the ENVIRONMENTS.rb file!")
        end
      end
      # configure common metrics
      args = self.commonConfig(metrics, args, key)
      # push arguments
      EliteBattle.addData(*args)
    end
  end
  #-----------------------------------------------------------------------------
  # setup battle environments
  #-----------------------------------------------------------------------------
  def self.setupScenes
    #---------------------------------------------------------------------------
    # Battle Room configurations per Environment
    # Cave
    self.addData(:Cave, PBEnvironment, :BACKDROP, EBEnvironment::CAVE)
    # Dark Cave (based on conditional)
    self.addData(proc{ |terrain, environ|
        return environ == PBEnvironment::Cave && pbGetMetadata($game_map.map_id, MetadataDarkMap)
      }, :BACKDROP, EBEnvironment::DARKCAVE)
    # Water
    self.addData(:MovingWater, PBEnvironment, :BACKDROP, EBEnvironment::WATER)
    # Underwater
    self.addData(:Underwater, PBEnvironment, :BACKDROP, EBEnvironment::UNDERWATER)
    # Forest
    self.addData(:Forest, PBEnvironment, :BACKDROP, EBEnvironment::FOREST)
    # Indoor
    self.addData(:None, PBEnvironment, :BACKDROP, EBEnvironment::INDOOR)
    # Outdoor
    self.addData(:Grass, PBEnvironment, :BACKDROP, EBEnvironment::OUTDOOR)
    # Mountains
    self.addData(:Rock, PBEnvironment, :BACKDROP, EBEnvironment::MOUNTAIN)
    #---------------------------------------------------------------------------
    # Battle Room configurations per Terrain
    # Mountains
    self.addData(:Rock, PBTerrain, :BACKDROP, EBTerrain::MOUNTAIN)
    # Puddle
    self.addData(:Puddle, PBTerrain, :BACKDROP, EBTerrain::PUDDLE)
    # Sand
    self.addData(:Sand, PBTerrain, :BACKDROP, EBTerrain::DIRT)
    # Tall Grass
    self.addData(proc{ |terrain, environ|
      return [PBTerrain::Grass, PBTerrain::TallGrass].include?(terrain) && environ != PBEnvironment::Underwater
    }, :BACKDROP, EBTerrain::TALLGRASS)
    # concrete base when in cities
    self.addData(proc{ |terrain, environ|
        return ($game_map.name.downcase).include?("city") || ($game_map.name.downcase).include?("town")
      }, :BACKDROP, EBTerrain::CONCRETE)
    # water base when surfing and no water environment is defined
    self.addData(proc{ |terrain, environ|
        return $PokemonGlobal.surfing && environ != PBEnvironment::MovingWater
      }, :BACKDROP, EBTerrain::WATER)
  end
  #-----------------------------------------------------------------------------
  # setup EBDX data
  #-----------------------------------------------------------------------------
  def self.setupData
    # load move/common animations if compiled
    File.runScript("Data/Plugins/animations.ebdx")
    # setup metrics
    self.setupData_Metrics
    # setup Pokemon metadata
    self.setupData_Pokemon
    # setup Trainer metadata
    self.setupData_Trainers
    # setup map metadata
    self.setupData_Maps
    # setup battle scenes
    self.setupScenes
  end
end
#===============================================================================
#  Compatibility for trainer party IDs
#===============================================================================
class PokeBattle_Trainer
  attr_accessor :partyID
end
# failsafe
module EBEnvironment; end
module EBTerrain; end
#-------------------------------------------------------------------------------
#  trainer generation override
#-------------------------------------------------------------------------------
alias pbLoadTrainer_ebdx pbLoadTrainer unless defined?(pbLoadTrainer_ebdx)
def pbLoadTrainer(trainerid, trainername, partyid = 0)
  ret = pbLoadTrainer_ebdx(trainerid, trainername, partyid)
  ret[0].partyID = partyid
  # try to load the next battle speech
  speech = EliteBattle.getTrainerData(trainerid, :BATTLESCRIPT, ret[0])
  EliteBattle.set(:nextBattleScript, speech.to_sym) if !speech.nil?
  return ret
end
#-------------------------------------------------------------------------------
