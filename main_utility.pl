quit :- 
    game_start,
    write('Progress will not be saved after you quit.'), nl,
    write('Are you sure? (y/n): '),
    read(Param),
    (Param = y -> halt;
    (Param = n -> fail)).

help :-
    game_state(in_battle),!,
    write('You are currently in a battle. Here are some commands to help you get through the battle.'), nl,
    write('Use command \'fight.\' to fight against the encountered enemy.'), nl,
    write('Use command \'run.\' to run away from the enemy. This command might as well not work as it is and you have no choice but to fight the enemy.').

help :-
    game_state(in_quest_dialogue),!,
    write('Please finish your quest dialogue first before continuing.').

help :-
    game_state(shopactive),!,
    write('You are currently in the shop. Here are some commands to get the stuff you needed.').

help :-
    game_state(travelling),!,
    write('You are currently travlling in the outside world! Here are some commands to guide you through this fantasy map.'), nl,
    write('Use command \'w.\' to move upward'), nl,
    write('Use command \'a.\' to move to the left'), nl,
    write('Use command \'s.\' to move downward'), nl,
    write('Use command \'d.\' to move to the right'), nl,
    write('You might encounter an enemy while you\'re travelling, so be ready for them!').

check_inventory :-
    write('You have nothing in your inventory! You can buy some in the shop.').

save:-
    open('a.pl',write,S), set_output(S), listing, close(S).

l:-
    assertz(game_start),!,
    ['a.pl'].