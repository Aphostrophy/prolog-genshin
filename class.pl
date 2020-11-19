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

baseAttack(knight, 35).
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

baseAttackScaling(knight, level, Attack) :-
    baseAttack(knight, BaseAttack),
    Attack is BaseAttack+30*level.

baseAttackScaling(archer,level, Attack) :-
    baseAttack(archer, BaseAttack),
    Attack is BaseAttack+30*level.

baseAttackScaling(archer,level,Attack):-
    baseAttack(archer,BaseAttack),
    Attack is BaseAttack+35*level.
    
baseHealthScaling(knight, level, Health) :-
    baseHealth(knight, BaseHealth),
    Health is BaseHealth+300*level.

baseHealthScaling(archer,level, Health) :-
    baseHealth(archer, BaseHealth),
    Health is BaseHealth+200*level.

baseHealthScaling(archer,level,Health):-
    baseHealth(archer,BaseHealth),
    Health is BaseHealth+150*level.

baseDefenseScaling(knight, level, Defense) :-
    baseDefense(knight, BaseDefense),
    Defense is BaseDefense+300*level.

baseDefenseScaling(archer,level, Defense) :-
    baseDefense(archer, BaseDefense),
    Defense is BaseDefense+200*level.

baseDefenseScaling(archer,level,Defense):-
    baseDefense(archer,BaseDefense),
    Defense is BaseDefense+150*level.