#========================================================
#This class holds the information for an individual quest
#========================================================
class Quest
  attr_reader   :id
  attr_reader   :stage

  def initialize(id,stage)
    @id         = id
    @stage      = 1
  end
end

#========================================================
#This class holds all the trainers quests
#========================================================
class Player_Quests
  attr_accessor :active_quests
  attr_accessor :completed_quests
  attr_accessor :failed_quests
  attr_accessor :selected_quest_id
  attr_accessor :quest_stage

  def initialize
    @active_quests =[]
    @completed_quests = []
    @failed_quests = []
    @selected_quest_id = 0
    @quest_stage = ""
  end

  def activateQuest(questID)
    q = "QUEST" + "#{questID}"
    @active_quests.push(QuestsData.const_get(q)["Name"])
    @quest_stage = "<ac>Chapter #{$Trainer.badge_count}\n#{QuestsData.const_get(q)["Name"]}\n#{QuestsData.const_get(q)["Stage1"]}</ac>"
    scene = Quest_Show.new
    scene.pbShow(@quest_stage)
    return scene
  end

  def completeQuest(questID)
    q = "QUEST" + "#{questID}"
    @completed_quests.push(QuestsData.const_get(q)["Name"])
  end

  def advanceQuestToStage(questID,stageNum)
    q = "QUEST" + "#{questID}"
    case stageNum
    when 1
      @quest_stage = "#{QuestsData.const_get(q)["Stage1"]}"
    when 2
      @quest_stage = "<ac>New Objective \n#{QuestsData.const_get(q)["Stage2"]}</ac>"
    when 3
      @quest_stage = "<ac>New Objective \n#{QuestsData.const_get(q)["Stage3"]}</ac>"
    when 4
      @quest_stage = "<ac>New Objective \n#{QuestsData.const_get(q)["Stage4"]}</ac>"
    when 5
      @quest_stage = "<ac>New Objective \n#{QuestsData.const_get(q)["Stage5"]}</ac>"
    when 6
      @quest_stage = "<ac>New Objective \n#{QuestsData.const_get(q)["Stage6"]}</ac>"
    when 7
      @quest_stage = "<ac>New Objective \n#{QuestsData.const_get(q)["Stage7"]}</ac>"
    when 8
      @quest_stage = "<ac>New Objective \n#{QuestsData.const_get(q)["Stage8"]}</ac>"
    when 9
      @quest_stage = "<ac>New Objective \n#{QuestsData.const_get(q)["Stage9"]}</ac>"
    when 10
      @quest_stage = "<ac>New Objective \n#{QuestsData.const_get(q)["Stage10"]}</ac>"
    end
    scene = Quest_Show.new
    scene.pbShow(@quest_stage)
    return scene
  end
end

class PokemonGlobalMetadata
  def quests
    @quests = Player_Quests.new if !@quests
    return @quests
  end

  alias quest_init initialize
  def initialize
    quest_init
    @quests = Player_Quests.new
  end
end

def activateQuest(id)
  return if !$PokemonGlobal
  $PokemonGlobal.quests.activateQuest(id)
end

def completeQuest(id)
  return if !$PokemonGlobal
  $PokemonGlobal.quests.completeQuest(id)
end

def failQuest(id)
  return if !$PokemonGlobal
  $PokemonGlobal.quests.failQuest(id)
end

def advanceQuestToStage(questID,stageNum)
  return if !$PokemonGlobal
  $PokemonGlobal.quests.advanceQuestToStage(questID,stageNum)
end
  #the name of the file to read from

#========================================================
#a module use during compilation of the quest file
#========================================================

#========================================================
#Pseudo class to read quest info from
#========================================================
class QuestInfo
  attr_reader :id
  attr_reader :name
  attr_reader :stages
  attr_reader :questDesc
  attr_reader :locations
  attr_reader :completedMessage

  def initialize(id,questName,stages,questDesc,locations,completedMessage)
    @id = id
    @name = questName
    @stages = stages
    @questDesc = questDesc
    @locations = locations
    @completedMessage = completedMessage
  end
end

#=====================================================================
#This class loads/reads all data for all quests.  Updates at the start
#of every game session will use this class to determine their values,
#and this is used for deciding updates/rewards, etc
#=====================================================================
class Game_Quests
  def compileAllQuests
    #names and IDs must be unique
    checkQuestIDs=[]
    checkQuestNames=[]
    @all_quests = {}
    currentQuest = 0
    name = ""
    questDesc = ""
    completedMessage = ""
    failedMessage = ""
    locations = []
    lineCount = 0
    curStage = 0
    curLocation = 0
    id = []
    #compiling all quest data
    @all_quests = QuestsData.constants
    @all_quests.each do |s|
      id.push("#{QuestsData.const_get(s)["ID"]}")
    end
  end
end

WINDOWSKIN_NAME = "" # set for custom windowskin

class Quest_Show

  def initialize
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 100000
    @sprites = {}

    skin = WINDOWSKIN_NAME == "" ? MessageConfig.pbGetSystemFrame : "Graphics/Windowskins/" + WINDOWSKIN_NAME

     @sprites["background"] = Window_UnformattedTextPokemon.newWithSize("", 0, 0, Graphics.width, 0, @viewport)
     @sprites["background"].z = @viewport.z - 1
     @sprites["background"].visible = false
     @sprites["background"].setSkin(skin)
     pbSetSmallFont(@sprites["background"].contents)

    colors = getDefaultTextColors(@sprites["background"].windowskin)

    @sprites["descwindow"] = Window_AdvancedTextPokemon.newWithSize("", 64, 0, Graphics.width - 64, 64, @viewport)
    @sprites["descwindow"].windowskin = nil
    @sprites["descwindow"].z = @viewport.z
    @sprites["descwindow"].visible = false
    @sprites["descwindow"].baseColor = colors[0]
    @sprites["descwindow"].shadowColor = colors[1]

    pbSetSmallFont(@sprites["descwindow"].contents)
    @sprites["descwindow"].lineHeight(30)
    @smallShow = false
  end

  def pbShow(quest_stage)
    description = quest_stage
    descwindow = @sprites["descwindow"]
    descwindow.resizeToFit(description, Graphics.width - 64)
    descwindow.text = description
    descwindow.y = 0
    descwindow.visible = true

    background = @sprites["background"]
    background.height = descwindow.height
    background.y = 0
    background.visible = true

  end

  def update
    pbUpdateSpriteHash(@sprites)
  end

  def pbEndScene
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end
