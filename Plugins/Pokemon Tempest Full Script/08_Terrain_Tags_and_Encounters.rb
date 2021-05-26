#===================================
# Terrain Tags and Encounters
#===================================
class PokemonEncounters
  def has_sandy_encounters?
    GameData::EncounterType.each do |enc_type|
      return true if enc_type.type == :sand && has_encounter_type?(enc_type.id)
    end
    return false
  end
  def has_graveyard_encounters?
    GameData::EncounterType.each do |enc_type|
      return true if enc_type.type == :graveyard && has_encounter_type?(enc_type.id)
    end
    return false
  end
  def has_snow_encounters?
    GameData::EncounterType.each do |enc_type|
      return true if enc_type.type == :snow && has_encounter_type?(enc_type.id)
    end
    return false
  end
  def has_high_bridge_encounters?
    GameData::EncounterType.each do |enc_type|
      return true if enc_type.type == :highbridge && has_encounter_type?(enc_type.id)
    end
    return false
  end
  def has_distortion_encounters?
    GameData::EncounterType.each do |enc_type|
      return true if enc_type.type == :distortion && has_encounter_type?(enc_type.id)
    end
    return false
  end
end

GameData::TerrainTag.register({
  :id                     => :Distortion,
  :id_number              => 17,
  :land_wild_encounters   => true,
  :battle_environment     => :Distortion
})

GameData::TerrainTag.register({
  :id                     => :HighBridge,
  :id_number              => 18,
  :land_wild_encounters   => true
})

GameData::TerrainTag.register({
  :id                     => :RockClimb,
  :id_number              => 19,
  :rock_climb             => true
})

GameData::TerrainTag.register({
  :id                     => :Sandy,
  :id_number              => 20,
  :land_wild_encounters   => true,
  :battle_environment     => :Sand
})

GameData::TerrainTag.register({
  :id                     => :Graveyard,
  :id_number              => 21,
  :land_wild_encounters   => true,
  :battle_environment     => :Graveyard
})

GameData::TerrainTag.register({
  :id                     => :Snow,
  :id_number              => 22,
  :land_wild_encounters   => true,
  :battle_environment     => :Ice
})

GameData::EncounterType.register({
  :id             => :Distortion,
  :type           => :distortion,
  :trigger_chance => 5,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :HighBridge,
  :type           => :highbridge,
  :trigger_chance => 5,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :Graveyard,
  :type           => :graveyard,
  :trigger_chance => 5,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :Snow,
  :type           => :snow,
  :trigger_chance => 5,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})

GameData::EncounterType.register({
  :id             => :Sand,
  :type           => :sand,
  :trigger_chance => 5,
  :old_slots      => [20, 20, 10, 10, 10, 10, 5, 5, 4, 4, 1, 1]
})
