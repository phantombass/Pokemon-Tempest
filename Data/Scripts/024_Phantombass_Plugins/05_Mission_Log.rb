module Mission
  One = 504
  Two = 509
  Three = 520
  Four = 526
  Mission1 = 503
  Mission2 = 504
  Mission3 = 505
  Mission4 = 507
  Stella = 517
  Vinny = 518
  SideQuest = 404
end

def pbMissionUpdate
  if $game_switches[Mission::One] == true && $game_switches[Mission::Two] == false
    $game_variables[Mission::Mission1] += 1
    if $game_variables[Mission::Mission1] == 4
      completeQuest(1)
    else
      advanceQuestToStage(1,$game_variables[Mission::Mission1])
    end
  elsif $game_switches[Mission::Two] == true && $game_switches[Mission::Three] == false
    $game_variables[Mission::Mission2] += 1
    advanceQuestToStage(3,$game_variables[Mission::Mission2])
  elsif $game_switches[Mission::Three] == true && $game_switches[Mission::Four] == false
    $game_variables[Mission::Mission3] += 1
    if $game_switches[Mission::Stella] == true
      advanceQuestToStage(5,$game_variables[Mission::Mission3])
    elsif $game_switches[Mission::Vinny] == true
      advanceQuestToStage(4,$game_variables[Mission::Mission3])
    end
  elsif $game_switches[Mission::Four] == true
    $game_variables[Mission::Mission4] += 1
    if $game_switches[Mission::Stella] == true
      advanceQuestToStage(7,$game_variables[Mission::Mission4])
    elsif $game_switches[Mission::Vinny] == true
      advanceQuestToStage(6,$game_variables[Mission::Mission4])
    end
    #elsif
    #written in to help me expand
  end
end

def pbNewMission(num)
  case num
  when 1
    $game_variables[Mission::Mission1] = 1
    activateQuest(1)
    $Trainer.badges[0] = true
    $game_switches[Mission::One] = true
    $game_variables[Chapter::Count] += 1
  when 2
    $game_variables[Mission::Mission2] = 1
    activateQuest(3)
    completeQuest(1)
    $Trainer.badges[1] = true
    $game_switches[Mission::Two] = true
    $game_variables[Chapter::Count] += 1
  when 3
    $game_variables[Mission::Mission3] = 1
    if $game_switches[Mission::Vinny]
      activateQuest(4)
    elsif $game_switches[Mission::Stella]
      activateQuest(5)
    end
    $Trainer.badges[2] = true
    completeQuest(3)
    $game_switches[Mission::Three] = true
    $game_variables[Chapter::Count] += 1
  when 4
    $game_variables[Mission::Mission4] = 1
    if $game_switches[Mission::Vinny]
      activateQuest(6)
    elsif $game_switches[Mission::Stella]
      activateQuest(7)
    end
    $Trainer.badges[3] = true
    if $game_switches[Mission::Vinny]
      completeQuest(4)
    elsif $game_switches[Mission::Stella]
      completeQuest(5)
    end
    $game_switches[Mission::Four] = true
    $game_variables[Chapter::Count] += 1
  when 0
    $game_switches[Readouts::Readout] = true
    activateQuest(2)
  when 8
    $game_switches[Mission::SideQuest] = true
    activateQuest(8)
  end
end

PluginManager.register({
  :name => "Mission Log",
  :version => "1.0",
  :credits => "Phantombass",
  :link => "No link yet",
  :dependencies => "Simple Quest UI"
})
