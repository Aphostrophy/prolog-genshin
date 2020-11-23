:- dynamic(map_entity/3).

% pagar
map_entity(4, 7, '#').
map_entity(4, 8, '#').
map_entity(5, 8, '#').
map_entity(6, 8, '#').
map_entity(9, 2, '#').
map_entity(8, 2, '#').
map_entity(7, 2, '#').
map_entity(8, 3, '#').
map_entity(8, 4, '#').

/* Buat ngebuat map */
% Top border
draw_map(X,Y):-
    X =< 10,
    X > 0,
    Y =:= 0,
    write('# '),
    X2 is X+1,
    draw_map(X2,Y).

% Right border
draw_map(X,Y):-
    X =:= 11,
    Y =< 11,
    write('# '), nl,
    Y2 is Y+1,
    draw_map(0, Y2).

% Bottom border
draw_map(X,Y):-
    X =< 10,
    X > 0,
    Y =:= 11,
    write('# '),
    X2 is X+1,
    draw_map(X2, Y).

% Left border
draw_map(X,Y):-
    X =:= 0,
    Y =< 11,
    write('# '),
    X2 is X+1,
    draw_map(X2, Y).

% Inside Map
draw_map(X,Y):-
    X =< 10,
    X > 0,
    Y =< 10,
    Y > 0,
    map_entity(X, Y, Entity), !,
    write(Entity), write(' '),
    X2 is X+1,
    draw_map(X2,Y).

draw_map(X,Y):-
    X =< 10,
    X > 0,
    Y =< 10,
    Y > 0,
    (\+map_entity(X, Y, _)),
    write('- '),
    X2 is X+1,
    draw_map(X2,Y).

w :-
    game_start,
    (\+ in_battle),
    map_entity(X, Y, 'P'),
    Y2 is Y-1,
    (\+ map_entity(X, Y2, '#')),
    Y2 > 0, Y2 =< 10, !,
    retract(map_entity(X, Y, 'P')),
    assertz(map_entity(X, Y2,'P')),
    chest_encounter.

w :-
    (\+game_start), !,
    write('Game is not started, use \"start.\" to play the game.').

w :-
    in_battle, !,
    write('You are in battle!! Use \"help.\" top display the commands that you can use.').

w :-
    write('Ouch, you hitted a wall. Use \"map.\" to open the map!!').

a :-
    game_start,
    (\+ in_battle),
    map_entity(X, Y, 'P'),
    X2 is X-1,
    (\+ map_entity(X2, Y, '#')),
    X2 > 0, X2 =< 10, !,
    retract(map_entity(X, Y, 'P')),
    assertz(map_entity(X2, Y,'P')),
    chest_encounter.

a :-
    (\+game_start), !,
    write('Game is not started, use \"start.\" to play the game.').

a :-
    in_battle, !,
    write('You are in battle!! Use \"help.\" top display the commands that you can use.').

a :-
    write('Ouch, you hitted a wall. Use \"map.\" to open the map!!').

s :-
    game_start,
    (\+ in_battle),
    map_entity(X, Y, 'P'),
    Y2 is Y+1,
    (\+ map_entity(X, Y2, '#')),
    Y2 > 0, Y2 =< 10, !,
    retract(map_entity(X, Y, 'P')),
    assertz(map_entity(X, Y2,'P')),
    chest_encounter.

s :-
    (\+game_start), !,
    write('Game is not started, use \"start.\" to play the game.').

s :-
    in_battle, !,
    write('You are in battle!! Use \"help.\" top display the commands that you can use.').

s :-
    write('Ouch, you hitted a wall. Use \"map.\" to open the map!!').

d :-
    game_start,
    (\+ in_battle),
    map_entity(X, Y, 'P'),
    X2 is X+1,
    (\+ map_entity(X2, Y, '#')),
    X2 > 0, X2 =< 10, !,
    retract(map_entity(X, Y, 'P')),
    assertz(map_entity(X2, Y,'P')),
    chest_encounter.

d :-
    (\+game_start), !,
    write('Game is not started, use \"start.\" to play the game.').

d :-
    in_battle, !,
    write('You are in battle!! Use \"help.\" top display the commands that you can use.').

d :-
    write('Ouch, you hitted a wall. Use \"map.\" to open the map!!').

map :- draw_map(0,0).