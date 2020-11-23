/* File : quest.pl */

:- dynamic(quest_active/0).
:- dynamic(slime_counter/1).
:- dynamic(hilichurl_counter/1).
:- dynamic(mage_counter/1).

/* Quest Generator */

quest :-
    game_start,
    map_entity(X, Y, 'P'),
    map_entity(X, Y, 'Q'),
    (\+ quest_active), !,
    retract(game_state(travelling)),
    assertz(game_state(in_quest_dialogue)),
    random(1, 11, SlimeCount),
    random(1, 6, HilichurlCount),
    random(1, 3, MageCount),
    write('Hi there traveler!!!'), nl,
    write('Could you help me out?? I want you to go kill: '), nl,
    write(SlimeCount), write(' slime(s)'), nl,
    write(HilichurlCount), write(' hilichurl(s)'), nl,
    write(MageCount), write(' mage(s)'), nl,
    write('Would you help me?? (yes/no)'), nl,
    assertz(slime_counter(SlimeCount)),
    assertz(hilichurl_counter(HilichurlCount)),
    assertz(mage_counter(MageCount)),
    assertz(quest_active).

quest :- 
    quest_active, !,
    write('You already have a quest!! Go finish it first!!').

quest :-
    !,
    write('You are not in quest node, use \"map\" to find the quest node!!').

yes :- 
    game_state(in_quest_dialogue), 
    (\+ quest_active), !,
    slime_counter(SlimeCount),
    hilichurl_counter(HilichurlCount),
    mage_counter(MageCount),
    assertz(quest_active),
    write('You accepted the quest!!'), nl,
    write('You agreed to go kill: '), nl,
    write(SlimeCount), write(' slime(s)'), nl,
    write(HilichurlCount), write(' hilichurl(s)'), nl,
    write(MageCount), write(' mage(s)'), nl,
    retract(game_state(in_quest_dialogue)),
    assertz(game_state(travelling)).

yes :-
    (\+ game_state(in_quest_dialogue)), !,
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
    (\+ game_state(in_quest_dialogue)), !,
    write('You are not in quest dialogue!!').