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