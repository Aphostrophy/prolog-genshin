/* inventory(list,totalIsi) */

inventoryMaxSize(100).

inventory :-
    inventory_bag(Inventory,_),
    printInventory(Inventory).

printInventory([]).

printInventory([H|T]) :-
    printPair(H),printInventory(T).

printPair([H|T]) :-
    [Amount|None] = T,Amount>0,
    write(H),write(':'),write(Amount),nl.

addToInventory([Name|Amount]) :-
    inventory_bag(Inventory,Size),
    member([Name|_],Inventory),!,
    modifyElement([Name|Amount], Inventory, NewInventory),
    NewSize is Size + Amount,
    retract(inventory_bag(Inventory,Size)),!,
    assertz(inventory_bag(NewInventory,NewSize)).

addToInventory([Name|Amount]) :-
    inventory_bag(Inventory,Size),
    \+member([Name|_],Inventory),
    push([Name,Amount],Inventory,NewInventory),
    NewSize is Size + Amount,
    retract(inventory_bag(Inventory,Size)),!,
    assertz(inventory_bag(NewInventory,NewSize)).

substractFromInventory([Name|Amount]) :-
    inventory_bag(Inventory,Size),
    member([Name|_],Inventory),!,
    reduceElement([Name|Amount],Inventory,NewInventory),
    NewSize is Size - Amount,
    retract(inventory_bag(Inventory,Size)),!,
    assertz(inventory_bag(NewInventory,NewSize)).

substractFromInventory([Name|Amount]) :- write('Hey dont cheat!'),nl,fail.

findItemAmount(Name,X) :-
    inventory_bag(Inventory,Size),
    member([Name|_],Inventory),!,
    getItemAmount(Name,Inventory,X).

findItemAmount(Name,X) :-
    inventory_bag(Inventory,Size),
    \+member([Name|_],Inventory),!,X is 0.

equip(Item) :- game_state(in_battle),!,write('Cannot equip item in battle').

equip(Item) :- \+item(Item),!,write('That is not an item').

equip(Item) :- findItemAmount(Item,X),X =< 0,!,write('Item not in inventory').

equip(Item) :-
    type(ItemType,Item),player_class(Class),
    weapon(ItemType),equipmentAllowed(Class,Item),!,retract(equipped_weapon(_)),assertz(equipped_weapon(Item)),
    write(ItemType).

equip(Item) :- 
    type(ItemType,Item),player_class(Class),
    weapon(ItemType),\+equipmentAllowed(Class,Item),!,
    write('This weapon is not suitable for your class').

equip(Item) :-
    type(ItemType,Item),
    cover(ItemType),!,retract(equipped_cover(_)),assertz(equipped_cover(Item)).