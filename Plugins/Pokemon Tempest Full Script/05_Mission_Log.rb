module Mission
  One = 504
  Two = 509
  Three = 520
  Four = 526
  Five = 541
  Mission1 = 503
  Mission2 = 504
  Mission3 = 505
  Mission4 = 507
  Mission5 = 508
  Stella = 517
  Vinny = 518
  SideQuest = 404
end

def pbMissionUpdate
  if $game_switches[Mission::One] == true && $game_switches[Mission::Two] == false
    if $game_variables[Mission::Mission1] == 4
      $game_variables[Mission::Mission1] += 0
    else
      $game_variables[Mission::Mission1] += 1
      $PokemonGlobal.quests.advanceQuestToStage(1,$game_variables[Mission::Mission1])
    end
  elsif $game_switches[Mission::Two] == true && $game_switches[Mission::Three] == false
    if $game_variables[Mission::Mission2] >= 2
      $game_variables[Mission::Mission2] += 0
    else
      $game_variables[Mission::Mission2] += 1
      $PokemonGlobal.quests.advanceQuestToStage(3,$game_variables[Mission::Mission2])
    end
  elsif $game_switches[Mission::Three] == true && $game_switches[Mission::Four] == false
    if $game_variables[Mission::Mission3] == 6
      $game_variables[Mission::Mission3] += 0
    else
      if $game_switches[Mission::Stella] == true
        $game_variables[Mission::Mission3] += 1
        $PokemonGlobal.quests.advanceQuestToStage(5,$game_variables[Mission::Mission3])
      elsif $game_switches[Mission::Vinny] == true
        $game_variables[Mission::Mission3] += 1
        $PokemonGlobal.quests.advanceQuestToStage(4,$game_variables[Mission::Mission3])
      end
    end
  elsif $game_switches[Mission::Four] == true && $game_switches[Mission::Five] == false
    if $game_variables[Mission::Mission4] == 10
      $game_variables[Mission::Mission4] += 0
    else
      if $game_switches[Mission::Stella] == true
        $game_variables[Mission::Mission4] += 1
        $PokemonGlobal.quests.advanceQuestToStage(7,$game_variables[Mission::Mission4])
      elsif $game_switches[Mission::Vinny] == true
        $game_variables[Mission::Mission4] += 1
        $PokemonGlobal.quests.advanceQuestToStage(6,$game_variables[Mission::Mission4])
      end
    end
  elsif $game_switches[Mission::Five] == true
    if $game_variables[Mission::Mission5] == 10
      $game_variables[Mission::Mission5] += 0
    else
      $game_variables[Mission::Mission5] += 1
      $PokemonGlobal.quests.advanceQuestToStage(10,$game_variables[Mission::Mission5])
    end
    #elsif
    #written in to help me expand
  end
end

def pbNewMission(num)
  case num
  when 1
    $game_variables[Mission::Mission1] = 1
    $PokemonGlobal.quests.activateQuest(1)
    $Trainer.badges[0] = true
    $game_switches[Mission::One] = true
    $game_variables[Chapter::Count] += 1
  when 2
    $game_variables[Mission::Mission2] = 1
    $PokemonGlobal.quests.activateQuest(3)
    $PokemonGlobal.quests.completeQuest(1)
    $Trainer.badges[1] = true
    $game_switches[Mission::Two] = true
    $game_variables[Chapter::Count] += 1
  when 3
    $game_variables[Mission::Mission3] = 1
    if $game_switches[Mission::Vinny]
      $PokemonGlobal.quests.activateQuest(4)
    elsif $game_switches[Mission::Stella]
      $PokemonGlobal.quests.activateQuest(5)
    end
    $Trainer.badges[2] = true
    $PokemonGlobal.quests.completeQuest(3)
    $game_switches[Mission::Three] = true
    $game_variables[Chapter::Count] += 1
  when 4
    $game_variables[Mission::Mission4] = 1
    if $game_switches[Mission::Vinny]
      $PokemonGlobal.quests.activateQuest(6)
    elsif $game_switches[Mission::Stella]
      $PokemonGlobal.quests.activateQuest(7)
    end
    $Trainer.badges[3] = true
    if $game_switches[Mission::Vinny]
      $PokemonGlobal.quests.completeQuest(4)
    elsif $game_switches[Mission::Stella]
      $PokemonGlobal.quests.completeQuest(5)
    end
    $game_switches[Mission::Four] = true
    $game_variables[Chapter::Count] += 1
  when 5
    $game_variables[Mission::Mission5] = 1
    if $game_switches[Mission::Vinny]
      $PokemonGlobal.quests.activateQuest(10)
    elsif $game_switches[Mission::Stella]
      $PokemonGlobal.quests.activateQuest(11)
    end
    $Trainer.badges[4] = true
    if $game_switches[Mission::Vinny]
      $PokemonGlobal.quests.completeQuest(6)
    elsif $game_switches[Mission::Stella]
      $PokemonGlobal.quests.completeQuest(7)
    end
    $game_switches[Mission::Five] = true
    $game_variables[Chapter::Count] += 1
  when 0
    $game_switches[Readouts::Readout] = true
    $PokemonGlobal.quests.activateQuest(2)
  when 8
    $game_switches[Mission::SideQuest] = true
    $PokemonGlobal.quests.activateQuest(8)
  end
end
