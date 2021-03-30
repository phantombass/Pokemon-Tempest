Events.onWildPokemonCreate += proc {| sender, e |
  pkmn = e[0]
  if $game_switches[82]
    $game_switches[81] = true
    pkmn.setAbility(2)
    pkmn.calcStats
  end
}
