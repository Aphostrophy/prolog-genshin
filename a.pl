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
:- dynamic(upgradable/0).
:- dynamic(inventory_bag/2).
:- dynamic(quest_active/1).
:- dynamic(slime_counter/1).
:- dynamic(hilichurl_counter/1).
:- dynamic(mage_counter/1).
:- dynamic(game_opened/0).
:- dynamic(game_start/0).
:- dynamic(game_state/1).
:- dynamic(type_enemy/1).
:- dynamic(hp_enemy/1).
:- dynamic(att_enemy/1).
:- dynamic(def_enemy/1).
:- dynamic(lvl_enemy/1).
:- dynamic(map_entity/3).
:- dynamic(isPagar/2).
:- dynamic(draw_done/1).
:- dynamic(fight_or_run/0).
:- dynamic(can_run/0).
:- dynamic(special_timer/1).
:- dynamic(shopactive/0).

% file: C:/Users/Aphos/Documents/prolog-genshin/battle.pl

trigger_battle :-
	assertz(fight_or_run),
	retract(game_state(travelling)),
	assertz(game_state(in_battle)),
	assertz(can_run),
	write('Fight or Run?').

trigger_boss :-
	retract(game_state(travelling)),
	assertz(game_state(boss_battle)),
	retract(type_enemy(_)),
	assertz(type_enemy(4)),
	retract(lvl_enemy(_)),
	assertz(lvl_enemy(70)),
	lvl_enemy(A),
	enemy_health(4, B),
	C is B + 10 * A,
	retract(hp_enemy(_)),
	assertz(hp_enemy(C)),
	enemy_attack(4, D),
	E is D + 5 * A,
	retract(att_enemy(_)),
	assertz(att_enemy(E)),
	enemy_defense(4, F),
	G is F + 2 * A,
	retract(def_enemy(_)),
	assertz(def_enemy(G)),
	write('You feel the ground tremble, the wind rages around you. You see a humongous being, it was an overweight Paimon.'),
	nl,
	write('Seems like she wants to eat you to satisfy her unsatisfiable appetite.'),
	nl,
	write('You can''t'' run. You have to defeat her!!').

fight :-
	game_state(boss_battle), !,
	write('You choose to face Paimon head on!!').
fight :-
	game_state(in_battle),
	fight_or_run, !,
	write('You choose to face the monster head on!!'),
	retract(fight_or_run).
fight :-
	\+ game_state(in_battle), !,
	write('You aren''t in a battle, please walk a bit to find monsters!!').
fight :-
	\+ fight_or_run, !,
	write('You choose to fight, get ready!!').

run :-
	game_state(boss_battle), !,
	write('There''s'' a wind barrier blocking your escape route. You cant''t'' run!').
run :-
	game_state(in_battle),
	can_run,
	fight_or_run,
	random(0, 11, A),
	retract(can_run),
	run_gacha(A), !.
run :-
	\+ game_state(in_battle), !,
	write('You aren''t in a battle. Why are you running??!!').
run :-
	\+ can_run, !,
	write('Seems like you can''t run, go fight it like a man!!').
run :-
	\+ fight_or_run, !,
	write('Who are you running from??').

run_gacha(A) :-
	A >= 8, !,
	retract(game_state(in_battle)),
	assertz(game_state(travelling)),
	retract(fight_or_run),
	write('You choose to run. You successfully escaped from the monster!!').
run_gacha(A) :-
	A < 8, !,
	write('Oh no you failed to run!! I guess there is no other way than to fight it like a man :).'),
	retract(fight_or_run).

attack :-
	game_state(boss_battle),
	\+ fight_or_run, !,
	hp_enemy(A),
	retract(hp_enemy(A)),
	att_enemy(_),
	def_enemy(B),
	player_attack(C),
	calc_damage(C, B, D),
	E is A - D,
	assertz(hp_enemy(E)),
	write('You deal '),
	write(D),
	write(' damage!'),
	nl,
	nl,
	check_death_boss.
attack :-
	game_state(in_battle),
	\+ fight_or_run, !,
	hp_enemy(A),
	retract(hp_enemy(A)),
	att_enemy(_),
	def_enemy(B),
	player_attack(C),
	calc_damage(C, B, D),
	E is A - D,
	assertz(hp_enemy(E)),
	write('You deal '),
	write(D),
	write(' damage!'),
	nl,
	nl,
	check_death.
attack :-
	fight_or_run, !,
	write('Type ''fight.'' to fight, type ''run.'' to run.').
attack :-
	\+ game_state(in_battle), !,
	write('You are currently not in a battle').

special_attack :-
	game_state(boss_battle), !,
	special_timer(A),
	A >= 3, !,
	write('You used your special attack!!'),
	nl,
	hp_enemy(B),
	retract(hp_enemy(B)),
	att_enemy(_),
	def_enemy(C),
	player_attack(D),
	E is 2 * D,
	calc_damage(E, C, F),
	G is B - F,
	assertz(hp_enemy(G)),
	write('You deal '),
	write(F),
	write(' damage!'),
	nl,
	nl,
	retract(special_timer(_)),
	assertz(special_timer(0)),
	check_death_boss.
special_attack :-
	game_state(boss_battle), !,
	special_timer(A),
	A < 3, !,
	write('You can''\t use special attack yet!').
special_attack :-
	game_state(in_battle),
	\+ fight_or_run, !,
	special_timer(A),
	A >= 3, !,
	write('You used your special attack!!'),
	nl,
	hp_enemy(B),
	retract(hp_enemy(B)),
	att_enemy(_),
	def_enemy(C),
	player_attack(D),
	E is 2 * D,
	calc_damage(E, C, F),
	G is B - F,
	assertz(hp_enemy(G)),
	write('You deal '),
	write(F),
	write(' damage!'),
	nl,
	nl,
	retract(special_timer(_)),
	assertz(special_timer(0)),
	check_death.
special_attack :-
	game_state(in_battle),
	\+ fight_or_run, !,
	special_timer(A),
	A < 3, !,
	write('You can''\t use special attack yet!').
special_attack :-
	fight_or_run, !,
	write('Type ''fight.'' to fight, type ''run.'' to run.').
special_attack :-
	\+ game_state(in_battle), !,
	write('You are currently not in a battle').

item :-
	game_state(travelling), !,
	inventory,
	write('Input item name!!'),
	nl,
	read(A),
	substractFromInventory([A|1]),
	property(A, B),
	heal(B),
	write('You used '),
	write(A),
	nl.
item :-
	game_state(boss_battle), !,
	inventory,
	write('Input item name!!'),
	nl,
	read(A),
	substractFromInventory([A|1]),
	property(A, B),
	heal(B),
	write('You used '),
	write(A),
	nl,
	enemy_turn.
item :-
	game_state(in_battle), !,
	inventory,
	write('Input item name!!'),
	nl,
	read(A),
	substractFromInventory([A|1]),
	property(A, B),
	heal(B),
	write('You used '),
	write(A),
	nl,
	special_timer(C),
	D is C + 1,
	retract(special_timer(_)),
	assertz(special_timer(D)),
	enemy_turn.

heal(A) :-
	player_health(B),
	player_max_health(C),
	D is B + A,
	D < C, !,
	retract(player_health(_)),
	assertz(player_health(D)).
heal(A) :-
	player_health(B),
	player_max_health(C),
	D is B + A,
	D >= C, !,
	retract(player_health(_)),
	assertz(player_health(C)).

check_death :-
	hp_enemy(A),
	A =< 0,
	type_enemy(B),
	enemy_type(B, C),
	write(C),
	write(' defeated! you got : '),
	nl, !,
	enemy_exp(B, D),
	enemy_gold(B, E), !,
	F is D + truncate(1.5 * D),
	G is E + 10 * E,
	write(F),
	write(' exp'),
	nl,
	write(G),
	write(' gold'),
	nl,
	add_player_exp(F),
	add_player_gold(G),
	update_quest(B),
	retract(game_state(in_battle)),
	assertz(game_state(travelling)).
check_death :-
	show_battle_status,
	nl,
	nl,
	special_timer(A),
	B is A + 1,
	retract(special_timer(_)),
	assertz(special_timer(B)),
	enemy_turn.

check_death_boss :-
	hp_enemy(A),
	A =< 0,
	type_enemy(B),
	enemy_type(B, C),
	write(C),
	write(' defeated!!'),
	nl, !,
	write('As Paimon falls down, the whole dungeon also collapses upon you.'),
	nl,
	write('When you open your eyes, you find yourself in a bed of a hospital.'),
	nl,
	write('It was just a moment when you thought it was just a dream, until you decided to take a look outside the window.'),
	nl,
	write('You find that the world has changed, you now lives inside a fantasy world where humans and other beings live together.'),
	nl,
	write('Will your story continues??'),
	nl,
	nl,
	write('CONGRATS!!! You completed the game, use ''start.'' if you want to play again!!'),
	retract(game_state(boss_battle)),
	retract(game_start).
check_death_boss :-
	show_battle_status,
	nl,
	nl,
	special_timer(A),
	B is A + 1,
	retract(special_timer(_)),
	assertz(special_timer(B)),
	enemy_turn.

enemy_turn :-
	!,
	att_enemy(A),
	player_defense(B),
	player_health(C),
	retract(player_health(C)),
	calc_damage(A, B, D),
	E is C - D,
	assertz(player_health(E)), !,
	type_enemy(F),
	enemy_type(F, G),
	write(G),
	write(' deals '),
	write(D),
	write(' damage!!'),
	nl,
	nl,
	check_player_death.

check_player_death :-
	player_health(A),
	A =< 0, !,
	write('You died... Game Over... Type ''start.'' to retry!'),
	retract(game_start).
check_player_death :-
	show_battle_status, !.

show_battle_status :-
	type_enemy(A),
	enemy_type(A, B),
	hp_enemy(C),
	write('Enemy :'),
	write(B),
	nl,
	write('Health : '),
	write(C),
	nl,
	nl,
	write('Your status :'),
	nl,
	player_health(D),
	player_max_health(E),
	write('Health : '),
	write(D),
	write(' / '),
	write(E),
	nl,
	special_timer(F),
	special_status(F).

special_status(A) :-
	A < 3, !,
	write('Special attack : not ready').
special_status(A) :-
	A >= 3, !,
	write('Special attack : READY!!!!!').

% file: C:/Users/Aphos/Documents/prolog-genshin/class.pl

class(knight).
class(archer).
class(mage).

baseHealth(knight, 500).
baseHealth(archer, 400).
baseHealth(mage, 300).

baseDefense(knight, 30).
baseDefense(archer, 20).
baseDefense(mage, 15).

baseAttack(knight, 10000000000).
baseAttack(archer, 40).
baseAttack(mage, 40).

baseHealthPotion(A, 10) :-
	class(A).

baseWeapon(knight, 'waster greatsword').
baseWeapon(archer, 'hunter bow').
baseWeapon(mage, 'apprentice notes').

equipmentAllowed(knight, A) :-
	type(claymore, A).
equipmentAllowed(archer, A) :-
	type(bow, A).
equipmentAllowed(mage, A) :-
	type(catalyst, A).

baseAttackScaling(knight, level, A) :-
	baseAttack(knight, B),
	A is B + 30 * level.
baseAttackScaling(archer, level, A) :-
	baseAttack(archer, B),
	A is B + 30 * level.
baseAttackScaling(archer, level, A) :-
	baseAttack(archer, B),
	A is B + 35 * level.

baseHealthScaling(knight, level, A) :-
	baseHealth(knight, B),
	A is B + 300 * level.
baseHealthScaling(archer, level, A) :-
	baseHealth(archer, B),
	A is B + 200 * level.
baseHealthScaling(archer, level, A) :-
	baseHealth(archer, B),
	A is B + 150 * level.

baseDefenseScaling(knight, level, A) :-
	baseDefense(knight, B),
	A is B + 300 * level.
baseDefenseScaling(archer, level, A) :-
	baseDefense(archer, B),
	A is B + 200 * level.
baseDefenseScaling(archer, level, A) :-
	baseDefense(archer, B),
	A is B + 150 * level.

% file: C:/Users/Aphos/Documents/prolog-genshin/encounter_enemy.pl

chestLoot(100).

encounter_enemy(A, B) :-
	random(1, 151, C),
	C =< 75,
	random(0, A, D),
	map_entity(E, F, 'P'),
	enemy_gacha(E, F, D),
	type_enemy(G),
	B is G.

enemy_gacha(A, B, C) :-
	A =< 8,
	A > 0,
	B =< 8,
	B > 0,
	C =< 70,
	C > 0, !,
	retract(type_enemy(_)),
	asserta(type_enemy(0)).
enemy_gacha(A, B, C) :-
	A =< 8,
	A > 0,
	B =< 8,
	B > 0,
	C =< 80,
	C > 70, !,
	retract(type_enemy(_)),
	asserta(type_enemy(1)).
enemy_gacha(A, B, C) :-
	A =< 8,
	A > 0,
	B =< 8,
	B > 0,
	C =< 90,
	C > 80, !,
	retract(type_enemy(_)),
	asserta(type_enemy(2)).
enemy_gacha(A, B, C) :-
	A =< 8,
	A > 0,
	B =< 8,
	B > 0,
	C =< 100,
	C > 90, !,
	retract(type_enemy(_)),
	asserta(type_enemy(3)).
enemy_gacha(A, B, C) :-
	A =< 15,
	A > 8,
	B =< 8,
	B > 0,
	C =< 10,
	C > 0, !,
	retract(type_enemy(_)),
	asserta(type_enemy(0)).
enemy_gacha(A, B, C) :-
	A =< 15,
	A > 8,
	B =< 8,
	B > 0,
	C =< 80,
	C > 10, !,
	retract(type_enemy(_)),
	asserta(type_enemy(1)).
enemy_gacha(A, B, C) :-
	A =< 15,
	A > 8,
	B =< 8,
	B > 0,
	C =< 90,
	C > 80, !,
	retract(type_enemy(_)),
	asserta(type_enemy(2)).
enemy_gacha(A, B, C) :-
	A =< 15,
	A > 8,
	B =< 8,
	B > 0,
	C =< 100,
	C > 90, !,
	retract(type_enemy(_)),
	asserta(type_enemy(3)).
enemy_gacha(A, B, C) :-
	A =< 15,
	A > 0,
	B =< 15,
	B > 8,
	C =< 10,
	C > 0, !,
	retract(type_enemy(_)),
	asserta(type_enemy(0)).
enemy_gacha(A, B, C) :-
	A =< 15,
	A > 0,
	B =< 15,
	B > 8,
	C =< 40,
	C > 10, !,
	retract(type_enemy(_)),
	asserta(type_enemy(1)).
enemy_gacha(A, B, C) :-
	A =< 15,
	A > 0,
	B =< 15,
	B > 8,
	C =< 90,
	C > 40, !,
	retract(type_enemy(_)),
	asserta(type_enemy(2)).
enemy_gacha(A, B, C) :-
	A =< 15,
	A > 0,
	B =< 15,
	B > 8,
	C =< 100,
	C > 90, !,
	retract(type_enemy(_)),
	asserta(type_enemy(3)).

chest_encounter :-
	encounter_enemy(100, A), !,
	encounter(A).
chest_encounter :-
	!.

encounter(A) :-
	A < 3,
	write('You encounter a '),
	enemy_type(A, B), !,
	write(B),
	write('!\n'),
	player_level(C),
	D is C + 1,
	random(1, D, E),
	retract(lvl_enemy(_)),
	assertz(lvl_enemy(E)),
	enemy_health(A, F),
	G is F + 10 * E,
	retract(hp_enemy(_)),
	assertz(hp_enemy(G)),
	enemy_attack(A, H),
	I is H + 5 * E,
	retract(att_enemy(_)),
	assertz(att_enemy(I)),
	enemy_defense(A, J),
	K is J + 2 * E,
	retract(def_enemy(_)),
	assertz(def_enemy(K)),
	print_info,
	trigger_battle.
encounter(A) :-
	A =:= 3,
	random(1, 101, B),
	gacha_chest(B).

gacha_chest(A) :-
	A =< 70,
	player_level(B),
	chestLoot(C),
	D is C + 100 * B,
	random(C, D, E),
	write('You found a chest!! You get : '),
	write(E),
	write(' gold'), !.
gacha_chest(A) :-
	A > 70,
	write('You encounter a '),
	enemy_type(3, B),
	write(B),
	write('!\n'),
	player_level(C),
	D is C + 1,
	random(1, D, E),
	retract(lvl_enemy(_)),
	assertz(lvl_enemy(E)),
	enemy_health(3, F),
	G is F + 10 * E,
	retract(hp_enemy(_)),
	assertz(hp_enemy(G)),
	enemy_attack(3, H),
	I is H + 5 * E,
	retract(att_enemy(_)),
	assertz(att_enemy(I)),
	enemy_defense(3, J),
	K is J + 2 * E,
	retract(def_enemy(_)),
	assertz(def_enemy(K)),
	print_info,
	trigger_battle.

print_info :-
	lvl_enemy(A),
	hp_enemy(B),
	att_enemy(C),
	def_enemy(D), !,
	write('Level: '),
	write(A),
	nl,
	write('Health: '),
	write(B),
	nl,
	write('Attack: '),
	write(C),
	nl,
	write('Defense: '),
	write(D),
	nl.

% file: C:/Users/Aphos/Documents/prolog-genshin/enemy.pl

enemy_type(0, slime).
enemy_type(1, hilichurl).
enemy_type(2, mage).
enemy_type(3, mimic).
enemy_type(4, paimon).

enemy_health(0, 50).
enemy_health(1, 100).
enemy_health(2, 200).
enemy_health(3, 200).
enemy_health(4, 10000).

enemy_attack(0, 15).
enemy_attack(1, 25).
enemy_attack(2, 40).
enemy_attack(3, 40).
enemy_attack(4, 1000).

enemy_defense(0, 20).
enemy_defense(1, 10).
enemy_defense(2, 30).
enemy_defense(3, 30).
enemy_defense(4, 1000).

enemy_special(0, 30).
enemy_special(1, 50).
enemy_special(2, 75).
enemy_special(3, 75).
enemy_special(3, 2000).

enemy_exp(0, 100).
enemy_exp(1, 200).
enemy_exp(2, 500).
enemy_exp(3, 500).

enemy_gold(0, 50).
enemy_gold(1, 75).
enemy_gold(2, 100).
enemy_gold(3, 100).

% file: C:/Users/Aphos/Documents/prolog-genshin/inventory.pl

inventoryMaxSize(100).

inventory :-
	inventory_bag(A, _),
	printInventory(A).

printInventory([]).
printInventory([A|B]) :-
	printPair(A),
	printInventory(B).

printPair([A|B]) :-
	[C|_] = B,
	C > 0,
	write(A),
	write(:),
	write(C),
	nl.

addToInventory([A|B]) :-
	inventory_bag(C, D),
	member([A|_], C), !,
	modifyElement([A|B], C, E),
	F is D + B,
	retract(inventory_bag(C, D)), !,
	assertz(inventory_bag(E, F)).
addToInventory([A|B]) :-
	inventory_bag(C, D),
	\+ member([A|_], C),
	push([A, B], C, E),
	F is D + B,
	retract(inventory_bag(C, D)), !,
	assertz(inventory_bag(E, F)).

substractFromInventory([A|B]) :-
	inventory_bag(C, D),
	member([A|_], C), !,
	reduceElement([A|B], C, E),
	F is D - B,
	retract(inventory_bag(C, D)), !,
	assertz(inventory_bag(E, F)).
substractFromInventory([_|_]) :-
	write('Hey dont cheat!'),
	nl,
	fail.

findItemAmount(A) :-
	inventory_bag(B, _),
	member([A|_], B), !,
	getItemAmount(A, B, C),
	write(C).
findItemAmount(A) :-
	inventory_bag(B, _),
	\+ member([A|_], B), !,
	write(0).

% file: C:/Users/Aphos/Documents/prolog-genshin/items.pl

item('health potion').
item('panas spesial 2 mekdi').
item(sadikin).
item('go milk').
item(crisbar).
item('waster greatsword').
item('debate club').
item('prototype aminus').
item('wolf greatsword').
item('hunter bow').
item('seasoned hunter bow').
item(messenger).
item('favonius warbow').
item('skyward harp').
item('apprentice notes').
item('pocket grimoire').
item('emerald orb').
item('mappa mare').
item('skyward atlas').
item('wooden armor').
item('iron armor').
item('steel armor').
item('golden armor').
item('diamond armor').

type(consumable, 'health potion').
type(consumable, 'panas spesial 2 mekdi').
type(consumable, sadikin).
type(consumable, 'go milk').
type(consumable, crisbar).
type(claymore, 'waster greatsword').
type(claymore, 'old merc pal').
type(claymore, 'debate club').
type(claymore, 'prototype aminus').
type(claymore, 'wolf greatsword').
type(bow, 'hunter bow').
type(bow, 'seasoned hunter bow').
type(bow, messenger).
type(bow, 'favonius warbow').
type(bow, 'skyward harp').
type(catalyst, 'apprentice notes').
type(catalyst, 'pocket grimoire').
type(catalyst, 'emerald orb').
type(catalyst, 'mappa mare').
type(catalyst, 'skyward atlas').
type(armor, 'wooden armor').
type(armor, 'iron armor').
type(armor, 'steel armor').
type(armor, 'golden armor').
type(armor, 'diamond armor').

price('health potion', 100).
price('panas spesial 2 mekdi', 150).
price(sadikin, 200).
price('go milk', 250).
price(crisbar, 300).
price(gacha, 1000).

ultraRareItem('wolf greatsword').
ultraRareItem('skyward harp').
ultraRareItem('skyward atlas').
ultraRareItem('diamond armor').

rareItem('prototype aminus').
rareItem('favonius warbow').
rareItem('mappa mare').
rareItem('golden armor').

property('health potion', A) :-
	A is 75.
property('panas spesial 2 mekdi', A) :-
	A is 150.
property(sadikin, A) :-
	A is 250.
property('go milk', A) :-
	A is 320.
property(crisbar, A) :-
	A is 450.
property('waster greatsword', A) :-
	A is 30.
property('old merc pal', A) :-
	A is 70.
property('debate club', A) :-
	A is 120.
property('prototype aminus', A) :-
	A is 180.
property('wolf greatsword', A) :-
	A is 250.
property('hunter bow', A) :-
	A is 40.
property('seasoned hunter bow', A) :-
	A is 90.
property(messenger, A) :-
	A is 150.
property('favonius warbow', A) :-
	A is 230.
property('skyward harp', A) :-
	A is 300.
property('apprentice notes', A) :-
	A is 50.
property('pocket grimoire', A) :-
	A is 110.
property('emerald orb', A) :-
	A is 175.
property('mappa mare', A) :-
	A is 320.
property('skyward atlas', A) :-
	A is 410.

property('wooden armor', A, B) :-
	A is 50,
	B is 20.
property('iron armor', A, B) :-
	A is 120,
	B is 60.
property('steel armor', A, B) :-
	A is 200,
	B is 100.
property('golden armor', A, B) :-
	A is 290,
	B is 150.
property('diamond armor', A, B) :-
	A is 400,
	B is 200.

% file: C:/Users/Aphos/Documents/prolog-genshin/main.pl

player_class(knight).

player_level(2).

equipped_weapon('waster greatsword').

player_health(700).

player_attack(14000000000).

player_defense(42).

player_max_health(700).

player_max_attack(14000000000).

player_max_defense(42).

current_gold(2100).

current_exp(200).


inventory_bag([['health potion', 10]], 10).

quest_active(false).

slime_counter(0).

hilichurl_counter(0).

mage_counter(0).

game_opened.

game_start.

game_state(travelling).

type_enemy(0).

hp_enemy(-9999999938).

att_enemy(20).

def_enemy(22).

lvl_enemy(1).

map_entity(14, 12, 'T').
map_entity(3, 14, 'T').
map_entity(2, 5, 'T').
map_entity(13, 3, 'T').
map_entity(2, 7, 'Q').
map_entity(15, 15, 'B').
map_entity(13, 1, 'S').
map_entity(1, 5, 'P').

draw_done(true).


can_run.
can_run.

special_timer(0).


start :-
	nl,
	['encounter_enemy.pl'],
	['utility.pl'],
	['items.pl'],
	['quest.pl'],
	['enemy.pl'],
	['class.pl'],
	['player.pl'],
	['inventory.pl'],
	['shop.pl'],
	['battle.pl'],
	['map.pl'],
	['save.pl'],
	write('     #                  ######   ##########          #   ######     ######        ######   ##########                       #          ######   '),
	nl,
	write('    #      ##########            #        #         #      #                        #      #        # ##########   ######   #   ###      #      '),
	nl,
	write('   #               #  ##########         #     #   #   ########## ##########    ##########         #          #         #   ####     ########## '),
	nl,
	write('  #               #   #        #        #       # #        #      #        #        #             #          #          #   #            #      '),
	nl,
	write(' #     #       # #           ##        #         #         #             ##         #            #        # #           #   #            #      '),
	nl,
	write('#########       #          ##        ##        ## #        #           ##           #          ##          #     ########## #            #      '),
	nl,
	write('         #       #       ##        ##        ##    #        ####     ##              ####    ##             #                #######      ####  '),
	nl,
	write('Main Menu:'),
	nl,
	write(new),
	nl,
	write(load),
	assertz(game_opened).

new :-
	game_opened, !,
	\+ game_start,
	assertz(game_start),
	assertz(game_state(travelling)), !,
	choose_class,
	assertz(type_enemy(0)),
	assertz(hp_enemy(0)),
	assertz(att_enemy(0)),
	assertz(def_enemy(0)),
	assertz(lvl_enemy(0)),
	assertz(special_timer(0)),
	assertz(slime_counter(0)),
	assertz(hilichurl_counter(0)),
	assertz(mage_counter(0)),
	assertz(quest_active(false)),
	asserta(map_entity(1, 1, 'P')),
	asserta(map_entity(13, 1, 'S')),
	asserta(map_entity(15, 15, 'B')),
	asserta(map_entity(2, 7, 'Q')),
	asserta(map_entity(13, 3, 'T')),
	asserta(map_entity(2, 5, 'T')),
	asserta(map_entity(3, 14, 'T')),
	asserta(map_entity(14, 12, 'T')),
	asserta(draw_done(true)),
	setBorder(0, 0).
new :-
	game_start, !,
	write('The game has already been started. Use ''help.'' to look at available commands!').

quit :-
	game_start,
	write('Progress will not be saved after you quit.'),
	nl,
	write('Are you sure? (y/n): '),
	read(A),
	(   A = y ->
	    halt
	;   A = n ->
	    fail
	).

help :-
	game_state(in_battle), !,
	write('You are currently in a battle. Here are some commands to help you get through the battle.'),
	nl,
	write('Use command ''fight.'' to fight against the encountered enemy.'),
	nl,
	write('Use command ''run.'' to run away from the enemy. This command might as well not work as it is and you have no choice but to fight the enemy.').
help :-
	game_state(in_quest_dialogue), !,
	write('Please finish your quest dialogue first before continuing.').
help :-
	game_state(shopactive), !,
	write('You are currently in the shop. Here are some commands to get the stuff you needed.').
help :-
	game_state(travelling), !,
	write('You are currently travlling in the outside world! Here are some commands to guide you through this fantasy map.'),
	nl,
	write('Use command ''w.'' to move upward'),
	nl,
	write('Use command ''a.'' to move to the left'),
	nl,
	write('Use command ''s.'' to move downward'),
	nl,
	write('Use command ''d.'' to move to the right'),
	nl,
	write('You might encounter an enemy while you''re travelling, so be ready for them!').

check_inventory :-
	write('You have nothing in your inventory! You can buy some in the shop.').

l :-
	['a.dat'].

% file: C:/Users/Aphos/Documents/prolog-genshin/map.pl

isPagar(4, 7).
isPagar(4, 8).
isPagar(5, 8).
isPagar(6, 8).
isPagar(9, 2).
isPagar(8, 2).
isPagar(7, 2).
isPagar(8, 3).
isPagar(8, 4).
isPagar(13, 9).
isPagar(13, 10).
isPagar(13, 11).
isPagar(13, 12).
isPagar(12, 12).
isPagar(11, 12).
isPagar(10, 12).
isPagar(0, 0).
isPagar(1, 0).
isPagar(2, 0).
isPagar(3, 0).
isPagar(4, 0).
isPagar(5, 0).
isPagar(6, 0).
isPagar(7, 0).
isPagar(8, 0).
isPagar(9, 0).
isPagar(10, 0).
isPagar(11, 0).
isPagar(12, 0).
isPagar(13, 0).
isPagar(14, 0).
isPagar(15, 0).
isPagar(16, 0).
isPagar(0, 1).
isPagar(16, 1).
isPagar(0, 2).
isPagar(16, 2).
isPagar(0, 3).
isPagar(16, 3).
isPagar(0, 4).
isPagar(16, 4).
isPagar(0, 5).
isPagar(16, 5).
isPagar(0, 6).
isPagar(16, 6).
isPagar(0, 7).
isPagar(16, 7).
isPagar(0, 8).
isPagar(16, 8).
isPagar(0, 9).
isPagar(16, 9).
isPagar(0, 10).
isPagar(16, 10).
isPagar(0, 11).
isPagar(16, 11).
isPagar(0, 12).
isPagar(16, 12).
isPagar(0, 13).
isPagar(16, 13).
isPagar(0, 14).
isPagar(16, 14).
isPagar(0, 15).
isPagar(16, 15).
isPagar(0, 16).
isPagar(1, 16).
isPagar(2, 16).
isPagar(3, 16).
isPagar(4, 16).
isPagar(5, 16).
isPagar(6, 16).
isPagar(7, 16).
isPagar(8, 16).
isPagar(9, 16).
isPagar(10, 16).
isPagar(11, 16).
isPagar(12, 16).
isPagar(13, 16).
isPagar(14, 16).
isPagar(15, 16).
isPagar(16, 16).
isPagar(16, 16).
isPagar(0, 16).
isPagar(1, 16).
isPagar(2, 16).
isPagar(3, 16).
isPagar(4, 16).
isPagar(5, 16).
isPagar(6, 16).
isPagar(7, 16).
isPagar(8, 16).
isPagar(9, 16).
isPagar(10, 16).
isPagar(11, 16).
isPagar(12, 16).
isPagar(13, 16).
isPagar(14, 16).
isPagar(15, 16).
isPagar(16, 16).
isPagar(16, 16).
isPagar(0, 0).
isPagar(1, 0).
isPagar(2, 0).
isPagar(3, 0).
isPagar(4, 0).
isPagar(5, 0).
isPagar(6, 0).
isPagar(7, 0).
isPagar(8, 0).
isPagar(9, 0).
isPagar(10, 0).
isPagar(11, 0).
isPagar(12, 0).
isPagar(13, 0).
isPagar(14, 0).
isPagar(15, 0).
isPagar(16, 0).
isPagar(0, 1).
isPagar(16, 1).
isPagar(0, 2).
isPagar(16, 2).
isPagar(0, 3).
isPagar(16, 3).
isPagar(0, 4).
isPagar(16, 4).
isPagar(0, 5).
isPagar(16, 5).
isPagar(0, 6).
isPagar(16, 6).
isPagar(0, 7).
isPagar(16, 7).
isPagar(0, 8).
isPagar(16, 8).
isPagar(0, 9).
isPagar(16, 9).
isPagar(0, 10).
isPagar(16, 10).
isPagar(0, 11).
isPagar(16, 11).
isPagar(0, 12).
isPagar(16, 12).
isPagar(0, 13).
isPagar(16, 13).
isPagar(0, 14).
isPagar(16, 14).
isPagar(0, 15).
isPagar(16, 15).
isPagar(0, 16).
isPagar(1, 16).
isPagar(2, 16).
isPagar(3, 16).
isPagar(4, 16).
isPagar(5, 16).
isPagar(6, 16).
isPagar(7, 16).
isPagar(8, 16).
isPagar(9, 16).
isPagar(10, 16).
isPagar(11, 16).
isPagar(12, 16).
isPagar(13, 16).
isPagar(14, 16).
isPagar(15, 16).
isPagar(16, 16).
isPagar(16, 16).
isPagar(0, 16).
isPagar(1, 16).
isPagar(2, 16).
isPagar(3, 16).
isPagar(4, 16).
isPagar(5, 16).
isPagar(6, 16).
isPagar(7, 16).
isPagar(8, 16).
isPagar(9, 16).
isPagar(10, 16).
isPagar(11, 16).
isPagar(12, 16).
isPagar(13, 16).
isPagar(14, 16).
isPagar(15, 16).
isPagar(16, 16).
isPagar(16, 16).

setBorder(A, B) :-
	A =< 15,
	A > 0,
	B =< 15,
	B > 0,
	C is A + 1,
	setBorder(C, B).
setBorder(A, B) :-
	B =:= 0,
	A =< 15,
	assertz(isPagar(A, B)),
	C is A + 1,
	setBorder(C, B).
setBorder(A, B) :-
	A =:= 0,
	B =< 16,
	assertz(isPagar(A, B)),
	C is A + 1,
	setBorder(C, B).
setBorder(A, B) :-
	A =:= 16,
	B =< 16,
	assertz(isPagar(A, B)),
	C is B + 1,
	setBorder(0, C).
setBorder(A, B) :-
	B =:= 16,
	A =< 16,
	assertz(isPagar(A, B)),
	C is A + 1,
	setBorder(C, B).

draw_map(_, A) :-
	A =:= 17,
	retract(draw_done(_)),
	asserta(draw_done(true)).
draw_map(A, B) :-
	draw_done(false),
	A =:= 17,
	nl,
	B =< 16,
	C is B + 1,
	draw_map(0, C).
draw_map(A, B) :-
	draw_done(false),
	A =< 16,
	A >= 0,
	B =< 16,
	B >= 0,
	isPagar(A, B), !,
	write('# '),
	C is A + 1,
	draw_map(C, B).
draw_map(A, B) :-
	draw_done(false),
	A =< 15,
	A > 0,
	B =< 15,
	B > 0,
	map_entity(A, B, _),
	draw_entity(A, B),
	C is A + 1,
	draw_map(C, B).
draw_map(A, B) :-
	draw_done(false),
	A =< 15,
	A > 0,
	B =< 15,
	B > 0,
	\+ isPagar(A, B), !,
	write('- '),
	C is A + 1,
	draw_map(C, B).

draw_entity(A, B) :-
	map_entity(A, B, 'P'),
	map_entity(A, B, _), !,
	write('P ').
draw_entity(A, B) :-
	map_entity(A, B, C), !,
	write(C),
	write(' ').

w :-
	game_start,
	\+ game_state(in_battle),
	map_entity(A, B, 'P'),
	C is B - 1,
	\+ isPagar(A, C), !,
	retract(map_entity(A, B, 'P')),
	assertz(map_entity(A, C, 'P')),
	chest_encounter.
w :-
	\+ game_start, !,
	write('Game is not started, use "start." to play the game.').
w :-
	game_state(in_battle), !,
	write('You are in battle!! Use "help." to display the commands that you can use.').
w :-
	write('Ouch, you hit a wall. Use "map." to open the map!!').

a :-
	game_start,
	\+ game_state(in_battle),
	map_entity(A, B, 'P'),
	C is A - 1,
	\+ isPagar(C, B), !,
	retract(map_entity(A, B, 'P')),
	assertz(map_entity(C, B, 'P')),
	chest_encounter.
a :-
	\+ game_start, !,
	write('Game is not started, use "start." to play the game.').
a :-
	game_state(in_battle), !,
	write('You are in battle!! Use "help." to display the commands that you can use.').
a :-
	write('Ouch, you hit a wall. Use "map." to open the map!!').

s :-
	game_start,
	\+ game_state(in_battle),
	map_entity(A, B, 'P'),
	C is B + 1,
	\+ isPagar(A, C),
	\+ map_entity(A, C, 'B'), !,
	retract(map_entity(A, B, 'P')),
	assertz(map_entity(A, C, 'P')),
	chest_encounter.
s :-
	game_start,
	\+ game_state(in_battle),
	map_entity(A, B, 'P'),
	C is B + 1,
	\+ isPagar(A, C), !,
	map_entity(A, C, 'B'), !,
	trigger_boss.
s :-
	\+ game_start, !,
	write('Game is not started, use "start." to play the game.').
s :-
	game_state(in_battle), !,
	write('You are in battle!! Use "help." to display the commands that you can use.').
s :-
	write('Ouch, you hit a wall. Use "map." to open the map!!').

d :-
	game_start,
	\+ game_state(in_battle),
	map_entity(A, B, 'P'),
	C is A + 1,
	\+ isPagar(C, B),
	\+ map_entity(C, B, 'B'), !,
	retract(map_entity(A, B, 'P')),
	assertz(map_entity(C, B, 'P')),
	chest_encounter.
d :-
	game_start,
	\+ game_state(in_battle),
	map_entity(A, B, 'P'),
	C is A + 1,
	\+ isPagar(C, B), !,
	map_entity(C, B, 'B'), !,
	trigger_boss.
d :-
	\+ game_start, !,
	write('Game is not started, use "start." to play the game.').
d :-
	game_state(in_battle), !,
	write('You are in battle!! Use "help." to display the commands that you can use.').
d :-
	write('Ouch, you hit a wall. Use "map." to open the map!!').

map :-
	retract(draw_done(_)),
	asserta(draw_done(false)),
	draw_map(0, 0), !.

teleport :-
	game_start,
	map_entity(A, B, 'P'),
	map_entity(A, B, 'T'),
	game_state(travelling), !,
	map,
	write('Where do you want to teleport??'),
	nl,
	write('Input the X coordinate : '),
	read(C),
	write('Input the Y coordinate : '),
	read(D),
	execute_teleport(C, D).

execute_teleport(A, B) :-
	map_entity(A, B, 'T'), !,
	map_entity(C, D, 'P'),
	write('You teleported to '),
	write(A),
	write(','),
	write(B),
	nl,
	retract(map_entity(C, D, 'P')),
	assertz(map_entity(A, B, 'P')).
execute_teleport(A, B) :-
	\+ map_entity(A, B, 'T'), !,
	write('Invalid Location!!').

% file: C:/Users/Aphos/Documents/prolog-genshin/player.pl

choose_class :-
	write('Welcome to Genshin Asik. Choose your job'),
	nl,
	write('1. Knight'),
	nl,
	write('2. Archer'),
	nl,
	write('3. Mage'),
	nl,
	read(A),
	nl,
	assert_class(A),
	initialize_resources.

status :-
	player_class(A),
	player_level(B),
	player_health(C),
	player_attack(D),
	player_defense(E),
	player_max_health(F),
	player_max_attack(G),
	player_max_defense(H),
	current_gold(I),
	current_exp(J),
	exp_level_up(B, K),
	write('Job: '),
	write(A),
	nl,
	write('Level: '),
	write(B),
	nl,
	write('Health: '),
	write(C),
	write(/),
	write(F),
	nl,
	write('Attack: '),
	write(D),
	write(/),
	write(G),
	nl,
	write('Defense: '),
	write(E),
	write(/),
	write(H),
	nl,
	write('Gold: '),
	write(I),
	nl,
	write('Exp: '),
	write(J),
	write(/),
	write(K),
	nl.

exp_level_up(A, B) :-
	B is 300 * A.

assert_class(1) :-
	assertz(player_class(knight)),
	baseHealth(A, B),
	player_class(A),
	assertz(player_level(1)),
	baseHealth(A, B),
	baseAttack(A, C),
	baseDefense(A, D),
	assertz(player_health(B)),
	assertz(player_attack(C)),
	assertz(player_defense(D)),
	assertz(player_max_health(B)),
	assertz(player_max_attack(C)),
	assertz(player_max_defense(D)),
	baseWeapon(A, E),
	assertz(equipped_weapon(E)),
	write('You choose '),
	write(A),
	write(', letâ\x80\\x99\s explore the world'),
	nl, !.
assert_class(2) :-
	assertz(player_class(archer)),
	player_class(A),
	assertz(player_level(1)),
	baseHealth(A, B),
	baseAttack(A, C),
	baseDefense(A, D),
	assertz(player_health(B)),
	assertz(player_attack(C)),
	assertz(player_defense(D)),
	assertz(player_max_health(B)),
	assertz(player_max_attack(C)),
	assertz(player_max_defense(D)),
	baseWeapon(A, E),
	assertz(equipped_weapon(E)),
	write('You choose '),
	write(A),
	write(', letâ\x80\\x99\s explore the world'),
	nl, !.
assert_class(3) :-
	assertz(player_class(mage)),
	player_class(A),
	assertz(player_level(1)),
	baseHealth(A, B),
	baseAttack(A, C),
	baseDefense(A, D),
	assertz(player_health(B)),
	assertz(player_attack(C)),
	assertz(player_defense(D)),
	assertz(player_max_health(B)),
	assertz(player_max_attack(C)),
	assertz(player_max_defense(D)),
	baseWeapon(A, E),
	assertz(equipped_weapon(E)),
	write('You choose '),
	write(A),
	write(', letâ\x80\\x99\s explore the world'),
	nl, !.

initialize_resources :-
	assertz(current_gold(1000)),
	assertz(current_exp(0)),
	assertz(inventory_bag([['health potion', 10]], 10)).

add_player_exp(A) :-
	current_exp(B),
	C is B + A,
	retract(current_exp(B)),
	assertz(current_exp(C)),
	player_level(D),
	exp_level_up(D, E),
	upgrade_player_level(D, C, E),
	write('You can now check your updated current Exp and Gold with ''status'' command!'),
	nl.

upgrade_player_level(_, A, B) :-
	A < B, !,
	C is B - A,
	write('You now have '),
	write(A),
	write(' Exp'),
	nl,
	write('You need '),
	write(C),
	write(' Exp to get upgraded to the next level. Keep exploring the game!'),
	nl.
upgrade_player_level(A, B, C) :-
	B >= C,
	D is A + 1,
	E is B - C,
	retract(player_level(A)),
	assertz(player_level(D)),
	retract(current_exp(B)),
	assertz(current_exp(E)),
	exp_level_up(D, F),
	G is F - E,
	upgrade_player_status,
	write('Your character has been upgraded to level '),
	write(D),
	write(!),
	nl,
	write('You now have '),
	write(E),
	write(' Exp'),
	nl,
	write('You need '),
	write(G),
	write(' Exp to get upgraded to the next level. Keep exploring the game!'),
	nl.

upgrade_player_status :-
	player_max_attack(A),
	player_max_defense(B),
	player_max_health(C),
	player_attack(D),
	player_defense(E),
	player_health(F),
	calc_status_upgrade(A, G),
	retract(player_max_attack(A)),
	assertz(player_max_attack(G)),
	retract(player_attack(D)),
	assertz(player_attack(G)),
	calc_status_upgrade(B, H),
	retract(player_max_defense(B)),
	assertz(player_max_defense(H)),
	retract(player_defense(E)),
	assertz(player_defense(H)),
	calc_status_upgrade(C, I),
	retract(player_max_health(C)),
	assertz(player_max_health(I)),
	retract(player_health(F)),
	assertz(player_health(I)).

add_player_gold(A) :-
	current_gold(B),
	C is B + A,
	retract(current_gold(B)),
	assertz(current_gold(C)),
	write('You obtained '),
	write(C),
	write(' Gold! The gold is now kept in your pocket!'),
	nl.

% file: C:/Users/Aphos/Documents/prolog-genshin/quest.pl

questExp(5000).

questGold(5000).

quest :-
	game_start,
	map_entity(A, B, 'P'),
	map_entity(A, B, 'Q'),
	quest_active(false), !,
	retract(game_state(travelling)),
	assertz(game_state(in_quest_dialogue)),
	random(1, 11, C),
	random(1, 6, D),
	random(1, 3, E),
	write('Hi there traveler!!!'),
	nl,
	write('Could you help me out?? I want you to go kill: '),
	nl,
	write(C),
	write(' slime(s)'),
	nl,
	write(D),
	write(' hilichurl(s)'),
	nl,
	write(E),
	write(' mage(s)'),
	nl,
	write('Would you help me?? (yes/no)'),
	nl,
	retract(slime_counter(_)),
	retract(hilichurl_counter(_)),
	retract(mage_counter(_)),
	assertz(slime_counter(C)),
	assertz(hilichurl_counter(D)),
	assertz(mage_counter(E)).
quest :-
	quest_active(true), !,
	write('You already have a quest!! Go finish it first!!').
quest :-
	!,
	write('You are not in quest node, use "map" to find the quest node!!').

quest_info :-
	quest_active(true), !,
	slime_counter(A),
	hilichurl_counter(B),
	mage_counter(C),
	write('Current quest bounty :'),
	nl,
	write(A),
	write(' slime(s)'),
	nl,
	write(B),
	write(' hilichurl(s)'),
	nl,
	write(C),
	write(' mage(s)'),
	nl.
quest_info :-
	quest_active(false), !,
	write('You are not in quest node, use "map" to find the quest node!!').

yes :-
	game_state(in_quest_dialogue),
	quest_active(false), !,
	slime_counter(A),
	hilichurl_counter(B),
	mage_counter(C),
	assertz(quest_active(true)),
	write('You accepted the quest!!'),
	nl,
	write('You agreed to go kill: '),
	nl,
	write(A),
	write(' slime(s)'),
	nl,
	write(B),
	write(' hilichurl(s)'),
	nl,
	write(C),
	write(' mage(s)'),
	nl,
	retract(game_state(in_quest_dialogue)),
	assertz(game_state(travelling)).
yes :-
	\+ game_state(in_quest_dialogue), !,
	write('You are not in quest dialogue!!').

no :-
	game_state(in_quest_dialogue), !,
	write('You rejected the quest!!'),
	retract(game_state(in_quest_dialogue)),
	assertz(game_state(travelling)),
	retract(slime_counter(_)),
	retract(hilichurl_counter(_)),
	retract(mage_counter(_)).
no :-
	\+ game_state(in_quest_dialogue), !,
	write('You are not in quest dialogue!!').

update_quest(A) :-
	A =:= 0,
	\+ slime_counter(0), !,
	slime_counter(B),
	C is B - 1,
	retract(slime_counter(_)),
	assertz(slime_counter(C)),
	check_quest_done.
update_quest(A) :-
	A =:= 0,
	slime_counter(0), !.
update_quest(A) :-
	A =:= 1,
	\+ hilichurl_counter(0), !,
	hilichurl_counter(B),
	C is B - 1,
	retract(hilichurl_counter(_)),
	assertz(hilichurl_counter(C)),
	check_quest_done.
update_quest(A) :-
	A =:= 1,
	hilichurl_counter(0), !.
update_quest(A) :-
	A =:= 2,
	\+ mage_counter(0), !,
	mage_counter(B),
	C is B - 1,
	retract(mage_counter(_)),
	assertz(mage_counter(C)),
	check_quest_done.
update_quest(A) :-
	A =:= 2,
	mage_counter(0), !.
update_quest(A) :-
	A =:= 3, !.

check_quest_done :-
	slime_counter(0),
	hilichurl_counter(0),
	mage_counter(0),
	write('Quest finished!!! You get :'),
	questExp(A),
	write(' Exp'),
	nl,
	questGold(B),
	write(' Gold'),
	nl,
	add_player_exp(A),
	add_player_gold(B).
check_quest_done :-
	\+ slime_counter(0), !.
check_quest_done :-
	\+ hilichurl_counter(0), !.
check_quest_done :-
	\+ mage_counter(0), !.

% file: C:/Users/Aphos/Documents/prolog-genshin/save.pl

save :-
	open('a.pl', write, A),
	set_output(A),
	write(':- dynamic(player_class/1).'),
	nl,
	write(':- dynamic(player_level/1).'),
	nl,
	write(':- dynamic(equipped_weapon/1).'),
	nl,
	write(':- dynamic(player_health/1).'),
	nl,
	write(':- dynamic(player_attack/1).'),
	nl,
	write(':- dynamic(player_defense/1).'),
	nl,
	write(':- dynamic(player_max_health/1).'),
	nl,
	write(':- dynamic(player_max_attack/1).'),
	nl,
	write(':- dynamic(player_max_defense/1).'),
	nl,
	write(':- dynamic(current_gold/1).'),
	nl,
	write(':- dynamic(current_exp/1).'),
	nl,
	write(':- dynamic(upgradable/0).'),
	nl,
	write(':- dynamic(inventory_bag/2).'),
	nl,
	write(':- dynamic(quest_active/1).'),
	nl,
	write(':- dynamic(slime_counter/1).'),
	nl,
	write(':- dynamic(hilichurl_counter/1).'),
	nl,
	write(':- dynamic(mage_counter/1).'),
	nl,
	write(':- dynamic(game_opened/0).'),
	nl,
	write(':- dynamic(game_start/0).'),
	nl,
	write(':- dynamic(game_state/1).'),
	nl,
	write(':- dynamic(type_enemy/1).'),
	nl,
	write(':- dynamic(hp_enemy/1).'),
	nl,
	write(':- dynamic(att_enemy/1).'),
	nl,
	write(':- dynamic(def_enemy/1).'),
	nl,
	write(':- dynamic(lvl_enemy/1).'),
	nl,
	write(':- dynamic(map_entity/3).'),
	nl,
	write(':- dynamic(isPagar/2).'),
	nl,
	write(':- dynamic(draw_done/1).'),
	nl,
	write(':- dynamic(fight_or_run/0).'),
	nl,
	write(':- dynamic(can_run/0).'),
	nl,
	write(':- dynamic(special_timer/1).'),
	nl,
	write(':- dynamic(shopactive/0).'),
	nl,
	listing,
	close(A).

% file: C:/Users/Aphos/Documents/prolog-genshin/shop.pl

shop :-
	game_state(shopactive), !,
	writeShopUsedMessage,
	fail.
shop :-
	assertz(game_state(shopactive)), !,
	write('What do you want to buy?'),
	nl,
	write('1. Gacha (1000 gold)'),
	nl,
	write('2. Health Potion (100 gold)'),
	nl,
	write('3. Panas spesial 2 mekdi (150 gold)'),
	nl,
	write('4. Sadikin (200 gold)'),
	nl,
	write('5. Go milk (250 gold)'),
	nl,
	write('6. Crisbar (300 gold)'),
	nl.

listIdx([A], 0, A).
listIdx([A|_], 0, A).
listIdx([_|A], B, C) :-
	D is B - 1,
	listIdx(A, D, C).

listitem(['waster greatsword', 'waster greatsword', 'waster greatsword', 'waster greatsword', 'waster greatsword', 'old merc pal', 'old merc pal', 'old merc pal', 'old merc pal', 'debate club', 'debate club', 'debate club', 'prototype aminus', 'prototype aminus', 'wolf greatsword', 'hunter bow', 'hunter bow', 'hunter bow', 'hunter bow', 'hunter bow', 'seasoned hunter bow', 'seasoned hunter bow', 'seasoned hunter bow', 'seasoned hunter bow', messenger, messenger, messenger, 'favonius warbow', 'favonius warbow', 'skyward harp', 'apprentice notes', 'apprentice notes', 'apprentice notes', 'apprentice notes', 'apprentice notes', 'pocket grimoire', 'pocket grimoire', 'pocket grimoire', 'pocket grimoire', 'emerald orb', 'emerald orb', 'emerald orb', 'mappa mare', 'mappa mare', 'skyward atlas', 'wooden armor', 'wooden armor', 'wooden armor', 'wooden armor', 'wooden armor', 'iron armor', 'iron armor', 'iron armor', 'iron armor', 'steel armor', 'steel armor', 'steel armor', 'golden armor', 'golden armor', 'diamond armor']).

gacha :-
	\+ game_state(shopactive), !,
	writeShopIsNotOpenMessage,
	fail.
gacha :-
	current_gold(A),
	price(gacha, B),
	A < B,
	writeNotEnoughGold,
	fail.
gacha :-
	listitem(A),
	game_state(shopactive),
	current_gold(B),
	price(gacha, C),
	B >= C,
	retract(current_gold(B)),
	D is B - C,
	assertz(current_gold(D)),
	random(0, 59, E),
	listIdx(A, E, F),
	addToInventory([F|1]),
	writeGacha(F), !.

writeGacha(A) :-
	\+ ultraRareItem(A),
	\+ rareItem(A),
	format('You got ~w.~n', [A]).
writeGacha(A) :-
	ultraRareItem(A),
	format('Congratulation! you got ~w (ULTRA RARE).~n', [A]).
writeGacha(A) :-
	rareItem(A),
	format('Congratulation! you got ~w (RARE).~n', [A]).

healthpotion :-
	\+ game_state(shopactive), !,
	writeShopIsNotOpenMessage,
	fail.
healthpotion :-
	current_gold(A),
	price(healthpotion, B),
	A < B,
	writeNotEnoughGold,
	fail.
healthpotion :-
	game_state(shopactive),
	current_gold(A),
	price('health potion', B),
	A >= B,
	retract(current_gold(A)),
	C is A - B,
	assertz(current_gold(C)),
	addToInventory(['health potion'|1]),
	write('Thanks for buying!'),
	nl.

panas :-
	\+ game_state(shopactive), !,
	writeShopIsNotOpenMessage,
	fail.
panas :-
	current_gold(A),
	price(panas, B),
	A < B,
	writeNotEnoughGold,
	fail.
panas :-
	game_state(shopactive),
	current_gold(A),
	price('panas spesial 2 mekdi', B),
	A >= B,
	retract(current_gold(A)),
	C is A - B,
	assertz(current_gold(C)),
	addToInventory(['panas 2 spesial mekdi'|1]),
	write('Thanks for buying!'),
	nl.

sadikin :-
	\+ game_state(shopactive), !,
	writeShopIsNotOpenMessage,
	fail.
sadikin :-
	current_gold(A),
	price(sadikin, B),
	A < B,
	writeNotEnoughGold,
	fail.
sadikin :-
	game_state(shopactive),
	current_gold(A),
	price(sadikin, B),
	A >= B,
	retract(current_gold(A)),
	C is A - B,
	assertz(current_gold(C)),
	addToInventory([sadikin|1]),
	write('Thanks for buying!'),
	nl.

gomilk :-
	\+ game_state(shopactive), !,
	writeShopIsNotOpenMessage,
	fail.
gomilk :-
	current_gold(A),
	price(gomilk, B),
	A < B,
	writeNotEnoughGold,
	fail.
gomilk :-
	game_state(shopactive),
	current_gold(A),
	price('go milk', B),
	A >= B,
	retract(current_gold(A)),
	C is A - B,
	assertz(current_gold(C)),
	addToInventory(['go milk'|1]),
	write('Thanks for buying!'),
	nl.

crisbar :-
	\+ game_state(shopactive), !,
	writeShopIsNotOpenMessage,
	fail.
crisbar :-
	current_gold(A),
	price(crisbar, B),
	A < B,
	writeNotEnoughGold,
	fail.
crisbar :-
	game_state(shopactive),
	current_gold(A),
	price(crisbar, B),
	A >= B,
	retract(current_gold(A)),
	C is A - B,
	assertz(current_gold(C)),
	addToInventory([crisbar|1]),
	write('Thanks for buying!'),
	nl.

exitShop :-
	\+ game_state(shopactive), !,
	writeShopIsNotOpenMessage,
	fail.
exitShop :-
	retract(game_state(shopactive)),
	assertz(game_state(travelling)),
	write('Farewell Traveller'),
	nl.

writeShopIsNotOpenMessage :-
	write('Please open the shop first'),
	nl.

writeNotEnoughGold :-
	write('Not enough gold! go clear the quests to get some gold!'),
	nl.

writeShopUsedMessage :-
	write('You have already opened shop'),
	nl.

hehe :-
	write('EHE TO NANDAYO?'),
	nl.

% file: C:/Users/Aphos/Documents/prolog-genshin/utility.pl

power(_, 0, 1).
power(A, B, C) :-
	B > 0,
	D is B - 1,
	power(A, D, E),
	C is A * E.
power(A, B, C) :-
	B < 0,
	D is B + 1,
	power(A, D, E),
	C is E / A.

calc_damage(A, B, C) :-
	D is A - 5,
	E is A + 5,
	random(D, E, F),
	G is F,
	C is truncate(G - 0.20000000000000001 * B).

calc_status_upgrade(A, B) :-
	B is truncate(A * 1.3999999999999999).

push(A, [], [A]).
push(A, [B|C], [B|D]) :-
	push(A, C, D).

modifyElement([A|B], [[A, C]|D], [[A, E]|D]) :-
	E is C + B.
modifyElement([A|B], [[C, D]|E], [[C, D]|F]) :-
	modifyElement([A|B], E, F).

reduceElement([A|B], [[A, C]|D], [[A, E]|D]) :-
	E is C - B.

getItemAmount(A, [[A, B]|_], B).
getItemAmount(A, [[_, _]|B], C) :-
	getItemAmount(A, B, D),
	C is D.
