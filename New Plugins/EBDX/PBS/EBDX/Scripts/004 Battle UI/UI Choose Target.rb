#===============================================================================
#  Target selection UI
#===============================================================================
class TargetWindowEBDX
  attr_reader :index
  #-----------------------------------------------------------------------------
  #  PBS metadata
  #-----------------------------------------------------------------------------
  def applyMetrics
    # sets default values
    @btnImg = "btnEmpty"
    @selImg = "cmdSel"
    # looks up next cached metrics first
    d1 = EliteBattle.get(:nextUI)
    d1 = d1[:TARGETMENU] if !d1.nil? && d1.has_key?(:TARGETMENU)
    # looks up globally defined settings
    d2 = EliteBattle.getData(:TARGETMENU, PBMetrics, :METRICS)
    # proceeds with parameter definition if available
    for data in [d2, d1]
      if !data.nil?
        # applies a set of predefined keys
        @btnImg = data[:BUTTONGRAPHIC] if data.has_key?(:BUTTONGRAPHIC) && data[:BUTTONGRAPHIC].is_a?(String)
        @selImg = data[:SELECTORGRAPHIC] if data.has_key?(:SELECTORGRAPHIC) && data[:SELECTORGRAPHIC].is_a?(String)
      end
    end
  end
  #-----------------------------------------------------------------------------
  #  initialize all the required components
  #-----------------------------------------------------------------------------
  def initialize(viewport, battle, scene)
    @viewport = viewport
    @battle = battle
    @scene = scene
    @index = 0
    @disposed = false
    # button sprite hash
    @buttons = {}
    # apply all the graphic path data
    @path = "Graphics/EBDX/Pictures/UI/"
    self.applyMetrics
    # set up selector sprite
    @sel = SelectorSprite.new(@viewport, 4)
    @sel.filename = @path + @selImg
    @sel.z = 99999
    # set up background graphic
    @background = Sprite.new(@viewport)
    @background.create_rect(@viewport.width, 64, Color.new(0, 0, 0, 150))
    @background.bitmap = pbBitmap(@path + @barImg) if !@barImg.nil?
    @background.y = Graphics.height - @background.bitmap.height + 80
    @background.z = 100
  end
  #-----------------------------------------------------------------------------
  #  re-draw buttons for current context and selectable battlers
  #-----------------------------------------------------------------------------
  def refresh(texts)
    # dispose current buttons
    pbDisposeSpriteHash(@buttons)
    # cache bitmap and calc width/height
    bmp = pbBitmap(@path + @btnImg)
    rw = @battle.pbMaxSize*(bmp.width + 8)
    rh = 2*(bmp.height + 4)
    # render each button
    for i in 0...texts.length
      @buttons["#{i}"] = Sprite.new(@viewport)
      @buttons["#{i}"].bitmap = Bitmap.new(bmp.width, bmp.height)
      @buttons["#{i}"].bitmap.blt(0, 0, bmp, bmp.rect)
      # apply icon sprite if valid target
      if !texts[i].nil?
        pkmn = @battle.battlers[i].pokemon
        icon = pbBitmap(pbPokemonIconFile(pkmn))
        ix = (bmp.width - icon.width/2)/2
        iy = (bmp.height - icon.height)/2 - 9
        @buttons["#{i}"].bitmap.blt(ix, iy, icon, Rect.new(0, 0, icon.width/2, bmp.height - 4 - iy), 216) if @battle.battlers[i].hp > 0
      else
        @buttons["#{i}"].opacity = 128
      end
      # calculate x and y positions
      x = (@viewport.width - rw)/2 + (i%2 == 0 ? i/2 : @battle.pbMaxSize(1) - 1 - (i-1)/2)*(bmp.width + 8)
      y = (@viewport.height - rh - 4) + (1 - i%2)*(bmp.height + 4)
      # apply positioning
      @buttons["#{i}"].x = x
      @buttons["#{i}"].y = y + 120
      @buttons["#{i}"].z = 100
    end
    bmp.dispose
  end
  #-----------------------------------------------------------------------------
  #  set new index
  #-----------------------------------------------------------------------------
  def index=(val)
    @index = val
    @sel.target(@buttons["#{@index}"])
    @buttons["#{@index}"].src_rect.y = -4
  end
  def shiftMode=(val); end
  #-----------------------------------------------------------------------------
  #  update target window
  #-----------------------------------------------------------------------------
  def update
    for key in @buttons.keys
      @buttons[key].src_rect.y += 1 if @buttons[key].src_rect.y < 0
    end
    @sel.update
  end
  #-----------------------------------------------------------------------------
  #  play animation for showing window
  #-----------------------------------------------------------------------------
  def showPlay
    10.times do
      for key in @buttons.keys
        @buttons[key].y -= 12
      end
      @background.y -= 8
      @scene.wait
    end
  end
  #-----------------------------------------------------------------------------
  #  play animation for hiding window
  #-----------------------------------------------------------------------------
  def hidePlay
    @sel.visible = false
    10.times do
      for key in @buttons.keys
        @buttons[key].y += 12
      end
      @background.y += 8
      @scene.wait
    end
  end
  #-----------------------------------------------------------------------------
  #  dispose all sprites
  #-----------------------------------------------------------------------------
  def dispose
    return if self.disposed?
    @sel.dispose
    @background.dispose
    pbDisposeSpriteHash(@buttons)
    @disposed = true
  end
  def disposed?; return @disposed; end
  #-----------------------------------------------------------------------------
end
#===============================================================================
#  Target Choice functionality part
#===============================================================================
class PokeBattle_Scene
  #-----------------------------------------------------------------------------
  #  Main selection override
  #-----------------------------------------------------------------------------
  alias pbChooseTarget_ebdx pbChooseTarget unless self.method_defined?(:pbChooseTarget_ebdx)
  def pbChooseTarget(idxBattler, targetType, visibleSprites = nil)
    # hide fight menu
    @fightWindow.hidePlay
    # Create an array of battler names (only valid targets are named)
    texts = pbCreateTargetTexts(idxBattler, targetType)
    # Determine mode based on targetType
    mode = (PBTargets.oneTarget?(targetType)) ? 0 : 1
    # set up variables
    ret = -1
    pbSelectBattler(@targetWindow.index)
    # set up target window
    @targetWindow.refresh(texts)
    @targetWindow.index = pbFirstTarget(idxBattler, targetType)
    if @targetWindow.index == -1
      raise RuntimeError.new(_INTL("No targets somehow..."))
    end
    @targetWindow.showPlay
    # main function loop
    loop do
      oldIndex = @targetWindow.index
      pbUpdate
      # Update selected command
      if mode == 0   # Choosing just one target, can change index
        if Input.trigger?(Input::LEFT) || Input.trigger?(Input::RIGHT)
          inc = ((@targetWindow.index%2) == 0) ? -2 : 2
          inc *= -1 if Input.trigger?(Input::RIGHT)
          indexLength = @battle.sideSizes[@targetWindow.index%2]*2
          newIndex = @targetWindow.index
          loop do
            newIndex += inc
            break if newIndex < 0 || newIndex >= indexLength
            next if texts[newIndex].nil?
            @targetWindow.index = newIndex
            break
          end
        elsif (Input.trigger?(Input::UP) && (@targetWindow.index%2) == 0) || (Input.trigger?(Input::DOWN) && (@targetWindow.index%2) == 1)
          for tryIndex in @battle.pbGetOpposingIndicesInOrder(@targetWindow.index)
            next if texts[tryIndex].nil?
            @targetWindow.index = tryIndex
            break
          end
        end
        if @targetWindow.index != oldIndex
          pbSEPlay("EBDX/SE_Select1")
          pbSelectBattler(@targetWindow.index)   # Select the new battler/data box
        end
      end
      # update window
      @targetWindow.update
      # confirm input
      if Input.trigger?(Input::C)
        ret = @targetWindow.index; pbPlayDecisionSE
        break
      end
      # cancel input
      if Input.trigger?(Input::B)
        ret = -1; pbPlayCancelSE
        break
      end
    end
    # deselect all sprites and show fight UI if cancelled
    self.pbDeselectAll(ret < 0 ? idxBattler : nil)
    @targetWindow.hidePlay
    @fightWindow.showPlay if ret < 0
    # return output
    return ret
  end
  #-----------------------------------------------------------------------------
end
