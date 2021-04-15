#===============================================================================
#  Module core used to map global move animations
#===============================================================================
module EliteBattle
  #-----------------------------------------------------------------------------
  @@physical = {}
  @@special = {}
  @@status = {}
  @@allOpp = {}
  @@nonUsr = {}
  @@multihit = {}
  #-----------------------------------------------------------------------------
  #  configure global animation mapping from external file if applicable
  #-----------------------------------------------------------------------------
  def self.setupGlobalAnimationMap
    # configure metrics data
    return if !File.safeData?("Data/Plugins/animationmap.ebdx")
    map = load_data("Data/Plugins/animationmap.ebdx")
    for key in map.keys
      type = key.upcase.to_sym
      vals = {
        'physicalMove' => @@physical,
        'specialMove' => @@special,
        'statusMove' => @@status,
        'multiHitMove' => @@multihit,
        'allOpposing' => @@allOpp,
        'nonUser' => @@nonUsr
      }
      # go through each parameter
      for v in vals.keys
        next if !map[key]["__pk__"][v]
        vals[v][type] = map[key]["__pk__"][v][0].upcase.to_sym
      end
    end
  end
  #-----------------------------------------------------------------------------
end
