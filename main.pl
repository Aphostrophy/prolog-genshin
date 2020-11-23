/* File Utama */

:- dynamic(game_start/0).
:- dynamic(game_state/1).
/* Keadaan player, battle kah? travelling kah? buka shop kah? */

start :-
    (\+ game_start),
    ['encounter_enemy.pl'],
    ['calculator.pl'],
    ['items.pl'],
    ['quest.pl'],
    ['enemy.pl'],
    ['class.pl'],
    ['player.pl'],
    ['inventory.pl'],
    ['shop.pl'],
    ['battle.pl'],
    ['map.pl'],

    assertz(game_start), assertz(game_state(travelling)), !,

    nl,
    write('     #                  ######   ##########          #   ######     ######        ######   ##########                       #          ######   '), nl,
    write('    #      ##########            #        #         #      #                        #      #        # ##########   ######   #   ###      #      '), nl,
    write('   #               #  ##########         #     #   #   ########## ##########    ##########         #          #         #   ####     ########## '), nl,
    write('  #               #   #        #        #       # #        #      #        #        #             #          #          #   #            #      '), nl,
    write(' #     #       # #           ##        #         #         #             ##         #            #        # #           #   #            #      '), nl,
    write('#########       #          ##        ##        ## #        #           ##           #          ##          #     ########## #            #      '), nl,
    write('         #       #       ##        ##        ##    #        ####     ##              ####    ##             #                #######      ####  '), nl,

    choose_class,

    /* Inisialisasi variabel */
    assertz(type_enemy(0)),
    assertz(hp_enemy(0)),
    assertz(att_enemy(0)),
    assertz(def_enemy(0)),
    assertz(lvl_enemy(0)),
    assertz(map_entity(1, 1, 'P')),
    assertz(map_entity(5, 3, 'S')),
    assertz(map_entity(9, 9, 'B')),
    assertz(map_entity(2, 7, 'Q')).

start :-
    game_start, !,
    write('The game has already been started. Use \'help.\' to look at available commands!').

quit :- 
    game_start,
    write('Progress will not be saved after you quit.'), nl,
    write('Are you sure? (y/n): '),
    read(Param),
    (Param = y -> halt;
    (Param = n -> fail)).

help :-
    game_state(in_battle),!,
    write('Ini nanti perintah" battle').

help :-
    game_state(in_quest_dialogue),!,
    write('Please finish your queset dialogue first before continuing').

help :-
    game_state(shopactive),!,
    write('Ini nanti perintah" shop').

help :-
    game_state(travelling),!,
    write('Ini nanti perintah" travelling').