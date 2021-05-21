#===============================================================================
#  Additions to the Pokemon class for additional functionality
#===============================================================================
class Pokemon
  attr_accessor :superHue
  attr_accessor :superVariant
  attr_accessor :forceSuper
  attr_accessor :dynamax
  attr_accessor :gfactor
  #-----------------------------------------------------------------------------
  #  function to implement additional shiny variants
  #-----------------------------------------------------------------------------
  alias shiny_ebdx shiny? unless self.method_defined?(:shiny_ebdx)
  def shiny?
    data = EliteBattle.get(:nextBattleData); data = {} if !data.is_a?(Hash)
    if self.superVariant.nil?
      self.superVariant = false
      sRate = data.has_key?(:SHINY_RATE) ? data[:SHINY_RATE] : 0
      self.makeShiny if (rand(10000) < sRate*100)
    end
    shiny = shiny_ebdx
    ssRate = data.has_key?(:SUPER_SHINY_RATE) ? data[:SUPER_SHINY_RATE] : EliteBattle::SUPER_SHINY_RATE
    return shiny if !ssRate || ssRate == 0
    if shiny && self.superHue.nil?
      self.superHue = false
      if (self.forceSuper || rand(10000) < ssRate*100)
        self.superHue = (1 + rand(7))*45
        self.superVariant = (rand(2) == 0) ? true : false
      end
    end
    return self.superShiny? ? true : shiny
  end
  #-----------------------------------------------------------------------------
  #  function to check whether additional shiny variant is applied
  #-----------------------------------------------------------------------------
  def superShiny?
    return self.superHue.is_a?(Numeric) ? true : false
  end
  #-----------------------------------------------------------------------------
  #  Adjustment to stat re-calculation
  #-----------------------------------------------------------------------------
  def calc_stats(basestat = nil, boss = false)
    base_stats = basestat.is_a?(Array) ? basestat.clone : self.baseStats
    this_level = self.level
    this_IV    = self.calcIV
    # Format stat multipliers due to nature
    nature_mod = {}
    GameData::Stat.each_main { |s| nature_mod[s.id] = 100 }
    this_nature = self.nature_for_stats
    if this_nature
      this_nature.stat_changes.each { |change| nature_mod[change[0]] += change[1] }
    end
    # Calculate stats
    stats = {}; i = 0
    GameData::Stat.each_main do |s|
      if s.id == :HP
        stats[s.id] = (calcHP(base_stats[s.id], this_level, this_IV[s.id], @ev[s.id]) * (boss ? boss[s.id] : 1)).round
      else
        stats[s.id] = (calcStat(base_stats[s.id], this_level, this_IV[s.id], @ev[s.id], nature_mod[s.id]) * (boss ? boss[s.id] : 1)).round
      end
    end
    hpDiff = @totalhp - @hp
    @totalhp = stats[:HP]
    @hp      = @totalhp - hpDiff
    @attack  = stats[:ATTACK]
    @defense = stats[:DEFENSE]
    @spatk   = stats[:SPECIAL_ATTACK]
    @spdef   = stats[:SPECIAL_DEFENSE]
    @speed   = stats[:SPEED]
  end
  #-----------------------------------------------------------------------------
  #  sauce
  #-----------------------------------------------------------------------------
  alias name_ebdx name unless self.method_defined?(:name_ebdx)
  def name
    return _INTL("Bidoof") if GameData::Species.exists?(:BIDOOF) && defined?(firstApr?) && firstApr?
    hide = EliteBattle.get_data(self.species, :Species, :HIDENAME, (self.form rescue 0)) && !$Trainer.owned?(self.species)
    return hide ? _INTL("???") : self.name_ebdx
  end
  #-----------------------------------------------------------------------------
end
#===============================================================================
#  Addition for move data (legacy compatibility)
#===============================================================================
class EBMoveData
  attr_reader :function, :basedamage, :type, :accuracy, :category
  attr_reader :totalpp, :addlEffect, :target, :priority, :flags
  #-----------------------------------------------------------------------------
  #  fix issues with PBMoveData
  #-----------------------------------------------------------------------------
  def initialize(moveid)
    moveData = pbGetMoveData(moveid)
    @function   = moveData[MOVE_FUNCTION_CODE]
    @basedamage = moveData[MOVE_BASE_DAMAGE]
    @type       = moveData[MOVE_TYPE]
    @category   = moveData[MOVE_CATEGORY]
    @accuracy   = moveData[MOVE_ACCURACY]
    @totalpp    = moveData[MOVE_TOTAL_PP]
    @addlEffect = moveData[MOVE_EFFECT_CHANCE]
    @target     = moveData[MOVE_TARGET]
    @priority   = moveData[MOVE_PRIORITY]
    @flags      = moveData[MOVE_FLAGS]
  end
  #-----------------------------------------------------------------------------
end
