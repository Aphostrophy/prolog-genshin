/* File Penyimpan Segala Hal yang diperlukan untuk kalkulasi */

power(X,0,1).

/* Deklarasi Rules */ 
power(A,B,X) :-
  B>0,
  B1 is B-1,
  power(A,B1,X1),
  X is A * X1.

power(A,B,X) :-
  B<0,
  B1 is B+1,
  power(A,B1,X1),
  X is X1/A.

calc_damage(Att, Def, Res) :-
    AttMin is Att - 5,
    AttMax is Att + 5,
    random(AttMin, AttMax, Random),
    AttRandom is Random,
    Res is truncate(AttRandom - 0.2*Def).

decrease_health(X, Damage) :-
  X =< 0,
  Damage is 1.

decrease_health(X, Hp) :-
  X > 0,
  Damage is X.
  
calc_status_upgrade(Status,Result) :-
  Result is truncate(Status * 1.4).


handle_sell(Name,Amount) :-
  Amount =<0,
  write('enter the correct amount of item(s) (greater than zero)!'),!.

handle_sell(Name,Amount):-
  findItemAmount(Name,X),
  Amount > X,
  write('Dont lie! you dont have that much of this item!'),!.

handle_sell(Name,Amount) :-
  price(Name,X),
  type(consumable,Name),
  NewPrice is X // 2,
  ObtainedGold is NewPrice * Amount,
  add_player_gold(ObtainedGold),
  substractFromInventory([Name|Amount]),
  write('The item has been successfully sold!'),nl.

handle_sell(Name,Amount) :-
  \+(type(consumable,Name)),
  ultraRareItem(Name),
  NewPrice is 10000,
  ObtainedGold is NewPrice * Amount,
  add_player_gold(ObtainedGold),
  substractFromInventory([Name|Amount]),
  write('The item has been successfully sold!'),nl.

handle_sell(Name,Amount) :-
  \+(type(consumable,Name)),
  rareItem(Name),
  NewPrice is 5000,
  ObtainedGold is NewPrice * Amount,
  add_player_gold(ObtainedGold),
  substractFromInventory([Name|Amount]),
  write('The item has been successfully sold!'),nl.

handle_sell(Name,Amount) :-
  !,
  NewPrice is 500,
  ObtainedGold is NewPrice * Amount,
  add_player_gold(ObtainedGold),
  substractFromInventory([Name|Amount]),
  write('The item has been successfully sold!'),nl.

push(X, [], [X]).

push(X, [Head|Tail], [Head|L]) :- push(X,Tail,L).

modifyElement([Name|Amount], [[Name,OldAmount]|Tail],[[Name,X]|Tail]):- X is OldAmount+Amount.

modifyElement([Name|Amount], [[Other,OldAmount]|Tail],[[Other,OldAmount]|L]) :- modifyElement([Name|Amount],Tail,L).

reduceElement([Name|Amount], [[Name,OldAmount]|Tail],[[Name,X]|Tail]):- X is OldAmount-Amount.

reduceElement([Name|Amount], [[Other,OldAmount]|Tail],[[Other,OldAmount]|L]):- reduceElement([Name|Amount],Tail,L).

getItemAmount(Name, [[Name,Amount]|Tail],Amount).

getItemAmount(Name,[[Other,OtherAmount]|Tail],Amount) :- getItemAmount(Name,Tail,X), Amount is X.