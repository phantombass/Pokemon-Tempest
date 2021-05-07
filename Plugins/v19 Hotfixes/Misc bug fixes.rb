#==============================================================================
# "v19 Hotfixes" plugin
# This file contains fixes for miscellaneous bugs.
# These bug fixes are also in the master branch of the GitHub version of
# Essentials:
# https://github.com/Maruno17/pokemon-essentials
#==============================================================================

Essentials::ERROR_TEXT += "[v19 Hotfixes 1.0.4]\r\n"

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
