:- dynamic(shopactive/0).

shop:-
    \+shopactive,!,
    write('What do you want to buy?'),nl,
    write('1. Gacha (1000 gold)'),nl,
    write('2. Health Potion(100 gold)'),nl.