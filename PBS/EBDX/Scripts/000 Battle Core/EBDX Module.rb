#===============================================================================
#  Main Utility Module for Elite Battle: DX
#-------------------------------------------------------------------------------
#  used to store and manipulate all of the configurable data and much more
#===============================================================================
module EliteBattle
  # variables for caching next battle segments
  @nextBattleBack = nil
  @nextBattleScript = nil
  @nextBattleData = nil
  @nextTransition = nil
  @wildSpecies = nil
  @wildLevel = nil
  @wildForm = nil
  @cachedBattler = nil
  @colorAlpha = 0
  @nextUI = nil
  @smAnim = false
  # variables for storing system data
  @pokemonData = {}
  @trainerData = {}
  @environmentData = {}
  @terrainData = {}
  @bgmData = {}
  @transitionData = {}
  @mapData = {}
  @procData = {}
  @metrics = {}
  @abilityMsg = []
  @abilityMsgText = []
  @vectors = {}
  @roomScale = 2.25
  @battlerMetrics = {}
  @customTransitions = {}
  @nextVectors = []
  # slight transition gimmick
  @tviewport = nil
  # configuration variables
  @messageLightColor = Color.new(51, 51, 51)
  @messageLightShadow = Color.new(212, 212, 212)
  @messageDarkColor = Color.white
  @messageDarkShadow = Color.new(32, 32, 32)
  # additional config vars
  @setBoss = false
  @logger = ErrorLogger.new("errorlogEBDX.txt")
  # cache move animations at game load
  @moveAnimations = load_data("Data/PkmnAnimations.rxdata")
  # ensure compiling
  @compiled = false
  @cachedData = []
  #-----------------------------------------------------------------------------
  # initialize logger
  #-----------------------------------------------------------------------------
  def self.log; return @logger; end
  def self.returnId(mod, const)
    return nil if !defined?(mod)
    return getID(mod, const)
  end
  #-----------------------------------------------------------------------------
  # internally parses action to valid symbolic name
  #-----------------------------------------------------------------------------
  def self.parse(var)
    return nil if !var.is_a?(Symbol) && !var.is_a?(String)
    return var if eval("defined?(@#{var})")
    return nil
  end
  #-----------------------------------------------------------------------------
  # gets value of specified varaible
  #-----------------------------------------------------------------------------
  def self.get(var)
    var = self.parse(var)
    return nil if var.nil?
    return self.instance_variable_get("@#{var}")
  end
  #-----------------------------------------------------------------------------
  # sets value for specified variable
  #-----------------------------------------------------------------------------
  def self.set(var, val)
    # specific catches
    return if var == :randomizer && !$PokemonGlobal && !$PokemonGlobal.randomizedData
    return if var == :nuzlocke && !$PokemonGlobal && !$PokemonGlobal.nuzlockeData
    # rest of function
    var = self.parse(var)
    if var == :nextBattleScript && val.is_a?(Symbol)
      val = hasConst?(BattleScripts, val) ? getConst(BattleScripts, val) : nil
    end
    return if var.nil?
    # concats battle speech parameter into an array if necessary
    if var == :nextBattleScript # potential compatibility for double battles
      if val.nil?
        @nextBattleScript = nil
      elsif !@nextBattleScript.nil?
        @nextBattleScript = [@nextBattleScript] if !@nextBattleScript.is_a?(Array)
        @nextBattleScript.push(val.is_a?(Hash) ? val.clone : nil)
      else
        @nextBattleScript = [val.is_a?(Hash) ? val.clone : nil]
      end
    else
      # merges hashes if applicable
      if val.is_a?(Hash) && self.get(var).is_a?(Hash)
        hash = self.get(var)
        for key in val.keys
          hash[key] = val[key]
        end
        val = hash
      end
      # applies varaible value
      self.instance_variable_set("@#{var}", val)
    end
  end
  #-----------------------------------------------------------------------------
  # resets value to nil
  #-----------------------------------------------------------------------------
  def self.reset(*args)
    for var in args
      self.set(var, nil)
    end
  end
  #-----------------------------------------------------------------------------
  # toggle selected variable
  #-----------------------------------------------------------------------------
  def self.toggle(sym)
    # specific catches
    return if sym == :randomizer && !$PokemonGlobal && !$PokemonGlobal.randomizedData
    return if var == :nuzlocke && !$PokemonGlobal && !$PokemonGlobal.nuzlockeData
    # rest of function
    val = self.get(sym)
    return if !val.is_a?(TrueClass) && !val.is_a?(FalseClass)
    val = !val
    self.set(sym, val)
  end
  #-----------------------------------------------------------------------------
  # converts constant into numeric number (if not already)
  #-----------------------------------------------------------------------------
  def self.const(const, forcemod = nil)
    forcemod = nil if forcemod == "other"
    return const if const.is_a?(Numeric)
    for mod in [PBEnvironment, PBTerrain, PBTrainers, PBSpecies]
      next if !forcemod.nil? && mod != forcemod
      const = const.upcase.to_sym if const.is_a?(String)
      return getConst(mod, const) if hasConst?(mod, const)
    end
    return nil
  end
  #-----------------------------------------------------------------------------
  # checks if observed dataset contains form info (prevent skipping)
  #-----------------------------------------------------------------------------
  def self.hasFormData?(dataset, skey, const, form)
    return false if !dataset.is_a?(Hash)
    for key in dataset.keys
      next if key == skey
      for val in dataset[key]
        if val.to_s.include?("_")
          vry = val.to_s.split("_")
          return true if vry[0] == const && vry[1].to_i == form
        end
      end
    end
    return false
  end
  #-----------------------------------------------------------------------------
  # registers all BGM
  #-----------------------------------------------------------------------------
  def self.assignBGM(key, *args)
    @bgmData[key] = args
  end
  #-----------------------------------------------------------------------------
  # gets next battle BGM
  #-----------------------------------------------------------------------------
  def self.nextBattleBGM?(id, variant = 0, ext = 0, mod = PBTrainers)
    return nil if id.nil?
    # try with form variants
    for key in @bgmData.keys
      return key if self.canTransition?(key, id, mod, variant, ext, @bgmData)
    end
    # try without form variants
    if mod == PBSpecies
      for key in @bgmData.keys
        return key if self.canTransition?(key, id, mod, 0, 0, @bgmData)
      end
    end
    # return nothing
    return nil
  end
  #-----------------------------------------------------------------------------
  # register custom battle animation transition
  #-----------------------------------------------------------------------------
  def self.registerTransition(name, process = nil, &block)
    @customTransitions[name] = (block.nil? ? process : block);
  end
  #-----------------------------------------------------------------------------
  # sets next transition
  #-----------------------------------------------------------------------------
  def self.nextTransition(name)
    @nextTransition = name
  end
  #-----------------------------------------------------------------------------
  # plays the next transition
  #-----------------------------------------------------------------------------
  def self.playNextTransition(viewport, trainer = nil, mod = PBTrainers)
    @tviewport = viewport
    # trainer assigned custom transitions
    if !trainer.nil?
      for key in @customTransitions.keys
        if self.canTransition?(key, trainer.trainertype, mod, trainer.name, trainer.partyID)
          wrapper = CallbackWrapper.new
          wrapper.set({ :viewport => viewport, :trainer => trainer, :trainerid => trainer.trainertype, :name => trainer.name, :partyID => trainer.partyID })
          wrapper.execute(@customTransitions[@key])
          return true
        end
      end
    end
    # play manually queued transition
    return false if @nextTransition.nil? || !@customTransitions.keys.include?(@nextTransition)
    wrapper = CallbackWrapper.new
    wrapper.set({ :viewport => viewport })
    wrapper.execute(@customTransitions[@nextTransition])
    @nextTransition = nil
    return true
  end
  #-----------------------------------------------------------------------------
  # registers all transitions
  #-----------------------------------------------------------------------------
  def self.assignTransition(*args)
    keys = []; vals = []
    for arg in args
      arr = arg.is_a?(String) ? keys : vals
      arr.push(arg)
    end
    for key in keys
      if @transitionData.has_key?(key)
        for val in vals
          @transitionData[key].push(val)
        end
      else
        @transitionData[key] = vals
      end
    end
  end
  #-----------------------------------------------------------------------------
  # checks whether or not to run special transition for constant
  #-----------------------------------------------------------------------------
  def self.canTransition?(transition, id, mod = PBTrainers, variant = 0, ext = 0, dataset = @transitionData)
    return false if !dataset.has_key?(transition)
    vrnt = variant
    array = dataset[transition]
    array = [array] if !array.is_a?(Array)
    return true if array.include?(:ALLOW_ALL)
    for val in array
      if val.to_s.include?("__i__")
        vry = [val.to_s.split("__i__")[0]]
        vry.push(variant) if variant.is_a?(String)
        vry.push(ext) if ext > 0
        return true if vry.join("__i__").to_sym == val
      elsif val.to_s.include?("_")
        prk = val.to_s.split("_")
        variant = 0 if prk[1] == "0" && !array.include?("#{prk[0]}_#{variant}".to_sym)
        return true if "#{self.const(prk[0].to_sym)}_#{prk[1]}" == "#{id}_#{vrnt}"
        return true if "#{self.const(prk[0].to_sym)}_#{prk[1]}" == "#{id}_#{variant}" && !self.hasFormData?(@transitionData, transition, prk[0], vrnt)
      end
      return true if self.const(val, mod) == id
    end
    return false
  end
  #-----------------------------------------------------------------------------
  # returns an array containing a list of all the possible SM VS backgrounds
  #-----------------------------------------------------------------------------
  def self.smTransitions?
    return ["trainer","special","elite","crazy","ultra","space","crystal","digital",
            "gold","forest","plasma","waves","flames"]
  end
  #-----------------------------------------------------------------------------
  # returns true if game is supposed to load a Sun & Moon styled VS sequence
  #-----------------------------------------------------------------------------
  def self.smTransition?(id, poke = false, variant = 0, extr = 0)
    ret = false
    for ext in self.smTransitions?
      ret = true if self.canTransition?("#{ext}SM", id, (poke ? PBSpecies : PBTrainers), variant, extr)
    end
    str = poke ? "species" : "trainer"
    ret = false if !pbResolveBitmap(sprintf("Graphics/EBDX/Transitions/#{str}%03d", id)) && !pbResolveBitmap(sprintf("Graphics/EBDX/Transitions/#{str}%03d_%d", id, poke ? variant : 0))
    return (@smAnim = ret)
  end
  #-----------------------------------------------------------------------------
  # adds additional metadata for Trainer and Pokemon
  #-----------------------------------------------------------------------------
  def self.addData(constant, *args)
    # compiler exception
    if !@compiled && $DEBUG
      args.insert(0, constant)
      @cachedData.push(args)
      return
    end
    # begin data processing
    constant = [constant] if !constant.is_a?(Array)
    mods = ["other"]
    for try_m in ["PBEnvironment", "PBTerrain", "PBTrainers", "PBSpecies"]
      eval("mods.push(#{try_m}) if defined?(#{try_m})")
    end
    forceMod = nil; addTo = nil
    if mods.include?(args[0])
      forceMod = args[0]; args.delete_at(0)
    end
    for contt in constant
      const = contt
      if contt.is_a?(Symbol)
        for mod in mods
          next if !forceMod.nil? && forceMod != mod
          const = contt; variant = 0
          # trainer validation
          if !hasConst?(mod, const) && const.to_s.include?("__i__")
            vry = const.to_s.split("__i__")
            const = vry[0].to_sym
          end
          next if mod != "other" && !hasConst?(mod, const)
          # checks to which module constant belongs to
          if defined?(PBTrainers) && mod == PBTrainers
            const = contt
            data = @trainerData.has_key?(const) ? @trainerData[const] : {}
            hash = @trainerData
            addTo = :TRAINERS
            break
          elsif defined?(PBSpecies) && mod == PBSpecies
            cd = const.to_s.split("_"); cd.push("0") if cd.length < 2
            const = cd.join("_").to_sym
            data = @pokemonData.has_key?(const) ? @pokemonData[const] : {}
            hash = @pokemonData
            addTo = :SPECIES
            break
          elsif defined?(PBEnvironment) && mod == PBEnvironment
            data = @environmentData.has_key?(const) ? @environmentData[const] : {}
            hash = @environmentData
            addTo = :ENVIRONMENT
            break
          elsif defined?(PBTerrain) && mod == PBTerrain
            data = @terrainData.has_key?(const) ? @terrainData[const] : {}
            hash = @terrainData
            addTo = :TERRAIN
            break
          elsif mod == "other"
            data = @metrics.has_key?(const) ? @metrics[const] : {}
            hash = @metrics
            addTo = :OTHER
          end
        end
      elsif contt.is_a?(Numeric)
        data = @mapData.has_key?(contt) ? @mapData[contt] : {}
        hash = @mapData
        addTo = :MAPS
      elsif contt.is_a?(Proc)
        data = @procData.has_key?(contt) ? @procData[contt] : {}
        hash = @procData
        addTo = :PROCS
      end
      # failsafe
      return if data.nil?
      # adds arguments depending on whether or not there are an even pair of them
      for i in 0...args.length
        next if i%2 == 1 || (i+1) >= args.length
        if [:BGM, :TRANSITION].include?(args[i]) && addTo != :MAPS
          set = (args[i] == :BGM) ? @bgmData : @transitionData
          if set.has_key?(args[i+1])
            set[args[i+1]].push(const)
          else
            set[args[i+1]] = [const]
          end
        elsif [:BACKDROP].include?(args[i]) && args[i+1].is_a?(Symbol) && defined?(EBEnvironment) && hasConst?(EBEnvironment, args[i+1])
          data[args[i]] = getConst(EBEnvironment, args[i+1])
        else
          data[args[i]] = args[i+1]
        end
      end
      hash[const] = data if !data.empty?
    end
  end
  #-----------------------------------------------------------------------------
  # gets additional metadata for Trainer and Pokemon
  #-----------------------------------------------------------------------------
  def self.getData(const, mod, key = nil, variant = 0, ext = 0)
    unless mod.is_a?(Proc)
      ct = const.is_a?(Symbol) ? const.to_s.split("__i__")[0].to_sym : const
      id = self.const(ct, mod)
    end
    # gets data from specified module
    if mod == PBTrainers
      data = @trainerData
    elsif mod == PBSpecies
      id = (id.to_s + "_" + variant.to_s)
      data = @pokemonData
    elsif mod == PBEnvironment
      data = @environmentData
    elsif mod == PBTerrain
      data = @terrainData
    elsif mod == PBMap
      return ((key.nil? ? @mapData[const] : @mapData[const][key]) rescue nil)
    elsif mod == PBMetrics
      return ((key.nil? ? @metrics[const] : @metrics[const][key]) rescue nil)
    end
    # failsafe
    return nil if data.nil?
    for hash_key in data.keys
      # for form offsets
      if mod == PBSpecies
        vry = hash_key.to_s.split("_")
        vry[1] = variant.to_s if vry[1] == "0" && !data.keys.include?("#{vry[0]}_#{variant}".to_sym) # applies default entry to all forms
        k = ("#{self.const(vry[0].to_sym, mod)}_#{vry[1]}")
      elsif mod == PBTrainers
        vry = hash_key.to_s.split("__i__")
        ct = self.const(vry[0].to_sym, mod)
        k = ct
        if ext.nil? || vry.nil?
          k = nil
        else
          k = nil if (variant.is_a?(String) && vry.length < 2) || (!variant.is_a?(String) && vry.length > 1)
          k = nil if (ext > 0 && vry.length < 3) || (ext < 1 && vry.length > 2)
        end
      else
        k = self.const(hash_key, mod)
      end
      if k == id
        if key.nil?
          return (data[hash_key] rescue nil)
        else
          return (data[hash_key][key] rescue nil)
        end
      end
    end
    return nil
  end
  #-----------------------------------------------------------------------------
  # gets trainer metadata
  #-----------------------------------------------------------------------------
  def self.getTrainerData(const, key, trainer = nil)
    d1 = self.getData(const, PBTrainers, key)
    d2 = trainer.nil? ? nil : self.getData(const, PBTrainers, key, trainer.name)
    d3 = trainer.nil? ? nil : self.getData(const, PBTrainers, key, trainer.name, trainer.partyID)
    return d3 if !d3.nil?
    return d2 if !d2.nil?
    return d1 if !d1.nil?
    return nil
  end
  #-----------------------------------------------------------------------------
  # adds main battler metrics
  #-----------------------------------------------------------------------------
  def self.battlerPos(index, *args)
    @battlerMetrics[index] = {}
    sym = nil
    for arg in args
      if arg.is_a?(Symbol)
        sym = arg; @battlerMetrics[index][sym] = []
      else
        @battlerMetrics[index][sym].push(arg) unless sym.nil?
      end
    end
  end
  #-----------------------------------------------------------------------------
  # gets trainerID from file
  #-----------------------------------------------------------------------------
  def self.trIdFromFile(file)
    num = file.split("trainer")[1]
    num.gsub!(".png", "") if num.include?(".png")
    return num.to_i
  end
  #-----------------------------------------------------------------------------
  # returns battle background sprite parameters from hashmap
  #-----------------------------------------------------------------------------
  def self.bgHashmap(key)
    hash = {:x => :ex, :y => :ey, :bitmap => :bitmap, :z => :z, :ox => :ox,
            :oy => :oy, :mirror => :mirror, :zoom => :param,
            :opacity => :opacity, :zoom_x => :zx, :zoom_y => :zy,
            :speed => :speed, :direction => :direction
    }
    return hash.has_key?(key) ? hash[key] : nil
  end
  #-----------------------------------------------------------------------------
  # stores vector data
  #-----------------------------------------------------------------------------
  def self.addVector(key,*args)
    if key == :CAMERA
      @vectors[key] = []
      for v in args
        v.push(1); @vectors[key].push(v)
      end
      return
    end
    args.push(1)
    @vectors[key] = args
  end
  #-----------------------------------------------------------------------------
  # returns vector data
  #-----------------------------------------------------------------------------
  def self.getVector(key, cond = nil)
    if [:MAIN, :BATTLER].include?(key)
      case key
      when :MAIN
        return @vectors[:TRIPLE].clone if @vectors.has_key?(:TRIPLE) && cond.respond_to?(:triplebattle?) && cond.triplebattle?
        return @vectors[:DOUBLE].clone if @vectors.has_key?(:DOUBLE) && cond.respond_to?(:doublebattle?) && cond.doublebattle?
        return @vectors[:SINGLE].clone if @vectors.has_key?(:SINGLE)
      when :BATTLER
        return cond ? @vectors[:PLAYER].clone : @vectors[:ENEMY].clone if @vectors.has_key?(:PLAYER, :ENEMY)
      end
    end
    return [102, 408, 32, 342, 1, 1] if !@vectors.has_key?(key)
    return @vectors[key].clone
  end
  #-----------------------------------------------------------------------------
  #  store random motion vectors
  #-----------------------------------------------------------------------------
  def self.nextCamera(*args)
    for vec in args
      @nextVectors.push(vec) if vec.is_a?(Array) && vec.length > 5
    end
  end
  #-----------------------------------------------------------------------------
  # gets random camera vector motion
  #-----------------------------------------------------------------------------
  def self.randomCamera?(battle, last)
    # failsafe
    if !@vectors.keys.include?(:CAMERA_MOTION) || !@vectors[:CAMERA_MOTION].is_a?(Array) || @vectors[:CAMERA_MOTION].empty?
      return self.getVector(:MAIN, battle).clone
    end
    a = @nextVectors.length > 0 ? @nextVectors.clone : @vectors[:CAMERA_MOTION].clone
    a.push(self.getVector(:MAIN, battle))
    a.delete_at(last) if !last.nil?
    return a
  end
  #-----------------------------------------------------------------------------
  # changes text displayed at the start of the battle if applicable
  #-----------------------------------------------------------------------------
  def self.battleText(default, *args)
    text = @nextBattleData.is_a?(Hash) && @nextBattleData.has_key?(:BATTLE_TEXT) ? @nextBattleData[:BATTLE_TEXT] : nil
    msg = (!text.nil? && text.is_a?(String)) ? text : default
    return _INTL(msg, *args)
  end
  #-----------------------------------------------------------------------------
  # check if follower Pokemon is active
  #-----------------------------------------------------------------------------
  def self.follower(battle)
    return (USE_FOLLOWER_EXCEPTION && $PokemonGlobal && $PokemonGlobal.respond_to?(:followerToggled) && $PokemonGlobal.followerToggled && battle.scene.firstsendout) ? 0 : nil
  end
  #-----------------------------------------------------------------------------
end
#===============================================================================
# slight compatibility trick
#===============================================================================
module PBMap; end
module PBMetrics; end
module PBEnvironment; end
module PBTerrain; end
class PBTrainers; end
module PBSpecies; end
class PBTypes; end
