:- dynamic(map_entity/3).
:- dynamic(isPagar/2).
:- dynamic(draw_done/1).

% pagar
isPagar(4, 7).
isPagar(4, 8).
isPagar(5, 8).
isPagar(6, 8).
isPagar(9, 2).
isPagar(8, 2).
isPagar(7, 2).
isPagar(8, 3).
isPagar(8, 4).

setBorder(X,Y) :-
    X =< 10,
    X > 0,
    Y =< 10,
    Y > 0,
    X2 is X+1,
    setBorder(X2,Y).

setBorder(X,Y) :-
    Y =:= 0,
    X =< 10,
    assertz(isPagar(X,Y)),
    X2 is X+1,
    setBorder(X2,Y).

setBorder(X,Y) :-
    X =:= 0,
    Y =< 11,
    assertz(isPagar(X,Y)),
    X2 is X+1,
    setBorder(X2,Y).

setBorder(X,Y) :-
    X =:= 11,
    Y =< 11,
    assertz(isPagar(X,Y)),
    Y2 is Y+1,
    setBorder(0,Y2).

setBorder(X,Y) :-
    Y =:= 11,
    X =< 11,
    assertz(isPagar(X,Y)),
    X2 is X+1,
    setBorder(X2,Y).

/* Buat ngebuat map */
draw_map(X,Y) :-
    Y =:= 12,
    retract(draw_done(_)),
    asserta(draw_done(true)).

draw_map(X,Y) :-
    draw_done(false),
    X =:= 12, nl,
    Y =< 11,
    Y2 is Y+1,
    draw_map(0,Y2).

draw_map(X,Y):-
    draw_done(false),
    X =< 11,
    X >= 0,
    Y =< 11,
    Y >= 0,
    isPagar(X,Y), !,
    write('# '),
    X2 is X+1,
    draw_map(X2,Y).

draw_map(X,Y):-
    draw_done(false),
    X =< 10,
    X > 0,
    Y =< 10,
    Y > 0,
    map_entity(X,Y,_),
    draw_entity(X,Y),
    X2 is X+1,
    draw_map(X2,Y).

draw_map(X,Y):-
    draw_done(false),
    X =< 10,
    X > 0,
    Y =< 10,
    Y > 0,
    (\+isPagar(X,Y)), !,
    write('- '),
    X2 is X+1,
    draw_map(X2,Y).

draw_entity(X,Y) :-
    map_entity(X,Y,'P'), 
    map_entity(X,Y,_), !,
    write('P ').

draw_entity(X,Y) :-
    map_entity(X,Y,Entity), !,
    write(Entity), write(' ').

w :-
    game_start,
    (\+ game_state(in_battle)),
    map_entity(X, Y, 'P'),
    Y2 is Y-1,
    (\+ isPagar(X, Y2)), !,
    retract(map_entity(X, Y, 'P')),
    assertz(map_entity(X, Y2,'P')),
    chest_encounter.

w :-
    (\+game_start), !,
    write('Game is not started, use \"start.\" to play the game.').

w :-
    game_state(in_battle), !,
    write('You are in battle!! Use \"help.\" to display the commands that you can use.').

w :-
    write('Ouch, you hitted a wall. Use \"map.\" to open the map!!').

a :-
    game_start,
    (\+ game_state(in_battle)),
    map_entity(X, Y, 'P'),
    X2 is X-1,
    (\+isPagar(X2, Y)), !,
    retract(map_entity(X, Y, 'P')),
    assertz(map_entity(X2, Y,'P')),
    chest_encounter.

a :-
    (\+game_start), !,
    write('Game is not started, use \"start.\" to play the game.').

a :-
    game_state(in_battle), !,
    write('You are in battle!! Use \"help.\" to display the commands that you can use.').

a :-
    write('Ouch, you hitted a wall. Use \"map.\" to open the map!!').

s :-
    game_start,
    (\+ game_state(in_battle)),
    map_entity(X, Y, 'P'),
    Y2 is Y+1,
    (\+isPagar(X, Y2)), 
    (\+map_entity(X,Y2,'B')), !,
    retract(map_entity(X, Y, 'P')),
    assertz(map_entity(X, Y2,'P')),
    chest_encounter.

s :-
    game_start,
    (\+ game_state(in_battle)),
    map_entity(X, Y, 'P'),
    Y2 is Y+1,
    (\+isPagar(X, Y2)), !,
    map_entity(X,Y2,'B'), !, 
    trigger_boss.

s :-
    (\+game_start), !,
    write('Game is not started, use \"start.\" to play the game.').

s :-
    game_state(in_battle), !,
    write('You are in battle!! Use \"help.\" to display the commands that you can use.').

s :-
    write('Ouch, you hitted a wall. Use \"map.\" to open the map!!').

d :-
    game_start,
    (\+ game_state(in_battle)),
    map_entity(X, Y, 'P'),
    X2 is X+1,
    (\+isPagar(X2, Y)),
    (\+map_entity(X2, Y, 'B')), !,
    retract(map_entity(X, Y, 'P')),
    assertz(map_entity(X2, Y,'P')),
    chest_encounter.

d :-
    game_start,
    (\+ game_state(in_battle)),
    map_entity(X, Y, 'P'),
    X2 is X+1,
    (\+isPagar(X2,Y)), !,
    map_entity(X2,Y,'B'), !,
    trigger_boss.

d :-
    (\+game_start), !,
    write('Game is not started, use \"start.\" to play the game.').

d :-
    game_state(in_battle), !,
    write('You are in battle!! Use \"help.\" to display the commands that you can use.').

d :-
    write('Ouch, you hitted a wall. Use \"map.\" to open the map!!').

map :-
    retract(draw_done(_)),
    asserta(draw_done(false)),
    draw_map(0,0), !.