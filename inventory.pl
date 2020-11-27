/* inventory(list,totalIsi) */

inventoryMaxSize(100).

inventory :-
    write('==============================================='),nl,
    write('           I  N  V  E  N  T  O  R  Y           '),nl,
    write('==============================================='),nl,nl,
    inventory_bag(Inventory,X),
    format('~w/100',[X]),nl,nl,
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
    NewSize is Size+Amount,
    inventoryMaxSize(X),
    NewSize =< X,!,
    handleAddToInventory([Name|Amount]).

addToInventory([Name|Amount]) :-
    !,
    write('Your inventory is full! sell some item(s) to the shop first!').

handleAddToInventory([Name|Amount]) :-
    inventory_bag(Inventory,Size),
    member([Name|_],Inventory),!,
    modifyElement([Name|Amount], Inventory, NewInventory),
    NewSize is Size + Amount,
    retract(inventory_bag(Inventory,Size)),!,
    assertz(inventory_bag(NewInventory,NewSize)).

handleAddToInventory([Name|Amount]) :-
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

    player_attack_mult(CurrentAttackMult),
    equipped_weapon(CurrentWeapon),property(CurrentWeapon,CurrentWeaponAttackMult),
    retract(equipped_weapon(CurrentWeapon)),assertz(equipped_weapon(Item)),
    property(Weapon, MultAttack),player_attack_mult(CurrentAttackMult), NewMultAtt is CurrentAttackMult + MultAttack,
    retract(player_attack_mult(_)),assertz(player_attack_mult(NewMultAtt)),
    substractFromInventory([Item|1]),addToInventory([CurrentWeapon|1]),
    write('Equipped '),write(Item),!.

equip(Item) :- 
    type(ItemType,Item),player_class(Class),
    weapon(ItemType),\+equipmentAllowed(Class,Item),!,
    write('This weapon is not suitable for your class.').

equip(Item) :-
    type(ItemType,Item),
    cover(ItemType),!,
    equipped_cover(CurrentCover),
    player_defense_mult(CurrentDefenseMult),player_max_health(CurrentMaxHealth),player_health(CurrentHealth),
    property(CurrentCover,OldArmorDefenseMult,OldArmorHealthMult),property(Item,NewArmorDefenseMult,NewArmorHealthMult),

    NewCurrentHealth is truncate(CurrentHealth * NewArmorHealthMult/OldArmorHealthMult),
    NewMaxHealth is truncate(CurrentMaxHealth *  NewArmorHealthMult/OldArmorHealthMult),
    NewDefenseMult is CurrentDefenseMult + NewArmorDefenseMult - OldArmorDefenseMult,
    retract(player_defense_mult(_)),
    assertz(player_defense_mult(NewDefenseMult)),
    
    retract(player_max_health(_)),assertz(player_max_health(NewMaxHealth)),
    retract(player_health(_)),assertz(player_health(NewCurrentHealth)),

    retract(equipped_cover(_)),assertz(equipped_cover(Item)),
    substractFromInventory([Item|1]),addToInventory([CurrentCover|1]),
    write('Equipped '),write(Item),!.

equipped_items:-
    equipped_weapon(X),
    write('Weapon:'),write(X),nl,
    property(X,Attack),write('Attack Bonus: '),write(Attack),nl,
    equipped_cover(Y),property(Y,Defense,HP),
    write('Armor:'),write(Y),nl,
    write('Bonus Defense: '),write(Defense),nl,
    write('Bonus Health: '),write(HP).