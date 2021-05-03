#===============================================================================
#  Randomizer Functionality for EBS DX
#-------------------------------------------------------------------------------
#  Randomizes compiled data instead of generating random battlers on the fly
#===============================================================================
module EliteBattle
  @randomizer = false
  #-----------------------------------------------------------------------------
  #  check if randomizer is on
  #-----------------------------------------------------------------------------
  def self.randomizer?
    return $PokemonGlobal && $PokemonGlobal.isRandomizer
  end
  def self.randomizerOn?
    return self.randomizer? && self.get(:randomizer)
  end
  #-----------------------------------------------------------------------------
  #  randomizes compiled trainer data
  #-----------------------------------------------------------------------------
  def self.randomizeTrainers
    # loads compiled data and creates new array
    data = load_data_ebdx_randomizer("Data/trainers.dat")
    return if !data.is_a?(Array) # failsafe
    # iterates through each trainer
    for i in 0...data.length
      # if defined as an exclusion rule, trainer will not be randomized
      excl = self.getData(:RANDOMIZER, PBMetrics, :EXCLUSIONS_TRAINERS)
      if !excl.nil? && excl.is_a?(Array)
        for ent in excl
          next if !ent.is_a?(Numeric) && !hasConst?(PBTrainers, ent)
          t = ent.is_a?(Numeric) ? ent : getConst(PBTrainers, ent)
          break if data[i][0] == t
        end
        next if data[i][0] == t
      end
      # randomizes the species of each trainer party and removes move data if present
      for j in 0...data[i][3].length
        # if defined as an exclusion rule, species will not be randomized
        excl = self.getData(:RANDOMIZER, PBMetrics, :EXCLUSIONS_SPECIES)
        if !excl.nil? && excl.is_a?(Array)
          for ent in excl
            s = ent.is_a?(Numeric) ? ent : getConst(PBSpecies, ent)
            break if data[i][3][j][TPSPECIES] == s
          end
          next if data[i][3][j][TPSPECIES] == s
        end
        data[i][3][j][TPSPECIES] = randomizeSpecies(1 + rand(PBSpecies.maxValue))
        # erases moves so they get auto-generated
        data[i][3][j][TPMOVES] = []
      end
    end
    return data
  end
  #-----------------------------------------------------------------------------
  #  randomizes map encounters
  #-----------------------------------------------------------------------------
  def self.randomizeEncounters
    # loads map encounters
    data = load_data_ebdx_randomizer("Data/encounters.dat")
    return if !data.is_a?(Hash) # failsafe
    # iterates through each map point
    for key in data.keys
      for i in 0...data[key][1].length
        next if data[key][1][i].nil?
        # compiles hashtable for duplicate species
        hash = {}
        for j in 0...data[key][1][i].length
          hash[data[key][1][i][j][0]] = randomizeSpecies(1 + rand(PBSpecies.maxValue))
        end
        # randomizes species for each specified encounter type and frequency
        for j in 0...data[key][1][i].length
          data[key][1][i][j][0] = hash[data[key][1][i][j][0]]
        end
      end
    end
    return data
  end
  #-----------------------------------------------------------------------------
  #  randomizes static battles called through events
  #-----------------------------------------------------------------------------
  def self.randomizeStatic
    array = (1...PBSpecies.maxValue).to_a
    # shuffles up species indexes to load a different one
    16.times { array.shuffle! }
    return array
  end
  #-----------------------------------------------------------------------------
  #  randomizes items received through events
  #-----------------------------------------------------------------------------
  def self.randomizeItems
    new = []
    item = 1
    # shuffles up item indexes to load a different one
    (PBItems.maxValue - 1).times do
      loop do
        item = 1 + rand(PBItems.maxValue)
        break if !pbIsKeyItem?(item)
      end
      new.push(item)
    end
    return new
  end
  #-----------------------------------------------------------------------------
  #  begins the process of randomizing all data
  #-----------------------------------------------------------------------------
  def self.randomizeData
    data = {}
    # compiles hashtable with randomized values
    randomized = {
      :TRAINERS => EliteBattle.randomizeTrainers,
      :ENCOUNTERS => EliteBattle.randomizeEncounters,
      :STATIC => EliteBattle.randomizeStatic,
      :GIFTS => EliteBattle.randomizeStatic,
      :ITEMS => EliteBattle.randomizeItems
    }
    # applies randomized data for specified rule sets
    for key in self.getData(:RANDOMIZER, PBMetrics, :RULES)
      data[key] = randomized[key] if randomized.has_key?(key)
    end
    return data
  end
  #-----------------------------------------------------------------------------
  #  returns randomized data for specific entry
  #-----------------------------------------------------------------------------
  def self.getRandomizedData(data, symbol, index = nil)
    return data if !@randomizer
    if $PokemonGlobal && $PokemonGlobal.randomizedData && $PokemonGlobal.randomizedData.has_key?(symbol)
      return $PokemonGlobal.randomizedData[symbol][index-1] if !index.nil?
      return $PokemonGlobal.randomizedData[symbol]
    end
    return data
  end
  #-----------------------------------------------------------------------------
  # randomizes all data and toggles on randomizer
  #-----------------------------------------------------------------------------
  def self.startRandomizer(skip = false)
    ret = $PokemonGlobal && $PokemonGlobal.isRandomizer
    ret = self.randomizerSelection unless skip
    @randomizer = true
    # refresh current cache
    if $PokemonTemp
      $PokemonTemp.encountersData = nil
      $PokemonTemp.trainersData = nil
    end
    # randomize data and cache it
    $PokemonGlobal.randomizedData = self.randomizeData if $PokemonGlobal.randomizedData.nil?
    $PokemonGlobal.isRandomizer = ret
    $PokemonEncounters.setup($game_map.map_id)
  end
  #-----------------------------------------------------------------------------
  #  creates an UI to select the randomizer options
  #-----------------------------------------------------------------------------
  def self.randomizerSelection
    # list of all possible rules
    modifiers = [:TRAINERS, :ENCOUNTERS, :STATIC, :GIFTS, :ITEMS]
    # list of rule descriptions
    desc = [
      _INTL("Randomize Trainer parties"),
      _INTL("Randomize Wild encounters"),
      _INTL("Randomize Static encounters"),
      _INTL("Randomize Gifted Pokémon"),
      _INTL("Randomize Items")
    ]
    # default
    added = []; cmd = 0
    # creates help text message window
    msgwindow = pbCreateMessageWindow(nil, "choice 1")
    msgwindow.text = _INTL("Select the Randomizer Modes you wish to apply.")
    # main loop
    loop do
      # generates all commands
      commands = []
      for i in 0...modifiers.length
        commands.push(_INTL("{1} {2}", (added.include?(modifiers[i])) ? "[X]" : "[  ]", desc[i]))
      end
      commands.push(_INTL("Done"))
      # goes to command window
      cmd = self.commandWindow(commands, cmd, msgwindow)
      # processes return
      if cmd < 0
        clear = pbConfirmMessage("Do you wish to cancel the Randomizer selection?")
        added.clear if clear
        next unless clear
      end
      break if cmd < 0 || cmd >= (commands.length - 1)
      if cmd >= 0 && cmd < (commands.length - 1)
        if added.include?(modifiers[cmd])
          added.delete(modifiers[cmd])
        else
          added.push(modifiers[cmd])
        end
      end
    end
    # disposes of message window
    pbDisposeMessageWindow(msgwindow)
    # adds randomizer rules
    $PokemonGlobal.randomizerRules = added
    EliteBattle.addData(:RANDOMIZER, :RULES, added)
    # shows message
    msg = _INTL("Your selected Randomizer rules have been applied.")
    msg = _INTL("No Randomizer rules have been applied.") if added.length < 1
    msg = _INTL("Your selection has been cancelled.") if cmd < 0
    pbMessage(msg)
    Input.update
    return added.length > 0
  end
  #-----------------------------------------------------------------------------
  #  clear the randomizer content
  #-----------------------------------------------------------------------------
  def self.resetRandomizer
    EliteBattle.reset(:randomizer)
    if $PokemonGlobal
      $PokemonGlobal.randomizedData
      $PokemonGlobal.isRandomizer
      $PokemonGlobal.randomizerRules
    end
  end
  #-----------------------------------------------------------------------------
end
#===============================================================================
#  helper functions to return randomized battlers and items
#===============================================================================
def randomizeSpecies(species, static = false, gift = false)
  return species if !EliteBattle.get(:randomizer)
  pokemon = nil
  species = getConst(PBSpecies, species) if species.is_a?(Symbol)
  if species.is_a?(PokeBattle_Pokemon)
    pokemon = species.clone
    species = pokemon.species
  end
  # if defined as an exclusion rule, species will not be randomized
  excl = EliteBattle.getData(:RANDOMIZER, PBMetrics, :EXCLUSIONS_SPECIES)
  if !excl.nil? && excl.is_a?(Array)
    for ent in excl
      s = ent.is_a?(Numeric) ? ent : getConst(PBSpecies, ent)
      return (pokemon.nil? ? species : pokemon) if species == s
    end
  end
  # randomizes static encounters
  species = EliteBattle.getRandomizedData(species, :STATIC, species) if static
  species = EliteBattle.getRandomizedData(species, :GIFTS, species) if gift
  if !pokemon.nil?
    pokemon.species = species
    pokemon.calcStats
    pokemon.resetMoves
  end
  return pokemon.nil? ? species : pokemon
end

def randomizeItem(item)
  return item if !EliteBattle.get(:randomizer)
  item = getID(PBItems, item) unless item.is_a?(Numeric)
  return item if pbIsKeyItem?(item)
  # if defined as an exclusion rule, species will not be randomized
  excl = EliteBattle.getData(:RANDOMIZER, PBMetrics, :EXCLUSIONS_ITEMS)
  if !excl.nil? && excl.is_a?(Array)
    for ent in excl
      i = ent.is_a?(Numeric) ? ent : getID(PBItems, ent)
      return item if item == i
    end
  end
  return EliteBattle.getRandomizedData(item, :ITEMS, item)
end
#===============================================================================
#  aliasing to return randomized battlers
#===============================================================================
alias pbBattleOnStepTaken_ebdx_randomizer pbBattleOnStepTaken unless defined?(pbBattleOnStepTaken_ebdx_randomizer)
def pbBattleOnStepTaken(*args)
  $nonStaticEncounter = true
  pbBattleOnStepTaken_ebdx_randomizer(*args)
  $nonStaticEncounter = false
end

alias load_data_ebdx_randomizer load_data unless defined?(load_data_ebdx_randomizer)
def load_data(file)
  data = load_data_ebdx_randomizer(file)
  sym = (file.gsub("Data/", "").gsub(".dat", "")).upcase.to_sym
  return EliteBattle.getRandomizedData(data, sym)
end
#===============================================================================
#  aliasing to randomize static battles
#===============================================================================
alias pbWildBattle_ebdx_randomizer pbWildBattle unless defined?(pbWildBattle_ebdx_randomizer)
def pbWildBattle(*args)
  # randomizer
  for i in [0]
    args[i] = randomizeSpecies(args[i], !$nonStaticEncounter)
  end
  # starts battle processing
  return pbWildBattle_ebdx_randomizer(*args)
end

alias pbDoubleWildBattle_ebdx_randomizer pbDoubleWildBattle unless defined?(pbDoubleWildBattle_ebdx_randomizer)
def pbDoubleWildBattle(*args)
  # randomizer
  for i in [0, 2]
    args[i] = randomizeSpecies(args[i], !$nonStaticEncounter)
  end
  # starts battle processing
  return pbDoubleWildBattle_ebdx_randomizer(*args)
end

alias pbTripleWildBattle_ebdx_randomizer pbTripleWildBattle unless defined?(pbTripleWildBattle_ebdx_randomizer)
def pbTripleWildBattle(*args)
  # randomizer
  for i in [0, 2, 4]
    args[i] = randomizeSpecies(args[i], !$nonStaticEncounter)
  end
  # starts battle processing
  return pbTripleWildBattle_ebdx_randomizer(*args)
end
#===============================================================================
#  aliasing to randomize gifted Pokemon
#===============================================================================
alias pbAddPokemon_ebdx_randomizer pbAddPokemon unless defined?(pbAddPokemon_ebdx_randomizer)
def pbAddPokemon(*args)
  # randomizer
  args[0] = randomizeSpecies(args[0], false, true)
  # gives Pokemon
  return pbAddPokemon_ebdx_randomizer(*args)
end

alias pbAddPokemonSilent_ebdx_randomizer pbAddPokemonSilent unless defined?(pbAddPokemonSilent_ebdx_randomizer)
def pbAddPokemonSilent(*args)
  # randomizer
  args[0] = randomizeSpecies(args[0], false, true)
  # gives Pokemon
  return pbAddPokemonSilent_ebdx_randomizer(*args)
end
#===============================================================================
#  snipped of code used to alias the item receiving
#===============================================================================
#-----------------------------------------------------------------------------
#  item find
#-----------------------------------------------------------------------------
alias pbItemBall_ebdx_randomizer pbItemBall unless defined?(pbItemBall_ebdx_randomizer)
def pbItemBall(*args)
  args[0] = randomizeItem(args[0])
  return pbItemBall_ebdx_randomizer(*args)
end
#-----------------------------------------------------------------------------
#  item receive
#-----------------------------------------------------------------------------
alias pbReceiveItem_ebdx_randomizer pbReceiveItem unless defined?(pbReceiveItem_ebdx_randomizer)
def pbReceiveItem(*args)
  args[0] = randomizeItem(args[0])
  return pbReceiveItem_ebdx_randomizer(*args)
end
#===============================================================================
#  additional entry to Global Metadata for randomized data storage
#===============================================================================
class PokemonGlobalMetadata
  attr_accessor :randomizedData
  attr_accessor :isRandomizer
  attr_accessor :randomizerRules
end
#===============================================================================
#  refresh cache on load
#===============================================================================
class PokemonLoadScreen
  alias pbStartLoadScreen_ebdx_randomizer pbStartLoadScreen unless self.method_defined?(:pbStartLoadScreen_ebdx_randomizer)
  def pbStartLoadScreen
    ret = pbStartLoadScreen_ebdx_randomizer
    # refresh current cache
    if $PokemonGlobal && $PokemonGlobal.isRandomizer
      EliteBattle.startRandomizer(true)
      EliteBattle.addData(:RANDOMIZER, :RULES, $PokemonGlobal.randomizerRules) if !$PokemonGlobal.randomizerRules.nil?
    end
    return ret
  end
end
