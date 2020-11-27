/* FILE player.pl */
/* Storing player datas */

/* Dependency Files : items.pl */

choose_class :-
    write('================================================================================================================================================'),nl,
    write('                                        |                     Choose your job!                     |                                            '), nl,
    write('                                        |                        1. Knight                         |                                            '), nl,
    write('                                        |                        2. Archer                         |                                            '), nl,
    write('                                        |                        3. Mage                           |                                            '), nl,
    write('================================================================================================================================================'),nl,
    write('|                                        Type the job you want to choose followed with a periodt.                                              |'),nl,
    write('|                                           For example: \'Knight\'.  or \'Archer.\'. or \'Mage\'.                                                   |'),nl,
    write('|                                    Make sure to include the apostrophe! Then, press return or enter.                                         |'),nl,
    write('================================================================================================================================================'),nl,
    read(X),nl,
    assert_class(X),
    write('================================================================================================================================================'),nl,
    write('|                      The game has been started. Use \'help.\' to look for available commands! Here are some of them.                           |'),nl,
    write('================================================================================================================================================'),nl,
    write('|        Commmand        |                                                           Function                                                  |'),nl,
    write('|------------------------|---------------------------------------------------------------------------------------------------------------------|'),nl,
    write('|       \'start.\'         |     Restart the game.                                                                                               |'),nl,
    write('|        \'quit.\'         |     Exit the game.                                                                                                  |'),nl,
    write('|      \'inventory.\'      |     List all the items in your inventory.                                                                           |'),nl,
    write('================================================================================================================================================'),nl,
    initialize_resources.

status :-
    player_class(X),player_level(Y),player_health(Health),player_attack(Attack),player_defense(Defense),
    player_max_health(MaxHealth),
    equipped_weapon(Weapon),equipped_cover(Armor),
    player_attack_mult(MultAttack),player_defense_mult(MultDefense),
    TotalAttack is truncate(Attack * MultAttack),
    TotalDefense is truncate(Defense * MultDefense),
    current_gold(Gold),current_exp(Exp),exp_level_up(Y,MaxExp),
    write('==============================================='),nl,
    write('             S   T   A   T   U   S             '),nl,
    write('==============================================='),nl,
    write('Job      : '),write(X),nl,
    write('Level    : '),write(Y),nl,
    write('Health   : '),write(Health),write('/'),write(MaxHealth),nl,
    write('Attack   : '),write(TotalAttack),nl,
    write('Defense  : '),write(TotalDefense),nl,
    write('Gold     : '),write(Gold),nl,
    write('Exp      : '),write(Exp),write('/'),write(MaxExp),nl,
    write('==============================================='),nl.

exp_level_up(Level,Exp):-
    Exp is 300*Level.

assert_class('Knight'):-
    assertz(player_class('knight')),
    player_class(X),assertz(player_level(1)),baseHealth(X,BaseHealth),baseAttack(X,BaseAttack),baseDefense(X,BaseDefense),
    assertz(player_health(BaseHealth)),assertz(player_attack(BaseAttack)),assertz(player_defense(BaseDefense)),
    assertz(player_max_health(BaseHealth)),assertz(player_max_attack(BaseAttack)),assertz(player_max_defense(BaseDefense)),
    baseWeapon(X,BaseWeapon),assertz(equipped_weapon(BaseWeapon)),assertz(equipped_cover('wooden armor')),
    assertz(player_health_mult(1.0)),assertz(player_attack_mult(1.0)),assertz(player_defense_mult(1.0)),
    write('================================================================================================================================================'),nl,
    write('                                               |You choose '), write(X), write(', let’s explore the world!|'),nl,!.

assert_class('Archer'):-
    assertz(player_class('archer')),
    player_class(X),assertz(player_level(1)),baseHealth(X,BaseHealth),baseAttack(X,BaseAttack),baseDefense(X,BaseDefense),
    assertz(player_health(BaseHealth)),assertz(player_attack(BaseAttack)),assertz(player_defense(BaseDefense)),
    assertz(player_max_health(BaseHealth)),assertz(player_max_attack(BaseAttack)),assertz(player_max_defense(BaseDefense)),
    baseWeapon(X,BaseWeapon),assertz(equipped_weapon(BaseWeapon)),assertz(equipped_cover('wooden armor')),
    assertz(player_health_mult(1.0)),assertz(player_attack_mult(1.0)),assertz(player_defense_mult(1.0)),
    write('================================================================================================================================================'),nl,
    write('                                               |You choose '), write(X), write(', let’s explore the world!|'),nl,!.

assert_class('Mage'):-
    assertz(player_class('mage')),
    player_class(X),assertz(player_level(1)),baseHealth(X,BaseHealth),baseAttack(X,BaseAttack),baseDefense(X,BaseDefense),
    assertz(player_health(BaseHealth)),assertz(player_attack(BaseAttack)),assertz(player_defense(BaseDefense)),
    assertz(player_max_health(BaseHealth)),assertz(player_max_attack(BaseAttack)),assertz(player_max_defense(BaseDefense)),
    baseWeapon(X,BaseWeapon),assertz(equipped_weapon(BaseWeapon)),assertz(equipped_cover('wooden armor')),
    assertz(player_health_mult(1.0)),assertz(player_attack_mult(1.0)),assertz(player_defense_mult(1.0)),
    write('================================================================================================================================================'),nl,
    write('                                               |You choose '), write(X), write(', let’s explore the world!|'),nl,!.

initialize_resources:-
    assertz(current_gold(1000)),
    assertz(current_exp(0)),
    assertz(inventory_bag([['health potion',10],['attack potion S',5]],15)).

add_player_exp(ObtainedExp) :-
    current_exp(CurrentExp),
    Result is CurrentExp + ObtainedExp,
    retract(current_exp(CurrentExp)),
    assertz(current_exp(Result)),
    player_level(X1),
    exp_level_up(X1,LevelExp),
    upgrade_player_level(X1,Result,LevelExp),
    write('You can now check your updated current Exp and Gold with \'status\' command!'),nl.

upgrade_player_level(X,Y,Z) :-
    Y < Z, !,
    RemainingExp is Z - Y,
    write('You now have '), write(Y), write(' Exp'), nl,
    write('You need '), write(RemainingExp), write(' Exp to get upgraded to the next level. Keep exploring the game!'),nl.

upgrade_player_level(X,Y,Z) :-
    Y >= Z,
    UpgradedLevel is X + 1,
    UpgradedExp is Y - Z,
    retract(player_level(X)), assertz(player_level(UpgradedLevel)),
    retract(current_exp(Y)), assertz(current_exp(UpgradedExp)),
    exp_level_up(UpgradedLevel,NewLevelExp),
    RemainingExp is NewLevelExp - UpgradedExp,
    upgrade_player_status,
    write('Your character has been upgraded to level '), write(UpgradedLevel), write('!'), nl,
    write('You now have '), write(UpgradedExp), write(' Exp'), nl,
    write('You need '), write(RemainingExp), write(' Exp to get upgraded to the next level. Keep exploring the game!'),nl.

upgrade_player_status :-
    player_max_attack(X), player_max_defense(Y), player_max_health(Z),
    player_attack(X1), player_defense(Y1), player_health(Z1),
    calc_status_upgrade(X,UpgradedAttack),
    retract(player_max_attack(X)), assertz(player_max_attack(UpgradedAttack)),
    retract(player_attack(X1)), assertz(player_attack(UpgradedAttack)),
    calc_status_upgrade(Y,UpgradedDefense),
    retract(player_max_defense(Y)), assertz(player_max_defense(UpgradedDefense)),
    retract(player_defense(Y1)), assertz(player_defense(UpgradedDefense)),
    calc_status_upgrade(Z,UpgradedHealth),
    retract(player_max_health(Z)), assertz(player_max_health(UpgradedHealth)),
    retract(player_health(Z1)), assertz(player_health(UpgradedHealth)).

add_player_gold(ObtainedGold) :-
    current_gold(X),
    AddedGold is X + ObtainedGold,
    retract(current_gold(X)), assertz(current_gold(AddedGold)),
    write('You obtained '), write(ObtainedGold),write(' Gold! The gold is now kept in your pocket!'),nl.