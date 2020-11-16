
/* File : encounter_simulation.pl */

:- include('enemy.pl').

:- dynamic(type_enemy/1).
:- dynamic(hp_enemy/1).
:- dynamic(att_enemy/1).
:- dynamic(def_enemy/1).
:- dynamic(lvl_enemy/1).

/* Encounter enemy randomizer */

encounter_enemy(MaxId, EnemyType) :-
    random(1, 151, EncounterRate),
    EncounterRate =< 150,
    random(0, MaxId, EncounterType),
    EnemyType is EncounterType,
    write('You encounter a '),
    enemy_type(EncounterType, EncounterName),
    write(EncounterName),
    write('!\n').

encounter :- 
    encounter_enemy(3, X), !,
    retract(type_enemy(_)),
    assertz(type_enemy(X)),

    random(1, 6, EnemyLevel),
    retract(lvl_enemy(_)),
    assertz(lvl_enemy(EnemyLevel)),
    

    enemy_health(X, Hp),
    ScaleHp is Hp + 10*EnemyLevel,
    retract(hp_enemy(_)),
    assertz(hp_enemy(ScaleHp)),
    

    enemy_attack(X, Att),
    ScaleAtt is Att + 5*EnemyLevel,
    retract(att_enemy(_)),
    assertz(att_enemy(ScaleAtt)),

    enemy_defense(X, Def),
    ScaleDef is Def + 2*EnemyLevel,
    retract(def_enemy(_)),
    assertz(def_enemy(ScaleDef)),

    print_info.

encounter :- !.

print_info :-
    /* Print Info enemy */
    lvl_enemy(EnemyLevel),
    hp_enemy(Hp),
    att_enemy(Att),
    def_enemy(Def), !,
    write('Level: '),
    write(EnemyLevel), nl,
    write('Health: '),
    write(Hp), nl,
    write('Attack: '),
    write(Att), nl,
    write('Defense: '),
    write(Def), nl.