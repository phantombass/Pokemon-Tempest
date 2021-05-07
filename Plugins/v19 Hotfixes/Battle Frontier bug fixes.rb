#==============================================================================
# "v19 Hotfixes" plugin
# This file contains fixes for bugs relating to the Battle Facilities.
# These bug fixes are also in the master branch of the GitHub version of
# Essentials:
# https://github.com/Maruno17/pokemon-essentials
#==============================================================================



#==============================================================================
# Fixes for Battle Palace.
#==============================================================================
class PokeBattle_BattlePalace < PokeBattle_Battle
  @@BattlePalaceUsualTable = {
    :HARDY   => [61,  7, 32],
    :LONELY  => [20, 25, 55],
    :BRAVE   => [70, 15, 15],
    :ADAMANT => [38, 31, 31],
    :NAUGHTY => [20, 70, 10],
    :BOLD    => [30, 20, 50],
    :DOCILE  => [56, 22, 22],
    :RELAXED => [25, 15, 60],
    :IMPISH  => [69,  6, 25],
    :LAX     => [35, 10, 55],
    :TIMID   => [62, 10, 28],
    :HASTY   => [58, 37,  5],
    :SERIOUS => [34, 11, 55],
    :JOLLY   => [35,  5, 60],
    :NAIVE   => [56, 22, 22],
    :MODEST  => [35, 45, 20],
    :MILD    => [44, 50,  6],
    :QUIET   => [56, 22, 22],
    :BASHFUL => [30, 58, 12],
    :RASH    => [30, 13, 57],
    :CALM    => [40, 50, 10],
    :GENTLE  => [18, 70, 12],
    :SASSY   => [88,  6,  6],
    :CAREFUL => [42, 50,  8],
    :QUIRKY  => [56, 22, 22]
  }
  @@BattlePalacePinchTable = {
    :HARDY   => [61,  7, 32],
    :LONELY  => [84,  8,  8],
    :BRAVE   => [32, 60,  8],
    :ADAMANT => [70, 15, 15],
    :NAUGHTY => [70, 22,  8],
    :BOLD    => [32, 58, 10],
    :DOCILE  => [56, 22, 22],
    :RELAXED => [75, 15, 10],
    :IMPISH  => [28, 55, 17],
    :LAX     => [29,  6, 65],
    :TIMID   => [30, 20, 50],
    :HASTY   => [88,  6,  6],
    :SERIOUS => [29, 11, 60],
    :JOLLY   => [35, 60,  5],
    :NAIVE   => [56, 22, 22],
    :MODEST  => [34, 60,  6],
    :MILD    => [34,  6, 60],
    :QUIET   => [56, 22, 22],
    :BASHFUL => [30, 58, 12],
    :RASH    => [27,  6, 67],
    :CALM    => [25, 62, 13],
    :GENTLE  => [90,  5,  5],
    :SASSY   => [22, 20, 58],
    :CAREFUL => [42,  5, 53],
    :QUIRKY  => [56, 22, 22]
  }

  def pbAutoFightMenu(idxBattler)
    this_battler = @battlers[idxBattler]
    nature = this_battler.nature.id
    randnum = @battleAI.pbAIRandom(100)
    category = 0
    atkpercent = 0
    defpercent = 0
    if this_battler.effects[PBEffects::Pinch]
      atkpercent = @@BattlePalacePinchTable[nature][0]
      defpercent = atkpercent+@@BattlePalacePinchTable[nature][1]
    else
      atkpercent = @@BattlePalaceUsualTable[nature][0]
      defpercent = atkpercent+@@BattlePalaceUsualTable[nature][1]
    end
    if randnum<atkpercent
      category = 0
    elsif randnum<atkpercent+defpercent
      category = 1
    else
      category = 2
    end
    moves = []
    for i in 0...this_battler.moves.length
      next if !pbCanChooseMovePartial?(idxBattler,i)
      next if pbMoveCategory(this_battler.moves[i])!=category
      moves[moves.length] = i
    end
    if moves.length==0
      # No moves of selected category
      pbRegisterMove(idxBattler,-2)
    else
      chosenmove = moves[@battleAI.pbAIRandom(moves.length)]
      pbRegisterMove(idxBattler,chosenmove)
    end
    return true
  end

  def pbPinchChange(battler)
    return if !battler || battler.fainted?
    return if battler.effects[PBEffects::Pinch] || battler.status == :SLEEP
    return if battler.hp > battler.totalhp / 2
    nature = battler.nature.id
    battler.effects[PBEffects::Pinch] = true
    case nature
    when :QUIET, :BASHFUL, :NAIVE, :QUIRKY, :HARDY, :DOCILE, :SERIOUS
      pbDisplay(_INTL("{1} is eager for more!", battler.pbThis))
    when :CAREFUL, :RASH, :LAX, :SASSY, :MILD, :TIMID
      pbDisplay(_INTL("{1} began growling deeply!", battler.pbThis))
    when :GENTLE, :ADAMANT, :HASTY, :LONELY, :RELAXED, :NAUGHTY
      pbDisplay(_INTL("A glint appears in {1}'s eyes!", battler.pbThis(true)))
    when :JOLLY, :BOLD, :BRAVE, :CALM, :IMPISH, :MODEST
      pbDisplay(_INTL("{1} is getting into position!", battler.pbThis))
    end
  end

  def pbEndOfRoundPhase
    super
    return if @decision != 0
    eachBattler { |b| pbPinchChange(b) }
  end
end

#==============================================================================
# Fixes for battle recording.
#==============================================================================
module PokeBattle_RecordedBattleModule
  def pbGetTrainerInfo(trainer)
    return nil if !trainer
    if trainer.is_a?(Array)
      ret = []
      for i in 0...trainer.length
        if trainer[i].is_a?(Player)
          ret.push([trainer[i].trainer_type,trainer[i].name.clone,trainer[i].id,trainer[i].badges.clone])
        else   # NPCTrainer
          ret.push([trainer[i].trainer_type,trainer[i].name.clone,trainer[i].id])
        end
      end
      return ret
    elsif trainer[i].is_a?(Player)
      return [[trainer.trainer_type,trainer.name.clone,trainer.id,trainer.badges.clone]]
    else
      return [[trainer.trainer_type,trainer.name.clone,trainer.id]]
    end
  end
end

module BattlePlayerHelper
  def self.pbCreateTrainerInfo(trainer)
    return nil if !trainer
    ret = []
    trainer.each do |tr|
      if tr.length == 4   # Player
        t = Player.new(tr[1], tr[0])
        t.id     = tr[2]
        t.badges = tr[3]
        ret.push(t)
      else   # NPCTrainer
        t = NPCTrainer.new(tr[1], tr[0])
        t.id = tr[2]
        ret.push(t)
      end
    end
    return ret
  end
end

#==============================================================================
# Fixed the definitions of Battle Facilities Pokémon.
#==============================================================================
class PBPokemon
  def initialize(species,item,nature,move1,move2,move3,move4,ev)
    @species = species
    itm = GameData::Item.try_get(item)
    @item = itm ? itm.id : nil
    @nature = nature
    @move1 = move1 ? move1 : nil
    @move2 = move2 ? move2 : nil
    @move3 = move3 ? move3 : nil
    @move4 = move4 ? move4 : nil
    @ev = ev
  end

  def self.fromInspected(str)
    insp=str.gsub(/^\s+/,"").gsub(/\s+$/,"")
    pieces=insp.split(/\s*;\s*/)
    species = (GameData::Species.exists?(pieces[0])) ? GameData::Species.get(pieces[0]).id : nil
    item = (GameData::Item.exists?(pieces[1])) ? GameData::Item.get(pieces[1]).id : nil
    nature = (GameData::Nature.exists?(pieces[2])) ? GameData::Nature.get(pieces[2]).id : nil
    ev = pieces[3].split(/\s*,\s*/)
    ev_array = []
    ev.each do |stat|
      case stat.upcase
      when "HP"          then ev_array.push(:HP)
      when "ATK"         then ev_array.push(:ATTACK)
      when "DEF"         then ev_array.push(:DEFENSE)
      when "SA", "SPATK" then ev_array.push(:SPECIAL_ATTACK)
      when "SD", "SPDEF" then ev_array.push(:SPECIAL_DEFENSE)
      when "SPD"         then ev_array.push(:SPEED)
      end
    end
    moves=pieces[4].split(/\s*,\s*/)
    moveid=[]
    for i in 0...Pokemon::MAX_MOVES
      move_data = GameData::Move.try_get(moves[i])
      moveid.push(move_data.id) if move_data
    end
    if moveid.length==0
      GameData::Move.each { |mov| moveid.push(mov.id); break }
    end
    return self.new(species, item, nature, moveid[0], moveid[1], moveid[2], moveid[3], ev_array)
  end

  def createPokemon(level,iv,trainer)
    pokemon=Pokemon.new(@species,level,trainer,false)
    pokemon.item = @item
    pokemon.personalID = rand(2**16) | rand(2**16) << 16
    pokemon.nature = nature
    pokemon.happiness=0
    pokemon.moves[0] = Pokemon::Move.new(self.convertMove(@move1))
    pokemon.moves[1] = (@move2) ? Pokemon::Move.new(self.convertMove(@move2)) : nil
    pokemon.moves[2] = (@move3) ? Pokemon::Move.new(self.convertMove(@move3)) : nil
    pokemon.moves[3] = (@move4) ? Pokemon::Move.new(self.convertMove(@move4)) : nil
    pokemon.moves.compact!
    if ev.length > 0
      ev.each { |stat| pokemon.ev[stat] = Pokemon::EV_LIMIT / ev.length }
    end
    GameData::Stat.each_main { |s| pokemon.iv[s.id] = iv }
    pokemon.calc_stats
    return pokemon
  end
end

#==============================================================================
# Fixed crash when starting a battle challenge.
#==============================================================================
class BattleChallenge
  def start(*args)
    t = ensureType(@id)
    @currentChallenge=@id   # must appear before pbStart
    @bc.pbStart(t,@numRounds)
  end
end

#==============================================================================
# Fixed Battle Facilities not getting the correct charsets for the opponents.
#==============================================================================
module GameData
  class TrainerType
    def self.check_file(tr_type, path, optional_suffix = "", suffix = "")
      tr_type_data = self.try_get(tr_type)
      return nil if tr_type_data.nil?
      # Check for files
      if optional_suffix && !optional_suffix.empty?
        ret = path + tr_type_data.id.to_s + optional_suffix + suffix
        return ret if pbResolveBitmap(ret)
        ret = path + sprintf("%03d", tr_type_data.id_number) + optional_suffix + suffix
        return ret if pbResolveBitmap(ret)
      end
      ret = path + tr_type_data.id.to_s + suffix
      return ret if pbResolveBitmap(ret)
      ret = path + sprintf("%03d", tr_type_data.id_number) + suffix
      return (pbResolveBitmap(ret)) ? ret : nil
    end
  end
end

def pbBattleChallengeGraphic(event)
  nextTrainer=pbBattleChallenge.nextTrainer
  bttrainers=pbGetBTTrainers(pbBattleChallenge.currentChallenge)
  filename=GameData::TrainerType.charset_filename_brief((bttrainers[nextTrainer][0] rescue nil))
  begin
    filename = "NPC 01" if nil_or_empty?(filename)
    bitmap=AnimatedBitmap.new("Graphics/Characters/"+filename)
    bitmap.dispose
    event.character_name=filename
  rescue
    event.character_name="NPC 01"
  end
end

#==============================================================================
# Fixes for bugs when generating trainers/Pokémon for Battle Facilities.
#==============================================================================
def pbRandomMove
  keys = GameData::Move::DATA.keys
  loop do
    move_id = keys[rand(keys.length)]
    move = GameData::Move.get(move_id)
    next if move.id_number > 384 || move.id == :SKETCH || move.id == :STRUGGLE
    return move.id
  end
end

def pbRandomPokemonFromRule(rule,trainer)
  pkmn=nil
  i=0
  iteration=-1
  loop do
    iteration+=1
    species=nil
    level=rule.ruleset.suggestedLevel
    keys = GameData::Species::DATA.keys
    loop do
      loop do
        species = keys[rand(keys.length)]
        break if GameData::Species.get(species).form == 0
      end
      r=rand(20)
      bst=baseStatTotal(species)
      next if level<minimumLevel(species)
      if iteration%2==0
        next if r<16 && bst<400
        next if r<13 && bst<500
      else
        next if bst>400
        next if r<10 && babySpecies(species)!=species
      end
      next if r<10 && babySpecies(species)==species
      next if r<7 && evolutions(species).length>0
      break
    end
    ev = []
    GameData::Stat.each_main { |s| ev.push(s.id) if rand(100) < 50 }
    nature = nil
    keys = GameData::Nature::DATA.keys
    loop do
      nature = keys[rand(keys.length)]
      nature_data = GameData::Nature.get(nature)
      if [:LAX, :GENTLE].include?(nature_data.id) || nature_data.stat_changes.length == 0
        next if rand(20) < 19
      else
        raised_emphasis = false
        lowered_emphasis = false
        nature_data.stat_changes.each do |change|
          next if !ev.include?(change[0])
          raised_emphasis = true if change[1] > 0
          lowered_emphasis = true if change[1] < 0
        end
        next if rand(10) < 6 && !raised_emphasis
        next if rand(10) < 9 && lowered_emphasis
      end
      break
    end
    item = nil
    $legalMoves={} if level!=$legalMovesLevel
    $legalMoves[species]=pbGetLegalMoves2(species,level) if !$legalMoves[species]
    itemlist=[
       :ORANBERRY,:SITRUSBERRY,:ADAMANTORB,:BABIRIBERRY,
       :BLACKSLUDGE,:BRIGHTPOWDER,:CHESTOBERRY,:CHOICEBAND,
       :CHOICESCARF,:CHOICESPECS,:CHOPLEBERRY,:DAMPROCK,
       :DEEPSEATOOTH,:EXPERTBELT,:FLAMEORB,:FOCUSSASH,
       :FOCUSBAND,:HEATROCK,:LEFTOVERS,:LIFEORB,:LIGHTBALL,
       :LIGHTCLAY,:LUMBERRY,:OCCABERRY,:PETAYABERRY,:SALACBERRY,
       :SCOPELENS,:SHEDSHELL,:SHELLBELL,:SHUCABERRY,:LIECHIBERRY,
       :SILKSCARF,:THICKCLUB,:TOXICORB,:WIDELENS,:YACHEBERRY,
       :HABANBERRY,:SOULDEW,:PASSHOBERRY,:QUICKCLAW,:WHITEHERB
    ]
    # Most used: Leftovers, Life Orb, Choice Band, Choice Scarf, Focus Sash
    loop do
      if rand(40)==0
        item = :LEFTOVERS
        break
      end
      item = itemlist[rand(itemlist.length)]
      next if !item
      case item
      when :LIGHTBALL
        next if species != :PIKACHU
      when :SHEDSHELL
        next if species != :FORRETRESS && species != :SKARMORY
      when :SOULDEW
        next if species != :LATIOS && species != :LATIAS
      when :FOCUSSASH
        next if baseStatTotal(species)>450 && rand(10)<8
      when :ADAMANTORB
        next if species != :DIALGA
      when :PASSHOBERRY
        next if species != :STEELIX
      when :BABIRIBERRY
        next if species != :TYRANITAR
      when :HABANBERRY
        next if species != :GARCHOMP
      when :OCCABERRY
        next if species != :METAGROSS
      when :CHOPLEBERRY
        next if species != :UMBREON
      when :YACHEBERRY
        next if species != :TORTERRA && species != :GLISCOR && species != :DRAGONAIR
      when :SHUCABERRY
        next if species != :HEATRAN
      when :DEEPSEATOOTH
        next if species != :CLAMPERL
      when :THICKCLUB
        next if species != :CUBONE && species != :MAROWAK
      when :LIECHIBERRY
        ev.push(:ATTACK) if !ev.include?(:ATTACK) && rand(100) < 50
      when :SALACBERRY
        ev.push(:SPEED) if !ev.include?(:SPEED) && rand(100) < 50
      when :PETAYABERRY
        ev.push(:SPECIAL_ATTACK) if !ev.include?(:SPECIAL_ATTACK) && rand(100) < 50
      end
      break
    end
    if level < 10 && GameData::Item.exists?(:ORANBERRY)
      item = :ORANBERRY if rand(40) == 0 || item == :SITRUSBERRY
    elsif level > 20 && GameData::Item.exists?(:SITRUSBERRY)
      item = :SITRUSBERRY if rand(40) == 0 || item == :ORANBERRY
    end
    moves=$legalMoves[species]
    sketch=false
    if moves[0] == :SKETCH
      sketch=true
      for i in 0...Pokemon::MAX_MOVES
        moves[i]=pbRandomMove
      end
    end
    next if moves.length==0
    if (moves|[]).length<Pokemon::MAX_MOVES
      moves=[:TACKLE] if moves.length==0
      moves|=[]
    else
      newmoves=[]
      rest=GameData::Move.exists?(:REST) ? :REST : nil
      spitup=GameData::Move.exists?(:SPITUP) ? :SPITUP : nil
      swallow=GameData::Move.exists?(:SWALLOW) ? :SWALLOW : nil
      stockpile=GameData::Move.exists?(:STOCKPILE) ? :STOCKPILE : nil
      snore=GameData::Move.exists?(:SNORE) ? :SNORE : nil
      sleeptalk=GameData::Move.exists?(:SLEEPTALK) ? :SLEEPTALK : nil
      loop do
        newmoves.clear
        while newmoves.length<[moves.length,Pokemon::MAX_MOVES].min
          m=moves[rand(moves.length)]
          next if rand(2)==0 && hasMorePowerfulMove(moves,m)
          newmoves.push(m) if m && !newmoves.include?(m)
        end
        if (newmoves.include?(spitup) ||
           newmoves.include?(swallow)) && !newmoves.include?(stockpile)
          next unless sketch
        end
        if (!newmoves.include?(spitup) && !newmoves.include?(swallow)) &&
           newmoves.include?(stockpile)
          next unless sketch
        end
        if newmoves.include?(sleeptalk) && !newmoves.include?(rest)
          next unless (sketch || !moves.include?(rest)) && rand(10)<2
        end
        if newmoves.include?(snore) && !newmoves.include?(rest)
          next unless (sketch || !moves.include?(rest)) && rand(10)<2
        end
        totalbasedamage=0
        hasPhysical=false
        hasSpecial=false
        hasNormal=false
        for move in newmoves
          d=GameData::Move.get(move)
          totalbasedamage+=d.base_damage
          if d.base_damage>=1
            hasNormal=true if d.type == :NORMAL
            hasPhysical=true if d.category==0
            hasSpecial=true if d.category==1
          end
        end
        if !hasPhysical && ev.include?(:ATTACK)
          # No physical attack, but emphasizes Attack
          next if rand(10)<8
        end
        if !hasSpecial && ev.include?(:SPECIAL_ATTACK)
          # No special attack, but emphasizes Special Attack
          next if rand(10)<8
        end
        r=rand(10)
        next if r>6 && totalbasedamage>180
        next if r>8 && totalbasedamage>140
        next if totalbasedamage==0 && rand(20)!=0
        ############
        # Moves accepted
        if hasPhysical && !hasSpecial
          ev.push(:ATTACK) if rand(10)<8
          ev.delete(:SPECIAL_ATTACK) if rand(10)<8
        end
        if !hasPhysical && hasSpecial
          ev.delete(:ATTACK) if rand(10)<8
          ev.push(:SPECIAL_ATTACK) if rand(10)<8
        end
        item = :LEFTOVERS if !hasNormal && item == :SILKSCARF
        moves=newmoves
        break
      end
    end
    if item == :LIGHTCLAY && !moves.any? { |m| m == :LIGHTSCREEN || m = :REFLECT }
      item = :LEFTOVERS
    end
    if item == :BLACKSLUDGE
      type1 = GameData::Species.get(species).type1
      type2 = GameData::Species.get(species).type2 || type1
      item = :LEFTOVERS if type1 != :POISON && type2 != :POISON
    end
    if item == :HEATROCK && !moves.any? { |m| m == :SUNNYDAY }
      item = :LEFTOVERS
    end
    if item == :DAMPROCK && !moves.any? { |m| m == :RAINDANCE }
      item = :LEFTOVERS
    end
    if moves.any? { |m| m == :REST }
       item = :LUMBERRY if rand(3)==0
       item = :CHESTOBERRY if rand(4)==0
    end
    pk = PBPokemon.new(species, item, nature, moves[0], moves[1], moves[2], moves[3], ev)
    pkmn = pk.createPokemon(level, 31, trainer)
    i += 1
    break if rule.ruleset.isPokemonValid?(pkmn)
  end
  return pkmn
end

def pbTrainerInfo(pokemonlist,trfile,rules)
  bttrainers=pbGetBTTrainers(trfile)
  btpokemon=pbGetBTPokemon(trfile)
  if bttrainers.length==0
    for i in 0...200
      yield(nil) if block_given? && i%50==0
      trainerid=0
      if GameData::TrainerType.exists?(:YOUNGSTER) && rand(30) == 0
        trainerid = :YOUNGSTER
      else
        tr_typekeys = GameData::TrainerType::DATA.keys
        loop do
          tr_type = tr_typekeys[rand(tr_typekeys.length)]
          tr_type_data = GameData::TrainerType.get(tr_type)
          next if tr_type_data.base_money >= 100
          trainerid = tr_type_data.id
        end
      end
      gender = GameData::TrainerType.get(trainerid).gender
      randomName=getRandomNameEx(gender,nil,0,12)
      tr=[trainerid,randomName,_INTL("Here I come!"),
          _INTL("Yes, I won!"),_INTL("Man, I lost!"),[]]
      bttrainers.push(tr)
    end
    bttrainers.sort! { |a, b|
      money1 = GameData::TrainerType.get(a[0]).base_money
      money2 = GameData::TrainerType.get(b[0]).base_money
      (money1 == money2) ? a[0].to_s <=> b[0].to_s : money1 <=> money2
    }
  end
  yield(nil) if block_given?
  suggestedLevel=rules.ruleset.suggestedLevel
  rulesetTeam=rules.ruleset.copy.clearPokemonRules
  pkmntypes=[]
  validities=[]
  for pkmn in pokemonlist
    pkmn.level=suggestedLevel if pkmn.level!=suggestedLevel
    pkmntypes.push(getTypes(pkmn.species))
    validities.push(rules.ruleset.isPokemonValid?(pkmn))
  end
  newbttrainers=[]
  for btt in 0...bttrainers.length
    yield(nil) if block_given? && btt%50==0
    trainerdata=bttrainers[btt]
    pokemonnumbers=trainerdata[5] || []
    species=[]
    types={}
    #p trainerdata[1]
    GameData::Type.each { |t| types[t.id] = 0 }
    for pn in pokemonnumbers
      pkmn=btpokemon[pn]
      species.push(pkmn.species)
      t=getTypes(pkmn.species)
      t.each { |typ| types[typ] += 1 }
    end
    species|=[] # remove duplicates
    count=0
    GameData::Type.each do |t|
      if types[t.id] >= 5
        types[t.id] /= 4
        types[t.id] = 10 if types[t.id] > 10
      else
        types[t.id] = 0
      end
      count += types[t.id]
    end
    types[:NORMAL] = 1 if count == 0
    if pokemonnumbers.length==0
      GameData::Type.each { |t| types[t.id] = 1 }
    end
    numbers=[]
    if pokemonlist
      numbersPokemon=[]
      # p species
      for index in 0...pokemonlist.length
        pkmn=pokemonlist[index]
        next if !validities[index]
        absDiff=((index*8/pokemonlist.length)-(btt*8/bttrainers.length)).abs
        if species.include?(pkmn.species)
          weight=[32,12,5,2,1,0,0,0][[absDiff,7].min]
          if rand(40)<weight
            numbers.push(index)
            numbersPokemon.push(pokemonlist[index])
          end
        else
          t=pkmntypes[index]
          t.each { |typ|
            weight=[32,12,5,2,1,0,0,0][[absDiff,7].min]
            weight*=types[typ]
            if rand(40)<weight
              numbers.push(index)
              numbersPokemon.push(pokemonlist[index])
            end
          }
        end
      end
      numbers|=[]
      if numbers.length < Settings::MAX_PARTY_SIZE ||
         !rulesetTeam.hasValidTeam?(numbersPokemon)
        for index in 0...pokemonlist.length
          pkmn=pokemonlist[index]
          next if !validities[index]
          if species.include?(pkmn.species)
            numbers.push(index)
            numbersPokemon.push(pokemonlist[index])
          else
            t=pkmntypes[index]
            t.each { |typ|
              if types[typ]>0 && !numbers.include?(index)
                numbers.push(index)
                numbersPokemon.push(pokemonlist[index])
                break
              end
            }
          end
          break if numbers.length >= Settings::MAX_PARTY_SIZE && rules.ruleset.hasValidTeam?(numbersPokemon)
        end
        if numbers.length < Settings::MAX_PARTY_SIZE || !rules.ruleset.hasValidTeam?(numbersPokemon)
          while numbers.length<pokemonlist.length &&
             (numbers.length < Settings::MAX_PARTY_SIZE || !rules.ruleset.hasValidTeam?(numbersPokemon))
            index=rand(pokemonlist.length)
            if !numbers.include?(index)
              numbers.push(index)
              numbersPokemon.push(pokemonlist[index])
            end
          end
        end
      end
      numbers.sort!
    end
    newbttrainers.push([trainerdata[0],trainerdata[1],trainerdata[2],
                        trainerdata[3],trainerdata[4],numbers])
  end
  yield(nil) if block_given?
  pbpokemonlist=[]
  for pkmn in pokemonlist
    pbpokemonlist.push(PBPokemon.fromPokemon(pkmn))
  end
  trlists=(load_data("Data/trainer_lists.dat") rescue [])
  hasDefault=false
  trIndex=-1
  for i in 0...trlists.length
    hasDefault=true if trlists[i][5]
  end
  for i in 0...trlists.length
    if trlists[i][2].include?(trfile)
      trIndex=i
      trlists[i][0]=newbttrainers
      trlists[i][1]=pbpokemonlist
      trlists[i][5]=!hasDefault
    end
  end
  yield(nil) if block_given?
  if trIndex<0
    info=[newbttrainers,pbpokemonlist,[trfile],
          trfile+"tr.txt",trfile+"pm.txt",!hasDefault]
    trlists.push(info)
  end
  yield(nil) if block_given?
  save_data(trlists,"Data/trainer_lists.dat")
  yield(nil) if block_given?
  Compiler.write_trainer_lists
  yield(nil) if block_given?
end

#==============================================================================
# Fixes for Battle Arena.
#==============================================================================
class PokeBattle_Battler
  def pbCancelMoves(full_cancel = false)
    # Outragers get confused anyway if they are disrupted during their final
    # turn of using the move
    if @effects[PBEffects::Outrage]==1 && pbCanConfuseSelf?(false) && !full_cancel
      pbConfuse(_INTL("{1} became confused due to fatigue!",pbThis))
    end
    # Cancel usage of most multi-turn moves
    @effects[PBEffects::TwoTurnAttack] = nil
    @effects[PBEffects::Rollout]       = 0
    @effects[PBEffects::Outrage]       = 0
    @effects[PBEffects::Uproar]        = 0
    @effects[PBEffects::Bide]          = 0
    @currentMove = nil
    # Reset counters for moves which increase them when used in succession
    @effects[PBEffects::FuryCutter]    = 0
  end
end

class PokeBattle_BattleArena < PokeBattle_Battle
  def pbEndOfRoundPhase
    super
    return if @decision != 0
    # Update skill rating
    for side in 0...2
      @skill[side] += self.successStates[side].skill
    end
#    PBDebug.log("[Mind: #{@mind.inspect}, Skill: #{@skill.inspect}]")
    # Increment turn counter
    @count += 1
    return if @count < 3
    # Half all multi-turn moves
    @battlers[0].pbCancelMoves(true)
    @battlers[1].pbCancelMoves(true)
    # Calculate scores in each category
    ratings1 = [0, 0, 0]
    ratings2 = [0, 0, 0]
    if @mind[0] == @mind[1]
      ratings1[0] = 1
      ratings2[0] = 1
    elsif @mind[0] > @mind[1]
      ratings1[0] = 2
    else
      ratings2[0] = 2
    end
    if @skill[0] == @skill[1]
      ratings1[1] = 1
      ratings2[1] = 1
    elsif @skill[0] > @skill[1]
      ratings1[1] = 2
    else
      ratings2[1] = 2
    end
    body = [0, 0]
    body[0] = ((@battlers[0].hp * 100) / [@starthp[0], 1].max).floor
    body[1] = ((@battlers[1].hp * 100) / [@starthp[1], 1].max).floor
    if body[0] == body[1]
      ratings1[2] = 1
      ratings2[2] = 1
    elsif body[0] > body[1]
      ratings1[2] = 2
    else
      ratings2[2] = 2
    end
    # Show scores
    @scene.pbBattleArenaJudgment(@battlers[0], @battlers[1], ratings1.clone, ratings2.clone)
    # Calculate total scores
    points = [0, 0]
    ratings1.each { |val| points[0] += val }
    ratings2.each { |val| points[1] += val }
    # Make judgment
    if points[0] == points[1]
      pbDisplay(_INTL("{1} tied the opponent\n{2} in a referee's decision!",
         @battlers[0].name, @battlers[1].name))
      # NOTE: Pokémon doesn't really lose HP, but the effect is mostly the
      #       same.
      @battlers[0].hp = 0
      @battlers[0].pbFaint(false)
      @battlers[1].hp = 0
      @battlers[1].pbFaint(false)
    elsif points[0] > points[1]
      pbDisplay(_INTL("{1} defeated the opponent\n{2} in a referee's decision!",
         @battlers[0].name, @battlers[1].name))
      @battlers[1].hp = 0
      @battlers[1].pbFaint(false)
    else
      pbDisplay(_INTL("{1} lost to the opponent\n{2} in a referee's decision!",
         @battlers[0].name, @battlers[1].name))
      @battlers[0].hp = 0
      @battlers[0].pbFaint(false)
    end
    pbGainExp
    pbEORSwitch
  end
end

class PokeBattle_Scene
  def pbBattleArenaJudgment(battler1,battler2,ratings1,ratings2)
    msgwindow  = nil
    dimmingvp  = nil
    infowindow = nil
    begin
      msgwindow = pbCreateMessageWindow
      dimmingvp = Viewport.new(0,0,Graphics.width,Graphics.height-msgwindow.height)
      pbMessageDisplay(msgwindow,
         _INTL("REFEREE: That's it! We will now go to judging to determine the winner!\\wtnp[20]")) {
         pbBattleArenaUpdate; dimmingvp.update }
      dimmingvp.z = 99999
      infowindow = SpriteWindow_Base.new(80,0,320,224)
      infowindow.contents = Bitmap.new(infowindow.width-infowindow.borderX,
                                       infowindow.height-infowindow.borderY)
      infowindow.z        = 99999
      infowindow.visible  = false
      for i in 0..10
        pbGraphicsUpdate
        pbInputUpdate
        msgwindow.update
        dimmingvp.update
        dimmingvp.color = Color.new(0,0,0,i*128/10)
      end
      updateJudgment(infowindow,0,battler1,battler2,ratings1,ratings2)
      infowindow.visible = true
      for i in 0..10
        pbGraphicsUpdate
        pbInputUpdate
        msgwindow.update
        dimmingvp.update
        infowindow.update
      end
      updateJudgment(infowindow,1,battler1,battler2,ratings1,ratings2)
      pbMessageDisplay(msgwindow,
         _INTL("REFEREE: Judging category 1, Mind!\nThe Pokémon showing the most guts!\\wtnp[40]")) {
         pbBattleArenaUpdate; dimmingvp.update; infowindow.update }
      updateJudgment(infowindow,2,battler1,battler2,ratings1,ratings2)
      pbMessageDisplay(msgwindow,
         _INTL("REFEREE: Judging category 2, Skill!\nThe Pokémon using moves the best!\\wtnp[40]")) {
         pbBattleArenaUpdate; dimmingvp.update; infowindow.update }
      updateJudgment(infowindow,3,battler1,battler2,ratings1,ratings2)
      pbMessageDisplay(msgwindow,
         _INTL("REFEREE: Judging category 3, Body!\nThe Pokémon with the most vitality!\\wtnp[40]")) {
         pbBattleArenaUpdate; dimmingvp.update; infowindow.update }
      total1 = 0
      total2 = 0
      for i in 0...3
        total1 += ratings1[i]
        total2 += ratings2[i]
      end
      if total1==total2
        pbMessageDisplay(msgwindow,
           _INTL("REFEREE: Judgment: {1} to {2}!\nWe have a draw!\\wtnp[40]",total1,total2)) {
          pbBattleArenaUpdate; dimmingvp.update; infowindow.update }
      elsif total1>total2
        pbMessageDisplay(msgwindow,
           _INTL("REFEREE: Judgment: {1} to {2}!\nThe winner is {3}'s {4}!\\wtnp[40]",
           total1,total2,@battle.pbGetOwnerName(battler1.index),battler1.name)) {
           pbBattleArenaUpdate; dimmingvp.update; infowindow.update }
      else
        pbMessageDisplay(msgwindow,
           _INTL("REFEREE: Judgment: {1} to {2}!\nThe winner is {3}!\\wtnp[40]",
           total1,total2,battler2.name)) {
           pbBattleArenaUpdate; dimmingvp.update; infowindow.update }
      end
      infowindow.visible = false
      msgwindow.visible  = false
      for i in 0..10
        pbGraphicsUpdate
        pbInputUpdate
        msgwindow.update
        dimmingvp.update
        dimmingvp.color = Color.new(0,0,0,(10-i)*128/10)
      end
    ensure
      pbDisposeMessageWindow(msgwindow)
      dimmingvp.dispose
      infowindow.contents.dispose if infowindow && infowindow.contents
      infowindow.dispose if infowindow
    end
  end
end
