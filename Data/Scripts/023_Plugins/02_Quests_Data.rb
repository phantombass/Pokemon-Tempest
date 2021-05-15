module QuestsData

    QUEST1 = {
      "ID" => "1",
      "Name" => "New Job",
      "Stage1" => "Go show Altemper to Professor Metto's colleague in the North.",
      "Stage2" => "Just one more colleague to speak to! Head south of Shira Town!",
      "Stage3" => "Go report back to Professor Metto in Shira Town!"
    }

    #====================================
      QUEST2 = {
        "ID" => "2",
        "Name" => "Readout Hunt",
        "Stage1" => "Find all the Weather Readouts!"
      }

      #====================================
      QUEST3 = {
      "ID" => "3",
      "Name" => "Rampaging Pokémon",
      "Stage1" => "Calm the angry Pokémon inside the Valley Mine.",
      "Stage2" => "Calm the angry Pokémon at Coastal Steppes!",
      "Stage3" => "Report back to Simon at the Museum!",
      "Stage4" => "Choose an Expedition Team to join up with!"
    }
      #====================================
      QUEST4 = {
      "ID" => "4",
      "Name" => "Venom Expedition Team",
      "Stage1" => "Meet Vinny at the Northwest exit.",
      "Stage2" => "Make your way through the Haunted Forest!",
      "Stage3" => "Head on to Distura City!",
      "Stage4" => "Meet Vinny at Venom HQ!",
      "Stage5" => "Go investigate the Venom Lab!",
      "Stage6" => "Report back to Vinny!"
    }
      #====================================
      QUEST5 = {
      "ID" => "5",
      "Name" => "Comet Expedition Team",
      "Stage1" => "Meet Stella at the Northeast exit.",
      "Stage2" => "Make your way through the Pixie Caverns!",
      "Stage3" => "Head on to Astral Peak!",
      "Stage4" => "Meet Stella at Comet HQ!"
    }
      #====================================
      QUEST6 = {
      "ID" => "6",
      "Name" => "Problem at Mt. Sear S",
      "Stage1" => "Meet Vinny at the Southwest exit of Distura City.",
      "Stage2" => "Go to Mt. Sear base to meet up with Vinny.",
      "Stage3" => "Scale Mt. Sear.",
      "Stage4" => "Calm Groudon down!",
      "Stage5" => "Meet Vinny back at HQ.",
      "Stage6" => "Head to Drakon Village.",
      "Stage7" => "Find the items for the Elder.",
      "Stage8" => "Speak to the Elder.",
      "Stage9" => "Head back to HQ.",
      "Stage10" => "Wait for instruction on the next Mission!"
    }
      #====================================
      QUEST7 = {
      "ID" => "7",
      "Name" => "Problem at Mt. Sear E",
      "Stage1" => "Meet Stella at the Northwest exit of Astral Peak.",
      "Stage2" => "Go to Mt. Sear base to meet up with Stella.",
      "Stage3" => "Descend into Mt. Sear's core.",
      "Stage4" => "Calm Kyogre down!",
      "Stage5" => "Meet Stella back at HQ.",
      "Stage6" => "Head to Timeless Grotto.",
      "Stage7" => "Find the items for the Elder.",
      "Stage8" => "Speak to the Elder.",
      "Stage9" => "Head back to HQ.",
      "Stage10" => "Wait for instruction on the next Mission!"
    }
      #====================================
      QUEST8 = {
      "ID" => "8",
      "Name" => "Side Quest: Wingsuit",
      "Stage1" => "Find all the Wingsuit pieces",
      "Stage2" => "Return to the Side Quest Captain!"
    }
      #====================================
      QUEST9 = {
      "ID" => "9",
      "Name" => "Side Quest",
      "Stage1" => "Get your first Side Quest!",
      "Stage2" => "Rescue the little girl!",
      "Stage3" => "Find the troublesome Pokémon!",
      "Stage4" => "Find the lost item!",
      "Stage5" => "Talk to the Side Quest Captain!",
      "Stage6" => "Wait for the Captain to text again!"
    }
      #====================================
      QUEST10 = {
      "ID" => "10",
      "Name" => "A Trip to New Lands",
      "Stage1" => "Meet Cynthia at her villa in Coastal Steppes.",
      "Stage2" => "Go to the Pokémon Center in Coastal Steppes.",
      "Stage3" => "Meet Cynthia in the Menzopolis Outlands.",
      "Stage4" => "Make your way to Sephala in Tinjo!",
      "Stage5" => "Go to the Abandoned Galactic Lab.",
      "Stage6" => "Enter the Distortion World and find Aaron.",
      "Stage7" => proc do
        if $game_switches[517]
          "Calm Palkia down."
        elsif $game_switches[518]
          "Calm Dialga down."
        end
      end,
      "Stage8" => "Head to Menzopolis to meet with Cynthia.",
      "Stage9" => "Explore Tinjo and the Distortion World as you wait for instructions on the next Mission from Cynthia!"
    }
#====================================

#DO NOT REMOVE THE END!!!!!!!!
end
