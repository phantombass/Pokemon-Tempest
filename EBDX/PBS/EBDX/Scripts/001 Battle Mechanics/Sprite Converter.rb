#===============================================================================
#  Automatic sprite name indexing for v4.3 and above
#===============================================================================
module EliteBattle
  def self.reIndexSprites
    # generates a list of all .png files
    allFiles = Dir.get("Graphics/Battlers", "*.png")
    files = []
    # pushes the necessary file names into the main processing list
    for i in 1..PBSpecies.maxValue
      next if !(getConstantName(PBSpecies, i) rescue nil)
      species = sprintf("%03d",i)
      species_name = getConstantName(PBSpecies, i)
      j = 0
      (allFiles.length).times do
        sprite = allFiles[j]
        if sprite.include?(species) || sprite.include?(species_name)
          files.push(sprite.gsub("Graphics/Battlers/", ""))
          allFiles.delete_at(j)
        else
          j += 1
        end
      end
    end
    # starts automatic renaming
    unless files.empty? && !allFiles.include?("egg.png") && !allFiles.include?("eggCracks.png")
      pbMessage("The game has detected that you have sprites in your Graphics/Battlers that do not match the Elite Battle: DX naming convention. This will break your game!")
      pbMessage("Make sure you have made a copy of your Graphics/Battlers folder as automatically resolving the issue will make permanent changes.")
      if pbConfirmMessage("Would you like to automatically resolve this issue?")
        dir = "Graphics/EBDX/Battlers/"
        time = Time.now
        # creates new directories if necessary
        for ext in ["Front/", "Back/", "FrontShiny/", "BackShiny/", "Eggs/"]
          Dir.mkdir(dir + ext) if !Dir.safe?(dir + ext)
          Dir.mkdir(dir + ext + "Female/") if !Dir.safe?(dir + ext + "Female/") && ext != "Eggs/"
        end
        for file in files
          user = "Graphics/Battlers/" + file
          dest = dir
          if Time.now > time + 5
            Graphics.update
            time = Time.now
          end
          # generates target directory and target name
          if file.include?("egg") || file.include?("Egg")
            dest = dir + "Eggs/"
            if file.include?("eggCracks")
              new_name = file.gsub(/eggCracks/) {|s| "cracks" }
            elsif file.include?("Egg")
              new_name = file.gsub(/Egg/) {|s| "" }
            else
              new_name = file.gsub(/egg/) {|s| "" }
            end
          elsif file.include?("s") && !file.include?("shadow")
            if file.include?("b")
              dest = dir + "BackShiny/"
              new_name = file.gsub(/sb/) {|s| "" }
            else
              dest = dir + "FrontShiny/"
              new_name = file.gsub(/s/) {|s| "" }
            end
          else
            if file.include?("b")
              dest = dir + "Back/"
              new_name = file.gsub(/b/) {|s| "" }
            else
              dest = dir + "Front/"
              new_name = file
            end
          end
          if file.include?("f")
            dest += "Female/"
            new_name.gsub!(/f/) {|s| "" }
          end
          target = dest + new_name
          # moves the files into their appropriate folders
          File.rename(user, target)
        end
      end
      # Egg conversion
      allFiles = Dir.get("Graphics/Battlers", "*.png")
      for file in allFiles
        next if !file.include?("egg")
        dest = "Graphics/EBDX/Battlers/Eggs/000" + (file.include?("eggCracks.png") ? "cracks" : "") + ".png"
        if File.safe?(dest)
          File.delete(file)
        else
          File.rename(file, dest)
        end
      end
      pbMessage("Conversion complete! Have fun using the new system!")
    end
  end
  #-----------------------------------------------------------------------------
end
#===============================================================================
#  Converts GIF files into EBDX formatted strips
#===============================================================================
def gifToPng
  return if !Dir.safe?("ToGIF")
  # gets a list of all GIF files
  files = Dir.get("ToGIF", "*.gif")
  time = Time.now
  # processes each file
  for file in files
    # loads GIF to bitmap
    bmp = GifBitmap.new(file, 0)
    # gets metrics
    w = bmp.width; h = bmp.height
    # determines rect size
    r = w > h ? w : h
    # creates blank bitmap strip
    out = Bitmap.new(r*bmp.gifbitmaps.length, r)
    for i in 0...bmp.gifbitmaps.length
      # fetches frame in GIF
      frame = bmp.gifbitmaps[i]
      # calculates x and y offset
      x = (r - frame.width)/2
      y = (r - frame.height)/2
      # renders GIF frame onto strip
      out.blt(r*i + x, y, frame, frame.rect)
      # prevents timing out
      if Time.now > time + 5
        time = Time.now
        Graphics.update
      end
    end
    out.saveToPng(file.gsub(".gif", ".png"))
    # disposes bitmaps
    bmp.dispose; out.dispose
  end
end
