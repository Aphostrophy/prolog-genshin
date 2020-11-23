:- dynamic(shopactive/0).
/*Nanti disatuin semua ke main biar ada game state (battle,shop,inventory,travelling,dll). */

shop:- game_state(shopactive),!,writeShopUsedMessage,fail.

shop:-
    assertz(game_state(shopactive)),
    write('What do you want to buy?'),nl,
    write('1. Gacha (1000 gold)'),nl,
    write('2. Health Potion (100 gold)'),nl.

gacha:- \+game_state(shopactive),!,writeShopIsNotOpenMessage,fail.

gacha:-
    write('Nunggu items jadi semua').

exitShop:- \+game_state(shopactive),!,writeShopIsNotOpenMessage,fail.

exitShop:-
    retract(game_state(shopactive)),
    assertz(game_state(travelling)),
    write('Farewell Traveller'),nl.

writeShopIsNotOpenMessage :-
    write('Please open the shop first'),nl.

writeShopUsedMessage :-
    write('You have already opened shop'), nl.

hehe:-
    write('EHE TO NANDAYO?'),nl.