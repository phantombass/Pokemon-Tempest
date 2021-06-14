module QuestModule
  sqMap = pbGet(86)
  # You don't actually need to add any information, but the respective fields in the UI will be blank or "???"
  # I included this here mostly as an example of what not to do, but also to show it's a thing that exists
  Quest1 = {
    :ID => "1",
    :Name => "New Job",
    :QuestDescription => "Show Altemper to Professor Metto's colleagues!",
    :Stage1 => "Head north first!",
    :Stage2 => "Head south next!",
    :Stage3 => "Report back to Professor Metto!",
    :Location1 => "Snowcap Heights",
    :Location2 => "Wind-Torn Valley",
    :Location3 => "Shira Town"
  }

#====================================
  Quest2 = {
    :ID => "2",
    :Name => "Readout Hunt",
    :QuestDescription => "Find all the Weather Readouts!",
    :Stage1 => "Find all the Weather Readouts!",
  }

  #====================================
  Quest3 = {
  :ID => "3",
  :Name => "Rampaging Pokémon",
  :QuestDescription => "Begin your hunt for the Rampaging Pokémon!",
  :Stage1 => "Calm the first angry Pokémon!",
  :Stage2 => "Calm the next angry Pokémon!",
  :Stage3 => "Report back to Simon!",
  :Stage4 => "Choose an Expedition Team!",
  :Location1 => "Wind-Torn Valley",
  :Location2 => "Rainbow Cliffs",
  :Location3 => "Coastal Steppes",
  :Location4 => "Coastal Steppes"
}
  #====================================
  Quest4 = {
  :ID => "4",
  :Name => "Venom Expedition Team",
  :QuestDescription => "Begin your work as a Venom Expedition Team member!",
  :Stage1 => "Meet Vinny at the Northwest exit.",
  :Stage2 => "Head to the Haunted Forest!",
  :Stage3 => "Onward to Distura City!",
  :Stage4 => "Meet Vinny at Venom HQ!",
  :Stage5 => "Go investigate the Venom Lab!",
  :Stage6 => "Report back to Vinny!",
  :Location1 => "Coastal Steppes",
  :Location2 => "Haunted Forest",
  :Location3 => "Distura City",
  :Location4 => "Venom HQ",
  :Location5 => "Venom Lab",
  :Location6 => "Venom HQ"
}
  #====================================
  Quest5 = {
  :ID => "5",
  :Name => "Comet Expedition Team",
  :Stage1 => "Meet Stella at the Northeast exit.",
  :QuestDescription => "Begin your work as a Comet Expedition Team member!",
  :Stage2 => "Make your way through the Pixie Caverns!",
  :Stage3 => "Head on to Astral Peak!",
  :Stage4 => "Meet Stella at Comet HQ!",
  :Stage5 => "Go investigate the Comet Lab!",
  :Stage6 => "Report back to Stella!",
  :Location1 => "Coastal Steppes",
  :Location2 => "Pixie Caverns",
  :Location3 => "Astral Peak",
  :Location4 => "Comet HQ",
  :Location5 => "Comet Lab",
  :Location6 => "Comet HQ"
}
  #====================================
  Quest6 = {
  :ID => "6",
  :Name => "Problem at Mt. Sear",
  :QuestDescription => "Something fishy is happening at Mt. Sear! Head up the investigation as the Venom Expedition Team!",
  :Stage1 => "Meet Vinny at the Southwest exit.",
  :Stage2 => "Go to Mt. Sear base.",
  :Stage3 => "Scale Mt. Sear.",
  :Stage4 => "Calm Groudon down!",
  :Stage5 => "Meet Vinny back at HQ.",
  :Stage6 => "Head to Drakon Village.",
  :Stage7 => "Find the items for the Elder.",
  :Stage8 => "Speak to the Elder.",
  :Stage9 => "Head back to HQ.",
  :Stage10 => "Wait for instruction!",
  :Location1 => "Distura City",
  :Location2 => "Mt. Sear South Entrance",
  :Location3 => "Mt. Sear",
  :Location4 => "Mt. Sear Summit",
  :Location5 => "Venom HQ",
  :Location6 => "Drakon Village",
  :Location7 => "Drakon Mountain",
  :Location8 => "Drakon Village",
  :Location9 => "Venom HQ",
  :Location10 => "Distura City"
}
  #====================================
  Quest7 = {
  :ID => "7",
  :Name => "Problem at Mt. Sear",
  :QuestDescription => "Something fishy is happening at Mt. Sear! Head up the investigation as the Comet Expedition Team!",
  :Stage1 => "Meet Stella at the Northwest exit.",
  :Stage2 => "Go to Mt. Sear base.",
  :Stage3 => "Descend into Mt. Sear's core.",
  :Stage4 => "Calm Kyogre down!",
  :Stage5 => "Meet Stella back at HQ.",
  :Stage6 => "Head to Timeless Grotto.",
  :Stage7 => "Find the items for the Elder.",
  :Stage8 => "Speak to the Elder.",
  :Stage9 => "Head back to HQ.",
  :Stage10 => "Wait for instruction!",
  :Location1 => "Distura City",
  :Location2 => "Mt. Sear East Entrance",
  :Location3 => "Mt. Sear",
  :Location4 => "Mt. Sear Depths",
  :Location5 => "Comet HQ",
  :Location6 => "Timeless Grotto",
  :Location7 => "Timeless Chasm",
  :Location8 => "Timeless Grotto",
  :Location9 => "Comet HQ",
  :Location10 => "Astral Peak"
}
  #====================================
  Quest8 = {
  :ID => "8",
  :Name => "Side Quest: Wingsuit",
  :QuestDescription => "Time to build a Wingsuit! Find all the pieces!",
  :Stage1 => "Find all the Wingsuit pieces",
  :Stage2 => "Return to the Side Quest Captain!",
  :Location1 => "Last 3 Rampaging Pokémon locations"
}
  #====================================
  Quest9 = {
  :ID => "9",
  :Name => "Side Quest",
  :QuestDescription => "Help the Side Quest Captain complete missions as they come in!",
  :Stage1 => "Get your first Side Quest!",
  :Stage2 => "Rescue the little girl!",
  :Stage3 => "Find the troublesome Pokémon!",
  :Stage4 => "Find the lost item!",
  :Stage5 => "Talk to the Side Quest Captain!",
  :Stage6 => "Wait for the Captain to text again!",
  :Location1 => "Side Quest Captain",
  :Location2 => "#{sqMap}",
  :Location3 => "#{sqMap}",
  :Location4 => "#{sqMap}",
  :Location5 => "Side Quest Captain",
}
  #====================================
  Quest10 = {
  :ID => "10",
  :Name => "A Trip to New Lands",
  :QuestDescription => "It's time to head to new regions! Finding Aaron is your top priority!",
  :Stage1 => "Meet Cynthia.",
  :Stage2 => "Go to the Pokémon Center.",
  :Stage3 => "Catch up to Cynthia.",
  :Stage4 => "Make your way to Sephala!",
  :Stage5 => "Go to the Abandoned Galactic Lab.",
  :Stage6 => "Find Aaron.",
  :Stage7 => "Calm Dialga down!",
  :Stage8 => "Meet with Cynthia and your mother.",
  :Stage9 => "Wait for instructions from Cynthia!",
  :Location1 => "Coastal Steppes",
  :Location2 => "Coastal Steppes PMC",
  :Location3 => "Menzopolis Outlands",
  :Location4 => "Sephala",
  :Location5 => "Abandoned Galactic Lab",
  :Location6 => "Temporal Apex",
  :Location7 => "Temporal Apex",
  :Location8 => "Shira Town",
}
  #====================================
  Quest11 = {
  :ID => "11",
  :Name => "A Trip to New Lands",
  :QuestDescription => "It's time to head to new regions! Finding Aaron is your top priority!",
  :Stage1 => "Meet Cynthia.",
  :Stage2 => "Go to the Pokémon Center.",
  :Stage3 => "Catch up to Cynthia.",
  :Stage4 => "Make your way to Sephala!",
  :Stage5 => "Go to the Abandoned Galactic Lab.",
  :Stage6 => "Find Aaron.",
  :Stage7 => "Calm Dialga down!",
  :Stage8 => "Meet with Cynthia and your mother.",
  :Stage9 => "Wait for instructions from Cynthia!",
  :Location1 => "Coastal Steppes",
  :Location2 => "Coastal Steppes PMC",
  :Location3 => "Menzopolis Outlands",
  :Location4 => "Sephala",
  :Location5 => "Abandoned Galactic Lab",
  :Location6 => "Spacial Plateau",
  :Location7 => "Spacial Plateau",
  :Location8 => "Shira Town",
}
  #====================================
  Quest12 = {
  :ID => "12",
  :Name => "Hunt Across Time and Space",
  :Stage1 => "Calm the rampaging Pokémon.",
  :Stage2 => "Go back to Cynthia's villa.",
  :Stage3 => "Chase Aaron and Team Maelstrom!",
  :Stage4 => "Head to the North Zharo Sea.",
  :Stage5 => "Reach the Thera Comet.",
  :Stage6 => "Find Aaron.",
  :Stage7 => "Calm Giratina down!",
  :Stage8 => "Debrief with Cynthia.",
  :Stage9 => "Meet the Quad-Region Elders.",
  :Stage10 => "Challenge and defeat the Quad-Region Elders.",
  :Location1 => "Pixie Caverns, Comet HQ, Mt. Sear Depths",
  :Location2 => "Coastal Steppes",
  :Location3 => "Temporal Apex",
  :Location4 => "Shira Town",
  :Location5 => "Thera Comet",
  :Location6 => "Distortion World",
  :Location7 => "Distortion World",
  :Location8 => "Coastal Steppes",
  :Location9 => "Reverb Mountain",
  :Location10 => "Quarta Castle"
}
  #====================================
  Quest13 = {
  :ID => "13",
  :Name => "Hunt Across Time and Space",
  :Stage1 => "Calm the rampaging Pokémon.",
  :Stage2 => "Go back to Cynthia's villa.",
  :Stage3 => "Chase Aaron and Team Maelstrom!",
  :Stage4 => "Head to the North Zharo Sea.",
  :Stage5 => "Reach the Thera Comet.",
  :Stage6 => "Find Aaron.",
  :Stage7 => "Calm Giratina down!",
  :Stage8 => "Debrief with Cynthia.",
  :Stage9 => "Meet the Quad-Region Elders.",
  :Stage10 => "Challenge and defeat the Quad-Region Elders.",
  :Location1 => "Haunted Forest, Venom HQ, Mt. Sear Summit",
  :Location2 => "Coastal Steppes",
  :Location3 => "Temporal Apex",
  :Location4 => "Shira Town",
  :Location5 => "Thera Comet",
  :Location6 => "Distortion World",
  :Location7 => "Distortion World",
  :Location8 => "Coastal Steppes",
  :Location9 => "Reverb Mountain",
  :Location10 => "Quarta Castle"
  }
#====================================
end
