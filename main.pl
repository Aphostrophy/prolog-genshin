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
    nl,
    write('                                .:-.`         ``......-:...-` `..-`.    ``..````.-///:.                 `.--.        '),nl,
    write('                              .--.        ...---.```  ```-``.  ...........```````.-----                   `.:-.      '),nl,
    write('                           `--.`    `-:::.````````..--.-..`:` -`.---````....--:------`                     `-:-`     '),nl,
    write('                           -:-`      ///--````.---.``  `..` -- .  ```      ```:::--.                          `-:.   '),nl,
    write('                         `--.        -::--.-::.`            .: .`` `   `.--....`                                .:-` '),nl,
    write('                        .--`          `.---:::-....`.`     `.. `..`  ```....`                                    `--`'),nl,
    write('                       .:-`                 ```````````    ..-` `-           ````                                 `'),nl,
    write('                      .:-`                       ```        `:: :                `.``                              '),nl,
    write('                 ------ `                      ``             :`.                   `.`                            '),nl,
    write('                     `                       ``               .-.                     `.`                          '),nl,
    write('                                           `                  `              ``         ``                         '),nl,
    write('                                         `                                    ::.         ``                       '),nl,
    write('                                       ``                                     /os+-.`       `.`                    '),nl,
    write('                                    `.`                           `           -ddmmNNmm:          ```.``````       '),nl,
    write('                                    ``               `             -`         :oshmNNNNs                ``..       '),nl,
    write('                                   ``                 .            ---           `.:smNm`       `       `.`        '),nl,
    write('                               ```                  `:-           ...-.`            .om+        `.``..-.`        `:'),nl,
    write('                 `         ``..`                  ``:`--           :  `--.    ``      -h.         ---`         `..+'),nl,
    write('                 .::..``....``       `            ./`  -:`         ..  ``.-.```.`      ./          ``...``````.``-:'),nl,
    write('                   .--..`          ``            `o.````.:-`        -`      `.-:/`      `               ````  ``:/ '),nl,
    write('                     `.--...`````````            ::`      .:-`       .` ``.---` ./             `````    ````..-/:  '),nl,
    write('                         ```.----:.``            /  ```.--.`.-:-.```  .:ydmmmdyo/--             ``.-........-::.   '),nl,
    write('                                :-``             :``/hhhhhs/   ..--//-.:hmddmmsoh//             ```.--.----:-.    `'),nl,
    write('                         `...` :-``.             /:dsymmhdm/        ````md/.hmm`o-::             ````--..:/.    `.``'),nl,
    write('                      ``.````-/-.``.             +yy`mNh.-hh            os+:+o/ .`-/       `      ````--..-:.  ..```'),nl,
    write('                    ``````````-:.``:`   `       `+./`ohs+://            `::--.`  .-/`       `     ````.:-.../..````'),nl,
    write('                 ``````````````:-../.   `       `/-`` ://-.`                    `::/-       `      ````::...-o`````'),nl,
    write('                 ````````````` `:.-/.`   `      `/:-           `  ```.`         :/.-:      ```     ````-+::..+```````'),nl,
    write('                 ````````       :oso/.`  ``     `+:+-         .:-....--        .+--:-     ````      ``.-/ -/-+. `````'),nl,
    write('                 ``````````     -::sh-``  ``    `::-+:`       `...``...      `-/---/`    ```.      ```--:  `++` ``````'),nl,
    write('                 `````````````  :o+:/s-`` `.`    .oyhmy/.`     ```````    `-oo/:--:.  `````.-     ``--./` ``:+.....```'),nl,
    write('                 ```````````----+dNNdhm+````..`  .+NNNNNmhy+:-.``    `.-+shmmmmds/.```````.:`  ````./.-+:--.``...:-` `'),nl,
    write('                  ``````` `-:-:/-hmmmmNNh/.``...``.oNNNNNNNNNNmdhyysyydmmmmmNmho-````````.-`       ://::-....``...    '),nl,
    write('                 ``        :      :sdmmmmNmy+--:-...+mNNNNmmmmmmNNNNNNmmmmmNNdyso//::-:+s-`       .+:.`.-.` ```       '),nl,
    write('                   ``      `.       ./sdmmNNNNNddho:--ohdddh+-dmmmmmNNNNNNNNNNNNNNNdysoo:``      -/` `-.            `.'),nl,nl,nl,

    write('     #                  ######   ##########          #   ######     ######        ######   ##########                       #          ######   '), nl,
    write('    #      ##########            #        #         #      #                        #      #        # ##########   ######   #   ###      #      '), nl,
    write('   #               #  ##########         #     #   #   ########## ##########    ##########         #          #         #   ####     ########## '), nl,
    write('  #               #   #        #        #       # #        #      #        #        #             #          #          #   #            #      '), nl,
    write(' #     #       # #           ##        #         #         #             ##         #            #        # #           #   #            #      '), nl,
    write('#########       #          ##        ##        ## #        #           ##           #          ##          #     ########## #            #      '), nl,
    write('         #       #       ##        ##        ##    #        ####     ##              ####    ##             #                #######      ####  '), nl,nl,
    write('% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %'),nl,
    write('%    Main Menu:                                                                                                                                 %'),nl,
    write('%                                                                                                                                               %'),nl,
    write('%    NEW                                                                                                                                        %'),nl,
    write('%    LOAD                                                                                                                                       %'),nl,
    write('% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %'),nl,
    
    assertz(game_opened).

new :-
    game_opened,!,
    (\+ game_start),

    assertz(game_start), assertz(game_state(travelling)), !,
    write('================================================================================================================================================'),nl,
    write('             @@@@@@@@@   @@@@@@@@@   @@@@@@@@@   @      @   @   @     @      @   @@@@@@@@@   @@@@@@@@@   @   @     @@@@@@     @                 '),nl,
    write('             @       @   @           @           @      @   @   @@    @      @   @           @           @  @     @      @    @                 '),nl,
    write('             @           @           @           @      @   @   @ @   @      @   @           @           @ @     @        @   @                 '),nl,
    write('             @           @@@@@@@@@   @@@@@@@@@   @@@@@@@@   @   @  @  @      @   @@@@@@@@@   @@@@@@@@@   @       @        @   @                 '),nl,
    write('             @  @@@@@@   @                   @   @      @   @   @   @ @      @           @   @           @ @     @@@@@@@@@@   @                 '),nl,
    write('             @       @   @                   @   @      @   @   @    @@      @           @   @           @  @    @        @   @                 '),nl,
    write('             @@@@@@@@@   @@@@@@@@@   @@@@@@@@@   @      @   @   @     @      @   @@@@@@@@@   @@@@@@@@@   @   @   @        @   @                 '),nl,nl,
    write('================================================================================================================================================'),nl,nl,
    choose_class,

    /* Inisialisasi variabel */
    
    assertz(type_enemy(0)),
    assertz(hp_enemy(0)),
    assertz(att_enemy(0)),
    assertz(def_enemy(0)),
    assertz(lvl_enemy(0)),
    assertz(special_timer(0)),
    assertz(buff_att(0)),
    assertz(buff_def(0)),

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
    write('The game has already been started. Use \'help.\' to look for available commands!').

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
    write('Use \'fight.\' to fight against the encountered enemy.'), nl,
    write('Use \'run.\' to run away from the enemy. This command might as well not work as it is and you have no choice but to fight the enemy.'),nl,
    write('Use \'attack.\' to attack di enemy you\'re currently facing.'),nl,
    write('Use \'special_attack.\' to use special attack ONLY when you face the boss.'),nl,
    write('Use \'item.\' to use items in your inventory.'),nl,
    write('Use \'status.\' to get the player info.'),nl.

help :-
    game_state(in_quest_dialogue),!,
    write('You are currently negotiating a quest offered to you. Here are the valid commands for this state.'),nl,
    write('Use \'yes.\' to accept the quest.'),nl,
    write('Use \'no.\' to reject the quest.'),nl.

help :-
    game_state(shopactive),!,
    write('The shop is now open! Here are some commands to get the stuff you needed.'),nl,
    write('Use \'gacha.\' to get a random item with a random class and keep it in your inventory.'),nl,
    write('Use \'healthpotion.\' to buy a health potion.'),nl,
    write('Use \'panas.\' to buy a panas spesial 2 mekdi.'),nl,
    write('Use \'sadikin.\' to buy a sadikin.'),nl,
    write('Use \'gomilk.\' to buy a go milk.'),nl,
    write('Use \'crisbar.\' to buy a crisbar.'),nl,
    write('Use \'exitshop.\' to exit the shop.'),nl.

help :-
    game_state(travelling),!,
    write('You are currently travlling in the outside world! Here are some commands to guide you through this fantasy map.'), nl,
    write('Use \'w.\' to move upward'), nl,
    write('Use \'a.\' to move to the left'), nl,
    write('Use \'s.\' to move downward'), nl,
    write('Use \'d.\' to move to the right'), nl,
    write('Use \'map.\' to print the map you are currently in.'),nl,
    write('Use \'quest.\' to do a quest when arriving at a place labeled \'Q\'.'),nl,
    write('Use \'shop.\' to open the shop.'),nl,
    write('Use \'item.\' to use items in your inventory.'),nl,
    write('Use \'quest_info.\' to get the remaining enemies to be killed when doing your quest.'),nl,
    write('Use \'teleport.\' to move to a specific coordinate on the map.'),nl,
    write('Use \'status.\' to get the player info.'),nl,
    write('You might encounter an enemy while you\'re travelling, so be ready for them!'),nl.

check_inventory :-
    write('You have nothing in your inventory! You can buy some in the shop.').

save:-
    game_opened,game_state(travelling),!,
    open('backup.pl',write,S), set_output(S), write(':- dynamic(player_class/1).'),nl,
    write(':- dynamic(player_level/1).'),nl,
    write(':- dynamic(equipped_weapon/1).'),nl,
    write(':- dynamic(player_health/1).'),nl,
    write(':- dynamic(player_attack/1).'),nl,
    write(':- dynamic(player_defense/1).'),nl,
    write(':- dynamic(player_max_health/1).'),nl,
    write(':- dynamic(player_max_attack/1).'),nl,
    write(':- dynamic(player_max_defense/1).'),nl,
    write(':- dynamic(current_gold/1).'),nl,
    write(':- dynamic(current_exp/1).'),nl,
    write(':- dynamic(upgradable/0).'),nl,
    write(':- dynamic(inventory_bag/2).'),nl,
    write(':- dynamic(quest_active/1).'),nl,
    write(':- dynamic(slime_counter/1).'),nl,
    write(':- dynamic(hilichurl_counter/1).'),nl,
    write(':- dynamic(mage_counter/1).'),nl,
    write(':- dynamic(game_opened/0).'),nl,
    write(':- dynamic(game_start/0).'),nl,
    write(':- dynamic(game_state/1).'),nl,
    write(':- dynamic(type_enemy/1).'),nl,
    write(':- dynamic(hp_enemy/1).'),nl,
    write(':- dynamic(att_enemy/1).'),nl,
    write(':- dynamic(def_enemy/1).'),nl,
    write(':- dynamic(lvl_enemy/1).'),nl,
    write(':- dynamic(map_entity/3).'),nl,
    write(':- dynamic(isPagar/2).'),nl,
    write(':- dynamic(draw_done/1).'),nl,
    write(':- dynamic(fight_or_run/0).'),nl,
    write(':- dynamic(can_run/0).'),nl,
    write(':- dynamic(special_timer/1).'),nl,
    write(':- dynamic(shopactive/0).'),nl,
    listing,
    close(S).

save:-
    write('You cannot save now').

load:-
    file_exists('backup.pl'),
    game_opened,!,
    ['backup.pl'].

load:-
    \+file_exists('backup.pl'),
    game_opened,!,write('No save files detected').