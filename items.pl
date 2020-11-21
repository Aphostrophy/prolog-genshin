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
property('health potion', 75).
property('panas spesial 2 mekdi', 150).
property('sadikin', 225).
property('go milk', 320).
property('crisbar', 450).

/* Properti buat claymore, bow, catalyst. Attack nambah sebesar Arrity kedua */
property('waster greatsword', 30).
property('old merc pal', 70).
property('debate club', 120).
property('prototype aminus', 180).
property('wolf greatsword', 250).

property('hunter bow', 40).
property('seasoned hunter bow', 90).
property('messenger', 150).
property('favonius warbow', 230).
property('skyward harp', 300).

property('apprentice notes', 50).
property('pocket grimoire', 110).
property('emerald orb', 175).
property('mappa mare', 320).
property('skyward atlas', 410).

/* Properti buat armor. Defense nambah sebesar Arrity kedua */
property('wooden armor', 50).
property('iron armor', 120).
property('steel aromor', 200).
property('golden armor', 290).
property('diamond armor', 400).