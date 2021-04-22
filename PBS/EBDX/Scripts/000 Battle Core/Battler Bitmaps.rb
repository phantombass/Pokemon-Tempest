#===============================================================================
#  Loads an animated BitmapWrapper for Pokemon
#===============================================================================
alias pbLoadPokemonBitmap_ebdx pbLoadPokemonBitmap unless defined?(:pbLoadPokemonBitmap_ebdx)
def pbLoadPokemonBitmap(pokemon, back = false, scale = FRONT_SPRITE_SCALE, speed = 2)
  return pbLoadPokemonBitmapSpecies(pokemon, pokemon.species, back, scale, speed)
end
#===============================================================================
#  Loads an animated BitmapWrapper for Pokemon species
#===============================================================================
alias pbLoadPokemonBitmapSpecies_ebdx pbLoadPokemonBitmapSpecies unless defined?(:pbLoadPokemonBitmapSpecies_ebdx)
def pbLoadPokemonBitmapSpecies(pokemon, species, back = false, scale = FRONT_SPRITE_SCALE, speed = 2)
  ret = nil; pokemon = pokemon.pokemon if pokemon.respond_to?(:pokemon)
  # sauce
  species = getConst(PBSpecies, :BIDOOF) if hasConst?(PBSpecies, :BIDOOF) && defined?(firstApr?) && firstApr?
  # applies scale
  scale = back ? BACK_SPRITE_SCALE : FRONT_SPRITE_SCALE
  # gets additional scale (if applicable)
  s = EliteBattle.getData(species, PBSpecies, (back ? :BACKSCALE : :SCALE), (pokemon.form rescue 0))
  scale = s if !s.nil? && s.is_a?(Numeric)
  # get more metrics
  s = EliteBattle.getData(species, PBSpecies, :SPRITESPEED, (pokemon.form rescue 0))
  speed = s if !s.nil? && s.is_a?(Numeric)
  if pokemon.egg?
    bitmapFileName = sprintf("Graphics/EBDX/Battlers/Eggs/%s", getConstantName(PBSpecies, species)) rescue nil
    if !pbResolveBitmap(bitmapFileName)
      bitmapFileName = sprintf("Graphics/EBDX/Battlers/Eggs/%03d", species)
      if !pbResolveBitmap(bitmapFileName)
        bitmapFileName = sprintf("Graphics/EBDX/Battlers/Eggs/000")
      end
    end
    bitmapFileName = pbResolveBitmap(bitmapFileName)
  else
    shiny = pokemon.isShiny?
    shiny = pokemon.superVariant if (!pokemon.superVariant.nil? && pokemon.isSuperShiny?)
    params = [species, back, pokemon.isFemale?, shiny, (pokemon.form rescue 0), (pokemon.isShadow? rescue 0), (pokemon.dynamax rescue false), (pokemon.dynamax && pokemon.gfactor rescue false)]
    bitmapFileName = pbCheckPokemonBitmapFiles(params)
  end
  if bitmapFileName.nil?
    bitmapFileName = "Graphics/EBDX/Battlers/000"
    EliteBattle.log.warn(missingPokeSpriteError(pokemon, back))
  end
  animatedBitmap = AnimatedBitmapWrapper.new(bitmapFileName, scale, speed) if bitmapFileName
  ret = animatedBitmap if bitmapFileName
  # Full compatibility with the alterBitmap methods is maintained
  # but unless the alterBitmap method gets rewritten and sprite animations get
  # hardcoded in the system, the bitmap alterations will not function properly
  # as they will not account for the sprite animation itself

  # alterBitmap methods for static sprites will work just fine
  alterBitmap = (MultipleForms.getFunction(species, "alterBitmap") rescue nil) if !pokemon.egg? && animatedBitmap && animatedBitmap.totalFrames == 1 # remove this totalFrames clause to allow for dynamic sprites too
  if bitmapFileName && alterBitmap
    animatedBitmap.prepareStrip
    for i in 0...animatedBitmap.totalFrames
      alterBitmap.call(pokemon, animatedBitmap.alterBitmap(i))
    end
    animatedBitmap.compileStrip
    ret = animatedBitmap
  end
  # adjusts for custom animation loops
  data = EliteBattle.getData(species, PBSpecies, :FRAMEANIMATION, (pokemon.form rescue 0))
  unless data.nil?
    ret.compileLoop(data)
  end
  # applies super shiny hue
  ret.hue_change(pokemon.superHue) if pokemon.superHue && !ret.changedHue?
  # refreshes bitmap
  ret.deanimate if ret.respond_to?(:deanimate)
  return ret
end
#===============================================================================
#  Pokemon icon aditions
#===============================================================================
def pbPokemonIconFile(pokemon)
  bitmapFileName = nil
  species = pokemon.species
  # sauce
  species = getConst(PBSpecies, :BIDOOF) if hasConst?(PBSpecies, :BIDOOF) && defined?(firstApr?) && firstApr?
  bitmapFileName = pbCheckPokemonIconFiles([species,(pokemon.isFemale?),
     pokemon.isShiny?,(pokemon.form rescue 0),(pokemon.isShadow? rescue false)],
     pokemon.egg?)
  return bitmapFileName
end
#===============================================================================
#  Loads animated BitmapWrapper for species
#===============================================================================
def pbLoadSpeciesBitmap(species, female=false, form=0, shiny=false, shadow=false, back=false, egg=false, scale=FRONT_SPRITE_SCALE)
  ret = nil
  # applies scale
  scale = back ? BACK_SPRITE_SCALE : FRONT_SPRITE_SCALE
  # gets additional scale (if applicable)
  s = EliteBattle.getData(species, PBSpecies, (back ? :BACKSCALE : :SCALE), (form rescue 0))
  scale = s if !s.nil? && s.is_a?(Numeric)
  # check sprite
  if egg
    bitmapFileName = sprintf("Graphics/EBDX/Battlers/Eggs/%s", getConstantName(PBSpecies, species)) rescue nil
    if !pbResolveBitmap(bitmapFileName)
      bitmapFileName = sprintf("Graphics/EBDX/Battlers/Eggs/%03d", species)
      if !pbResolveBitmap(bitmapFileName)
        bitmapFileName = sprintf("Graphics/EBDX/Battlers/Eggs/000")
      end
    end
    bitmapFileName = pbResolveBitmap(bitmapFileName)
  else
    bitmapFileName = pbCheckPokemonBitmapFiles([species, back, female, shiny, form, shadow, false, false])
  end
  if bitmapFileName
    ret = AnimatedBitmapWrapper.new(bitmapFileName, scale)
  end
  # adjusts for custom animation loops
  data = EliteBattle.getData(species, PBSpecies, :FRAMEANIMATION, form)
  unless data.nil?
    ret.compileLoop(data)
  end
  # refreshes bitmap
  ret.deanimate if ret.respond_to?(:deanimate)
  return ret
end
#===============================================================================
#  Returns error message upon missing sprites
#===============================================================================
def missingPokeSpriteError(pokemon, back)
  error_b = back ? "Back" : "Front"
  error_b += "Shiny" if pokemon.isShiny?
  error_b += "/Female/" if pokemon.isFemale?
  error_b += " shadow" if pokemon.isShadow?
  error_b += " form #{pokemon.form} " if pokemon.form > 0
  return "Looks like you're missing the #{error_b} sprite for #{PBSpecies.getName(pokemon.species)}!"
end
#===============================================================================
#  New methods of handing Pokemon sprite name references
#===============================================================================
def pbCheckPokemonBitmapFiles(params)
  species = params[0]; back = params[1]; factors = []
  factors.push([5, params[5], false]) if params[5] && params[5] != false # shadow
  factors.push([2, params[2], false]) if params[2] && params[2] != false # gender
  factors.push([3, params[3], false]) if params[3] && params[3] != false # shiny
  factors.push([6, params[6], false]) if params[6] && params[6] != false # dynamaxed
  factors.push([7, params[7], false]) if params[7] && params[7] != false # gigantimaxed
  factors.push([4, params[4].to_s, ""]) if params[4] && params[4].to_s != "" && params[4].to_s != "0" # form
  tshadow = false; tgender = false; tshiny = false; tform = ""
  for i in 0...(2**factors.length)
    for j in 0...factors.length
      case factors[j][0]
      when 2   # gender
        tgender = ((i/(2**j))%2 == 0) ? factors[j][1] : factors[j][2]
      when 3   # shiny
        tshiny = ((i/(2**j))%2 == 0) ? factors[j][1] : factors[j][2]
      when 4   # form
        tform = ((i/(2**j))%2 == 0) ? factors[j][1] : factors[j][2]
      when 5   # shadow
        tshadow = ((i/(2**j))%2 == 0) ? factors[j][1] : factors[j][2]
      when 6   # dynamaxed
        tdyna = ((i/(2**j))%2 == 0) ? factors[j][1] : factors[j][2]
      when 7   # gigantimaxed
        tgigant = ((i/(2**j))%2 == 0) ? factors[j][1] : factors[j][2]
      end
    end
    folder = "Graphics/EBDX/Battlers/"
    if tshiny && back
      folder += "BackShiny"
    elsif tshiny
      folder += "FrontShiny"
    elsif back
      folder += "Back"
    else
      folder += "Front"
    end
    dirs = []; dirs.push("/Gigantimax") if tgigant; dirs.push("/Dynamax") if tdyna && !tgigant; dirs.push("/Female") if tgender; dirs.push("")
    for dir in dirs
      bitmapFileName = sprintf("#{folder}#{dir}/%s%s%s", getConstantName(PBSpecies,species), (tform != "" ? "_" + tform : ""), tshadow ? "_shadow" : "") rescue nil
      ret = pbResolveBitmap(bitmapFileName)
      return ret if ret
    end
    for dir in dirs
      bitmapFileName = sprintf("#{folder}#{dir}/%03d%s%s", species, (tform != "" ? "_" + tform : ""), tshadow ? "_shadow" : "")
      ret = pbResolveBitmap(bitmapFileName)
      return ret if ret
    end
  end
  return nil
end
#===============================================================================
#  Returns full path for sprite
#===============================================================================
def pbPokemonBitmapFile(species, shiny, back=false)
  folder = "Graphics/EBDX/Battlers/"
  if shiny && back
    folder += "BackShiny/"
  elsif shiny
    folder += "FrontShiny/"
  elsif back
    folder += "Back/"
  else
    folder += "Front/"
  end
  name = sprintf("#{folder}%s", getConstantName(PBSpecies, species)) rescue nil
  ret = pbResolveBitmap(name)
  return ret if ret
  name = sprintf("#{folder}%03d", species)
  return pbResolveBitmap(name)
end
#===============================================================================
#  Pokemon cries
#===============================================================================
alias pbCryFile_ebdx pbCryFile unless defined?(pbCryFile_ebdx)
def pbCryFile(pokemon, form = 0)
  # sauce
  pokemon = getConst(PBSpecies, :BIDOOF) if hasConst?(PBSpecies, :BIDOOF) && defined?(firstApr?) && firstApr?
  return pbCryFile_ebdx(pokemon, form)
end
