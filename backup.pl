:- dynamic(player_class/1).
:- dynamic(player_level/1).
:- dynamic(equipped_weapon/1).
:- dynamic(equipped_cover/1).
:- dynamic(player_health/1).
:- dynamic(player_attack/1).
:- dynamic(player_defense/1).
:- dynamic(buff_att/1).
:- dynamic(buff_def/1).
:- dynamic(player_max_health/1).
:- dynamic(player_attack_mult/1).
:- dynamic(player_defense_mult/1).
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
	hp_enemy(A), !,
	retract(hp_enemy(A)),
	att_enemy(_),
	def_enemy(B), !,
	player_attack(C),
	player_attack_mult(D), !,
	_ is C * D,
	calc_damage(C, B, E), !,
	attack_mutate(E, F), !,
	G is A - F,
	assertz(hp_enemy(G)),
	write('You deal '),
	write(E),
	write(' damage!'),
	nl,
	nl,
	check_death_boss.
attack :-
	game_state(in_battle),
	\+ fight_or_run, !,
	hp_enemy(A), !,
	retract(hp_enemy(A)),
	att_enemy(_),
	def_enemy(B), !,
	player_attack(C),
	player_attack_mult(D), !,
	E is C * D,
	calc_damage(E, B, F), !,
	attack_mutate(F, G), !,
	H is A - G,
	assertz(hp_enemy(H)),
	write('You deal '),
	write(F),
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
	player_attack_mult(E), !,
	F is D * E,
	G is 2 * F,
	calc_damage(G, C, H),
	attack_mutate(H, I), !,
	J is B - I,
	assertz(hp_enemy(J)),
	write('You deal '),
	write(H),
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
	player_attack_mult(E), !,
	F is D * E,
	G is 2 * F,
	calc_damage(G, C, H),
	attack_mutate(H, I), !,
	J is B - I,
	assertz(hp_enemy(J)),
	write('You deal '),
	write(H),
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
	consumable_type(A, B), !,
	use_item(A, B),
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
	consumable_type(A, B), !,
	use_item(A, B),
	write('You used '),
	write(A),
	nl,
	special_timer(C),
	D is C + 1,
	retract(special_timer(_)),
	assertz(special_timer(D)),
	enemy_turn, !.
item :-
	game_state(in_battle), !,
	inventory,
	write('Input item name!!'),
	nl,
	read(A),
	consumable_type(A, B), !,
	substractFromInventory([A|1]),
	use_item(A, B),
	write('You used '),
	write(A),
	nl,
	special_timer(C),
	D is C + 1,
	retract(special_timer(_)),
	assertz(special_timer(D)),
	enemy_turn, !.

use_item(A, B) :-
	B = heal,
	player_max_health(C),
	property(A, D), !,
	E is truncate(C * D),
	heal(E).
use_item(A, B) :-
	B = att,
	property(A, C), !,
	attUp(C).
use_item(A, B) :-
	B = def,
	property(A, C), !,
	defUp(C).

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

attUp(A) :-
	equipped_weapon(B),
	property(B, C), !,
	D is C + A,
	retract(buff_att(_)),
	assertz(buff_att(3)),
	retract(player_attack_mult(_)),
	assertz(player_attack_mult(D)).

defUp(A) :-
	equipped_cover(B),
	property(B, C, _), !,
	D is C + A,
	retract(buff_def(_)),
	assertz(buff_def(3)),
	retract(player_defense_mult(_)),
	assertz(player_defense_mult(D)).

check_death :-
	hp_enemy(A),
	A =< 0, !,
	type_enemy(B),
	enemy_type(B, C), !,
	write(C),
	write(' defeated! you got : '),
	nl, !,
	enemy_exp(B, D),
	enemy_gold(B, E),
	lvl_enemy(F), !,
	G is D + 5 * F,
	H is E + 10 * F,
	write(G),
	write(' exp'),
	nl,
	write(H),
	write(' gold'),
	nl,
	add_player_exp(G),
	add_player_gold(H), !,
	update_quest(B),
	buff_att(I),
	buff_def(J), !,
	check_buff_att(I),
	check_buff_def(J), !,
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
	buff_att(C),
	buff_def(D), !,
	check_buff_att(C),
	check_buff_def(D), !,
	enemy_turn.

check_death_boss :-
	hp_enemy(A),
	A =< 0, !,
	type_enemy(B),
	enemy_type(B, C), !,
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
	buff_att(C),
	buff_def(D), !,
	check_buff_att(C),
	check_buff_def(D), !,
	enemy_turn.

check_buff_att(A) :-
	A > 0, !,
	buff_att(B), !,
	C is B - 1,
	retract(buff_att(_)),
	assertz(buff_att(C)).
check_buff_att(A) :-
	A =:= 0, !,
	equipped_weapon(B),
	property(B, C), !,
	retract(player_attack_mult(_)),
	assertz(player_attack_mult(C)).

check_buff_def(A) :-
	A > 0, !,
	buff_def(B), !,
	C is B - 1,
	retract(buff_def(_)),
	assertz(buff_def(C)).
check_buff_def(A) :-
	A =:= 0, !,
	equipped_cover(B),
	property(B, C, _), !,
	retract(player_defense_mult(_)),
	assertz(player_defense_mult(C)).

enemy_turn :-
	!,
	att_enemy(A),
	player_defense(B),
	player_defense_mult(C),
	player_health(D), !,
	E is truncate(B * C),
	calc_damage(A, E, F), !,
	attack_mutate(F, G), !,
	H is D - G,
	retract(player_health(D)),
	assertz(player_health(H)), !,
	type_enemy(I),
	enemy_type(I, J), !,
	write(J),
	write(' deals '),
	write(F),
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
	hp_enemy(C), !,
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
	player_max_health(E), !,
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
	write(' gold'),
	nl, !,
	add_player_gold(E).
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

enemy_exp(0, 50).
enemy_exp(1, 100).
enemy_exp(2, 250).
enemy_exp(3, 250).

enemy_gold(0, 75).
enemy_gold(1, 150).
enemy_gold(2, 300).
enemy_gold(3, 300).

% file: C:/Users/Aphos/Documents/prolog-genshin/inventory.pl

inventoryMaxSize(100).

inventory :-
	write(===============================================),
	nl,
	write('           I  N  V  E  N  T  O  R  Y           '),
	nl,
	write(===============================================),
	nl,
	nl,
	inventory_bag(A, _),
	printInventory(A),
	nl,
	write(===============================================), !,
	nl.

printInventory([]).
printInventory([A|B]) :-
	printPair(A),
	printInventory(B).

printPair([A|B]) :-
	[C|_] = B,
	C > 0, !,
	type(D, A),
	format('[type : ~w] ', [D]),
	write(A),
	write(' : '),
	write(C),
	nl.
printPair([_|_]) :-
	!.

addToInventory([A|B]) :-
	inventory_bag(_, C),
	D is C + B,
	inventoryMaxSize(E),
	D =< E, !,
	handleAddToInventory([A|B]).
addToInventory([_|_]) :-
	!,
	write('Your inventory is full! sell some item(s) to the shop first!').

handleAddToInventory([A|B]) :-
	inventory_bag(C, D),
	member([A|_], C), !,
	modifyElement([A|B], C, E),
	F is D + B,
	retract(inventory_bag(C, D)), !,
	assertz(inventory_bag(E, F)).
handleAddToInventory([A|B]) :-
	inventory_bag(C, D),
	\+ member([A|_], C),
	push([A, B], C, E),
	F is D + B,
	retract(inventory_bag(C, D)), !,
	assertz(inventory_bag(E, F)).

substractFromInventory([A|B]) :-
	inventory_bag(C, D),
	findItemAmount(A, E),
	E >= B, !,
	reduceElement([A|B], C, F),
	G is D - B,
	retract(inventory_bag(C, D)), !,
	assertz(inventory_bag(F, G)).
substractFromInventory([_|_]) :-
	write('Hey dont cheat!'),
	nl,
	fail.

findItemAmount(A, B) :-
	inventory_bag(C, _),
	member([A|_], C), !,
	getItemAmount(A, C, B).
findItemAmount(A, B) :-
	inventory_bag(C, _),
	\+ member([A|_], C), !,
	B is 0.

equip(_) :-
	game_state(in_battle), !,
	write('Cannot equip item in battle.').
equip(A) :-
	\+ item(A), !,
	write('That is not an item.').
equip(A) :-
	findItemAmount(A, B),
	B =< 0, !,
	write('Item not in inventory.').
equip(A) :-
	type(B, A),
	player_class(C),
	weapon(B),
	equipmentAllowed(C, A), !,
	player_attack_mult(D),
	equipped_weapon(E),
	property(E, _),
	retract(equipped_weapon(E)),
	assertz(equipped_weapon(A)),
	property(_, F),
	player_attack_mult(D),
	G is D + F,
	retract(player_attack_mult(_)),
	assertz(player_attack_mult(G)),
	substractFromInventory([A|1]),
	addToInventory([E|1]),
	write('Equipped '),
	write(A).
equip(A) :-
	type(B, A),
	player_class(C),
	weapon(B),
	\+ equipmentAllowed(C, A), !,
	write('This weapon is not suitable for your class.').
equip(A) :-
	type(B, A),
	cover(B), !,
	equipped_cover(C),
	player_defense_mult(D),
	player_max_health(E),
	player_health(F),
	property(C, G, H),
	property(A, I, J),
	K is truncate(F * J / H),
	L is truncate(E * J / H),
	M is D + I - G,
	retract(player_defense_mult(_)),
	assertz(player_defense_mult(M)),
	retract(player_max_health(_)),
	assertz(player_max_health(L)),
	retract(player_health(_)),
	assertz(player_health(K)),
	retract(equipped_cover(_)),
	assertz(equipped_cover(A)),
	substractFromInventory([A|1]),
	addToInventory([C|1]),
	write('Equipped '),
	write(A).

equipped_items :-
	equipped_weapon(A),
	write('Weapon:'),
	write(A),
	nl,
	property(A, B),
	write('Attack Bonus: '),
	write(B),
	nl,
	equipped_cover(C),
	property(C, D, E),
	write('Armor:'),
	write(C),
	nl,
	write('Bonus Defense: '),
	write(D),
	nl,
	write('Bonus Health: '),
	write(E).

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
type(consumable, 'attack potion S').
type(consumable, 'attack potion M').
type(consumable, 'attack potion L').
type(consumable, 'defense potion S').
type(consumable, 'defense potion M').
type(consumable, 'defense potion L').
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

weapon(bow).
weapon(catalyst).
weapon(claymore).

cover(armor).

price('health potion', 100).
price('panas spesial 2 mekdi', 150).
price(sadikin, 200).
price('go milk', 250).
price(crisbar, 300).
price(gacha, 1000).
price('attack potion S', 300).
price('attack potion M', 350).
price('attack potion L', 400).
price('defense potion S', 250).
price('defense potion M', 300).
price('defense potion L', 350).

ultraRareItem('wolf greatsword').
ultraRareItem('skyward harp').
ultraRareItem('skyward atlas').
ultraRareItem('diamond armor').

rareItem('prototype aminus').
rareItem('favonius warbow').
rareItem('mappa mare').
rareItem('golden armor').

consumable_type('health potion', heal).
consumable_type('panas spesial 2 mekdi', heal).
consumable_type(sadikin, heal).
consumable_type('go milk', heal).
consumable_type(crisbar, heal).
consumable_type('attack potion S', att).
consumable_type('attack potion M', att).
consumable_type('attack potion L', att).
consumable_type('defense potion S', def).
consumable_type('defense potion M', def).
consumable_type('defense potion L', def).

property('health potion', A) :-
	A is 0.10000000000000001.
property('panas spesial 2 mekdi', A) :-
	A is 0.14999999999999999.
property(sadikin, A) :-
	A is 0.25.
property('go milk', A) :-
	A is 0.32000000000000001.
property(crisbar, A) :-
	A is 0.45000000000000001.
property('attack potion S', A) :-
	A is 0.10000000000000001.
property('attack potion M', A) :-
	A is 0.29999999999999999.
property('attack potion L', A) :-
	A is 0.5.
property('defense potion S', A) :-
	A is 0.10000000000000001.
property('defense potion M', A) :-
	A is 0.29999999999999999.
property('defense potion L', A) :-
	A is 0.5.
property('waster greatsword', A) :-
	A is 1.0.
property('old merc pal', A) :-
	A is 1.2.
property('debate club', A) :-
	A is 1.3999999999999999.
property('prototype aminus', A) :-
	A is 1.7.
property('wolf greatsword', A) :-
	A is 3.0.
property('hunter bow', A) :-
	A is 1.0.
property('seasoned hunter bow', A) :-
	A is 1.2.
property(messenger, A) :-
	A is 1.3999999999999999.
property('favonius warbow', A) :-
	A is 1.7.
property('skyward harp', A) :-
	A is 3.0.
property('apprentice notes', A) :-
	A is 1.0.
property('pocket grimoire', A) :-
	A is 1.2.
property('emerald orb', A) :-
	A is 1.3999999999999999.
property('mappa mare', A) :-
	A is 1.7.
property('skyward atlas', A) :-
	A is 3.0.

property('wooden armor', A, B) :-
	A is 1.0,
	B is 1.0.
property('iron armor', A, B) :-
	A is 1.2,
	B is 1.2.
property('steel armor', A, B) :-
	A is 1.3999999999999999,
	B is 1.3999999999999999.
property('golden armor', _, A) :-
	_ is 1.7,
	A is 1.7.
property('diamond armor', A, B) :-
	A is 3.0,
	B is 3.0.

% file: C:/Users/Aphos/Documents/prolog-genshin/main.pl

player_class(knight).

player_level(37).

equipped_weapon('waster greatsword').

equipped_cover('wooden armor').

player_health(15352).

player_attack(309126805284).

player_defense(804).

buff_att(0).

buff_def(0).

player_attack_mult(1.0).

player_defense_mult(1.0).

player_max_health(15352).

current_gold(12140).

current_exp(895).


inventory_bag([['health potion', 10], ['attack potion S', 5], ['mappa mare', 3]], 18).

quest_active(false).

slime_counter(0).

hilichurl_counter(0).

mage_counter(0).

game_opened.

game_start.

game_state(travelling).

type_enemy(2).

hp_enemy(-309126804797).

att_enemy(175).

def_enemy(84).

lvl_enemy(27).

map_entity(14, 12, 'T').
map_entity(3, 14, 'T').
map_entity(2, 5, 'T').
map_entity(13, 3, 'T').
map_entity(2, 7, 'Q').
map_entity(15, 15, 'B').
map_entity(13, 1, 'S').
map_entity(3, 4, 'P').

draw_done(true).


can_run.
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
	nl,
	write('                                .:-.`         ``......-:...-` `..-`.    ``..````.-///:.                 `.--.        '),
	nl,
	write('                              .--.        ...---.```  ```-``.  ...........```````.-----                   `.:-.      '),
	nl,
	write('                           `--.`    `-:::.````````..--.-..`:` -`.---````....--:------`                     `-:-`     '),
	nl,
	write('                           -:-`      ///--````.---.``  `..` -- .  ```      ```:::--.                          `-:.   '),
	nl,
	write('                         `--.        -::--.-::.`            .: .`` `   `.--....`                                .:-` '),
	nl,
	write('                        .--`          `.---:::-....`.`     `.. `..`  ```....`                                    `--`'),
	nl,
	write('                       .:-`                 ```````````    ..-` `-           ````                                 `'),
	nl,
	write('                      .:-`                       ```        `:: :                `.``                              '),
	nl,
	write('                 ------ `                      ``             :`.                   `.`                            '),
	nl,
	write('                     `                       ``               .-.                     `.`                          '),
	nl,
	write('                                           `                  `              ``         ``                         '),
	nl,
	write('                                         `                                    ::.         ``                       '),
	nl,
	write('                                       ``                                     /os+-.`       `.`                    '),
	nl,
	write('                                    `.`                           `           -ddmmNNmm:          ```.``````       '),
	nl,
	write('                                    ``               `             -`         :oshmNNNNs                ``..       '),
	nl,
	write('                                   ``                 .            ---           `.:smNm`       `       `.`        '),
	nl,
	write('                               ```                  `:-           ...-.`            .om+        `.``..-.`        `:'),
	nl,
	write('                 `         ``..`                  ``:`--           :  `--.    ``      -h.         ---`         `..+'),
	nl,
	write('                 .::..``....``       `            ./`  -:`         ..  ``.-.```.`      ./          ``...``````.``-:'),
	nl,
	write('                   .--..`          ``            `o.````.:-`        -`      `.-:/`      `               ````  ``:/ '),
	nl,
	write('                     `.--...`````````            ::`      .:-`       .` ``.---` ./             `````    ````..-/:  '),
	nl,
	write('                         ```.----:.``            /  ```.--.`.-:-.```  .:ydmmmdyo/--             ``.-........-::.   '),
	nl,
	write('                                :-``             :``/hhhhhs/   ..--//-.:hmddmmsoh//             ```.--.----:-.    `'),
	nl,
	write('                         `...` :-``.             /:dsymmhdm/        ````md/.hmm`o-::             ````--..:/.    `.``'),
	nl,
	write('                      ``.````-/-.``.             +yy`mNh.-hh            os+:+o/ .`-/       `      ````--..-:.  ..```'),
	nl,
	write('                    ``````````-:.``:`   `       `+./`ohs+://            `::--.`  .-/`       `     ````.:-.../..````'),
	nl,
	write('                 ``````````````:-../.   `       `/-`` ://-.`                    `::/-       `      ````::...-o`````'),
	nl,
	write('                 ````````````` `:.-/.`   `      `/:-           `  ```.`         :/.-:      ```     ````-+::..+```````'),
	nl,
	write('                 ````````       :oso/.`  ``     `+:+-         .:-....--        .+--:-     ````      ``.-/ -/-+. `````'),
	nl,
	write('                 ``````````     -::sh-``  ``    `::-+:`       `...``...      `-/---/`    ```.      ```--:  `++` ``````'),
	nl,
	write('                 `````````````  :o+:/s-`` `.`    .oyhmy/.`     ```````    `-oo/:--:.  `````.-     ``--./` ``:+.....```'),
	nl,
	write('                 ```````````----+dNNdhm+````..`  .+NNNNNmhy+:-.``    `.-+shmmmmds/.```````.:`  ````./.-+:--.``...:-` `'),
	nl,
	write('                  ``````` `-:-:/-hmmmmNNh/.``...``.oNNNNNNNNNNmdhyysyydmmmmmNmho-````````.-`       ://::-....``...    '),
	nl,
	write('                 ``        :      :sdmmmmNmy+--:-...+mNNNNmmmmmmNNNNNNmmmmmNNdyso//::-:+s-`       .+:.`.-.` ```       '),
	nl,
	write('                   ``      `.       ./sdmmNNNNNddho:--ohdddh+-dmmmmmNNNNNNNNNNNNNNNdysoo:``      -/` `-.            `.'),
	nl,
	nl,
	nl,
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
	write(================================================================================================================================================),
	nl,
	write('                                     |Welcome to Genshin Asik Cihuy Semoga Bagus Hasilnya!|                                                     '),
	nl,
	write('                                     |                   Main Menu:                       |                                                     '),
	nl,
	write('                                     |                  1. New Game                       |                                                     '),
	nl,
	write('                                     |                  2. Load Game                      |                                                     '),
	nl,
	write('                                     |   Type ''new.'' or ''load.'' to start the game.        |                                                 '),
	nl,
	write(================================================================================================================================================),
	nl,
	assertz(game_opened).

new :-
	game_opened, !,
	\+ game_start,
	assertz(game_start),
	assertz(game_state(travelling)), !,
	write(================================================================================================================================================),
	nl,
	write('           @@@@@@@@@   @@@@@@@@@   @     @   @@@@@@@@@   @      @   @   @     @      @   @@@@@@@@@   @@@@@@@@@   @   @     @@@@@@     @         '),
	nl,
	write('           @       @   @           @@    @   @           @      @   @   @@    @      @   @           @           @  @     @      @    @         '),
	nl,
	write('           @           @           @ @   @   @           @      @   @   @ @   @      @   @           @           @ @     @        @   @         '),
	nl,
	write('           @           @@@@@@@@@   @  @  @   @@@@@@@@@   @@@@@@@@   @   @  @  @      @   @@@@@@@@@   @@@@@@@@@   @       @        @   @         '),
	nl,
	write('           @  @@@@@@   @           @   @ @           @   @      @   @   @   @ @      @           @   @           @ @     @@@@@@@@@@   @         '),
	nl,
	write('           @       @   @           @    @@           @   @      @   @   @    @@      @           @   @           @  @    @        @   @         '),
	nl,
	write('           @@@@@@@@@   @@@@@@@@@   @     @   @@@@@@@@@   @      @   @   @     @      @   @@@@@@@@@   @@@@@@@@@   @   @   @        @   @         '),
	nl,
	nl,
	write(================================================================================================================================================),
	nl,
	nl,
	choose_class,
	assertz(type_enemy(0)),
	assertz(hp_enemy(0)),
	assertz(att_enemy(0)),
	assertz(def_enemy(0)),
	assertz(lvl_enemy(0)),
	assertz(special_timer(0)),
	assertz(buff_att(0)),
	assertz(buff_def(0)),
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
	setBorder.
new :-
	game_start, !,
	write('The game has already been started. Use ''help.'' to look for available commands!').

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
	write(================================================================================================================================================),
	nl,
	write('|                          You are currently in a battle. Here are some commands to help you get through the battle.                           |'),
	nl,
	write(================================================================================================================================================),
	nl,
	write('|        Commmand        |                                                           Function                                                  |'),
	nl,
	write('|------------------------|---------------------------------------------------------------------------------------------------------------------|'),
	nl,
	write('|       ''fight.''         |     Fight against the encountered enemy.                                                                            |'),
	nl,
	write('|        ''run.''          |     Run away from the enemy. Might as well not work as it is and you have no choice but to fight the enemy.         |'),
	nl,
	write('|       ''attack.''        |     Attack the enemy you''re currently facing.                                                                       |'),
	nl,
	write('|   ''special_attack.''    |     Use special attack ONLY when you face the boss.                                                                 |'),
	nl,
	write('|       ''item.''          |     Use items in your inventory.                                                                                    |'),
	nl,
	write('|       ''status.''        |     Get the player info.                                                                                            |'),
	nl,
	write(================================================================================================================================================),
	nl.
help :-
	game_state(in_quest_dialogue), !,
	write(================================================================================================================================================),
	nl,
	write('|                       You are currently negotiating a quest offered to you. Here are the valid commands for this state.                      |'),
	nl,
	write(================================================================================================================================================),
	nl,
	write('|        Commmand        |                                                           Function                                                  |'),
	nl,
	write('|------------------------|---------------------------------------------------------------------------------------------------------------------|'),
	nl,
	write('|        ''yes.''          |     accept the quest.                                                                                               |'),
	nl,
	write('|         ''no.''          |     reject the quest.                                                                                               |'),
	nl,
	write(================================================================================================================================================),
	nl.
help :-
	game_state(shopactive), !,
	write(================================================================================================================================================),
	nl,
	write('|                              The shop is now open! Here are some commands to get the stuff you needed.                                       |'),
	nl,
	write(================================================================================================================================================),
	nl,
	write('|        Commmand        |                                                           Function                                                  |'),
	nl,
	write('|------------------------|---------------------------------------------------------------------------------------------------------------------|'),
	nl,
	write('|       ''gacha.''         |     Get a random item with a random class and keep it in your inventory.                                            |'),
	nl,
	write('|    ''health potion.''     |     Buy a health potion.                                                                                            |'),
	nl,
	write('|       ''panas.''         |     Buy a panas spesial 2 mekdi.                                                                                    |'),
	nl,
	write('|      ''sadikin.''        |     Buy a sadikin.                                                                                                  |'),
	nl,
	write('|       ''go milk.''        |     Buy a go milk.                                                                                                  |'),
	nl,
	write('|      ''crisbar.''        |     Buy a crisbar.                                                                                                  |'),
	nl,
	write('|      ''exitshop.''       |     Exit the shop.                                                                                                  |'),
	nl,
	write('|        ''sell.''         |     Sell items in your inventory.                                                                                   |'),
	nl,
	write(================================================================================================================================================),
	nl.
help :-
	game_state(travelling), !,
	write(================================================================================================================================================),
	nl,
	write('|              You are currently travlling in the outside world! Here are some commands to guide you through this fantasy map.                 |'),
	nl,
	write(================================================================================================================================================),
	nl,
	write('|        Commmand        |                                                           Function                                                  |'),
	nl,
	write('|------------------------|---------------------------------------------------------------------------------------------------------------------|'),
	nl,
	write('|        ''w.''          |     Move upward.                                                                                                    |'),
	nl,
	write('|        ''a.''          |     Move to the left.                                                                                               |'),
	nl,
	write('|        ''s.''          |     Move downward.                                                                                                  |'),
	nl,
	write('|        ''d.''          |     Move to the right.                                                                                              |'),
	nl,
	write('|       ''map.''         |     Print the map you are currently in.                                                                             |'),
	nl,
	write('|      ''quest.''        |     Do a quest when arriving at a place labeled ''Q''.                                                              |'),
	nl,
	write('|       ''shop.''        |     Open the shop.                                                                                                  |'),
	nl,
	write('|     ''inventory.''     |     Check your inventory.                                                                                           |'),
	nl,
	write('|       ''item.''        |     Use items in your inventory.                                                                                    |'),
	nl,
	write('|   ''equipped_items.''  |     Check your equipped weapon and armor                                                                            |'),
	nl,
	write('|    ''quest_info.''     |     Get the remaining enemies to be killed when doing your quest.                                                   |'),
	nl,
	write('|     ''teleport.''      |     Move to a specific waypoint on the map when you are in a waypoint labelled T.                                   |'),
	nl,
	write('|      ''status.''       |     Get the player info.                                                                                            |'),
	nl,
	write('|      ''equip.''        |     Equip a weapon or armor from inventory. Usage : equip(''item name'') .                                          |'),
	nl,
	write(================================================================================================================================================),
	nl,
	write('|                               You might encounter an enemy while you''re travelling, so be ready for them!                                   |'),
	nl,
	write(================================================================================================================================================),
	nl.

save :-
	game_opened,
	game_state(travelling), !,
	open('backup.pl', write, A),
	set_output(A),
	write(':- dynamic(player_class/1).'),
	nl,
	write(':- dynamic(player_level/1).'),
	nl,
	write(':- dynamic(equipped_weapon/1).'),
	nl,
	write(':- dynamic(equipped_cover/1).'),
	nl,
	write(':- dynamic(player_health/1).'),
	nl,
	write(':- dynamic(player_attack/1).'),
	nl,
	write(':- dynamic(player_defense/1).'),
	nl,
	write(':- dynamic(buff_att/1).'),
	nl,
	write(':- dynamic(buff_def/1).'),
	nl,
	write(':- dynamic(player_max_health/1).'),
	nl,
	write(':- dynamic(player_attack_mult/1).'),
	nl,
	write(':- dynamic(player_defense_mult/1).'),
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
save :-
	write('You cannot save now').

load :-
	file_exists('backup.pl'),
	game_opened, !,
	['backup.pl'].
load :-
	\+ file_exists('backup.pl'),
	game_opened, !,
	write('No save files detected').

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
isPagar(0, 0).
isPagar(0, 1).
isPagar(0, 2).
isPagar(0, 3).
isPagar(0, 4).
isPagar(0, 5).
isPagar(0, 6).
isPagar(0, 7).
isPagar(0, 8).
isPagar(0, 9).
isPagar(0, 10).
isPagar(0, 11).
isPagar(0, 12).
isPagar(0, 13).
isPagar(0, 14).
isPagar(0, 15).
isPagar(0, 16).
isPagar(16, 0).
isPagar(16, 1).
isPagar(16, 2).
isPagar(16, 3).
isPagar(16, 4).
isPagar(16, 5).
isPagar(16, 6).
isPagar(16, 7).
isPagar(16, 8).
isPagar(16, 9).
isPagar(16, 10).
isPagar(16, 11).
isPagar(16, 12).
isPagar(16, 13).
isPagar(16, 14).
isPagar(16, 15).
isPagar(16, 16).

setBorder :-
	forall(between(0, 16, A), assertz(isPagar(A, 0))),
	forall(between(0, 16, A), assertz(isPagar(A, 16))),
	forall(between(0, 16, B), assertz(isPagar(0, B))),
	forall(between(0, 16, B), assertz(isPagar(16, B))).

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
	game_state(travelling),
	map_entity(A, B, 'P'),
	C is B - 1,
	\+ isPagar(A, C), !,
	retract(map_entity(A, B, 'P')),
	assertz(map_entity(A, C, 'P')),
	chest_encounter, !.
w :-
	\+ game_start, !,
	write('Game is not started, use "start." to play the game.').
w :-
	game_state(in_battle), !,
	write('You are in battle!! Use "help." to display the commands that you can use.').
w :-
	game_state(shopactive), !,
	write('Exit the shop first by using command "exitShop." !'),
	nl.
w :-
	\+ game_state(travelling), !,
	write('Cannot travel now').
w :-
	write('Ouch, you hit a wall. Use "map." to open the map!!').

a :-
	game_start,
	\+ game_state(in_battle),
	game_state(travelling),
	map_entity(A, B, 'P'),
	C is A - 1,
	\+ isPagar(C, B), !,
	retract(map_entity(A, B, 'P')),
	assertz(map_entity(C, B, 'P')),
	chest_encounter, !.
a :-
	\+ game_start, !,
	write('Game is not started, use "start." to play the game.').
a :-
	game_state(in_battle), !,
	write('You are in battle!! Use "help." to display the commands that you can use.').
a :-
	game_state(shopactive), !,
	write('Exit the shop first by using command "exitShop." !'),
	nl.
a :-
	\+ game_state(travelling), !,
	write('Cannot travel now').
a :-
	write('Ouch, you hit a wall. Use "map." to open the map!!').

s :-
	game_start,
	game_state(travelling),
	map_entity(A, B, 'P'),
	C is B + 1,
	\+ isPagar(A, C),
	\+ map_entity(A, C, 'B'), !,
	retract(map_entity(A, B, 'P')),
	assertz(map_entity(A, C, 'P')),
	chest_encounter, !.
s :-
	game_start,
	game_state(travelling),
	map_entity(A, B, 'P'),
	C is B + 1,
	\+ isPagar(A, C),
	map_entity(A, C, 'B'), !,
	trigger_boss.
s :-
	\+ game_start, !,
	write('Game is not started, use "start." to play the game.').
s :-
	game_state(in_battle), !,
	write('You are in battle!! Use "help." to display the commands that you can use.').
s :-
	game_state(shopactive), !,
	write('Exit the shop first by using command "exitShop." !'),
	nl.
s :-
	\+ game_state(travelling), !,
	write('Cannot travel now').
s :-
	write('Ouch, you hit a wall. Use "map." to open the map!!').

d :-
	game_start,
	game_state(travelling),
	map_entity(A, B, 'P'),
	C is A + 1,
	\+ isPagar(C, B),
	\+ map_entity(C, B, 'B'), !,
	retract(map_entity(A, B, 'P')),
	assertz(map_entity(C, B, 'P')),
	chest_encounter, !.
d :-
	game_start,
	game_state(travelling),
	map_entity(A, B, 'P'),
	C is A + 1,
	\+ isPagar(C, B), !,
	map_entity(C, B, 'B'), !,
	trigger_boss, !.
d :-
	\+ game_start, !,
	write('Game is not started, use "start." to play the game.').
d :-
	game_state(in_battle), !,
	write('You are in battle!! Use "help." to display the commands that you can use.').
d :-
	game_state(shopactive), !,
	write('Exit the shop first by using command "exitShop." !'),
	nl.
d :-
	\+ game_state(travelling), !,
	write('Cannot travel now').
d :-
	write('Ouch, you hit a wall. Use "map." to open the map!!').

map :-
	write(===============================================),
	nl,
	write('            W  O  R  L  D    M  A  P           '),
	nl,
	write(===============================================),
	nl,
	nl,
	retract(draw_done(_)),
	asserta(draw_done(false)),
	draw_map(0, 0),
	nl,
	write(===============================================), !,
	nl.

teleport :-
	game_start,
	game_state(travelling),
	map_entity(A, B, 'P'),
	\+ map_entity(A, B, 'T'), !,
	write('You''re not on teleport point!!'),
	nl,
	write('Use "map." to open the map!!').
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
	write(================================================================================================================================================),
	nl,
	write('                                        |                     Choose your job!                     |                                            '),
	nl,
	write('                                        |                        1. Knight                         |                                            '),
	nl,
	write('                                        |                        2. Archer                         |                                            '),
	nl,
	write('                                        |                        3. Mage                           |                                            '),
	nl,
	write(================================================================================================================================================),
	nl,
	write('|                                        Type the job you want to choose followed with a periodt.                                              |'),
	nl,
	write('|                                           For example: ''Knight''.  or ''Archer.''. or ''Mage''.                                                   |'),
	nl,
	write('|                                    Make sure to include the apostrophe! Then, press return or enter.                                         |'),
	nl,
	write(================================================================================================================================================),
	nl,
	read(A),
	nl,
	assert_class(A),
	write(================================================================================================================================================),
	nl,
	write('|                      The game has been started. Use ''help.'' to look for available commands! Here are some of them.                           |'),
	nl,
	write(================================================================================================================================================),
	nl,
	write('|        Commmand        |                                                           Function                                                  |'),
	nl,
	write('|------------------------|---------------------------------------------------------------------------------------------------------------------|'),
	nl,
	write('|       ''start.''         |     Restart the game.                                                                                               |'),
	nl,
	write('|        ''quit.''         |     Exit the game.                                                                                                  |'),
	nl,
	write('|      ''inventory.''      |     List all the items in your inventory.                                                                           |'),
	nl,
	write(================================================================================================================================================),
	nl,
	initialize_resources.

status :-
	player_class(A),
	player_level(B),
	player_health(C),
	player_attack(D),
	player_defense(E),
	player_max_health(F),
	equipped_weapon(_),
	equipped_cover(_),
	player_attack_mult(G),
	player_defense_mult(H),
	I is truncate(D * G),
	J is truncate(E * H),
	current_gold(K),
	current_exp(L),
	exp_level_up(B, M),
	write(===============================================),
	nl,
	write('             S   T   A   T   U   S             '),
	nl,
	write(===============================================),
	nl,
	write('Job      : '),
	write(A),
	nl,
	write('Level    : '),
	write(B),
	nl,
	write('Health   : '),
	write(C),
	write(/),
	write(F),
	nl,
	write('Attack   : '),
	write(I),
	nl,
	write('Defense  : '),
	write(J),
	nl,
	write('Gold     : '),
	write(K),
	nl,
	write('Exp      : '),
	write(L),
	write(/),
	write(M),
	nl,
	write(===============================================),
	nl.

exp_level_up(A, B) :-
	B is 300 * A.

assert_class('Knight') :-
	assertz(player_class(knight)),
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
	assertz(equipped_cover('wooden armor')),
	assertz(player_health_mult(1.0)),
	assertz(player_attack_mult(1.0)),
	assertz(player_defense_mult(1.0)),
	write(================================================================================================================================================),
	nl,
	write('                                               |You choose '),
	write(A),
	write(', letâ\x80\\x99\s explore the world!|'),
	nl, !.
assert_class('Archer') :-
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
	assertz(equipped_cover('wooden armor')),
	assertz(player_health_mult(1.0)),
	assertz(player_attack_mult(1.0)),
	assertz(player_defense_mult(1.0)),
	write(================================================================================================================================================),
	nl,
	write('                                               |You choose '),
	write(A),
	write(', letâ\x80\\x99\s explore the world!|'),
	nl, !.
assert_class('Mage') :-
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
	assertz(equipped_cover('wooden armor')),
	assertz(player_health_mult(1.0)),
	assertz(player_attack_mult(1.0)),
	assertz(player_defense_mult(1.0)),
	write(================================================================================================================================================),
	nl,
	write('                                               |You choose '),
	write(A),
	write(', letâ\x80\\x99\s explore the world!|'),
	nl, !.

initialize_resources :-
	assertz(current_gold(1000)),
	assertz(current_exp(0)),
	assertz(inventory_bag([['health potion', 10], ['attack potion S', 5]], 15)).

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
	print_level_up_util(G, D, E),
	call_level_up(D, E, F).

call_level_up(A, B, C) :-
	B >= C, !,
	upgrade_player_level(A, B, C).
call_level_up(_, _, _) :-
	!.

print_level_up_util(A, B, C) :-
	A > 0, !,
	write('Your character has been upgraded to level '),
	write(B),
	write(!),
	nl,
	write('You now have '),
	write(C),
	write(' Exp'),
	nl,
	write('You need '),
	write(A),
	write(' Exp to get upgraded to the next level. Keep exploring the game!'),
	nl.
print_level_up_util(_, _, _) :-
	!.

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
	write(A),
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
	write(===============================================),
	nl,
	write('                Q   U   E   S   T              '),
	nl,
	write(===============================================),
	nl,
	nl,
	write('Hello there traveler!'),
	nl,
	write('Could you help me out? I want you to slay : '),
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
	write('Would you help me out? (yes/no)'),
	nl,
	nl,
	write(=================================================),
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
	retract(quest_active(false)),
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
	retract(mage_counter(_)),
	assertz(slime_counter(0)),
	assertz(hilichurl_counter(0)),
	assertz(mage_counter(0)).
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
	write(A),
	write(' Exp'),
	nl,
	questGold(B),
	write(B),
	write(' Gold'),
	nl,
	retract(quest_active(true)),
	assertz(quest_active(false)),
	add_player_exp(A),
	add_player_gold(B).
check_quest_done :-
	\+ slime_counter(0), !.
check_quest_done :-
	\+ hilichurl_counter(0), !.
check_quest_done :-
	\+ mage_counter(0), !.

% file: C:/Users/Aphos/Documents/prolog-genshin/shop.pl

shop :-
	game_state(shopactive), !,
	writeShopUsedMessage,
	fail.
shop :-
	map_entity(A, B, 'P'),
	map_entity(A, B, 'S'),
	retract(game_state(travelling)),
	assertz(game_state(shopactive)), !,
	write(===========================================================================================),
	nl,
	write('|                                        S   H   O   P                                    |'),
	nl,
	write(===========================================================================================),
	nl,
	write('|                      Welcome to the shop! What do you want to do?                       |'),
	nl,
	write(===========================================================================================),
	nl,
	write('|    Activity    |         Item          |        Price          |        Command         |'),
	nl,
	write('-----------------|-----------------------|-----------------------|------------------------|'),
	nl,
	write('|     Gacha      |   Weapon and Armor    |      1000 gold        |       ''gacha.''         |'),
	nl,
	write('|      Buy       |     Health Potion     |      100 gold         |    ''healthpotion.''     |'),
	nl,
	write('|      Buy       | Panas Spesial 2 Mekdi |      150 gold         |       ''panas.''         |'),
	nl,
	write('|      Buy       |       Sadikin         |      200 gold         |      ''sadikin.''        |'),
	nl,
	write('|      Buy       |       Go Milk         |      250 gold         |       ''gomilk.''        |'),
	nl,
	write('|      Buy       |       Crisbar         |      300 gold         |      ''crisbar.''        |'),
	nl,
	write('|      Buy       |   Attack Potion S     |      300 gold         |    ''attackPotionS.''    |'),
	nl,
	write('|      Buy       |   Attack Potion M     |      350 gold         |    ''attackPotionM.''    |'),
	nl,
	write('|      Buy       |   Attack Potion L     |      400 gold         |    ''attackPotionL.''    |'),
	nl,
	write('|      Buy       |   Defense Potion S    |      250 gold         |    ''defensePotionS.''   |'),
	nl,
	write('|      Buy       |   Defense Potion M    |      300 gold         |    ''defensePotionM.''   |'),
	nl,
	write('|      Buy       |   Defense Potion L    |      350 gold         |    ''defensePotionL.''   |'),
	nl,
	write('|      Sell      |       All items       |   Depends on item     |        ''sell.''         |'),
	nl,
	nl,
	write(===========================================================================================),
	nl.
shop :-
	!,
	writeNotShopTile.

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
	inventory_bag(_, G),
	\+ G =:= 100,
	writeGacha(F), !.

writeGacha(A) :-
	\+ ultraRareItem(A),
	\+ rareItem(A),
	type(B, A),
	format('You got ~w [type : ~w].~n', [A, B]).
writeGacha(A) :-
	ultraRareItem(A),
	type(B, A),
	format('Congratulation! you got ~w [type : ~w] (ULTRA RARE).~n', [A, B]).
writeGacha(A) :-
	rareItem(A),
	type(B, A),
	format('Congratulation! you got ~w [type : ~w] (RARE).~n', [A, B]).

healthpotion :-
	\+ game_state(shopactive), !,
	writeShopIsNotOpenMessage,
	fail.
healthpotion :-
	current_gold(A),
	price('health potion', B),
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
	inventory_bag(_, D),
	\+ D =:= 100,
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
	inventory_bag(_, D),
	\+ D =:= 100,
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
	inventory_bag(_, D),
	\+ D =:= 100,
	write('Thanks for buying!'),
	nl.

gomilk :-
	\+ game_state(shopactive), !,
	writeShopIsNotOpenMessage,
	fail.
gomilk :-
	current_gold(A),
	price('go milk', B),
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
	inventory_bag(_, D),
	\+ D =:= 100,
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
	inventory_bag(_, D),
	\+ D =:= 100,
	write('Thanks for buying!'),
	nl.

attackPotionS :-
	\+ game_state(shopactive), !,
	writeShopIsNotOpenMessage,
	fail.
attackPotionS :-
	current_gold(A),
	price('attack potion S', B),
	A < B,
	writeNotEnoughGold,
	fail.
attackPotionS :-
	game_state(shopactive),
	current_gold(A),
	price('attack potion S', B),
	A >= B,
	retract(current_gold(A)),
	C is A - B,
	assertz(current_gold(C)),
	addToInventory(['attack potion S'|1]),
	inventory_bag(_, D),
	\+ D =:= 100,
	write('Thanks for buying!'),
	nl.

attackPotionM :-
	\+ game_state(shopactive), !,
	writeShopIsNotOpenMessage,
	fail.
attackPotionM :-
	current_gold(A),
	price('attack potion M', B),
	A < B,
	writeNotEnoughGold,
	fail.
attackPotionM :-
	game_state(shopactive),
	current_gold(A),
	price('attack potion M', B),
	A >= B,
	retract(current_gold(A)),
	C is A - B,
	assertz(current_gold(C)),
	addToInventory(['attack potion M'|1]),
	inventory_bag(_, D),
	\+ D =:= 100,
	write('Thanks for buying!'),
	nl.

attackPotionL :-
	\+ game_state(shopactive), !,
	writeShopIsNotOpenMessage,
	fail.
attackPotionL :-
	current_gold(A),
	price('attack potion L', B),
	A < B,
	writeNotEnoughGold,
	fail.
attackPotionL :-
	game_state(shopactive),
	current_gold(A),
	price('attack potion L', B),
	A >= B,
	retract(current_gold(A)),
	C is A - B,
	assertz(current_gold(C)),
	addToInventory(['attack potion L'|1]),
	inventory_bag(_, D),
	\+ D =:= 100,
	write('Thanks for buying!'),
	nl.

defensePotionS :-
	\+ game_state(shopactive), !,
	writeShopIsNotOpenMessage,
	fail.
defensePotionS :-
	current_gold(A),
	price('defense potion S', B),
	A < B,
	writeNotEnoughGold,
	fail.
defensePotionS :-
	game_state(shopactive),
	current_gold(A),
	price('defense potion S', B),
	A >= B,
	retract(current_gold(A)),
	C is A - B,
	assertz(current_gold(C)),
	addToInventory(['defense potion S'|1]),
	inventory_bag(_, D),
	\+ D =:= 100,
	write('Thanks for buying!'),
	nl.

defensePotionM :-
	\+ game_state(shopactive), !,
	writeShopIsNotOpenMessage,
	fail.
defensePotionM :-
	current_gold(A),
	price('defense potion M', B),
	A < B,
	writeNotEnoughGold,
	fail.
defensePotionM :-
	game_state(shopactive),
	current_gold(A),
	price('defense potion M', B),
	A >= B,
	retract(current_gold(A)),
	C is A - B,
	assertz(current_gold(C)),
	addToInventory(['defense potion M'|1]),
	inventory_bag(_, D),
	\+ D =:= 100,
	write('Thanks for buying!'),
	nl.

defensePotionL :-
	\+ game_state(shopactive), !,
	writeShopIsNotOpenMessage,
	fail.
defensePotionL :-
	current_gold(A),
	price('defense potion L', B),
	A < B,
	writeNotEnoughGold,
	fail.
defensePotionL :-
	game_state(shopactive),
	current_gold(A),
	price('defense potion L', B),
	A >= B,
	retract(current_gold(A)),
	C is A - B,
	assertz(current_gold(C)),
	addToInventory(['defense potion L'|1]),
	inventory_bag(_, D),
	\+ D =:= 100,
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

writeNotShopTile :-
	write('You are not in the shop, use "map" to find the shop!'),
	nl.

writeNotEnoughGold :-
	write('Not enough gold! go clear the quests to get some gold!'),
	nl.

writeShopUsedMessage :-
	write('You have already opened shop'),
	nl.

hehe :-
	write('EHE TE NANDAYO?'),
	nl.

sell :-
	\+ game_state(shopactive), !,
	writeShopIsNotOpenMessage,
	fail.
sell :-
	game_state(shopactive),
	inventory,
	write('Type the item''s name you wish to sell: '),
	read(A),
	write('Type the amount of that item: '),
	read(B),
	handle_sell(A, B).

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

attack_mutate(A, B) :-
	A =< 0,
	B is 1.
attack_mutate(A, B) :-
	A > 0,
	B is A.

calc_status_upgrade(A, B) :-
	B is truncate(A * 1.1000000000000001).

handle_sell(_, A) :-
	A =< 0,
	write('enter the correct amount of item(s) (greater than zero)!'), !.
handle_sell(A, B) :-
	findItemAmount(A, C),
	B > C,
	write('Dont lie! you dont have that much of this item!'), !.
handle_sell(A, B) :-
	price(A, C),
	type(consumable, A),
	D is C // 2,
	E is D * B,
	add_player_gold(E),
	substractFromInventory([A|B]), !,
	write('The item has been successfully sold!'),
	nl.
handle_sell(A, B) :-
	\+ type(consumable, A),
	ultraRareItem(A),
	C is 10000,
	D is C * B,
	add_player_gold(D),
	substractFromInventory([A|B]), !,
	write('The item has been successfully sold!'),
	nl.
handle_sell(A, B) :-
	\+ type(consumable, A),
	rareItem(A),
	C is 5000,
	D is C * B,
	add_player_gold(D),
	substractFromInventory([A|B]), !,
	write('The item has been successfully sold!'),
	nl.
handle_sell(A, B) :-
	!,
	C is 500,
	D is C * B,
	add_player_gold(D),
	substractFromInventory([A|B]), !,
	write('The item has been successfully sold!'),
	nl.

push(A, [], [A]).
push(A, [B|C], [B|D]) :-
	push(A, C, D).

modifyElement([A|B], [[A, C]|D], [[A, E]|D]) :-
	E is C + B.
modifyElement([A|B], [[C, D]|E], [[C, D]|F]) :-
	modifyElement([A|B], E, F).

reduceElement([A|B], [[A, C]|D], [[A, E]|D]) :-
	E is C - B.
reduceElement([A|B], [[C, D]|E], [[C, D]|F]) :-
	reduceElement([A|B], E, F).

getItemAmount(A, [[A, B]|_], B).
getItemAmount(A, [[_, _]|B], C) :-
	getItemAmount(A, B, D),
	C is D.

% file: user_input

player_health_mult(1.0).

player_max_attack(309126805284).

player_max_defense(804).
