:- dynamic(shopactive/0).
/*Nanti disatuin semua ke main biar ada game state (battle,shop,inventory,travelling,dll). */

shop:- game_state(shopactive),!,writeShopUsedMessage,fail.

shop:-
    assertz(game_state(shopactive)),!,
    write('What do you want to buy?'),nl,
    write('1. Gacha (1000 gold)'),nl,
    write('2. Health Potion (100 gold)'),nl.
    write('3. Panas spesial 2 mekdi (150 gold)' ),nl.
    write('4. Sadikin (200 gold)'),nl.
    write('5. Go milk (250 gold)'),nl.
    write('6. Crisbar (300 gold)'),nl.

% GACHA 
listIdx([X], 0, X).
listIdx([H|_], 0, H).
listIdx([_|T], idx, elmt) :- 
    idx2 is idx-1, 
    listIdx(T, idx2, elmt).

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
gacha:-
    game_state(shopactive),
    current_gold(G),
    G >= 1000,
    random(0,59,idx),
    listIdx(L,idx,elmt),
    addToInventory([elmt|1]),
    writeGacha(elmt).

writeGacha(elmt):-
    \+(ultraRareItem(elmt)),
    \+(rareItem(elmt)),
    format('You got ~w.~n',[elmt]),!.

writeGacha(elmt):-
    ultraRareItem(elmt),
    format('You got ~w (ULTRA RARE).~n',[elmt]),!.

writeGacha(elmt):-
    rareItem(elmt),
    format('You got ~w (RARE).~n',[elmt]),!.
    
% POTION

healthpotion:- \+game_state(shopactive),!,writeShopIsNotOpenMessage,fail.
healthpotion:-
    game_state(shopactive),
    current_gold(G),
    price('health potion', P),
    G >= P,
    retract(current_gold(G)),
    G2 is G-P,
    assertz(current_gold(G2)),
    addToInventory(['health potion'|1]),
    write('Thanks for buying!'),nl.

panas:- \+game_state(shopactive),!,writeShopIsNotOpenMessage,fail.
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
sadikin:-
    game_state(shopactive),
    current_gold(G),
    price('sadikin', P),
    G >= P,
    retract(current_gold(G)),
    G2 is G-P,
    assertz(current_gold(G2)),
    addToInventory(['sadikin'|1]).
    write('Thanks for buying!'),nl.

gomilk:- \+game_state(shopactive),!,writeShopIsNotOpenMessage,fail.
gomilk:-
    game_state(shopactive),
    current_gold(G),
    price('go milk',P),
    G >= P,
    retract(current_gold(G)),
    G2 is G-P,
    assertz(current_gold(G2)),
    addToInventory(['health potion'|1]).
    write('Thanks for buying!'),nl.

crisbar :- \+game_state(shopactive),!,writeShopIsNotOpenMessage,fail.
crisbar:-
    game_state(shopactive),
    current_gold(G),
    price('crisbar',P),
    G >= P,
    retract(current_gold(G)),
    G2 is G-P,
    assertz(current_gold(G2)),
    addToInventory(['health potion'|1]).    
    write('Thanks for buying!'),nl.

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