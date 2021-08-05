module SideQuest
  OnOff = 403
  WingsuitDone = 405
  Activated = 527
  Type = 801
  Pkmn = 802
  Item = 803
  Loc = 804
  Reward = 805
  MapName = 806
  MapID = 807
  PkmnName = 808
  PkmnID = 809
  ItemName = 810
  ItemID = 811
  Steps = 812
  Rand = 813
  Switch = 101
  Available = 102
  Shira = 83
  Alps = 84
  Snowcap = 85
  Zephyr = 86
  Valley = 87
  Mine = 88
  Ashen = 89
  Steppes = 90
  Cliffs = 91
  Trail = 92
  Forest = 93
  Distura = 94
  Cosmic = 95
  Caverns = 96
  Peak = 97
  Venom = 98
  Comet = 99
  Cinder = 105
  SearS = 107
  Slopes = 108
  SearE = 109
  Dust = 112
  Drakon = 113
  SubTerra = 114
  Timeless = 115
  Lost = 100
  MonSQ = 103
  ItemSQ = 104
end

Events.onStepTaken += proc { |_sender,_e|
  if $game_switches[SideQuest::WingsuitDone] == true
    if !$game_switches[SideQuest::Switch]
      $game_variables[SideQuest::Steps] += 1
      $game_switches[SideQuest::Available] = true if $game_variables[SideQuest::Steps] >= 200
    end
    if !$game_switches[SideQuest::Available]
      $game_switches[SideQuest::OnOff] = false
    end
    if $game_variables[SideQuest::Steps] == 200 && $game_switches[SideQuest::Available]
      $game_variables[SideQuest::Rand] = rand(100)+1
      if $game_variables[SideQuest::Rand] >= 31
        meName = "Voltorb flip win"
        textColor = "7FE00000"
        pbMessage(_INTL("\\me[{1}]<c2={2}>Hey \\PN! It's the Side Quest Captain! I have a job for you!</c2>",meName,textColor))
        pbSideQuestLast
      else
        $game_variables[SideQuest::Steps] = 0
      end
    end
  end
}

def pbSideQuestStart
  $PokemonGlobal.quests.completeQuest(:Quest8,"26CC4B56",false)
  $PokemonGlobal.quests.activateQuest(:Quest9,"26CC4B56",false)
  $game_switches[SideQuest::Available] = false
  $game_switches[SideQuest::Switch] = false
  $game_variables[SideQuest::Steps] = 0
end

def pbSideQuest
  textColor = "7FE00000"
  randSQ = $game_variables[SideQuest::Rand]
  if !$game_switches[SideQuest::Available]
    pbCallBub(2,@event_id)
    pbMessage(_INTL("<c2={1}>I'm sorry, it appears we have no quests available right now.</c2>",textColor))
    pbCallBub(2,@event_id)
    pbMessage(_INTL("<c2={1}>Come back in a bit to check again.</c2>",textColor))
  end
  if $game_switches[SideQuest::Available] && !$game_switches[SideQuest::Switch]
    if randSQ >= 31
      pbSideQuestGen
    else
      pbCallBub(2,@event_id)
      pbMessage(_INTL("<c2={1}>I'm sorry, it appears we have no quests available right now.</c2>",textColor))
      pbCallBub(2,@event_id)
      pbMessage(_INTL("<c2={1}>Come back in a bit to check again.</c2>",textColor))
      $game_switches[SideQuest::Switch] = false
      $game_switches[SideQuest::Available] = false
      $game_variables[SideQuest::Steps] = 0
    end
  end
end

def pbSideQuestGen
  typeSQ = 0
  pkmnSQ = 0
  itemSQ = 0
  locSQ = 0
  mapID = 0
  mapName = 0
  pkmnID = 0
  pkmnName = 0
  itemID = 0
  itemName = 0
  rewardSQ = 0
  textColor = "7FE00000"
  textColor2 = "463F0000"
  typeSQ = rand(3)
  locSQ = rand(20)
  $game_variables[SideQuest::Steps] = 0
  case locSQ
  when 0
    if $game_switches[Mission::Stella]
      mapName = "Comet Lab"
      $game_switches[SideQuest::Comet] = true
    elsif $game_switches[Mission::Vinny]
      mapName = "Venom Lab"
      $game_switches[SideQuest::Venom] = true
    end
  when 1
    if $game_switches[Mission::Stella]
      mapName = "Pixie Caverns"
      $game_switches[SideQuest::Caverns] = true
    elsif $game_switches[Mission::Vinny]
      mapName = "Haunted Forest"
      $game_switches[SideQuest::Forest] = true
    end
  when 2
    if $game_switches[Mission::Stella]
      mapName = "Cosmic Coast"
      $game_switches[SideQuest::Cosmic] = true
    elsif $game_switches[Mission::Vinny]
      mapName = "Trail of Affliction"
      $game_switches[SideQuest::Trail] = true
    end
  when 3
    if $game_switches[Mission::Stella]
      mapName = "Comet Lab"
      $game_switches[SideQuest::Comet] = true
    elsif $game_switches[Mission::Vinny]
      mapName = "Venom Lab"
      $game_switches[SideQuest::Venom] = true
    end
  when 4
    if $game_switches[Mission::Stella]
      mapName = "Pixie Caverns"
      $game_switches[SideQuest::Caverns] = true
    elsif $game_switches[Mission::Vinny]
      mapName = "Haunted Forest"
      $game_switches[SideQuest::Forest] = true
    end
  when 5
    if $game_switches[Mission::Stella]
      mapName = "Cosmic Coast"
      $game_switches[SideQuest::Cosmic] = true
    elsif $game_switches[Mission::Vinny]
      mapName = "Trail of Affliction"
      $game_switches[SideQuest::Trail] = true
    end
  when 6
    mapName = "Coastal Steppes"
    $game_switches[SideQuest::Steppes] = true
  when 7
    mapName = "Rainbow Cliffs"
    $game_switches[SideQuest::Cliffs] = true
  when 8
    mapName = "Ashen Beach"
    $game_switches[SideQuest::Ashen] = true
  when 9
    mapName = "Valley Mine"
    $game_switches[SideQuest::Mine] = true
  when 10
    mapName = "Zephyr Hills"
    $game_switches[SideQuest::Zephyr] = true
  when 11
    mapName = "Shira Town"
    $game_switches[SideQuest::Shira] = true
  when 12
    mapName = "Wind-Torn Valley"
    $game_switches[SideQuest::Valley] = true
  when 13
    mapName = "Snowcap Alps"
    $game_switches[SideQuest::Alps] = true
  when 14
    mapName = "Snowcap Heights"
    $game_switches[SideQuest::Snowcap] = true
  when 15
    if $game_switches[Mission::Vinny]
      mapName = "Distura City"
      $game_switches[SideQuest::Distura] = true
    elsif $game_switches[Mission::Stella]
      mapName = "Astral Peak"
      $game_switches[SideQuest::Peak] = true
    end
  when 16
    if $game_switches[Mission::Vinny]
      mapName = "Cinder Foothills"
      $game_switches[SideQuest::Cinder] = true
    elsif $game_switches[Mission::Stella]
      mapName = "Torrential Slopes"
      $game_switches[SideQuest::Slopes] = true
    end
  when 17
    mapName = "Mt. Sear"
    if $game_switches[Mission::Vinny]
      $game_switches[SideQuest::SearS] = true
    elsif $game_switches[Mission::Stella]
      $game_switches[SideQuest::SearE] = true
    end
  when 18
    if $game_switches[Mission::Vinny]
      mapName = "Dust-Ridden Pass"
      $game_switches[SideQuest::Dust] = true
    elsif $game_switches[Mission::Stella]
      mapName = "SubTerra Trench"
      $game_switches[SideQuest::SubTerra] = true
    end
  when 19
    if $game_switches[Mission::Vinny]
      mapName = "Drakon Mountain"
      $game_switches[SideQuest::Drakon] = true
    elsif $game_switches[Mission::Stella]
      mapName = "Timeless Chasm"
      $game_switches[SideQuest::Timeless] = true
    end
  end
  case typeSQ
  when 0
    #lost little girl quest
    pbCallBub(2,@event_id)
    pbMessage(_INTL("<c2={1}>There's been a report of a lost little girl.</c2>",textColor))
    pbCallBub(2,@event_id)
    pbMessage(_INTL("<c2={1}>She is reported to have been sighted near</c2><c2={2}> {3}.</c2>",textColor,textColor2,mapName))
    pbCallBub(2,@event_id)
    pbMessage(_INTL("<c2={1}>When you find her, come back here for your reward!</c2>",textColor))
    rewardSQ = 1000
    $game_switches[SideQuest::Lost] = true
  when 1
    pkmnSQ = rand(5)
    if $game_switches[Mission::Stella]
      case pkmnSQ
      # Comet Side Quests Only
      when 0
        pkmnID = :CLEFAIRY
      when 1
        pkmnID = :SABLEYE
      when 2
        pkmnID = :MUNNA
      when 3
        pkmnID = :TURTWIG
      when 4
        pkmnID = :PIPLUP
      end
    end
    if $game_switches[Mission::Vinny]
      case pkmnSQ
      # Venom Side Quests Only
      when 0
        pkmnID = :SNEASEL
      when 1
        pkmnID = :CHATOT
      when 2
        pkmnID = :SEVIPER
      when 3
        pkmnID = :TURTWIG
      when 4
        pkmnID = :PIPLUP
      end
    end
    pkmnName = GameData::Species.get(pkmnID).name
    pbCallBub(2,@event_id)
    pbMessage(_INTL("<c2={1}>There's been a report of a {2} that's causing trouble.</c2>",textColor,pkmnName))
    pbCallBub(2,@event_id)
    pbMessage(_INTL("<c2={1}>It is reported to have been sighted near</c2><c2={2}> {3}.</c2>",textColor,textColor2,mapName))
    pbCallBub(2,@event_id)
    pbMessage(_INTL("<c2={1}>When you find it, come back here for your reward!</c2>",textColor))
    $game_switches[SideQuest::MonSQ] = true
    rewardSQ = 3000
  when 2
    itemSQ = rand(5)
    case itemSQ
    when 0
      itemID = :LIGHTBALL
    when 1
      itemID = :LUCKYPUNCH
    when 2
      itemID = :QUICKPOWDER
    when 3
      itemID = :RINGTARGET
    when 4
      itemID = :LEEK
    end
    itemName = GameData::Item.get(itemID).name
    pbCallBub(2,@event_id)
    pbMessage(_INTL("<c2={1}>There's been a report of someone losing their {2}.</c2>",textColor,itemName))
    pbCallBub(2,@event_id)
    pbMessage(_INTL("<c2={1}>It is reported to have been sighted near</c2><c2={2}> {3}.</c2>",textColor,textColor2,mapName))
    pbCallBub(2,@event_id)
    pbMessage(_INTL("<c2={1}>When you find it, come back here for your reward!</c2>",textColor))
    $game_switches[SideQuest::ItemSQ] = true
    rewardSQ = 2000
  end
  $game_variables[SideQuest::Type] = typeSQ
  $game_variables[SideQuest::MapName] = mapName
  $game_variables[SideQuest::PkmnName] = pkmnName
  $game_variables[SideQuest::ItemName] = itemName
  $game_variables[SideQuest::Pkmn] = pkmnSQ
  $game_variables[SideQuest::Item] = itemSQ
  $game_variables[SideQuest::Reward] = rewardSQ
  $game_switches[SideQuest::Switch] = true
  $game_switches[SideQuest::OnOff] = false
  pbSideQuestUpdate
end

def pbSideQuestUpdate
  typeAdv = $game_variables[SideQuest::Type] + 2
  $PokemonGlobal.quests.advanceQuestToStage(:Quest9,typeAdv,"463F0000",false)
end

def pbSideQuestLast
  $PokemonGlobal.quests.advanceQuestToStage(:Quest9,5,"463F0000",false)
end

def pbSideQuestComplete
  msg = 0
  type = $game_variables[SideQuest::Type]
  map = $game_variables[SideQuest::MapName]
  pkmn = $game_variables[SideQuest::PkmnName]
  item = $game_variables[SideQuest::ItemName]
  item2 = $game_variables[SideQuest::Item]
  reward = $game_variables[SideQuest::Reward]
  itemID = 0
  itemRand = rand(5)
  itemReward1 = 0
  itemReward2 = 0
  itemReward3 = 0
  meName = "Item get"
  textColor = "7FE00000"
  case itemRand
  when 0
    itemReward1 = :HYPERPOTION
    itemReward2 = :SITRUSBERRY
    itemReward3 = :NUGGET
  when 1
    itemReward1 = :FULLHEAL
    itemReward2 = :SITRUSBERRY
    itemReward3 = :NUGGET
  when 2
    itemReward1 = :SUPERREPEL
    itemReward2 = :LUMBERRY
    itemReward3 = :RARECANDY
  when 3
    itemReward1 = :HYPERPOTION
    itemReward2 = :FULLHEAL
    itemReward3 = :NUGGET
  when 4
    itemReward1 = :HYPERPOTION
    itemReward2 = :SUPERREPEL
    itemReward3 = :NUGGET
  end
  case type
  when 0
    msg = "lost girl"
  when 1
    msg = pkmn
  when 2
    msg = item
  end
  case item2
  when 0
    itemID = :LIGHTBALL
  when 1
    itemID = :LUCKYPUNCH
  when 2
    itemID = :QUICKPOWDER
  when 3
    itemID = :RINGTARGET
  when 4
    itemID = :LEEK
  end
  pbCallBub(2,@event_id)
  pbMessage(_INTL("<c2={1}>Thank you for helping find the {2}!</c2>",textColor,msg))
  pbCallBub(2,@event_id)
  pbMessage(_INTL("<c2={1}>As promised, a reward!</c2>",textColor))
  pbMessage(_INTL("\\me[{1}]<c2={2}>\\PN got ${3}!",meName,textColor,reward))
  $Trainer.money += reward
  pbWait(8)
  if type == 0
    pbReceiveItem(itemReward1,1)
  elsif type == 2
    pbReceiveItem(itemReward1,2)
    pbReceiveItem(itemReward2,1)
    $PokemonBag.pbDeleteItem(itemID,1)
  elsif type == 1
    pbReceiveItem(itemReward1,3)
    pbReceiveItem(itemReward2,2)
    pbReceiveItem(itemReward3,1)
  end
  pbCallBub(2,@event_id)
  pbMessage(_INTL("<c2={1}>I'll text you when we have another quest!</c2>",textColor))
  for i in 81..104
    $game_switches[i] = false
  end
  for j in 801..813
    $game_variables[j] = -1
  end
  $PokemonGlobal.quests.advanceQuestToStage(:Quest9,6,"463F0000",false)
end
