#==============================================================================
# "v19 Hotfixes" plugin
# This file contains fixes for miscellaneous bugs.
# These bug fixes are also in the master branch of the GitHub version of
# Essentials:
# https://github.com/Maruno17/pokemon-essentials
#==============================================================================

Essentials::ERROR_TEXT += "[v19 Hotfixes 1.0.6]\r\n"

#==============================================================================
# Fix for dynamic shadows not disappearing if you transfer elsewhere while you
# have dynamic shadows on you.
#==============================================================================
class Scene_Map
  def transfer_player(cancelVehicles=true)
    $game_temp.player_transferring = false
    pbCancelVehicles($game_temp.player_new_map_id) if cancelVehicles
    autofade($game_temp.player_new_map_id)
    pbBridgeOff
    @spritesetGlobal.playersprite.clearShadows
    if $game_map.map_id!=$game_temp.player_new_map_id
      $MapFactory.setup($game_temp.player_new_map_id)
    end
    $game_player.moveto($game_temp.player_new_x, $game_temp.player_new_y)
    case $game_temp.player_new_direction
    when 2 then $game_player.turn_down
    when 4 then $game_player.turn_left
    when 6 then $game_player.turn_right
    when 8 then $game_player.turn_up
    end
    $game_player.straighten
    $game_map.update
    disposeSpritesets
    RPG::Cache.clear
    createSpritesets
    if $game_temp.transition_processing
      $game_temp.transition_processing = false
      Graphics.transition(20)
    end
    $game_map.autoplay
    Graphics.frame_reset
    Input.update
  end
end

class Sprite_Character < RPG::Sprite
  def clearShadows
    @ombrelist.each { |s| s.dispose if s }
    @ombrelist.clear
  end
end

#==============================================================================
# Fix for events not being able to notice the player at a distance if the event
# is facing left.
#==============================================================================
def pbEventCanReachPlayer?(event, player, distance)
  return false if !pbEventFacesPlayer?(event, player, distance)
  delta_x = (event.direction == 6) ? 1 : (event.direction == 4) ? -1 : 0
  delta_y = (event.direction == 2) ? 1 : (event.direction == 8) ? -1 : 0
  case event.direction
  when 2   # Down
    real_distance = player.y - event.y - 1
  when 4   # Left
    real_distance = event.x - player.x - 1
  when 6   # Right
    real_distance = player.x - event.x - event.width
  when 8   # Up
    real_distance = event.y - event.height - player.y
  end
  if real_distance > 0
    real_distance.times do |i|
      return false if !event.can_move_from_coordinate?(event.x + i * delta_x, event.y + i * delta_y, event.direction)
    end
  end
  return true
end

#==============================================================================
# Fix for crash after evolving a Pokémon.
#==============================================================================
class Pokemon
  def action_after_evolution(new_species)
    species_data.get_evolutions(true).each do |evo|   # [new_species, method, parameter]
      break if GameData::Evolution.get(evo[1]).call_after_evolution(self, evo[0], evo[2], new_species)
    end
  end
end

#==============================================================================
# Fix for crash when opening the Pokédex to show a newly captured species.
#==============================================================================
class PokemonPokedexInfo_Scene
  def pbStartSceneBrief(species)  # For standalone access, shows first page only
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    dexnum = 0
    dexnumshift = false
    if $Trainer.pokedex.unlocked?(-1)   # National Dex is unlocked
      species_data = GameData::Species.try_get(species)
      dexnum = species_data.id_number if species_data
      dexnumshift = true if Settings::DEXES_WITH_OFFSETS.include?(-1)
    else
      dexnum = 0
      for i in 0...$Trainer.pokedex.dexes_count - 1   # Regional Dexes
        next if !$Trainer.pokedex.unlocked?(i)
        num = pbGetRegionalNumber(i,species)
        next if num <= 0
        dexnum = num
        dexnumshift = true if Settings::DEXES_WITH_OFFSETS.include?(i)
        break
      end
    end
    @dexlist = [[species,"",0,0,dexnum,dexnumshift]]
    @index   = 0
    @page = 1
    @brief = true
    @typebitmap = AnimatedBitmap.new(_INTL("Graphics/Pictures/Pokedex/icon_types"))
    @sprites = {}
    @sprites["background"] = IconSprite.new(0,0,@viewport)
    @sprites["infosprite"] = PokemonSprite.new(@viewport)
    @sprites["infosprite"].setOffset(PictureOrigin::Center)
    @sprites["infosprite"].x = 104
    @sprites["infosprite"].y = 136
    @sprites["overlay"] = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    pbUpdateDummyPokemon
    drawPage(@page)
    pbFadeInAndShow(@sprites) { pbUpdate }
  end
end

#==============================================================================
# Fixed crash when checking the length of an ogg file.
#==============================================================================
def getOggPage(file)
  fgetdw = proc { |file|
    (file.eof? ? 0 : (file.read(4).unpack("V")[0] || 0))
  }
  dw = fgetdw.call(file)
  return nil if dw != 0x5367674F
  header = file.read(22)
  bodysize = 0
  hdrbodysize = (file.read(1)[0].ord rescue 0)
  hdrbodysize.times do
    bodysize += (file.read(1)[0].ord rescue 0)
  end
  ret = [header, file.pos, bodysize, file.pos + bodysize]
  return ret
end

# internal function
def oggfiletime(file)
  fgetdw = proc { |file|
    (file.eof? ? 0 : (file.read(4).unpack("V")[0] || 0))
  }
  fgetw = proc { |file|
    (file.eof? ? 0 : (file.read(2).unpack("v")[0] || 0))
  }
  pages = []
  page = nil
  loop do
    page = getOggPage(file)
    break if !page
    pages.push(page)
    file.pos = page[3]
  end
  return -1 if pages.length == 0
  curserial = nil
  i = -1
  pcmlengths = []
  rates = []
  for page in pages
    header = page[0]
    serial = header[10, 4].unpack("V")
    frame = header[2, 8].unpack("C*")
    frameno = frame[7]
    frameno = (frameno << 8) | frame[6]
    frameno = (frameno << 8) | frame[5]
    frameno = (frameno << 8) | frame[4]
    frameno = (frameno << 8) | frame[3]
    frameno = (frameno << 8) | frame[2]
    frameno = (frameno << 8) | frame[1]
    frameno = (frameno << 8) | frame[0]
    if serial != curserial
      curserial = serial
      file.pos = page[1]
      packtype = (file.read(1)[0].ord rescue 0)
      string = file.read(6)
      return -1 if string != "vorbis"
      return -1 if packtype != 1
      i += 1
      version = fgetdw.call(file)
      return -1 if version != 0
      rates[i] = fgetdw.call(file)
    end
    pcmlengths[i] = frameno
  end
  ret = 0.0
  for i in 0...pcmlengths.length
    ret += pcmlengths[i].to_f / rates[i].to_f
  end
  return ret * 256.0
end

#==============================================================================
# Fixed inaccurate positioning of message in Hall of Fame.
#==============================================================================
class HallOfFame_Scene
  def writeWelcome
    overlay=@sprites["overlay"].bitmap
    overlay.clear
    pbDrawTextPositions(overlay,[[_INTL("Welcome to the Hall of Fame!"),
       Graphics.width/2,Graphics.height-80,2,BASECOLOR,SHADOWCOLOR]])
  end
end

#==============================================================================
# Fixed changing the Music Volume only applying to the currently playing BGM,
# and not applying to any later BGM played unless the Music Volume is changed
# again.
#==============================================================================
class PokemonOption_Scene
  def pbAddOnOptions(options)
    options.each_with_index do |option, i|
	  next if option.name != _INTL("Music Volume")
	  options[i] = SliderOption.new(_INTL("Music Volume"),0,100,5,
         proc { $PokemonSystem.bgmvolume },
         proc { |value|
           if $PokemonSystem.bgmvolume!=value
             $PokemonSystem.bgmvolume = value
             if $game_system.playing_bgm!=nil #&& !inloadscreen
               playingBGM = $game_system.getPlayingBGM
               $game_system.bgm_pause
               $game_system.bgm_resume(playingBGM)
             end
           end
         })
	  break
	end
    return options
  end
end

#==============================================================================
# Fixed rounding error in positioning of overworld weather tile sprites.
#==============================================================================
module RPG
  class Weather
    def update_tile_position(sprite, index)
      return if !sprite || !sprite.bitmap || !sprite.visible
      weather_type = @type
      if @fading && @fade_time >= [FADE_OLD_TONE_END - @time_shift, 0].max
        weather_type = @target_type
      end
      sprite.x = (@ox + @tile_x + (index % @tiles_wide) * sprite.bitmap.width).round
      sprite.y = (@oy + @tile_y + (index / @tiles_wide) * sprite.bitmap.height).round
      sprite.x += @tiles_wide * sprite.bitmap.width if sprite.x - @ox < -sprite.bitmap.width
      sprite.y -= @tiles_tall * sprite.bitmap.height if sprite.y - @oy > Graphics.height
      sprite.visible = true
      if @fading && @type != @target_type
        if @fade_time >= FADE_OLD_TILES_START && @fade_time < FADE_OLD_TILES_END
          if @time_shift == 0   # There were old tiles to fade out
            fraction = (@fade_time - [FADE_OLD_TILES_START - @time_shift, 0].max) / (FADE_OLD_TILES_END - FADE_OLD_TILES_START)
            sprite.opacity = 255 * (1 - fraction)
          end
        elsif @fade_time >= [FADE_NEW_TILES_START - @time_shift, 0].max &&
              @fade_time < [FADE_NEW_TILES_END - @time_shift, 0].max
          fraction = (@fade_time - [FADE_NEW_TILES_START - @time_shift, 0].max) / (FADE_NEW_TILES_END - FADE_NEW_TILES_START)
          sprite.opacity = 255 * fraction
        else
          sprite.opacity = 0
        end
      else
        sprite.opacity = (@max > 0) ? 255 : 0
      end
    end
  end
end

#==============================================================================
# Fixed being able to give the player a foreign Pokémon with a blank name.
#==============================================================================
def pbAddForeignPokemon(pkmn, level = 1, owner_name = nil, nickname = nil, owner_gender = 0, see_form = true)
  return false if !pkmn || $Trainer.party_full?
  pkmn = Pokemon.new(pkmn, level) if !pkmn.is_a?(Pokemon)
  # Set original trainer to a foreign one
  pkmn.owner = Pokemon::Owner.new_foreign(owner_name || "", owner_gender)
  # Set nickname
  pkmn.name = nickname[0, Pokemon::MAX_NAME_SIZE] if !nil_or_empty?(nickname)
  # Recalculate stats
  pkmn.calc_stats
  if owner_name
    pbMessage(_INTL("\\me[Pkmn get]{1} received a Pokémon from {2}.\1", $Trainer.name, owner_name))
  else
    pbMessage(_INTL("\\me[Pkmn get]{1} received a Pokémon.\1", $Trainer.name))
  end
  pbStorePokemon(pkmn)
  $Trainer.pokedex.register(pkmn) if see_form
  $Trainer.pokedex.set_owned(pkmn.species)
  return true
end

#==============================================================================
# Fixed changing a Pokémon's form with an item not updating the screen or doing
# certain other things (e.g. removing a Pokémon that was fused with another).
#==============================================================================
class Pokemon
  def setForm(value)
    oldForm = @form
    @form = value
    @ability = nil
    yield if block_given?
    MultipleForms.call("onSetForm", self, value, oldForm)
    calc_stats
    $Trainer.pokedex.register(self)
  end
end

#==============================================================================
# Fixed defs pbChooseItem, pbChooseApricorn and pbChooseFossil storing nil into
# a Game Variable (which gets treated as 0); they now store :NONE.
#==============================================================================
def pbChooseItem(var = 0, *args)
  ret = nil
  pbFadeOutIn {
    scene = PokemonBag_Scene.new
    screen = PokemonBagScreen.new(scene,$PokemonBag)
    ret = screen.pbChooseItemScreen
  }
  $game_variables[var] = ret || :NONE if var > 0
  return ret
end

def pbChooseApricorn(var = 0)
  ret = nil
  pbFadeOutIn {
    scene = PokemonBag_Scene.new
    screen = PokemonBagScreen.new(scene,$PokemonBag)
    ret = screen.pbChooseItemScreen(Proc.new { |item| GameData::Item.get(item).is_apricorn? })
  }
  $game_variables[var] = ret || :NONE if var > 0
  return ret
end

def pbChooseFossil(var = 0)
  ret = nil
  pbFadeOutIn {
    scene = PokemonBag_Scene.new
    screen = PokemonBagScreen.new(scene,$PokemonBag)
    ret = screen.pbChooseItemScreen(Proc.new { |item| GameData::Item.get(item).is_fossil? })
  }
  $game_variables[var] = ret || :NONE if var > 0
  return ret
end

#==============================================================================
# Fixed phone contact details being registered incorrectly (causing a crash
# when calling them), fixed being unable to call non-trainer contacts.
#==============================================================================
def pbPhoneRegisterBattle(message,event,trainertype,trainername,maxbattles)
  return if !$Trainer.has_pokegear           # Can't register without a Pokégear
  return false if !GameData::TrainerType.exists?(trainertype)
  trainertype = GameData::TrainerType.get(trainertype).id
  contact = pbFindPhoneTrainer(trainertype,trainername)
  return if contact && contact[0]              # Existing contact and is visible
  message = _INTL("Let me register you.") if !message
  return if !pbConfirmMessage(message)
  displayname = _INTL("{1} {2}", GameData::TrainerType.get(trainertype).name,
     pbGetMessageFromHash(MessageTypes::TrainerNames,trainername))
  if contact                          # Previously registered, just make visible
    contact[0] = true
  else                                                         # Add new contact
    pbPhoneRegister(event,trainertype,trainername)
    pbPhoneIncrement(trainertype,trainername,maxbattles)
  end
  pbMessage(_INTL("\\me[Register phone]Registered {1} in the Pokégear.",displayname))
end

def pbFindPhoneTrainer(tr_type, tr_name)        # Ignores whether visible or not
  return nil if !$PokemonGlobal.phoneNumbers
  for num in $PokemonGlobal.phoneNumbers
    return num if num[1] == tr_type && num[2] == tr_name   # If a match
  end
  return nil
end

#==============================================================================
# Fixed Event Touch not working.
#==============================================================================
class Game_Character
  def move_generic(dir, turn_enabled = true)
    turn_generic(dir) if turn_enabled
    if can_move_in_direction?(dir)
      turn_generic(dir)
      @x += (dir == 4) ? -1 : (dir == 6) ? 1 : 0
      @y += (dir == 8) ? -1 : (dir == 2) ? 1 : 0
      increase_steps
    else
      check_event_trigger_touch(dir)
    end
  end
end

class Game_Event < Game_Character
  def check_event_trigger_touch(dir)
    return if $game_system.map_interpreter.running?
    return if @trigger != 2   # Event touch
    case dir
    when 2
      return if $game_player.y != @y + 1
    when 4
      return if $game_player.x != @x - 1
    when 6
      return if $game_player.x != @x + @width
    when 8
      return if $game_player.y != @y - @height
    end
    return if !in_line_with_coordinate?($game_player.x, $game_player.y)
    return if jumping? || over_trigger?
    start
  end
end

class Game_Player < Game_Character
  def move_generic(dir, turn_enabled = true)
    turn_generic(dir, true) if turn_enabled
    if !$PokemonTemp.encounterTriggered
      if can_move_in_direction?(dir)
        x_offset = (dir == 4) ? -1 : (dir == 6) ? 1 : 0
        y_offset = (dir == 8) ? -1 : (dir == 2) ? 1 : 0
        return if pbLedge(x_offset, y_offset)
        return if pbEndSurf(x_offset, y_offset)
        turn_generic(dir, true)
        if !$PokemonTemp.encounterTriggered
          @x += x_offset
          @y += y_offset
          $PokemonTemp.dependentEvents.pbMoveDependentEvents
          increase_steps
        end
      elsif !check_event_trigger_touch(dir)
        bump_into_object
      end
    end
    $PokemonTemp.encounterTriggered = false
  end

  def check_event_trigger_touch(dir)
    result = false
    return result if $game_system.map_interpreter.running?
    # All event loops
    x_offset = (dir == 4) ? -1 : (dir == 6) ? 1 : 0
    y_offset = (dir == 8) ? -1 : (dir == 2) ? 1 : 0
    for event in $game_map.events.values
      next if ![1, 2].include?(event.trigger)   # Player touch, event touch
      # If event coordinates and triggers are consistent
      next if !event.at_coordinate?(@x + x_offset, @y + y_offset)
      if event.name[/trainer\((\d+)\)/i]
        distance = $~[1].to_i
        next if !pbEventCanReachPlayer?(event,self,distance)
      elsif event.name[/counter\((\d+)\)/i]
        distance = $~[1].to_i
        next if !pbEventFacesPlayer?(event,self,distance)
      end
      # If starting determinant is front event (other than jumping)
      next if event.jumping? || event.over_trigger?
      event.start
      result = true
    end
    return result
  end
end

#==============================================================================
# Fixed encounter sets being duplicated.
#==============================================================================
module GameData
  class Encounter
    def self.register(hash)
      self::DATA[hash[:id]] = self.new(hash)
    end
  end
end

#==============================================================================
# Fixed certain species not learning moves upon changing form like they should.
#==============================================================================
MultipleForms.register(:ROTOM,{
  "onSetForm" => proc { |pkmn, form, oldForm|
    form_moves = [
       :OVERHEAT,    # Heat, Microwave
       :HYDROPUMP,   # Wash, Washing Machine
       :BLIZZARD,    # Frost, Refrigerator
       :AIRSLASH,    # Fan
       :LEAFSTORM    # Mow, Lawnmower
    ]
    move_index = -1
    pkmn.moves.each_with_index do |move, i|
      next if !form_moves.any? { |m| m == move.id }
      move_index = i
      break
    end
    if form == 0
      # Turned back into the base form; forget form-specific moves
      if move_index >= 0
        move_name = pkmn.moves[move_index].name
        pkmn.forget_move_at_index(move_index)
        pbMessage(_INTL("{1} forgot {2}...", pkmn.name, move_name))
        pkmn.learn_move(:THUNDERSHOCK) if pkmn.numMoves == 0
      end
    else
      # Turned into an alternate form; try learning that form's unique move
      new_move_id = form_moves[form - 1]
      if move_index >= 0
        # Knows another form's unique move; replace it
        old_move_name = pkmn.moves[move_index].name
        if GameData::Move.exists?(new_move_id)
          pkmn.moves[move_index].id = new_move_id
          new_move_name = pkmn.moves[move_index].name
          pbMessage(_INTL("1,\\wt[16] 2, and\\wt[16]...\\wt[16] ...\\wt[16] ... Ta-da!\\se[Battle ball drop]\1"))
          pbMessage(_INTL("{1} forgot how to use {2}.\\nAnd...\1", pkmn.name, old_move_name))
          pbMessage(_INTL("\\se[]{1} learned {2}!\\se[Pkmn move learnt]", pkmn.name, new_move_name))
        else
          pkmn.forget_move_at_index(move_index)
          pbMessage(_INTL("{1} forgot {2}...", pkmn.name, old_move_name))
          pkmn.learn_move(:THUNDERSHOCK) if pkmn.numMoves == 0
        end
      else
        # Just try to learn this form's unique move
        pbLearnMove(pkmn, new_move_id, true)
      end
    end
  }
})

MultipleForms.register(:KYUREM,{
  "getFormOnEnteringBattle" => proc { |pkmn,wild|
    next pkmn.form+2 if pkmn.form==1 || pkmn.form==2
  },
  "getFormOnLeavingBattle" => proc { |pkmn,battle,usedInBattle,endBattle|
    next pkmn.form-2 if pkmn.form>=3   # Fused forms stop glowing
  },
  "onSetForm" => proc { |pkmn, form, oldForm|
    case form
    when 0   # Normal
      pkmn.moves.each do |move|
        if [:ICEBURN, :FREEZESHOCK].include?(move.id)
          move.id = :GLACIATE if GameData::Move.exists?(:GLACIATE)
        end
        if [:FUSIONFLARE, :FUSIONBOLT].include?(move.id)
          move.id = :SCARYFACE if GameData::Move.exists?(:SCARYFACE)
        end
      end
    when 1   # White
      pkmn.moves.each do |move|
        move.id = :ICEBURN if move.id == :GLACIATE && GameData::Move.exists?(:ICEBURN)
        move.id = :FUSIONFLARE if move.id == :SCARYFACE && GameData::Move.exists?(:FUSIONFLARE)
      end
    when 2   # Black
      pkmn.moves.each do |move|
        move.id = :FREEZESHOCK if move.id == :GLACIATE && GameData::Move.exists?(:FREEZESHOCK)
        move.id = :FUSIONBOLT if move.id == :SCARYFACE && GameData::Move.exists?(:FUSIONBOLT)
      end
    end
  }
})

MultipleForms.register(:NECROZMA,{
  "getFormOnLeavingBattle" => proc { |pkmn,battle,usedInBattle,endBattle|
    # Fused forms are 1 and 2, Ultra form is 3 or 4 depending on which fusion
    next pkmn.form-2 if pkmn.form>=3 && (pkmn.fainted? || endBattle)
  },
  "onSetForm" => proc { |pkmn, form, oldForm|
    next if form > 2 || oldForm > 2   # Ultra form changes don't affect moveset
    form_moves = [
       :SUNSTEELSTRIKE,   # Dusk Mane (with Solgaleo) (form 1)
       :MOONGEISTBEAM     # Dawn Wings (with Lunala) (form 2)
    ]
    if form == 0
      # Turned back into the base form; forget form-specific moves
      move_index = -1
      pkmn.moves.each_with_index do |move, i|
        next if !form_moves.any? { |m| m == move.id }
        move_index = i
        break
      end
      if move_index >= 0
        move_name = pkmn.moves[move_index].name
        pkmn.forget_move_at_index(move_index)
        pbMessage(_INTL("{1} forgot {2}...", pkmn.name, move_name))
        pkmn.learn_move(:CONFUSION) if pkmn.numMoves == 0
      end
    else
      # Turned into an alternate form; try learning that form's unique move
      new_move_id = form_moves[form - 1]
      pbLearnMove(pkmn, new_move_id, true)
    end
  }
})

#==============================================================================
# Made events and the player recalculate their bush depth less often
# (lag-busting).
#==============================================================================
class Game_Character
  def bush_depth
    return @bush_depth || 0
  end

  def calculate_bush_depth
    if @tile_id > 0 || @always_on_top || jumping?
      @bush_depth = 0
    else
      deep_bush = regular_bush = false
      xbehind = @x + (@direction == 4 ? 1 : @direction == 6 ? -1 : 0)
      ybehind = @y + (@direction == 8 ? 1 : @direction == 2 ? -1 : 0)
      this_map = (self.map.valid?(@x, @y)) ? [self.map, @x, @y] : $MapFactory.getNewMap(@x, @y)
      if this_map[0].deepBush?(this_map[1], this_map[2]) && self.map.deepBush?(xbehind, ybehind)
        @bush_depth = Game_Map::TILE_HEIGHT
      elsif !moving? && this_map[0].bush?(this_map[1], this_map[2])
        @bush_depth = 12
      else
        @bush_depth = 0
      end
    end
  end

  alias __hotfixes__update update
  def update
    @stopped_last_frame = @stopped_this_frame
    __hotfixes__update
  end

  alias __hotfixes__update_move update_move
  def update_move
    __hotfixes__update_move
    # End of a step, so perform events that happen at this time
    if !jumping? && !moving?
      calculate_bush_depth
      @stopped_this_frame = true
    elsif !@moved_last_frame || @stopped_last_frame   # Started a new step
      calculate_bush_depth
      @stopped_this_frame = false
    end
  end

  alias __hotfixes__update_stop update_stop
  def update_stop
    __hotfixes__update_stop
    @stopped_this_frame = false
  end
end

class Game_Player < Game_Character
  def bush_depth
    return @bush_depth || 0
  end
end

#===============================================================================
# Fixed Shadow Pokémon knowing the same move repeatedly.
#===============================================================================
class Pokemon
  def replace_moves(new_moves)
    new_moves.each do |move|
      next if !move || !GameData::Move.exists?(move) || hasMove?(move)
      if numMoves < Pokemon::MAX_MOVES   # Has an empty slot; just learn move
        learn_move(move)
        next
      end
      @moves.each do |m|
        next if new_moves.include?(m.id)
        m.id = GameData::Move.get(move).id
        break
      end
    end
  end
end
