#===============================================================================
#  Additions to the Pokemon class for additional functionality
#===============================================================================
class PokeBattle_Pokemon
  attr_accessor :superHue
  attr_accessor :superVariant
  attr_accessor :forceSuper
  attr_accessor :dynamax
  attr_accessor :gfactor
  #-----------------------------------------------------------------------------
  #  function to implement additional shiny variants
  #-----------------------------------------------------------------------------
  alias shiny_ebdx isShiny? unless self.method_defined?(:shiny_ebdx)
  def isShiny?
    data = EliteBattle.get(:nextBattleData); data = {} if !data.is_a?(Hash)
    if self.superVariant.nil?
      self.superVariant = false
      sRate = data.has_key?(:SHINY_RATE) ? data[:SHINY_RATE] : 0
      self.makeShiny if (rand(10000) < sRate*100)
    end
    shiny = shiny_ebdx
    ssRate = data.has_key?(:SUPER_SHINY_RATE) ? data[:SUPER_SHINY_RATE] : SUPER_SHINY_RATE
    return shiny if !ssRate || ssRate == 0
    if shiny && self.superHue.nil?
      self.superHue = false
      if (self.forceSuper || rand(10000) < ssRate*100)
        self.superHue = (1 + rand(7))*45
        self.superVariant = (rand(2) == 0) ? true : false
      end
    end
    return self.isSuperShiny? ? true : shiny
  end
  #-----------------------------------------------------------------------------
  #  fix for held items
  #-----------------------------------------------------------------------------
  def hasItem?(item_id = 0)
    held_item = self.item
    return held_item > 0 if item_id == 0
    return false if held_item == 0 && getID(PBItems, item_id) == 0
    return held_item == getID(PBItems,item_id)
  end
  #-----------------------------------------------------------------------------
  #  function to check whether additional shiny variant is applied
  #-----------------------------------------------------------------------------
  def isSuperShiny?
    return self.superHue.is_a?(Numeric) ? true : false
  end
  #-----------------------------------------------------------------------------
  #  Adjustment to stat re-calculation
  #-----------------------------------------------------------------------------
  def calcStats(basestat = nil, boss = false)
    # boost stats in Wild Boss battles
    nature = self.nature
    stats = []
    pvalues = [100, 100, 100, 100, 100]
    nd5 = (nature/5).floor
    nm5 = (nature%5).floor
    if nd5 != nm5
      pvalues[nd5] = 110
      pvalues[nm5] = 90
    end
    level = self.level
    bs = basestat.is_a?(Array) ? basestat : self.baseStats
    for i in 0..5
      base = bs[i]
      if i == PBStats::HP
        stats[i] = (self.calcHP(base, level, @iv[i], @ev[i]) * (boss ? boss[i] : 1)).round
      else
        stats[i] = (self.calcStat(base, level, @iv[i], @ev[i], pvalues[i-1]) * (boss ? boss[i] : 1)).round
      end
    end
    diff = @totalhp - @hp
    @totalhp = stats[0]
    @hp = @totalhp-diff
    @hp = 0 if @hp <= 0
    @hp = @totalhp if @hp > @totalhp
    @attack = stats[1]
    @defense = stats[2]
    @speed = stats[3]
    @spatk = stats[4]
    @spdef = stats[5]
  end
  #-----------------------------------------------------------------------------
  #  sauce
  #-----------------------------------------------------------------------------
  def name
    return _INTL("Bidoof") if hasConst?(PBSpecies, :BIDOOF) && defined?(firstApr?) && firstApr?
    hide = EliteBattle.getData(self.species, PBSpecies, :HIDENAME, (self.form rescue 0)) && !$Trainer.owned[self.species]
    return hide ? _INTL("???") : @name
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
