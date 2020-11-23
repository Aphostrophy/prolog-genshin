/* FILE player.pl */
/* Storing player datas */

/* Dependency Files : items.pl */

:- dynamic(player_class/1).
:- dynamic(player_level/1).
:- dynamic(equipped_weapon/1).
:- dynamic(player_health/1).
:- dynamic(player_attack/1).
:- dynamic(player_defense/1).

:- dynamic(player_max_health/1).
:- dynamic(player_max_attack/1).
:- dynamic(player_max_defense/1).

:- dynamic(current_gold/1).
:- dynamic(current_exp/1).

choose_class :-
    write('Welcome to Genshin Asik. Choose your job'), nl,
    write('1. Knight'), nl,
    write('2. Archer'), nl,
    write('3. Mage'), nl,
    read(X),nl,
    assert_class(X),
    initialize_resources.

status :-
    player_class(X),player_level(Y),player_health(Health),player_attack(Attack),player_defense(Defense),
    player_max_health(MaxHealth),player_max_attack(MaxAttack),player_max_defense(MaxDefense),
    current_gold(Gold),
    write('Job: '),write(X),nl,
    write('Level: '),write(Y),nl,
    write('Health: '),write(Health),write('/'),write(MaxHealth),nl,
    write('Attack: '),write(Attack),write('/'),write(MaxAttack),nl,
    write('Defense: '),write(Defense),write('/'),write(MaxDefense),nl,
    write('Gold: '),write(Gold),nl.

exp_level_up(Level,Exp):-
    power(1.4,(Level-1),ScalingFactor),
    write(ScalingFactor),
    Exp is truncate(300*ScalingFactor).

assert_class(1):-
    assertz(player_class('knight')),baseHealth(X,BaseHealth),
    player_class(X),assertz(player_level(1)),baseHealth(X,BaseHealth),baseAttack(X,BaseAttack),baseDefense(X,BaseDefense),
    assertz(player_health(BaseHealth)),assertz(player_attack(BaseAttack)),assertz(player_defense(BaseDefense)),
    assertz(player_max_health(BaseHealth)),assertz(player_max_attack(BaseAttack)),assertz(player_max_defense(BaseDefense)),
    baseWeapon(X,BaseWeapon),assertz(equipped_weapon(BaseWeapon)),
    write('You choose '), write(X), write(', let’s explore the world'),nl,!.

assert_class(2):-
    assertz(player_class('archer')),
    player_class(X),assertz(player_level(1)),baseHealth(X,BaseHealth),baseAttack(X,BaseAttack),baseDefense(X,BaseDefense),
    assertz(player_health(BaseHealth)),assertz(player_attack(BaseAttack)),assertz(player_defense(BaseDefense)),
    assertz(player_max_health(BaseHealth)),assertz(player_max_attack(BaseAttack)),assertz(player_max_defense(BaseDefense)),
    baseWeapon(X,BaseWeapon),assertz(equipped_weapon(BaseWeapon)),
    write('You choose '), write(X), write(', let’s explore the world'),nl,!.

assert_class(3):-
    assertz(player_class('mage')),
    player_class(X),assertz(player_level(1)),baseHealth(X,BaseHealth),baseAttack(X,BaseAttack),baseDefense(X,BaseDefense),
    assertz(player_health(BaseHealth)),assertz(player_attack(BaseAttack)),assertz(player_defense(BaseDefense)),
    assertz(player_max_health(BaseHealth)),assertz(player_max_attack(BaseAttack)),assertz(player_max_defense(BaseDefense)),
    baseWeapon(X,BaseWeapon),assertz(equipped_weapon(BaseWeapon)),
    write('You choose '), write(X), write(', let’s explore the world'),nl,!.

initialize_resources:-
    assertz(current_gold(1000)),
    assertz(current_exp(0)),
    assertz(inventory_bag([['health potion',10]],10)).