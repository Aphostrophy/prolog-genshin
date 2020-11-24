/* File : battle.pl */
/* Battle Mechanisms Go Here */

:- dynamic(special_used/0).
:- dynamic(fight_or_run/0).
:- dynamic(can_run/0).

trigger_battle :- 
    assertz(fight_or_run),
    retract(game_state(travelling)),
    assertz(game_state(in_battle)),
    assertz(can_run),
    write('Fight or Run?').

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

attack :-
    game_state(in_battle), (\+ fight_or_run), !,

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
    \+game_state(in_battle), !,
    write('You are currently not in a battle').

    write('You deal '), write(Atk), write(' damage to the enemy!'), nl, nl,

    check_death.

/* Command untuk use Potion  */



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

    /* calculate gold and exp gain */
    enemy_exp(Y, Exp),
    enemy_gold(Y, Gold), !,
    ExpLoot is Exp + truncate(1.5*Exp),
    GoldLoot is Gold + 10*Gold,

    /* Loot and EXP gain */
    write(ExpLoot), write(' exp'), nl,
    write(GoldLoot), write(' gold'), nl,

    update_quest(Y),

    retract(game_state(in_battle)),
    assertz(game_state(travelling)).

% Ignore bila musuh belum mati
check_death :- 
    show_battle_status, 
    nl, nl, 
    enemy_turn.

check_player_death :-
    player_health(PlayerHealth),
    PlayerHealth =< 0, !,
    write('You died... Game Over... Type \'start.\' to retry!'),
    retract(game_start).

check_player_death :-
    show_battle_status, !.

show_battle_status :-
    /* Enemy Status */
    type_enemy(EnemyId),
    enemy_type(EnemyId, EnemyName),
    hp_enemy(EnemyHealth),

    write('Enemy :'), write(EnemyName), nl,
    write('Health : '), write(EnemyHealth), nl, nl,

    /* Player Status */
    write('Your status :'), nl,
    player_health(PlayerHealth),
    write('Health : '), write(PlayerHealth).

update_quest(Type) :-
    Type =:= 0,
    (\+slime_counter(0)), !,
    slime_counter(Count),
    NewCount is Count-1,
    retract(slime_counter(_)),
    assertz(slime_counter(NewCount)),
    check_quest_done.

update_quest(Type) :-
    Type =:= 0,
    slime_counter(0), !.

update_quest(Type) :-
    Type =:= 1,
    (\+hilichurl_counter(0)), !,
    hilichurl_counter(Count),
    NewCount is Count-1,
    retract(hilichurl_counter(_)),
    assertz(hilichurl_counter(NewCount)),
    check_quest_done.

update_quest(Type) :-
    Type =:= 1,
    hilichurl_counter(0), !.

update_quest(Type) :-
    Type =:= 2,
    (\+mage_counter(0)), !,
    mage_counter(Count),
    NewCount is Count-1,
    retract(mage_counter(_)),
    assertz(mage_counter(NewCount)),
    check_quest_done.

update_quest(Type) :-
    Type =:= 2,
    mage_counter(0), !.

check_quest_done :-
    slime_counter(0),
    hilichurl_counter(0),
    mage_counter(0),
    write('Quest finished!!! You get :'),\
    questExp(ExpLoot),
    questGold(GoldLoot),

    current_gold(CurrentGold),
    NewCurrentGold is CurrentGold+GoldLoot,

    current_exp(CurrentExp),
    NewCurrentExp is CurrentExp+ExpLoot,

    retract(current_exp(_)),
    retract(current_gold(_)),
    assertz(current_gold(NewCurrentGold)),
    assertz(current_exp(NewCurrentExp)).

check_quest_done :-
    (\+slime_counter(0)), !.  

check_quest_done :-
    (\+hilichurl_counter(0)), !. 

check_quest_done :-
    (\+mage_counter(0)), !.