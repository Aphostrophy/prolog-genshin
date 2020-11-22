:- dynamic(player/2).

isStore(X,Y):-
    X =:= 5,
    Y =:= 3.
isBoss(X,Y):-
    X =:= 9,
    Y =:= 9.
isQuest(X,Y):-
    X =:= 2,
    Y =:= 7.

player(1,1).

%MISI NYAMPAH INI CARA BODOH

isPagar(X,Y):-
    X =:= 0,
    Y =:= 0.
isPagar(X,Y):-
    X =:= 1,
    Y =:= 0.
isPagar(X,Y):-
    X =:= 2,
    Y =:= 0.
isPagar(X,Y):-
    X =:= 3,
    Y =:= 0.
isPagar(X,Y):-
    X =:= 4,
    Y =:= 0.
isPagar(X,Y):-
    X =:= 5,
    Y =:= 0.
isPagar(X,Y):-
    X =:= 6,
    Y =:= 0.
isPagar(X,Y):-
    X =:= 7,
    Y =:= 0.
isPagar(X,Y):-
    X =:= 8,
    Y =:= 0.
isPagar(X,Y):-
    X =:= 9,
    Y =:= 0.
isPagar(X,Y):-
    X =:= 10,
    Y =:= 0.
isPagar(X,Y):-
    X =:= 11,
    Y =:= 0.

isPagar(X,Y):-
    X =:= 0,
    Y =:= 11.
isPagar(X,Y):-
    X =:= 1,
    Y =:= 11.
isPagar(X,Y):-
    X =:= 2,
    Y =:= 11.
isPagar(X,Y):-
    X =:= 3,
    Y =:= 11.
isPagar(X,Y):-
    X =:= 4,
    Y =:= 11.
isPagar(X,Y):-
    X =:= 5,
    Y =:= 11.
isPagar(X,Y):-
    X =:= 6,
    Y =:= 11.
isPagar(X,Y):-
    X =:= 7,
    Y =:= 11.
isPagar(X,Y):-
    X =:= 8,
    Y =:= 11.
isPagar(X,Y):-
    X =:= 9,
    Y =:= 11.
isPagar(X,Y):-
    X =:= 10,
    Y =:= 11.
isPagar(X,Y):-
    X =:= 11,
    Y =:= 11.

isPagar(X,Y):-
    X =:= 0,
    Y =:= 1.
isPagar(X,Y):-
    X =:= 0,
    Y =:= 2.
isPagar(X,Y):-
    X =:= 0,
    Y =:= 3.
isPagar(X,Y):-
    X =:= 0,
    Y =:= 4.
isPagar(X,Y):-
    X =:= 0,
    Y =:= 5.
isPagar(X,Y):-
    X =:= 0,
    Y =:= 6.
isPagar(X,Y):-
    X =:= 0,
    Y =:= 7.
isPagar(X,Y):-
    X =:= 0,
    Y =:= 8.
isPagar(X,Y):-
    X =:= 0,
    Y =:= 9.
isPagar(X,Y):-
    X =:= 0,
    Y =:= 10.

isPagar(X,Y):-
    X =:= 11,
    Y =:= 1.
isPagar(X,Y):-
    X =:= 11,
    Y =:= 2.
isPagar(X,Y):-
    X =:= 11,
    Y =:= 3.
isPagar(X,Y):-
    X =:= 11,
    Y =:= 4.
isPagar(X,Y):-
    X =:= 11,
    Y =:= 5.
isPagar(X,Y):-
    X =:= 11,
    Y =:= 6.
isPagar(X,Y):-
    X =:= 11,
    Y =:= 7.
isPagar(X,Y):-
    X =:= 11,
    Y =:= 8.
isPagar(X,Y):-
    X =:= 11,
    Y =:= 9.
isPagar(X,Y):-
    X =:= 11,
    Y =:= 10.

isPagar(X,Y):-
    X =:= 4,
    Y =:= 7.
isPagar(X,Y):-
    X =:= 4,
    Y =:= 8.
isPagar(X,Y):-
    X =:= 5,
    Y =:= 8.
isPagar(X,Y):-
    X =:= 6,
    Y =:= 8.

isPagar(X,Y):-
    X =:= 9,
    Y =:= 2.
isPagar(X,Y):-
    X =:= 8,
    Y =:= 2.
isPagar(X,Y):-
    X =:= 7,
    Y =:= 2.
isPagar(X,Y):-
    X =:= 8,
    Y =:= 3.
isPagar(X,Y):-
    X =:= 8,
    Y =:= 4.


% NYAMPAH SELESAI

draw_map(X,Y):-
    X < 12,
    Y < 12,
    \+(player(X,Y)),
    \+(isPagar(X,Y)),
    \+(isStore(X,Y)),
    \+(isBoss(X,Y)),
    \+(isQuest(X,Y)),
    write('- '),
    Y2 is Y+1,
    draw_map(X,Y2).

draw_map(X,12):-
    write('\n'),
    Y2 is 0,
    X2 is X+1,
    draw_map(X2,Y2).

draw_map(X,Y):-
    isStore(X,Y),
    write('S '),
    Y2 is Y+1,
    draw_map(X,Y2).

draw_map(X,Y):-
    isBoss(X,Y),
    write('B '),
    Y2 is Y+1,
    draw_map(X,Y2).

draw_map(X,Y):-
    isQuest(X,Y),
    write('Q '),
    Y2 is Y+1,
    draw_map(X,Y2).

draw_map(X,Y):-
    player(X,Y),
    write('P '),
    Y2 is Y+1,
    draw_map(X,Y2).

draw_map(X,Y):-
    isPagar(X,Y),
    write('# '),
    Y2 is Y+1,
    draw_map(X,Y2).

isNabrak(X,Y) :-
    isBoss(X,Y).
isNabrak(X,Y) :-
    isPagar(X,Y).
isNabrak(X,Y) :-
    isStore(X,Y).
isNabrak(X,Y) :-
    isQuest(X,Y).


w :-
    player(X,Y),
    X2 is X-1,
    \+(isNabrak(X2,Y)),
    retractall(player(X,Y)),
    assertz(player(X2,Y)),
    write('you moved to the north').

w :-
    player(X,Y),
    X2 is X-1,
    isPagar(X2,Y),
    write('ouch, you hitted the wall'), !.

s :-
    player(X,Y),
    X2 is X+1,
    \+(isNabrak(X2,Y)),
    retractall(player(X,Y)),
    assertz(player(X2,Y)),
    write('you moved to the south').
s :-
    player(X,Y),
    X2 is X+1,
    isPagar(X2,Y),
    write('ouch, you hitted the wall'), !.

a :-
    player(X,Y),
    Y2 is Y-1,
    \+(isNabrak(X,Y2)),
    retractall(player(X,Y)),
    assertz(player(X,Y2)),
    write('you moved to the west').
a :-
    player(X,Y),
    Y2 is Y-1,
    isPagar(X,Y2),
    write('ouch, you hitted the wall').

d :-
    player(X,Y),
    Y2 is Y+1,
    \+(isNabrak(X,Y2)),
    retractall(player(X,Y)),
    assertz(player(X,Y2)),
    write('you moved to the east').
d :-
    player(X,Y),
    Y2 is Y+1,
    isPagar(X,Y2),
    write('ouch, you hitted the wall').








