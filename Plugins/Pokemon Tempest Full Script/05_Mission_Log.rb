module Mission
  One = 504
  Two = 509
  Three = 520
  Four = 526
  Five = 541
  Six = 557
  Mission1 = 503
  Mission2 = 504
  Mission3 = 505
  Mission4 = 507
  Mission5 = 508
  Mission6 = 511
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
      $PokemonGlobal.quests.advanceQuestToStage(:Quest1,$game_variables[Mission::Mission1],"463F0000",false)
    end
  elsif $game_switches[Mission::Two] == true && $game_switches[Mission::Three] == false
    if $game_variables[Mission::Mission2] >= 4
      $game_variables[Mission::Mission2] += 0
    else
      $game_variables[Mission::Mission2] += 1
      $PokemonGlobal.quests.advanceQuestToStage(:Quest3,$game_variables[Mission::Mission2],"463F0000",false)
    end
  elsif $game_switches[Mission::Three] == true && $game_switches[Mission::Four] == false
    if $game_variables[Mission::Mission3] == 6
      $game_variables[Mission::Mission3] += 0
    else
      if $game_switches[Mission::Stella] == true
        $game_variables[Mission::Mission3] += 1
        $PokemonGlobal.quests.advanceQuestToStage(:Quest5,$game_variables[Mission::Mission3],"463F0000",false)
      elsif $game_switches[Mission::Vinny] == true
        $game_variables[Mission::Mission3] += 1
        $PokemonGlobal.quests.advanceQuestToStage(:Quest4,$game_variables[Mission::Mission3],"463F0000",false)
      end
    end
  elsif $game_switches[Mission::Four] == true && $game_switches[Mission::Five] == false
    if $game_variables[Mission::Mission4] == 10
      $game_variables[Mission::Mission4] += 0
    else
      if $game_switches[Mission::Stella] == true
        $game_variables[Mission::Mission4] += 1
        $PokemonGlobal.quests.advanceQuestToStage(:Quest7,$game_variables[Mission::Mission4],"463F0000",false)
      elsif $game_switches[Mission::Vinny] == true
        $game_variables[Mission::Mission4] += 1
        $PokemonGlobal.quests.advanceQuestToStage(:Quest6,$game_variables[Mission::Mission4],"463F0000",false)
      end
    end
  elsif $game_switches[Mission::Five] == true && $game_switches[Mission::Six] == false
    if $game_variables[Mission::Mission5] == 9
      $game_variables[Mission::Mission5] += 0
    else
      if $game_switches[Mission::Stella] == true
        $game_variables[Mission::Mission5] += 1
        $PokemonGlobal.quests.advanceQuestToStage(:Quest11,$game_variables[Mission::Mission5],"463F0000",false)
      elsif $game_switches[Mission::Vinny] == true
        $game_variables[Mission::Mission5] += 1
        $PokemonGlobal.quests.advanceQuestToStage(:Quest10,$game_variables[Mission::Mission5],"463F0000",false)
      end
    end
  elsif $game_switches[Mission::Six] == true
    if $game_variables[Mission::Mission6] == 10
      $game_variables[Mission::Mission6] += 0
    else
      if $game_switches[Mission::Stella] == true
        $game_variables[Mission::Mission6] += 1
        $PokemonGlobal.quests.advanceQuestToStage(:Quest13,$game_variables[Mission::Mission6],"463F0000",false)
      elsif $game_switches[Mission::Vinny] == true
        $game_variables[Mission::Mission6] += 1
        $PokemonGlobal.quests.advanceQuestToStage(:Quest12,$game_variables[Mission::Mission6],"463F0000",false)
      end
    end
    #elsif
    #written in to help me expand
  end
end

def pbNewMission(num)
  case num
  when 1
    $game_variables[Mission::Mission1] = 1
    $Trainer.badges[0] = true
    $game_switches[Mission::One] = true
    $game_variables[Chapter::Count] = 1
    $PokemonGlobal.quests.activateQuest(:Quest1,"56946F5A",false)
  when 2
    $game_variables[Mission::Mission2] = 1
    $PokemonGlobal.quests.completeQuest(:Quest1,"26CC4B56",false)
    $Trainer.badges[1] = true
    $game_switches[Mission::Two] = true
    $game_variables[Chapter::Count] = 2
    $PokemonGlobal.quests.activateQuest(:Quest3,"56946F5A",false)
  when 3
    $game_variables[Mission::Mission3] = 1
    $Trainer.badges[2] = true
    $PokemonGlobal.quests.completeQuest(:Quest3,"26CC4B56",false)
    $game_switches[Mission::Three] = true
    $game_variables[Chapter::Count] = 3
    if $game_switches[Mission::Vinny]
      $PokemonGlobal.quests.activateQuest(:Quest4,"56946F5A",false)
    elsif $game_switches[Mission::Stella]
      $PokemonGlobal.quests.activateQuest(:Quest5,"56946F5A",false)
    end
  when 4
    $game_variables[Mission::Mission4] = 1
    $Trainer.badges[3] = true
    $game_switches[Mission::Four] = true
    $game_variables[Chapter::Count] = 4
    if $game_switches[Mission::Vinny]
      $PokemonGlobal.quests.activateQuest(:Quest6,"56946F5A",false)
    elsif $game_switches[Mission::Stella]
      $PokemonGlobal.quests.activateQuest(:Quest7,"56946F5A",false)
    end
    if $game_switches[Mission::Vinny]
      $PokemonGlobal.quests.completeQuest(:Quest4,"26CC4B56",false)
    elsif $game_switches[Mission::Stella]
      $PokemonGlobal.quests.completeQuest(:Quest5,"26CC4B56",false)
    end
  when 5
    $game_variables[Mission::Mission5] = 1
    $Trainer.badges[4] = true
    $game_switches[Mission::Five] = true
    $game_variables[Chapter::Count] = 5
    if $game_switches[Mission::Vinny]
      $PokemonGlobal.quests.activateQuest(:Quest10,"56946F5A",false)
    elsif $game_switches[Mission::Stella]
      $PokemonGlobal.quests.activateQuest(:Quest11,"56946F5A",false)
    end
    if $game_switches[Mission::Vinny]
      $PokemonGlobal.quests.completeQuest(:Quest6,"26CC4B56",false)
    elsif $game_switches[Mission::Stella]
      $PokemonGlobal.quests.completeQuest(:Quest7,"26CC4B56",false)
    end
  when 6
    $game_variables[Mission::Mission6] = 1
    $Trainer.badges[5] = true
    $game_switches[Mission::Six] = true
    $game_variables[Chapter::Count] = 6
    if $game_switches[Mission::Vinny]
      $PokemonGlobal.quests.activateQuest(:Quest12,"56946F5A",false)
    elsif $game_switches[Mission::Stella]
      $PokemonGlobal.quests.activateQuest(:Quest13,"56946F5A",false)
    end
    if $game_switches[Mission::Vinny]
      $PokemonGlobal.quests.completeQuest(:Quest10,"26CC4B56",false)
    elsif $game_switches[Mission::Stella]
      $PokemonGlobal.quests.completeQuest(:Quest11,"26CC4B56",false)
    end
    $PokemonGlobal.encounter_version = 1
  when 0
    $game_switches[Readouts::Readout] = true
    $PokemonGlobal.quests.activateQuest(:Quest2,"56946F5A",false)
  when 8
    $game_switches[Mission::SideQuest] = true
    $PokemonGlobal.quests.activateQuest(:Quest8,"56946F5A",false)
  end
end
