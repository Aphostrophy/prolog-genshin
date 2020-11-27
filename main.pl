/* File Utama */

/* Keadaan player, battle kah? travelling kah? buka shop kah? */

:- dynamic(player_class/1).
:- dynamic(player_level/1).
:- dynamic(equipped_weapon/1).
:- dynamic(equipped_cover/1).
:- dynamic(player_health/1).
:- dynamic(player_attack/1).
:- dynamic(player_defense/1).
:- dynamic(buff_att/1).
:- dynamic(buff_def/1).

:- dynamic(player_attack_mult/1).
:- dynamic(player_defense_mult/1).

:- dynamic(player_max_health/1).

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
    write('         #       #       ##        ##        ##    #        ####     ##              ####    ##             #                #######      ####  '), nl,
    write('================================================================================================================================================'),nl,
    write('                                     |Welcome to Genshin Asik Cihuy Semoga Bagus Hasilnya!|                                                     '),nl,
    write('                                     |                   Main Menu:                       |                                                     '),nl,
    write('                                     |                  1. New Game                       |                                                     '),nl,
    write('                                     |                  2. Load Game                      |                                                     '),nl,
    write('                                     |   Type \'new.\' or \'load.\' to start the game.        |                                                 '),nl,
    write('================================================================================================================================================'),nl,
    assertz(game_opened).

new :-
    game_opened,!,
    (\+ game_start),

    assertz(game_start), assertz(game_state(travelling)), !,
    write('================================================================================================================================================'),nl,
    write('           @@@@@@@@@   @@@@@@@@@   @     @   @@@@@@@@@   @      @   @   @     @      @   @@@@@@@@@   @@@@@@@@@   @   @     @@@@@@     @         '),nl,
    write('           @       @   @           @@    @   @           @      @   @   @@    @      @   @           @           @  @     @      @    @         '),nl,
    write('           @           @           @ @   @   @           @      @   @   @ @   @      @   @           @           @ @     @        @   @         '),nl,
    write('           @           @@@@@@@@@   @  @  @   @@@@@@@@@   @@@@@@@@   @   @  @  @      @   @@@@@@@@@   @@@@@@@@@   @       @        @   @         '),nl,
    write('           @  @@@@@@   @           @   @ @           @   @      @   @   @   @ @      @           @   @           @ @     @@@@@@@@@@   @         '),nl,
    write('           @       @   @           @    @@           @   @      @   @   @    @@      @           @   @           @  @    @        @   @         '),nl,
    write('           @@@@@@@@@   @@@@@@@@@   @     @   @@@@@@@@@   @      @   @   @     @      @   @@@@@@@@@   @@@@@@@@@   @   @   @        @   @         '),nl,nl,
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
    setBorder.

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
    write('================================================================================================================================================'),nl,
    write('|                          You are currently in a battle. Here are some commands to help you get through the battle.                           |'),nl,
    write('================================================================================================================================================'),nl,
    write('|        Commmand        |                                                           Function                                                  |'),nl,
    write('|------------------------|---------------------------------------------------------------------------------------------------------------------|'),nl,
    write('|       \'fight.\'         |     Fight against the encountered enemy.                                                                            |'),nl,
    write('|        \'run.\'          |     Run away from the enemy. Might as well not work as it is and you have no choice but to fight the enemy.         |'),nl,
    write('|       \'attack.\'        |     Attack the enemy you\'re currently facing.                                                                       |'),nl,
    write('|   \'special_attack.\'    |     Use special attack ONLY when you face the boss.                                                                 |'),nl,
    write('|       \'item.\'          |     Use items in your inventory.                                                                                    |'),nl,
    write('|       \'status.\'        |     Get the player info.                                                                                            |'),nl,
    write('================================================================================================================================================'),nl.

help :-
    game_state(in_quest_dialogue),!,
    write('================================================================================================================================================'),nl,
    write('|                       You are currently negotiating a quest offered to you. Here are the valid commands for this state.                      |'),nl,
    write('================================================================================================================================================'),nl,
    write('|        Commmand        |                                                           Function                                                  |'),nl,
    write('|------------------------|---------------------------------------------------------------------------------------------------------------------|'),nl,
    write('|        \'yes.\'          |     accept the quest.                                                                                               |'),nl,
    write('|         \'no.\'          |     reject the quest.                                                                                               |'),nl,
    write('================================================================================================================================================'),nl.

help :-
    game_state(shopactive),!,
    write('================================================================================================================================================'),nl,
    write('|                              The shop is now open! Here are some commands to get the stuff you needed.                                       |'),nl,
    write('================================================================================================================================================'),nl,
    write('|        Commmand        |                                                           Function                                                  |'),nl,
    write('|------------------------|---------------------------------------------------------------------------------------------------------------------|'),nl,
    write('|       \'gacha.\'         |     Get a random item with a random class and keep it in your inventory.                                            |'),nl,
    write('|    \'health potion.\'    |     Buy a health potion.                                                                                            |'),nl,
    write('|       \'panas.\'         |     Buy a panas spesial 2 mekdi.                                                                                    |'),nl,
    write('|      \'sadikin.\'        |     Buy a sadikin.                                                                                                  |'),nl,
    write('|       \'go milk.\'       |     Buy a go milk.                                                                                                  |'),nl,
    write('|      \'crisbar.\'        |     Buy a crisbar.                                                                                                  |'),nl,
    write('|      \'exitShop.\'       |     Exit the shop.                                                                                                  |'),nl,
    write('|        \'sell.\'         |     Sell items in your inventory.                                                                                   |'),nl,
    write('================================================================================================================================================'),nl.

help :-
    game_state(travelling),!,
    write('================================================================================================================================================'),nl,
    write('|              You are currently travlling in the outside world! Here are some commands to guide you through this fantasy map.                 |'),nl,
    write('================================================================================================================================================'),nl,
    write('|        Commmand        |                                                           Function                                                  |'),nl,
    write('|------------------------|---------------------------------------------------------------------------------------------------------------------|'),nl,
    write('|        \'w.\'          |     Move upward.                                                                                                    |'),nl,
    write('|        \'a.\'          |     Move to the left.                                                                                               |'),nl,
    write('|        \'s.\'          |     Move downward.                                                                                                  |'),nl,
    write('|        \'d.\'          |     Move to the right.                                                                                              |'),nl,
    write('|       \'map.\'         |     Print the map you are currently in.                                                                             |'),nl,
    write('|      \'quest.\'        |     Do a quest when arriving at a place labeled \'Q\'.                                                              |'),nl,
    write('|       \'shop.\'        |     Open the shop.                                                                                                  |'),nl,
    write('|     \'inventory.\'     |     Check your inventory.                                                                                           |'),nl,
    write('|       \'item.\'        |     Use items in your inventory.                                                                                    |'),nl,
    write('|   \'equipped_items.\'  |     Check your equipped weapon and armor                                                                            |'),nl,
    write('|    \'quest_info.\'     |     Get the remaining enemies to be killed when doing your quest.                                                   |'),nl,
    write('|     \'teleport.\'      |     Move to a specific waypoint on the map when you are in a waypoint labelled T.                                   |'),nl,
    write('|      \'status.\'       |     Get the player info.                                                                                            |'),nl,
    write('|      \'equip.\'        |     Equip a weapon or armor from inventory. Usage : equip(\'item name\') .                                          |'),nl,
    write('================================================================================================================================================'),nl,
    write('|                               You might encounter an enemy while you\'re travelling, so be ready for them!                                   |'),nl,
    write('================================================================================================================================================'),nl.

save:-
    game_opened,game_state(travelling),!,
    open('backup.pl',write,S), set_output(S), write(':- dynamic(player_class/1).'),nl,
    write(':- dynamic(player_level/1).'),nl,
    write(':- dynamic(equipped_weapon/1).'),nl,
    write(':- dynamic(equipped_cover/1).'),nl,
    write(':- dynamic(player_health/1).'),nl,
    write(':- dynamic(player_attack/1).'),nl,
    write(':- dynamic(player_defense/1).'),nl,
    write(':- dynamic(buff_att/1).'),nl,
    write(':- dynamic(buff_def/1).'),nl,
    write(':- dynamic(player_max_health/1).'),nl,
    write(':- dynamic(player_attack_mult/1).'),nl,
    write(':- dynamic(player_defense_mult/1).'),nl,
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