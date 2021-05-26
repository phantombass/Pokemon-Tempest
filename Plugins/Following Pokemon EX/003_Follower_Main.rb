#-------------------------------------------------------------------------------
# Control the following Pokemon
# Example:
#     follower_move_route([
#         PBMoveRoute::TurnRight,
#         PBMoveRoute::Wait,4,
#         PBMoveRoute::Jump,0,0
#     ])
# The Pokemon turns Right, waits 4 frames, and then jumps
#-------------------------------------------------------------------------------
def follower_move_route(commands,waitComplete=false)
  return if !$Trainer.indexAltemper(true) || !$PokemonGlobal.follower_toggled
  $PokemonTemp.dependentEvents.set_move_route(commands,waitComplete)
end

alias followingMoveRoute follower_move_route

#-------------------------------------------------------------------------------
# Script Command to toggle Following Pokemon
#-------------------------------------------------------------------------------
def pbToggleFollowingPokemon(forced = nil,anim = true)
  return if !pbGetFollowerDependentEvent
  return if !$Trainer.indexAltemper(true)
  if !nil_or_empty?(forced)
    $PokemonGlobal.follower_toggled = true if forced[/on/i]
    $PokemonGlobal.follower_toggled = false if forced[/off/i]
  else
    $PokemonGlobal.follower_toggled = !($PokemonGlobal.follower_toggled)
  end
  $PokemonTemp.dependentEvents.refresh_sprite(anim)
end

#-------------------------------------------------------------------------------
# Script Command to start Pokemon Following. x is the Event ID that will be the follower
#-------------------------------------------------------------------------------
def pbPokemonFollow(x)
  return false if !$Trainer.indexAltemper(true)
  $PokemonTemp.dependentEvents.removeEventByName("FollowerPkmn") if pbGetFollowerDependentEvent
  pbAddDependency2(x,"FollowerPkmn",FollowerSettings::FOLLOWER_COMMON_EVENT)
  $PokemonGlobal.follower_toggled = true
  event = pbGetFollowerDependentEvent
  $PokemonTemp.dependentEvents.pbFollowEventAcrossMaps($game_player,event,true,false)
  $PokemonTemp.dependentEvents.refresh_sprite(true)
end

#-------------------------------------------------------------------------------
# Script Command for Talking to Following Pokemon
#-------------------------------------------------------------------------------
def pbTalkToFollower
  return false if !$PokemonTemp.dependentEvents.can_refresh?
  if !($PokemonGlobal.surfing ||
       (GameData::MapMetadata.exists?($game_map.map_id) &&
       GameData::MapMetadata.get($game_map.map_id).always_bicycle) ||
       !$game_player.pbFacingTerrainTag.can_surf_freely ||
       !$game_map.passable?($game_player.x,$game_player.y,$game_player.direction,$game_player))
    pbSurf
    return false
  end
  first_pkmn = $Trainer.indexAltemper(true)
  GameData::Species.play_cry(first_pkmn)
  event = pbGetFollowerDependentEvent
  random_val = rand(6)
  Events.OnTalkToFollower.trigger(first_pkmn,event.x,event.y,random_val)
  pbTurnTowardEvent(event,$game_player)
end

#-------------------------------------------------------------------------------
# Script Command for getting the Following Pokemon Dependency
#-------------------------------------------------------------------------------
def pbGetFollowerDependentEvent
  return $PokemonTemp.dependentEvents.follower_dependent_event
end

#-------------------------------------------------------------------------------
# Script Command for removing every dependent event except Following Pokemon
#-------------------------------------------------------------------------------
def pbRemoveDependenciesExceptFollower
  $PokemonTemp.dependentEvents.remove_except_follower
end

#-------------------------------------------------------------------------------
# Script Command for  Pokémon finding an item in the field
#-------------------------------------------------------------------------------
def pbPokemonFound(item,quantity = 1,message = "")
  return false if !$PokemonGlobal.follower_hold_item
  pokename = $Trainer.indexAltemper(true).name
  message = "{1} seems to be holding something..." if nil_or_empty?(message)
  pbMessage(_INTL(message,pokename))
  item = GameData::Item.get(item)
  return false if !item || quantity<1
  itemname = (quantity>1) ? item.name_plural : item.name
  pocket = item.pocket
  move = item.move
  if $PokemonBag.pbStoreItem(item,quantity)   # If item can be picked up
    meName = (item.is_key_item?) ? "Key item get" : "Item get"
    if item == :LEFTOVERS
      pbMessage(_INTL("\\me[{1}]#{pokename} found some \\c[1]{2}\\c[0]!\\wtnp[30]",meName,itemname))
    elsif item.is_machine?   # TM or HM
      pbMessage(_INTL("\\me[{1}]#{pokename} found \\c[1]{2} {3}\\c[0]!\\wtnp[30]",meName,itemname,GameData::Move.get(move).name))
    elsif quantity>1
      pbMessage(_INTL("\\me[{1}]#{pokename} found {2} \\c[1]{3}\\c[0]!\\wtnp[30]",meName,quantity,itemname))
    elsif itemname.starts_with_vowel?
      pbMessage(_INTL("\\me[{1}]#{pokename} found an \\c[1]{2}\\c[0]!\\wtnp[30]",meName,itemname))
    else
      pbMessage(_INTL("\\me[{1}]#{pokename} found a \\c[1]{2}\\c[0]!\\wtnp[30]",meName,itemname))
    end
    pbMessage(_INTL("#{pokename} put the {1} away\\nin the <icon=bagPocket{2}>\\c[1]{3} Pocket\\c[0].",
       itemname,pocket,PokemonBag.pocketNames()[pocket]))
    return true
  end
  # Can't add the item
  if item == :LEFTOVERS
    pbMessage(_INTL("#{pokename} found some \\c[1]{1}\\c[0]!\\wtnp[30]",itemname))
  elsif item.is_machine?   # TM or HM
    pbMessage(_INTL("#{pokename} found \\c[1]{1} {2}\\c[0]!\\wtnp[30]",itemname,GameData::Move.get(move).name))
  elsif quantity>1
    pbMessage(_INTL("#{pokename} found {1} \\c[1]{2}\\c[0]!\\wtnp[30]",quantity,itemname))
  elsif itemname.starts_with_vowel?
    pbMessage(_INTL("#{pokename} found an \\c[1]{1}\\c[0]!\\wtnp[30]",itemname))
  else
    pbMessage(_INTL("#{pokename} found a \\c[1]{1}\\c[0]!\\wtnp[30]",itemname))
  end
  pbMessage(_INTL("But your Bag is full..."))
  return false
end


#-------------------------------------------------------------------------------
# Main edits to dependent events for followers to function
#-------------------------------------------------------------------------------
class DependentEvents
  attr_accessor :realEvents
#-------------------------------------------------------------------------------
# Raises The Current Pokemon's Happiness level +1 per each time
# 5000 frames (2 min 5s) have passed
# follower_hold_item is the variable which decides when you are able
# to talk to your pokemon to recieve an item. It becomes true after 15000 frames
# (6mins and 15s) have passed
#-------------------------------------------------------------------------------
  def add_following_time
    $PokemonGlobal.time_taken += 1
    $Trainer.indexAltemper(true).happiness += 1 if ($PokemonGlobal.time_taken % 5000) == 0
    $PokemonGlobal.follower_hold_item = true if ($PokemonGlobal.time_taken > 15000)
  end

# Dependent Event method to remove all events except following pokemon
  def remove_except_follower
    events=$PokemonGlobal.dependentEvents
    for i in 0...events.length
      if events[i] && !events[i][8][/FollowerPkmn/]
        events[i]=nil
        @realEvents[i]=nil
        @lastUpdate+=1
      end
      events.compact!
      @realEvents.compact!
    end
  end

# Dependent Event method to look for Following Pokemon Event
  def follower_dependent_event
    events = $PokemonGlobal.dependentEvents
    for i in 0...events.length
      if events[i] && events[i][8][/FollowerPkmn/]
        return @realEvents[i]
      end
    end
    return nil
  end

# Checks if the follower needs a refresh
  def can_refresh?
    return false if !pbGetFollowerDependentEvent
    return false if !$PokemonGlobal.follower_toggled
    first_pkmn = $Trainer.indexAltemper(true)
    return false if !first_pkmn
    refresh = Events.FollowerRefresh.trigger(first_pkmn)
    refresh = true if refresh == -1
    return refresh
  end

# Change the sprite to the correct species and data
  def change_sprite(params)
    events = $PokemonGlobal.dependentEvents
    for k in 0...events.length
      if events[k] && events[k][8][/FollowerPkmn/]
        fname = GameData::Species.ow_sprite_filename(params[0],params[1],params[2],params[3],params[4]).gsub!("Graphics/Characters/","")
        events[k][6] = fname
        @realEvents[k].character_name = fname
      end
      return
    end
  end

# Adds step animation for followers and update their speed
  def start_stepping
    follower_move_route([PBMoveRoute::StepAnimeOn])
  end

# Stop the Stepping animation
  def stop_stepping
    follower_move_route([PBMoveRoute::StepAnimeOff])
  end

# Removes the sprite of the follower. DOESN'T DISABLE IT
  def remove_sprite
    events = $PokemonGlobal.dependentEvents
    for i in 0...events.length
      next if !events[i] && events[i][8][/FollowerPkmn/]
      events[i][6] = ""
      @realEvents[i].character_name = ""
      $PokemonGlobal.time_taken = 0
    end
  end

# Command to update follower/ make it reappear
  def refresh_sprite(anim = false)
    first_pkmn = $Trainer.indexAltemper(true)
    return if !first_pkmn
    remove_sprite
    ret = can_refresh?
    if anim
      events = $PokemonGlobal.dependentEvents
      for i in 0...events.length
        next if !events[i] && events[i][8][/FollowerPkmn/]
        anim = getConst(FollowerSettings,(ret == true)? :Animation_Come_Out : :Animation_Come_In)
        $scene.spriteset.addUserAnimation(anim,@realEvents[i].x,@realEvents[i].y)
        pbMoveRoute($game_player,[PBMoveRoute::Wait,10])
      end
    end
    change_sprite([first_pkmn.species, first_pkmn.form,
          first_pkmn.gender, first_pkmn.shiny?,
          first_pkmn.shadowPokemon?]) if ret
    if ret
      $PokemonTemp.dependentEvents.start_stepping
    else
      $PokemonTemp.dependentEvents.stop_stepping
    end
    return ret
  end

# Command to update follower/ make it reappear
  def set_move_route(commands,waitComplete=true)
    events=$PokemonGlobal.dependentEvents
    for i in 0...events.length
      if events[i] && events[i][8][/FollowerPkmn/]
        pbMoveRoute(@realEvents[i],commands,waitComplete)
      end
    end
  end

# Define the Follower Dependent events as a different class from Game_Event
  def createEvent(eventData)
    rpgEvent = RPG::Event.new(eventData[3],eventData[4])
    rpgEvent.id = eventData[1]
    if eventData[9]
      # Must setup common event list here and now
      commonEvent = Game_CommonEvent.new(eventData[9])
      rpgEvent.pages[0].list = commonEvent.list
    end
    if eventData[8][/FollowerPkmn/]
      newEvent = Game_FollowerEvent.new(eventData[0],rpgEvent,
                                        $MapFactory.getMap(eventData[2]))
    else
      newEvent = Game_Event.new(eventData[0],rpgEvent,$MapFactory.getMap(eventData[2]))
    end
    newEvent.character_name = eventData[6]
    newEvent.character_hue  = eventData[7]
    case eventData[5]   # direction
    when 2 then newEvent.turn_down
    when 4 then newEvent.turn_left
    when 6 then newEvent.turn_right
    when 8 then newEvent.turn_up
    end
    return newEvent
  end
end

#-------------------------------------------------------------------------------
# Adding a new method to GameData to easily get the appropriate Follower Graphic
#-------------------------------------------------------------------------------
module GameData
  class Species
    def self.ow_sprite_filename(species, form = 0, gender = 0, shiny = false, shadow = false)
      ret = self.check_graphic_file("Graphics/Characters/", species, form, gender, shiny, shadow, "Followers")
	  ret = "Graphics/Characters/Followers/000" if nil_or_empty?(ret)
	  return ret
    end
  end
end

#-------------------------------------------------------------------------------
# Defining a new class for Following Pokemon event which will have constant
# rate of move animation
#-------------------------------------------------------------------------------
class Game_FollowerEvent < Game_Event

  def update_pattern
    return if @lock_pattern
    if @moved_last_frame && !@moved_this_frame && !@step_anime
      @pattern = @original_pattern
      @anime_count = 0
      return
    end
    # Character has started to move, change pattern immediately
    if !@moved_last_frame && @moved_this_frame && !@step_anime
      @pattern = (@pattern + 1) % 4 if @walk_anime
      @anime_count = 0
      return
    end
    # Calculate how many frames each pattern should display for, i.e. the time
    # it takes to move half a tile (or a whole tile if cycling). We assume the
    # game uses square tiles.
    frames_per_pattern = Game_Map::REAL_RES_X / 17.06
    frames_per_pattern *= 2 if move_speed == 6   # Cycling/fastest speed
    return if @anime_count < frames_per_pattern
    # Advance to the next animation frame
    @pattern = (@pattern + 1) % 4
    @anime_count -= frames_per_pattern
  end
end

#-------------------------------------------------------------------------------
# Adding a new method to GameData to easily get the appropriate Follower Graphic
#-------------------------------------------------------------------------------
module Compiler
  module_function

  def convert_pokemon_ows(src_dir, dest_dir)
    split = "Graphics/Characters/Followers/".split('/')
    for i in 0...split.size
      Dir.mkdir(split[0..i].join('/')) unless File.directory?(split[0..i].join('/'))
    end
    System.reload_cache
    split = "Graphics/Characters/Followers shiny/".split('/')
    for i in 0...split.size
      Dir.mkdir(split[0..i].join('/')) unless File.directory?(split[0..i].join('/'))
    end
    System.reload_cache
    return if !FileTest.directory?(src_dir)
    # generates a list of all graphic files
    files = readDirectoryFiles(src_dir, ["*.png"])
    # starts automatic renaming
    files.each_with_index do |file, i|
      Graphics.update if i % 100 == 0
      pbSetWindowText(_INTL("Converting Pokémon overworlds {1}/{2}...", i, files.length)) if i % 50 == 0
      next if !file[/^\d{3}[^\.]*\.[^\.]*$/]
      if file[/s/] && !file[/shadow/]
        prefix = "Followers shiny/"
      else
        prefix = "Followers/"
      end
      new_filename = convert_pokemon_filename(file,prefix)
      # moves the files into their appropriate folders
      File.move(src_dir + file, dest_dir + new_filename)
    end
  end

  if defined?(convert_files)
    class << self
      alias follower_convert_files convert_files
      def convert_files
        follower_convert_files
        convert_pokemon_ows("Graphics/Characters/","Graphics/Characters/")
        pbSetWindowText(nil)
      end
    end
  end
end

#-------------------------------------------------------------------------------
# Adding a new method to GameData to easily get the appropriate Follower Graphic
#-------------------------------------------------------------------------------
module SpriteRenamer
  module_function

  def convert_pokemon_ows(src_dir, dest_dir)
    split = "Graphics/Characters/Followers/".split('/')
    for i in 0...split.size
      Dir.mkdir(split[0..i].join('/')) unless File.directory?(split[0..i].join('/'))
    end
    System.reload_cache
    split = "Graphics/Characters/Followers shiny/".split('/')
    for i in 0...split.size
      Dir.mkdir(split[0..i].join('/')) unless File.directory?(split[0..i].join('/'))
    end
    System.reload_cache
    return if !FileTest.directory?(src_dir)
    # generates a list of all graphic files
    files = readDirectoryFiles(src_dir, ["*.png"])
    # starts automatic renaming
    files.each_with_index do |file, i|
      Graphics.update if i % 100 == 0
      pbSetWindowText(_INTL("Converting Pokémon overworlds {1}/{2}...", i, files.length)) if i % 50 == 0
      next if !file[/^\d{3}[^\.]*\.[^\.]*$/]
      if file[/s/] && !file[/shadow/]
        prefix = "Followers shiny/"
      else
        prefix = "Followers/"
      end
      new_filename = convert_pokemon_filename(file,prefix)
      # moves the files into their appropriate folders
      File.move(src_dir + file, dest_dir + new_filename)
    end
  end

  if defined?(convert_files)
    class << self
      alias follower_convert_files convert_files
      def convert_files
        follower_convert_files
        convert_pokemon_ows("Graphics/Characters/","Graphics/Characters/")
        pbSetWindowText(nil)
      end
    end
  end
end

#-------------------------------------------------------------------------------
# New animation to incorporate the HM animation for Following Pokemon
#-------------------------------------------------------------------------------
alias follow_HMAnim pbHiddenMoveAnimation
def pbHiddenMoveAnimation(pokemon,followAnim = true)
  ret = follow_HMAnim(pokemon)
  if ret && followAnim && $PokemonTemp.dependentEvents.can_refresh? && pokemon == $Trainer.indexAltemper(true)
    value = $game_player.direction
    follower_move_route([PBMoveRoute::Forward])
    case pbGetFollowerDependentEvent.direction
    when 2; pbMoveRoute($game_player,[PBMoveRoute::Up],true)
    when 4; pbMoveRoute($game_player,[PBMoveRoute::Right],true)
    when 6; pbMoveRoute($game_player,[PBMoveRoute::Left],true)
    when 8; pbMoveRoute($game_player,[PBMoveRoute::Down],true)
    end
    pbMoveRoute($game_player,[PBMoveRoute::Wait,(Graphics.frame_rate/5)])
    pbTurnTowardEvent($game_player,pbGetFollowerDependentEvent)
    pbMoveRoute($game_player,[PBMoveRoute::Wait,(Graphics.frame_rate/5)])
    case value
    when 2; follower_move_route([PBMoveRoute::TurnDown])
    when 4; follower_move_route([PBMoveRoute::TurnLeft])
    when 6; follower_move_route([PBMoveRoute::TurnRight])
    when 8; follower_move_route([PBMoveRoute::TurnUp])
    end
    pbMoveRoute($game_player,[PBMoveRoute::Wait,(Graphics.frame_rate/5)])
    case value
    when 2; pbMoveRoute($game_player,[PBMoveRoute::TurnDown],true)
    when 4; pbMoveRoute($game_player,[PBMoveRoute::TurnLeft],true)
    when 6; pbMoveRoute($game_player,[PBMoveRoute::TurnRight],true)
    when 8; pbMoveRoute($game_player,[PBMoveRoute::TurnUp],true)
    end
    pbSEPlay("Player jump")
    follower_move_route([PBMoveRoute::Jump,0,0])
    pbMoveRoute($game_player,[PBMoveRoute::Wait,(Graphics.frame_rate/5)])
  end
end

#-------------------------------------------------------------------------------
# New sendout animation for Followers to slide in when sent out for the 1st time in battle
#-------------------------------------------------------------------------------
class PokeballPlayerSendOutAnimation < PokeBattle_Animation
  def initialize(sprites,viewport,idxTrainer,battler,startBattle,idxOrder=0)
    @idxTrainer     = idxTrainer
    @battler        = battler
    @showingTrainer = startBattle
    @idxOrder       = idxOrder
    @trainer        = @battler.battle.pbGetOwnerFromBattlerIndex(@battler.index)
    @shadowVisible  = sprites["shadow_#{battler.index}"].visible
    @sprites        = sprites
    @viewport       = viewport
    @pictureEx      = []   # For all the PictureEx
    @pictureSprites = []   # For all the sprites
    @tempSprites    = []   # For sprites that exist only for this animation
    @animDone       = false
    if $PokemonTemp.dependentEvents.can_refresh? && battler.index == 0 && startBattle
      createFollowerProcesses
    else
      createProcesses
    end
  end

  def createFollowerProcesses
    delay = 0
    delay = 5 if @showingTrainer
    batSprite = @sprites["pokemon_#{@battler.index}"]
    shaSprite = @sprites["shadow_#{@battler.index}"]
    battlerY = batSprite.y
    battler = addSprite(batSprite,PictureOrigin::Bottom)
    battler.setVisible(delay,true)
    battler.setZoomXY(delay,100,100)
    battler.setColor(delay,Color.new(0,0,0,0))
    battler.setDelta(0,-240,0)
    battler.moveDelta(delay,12,240,0)
    battler.setCallback(delay + 12,[batSprite,:pbPlayIntroAnimation])
    if @shadowVisible
      shadow = addSprite(shaSprite,PictureOrigin::Center)
      shadow.setVisible(delay,@shadowVisible)
      shadow.setDelta(0,-Graphics.width/2,0)
      shadow.setDelta(delay,12,Graphics.width/2,0)
    end
  end
end

#-------------------------------------------------------------------------------
# Refresh a Following Pokemon after taking a step, when a refresh is queued
#-------------------------------------------------------------------------------
Events.onStepTaken += proc { |_sender,_e|
  if $PokemonGlobal.call_refresh[0]
    $PokemonTemp.dependentEvents.refresh_sprite($PokemonGlobal.call_refresh[1])
    $PokemonGlobal.call_refresh = [false,false]
  end
}

#-------------------------------------------------------------------------------
# Registering a fake bridge terrain tag to account for weirdness in the
# base essentials tileset
#-------------------------------------------------------------------------------
GameData::TerrainTag.register({
  :id                     => :FakeBridge,
  :id_number              => 42
})


#-------------------------------------------------------------------------------
# Functions for handling the work that the variables did earlier
#-------------------------------------------------------------------------------
class PokemonGlobalMetadata
  attr_accessor :follower_toggled
  attr_accessor :call_refresh
  attr_accessor :time_taken
  attr_accessor :follower_hold_item
  attr_accessor :current_surfing
  attr_accessor :current_diving
  attr_writer :dependentEvents

  def call_refresh
    @call_refresh = [false,false] if !@call_refresh
    return @call_refresh
  end

  def call_refresh=(value)
    ret = value
    ret = [value,false] if !value.is_a?(Array)
    @call_refresh = value
  end

  def follower_toggled
    @follower_toggled = false if !@follower_toggled
    return @follower_toggled
  end

  def time_taken
    @time_taken = 0 if !@time_taken
    return @time_taken
  end

  def follower_hold_item
    @follower_hold_item = false if !@follower_hold_item
    return @follower_hold_item
  end

  def current_surfing
    @current_surfing = nil if !@current_surfing
    return @current_surfing
  end

  def current_diving
    @current_diving = nil if !@current_diving
    return @current_diving
  end
end

class Trainer
  def hasAltemper?
    return true if indexAltemper > -1
    return false
  end

  def indexAltemper(pkmn=false)
    ret = -1
    @party.each_with_index do |p,i|
      ret = i if p && p.isSpecies?(:ALTEMPER) && p.able?
    end
    if pkmn
      return @party[ret] if ret >= 0
      return nil
    end
    return ret
  end
end
