:- dynamic(inventory_bag/2).
/* inventory(list,totalIsi) */

inventoryMaxSize(100).

inventory :-
    inventory_bag(Inventory,_),
    printInventory(Inventory).

printInventory([]).

printInventory([H|T]) :-
    printPair(H),printInventory(T).

printPair([H|T]) :-
    [Amount|None] = T,
    write(H),write(':'),write(Amount),nl.

addToInventory([Name|Amount]) :-
    inventory_bag(Inventory,Size),
    member([Name|_],Inventory),
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
