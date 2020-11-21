:- dynamic(shopactive/0).
/*Nanti disatuin semua ke main biar ada game state (battle,shop,inventory,travelling,dll). */

shop:- shopactive,!,writeShopUsedMessage,fail.

shop:-
    assertz(shopactive),
    write('What do you want to buy?'),nl,
    write('1. Gacha (1000 gold)'),nl,
    write('2. Health Potion (100 gold)'),nl.

gacha:- \+shopactive,!,writeShopIsNotOpenMessage,fail.

gacha:-
    write('Nunggu items jadi semua').

exitShop:- \+shopactive,!,writeShopIsNotOpenMessage,fail.

exitShop:-
    retract(shopactive),
    write('Farewell Traveller'),nl.

writeShopIsNotOpenMessage :-
    write('Please open the shop first'),nl.

writeShopUsedMessage :-
    write('You have already opened shop'), nl.

hehe:-
    write('EHE TO NANDAYO?'),nl.