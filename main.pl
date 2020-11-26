/* File Utama */

/* Keadaan player, battle kah? travelling kah? buka shop kah? */

:- dynamic(player_class/1).
:- dynamic(player_level/1).
:- dynamic(equipped_weapon/1).
:- dynamic(player_health/1).
:- dynamic(player_attack/1).
:- dynamic(player_defense/1).

:- dynamic(player_max_health/1).
:- dynamic(player_max_attack/1).
:- dynamic(player_max_defense/1).

:- dynamic(current_gold/1).
:- dynamic(current_exp/1).
:- dynamic(upgradable/0).

:- dynamic(inventory_bag/2).

:- dynamic(quest_active/1).
:- dynamic(slime_counter/1).
:- dynamic(hilichurl_counter/1).
:- dynamic(mage_counter/1).

:- dynamic(game_opened/0).
:- dynamic(game_start/0).
:- dynamic(game_state/1).

:- dynamic(type_enemy/1).
:- dynamic(hp_enemy/1).
:- dynamic(att_enemy/1).
:- dynamic(def_enemy/1).
:- dynamic(lvl_enemy/1).

:- dynamic(map_entity/3).
:- dynamic(draw_done/1).

:- dynamic(fight_or_run/0).
:- dynamic(can_run/0).
:- dynamic(special_timer/1).

:- dynamic(shopactive/0).

start:-
    nl,
    ['encounter_enemy.pl'],
    ['utility.pl'],
    ['items.pl'],
    ['quest.pl'],
    ['enemy.pl'],
    ['class.pl'],
    ['player.pl'],
    ['inventory.pl'],
    ['shop.pl'],
    ['battle.pl'],
    ['map.pl'],
    ['save.pl'],
    write('     #                  ######   ##########          #   ######     ######        ######   ##########                       #          ######   '), nl,
    write('    #      ##########            #        #         #      #                        #      #        # ##########   ######   #   ###      #      '), nl,
    write('   #               #  ##########         #     #   #   ########## ##########    ##########         #          #         #   ####     ########## '), nl,
    write('  #               #   #        #        #       # #        #      #        #        #             #          #          #   #            #      '), nl,
    write(' #     #       # #           ##        #         #         #             ##         #            #        # #           #   #            #      '), nl,
    write('#########       #          ##        ##        ## #        #           ##           #          ##          #     ########## #            #      '), nl,
    write('         #       #       ##        ##        ##    #        ####     ##              ####    ##             #                #######      ####  '), nl,
    write('Main Menu:'),nl,
    write('new'),nl,
    write('load'),
    assertz(game_opened).

new :-
    game_opened,!,
    (\+ game_start),

    assertz(game_start), assertz(game_state(travelling)), !,

    choose_class,

    /* Inisialisasi variabel */
    
    assertz(type_enemy(0)),
    assertz(hp_enemy(0)),
    assertz(att_enemy(0)),
    assertz(def_enemy(0)),
    assertz(lvl_enemy(0)),
    assertz(special_timer(0)),
    assertz(slime_counter(0)),
    assertz(hilichurl_counter(0)),
    assertz(mage_counter(0)),
    assertz(quest_active(false)),
    asserta(map_entity(1, 1, 'P')),
    asserta(map_entity(13, 1, 'S')),
    asserta(map_entity(15, 15, 'B')),
    asserta(map_entity(2, 7, 'Q')),
    asserta(map_entity(13, 3, 'T')),
    asserta(map_entity(2, 5, 'T')),
    asserta(map_entity(3, 14, 'T')),
    asserta(map_entity(14, 12, 'T')),
    asserta(draw_done(true)),
    setBorder(0,0).

new :-
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
    write('You are currently in a battle. Here are some commands to help you get through the battle.'), nl,
    write('Use command \'fight.\' to fight against the encountered enemy.'), nl,
    write('Use command \'run.\' to run away from the enemy. This command might as well not work as it is and you have no choice but to fight the enemy.').

help :-
    game_state(in_quest_dialogue),!,
    write('Please finish your quest dialogue first before continuing.').

help :-
    game_state(shopactive),!,
    write('You are currently in the shop. Here are some commands to get the stuff you needed.').

help :-
    game_state(travelling),!,
    write('You are currently travlling in the outside world! Here are some commands to guide you through this fantasy map.'), nl,
    write('Use command \'w.\' to move upward'), nl,
    write('Use command \'a.\' to move to the left'), nl,
    write('Use command \'s.\' to move downward'), nl,
    write('Use command \'d.\' to move to the right'), nl,
    write('You might encounter an enemy while you\'re travelling, so be ready for them!').

check_inventory :-
    write('You have nothing in your inventory! You can buy some in the shop.').

l:-
    ['a.dat'].