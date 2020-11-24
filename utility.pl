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
  
calc_status_upgrade(Status,Result) :-
  Result is truncate(Status * 1.4).

push(X, [], [X]).

push(X, [Head|Tail], [Head|L]) :- push(X,Tail,L).

modifyElement([Name|Amount], [[Name,OldAmount]|Tail],[[Name,X]|Tail]):- X is OldAmount+Amount.

modifyElement([Name|Amount], [[Other,OldAmount]|Tail],[[Other,OldAmount]|L]) :- modifyElement([Name|Amount],Tail,L).

reduceElement([Name|Amount], [[Name,OldAmount]|Tail],[[Name,X]|Tail]):- X is OldAmount-Amount.

getItemAmount(Name, [[Name,Amount]|Tail],Amount).

getItemAmount(Name,[[Other,OtherAmount]|Tail],Amount) :- getItemAmount(Name,Tail,X), Amount is X.