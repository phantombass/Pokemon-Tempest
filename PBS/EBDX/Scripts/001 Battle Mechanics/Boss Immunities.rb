#===============================================================================
#  Additional overrides for boss battle mechanic (immunities)
#===============================================================================
class PokeBattle_Battler
  attr_accessor :immunity
  #-----------------------------------------------------------------------------
  # Sleep
  #-----------------------------------------------------------------------------
  alias cansleep_ebdx pbCanSleep? unless self.method_defined?(:cansleep_ebdx)
  def pbCanSleep?(*args)
    rule = EliteBattle.getData(:BOSSBATTLES, PBMetrics, :IMMUNITIES).include?(:SLEEP)
    if self.immunity && rule
      @battle.pbDisplay(_INTL("{1}'s vitality prevents it from falling asleep!", pbThis)) if args[0]
      return false
    end
    return cansleep_ebdx(*args)
  end
  #-----------------------------------------------------------------------------
  # Poison
  #-----------------------------------------------------------------------------
  alias canpoison_ebdx pbCanPoison? unless self.method_defined?(:canpoison_ebdx)
  def pbCanPoison?(*args)
    rule = EliteBattle.getData(:BOSSBATTLES, PBMetrics, :IMMUNITIES).include?(:POISON)
    if self.immunity && rule
      @battle.pbDisplay(_INTL("{1}'s vitality prevents it from getting poisoned!", pbThis)) if args[0]
      return false
    end
    return canpoison_ebdx(*args)
  end
  #-----------------------------------------------------------------------------
  # Burn
  #-----------------------------------------------------------------------------
  alias canburn_ebdx pbCanBurn? unless self.method_defined?(:canburn_ebdx)
  def pbCanBurn?(*args)
    rule = EliteBattle.getData(:BOSSBATTLES, PBMetrics, :IMMUNITIES).include?(:BURN)
    if self.immunity && rule
      @battle.pbDisplay(_INTL("{1}'s vitality prevents it from getting burned!", pbThis)) if args[0]
      return false
    end
    return canburn_ebdx(*args)
  end
  #-----------------------------------------------------------------------------
  # Paralysis
  #-----------------------------------------------------------------------------
  alias canparalyze_ebdx pbCanParalyze? unless self.method_defined?(:canparalyze_ebdx)
  def pbCanParalyze?(*args)
    rule = EliteBattle.getData(:BOSSBATTLES, PBMetrics, :IMMUNITIES).include?(:PARALISYS)
    if self.immunity && rule
      @battle.pbDisplay(_INTL("{1}'s vitality prevents it from getting paralyzed!", pbThis)) if args[0]
      return false
    end
    return canparalyze_ebdx(*args)
  end
  #-----------------------------------------------------------------------------
  # Frozen
  #-----------------------------------------------------------------------------
  alias canfreeze_ebdx pbCanFreeze? unless self.method_defined?(:canfreeze_ebdx)
  def pbCanFreeze?(*args)
    rule = EliteBattle.getData(:BOSSBATTLES, PBMetrics, :IMMUNITIES).include?(:FREEZE)
    if self.immunity && rule
      @battle.pbDisplay(_INTL("{1}'s vitality prevents it from getting frozen!", pbThis)) if args[0]
      return false
    end
    return canfreeze_ebdx(*args)
  end
  #-----------------------------------------------------------------------------
  # Confusion
  #-----------------------------------------------------------------------------
  alias canconfuse_ebdx pbCanConfuse? unless self.method_defined?(:canconfuse_ebdx)
  def pbCanConfuse?(*args)
    rule = EliteBattle.getData(:BOSSBATTLES, PBMetrics, :IMMUNITIES).include?(:CONFUSION)
    if self.immunity && rule
      @battle.pbDisplay(_INTL("{1}'s focus prevents it from getting confused!", pbThis)) if args[0]
      return false
    end
    return canconfuse_ebdx(*args)
  end
  #-----------------------------------------------------------------------------
  # Attraction
  #-----------------------------------------------------------------------------
  alias canconattract_ebdx pbCanAttract? unless self.method_defined?(:canattract_ebdx)
  def pbCanAttract?(*args)
    rule = EliteBattle.getData(:BOSSBATTLES, PBMetrics, :IMMUNITIES).include?(:ATTRACT)
    if self.immunity && rule
      @battle.pbDisplay(_INTL("{1}'s determination prevents it from getting attracted!", pbThis)) if args[0]
      return false
    end
    return canconattract_ebdx(*args)
  end
  #-----------------------------------------------------------------------------
  # Flinching
  #-----------------------------------------------------------------------------
  alias canflinch_ebdx pbFlinch unless self.method_defined?(:canflinch_ebdx)
  def pbFlinch(*args)
    rule = EliteBattle.getData(:BOSSBATTLES, PBMetrics, :IMMUNITIES).include?(:FLINCH)
    return false if (self.immunity && rule) || self.pokemon.dynamax
    return canflinch_ebdx(*args)
  end
  #-----------------------------------------------------------------------------
end
#===============================================================================
#  destiny bond immunity for bosses
#===============================================================================
class PokeBattle_Move_0E7 < PokeBattle_Move
  alias destinybond_ebdx pbEffectGeneral unless self.method_defined?(:destinybond_ebdx)
  def pbEffectGeneral(*args)
    rule = EliteBattle.getData(:BOSSBATTLES, PBMetrics, :IMMUNITIES).include?(:DESTINYBOND)
    if args[1].immunity && rule
      @battle.pbDisplay(_INTL("{1} is unaffected!", args[1].pbThis))
      return true
    end
    return destinybond_ebdx(*args)
  end
end
#===============================================================================
#  leech seed immunity for bosses
#===============================================================================
class PokeBattle_Move_0DC < PokeBattle_Move
  alias leechseed_ebdx pbFailsAgainstTarget? unless self.method_defined?(:leechseed_ebdx)
  def pbFailsAgainstTarget?(*args)
    rule = EliteBattle.getData(:BOSSBATTLES, PBMetrics, :IMMUNITIES).include?(:LEECHSEED)
    if args[1].immunity && rule
      @battle.pbDisplay(_INTL("It doesn't affect {1}...", args[1].pbThis(true)))
      return true
    end
    return leechseed_ebdx(*args)
  end
end
#===============================================================================
#  OHKO immunity
#===============================================================================
class PokeBattle_Move_070 < PokeBattle_Move
  alias ohkomove_ebdx pbFailsAgainstTarget? unless self.method_defined?(:ohkomove_ebdx)
  def pbFailsAgainstTarget?(*args)
    rule = EliteBattle.getData(:BOSSBATTLES, PBMetrics, :IMMUNITIES).include?(:OHKO)
    if args[1].immunity && rule
      @battle.pbDisplay(_INTL("{1} is unaffected!", args[1].pbThis))
      return true
    end
    return ohkomove_ebdx(*args)
  end
end
#===============================================================================
#  Perish Song immunity
#===============================================================================
class PokeBattle_Move_0E5 < PokeBattle_Move
  alias perishsong_ebdx pbFailsAgainstTarget? unless self.method_defined?(:perishsong_ebdx)
  def pbFailsAgainstTarget?(*args)
    rule = EliteBattle.getData(:BOSSBATTLES, PBMetrics, :IMMUNITIES).include?(:PERISHSONG)
    if args[1].immunity && rule
      @battle.pbDisplay(_INTL("{1} is unaffected!", args[1].pbThis))
      return true
    end
    return perishsong_ebdx(*args)
  end
end
