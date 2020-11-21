/* File : battle.pl */
/* Battle Mechanisms Go Here */

:- dynamic(in_battle/0).
:- dynamic(special_used/0).
:- dynamic(fight_or_run/0).
:- dynamic(can_run/0).

trigger_battle :- 
    assertz(fight_or_run),
    assertz(in_battle),
    assertz(can_run),
    write('Fight or Run?').

fight :- 
    in_battle,
    fight_or_run, !,
    write('You choose to face the monster head on!!'),
    retract(fight_or_run).

fight :- 
    (\+ in_battle), !,
    write('You aren\'t in a battle, please walk a bit to find monsters!!').
    
fight :- 
    (\+ fight_or_run), !,
    write('You choose to fight, get ready!!').

run :- 
    can_run,
    in_battle,
    fight_or_run, 
    random(0,11,RunRate),
    retract(can_run),
    run_gacha(RunRate), !.

run :-
    (\+ in_battle),!,
    write('You aren\'t in a battle. Why are you running??!!').

run :-
    (\+ can_run), !,
    write('Seems like you can\'t run, go fight it like a man!!').

run :-
    (\+ fight_or_run), !,
    write('Who are you running from??').

run_gacha(Rate) :-
    Rate >= 8, !,
    retract(in_battle),
    retract(fight_or_run),
    write('You choose to run. You successfully escaped from the monster!!').

run_gacha(Rate) :-
    Rate < 8, !,
    write('Oh no you failed to run!! I guess there is no other way than to fight it like a man :).'),
    retract(fight_or_run).

attack :-
    in_battle, (\+ fight_or_run), !,

    hp_enemy(X),
    retract(hp_enemy(X)),
    att_enemy(AttEnemy),
    def_enemy(DefEnemy),

    player_attack(AttPlayer),
    calc_damage(AttPlayer, DefEnemy, Atk),

    NewX is X - Atk,
    assertz(hp_enemy(NewX)),
    
    write('You deal '), write(Atk), write(' damage!'), nl, nl,

    check_death.

attack :-
    fight_or_run, !,
    write('Type \'fight.\' to fight, type \'run\' to run.').

attack :-
    \+in_battle, !,
    write('You are currently not in a battle').

% Success Result: Darah musuh berkurang
specialAttack :-
    in_battle, (\+ fight_or_flight), (\+ special_used),
    (\+ selected_pokemon(0)), !,
    enemy_health(X),
    retract(enemy_health(X)),
    selected_pokemon(SelPoke),
    pokemon_inventory(Inv, _),
    nth_item(Inv, SelPoke, PokeId),
    enemy_pokemon(EnemyId),
    calc_special_damage(PokeId, EnemyId, Atk),
    NewX is X - Atk,
    assertz(enemy_health(NewX)),
    assertz(special_used),
    
    write('You deal '), write(Atk), write(' damage to the enemy!'), nl, nl,

    check_death.

specialAttack :-
    selected_pokemon(0), !,
    write('You have not picked a pokemon yet').

specialAttack :-
    fight_or_flight, !,
    write('Type \'fight.\' to fight, type \'run\' to run.').

specialAttack :-
    special_used, !,
    write('You have used a special this battle.').

% Fail Condition: Tidak dalam battle
specialAttack :-
    !,
    write('You are currently not in a battle').

enemy_turn :- 
    !,
    att_enemy(AttEnemy),
    player_defense(DefPlayer),
    player_health(PlayerHealth),
    retract(player_health(PlayerHealth)),

    calc_damage(AttEnemy, DefPlayer, Atk),
    NewX is PlayerHealth - Atk,
    
    assertz(player_health(NewX)), !,

    type_enemy(EnemyId),
    enemy_type(EnemyId, EnemyName),
    write(EnemyName), write(' deals '), write(Atk), write(' damage!!'), nl, nl,

    check_player_death.

% Menyelesaikan battle saat musuh sudah kalah
check_death :-
    hp_enemy(X),
    X =< 0,
    type_enemy(Y),
    enemy_type(Y, Name),

    write(Name), write(' defeated! you got : '), nl, !,
    /* nanti loot ama exp gainnya ditulis disini */

    retract(in_battle),
    retract(special_used).

% Ignore bila musuh belum mati
check_death :- 
    show_battle_status, 
    nl, nl, 
    enemy_turn.

check_player_death :-
    player_health(PlayerHealth),
    PlayerHealth =< 0, !,

    lose, !.

check_player_death :-
    show_battle_status, !.

lose :-
    retract(game_start(true)),
    asserta(game_start(false)),
    write('You died... Game Over... Type \'start.\' to retry!'), !.

show_battle_status :-
    /* Enemy Status */
    type_enemy(EnemyId),
    enemy_type(EnemyId, EnemyName),
    hp_enemy(EnemyHealth),

    write('Enemy :'), write(EnemyName), nl,
    write('Health : '), write(EnemyHealth), nl, nl,

    write('Your status :'), nl,
    player_health(PlayerHealth),
    write('Health : '), write(PlayerHealth).