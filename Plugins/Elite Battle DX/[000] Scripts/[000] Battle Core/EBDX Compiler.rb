#===============================================================================
#  Compiler Module for Elite Battle: DX
#-------------------------------------------------------------------------------
#  used to compile PBS data and interpret them on run-time
#===============================================================================
module CompilerEBDX
  #-----------------------------------------------------------------------------
  # interpret file stream and convert to appropriate Hash map
  #-----------------------------------------------------------------------------
  def self.interpret(filename)
    # failsafe
    return {} if !safeExists?(filename)
    # read file
    contents = File.open(filename, 'rb') {|f| f.read.gsub("\t", "  ") }
    # begin interpretation
    data = {}; entries = []
    # skip if empty
    return data if !contents || contents.empty?
    indexes = contents.scan(/(?<=\[)(.*?)(?=\])/i); indexes.push(indexes[-1])
    # iterate through each index and compile data points
    for j in 0...indexes.length
      i = indexes[j]
      if j == indexes.length - 1 # when final entry
        m = contents.split("[#{i[0]}]")[1]
        next if m.nil?
      else # fetch data contents
        m = contents.split("[#{i[0]}]")[0]
        next if m.nil?
        contents.gsub!(m, "")
      end
      m.gsub!("[#{i[0]}]\r\n", "")
      entries.push(m.split("\r\n")) # push into array
    end
    # delete first empty data point
    entries.delete_at(0)
    # loop to iterate through each data point and compile usable information
    for i in 0...entries.length
      d = {}
      # set primary section
      section = "__pk__"
      # compiles data into proper structure
      for e in entries[i]
        d[section] = {} if !d.keys.include?(section)
        e = e.split("#")[0]
        next if e.nil? || e == "" || (e.include?("[") && e.include?("]"))
        a = e.split("=")
        a[0] = a[0] ? a[0].strip : ""
        a[1] = a[1] ? a[1].strip : ""
        next section = a[0] if a[1].nil? || a[1] == "" || a[1].empty?
        # split array
        a[1] = a[1].split(",")
        # raise error
        if a[0] == "XY" && a[1].length < 2
          raise self.lengthError(filename, indexes[i][0], section, 2, a[0], a[1])
        elsif a[0] == "XYZ" && a[1].length < 3
          raise self.lengthError(filename, indexes[i][0], section, 3, a[0], a[1])
        end
        # convert to proper type
        for q in 0...a[1].length
          typ = "String"
          begin
            if a[1][q].is_numeric? && a[1][q].include?('.')
              typ = "Float"
              a[1][q] = a[1][q].to_f
            elsif a[1][q].is_numeric?
              typ = "Integer"
              a[1][q] = a[1][q].to_i
            elsif a[1][q].downcase == "true" || a[1][q].downcase == "false"
              typ = "Boolean"
              a[1][q] = a[1][q].downcase == "true"
            end
          rescue
            EliteBattle.log.error(self.formatError(filename, indexes[i][0], section, typ, a[0], a[1][q]))
          end
        end
        # add data to section
        d[section][a[0]] = a[1]
      end
      # delete primary if empty
      d.delete("__pk__") if d["__pk__"] && d["__pk__"].empty?
      # push data entry
      data[indexes[i][0]] = d
    end
    return data
  end
  #-----------------------------------------------------------------------------
  # get base maps to compile
  #-----------------------------------------------------------------------------
  def self.getCompileMaps
    files = []
    Dir.get("PBS/EBDX", "*.txt", false).each do |d|
      f = d.split(".")[0]
      files.push(f) if !files.include?(f)
    end
    return files
  end
  #-----------------------------------------------------------------------------
  # compile all the necessary PBS data
  #-----------------------------------------------------------------------------
  def self.compile(mustCompile = false)
    return if !$DEBUG || !Dir.safe?("PBS/EBDX") || safeExists?("Game.rgssad")
    pbSetWindowText("Compiling EBDX data")
    pbs = Dir.get("PBS/EBDX", "*.txt", false)
    # show message
    echoln ""
    comp = false
    # iterate through possible PBS files
    for filename in self.getCompileMaps
      #------------------------------------------------------------------------
      refresh = !safeExists?("Data/#{filename}.ebdx")
      refresh = true if Input.press?(Input::CTRL) || mustCompile
      # main handler for base file
      refresh = true if !refresh && safeExists?("PBS/EBDX/#{filename}.txt") && File.mtime("PBS/EBDX/#{filename}.txt") > File.mtime("Data/#{filename}.ebdx")
      # iterate through all possible packs
      for f in pbs
        # skip if main or not part of current iterable
        next if f == "#{filename}.txt" || !f.start_with?(filename) || refresh
        refresh = true if File.mtime("PBS/EBDX/#{f}") > File.mtime("Data/#{filename}.ebdx")
      end
      # refresh if compiled data is older than compiled scripts
      refresh = true if !refresh && safeExists?("Data/#{filename}.ebdx") && safeExists?("Data/PluginScripts.rxdata") && File.mtime("Data/PluginScripts.rxdata") > File.mtime("Data/#{filename}.ebdx")
      #------------------------------------------------------------------------
      next if !refresh
      # show message
      if !comp
        echoln "Compiling Elite Battle: DX data...\r\n"; comp = true
      end
      echoln "  -> compiling #{filename.downcase} data..."
      read = {}
      # read main PBS
      read.deep_merge!(self.interpret("PBS/EBDX/#{filename}.txt")) if safeExists?("PBS/EBDX/#{filename}.txt")
      # iterate through all possible packs
      for f in pbs
        # skip if main or not part of current iterable
        next if f == "#{filename}.txt" || !f.start_with?(filename)
        read.deep_merge!(self.interpret("PBS/EBDX/#{f}"))
      end
      #------------------------------------------------------------------------
      # compile PBS data
      save_data(read, "Data/#{filename}.ebdx")
    end
    # clean up
    GC.start
    echoln comp ? "\r\nCompiled all Elite Battle: DX data.\r\n" : "\r\nAll Elite Battle: DX data already compiled.\r\n"
    EliteBattle.set(:compiled, true)
    pbSetWindowText(nil)
  end
  #-----------------------------------------------------------------------------
  # print out formatting error
  #-----------------------------------------------------------------------------
  def self.formatError(filename, section, sub, type, key, val)
    sectn = (sub == "__pk__") ? "[#{section}]" : "[#{section}]\nSub-section: #{sub}"
    return "File: #{filename}\nError compiling data in Section: #{sectn}\nCould not implicitly convert value for Key: #{key} to type (#{type})\n#{key} = #{val}"
  end
  def self.lengthError(filename, section, sub, len, key, val)
    sectn = (sub == "__pk__") ? "[#{section}]" : "[#{section}]\nSub-section: #{sub}"
    return "File: #{filename}\nError compiling data in Section: #{sectn}\nWrong number of arguments for Key: #{key}, got #{val.length} expected #{len}"
  end
  #-----------------------------------------------------------------------------
  # interpret all the data from cache
  #-----------------------------------------------------------------------------
  def self.addFromCached
    return if !$DEBUG
    # get cache
    cache = EliteBattle.get(:cachedData)
    for ch in cache
      # run each from cache
      EliteBattle.add_data(*ch)
    end
    # clear cache
    cache.clear
    EliteBattle.set(:cachedData, [])
    # force start garbage collector
    GC.start
  end
  #-----------------------------------------------------------------------------
end
#===============================================================================
# run compiler
module Compiler
  #-----------------------------------------------------------------------------
  class << Compiler
    alias compile_all_ebdx compile_all
  end
  #-----------------------------------------------------------------------------
  def self.compile_all(mustCompile)
    # run Essentials compiler
    compile_all_ebdx(mustCompile) { |msg| pbSetWindowText(msg); echoln(msg) }
    # compile EBDX
    CompilerEBDX.compile(mustCompile)
  end
  #-----------------------------------------------------------------------------
end
