/* inventory(list,totalIsi) */

inventoryMaxSize(100).

inventory :-
    write('==============================================='),nl,
    write('           I  N  V  E  N  T  O  R  Y           '),nl,
    write('==============================================='),nl,nl,
    inventory_bag(Inventory,_),
    printInventory(Inventory),nl,
    write('==============================================='),!,nl.

printInventory([]).

printInventory([H|T]) :-
    printPair(H),printInventory(T).

printPair([H|T]) :-
    [Amount|None] = T,Amount>0,!,
    type(C,H),format('[type : ~w] ',[C]),write(H),write(' : '),write(Amount),nl.

printPair([H|T]) :- !.

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
    findItemAmount(Name,Supply),
    Supply>=Amount,!,

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

equip(Item) :- game_state(in_battle),!,write('Cannot equip item in battle.').

equip(Item) :- \+item(Item),!,write('That is not an item.').

equip(Item) :- findItemAmount(Item,X),X =< 0,!,write('Item not in inventory.').

equip(Item) :-
    type(ItemType,Item),player_class(Class),
    weapon(ItemType),equipmentAllowed(Class,Item),!,
    equipped_weapon(CurrentWeapon),property(CurrentWeapon,CurrentWeaponAttack),
    NewMaxAttack is CurrentAttack + NewWeaponAttack - CurrentWeaponAttack,
    retract(equipped_weapon(CurrentWeapon)),assertz(equipped_weapon(Item)),
    property(Weapon, MultAttack),
    retract(player_attack_mult(_)),assertz(player_attack_mult())
    substractFromInventory([Item|1]),addToInventory([CurrentWeapon|1]),
    write('Equipped '),write(Item).

equip(Item) :- 
    type(ItemType,Item),player_class(Class),
    weapon(ItemType),\+equipmentAllowed(Class,Item),!,
    write('This weapon is not suitable for your class.').

equip(Item) :-
    type(ItemType,Item),
    cover(ItemType),!,
    equipped_cover(CurrentCover),
    player_max_health(CurrentMaxHealth),
    property(CurrentCover,OldArmorDefense,OldArmorHealth),property(Item,NewArmorDefense,NewArmorHealth),
    NewMaxHealth is CurrentMaxHealth + NewArmorHealth - OldArmorHealth,
    NewMaxDefense is CurrentMaxDefense + NewArmorDefense - OldArmorDefense,
    retract(equipped_cover(_)),assertz(equipped_cover(Item)),
    property(Armor,MultDefense,MultHealth),
    substractFromInventory([Item|1]),addToInventory([CurrentCover|1]),
    write('Equipped '),write(Item).

equipped_items:-
    equipped_weapon(X),
    write('Weapon:'),write(X),nl,
    property(X,Attack),write('Attack Bonus: '),write(Attack),nl,
    equipped_cover(Y),property(Y,Defense,HP),
    write('Armor:'),write(Y),nl,
    write('Bonus Defense: '),write(Defense),nl,
    write('Bonus Health: '),write(HP).