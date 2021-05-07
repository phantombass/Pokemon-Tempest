#==============================================================================
# "v19 Hotfixes" plugin
# This file contains fixes for bugs relating to Debug features or compiling.
# These bug fixes are also in the master branch of the GitHub version of
# Essentials:
# https://github.com/Maruno17/pokemon-essentials
#==============================================================================



#==============================================================================
# Fix for crash when trying to edit a map's weather metadata.
#==============================================================================
module WeatherEffectProperty
  def self.set(_settingname,oldsetting)
    oldsetting = [:None, 100] if !oldsetting
    options = []
    ids = []
    default = 0
    GameData::Weather.each do |w|
      default = ids.length if w.id == oldsetting[0]
      options.push(w.real_name)
      ids.push(w.id)
    end
    cmd = pbMessage(_INTL("Choose a weather effect."), options, -1, nil, default)
    return nil if cmd < 0 || ids[cmd] == :None
    params = ChooseNumberParams.new
    params.setRange(0, 100)
    params.setDefaultValue(oldsetting[1])
    number = pbMessageChooseNumber(_INTL("Set the probability of the weather."), params)
    return [ids[cmd], number]
  end
end

#==============================================================================
# Fix for crash when trying to save tileset terrain tags in the Debug function
# "Edit Terrain Tags".
#==============================================================================
class PokemonTilesetScene
  def pbStartScene
    pbFadeInAndShow(@sprites)
    loop do
      Graphics.update
      Input.update
      if Input.repeat?(Input::UP)
        update_cursor_position(0, -1)
      elsif Input.repeat?(Input::DOWN)
        update_cursor_position(0, 1)
      elsif Input.repeat?(Input::LEFT)
        update_cursor_position(-1, 0)
      elsif Input.repeat?(Input::RIGHT)
        update_cursor_position(1, 0)
      elsif Input.repeat?(Input::JUMPUP)
        update_cursor_position(0, -Graphics.height / TILE_SIZE)
      elsif Input.repeat?(Input::JUMPDOWN)
        update_cursor_position(0, Graphics.height / TILE_SIZE)
      elsif Input.trigger?(Input::ACTION)
        commands = [
           _INTL("Go to bottom"),
           _INTL("Go to top"),
           _INTL("Change tileset"),
           _INTL("Cancel")
        ]
        case pbShowCommands(nil,commands,-1)
        when 0
          @y = @height - TILE_SIZE
          @topy = @y - Graphics.height + TILE_SIZE if @y - @topy >= Graphics.height
          pbUpdateTileset
        when 1
          @y = -TILE_SIZE
          @topy = @y if @y < @topy
          pbUpdateTileset
        when 2
          pbChooseTileset
        end
      elsif Input.trigger?(Input::BACK)
        if pbConfirmMessage(_INTL("Save changes?"))
          save_data(@tilesets_data, "Data/Tilesets.rxdata")
          $data_tilesets = @tilesets_data
          if $game_map && $MapFactory
            $MapFactory.setup($game_map.map_id)
            $game_player.center($game_player.x, $game_player.y)
            if $scene.is_a?(Scene_Map)
              $scene.disposeSpritesets
              $scene.createSpritesets
            end
          end
          pbMessage(_INTL("To ensure that the changes remain, close and reopen RPG Maker XP."))
        end
        break if pbConfirmMessage(_INTL("Exit from the editor?"))
      elsif Input.trigger?(Input::USE)
        selected = pbGetSelected(@x, @y)
        params = ChooseNumberParams.new
        params.setRange(0, 99)
        params.setDefaultValue(@tileset.terrain_tags[selected])
        pbSetSelected(selected,pbMessageChooseNumber(_INTL("Set the terrain tag."), params))
        pbUpdateTileset
      end
    end
    pbFadeOutAndHide(@sprites)
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
    @tilehelper.dispose
  end
end

#==============================================================================
# Fix for crash when trying to use the Debug function "Fix Invalid Tiles".
#==============================================================================
def pbDebugFixInvalidTiles
  num_errors = 0
  num_error_maps = 0
  tilesets = $data_tilesets
  mapData = Compiler::MapData.new
  t = Time.now.to_i
  Graphics.update
  for id in mapData.mapinfos.keys.sort
    if Time.now.to_i - t >= 5
      Graphics.update
      t = Time.now.to_i
    end
    changed = false
    map = mapData.getMap(id)
    next if !map || !mapData.mapinfos[id]
    pbSetWindowText(_INTL("Processing map {1} ({2})", id, mapData.mapinfos[id].name))
    passages = mapData.getTilesetPassages(map, id)
    # Check all tiles in map for non-existent tiles
    for x in 0...map.data.xsize
      for y in 0...map.data.ysize
        for i in 0...map.data.zsize
          tile_id = map.data[x, y, i]
          next if pbCheckTileValidity(tile_id, map, tilesets, passages)
          map.data[x, y, i] = 0
          changed = true
          num_errors += 1
        end
      end
    end
    # Check all events in map for page graphics using a non-existent tile
    for key in map.events.keys
      event = map.events[key]
      for page in event.pages
        next if page.graphic.tile_id <= 0
        next if pbCheckTileValidity(page.graphic.tile_id, map, tilesets, passages)
        page.graphic.tile_id = 0
        changed = true
        num_errors += 1
      end
    end
    next if !changed
    # Map was changed; save it
    num_error_maps += 1
    mapData.saveMap(id)
  end
  if num_error_maps == 0
    pbMessage(_INTL("No invalid tiles were found."))
  else
    pbMessage(_INTL("{1} error(s) were found across {2} map(s) and fixed.", num_errors, num_error_maps))
    pbMessage(_INTL("Close RPG Maker XP to ensure the changes are applied properly."))
  end
end

#==============================================================================
# Fix for the "Give Demo Party" Debug feature adding Pokémon without clearing
# the party first, and potentially resulting in more than the maximum number of
# Pokémon allowed in the party.
#==============================================================================
DebugMenuCommands.register("demoparty", {
  "parent"      => "pokemonmenu",
  "name"        => _INTL("Give Demo Party"),
  "description" => _INTL("Give yourself 6 preset Pokémon. They overwrite the current party."),
  "effect"      => proc {
    party = []
    species = [:PIKACHU, :PIDGEOTTO, :KADABRA, :GYARADOS, :DIGLETT, :CHANSEY]
    for id in species
      party.push(id) if GameData::Species.exists?(id)
    end
    $Trainer.party.clear
    # Generate Pokémon of each species at level 20
    party.each do |species|
      pkmn = Pokemon.new(species, 20)
      $Trainer.party.push(pkmn)
      $Trainer.pokedex.register(pkmn)
      $Trainer.pokedex.set_owned(species)
      case species
      when :PIDGEOTTO
        pkmn.learn_move(:FLY)
      when :KADABRA
        pkmn.learn_move(:FLASH)
        pkmn.learn_move(:TELEPORT)
      when :GYARADOS
        pkmn.learn_move(:SURF)
        pkmn.learn_move(:DIVE)
        pkmn.learn_move(:WATERFALL)
      when :DIGLETT
        pkmn.learn_move(:DIG)
        pkmn.learn_move(:CUT)
        pkmn.learn_move(:HEADBUTT)
        pkmn.learn_move(:ROCKSMASH)
      when :CHANSEY
        pkmn.learn_move(:SOFTBOILED)
        pkmn.learn_move(:STRENGTH)
        pkmn.learn_move(:SWEETSCENT)
      end
      pkmn.record_first_moves
    end
    pbMessage(_INTL("Filled party with demo Pokémon."))
  }
})

#==============================================================================
# Fix for the Pokémon icon mover/renamer not moving shiny Pokémon icons into
# the correct folder.
#==============================================================================
module Compiler
  module_function

  def convert_pokemon_filename(full_name, default_prefix = "")
    name = full_name
    extension = nil
    if full_name[/^(.+)\.([^\.]+)$/]   # Of the format something.abc
      name = $~[1]
      extension = $~[2]
    end
    prefix = default_prefix
    form = female = shadow = crack = ""
    if default_prefix == ""
      if name[/s/] && !name[/shadow/]
        prefix = (name[/b/]) ? "Back shiny/" : "Front shiny/"
      else
        prefix = (name[/b/]) ? "Back/" : "Front/"
      end
    elsif default_prefix == "Icons/"
      prefix = "Icons shiny/" if name[/s/] && !name[/shadow/]
    end
    if name[/000/]
      species = "000"
    else
      species_number = name[0, 3].to_i
      species_data = GameData::Species.try_get(species_number)
      raise _INTL("Species {1} is not defined (trying to rename Pokémon graphic {2}).", species_number, full_name) if !species_data
      species = species_data.id.to_s
      form = "_" + $~[1].to_s if name[/_(\d+)/]
      female = "_female" if name[/f/]
      shadow = "_shadow" if name[/_shadow/]
      if name[/egg/]
        prefix = "Eggs/"
        crack = "_icon" if default_prefix == "Icons/"
        crack = "_cracks" if name[/eggCracks/]
      end
    end
    return prefix + species + form + female + shadow + crack + ((extension) ? "." + extension : ".png")
  end
end

#==============================================================================
# Fixed alternate forms not inheriting certain properties from the base form.
#==============================================================================
module Compiler
  module_function

  def compile_pokemon_forms
    species_names           = []
    species_form_names      = []
    species_categories      = []
    species_pokedex_entries = []
    used_forms = {}
    # Get maximum species ID number
    form_number = 0
    GameData::Species.each do |species|
      form_number = species.id_number if form_number < species.id_number
    end
    # Read from PBS file
    File.open("PBS/pokemonforms.txt", "rb") { |f|
      FileLineData.file = "PBS/pokemonforms.txt"   # For error reporting
      # Read a whole section's lines at once, then run through this code.
      # contents is a hash containing all the XXX=YYY lines in that section, where
      # the keys are the XXX and the values are the YYY (as unprocessed strings).
      schema = GameData::Species.schema(true)
      pbEachFileSection2(f) { |contents, section_name|
        FileLineData.setSection(section_name, "header", nil)   # For error reporting
        # Split section_name into a species number and form number
        split_section_name = section_name.split(/[-,\s]/)
        if split_section_name.length != 2
          raise _INTL("Section name {1} is invalid (PBS/pokemonforms.txt). Expected syntax like [XXX,Y] (XXX=internal name, Y=form number).", sectionName)
        end
        species_symbol = csvEnumField!(split_section_name[0], :Species, nil, nil)
        form           = csvPosInt!(split_section_name[1])
        # Raise an error if a species is undefined, the form number is invalid or
        # a species/form combo is used twice
        if !GameData::Species.exists?(species_symbol)
          raise _INTL("Species ID '{1}' is not defined in pokemon.txt.\r\n{2}", species_symbol, FileLineData.linereport)
        elsif form == 0
          raise _INTL("A form cannot be defined with a form number of 0.\r\n{1}", FileLineData.linereport)
        elsif used_forms[species_symbol] && used_forms[species_symbol].include?(form)
          raise _INTL("Form {1} for species ID {2} is defined twice.\r\n{3}", form, species_symbol, FileLineData.linereport)
        end
        used_forms[species_symbol] = [] if !used_forms[species_symbol]
        used_forms[species_symbol].push(form)
        form_number += 1
        base_data = GameData::Species.get(species_symbol)
        # Go through schema hash of compilable data and compile this section
        for key in schema.keys
          # Skip empty properties (none are required)
          if nil_or_empty?(contents[key])
            contents[key] = nil
            next
          end
          FileLineData.setSection(section_name, key, contents[key])   # For error reporting
          # Compile value for key
          value = pbGetCsvRecord(contents[key], key, schema[key])
          value = nil if value.is_a?(Array) && value.length == 0
          contents[key] = value
          # Sanitise data
          case key
          when "BaseStats", "EffortPoints"
            value_hash = {}
            GameData::Stat.each_main do |s|
              value_hash[s.id] = value[s.pbs_order] if s.pbs_order >= 0
            end
            contents[key] = value_hash
          when "Height", "Weight"
            # Convert height/weight to 1 decimal place and multiply by 10
            value = (value * 10).round
            if value <= 0
              raise _INTL("Value for '{1}' can't be less than or close to 0 (section {2}, PBS/pokemonforms.txt)", key, section_name)
            end
            contents[key] = value
          when "Moves"
            move_array = []
            for i in 0...value.length / 2
              move_array.push([value[i * 2], value[i * 2 + 1], i])
            end
            move_array.sort! { |a, b| (a[0] == b[0]) ? a[2] <=> b[2] : a[0] <=>b [0] }
            move_array.each { |arr| arr.pop }
            contents[key] = move_array
          when "TutorMoves", "EggMoves", "Abilities", "HiddenAbility", "Compatibility"
            contents[key] = [contents[key]] if !contents[key].is_a?(Array)
            contents[key].compact!
          when "Evolutions"
            evo_array = []
            for i in 0...value.length / 3
              param_type = GameData::Evolution.get(value[i * 3 + 1]).parameter
              param = value[i * 3 + 2]
              if param_type.nil?
                param = nil
              elsif param_type == Integer
                param = csvPosInt!(param)
              else
                param = csvEnumField!(param, param_type, "Evolutions", section_name)
              end
              evo_array.push([value[i * 3], value[i * 3 + 1], param, false])
            end
            contents[key] = evo_array
          end
        end
        # Construct species hash
        form_symbol = sprintf("%s_%d", species_symbol.to_s, form).to_sym
        moves = contents["Moves"]
        if !moves
          moves = []
          base_data.moves.each { |m| moves.push(m.clone) }
        end
        evolutions = contents["Evolutions"]
        if !evolutions
          evolutions = []
          base_data.evolutions.each { |e| evolutions.push(e.clone) }
        end
        species_hash = {
          :id                    => form_symbol,
          :id_number             => form_number,
          :species               => species_symbol,
          :form                  => form,
          :name                  => base_data.real_name,
          :form_name             => contents["FormName"],
          :category              => contents["Kind"] || base_data.real_category,
          :pokedex_entry         => contents["Pokedex"] || base_data.real_pokedex_entry,
          :pokedex_form          => contents["PokedexForm"],
          :type1                 => contents["Type1"] || base_data.type1,
          :type2                 => contents["Type2"] || base_data.type2,
          :base_stats            => contents["BaseStats"] || base_data.base_stats,
          :evs                   => contents["EffortPoints"] || base_data.evs,
          :base_exp              => contents["BaseEXP"] || base_data.base_exp,
          :growth_rate           => base_data.growth_rate,
          :gender_ratio          => base_data.gender_ratio,
          :catch_rate            => contents["Rareness"] || base_data.catch_rate,
          :happiness             => contents["Happiness"] || base_data.happiness,
          :moves                 => moves,
          :tutor_moves           => contents["TutorMoves"] || base_data.tutor_moves.clone,
          :egg_moves             => contents["EggMoves"] || base_data.egg_moves.clone,
          :abilities             => contents["Abilities"] || base_data.abilities.clone,
          :hidden_abilities      => contents["HiddenAbility"] || base_data.hidden_abilities.clone,
          :wild_item_common      => contents["WildItemCommon"] || base_data.wild_item_common,
          :wild_item_uncommon    => contents["WildItemUncommon"] || base_data.wild_item_uncommon,
          :wild_item_rare        => contents["WildItemRare"] || base_data.wild_item_rare,
          :egg_groups            => contents["Compatibility"] || base_data.egg_groups.clone,
          :hatch_steps           => contents["StepsToHatch"] || base_data.hatch_steps,
          :incense               => base_data.incense,
          :evolutions            => evolutions,
          :height                => contents["Height"] || base_data.height,
          :weight                => contents["Weight"] || base_data.weight,
          :color                 => contents["Color"] || base_data.color,
          :shape                 => (contents["Shape"]) ? GameData::BodyShape.get(contents["Shape"]).id : base_data.shape,
          :habitat               => contents["Habitat"] || base_data.habitat,
          :generation            => contents["Generation"] || base_data.generation,
          :mega_stone            => contents["MegaStone"],
          :mega_move             => contents["MegaMove"],
          :unmega_form           => contents["UnmegaForm"],
          :mega_message          => contents["MegaMessage"],
          :back_sprite_x         => contents["BattlerPlayerX"] || base_data.back_sprite_x,
          :back_sprite_y         => contents["BattlerPlayerY"] || base_data.back_sprite_y,
          :front_sprite_x        => contents["BattlerEnemyX"] || base_data.front_sprite_x,
          :front_sprite_y        => contents["BattlerEnemyY"] || base_data.front_sprite_y,
          :front_sprite_altitude => contents["BattlerAltitude"] || base_data.front_sprite_altitude,
          :shadow_x              => contents["BattlerShadowX"] || base_data.shadow_x,
          :shadow_size           => contents["BattlerShadowSize"] || base_data.shadow_size
        }
        # If form is single-typed, ensure it remains so if base species is dual-typed
        species_hash[:type2] = contents["Type1"] if contents["Type1"] && !contents["Type2"]
        # If form has any wild items, ensure none are inherited from base species
        if contents["WildItemCommon"] || contents["WildItemUncommon"] || contents["WildItemRare"]
          species_hash[:wild_item_common]   = contents["WildItemCommon"]
          species_hash[:wild_item_uncommon] = contents["WildItemUncommon"]
          species_hash[:wild_item_rare]     = contents["WildItemRare"]
        end
        # Add form's data to records
        GameData::Species.register(species_hash)
        species_names[form_number]           = species_hash[:name]
        species_form_names[form_number]      = species_hash[:form_name]
        species_categories[form_number]      = species_hash[:category]
        species_pokedex_entries[form_number] = species_hash[:pokedex_entry]
      }
    }
    # Add prevolution "evolution" entry for all evolved forms that define their
    # own evolution methods (and thus won't have a prevolution listed already)
    all_evos = {}
    GameData::Species.each do |species|   # Build a hash of prevolutions for each species
      next if all_evos[species.species]
      species.evolutions.each do |evo|
        all_evos[evo[0]] = [species.species, evo[1], evo[2], true] if !evo[3] && !all_evos[evo[0]]
      end
    end
    GameData::Species.each do |species|   # Distribute prevolutions
      next if species.form == 0   # Looking at alternate forms only
      next if species.evolutions.any? { |evo| evo[3] }   # Already has prevo listed
      species.evolutions.push(all_evos[species.species].clone) if all_evos[species.species]
    end
    # Save all data
    GameData::Species.save
    MessageTypes.addMessages(MessageTypes::Species, species_names)
    MessageTypes.addMessages(MessageTypes::FormNames, species_form_names)
    MessageTypes.addMessages(MessageTypes::Kinds, species_categories)
    MessageTypes.addMessages(MessageTypes::Entries, species_pokedex_entries)
    Graphics.update
  end
end
