
/* File : encounter_simulation.pl */

:- include('enemy.pl').

/* Encounter enemy randomizer */

encounter_enemy(MaxId, EnemyType) :-
    random(1, 151, EncounterRate),
    EncounterRate =< 75,
    random(0, MaxId, EncounterType),
    EnemyType is EncounterType,
    write('You encounter a '),
    enemy_type(EncounterType, EncounterName),
    write(EncounterName),
    write('!\n'),
    random(1, 6, EnemyLevel),
    enemy_attack(EncounterType, Att),
    enemy_defense(EncounterType, Def),
    write('Level: '),
    write(EnemyLevel), nl,
    write('Attack: '),
    write(Att), nl,
    write('Defense: '),
    write(Def), nl.
