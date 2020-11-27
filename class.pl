/* FILE class.pl */
/* Storing classes */

/* Dependency Files : items.pl */

class(knight).
class(archer).
class(mage).

baseHealth(knight, 500).
baseHealth(archer, 400).
baseHealth(mage, 300).

baseDefense(knight, 30).
baseDefense(archer, 20).
baseDefense(mage,15).

baseAttack(knight, 30).
baseAttack(archer,40).
baseAttack(mage,40).

baseHealthPotion(X, 10) :- class(X).

baseWeapon(knight, 'waster greatsword').
baseWeapon(archer,'hunter bow').
baseWeapon(mage,'apprentice notes').

equipmentAllowed(knight,Y) :-
    type(claymore,Y).

equipmentAllowed(archer,Y) :-
    type(bow,Y).

equipmentAllowed(mage,Y) :-
    type(catalyst,Y).