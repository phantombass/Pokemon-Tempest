#===================================
# Mid Battle Status Scripts
#===================================
def poisonAllPokemon(event=nil)
    for pkmn in $Trainer.ablePokemonParty
       next if pkmn.hasType?(:POISON)  || pkmn.hasType?(:STEEL) ||
          pkmn.hasAbility?(:COMATOSE)  || pkmn.hasAbility?(:SHIELDSDOWN) || pkmn.hasAbility?(:IMMUNITY)
          pkmn.status!=0
       pkmn.status = 2
       pkmn.statusCount = 1
     end
end

def paralyzeAllPokemon(event=nil)
    for pkmn in $Trainer.ablePokemonParty
       next if pkmn.hasType?(:ELECTRIC) ||
          pkmn.hasAbility?(:COMATOSE)  || pkmn.hasAbility?(:SHIELDSDOWN) || pkmn.hasAbility?(:LIMBER)
          pkmn.status!=0
       pkmn.status = 4
     end
end

def burnAllPokemon(event=nil)
    for pkmn in $Trainer.ablePokemonParty
       next if pkmn.hasType?(:FIRE) ||
          pkmn.hasAbility?(:COMATOSE)  || pkmn.hasAbility?(:SHIELDSDOWN) || pkmn.hasAbility?(:WATERBUBBLE) || pkmn.hasAbility?(:WATERVEIL)
          pkmn.status!=0
       pkmn.status = 3
     end
end

class PokeBattle_Battle
  def removeAllHazards
    if @battlers[0].pbOwnSide.effects[PBEffects::StealthRock] || @battlers[0].pbOpposingSide.effects[PBEffects::StealthRock]
      @battlers[0].pbOwnSide.effects[PBEffects::StealthRock]      = false
      @battlers[0].pbOpposingSide.effects[PBEffects::StealthRock] = false
    end
    if @battlers[0].pbOwnSide.effects[PBEffects::Spikes]>0 || @battlers[0].pbOpposingSide.effects[PBEffects::Spikes]>0
      @battlers[0].pbOwnSide.effects[PBEffects::Spikes]      = 0
      @battlers[0].pbOpposingSide.effects[PBEffects::Spikes] = 0
    end
    if @battlers[0].pbOwnSide.effects[PBEffects::CometShards] || @battlers[0].pbOpposingSide.effects[PBEffects::CometShards]
      @battlers[0].pbOwnSide.effects[PBEffects::CometShards]      = false
      @battlers[0].pbOpposingSide.effects[PBEffects::CometShards] = false
    end
    if @battlers[0].pbOwnSide.effects[PBEffects::ToxicSpikes]>0 || @battlers[0].pbOpposingSide.effects[PBEffects::ToxicSpikes]>0
      @battlers[0].pbOwnSide.effects[PBEffects::ToxicSpikes]      = 0
      @battlers[0].pbOpposingSide.effects[PBEffects::ToxicSpikes] = 0
    end
    if @battlers[0].pbOwnSide.effects[PBEffects::StickyWeb] || @battlers[0].pbOpposingSide.effects[PBEffects::StickyWeb]
      @battlers[0].pbOwnSide.effects[PBEffects::StickyWeb]      = false
      @battlers[0].pbOpposingSide.effects[PBEffects::StickyWeb] = false
    end
  end
end

EliteBattle.defineMoveAnimation(:STELLARWIND) do
  vector = @scene.getRealVector(@targetIndex, @targetIsPlayer)
  vector2 = @scene.getRealVector(@userIndex, @userIsPlayer)
  # set up animation
  fp = {}
  rndx = []; prndx = []
  rndy = []; prndy = []
  rangl = []
  dx = []
  dy = []
  for i in 0...128
    fp["#{i}"] = Sprite.new(@viewport)
    fp["#{i}"].bitmap = pbBitmap("Graphics/EBDX/Animations/Moves/eb423")
    fp["#{i}"].ox = fp["#{i}"].bitmap.width/2
    fp["#{i}"].oy = fp["#{i}"].bitmap.height/2
    fp["#{i}"].visible = false
    fp["#{i}"].z = @targetSprite.z + 1
    rndx.push(rand(256)); prndx.push(rand(72))
    rndy.push(rand(256)); prndy.push(rand(72))
    rangl.push(rand(9))
    dx.push(0)
    dy.push(0)
  end
  shake = 4
  # start animation
  @vector.set(vector2)
  pbSEPlay("Anim/Whirlwind")
  for i in 0...72
    ax, ay = @userSprite.getCenter
    cx, cy = @targetSprite.getCenter(true)
    for j in 0...128
      next if j>(i*2)
      if !fp["#{j}"].visible
        dx[j] = ax - 46*@userSprite.zoom_x*0.5 + prndx[j]*@userSprite.zoom_x*0.5
        dy[j] = ay - 46*@userSprite.zoom_y*0.5 + prndy[j]*@userSprite.zoom_y*0.5
        fp["#{j}"].x = dx[j]
        fp["#{j}"].y = dy[j]
        fp["#{j}"].visible = true
      end
      x0 = ax - 46*@userSprite.zoom_x*0.5 + prndx[j]*@userSprite.zoom_x*0.5
      y0 = ay - 46*@userSprite.zoom_y*0.5 + prndy[j]*@userSprite.zoom_y*0.5
      x2 = cx - 128*@targetSprite.zoom_x*0.5 + rndx[j]*@targetSprite.zoom_x*0.5
      y2 = cy - 128*@targetSprite.zoom_y*0.5 + rndy[j]*@targetSprite.zoom_y*0.5
      fp["#{j}"].x += (x2 - x0)*0.1
      fp["#{j}"].y += (y2 - y0)*0.1
      fp["#{j}"].angle += rangl[j]*2
      nextx = fp["#{j}"].x
      nexty = fp["#{j}"].y
      if !@targetIsPlayer
        fp["#{j}"].opacity -= 51 if nextx > cx && nexty < cy
      else
        fp["#{j}"].opacity -= 51 if nextx < cx && nexty > cy
      end
    end
    if i >= 64
  #    @targetSprite.x += 64*(@targetIsPlayer ? -1 : 1)
    elsif i >= 52
      @targetSprite.ox += shake
      shake = -4 if @targetSprite.ox > @targetSprite.bitmap.width/2 + 2
      shake = 4 if @targetSprite.ox < @targetSprite.bitmap.width/2 - 2
      @targetSprite.still
    end
    @vector.set(vector) if i == 16
    @vector.inc = 0.1 if i == 16
    @scene.wait(1,i < 64)
  end
#  @targetSprite.visible = false
#  @targetSprite.hidden = true
#  @targetSprite.ox = @targetSprite.bitmap.width/2
  pbDisposeSpriteHash(fp)
  @vector.reset
  @vector.inc = 0.2
  @scene.wait(16,true)
end
EliteBattle.defineMoveAnimation(:TIMEWIND) do
  vector = @scene.getRealVector(@targetIndex, @targetIsPlayer)
  vector2 = @scene.getRealVector(@userIndex, @userIsPlayer)
  # set up animation
  fp = {}
  rndx = []; prndx = []
  rndy = []; prndy = []
  rangl = []
  dx = []
  dy = []
  for i in 0...128
    fp["#{i}"] = Sprite.new(@viewport)
    fp["#{i}"].bitmap = pbBitmap("Graphics/EBDX/Animations/Moves/eb423")
    fp["#{i}"].ox = fp["#{i}"].bitmap.width/2
    fp["#{i}"].oy = fp["#{i}"].bitmap.height/2
    fp["#{i}"].visible = false
    fp["#{i}"].z = @targetSprite.z + 1
    rndx.push(rand(256)); prndx.push(rand(72))
    rndy.push(rand(256)); prndy.push(rand(72))
    rangl.push(rand(9))
    dx.push(0)
    dy.push(0)
  end
  shake = 4
  # start animation
  @vector.set(vector2)
  pbSEPlay("Anim/Whirlwind")
  for i in 0...72
    ax, ay = @userSprite.getCenter
    cx, cy = @targetSprite.getCenter(true)
    for j in 0...128
      next if j>(i*2)
      if !fp["#{j}"].visible
        dx[j] = ax - 46*@userSprite.zoom_x*0.5 + prndx[j]*@userSprite.zoom_x*0.5
        dy[j] = ay - 46*@userSprite.zoom_y*0.5 + prndy[j]*@userSprite.zoom_y*0.5
        fp["#{j}"].x = dx[j]
        fp["#{j}"].y = dy[j]
        fp["#{j}"].visible = true
      end
      x0 = ax - 46*@userSprite.zoom_x*0.5 + prndx[j]*@userSprite.zoom_x*0.5
      y0 = ay - 46*@userSprite.zoom_y*0.5 + prndy[j]*@userSprite.zoom_y*0.5
      x2 = cx - 128*@targetSprite.zoom_x*0.5 + rndx[j]*@targetSprite.zoom_x*0.5
      y2 = cy - 128*@targetSprite.zoom_y*0.5 + rndy[j]*@targetSprite.zoom_y*0.5
      fp["#{j}"].x += (x2 - x0)*0.1
      fp["#{j}"].y += (y2 - y0)*0.1
      fp["#{j}"].angle += rangl[j]*2
      nextx = fp["#{j}"].x
      nexty = fp["#{j}"].y
      if !@targetIsPlayer
        fp["#{j}"].opacity -= 51 if nextx > cx && nexty < cy
      else
        fp["#{j}"].opacity -= 51 if nextx < cx && nexty > cy
      end
    end
    if i >= 64
  #    @targetSprite.x += 64*(@targetIsPlayer ? -1 : 1)
    elsif i >= 52
      @targetSprite.ox += shake
      shake = -4 if @targetSprite.ox > @targetSprite.bitmap.width/2 + 2
      shake = 4 if @targetSprite.ox < @targetSprite.bitmap.width/2 - 2
      @targetSprite.still
    end
    @vector.set(vector) if i == 16
    @vector.inc = 0.1 if i == 16
    @scene.wait(1,i < 64)
  end
#  @targetSprite.visible = false
#  @targetSprite.hidden = true
#  @targetSprite.ox = @targetSprite.bitmap.width/2
  pbDisposeSpriteHash(fp)
  @vector.reset
  @vector.inc = 0.2
  @scene.wait(16,true)
end

#==================
#Boss BattleScripts
#==================

module BattleScripts
  #Rampaging Pokémon
  METANG = {
    "turnStart0" => proc do
      $game_switches[81] = true
      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("The Metang is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Metang's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Metang's anger is shaking the cave!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  CHERRIM = {
    "turnStart0" => proc do
      $game_switches[81] = true
      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("The Cherrim is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Cherrim's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Cherrim's anger is shaking the cliffs!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  ARIADOS = {
    "turnStart0" => proc do
      $game_switches[81] = true
      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("The Ariados is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Ariados's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Ariados's anger is shaking the forest!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  ELECTRODE = {
    "turnStart0" => proc do
      $game_switches[81] = true
      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("The Electrode is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Electrode's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Electrode's anger is shaking the lab!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  MACHOKE = {
    "turnStart0" => proc do
      $game_switches[81] = true
      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("The Machoke is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Machoke's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Machoke's anger is shaking the caverns!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  XATU = {
    "turnStart0" => proc do
      $game_switches[81] = true
      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("The Xatu is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Xatu's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Xatu's anger is shaking the lab!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  ABSOL = {
    "turnStart0" => proc do
      $game_switches[81] = true
      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("Absol is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Absol's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Absol's anger is shaking the area!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  SIDEQUEST = {
    "turnStart0" => proc do
      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("The Pokémon is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("The Pokémon's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("The Pokémon's anger is shaking the area!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  GROUDON = {
    "turnStart0" => proc do
      $game_switches[81] = true
      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("Groudon is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Groudon's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Groudon's anger is shaking the mountain!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  KYOGRE = {
    "turnStart0" => proc do
      $game_switches[81] = true
      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("Kyogre is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Kyogre's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Kyogre's anger is shaking the cave!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  GROUDON = {
    "turnStart0" => proc do
      $game_switches[81] = true
      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("Groudon is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Groudon's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Groudon's anger is shaking the mountain!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  RAYQUAZA1 = {
    "turnStart0" => proc do
      $game_switches[81] = true
      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("Rayquaza is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Rayquaza's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Rayquaza's anger is shaking the mountain!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  RAYQUAZA2 = {
    "turnStart0" => proc do
      $game_switches[81] = true
      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("Rayquaza is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Rayquaza's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Rayquaza's anger is shaking the cave!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  DIALGA = {
    "turnStart0" => proc do
      $game_switches[81] = true
      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("Dialga is carefully eyeing you...")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Dialga's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Dialga is raring to go!")
      @scene.pbShowAllDataboxes
    end
  }

  PALKIA = {
    "turnStart0" => proc do
      $game_switches[81] = true
      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("Palkia is carefully eyeing you...")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Palkia's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Palkia is raring to go!")
      @scene.pbShowAllDataboxes
    end
  }

  CLEFABLE = {
    "turnStart0" => proc do
      $game_switches[81] = true
      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("The Clefable is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Clefable's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Clefable's anger is shaking the caverns!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  ELECTIVIRE = {
    "turnStart0" => proc do
      $game_switches[81] = true
      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("The Electivire is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Electivire's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Electivire's anger is shaking the lab!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  DUSKNOIR = {
    "turnStart0" => proc do
      $game_switches[81] = true
      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("The Dusknoir is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Dusknoir's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Dusknoir's anger is shaking the forest!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  WEAVILE = {
    "turnStart0" => proc do
      $game_switches[81] = true
      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("The Weavile is seething with rage!")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Weavile's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Weavile's anger is shaking the lab!")
      # change the battle environment (use animation to transition)
      @sprites["battlebg"].reconfigure(EnvironmentEBDX::DIMENSION, :DISTORTION)
      @scene.pbDisplay("Its anger distorted the dimensions!")
      # show databoxes
      @scene.pbShowAllDataboxes
    end
  }

  GIRATINA = {
    "turnStart0" => proc do
      $game_switches[81] = true
      # hide databoxes
      @scene.pbHideAllDataboxes
      # show flavor text
      @scene.pbDisplay("Giratina is carefully eyeing you...")
      pbBGMPlay("Legendary")
      EliteBattle.playCommonAnimation(:AURAFLARE, @scene, 1)
      @vector.reset # AURAFLARE doesn't reset the vector by default
      @scene.wait(16, true) # set true to anchor the sprites to vector
      # raise battler Attack sharply (doesn't display text)
      @scene.pbDisplay("Giratina's stats rose!")
      @scene.wait(16)
      # play common animation
      EliteBattle.playCommonAnimation(:ROAR, @scene, 1)
      @scene.pbDisplay("Giratina is raring to go!")
      @scene.pbShowAllDataboxes
    end
  }
#Important Trainer Battles
      AARON = {
        "turnStart0" => "I'll humor you this time, child.",
        "lastOpp" => "Hmm. You have become a rather puzzling problem."
      }
      AARONLOSS = {
        "turnStart0" => "Clearly you do not understand when to give up.",
        "lastOpp" => "Hmm. You appear to have gotten a little stronger."
      }
      AARONLAST = {
        "turnStart0" => "You have interfered for the last time.",
        "lastOpp" => "Hmm. You appear to have gotten a little stronger."
      }
      #Rival Battles
        RIVAL = {
          "turnStart0" => "You're going to regret challenging me!",
          "lastOpp" => "Ugh. You are so irritating!"
        }

        RIVAL1 = {
          "turnStart0" => "You're going to pay for beating me last time!",
          "lastOpp" => "Ugh. This can NOT be happening again!"
        }

        RIVAL2 = {
          "turnStart0" => "You are going down again! Just like last time!",
          "lastOpp" => "Ugh. This can NOT be happening!"
        }

        RIVAL3 = {
          "turnStart0" => "You are going to have to prove to me you can do this!",
          "lastOpp" => "Come on! Is that all you got?!?"
        }

        RIVAL4 = {
          "turnStart0" => "I want to see the strongest trainer in Ufara's team!",
          "lastOpp" => "I knew you were strong. But not this strong..."
        }

        CYNTHIA = {
          "turnStart0" => "Come at me with everything! I want to know just how strong your team is!",
          "lastOpp" => "It's been a long time since I was backed into a corner like this."
        }

        MOM = {
          "turnStart0" => "I don't want you holding back, honey. I know I won't!",
          "lastOpp" => "Oh my. I had no idea you were this strong!"
        }

        BARRY = {
          "turnStart0" => "Let's see just how strong you are!",
          "lastOpp" => "Wow! You're really good!"
        }

        SIMON = {
          "turnStart0" => "Alright, my friend. Let's put that team to the test!",
          "lastOpp" => "You're pushing me to my limits! What a blast!"
        }
end
