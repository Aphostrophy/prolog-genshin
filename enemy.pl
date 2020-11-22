/* File : enemy.pl */
/* Place to store Enemy Facts */

/* ID and Name */
enemy_type(0, slime).
enemy_type(1, hilichurl).
enemy_type(2, mage).
enemy_type(3, mimic).
enemy_type(4, paimon).

/* Enemy Base Stats */
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