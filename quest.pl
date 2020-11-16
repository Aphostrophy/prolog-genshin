/* File : quest.pl */

:- dynamic(in_quest_dialogue/0).
:- dynamic(quest_active/0).
:- dynamic(slime_counter/1).
:- dynamic(goblin_counter/1).
:- dynamic(wolf_counter/1).

/* Quest Generator */

quest :-
    asserta(in_quest_dialogue),
    random(1, 11, SlimeCount),
    random(1, 6, GoblinCount),
    random(1, 3, WolfCount),
    write('Hi there traveler!!!'), nl,
    write('Could you help me out?? I want you to go kill: '), nl,
    write(SlimeCount), write(' slime(s)'), nl,
    write(GoblinCount), write(' goblin(s)'), nl,
    write(WolfCount), write(' wolf(s)'), nl,
    write('Would you help me?? (yes/no)'), nl,
    asserta(slime_counter(SlimeCount)),
    asserta(goblin_counter(GoblinCount)),
    asserta(wolf_counter(WolfCount)),
    asserta(quest_active).

yes :- 
    in_quest_dialogue, !,
    slime_counter(SlimeCount),
    goblin_counter(GoblinCount),
    wolf_counter(WolfCount),
    write('You accepted the quest!!'), nl,
    write('You agreed to go kill: '), nl,
    write(SlimeCount), write(' slime(s)'), nl,
    write(GoblinCount), write(' goblin(s)'), nl,
    write(WolfCount), write(' wolf(s)'), nl,
    retract(in_quest_dialogue).

yes :-
    (\+ in_quest_dialogue), !,
    write('You are not in quest dialogue!!').

no :- 
    in_quest_dialogue, !,
    write('You rejected the quest!!'),
    retract(in_quest_dialogue),
    retract(slime_counter(_)),
    retract(goblin_counter(_)),
    retract(wolf_counter(_)).

no :- 
    (\+ in_quest_dialogue), !,
    write('You are not in quest dialogue!!').