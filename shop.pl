
/*Nanti disatuin semua ke main biar ada game state (battle,shop,inventory,travelling,dll). */

shop:- game_state(shopactive),!,writeShopUsedMessage,fail.
shop:-
    map_entity(X,Y,'P'),
    map_entity(X,Y,'S'),
    retract(game_state(travelling)),
    assertz(game_state(shopactive)),!,
    write('==========================================================================================='),nl,
    write('|                                        S   H   O   P                                    |'),nl,
    write('==========================================================================================='),nl,
    write('|                      Welcome to the shop! What do you want to do?                       |'),nl,
    write('==========================================================================================='),nl,
    write('|    Activity    |         Item          |        Price          |        Command         |'),nl,
    write('-----------------|-----------------------|-----------------------|------------------------|'),nl,
    write('|     Gacha      |   Weapon and Armor    |      1000 gold        |       \'gacha.\'         |'),nl,
    write('|      Buy       |     Health Potion     |      100 gold         |    \'healthpotion.\'     |'),nl,
    write('|      Buy       | Panas Spesial 2 Mekdi |      150 gold         |       \'panas.\'         |'),nl,
    write('|      Buy       |       Sadikin         |      200 gold         |      \'sadikin.\'        |'),nl,
    write('|      Buy       |       Go Milk         |      250 gold         |       \'gomilk.\'        |'),nl,
    write('|      Buy       |       Crisbar         |      300 gold         |      \'crisbar.\'        |'),nl,
    write('|      Buy       |   Attack Potion S     |      300 gold         |    \'attackPotionS.\'    |'),nl,
    write('|      Buy       |   Attack Potion M     |      350 gold         |    \'attackPotionM.\'    |'),nl,
    write('|      Buy       |   Attack Potion L     |      400 gold         |    \'attackPotionL.\'    |'),nl,
    write('|      Buy       |   Defense Potion S    |      250 gold         |    \'defensePotionS.\'   |'),nl,
    write('|      Buy       |   Defense Potion M    |      300 gold         |    \'defensePotionM.\'   |'),nl,
    write('|      Buy       |   Defense Potion L    |      350 gold         |    \'defensePotionL.\'   |'),nl,
    write('|      Sell      |       All items       |   Depends on item     |        \'sell.\'         |'),nl,nl,
    write('==========================================================================================='),nl.
shop:- !,writeNotShopTile.

% GACHA 
listIdx([X], 0, X).
listIdx([H|_], 0, H).
listIdx([_|T], I, E) :- 
    I2 is I-1, 
    listIdx(T, I2, E).

listitem(['waster greatsword','waster greatsword','waster greatsword','waster greatsword','waster greatsword',
           'old merc pal', 'old merc pal','old merc pal','old merc pal',
           'debate club','debate club','debate club',
           'prototype aminus','prototype aminus',
           'wolf greatsword',
           'hunter bow','hunter bow','hunter bow','hunter bow','hunter bow',
           'seasoned hunter bow','seasoned hunter bow','seasoned hunter bow','seasoned hunter bow',
           'messenger','messenger','messenger',
           'favonius warbow','favonius warbow',
           'skyward harp',
           'apprentice notes','apprentice notes','apprentice notes','apprentice notes','apprentice notes',
           'pocket grimoire','pocket grimoire','pocket grimoire','pocket grimoire',
           'emerald orb','emerald orb','emerald orb',
           'mappa mare','mappa mare',
           'skyward atlas',
           'wooden armor','wooden armor','wooden armor','wooden armor','wooden armor',
           'iron armor','iron armor','iron armor','iron armor',
           'steel armor','steel armor','steel armor',
           'golden armor','golden armor',
           'diamond armor']).

gacha:- \+game_state(shopactive),!,writeShopIsNotOpenMessage,fail.
gacha:- current_gold(G),price('gacha',P),G<P,writeNotEnoughGold,fail.
gacha:-
    listitem(L),
    game_state(shopactive),
    current_gold(G),
    price('gacha',P),
    G >= P,
    retract(current_gold(G)),
    G2 is G-P,
    assertz(current_gold(G2)),
    random(0,59,X),
    listIdx(L,X,E),
    addToInventory([E|1]),
    writeGacha(E),!.

writeGacha(E):-
    \+(ultraRareItem(E)),
    \+(rareItem(E)),
    type(C,E),
    format('You got ~w [type : ~w].~n',[E,C]).

writeGacha(E):-
    ultraRareItem(E),
    type(C,E),
    format('Congratulation! you got ~w [type : ~w] (ULTRA RARE).~n',[E,C]).

writeGacha(E):-
    rareItem(E),
    type(C,E),
    format('Congratulation! you got ~w [type : ~w] (RARE).~n',[E,C]).
    
% POTION

healthpotion:- \+game_state(shopactive),!,writeShopIsNotOpenMessage,fail.
healthpotion:- current_gold(G),price('healthpotion',P),G<P,writeNotEnoughGold,fail.
healthpotion:-
    game_state(shopactive),
    current_gold(G),
    price('health potion',P),
    G >= P,
    retract(current_gold(G)),
    G2 is G-P,
    assertz(current_gold(G2)),
    addToInventory(['health potion'|1]),
    write('Thanks for buying!'),nl.

panas:- \+game_state(shopactive),!,writeShopIsNotOpenMessage,fail.
panas:- current_gold(G),price('panas',P),G<P,writeNotEnoughGold,fail.
panas:-
    game_state(shopactive),
    current_gold(G),
    price('panas spesial 2 mekdi', P),
    G >= P,
    retract(current_gold(G)),
    G2 is G-P,
    assertz(current_gold(G2)),
    addToInventory(['panas 2 spesial mekdi'|1]),
    write('Thanks for buying!'),nl.

sadikin:- \+game_state(shopactive),!,writeShopIsNotOpenMessage,fail.
sadikin:- current_gold(G),price('sadikin',P),G<P,writeNotEnoughGold,fail.
sadikin:-
    game_state(shopactive),
    current_gold(G),
    price('sadikin', P),
    G >= P,
    retract(current_gold(G)),
    G2 is G-P,
    assertz(current_gold(G2)),
    addToInventory(['sadikin'|1]),
    write('Thanks for buying!'),nl.

gomilk:- \+game_state(shopactive),!,writeShopIsNotOpenMessage,fail.
gomilk:- current_gold(G),price('gomilk',P),G<P,writeNotEnoughGold,fail.
gomilk:-
    game_state(shopactive),
    current_gold(G),
    price('go milk',P),
    G >= P,
    retract(current_gold(G)),
    G2 is G-P,
    assertz(current_gold(G2)),
    addToInventory(['go milk'|1]),
    write('Thanks for buying!'),nl.

crisbar :- \+game_state(shopactive),!,writeShopIsNotOpenMessage,fail.
crisbar:- current_gold(G),price('crisbar',P),G<P,writeNotEnoughGold,fail.
crisbar:-
    game_state(shopactive),
    current_gold(G),
    price('crisbar',P),
    G >= P,
    retract(current_gold(G)),
    G2 is G-P,
    assertz(current_gold(G2)),
    addToInventory(['crisbar'|1]),
    write('Thanks for buying!'),nl.

attackPotionS :- \+game_state(shopactive),!,writeShopIsNotOpenMessage,fail.
attackPotionS:- current_gold(G),price('attack potion S',P),G<P,writeNotEnoughGold,fail.
attackPotionS:-
    game_state(shopactive),
    current_gold(G),
    price('attack potion S',P),
    G >= P,
    retract(current_gold(G)),
    G2 is G-P,
    assertz(current_gold(G2)),
    addToInventory(['attack potion S'|1]),
    write('Thanks for buying!'),nl.

attackPotionM :- \+game_state(shopactive),!,writeShopIsNotOpenMessage,fail.
attackPotionM:- current_gold(G),price('attack potion M',P),G<P,writeNotEnoughGold,fail.
attackPotionM:-
    game_state(shopactive),
    current_gold(G),
    price('attack potion M',P),
    G >= P,
    retract(current_gold(G)),
    G2 is G-P,
    assertz(current_gold(G2)),
    addToInventory(['attack potion M'|1]),
    write('Thanks for buying!'),nl.

attackPotionL :- \+game_state(shopactive),!,writeShopIsNotOpenMessage,fail.
attackPotionL:- current_gold(G),price('attack potion L',P),G<P,writeNotEnoughGold,fail.
attackPotionL:-
    game_state(shopactive),
    current_gold(G),
    price('attack potion L',P),
    G >= P,
    retract(current_gold(G)),
    G2 is G-P,
    assertz(current_gold(G2)),
    addToInventory(['attack potion L'|1]),
    write('Thanks for buying!'),nl.

defensePotionS :- \+game_state(shopactive),!,writeShopIsNotOpenMessage,fail.
defensePotionS:- current_gold(G),price('defense potion S',P),G<P,writeNotEnoughGold,fail.
defensePotionS:-
    game_state(shopactive),
    current_gold(G),
    price('defense potion S',P),
    G >= P,
    retract(current_gold(G)),
    G2 is G-P,
    assertz(current_gold(G2)),
    addToInventory(['defense potion S'|1]),
    write('Thanks for buying!'),nl.

defensePotionM :- \+game_state(shopactive),!,writeShopIsNotOpenMessage,fail.
defensePotionM:- current_gold(G),price('defense potion M',P),G<P,writeNotEnoughGold,fail.
defensePotionM:-
    game_state(shopactive),
    current_gold(G),
    price('defense potion M',P),
    G >= P,
    retract(current_gold(G)),
    G2 is G-P,
    assertz(current_gold(G2)),
    addToInventory(['defense potion M'|1]),
    write('Thanks for buying!'),nl.

defensePotionL :- \+game_state(shopactive),!,writeShopIsNotOpenMessage,fail.
defensePotionL:- current_gold(G),price('defense potion L',P),G<P,writeNotEnoughGold,fail.
defensePotionL:-
    game_state(shopactive),
    current_gold(G),
    price('defense potion L',P),
    G >= P,
    retract(current_gold(G)),
    G2 is G-P,
    assertz(current_gold(G2)),
    addToInventory(['defense potion L'|1]),
    write('Thanks for buying!'),nl.

exitShop:- \+game_state(shopactive),!,writeShopIsNotOpenMessage,fail.

exitShop:-
    retract(game_state(shopactive)),
    assertz(game_state(travelling)),
    write('Farewell Traveller'),nl.

writeShopIsNotOpenMessage :-
    write('Please open the shop first'),nl.
writeNotShopTile :-
    write('You are not in the shop, use \"map\" to find the shop!'),nl.
writeNotEnoughGold :-
    write('Not enough gold! go clear the quests to get some gold!'),nl.
writeShopUsedMessage :-
    write('You have already opened shop'), nl.

hehe:-
    write('EHE TE NANDAYO?'),nl.

sell:- \+game_state(shopactive),!,writeShopIsNotOpenMessage,fail.
sell :-
    game_state(shopactive),
    inventory,
    write('Type the item\'s name you wish to sell: '), read(Name),
    write('Type the amount of that item: '), read(Amount),
    handle_sell(Name,Amount).


