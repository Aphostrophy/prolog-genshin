/* File : battle.pl */
/* Battle Mechanisms Go Here */

/* Saat bukan boss battle */
trigger_battle :- 
    assertz(fight_or_run),
    retract(game_state(travelling)),
    assertz(game_state(in_battle)),
    assertz(can_run),
    write('Fight or Run?').

/* Saat boss battle */
trigger_boss :-
    retract(game_state(travelling)),
    assertz(game_state(boss_battle)),
    
    retract(type_enemy(_)),
    assertz(type_enemy(4)),

    retract(lvl_enemy(_)),
    assertz(lvl_enemy(70)),

    lvl_enemy(EnemyLevel),
    
    enemy_health(4, Hp),
    ScaleHp is Hp + 10*EnemyLevel,
    retract(hp_enemy(_)),
    assertz(hp_enemy(ScaleHp)),
    
    enemy_attack(4, Att),
    ScaleAtt is Att + 5*EnemyLevel,
    retract(att_enemy(_)),
    assertz(att_enemy(ScaleAtt)),

    enemy_defense(4, Def),
    ScaleDef is Def + 2*EnemyLevel,
    retract(def_enemy(_)),
    assertz(def_enemy(ScaleDef)),
    write('You feel the ground tremble, the wind rages around you. You see a humongous being, it was an overweight Paimon.'), nl,
    write('Seems like she wants to eat you to satisfy her unsatisfiable appetite.'), nl,
    write('You can\'t\' run. You have to defeat her!!').

/* Saat boss battle */
fight :- 
    game_state(boss_battle), !,
    write('You choose to face Paimon head on!!').

/* Saat bukan boss battle */
fight :- 
    game_state(in_battle),
    fight_or_run, !,
    write('You choose to face the monster head on!!'),
    retract(fight_or_run).

fight :- 
    (\+ game_state(in_battle)), !,
    write('You aren\'t in a battle, please walk a bit to find monsters!!').
    
fight :- 
    (\+ fight_or_run), !,
    write('You choose to fight, get ready!!').

/* Saat boss battle */
run :-
    game_state(boss_battle), !,
    write('There\'s\' a wind barrier blocking your escape route. You cant\'t\' run!').

/* Saat bukan boss battle */
run :- 
    game_state(in_battle),
    can_run,
    fight_or_run, 
    random(0,11,RunRate),
    retract(can_run),
    run_gacha(RunRate), !.

run :-
    (\+ game_state(in_battle)),!,
    write('You aren\'t in a battle. Why are you running??!!').

run :-
    (\+ can_run), !,
    write('Seems like you can\'t run, go fight it like a man!!').

run :-
    (\+ fight_or_run), !,
    write('Who are you running from??').

/* Rules buat gacha kemungkinan run */
run_gacha(Rate) :-
    Rate >= 8, !,
    retract(game_state(in_battle)),
    assertz(game_state(travelling)),
    retract(fight_or_run),
    write('You choose to run. You successfully escaped from the monster!!').

run_gacha(Rate) :-
    Rate < 8, !,
    write('Oh no you failed to run!! I guess there is no other way than to fight it like a man :).'),
    retract(fight_or_run).

/* Saat boss battle */
attack :-
    game_state(boss_battle), (\+ fight_or_run), !,
    hp_enemy(X), !,
    retract(hp_enemy(X)),
    att_enemy(AttEnemy),
    def_enemy(DefEnemy), !,

    player_attack(AttPlayer), !,
    calc_damage(AttPlayer, DefEnemy, Atk), !,

    NewX is X - Atk,
    assertz(hp_enemy(NewX)),
    
    write('You deal '), write(Atk), write(' damage!'), nl, nl,

    check_death_boss.

/* Saat bukan boss battle */
attack :-
    game_state(in_battle), (\+ fight_or_run), !,

    hp_enemy(X), !,
    retract(hp_enemy(X)),
    att_enemy(AttEnemy),
    def_enemy(DefEnemy), !,

    player_attack(AttPlayer), !,
    calc_damage(AttPlayer, DefEnemy, Atk), !,
    
    NewX is X - Atk,
    assertz(hp_enemy(NewX)),
    
    write('You deal '), write(Atk), write(' damage!'), nl, nl,

    check_death.

attack :-
    fight_or_run, !,
    write('Type \'fight.\' to fight, type \'run.\' to run.').

attack :-
    \+game_state(in_battle), !,
    write('You are currently not in a battle').

/* Saat boss battle */
special_attack :-
    game_state(boss_battle), !,
    special_timer(Timer),
    Timer >= 3, !,
    write('You used your special attack!!'), nl,

    hp_enemy(X),
    retract(hp_enemy(X)),
    att_enemy(AttEnemy),
    def_enemy(DefEnemy),

    player_attack(AttPlayer),
    SpecialAtt is 2*AttPlayer,
    calc_damage(SpecialAtt, DefEnemy, Atk),

    NewX is X - Atk,
    assertz(hp_enemy(NewX)),
    
    write('You deal '), write(Atk), write(' damage!'), nl, nl,

    retract(special_timer(_)),
    assertz(special_timer(0)),

    check_death_boss.

special_attack :-
    game_state(boss_battle), !,
    special_timer(Timer),
    Timer < 3, !,
    write('You can\'\t use special attack yet!').

/* Saat bukan boss battle */
special_attack :-
    game_state(in_battle), (\+ fight_or_run), !,
    special_timer(Timer),
    Timer >= 3, !,
    write('You used your special attack!!'), nl,

    hp_enemy(X),
    retract(hp_enemy(X)),
    att_enemy(AttEnemy),
    def_enemy(DefEnemy),

    player_attack(AttPlayer),
    SpecialAtt is 2*AttPlayer,
    calc_damage(SpecialAtt, DefEnemy, Atk),

    NewX is X - Atk,
    assertz(hp_enemy(NewX)),
    
    write('You deal '), write(Atk), write(' damage!'), nl, nl,

    retract(special_timer(_)),
    assertz(special_timer(0)),

    check_death.

special_attack :-
    game_state(in_battle), (\+ fight_or_run), !,
    special_timer(Timer),
    Timer < 3, !,
    write('You can\'\t use special attack yet!').

special_attack :-
    fight_or_run, !,
    write('Type \'fight.\' to fight, type \'run.\' to run.').

special_attack :-
    \+game_state(in_battle), !,
    write('You are currently not in a battle').

/* Command untuk use Consumables  */

/* Saat travelling */
item :-
    game_state(travelling), !,
    inventory,
    write('Input item name!!'), nl,
    read(ItemName),
    substractFromInventory([ItemName|1]),

    property(ItemName, Hp),
    heal(Hp),
    write('You used '), write(ItemName), nl.

/* Saat boss battle */
item :-
    game_state(boss_battle), !,
    inventory,
    write('Input item name!!'), nl,
    read(ItemName),
    substractFromInventory([ItemName|1]),

    consumable_type(ItemName, Type), !,
    use_item(ItemName,Type),
    write('You used '), write(ItemName), nl,

    special_timer(Timer),
    NewTimer is Timer+1,
    retract(special_timer(_)),
    assertz(special_timer(NewTimer)),

    enemy_turn, !.

/* Saat bukan boss battle */
item :-
    game_state(in_battle), !,
    inventory,
    write('Input item name!!'), nl,
    read(ItemName),
    substractFromInventory([ItemName|1]),

    consumable_type(ItemName, Type),
    use_item(ItemName,Type),
    write('You used '), write(ItemName), nl,

    special_timer(Timer),
    NewTimer is Timer+1,
    retract(special_timer(_)),
    assertz(special_timer(NewTimer)),

    enemy_turn, !.

/* use item sesuai typenya (heal, att, atau def) */
use_item(ItemName,Type) :-
    Type = heal,
    property(ItemName, Hp), !,
    heal(Hp).

use_item(ItemName,Type) :-
    Type = att,
    property(ItemName, Att), !,
    attUp(Att).

use_item(ItemName,Type) :-
    Type = def,
    property(ItemName, Def), !,
    defUp(Def).

heal(Hp) :-
    player_health(PlayerHealth), !,
    player_max_health(PlayerMaxHealth),
    NewHealth is PlayerHealth+Hp,
    NewHealth < PlayerMaxHealth, !,
    retract(player_health(_)),
    assertz(player_health(NewHealth)).

heal(Hp) :-
    player_health(PlayerHealth), !,
    player_max_health(PlayerMaxHealth),
    NewHealth is PlayerHealth+Hp,
    NewHealth >= PlayerMaxHealth, !,
    retract(player_health(_)),
    assertz(player_health(PlayerMaxHealth)).

attUp(Att) :-
    player_attack(PlayerAttack), !,
    NewAttack is PlayerAttack+Att,
    retract(buff_att(_)),
    assertz(buff_att(3)),
    retract(player_attack(_)),
    assertz(player_attack(NewAttack)).

defUp(Def) :-
    player_defense(PlayerDefense), !,
    NewDefense is PlayerDefense+Def,
    retract(buff_def(_)),
    assertz(buff_def(3)),
    retract(player_defense(_)),
    assertz(player_defense(NewDefense)).

/* Saat bukan boss battle */
check_death :-
    hp_enemy(X),
    X =< 0, !,
    type_enemy(Y),
    enemy_type(Y, Name), !,

    write(Name), write(' defeated! you got : '), nl, !,

    /* calculate gold and exp gain */
    enemy_exp(Y, Exp),
    enemy_gold(Y, Gold), 
    lvl_enemy(EnemyLevel), !,
    ExpLoot is Exp + 5*EnemyLevel,
    GoldLoot is Gold + 10*EnemyLevel,

    /* Loot and EXP gain */
    write(ExpLoot), write(' exp'), nl,
    write(GoldLoot), write(' gold'), nl,
    
    add_player_exp(ExpLoot),
    add_player_gold(GoldLoot), !,

    update_quest(Y),

    buff_att(BuffAtt),
    buff_def(BuffDef), !,
    check_buff_att(BuffAtt),
    check_buff_def(BuffDef), !,

    retract(game_state(in_battle)),
    assertz(game_state(travelling)).

check_death :- 
    show_battle_status, 
    nl, nl,
    special_timer(Timer),
    NewTimer is Timer+1,
    retract(special_timer(_)),
    assertz(special_timer(NewTimer)),

    buff_att(BuffAtt),
    buff_def(BuffDef), !,
    check_buff_att(BuffAtt),
    check_buff_def(BuffDef), !,
    enemy_turn.

/* Saat boss battle */
check_death_boss :-
    hp_enemy(X),
    X =< 0, !,
    type_enemy(Y),
    enemy_type(Y, Name), !,

    write(Name), write(' defeated!!'), nl, !,

    write('As Paimon falls down, the whole dungeon also collapses upon you.'), nl,
    write('When you open your eyes, you find yourself in a bed of a hospital.'), nl,
    write('It was just a moment when you thought it was just a dream, until you decided to take a look outside the window.'), nl,
    write('You find that the world has changed, you now lives inside a fantasy world where humans and other beings live together.'), nl,
    write('Will your story continues??'), nl, nl,

    write('CONGRATS!!! You completed the game, use \'start.\' if you want to play again!!'),

    retract(game_state(boss_battle)),
    retract(game_start).

check_death_boss :- 
    show_battle_status, 
    nl, nl,
    special_timer(Timer),
    NewTimer is Timer+1,
    retract(special_timer(_)),
    assertz(special_timer(NewTimer)),

    buff_att(BuffAtt),
    buff_def(BuffDef), !,
    check_buff_att(BuffAtt),
    check_buff_def(BuffDef), !,
    enemy_turn.

/* Check buff masih ada atau tidak */
check_buff_att(X) :-
    X > 0, !,
    buff_att(Timer), !,
    NewTimer is Timer-1,
    retract(buff_att(_)),
    assertz(buff_att(NewTimer)).

check_buff_att(X) :-
    X =:= 0, !,
    player_max_attack(NewAttack), !,
    retract(player_attack(_)),
    assertz(player_attack(NewAttack)).

check_buff_def(X) :-
    X > 0, !,
    buff_def(Timer), !,
    NewTimer is Timer-1,
    retract(buff_def(_)),
    assertz(buff_def(NewTimer)).
    
check_buff_def(X) :-
    X =:= 0, !,
    player_max_defense(NewDefense), !,
    retract(player_defense(_)),
    assertz(player_defense(NewDefense)).

/* Giliran enemy nyerang */
enemy_turn :- 
    !,
    att_enemy(AttEnemy),
    player_defense(DefPlayer),
    player_health(PlayerHealth), !,
    retract(player_health(PlayerHealth)),

    calc_damage(AttEnemy, DefPlayer, Atk), !,
    NewX is PlayerHealth - Atk,
    
    assertz(player_health(NewX)), !,

    type_enemy(EnemyId),
    enemy_type(EnemyId, EnemyName), !,
    write(EnemyName), write(' deals '), write(Atk), write(' damage!!'), nl, nl,

    check_player_death.

/* Ngecek player mati ato kaga */
check_player_death :-
    player_health(PlayerHealth),
    PlayerHealth =< 0, !,
    write('You died... Game Over... Type \'start.\' to retry!'),
    retract(game_start).

check_player_death :-
    show_battle_status, !.

/* Nampilin status enemy dan player */
show_battle_status :-
    /* Enemy Status */
    type_enemy(EnemyId),
    enemy_type(EnemyId, EnemyName),
    hp_enemy(EnemyHealth), !,

    write('Enemy :'), write(EnemyName), nl,
    write('Health : '), write(EnemyHealth), nl, nl,

    /* Player Status */
    write('Your status :'), nl,
    player_health(PlayerHealth),
    player_max_health(PlayerMaxHealth), !,
    write('Health : '), write(PlayerHealth), write(' / '), write(PlayerMaxHealth), nl,
    special_timer(Timer),
    special_status(Timer).

/* Nampilin status special attack */
special_status(Timer) :-
    Timer < 3, !,
    write('Special attack : not ready').

special_status(Timer) :-
    Timer >= 3, !,
    write('Special attack : READY!!!!!').