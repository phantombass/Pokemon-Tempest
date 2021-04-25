#===
#Audio (FmodEx)
#  A rewrite of Audio module to integrate FmodEx
#---
#© 2015 - Nuri Yuri (塗 ゆり)
#© 2015 - GiraPrimal : Concept of LOOP_TABLE
#---
#Script written by the menbers of the Community Script Project
#===
if !mkxp?
module Audio
  LOOP_TABLE = [
  # [ "Audio/xxx/File_name", begin, end ]
  # Add here


  # Note : Renember to add a comma after each ]
  #       (except for the last line and the below ]).
  ]
  #---
  #>Puts the file names in lowercase to improve the search
  #---
  LOOP_TABLE.each do |i| i[0].downcase! end

  unless @bgm_play #>To avoid the RGSSReset problem
  #===
  #>Load and initialize FmodEx
  #===
  Kernel.load_module("RGSS FmodEx.dll","Init_FmodEx")
  ::FmodEx.init(32)
  #---
  #>Indication of the default lib'
  #---
  @library = ::FmodEx
  #---
  #>Saving the RGSS functions
  #---
  @bgm_play = method(:bgm_play)
  @bgm_fade = method(:bgm_fade)
  @bgm_stop = method(:bgm_stop)
  @bgs_play = method(:bgs_play)
  @bgs_fade = method(:bgs_fade)
  @bgs_stop = method(:bgs_stop)
  @me_play = method(:me_play)
  @me_fade = method(:me_fade)
  @me_stop = method(:me_stop)
  @se_play = method(:se_play)
  @se_stop = method(:se_stop)
  #---
  #>Volumes definition
  #---
  @master_volume = 100
  @sfx_volume = 100
  #===
  #>Extensions supported by FmodEx
  #===
  EXT = ['.ogg', '.mp3', '.wav', '.mid', '.aac', '.wma', '.it', '.xm', '.mod', '.s3m', '.midi']
  #===
  #>Creation/definition of the functions
  #===
  module_function
  def bgm_play(file_name, volume = 100, pitch = 100)
    volume = volume * @master_volume / 100
    return @bgm_play.call(file_name, volume, pitch) if(@library != ::FmodEx)
    return @bgm_play.call(file_name, volume, pitch) if(@library != ::FmodEx)
    return @bgm_play.call(file_name, volume, pitch) if(@library != ::FmodEx)
    filename = check_file(file_name)
    bgm = ::FmodEx.bgm_play(filename, volume, pitch)
    loop_audio(bgm, file_name)
  end
  def bgm_fade(time)
    return @bgm_fade.call(time) if(@library != ::FmodEx)
    return @bgm_fade.call(time) if(@library != ::FmodEx)
    return @bgm_fade.call(time) if(@library != ::FmodEx)
    ::FmodEx.bgm_fade(time)
  end
  def bgm_stop
    return @bgm_stop.call if(@library != ::FmodEx)
    return @bgm_stop.call if(@library != ::FmodEx)
    return @bgm_stop.call if(@library != ::FmodEx)
    ::FmodEx.bgm_stop
  end
  def bgs_play(file_name, volume = 100, pitch = 100)
    volume = volume * @sfx_volume / 100
    return @bgs_play.call(file_name, volume, pitch) if(@library != ::FmodEx)
    filename = check_file(file_name)
    bgs = ::FmodEx.bgs_play(filename, volume, pitch)
    loop_audio(bgs, file_name)
  end
  def bgs_fade(time)
    return @bgs_fade.call(time) if(@library != ::FmodEx)
    ::FmodEx.bgs_fade(time)
  end
  def bgs_stop
    return @bgs_stop.call if(@library != ::FmodEx)
    ::FmodEx.bgs_stop
  end
  def me_play(file_name, volume = 100, pitch = 100)
    volume = volume * @master_volume / 100
    return @me_play.call(file_name, volume, pitch) if(@library != ::FmodEx)
    return @me_play.call(file_name, volume, pitch) if(@library != ::FmodEx)
    return @me_play.call(file_name, volume, pitch) if(@library != ::FmodEx)
    file_name = check_file(file_name)
    ::FmodEx.me_play(file_name, volume, pitch)
  end
  def me_fade(time)
    return @me_fade.call(time) if(@library != ::FmodEx)
    return @me_fade.call(time) if(@library != ::FmodEx)
    return @me_fade.call(time) if(@library != ::FmodEx)
    ::FmodEx.me_fade(time)
  end
  def me_stop
    return @me_stop.call if(@library != ::FmodEx)
    return @me_stop.call if(@library != ::FmodEx)
    return @me_stop.call if(@library != ::FmodEx)
    ::FmodEx.me_stop
  end
  def se_play(file_name, volume = 100, pitch = 100)
    volume = volume * @sfx_volume / 100
    return @se_play.call(file_name, volume, pitch) if(@library != ::FmodEx)
    return @se_play.call(file_name, volume, pitch) if(@library != ::FmodEx)
    return @se_play.call(file_name, volume, pitch) if(@library != ::FmodEx)
    file_name = check_file(file_name)
    ::FmodEx.se_play(file_name, volume, pitch)
  end
  def se_stop
    return @se_stop.call if(@library != ::FmodEx)
    return @se_stop.call if(@library != ::FmodEx)
    return @se_stop.call if(@library != ::FmodEx)
    ::FmodEx.se_stop
  end
  #===
  #>check_file
  #  Check the presence of the file and return the filename
  #  /!\ Doesn't correct the mistake
  #====
  def check_file(file_name)
    return file_name if File.exist?(file_name)
    EXT.each do |ext|
      filename = file_name+ext
      return filename if File.exist?(filename)
    end
    return file_name
  end
  #===
  #>loop_audio
  # Function that automatically call the set_loop_points
  #===
  def loop_audio(sound, file_name)
    filename = file_name.downcase
    LOOP_TABLE.each do |i|
      if(i[0] == filename)
        return sound.set_loop_points(i[1], i[2])
      end
    end
  end
  end
end
end
