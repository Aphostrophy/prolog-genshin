/* File : encounter_enemy.pl */

%:- include('enemy.pl').

:- dynamic(type_enemy/1).
:- dynamic(hp_enemy/1).
:- dynamic(att_enemy/1).
:- dynamic(def_enemy/1).
:- dynamic(lvl_enemy/1).

chestLoot(100).

/* Encounter enemy randomizer */

encounter_enemy(MaxWeight, EnemyType) :-
    random(1, 151, EncounterRate),
    EncounterRate =< 75,
    random(0, MaxWeight, EncounterWeight),

    enemy_gacha(EncounterWeight),
    type_enemy(EncounterType),

    EnemyType is EncounterType.

/* Rules untuk nge-gacha kemunculan enemy berdasarkan range weight-nya */
/* Nanti weight-nya bisa disesuaiin sama area map, 
   biar kemunculan tipe monster tertentu bisa lebih tinggi di tempat tertentu */

enemy_gacha(Rate) :-
    Rate =< 50,
    retract(type_enemy(_)),
    asserta(type_enemy(0)).

enemy_gacha(Rate) :- 
    Rate =< 80,
    Rate > 50,
    retract(type_enemy(_)),
    asserta(type_enemy(1)).

enemy_gacha(Rate) :- 
    Rate =< 90,
    Rate > 80,
    retract(type_enemy(_)),
    asserta(type_enemy(2)).

enemy_gacha(Rate) :- 
    Rate =< 100,
    Rate > 90,
    retract(type_enemy(_)),
    asserta(type_enemy(3)).

/* Rules yang bakal dipakai di battle.pl */

/* pertama cek dulu apakah dia menemukan chest atau musuh */
chest_encounter :- 
    encounter_enemy(100, X), !,
    encounter(X).

chest_encounter :- !.

/* jika dia tidak menemukan chest */
encounter(X) :- 
    X < 3,
    write('You encounter a '),
    enemy_type(X, EncounterName), !,
    write(EncounterName),
    write('!\n'),
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

    print_info,

    trigger_battle.

/* jika dia menemukan chest */
encounter(X) :- 
    X =:= 3,
    random(1, 101, ChestRate),
    gacha_chest(ChestRate).

/* buat nentuin dia ketemu mimic atau tidak */
gacha_chest(ChestRate) :- 
    ChestRate =< 70,
    player_level(PlayerLevel),
    chestLoot(MinGold),
    MaxGold is MinGold + 100*PlayerLevel,
    random(MinGold, MaxGold, Loot),    
    write('You found a chest!! You get : '), write(Loot), write(' gold'), !.

gacha_chest(X) :-
    ChestRate > 70,
    write('You encounter a '),
    enemy_type(3, EncounterName),
    write(EncounterName),
    write('!\n'),
    random(1, 6, EnemyLevel),
    retract(lvl_enemy(_)),
    assertz(lvl_enemy(EnemyLevel)),
    
    enemy_health(3, Hp),
    ScaleHp is Hp + 10*EnemyLevel,
    retract(hp_enemy(_)),
    assertz(hp_enemy(ScaleHp)),
    
    enemy_attack(3, Att),
    ScaleAtt is Att + 5*EnemyLevel,
    retract(att_enemy(_)),
    assertz(att_enemy(ScaleAtt)),

    enemy_defense(3, Def),
    ScaleDef is Def + 2*EnemyLevel,
    retract(def_enemy(_)),
    assertz(def_enemy(ScaleDef)),

    print_info,

    trigger_battle.

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