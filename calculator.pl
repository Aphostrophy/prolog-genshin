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