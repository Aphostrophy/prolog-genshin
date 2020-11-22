/* FILE items.pl */
/* Storing items and its details */

/* FACTS */

item('health potion').
item('panas spesial 2 mekdi').
item('sadikin').
item('go milk').
item('crisbar').
item('waster greatsword').
item('debate club').
item('prototype aminus').
item('wolf greatsword').
item('hunter bow').
item('seasoned hunter bow').
item('messenger').
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
type(consumable, 'sadikin').
type(consumable, 'go milk').
ttype(consumable, 'crisbar').
type(claymore, 'waster greatsword').
type(claymore, 'old merc pal').
type(claymore, 'debate club').
type(claymore, 'prototype aminus').
type(claymore, 'wolf greatsword').
type(bow,'hunter bow').
type(bow,'seasoned hunter bow').
type(bow,'messenger').
type(bow,'favonius warbow').
type(bow,'skyward harp').
type(catalyst,'apprentice notes').
type(catalyst,'pocket grimoire').
type(catalyst,'emerald orb').
type(catalyst,'mappa mare').
type(catalyst,'skyward atlas').
type(armor,'wooden armor').
type(armor,'iron armor').
type(armor,'steel armor').
type(armor,'golden armor').
type(armor,'diamond armor').

/* Properti buat consumable. Health nambah sebesar Arrity kedua */
property('health potion', Health) :- Health is 75.
property('panas spesial 2 mekdi', Health) :- Health is 150.
property('sadikin', Health) :- Health is 250.
property('go milk', Health) :- Health is 320.
property('crisbar', Health) :- Health is 450.

/* Properti buat claymore, bow, catalyst. Attack nambah sebesar Arrity kedua */
property('waster greatsword', Attack) :- Attack is 30.
property('old merc pal', Attack) :- Attack is 70.
property('debate club', Attack) :- Attack is 120.
property('prototype aminus', Attack) :- Attack is 180.
property('wolf greatsword', Attack) :- Attack is 250.

property('hunter bow', Attack) :- Attack is 40.
property('seasoned hunter bow', Attack) :- Attack is 90.
property('messenger', Attack) :- Attack is 150.
property('favonius warbow', Attack) :- Attack is 230.
property('skyward harp', Attack) :- Attack is 300.

property('apprentice notes', Attack) :- Attack is 50.
property('pocket grimoire', Attack) :- Attack is 110.
property('emerald orb', Attack) :- Attack is 175.
property('mappa mare', Attack) :- Attack is 320.
property('skyward atlas', Attack) :- Attack is 410.

/* Properti buat armor. Defense dan Health nambah sebesar Arrity kedua dan ketiga */
property('wooden armor', Defense, Health) :-
    Defense is 50,
    Health is 20.
property('iron armor', Defense, Health) :-
    Defense is 120,
    Health is 60.
property('steel armor', Defense, Health) :-
    Defense is 200,
    Health is 100.
property('golden armor', Defense, Health) :-
    Defense is 290,
    Health is 150.
property('diamond armor', Defense, Health) :-
    Defense is 400,
    Health is 200.