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