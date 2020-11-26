% pagar

:- dynamic(isPagar/2).
isPagar(4, 7).
isPagar(4, 8).
isPagar(5, 8).
isPagar(6, 8).
isPagar(9, 2).
isPagar(8, 2).
isPagar(7, 2).
isPagar(8, 3).
isPagar(8, 4).
isPagar(13, 9).
isPagar(13, 10).
isPagar(13, 11).
isPagar(13, 12).
isPagar(12, 12).
isPagar(11, 12).
isPagar(10, 12).

setBorder :- 
    forall(between(0,16,X), assertz(isPagar(X,0))),
    forall(between(0,16,X), assertz(isPagar(X,16))),
    forall(between(0,16,Y), assertz(isPagar(0,Y))),
    forall(between(0,16,Y), assertz(isPagar(16,Y))).

/* Buat ngebuat map */
draw_map(X,Y) :-
    Y =:= 17,
    retract(draw_done(_)),
    asserta(draw_done(true)).

draw_map(X,Y) :-
    draw_done(false),
    X =:= 17, nl,
    Y =< 16,
    Y2 is Y+1,
    draw_map(0,Y2).

draw_map(X,Y):-
    draw_done(false),
    X =< 16,
    X >= 0,
    Y =< 16,
    Y >= 0,
    isPagar(X,Y), !,
    write('# '),
    X2 is X+1,
    draw_map(X2,Y).

draw_map(X,Y):-
    draw_done(false),
    X =< 15,
    X > 0,
    Y =< 15,
    Y > 0,
    map_entity(X,Y,_),
    draw_entity(X,Y),
    X2 is X+1,
    draw_map(X2,Y).

draw_map(X,Y):-
    draw_done(false),
    X =< 15,
    X > 0,
    Y =< 15,
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
    game_state(travelling),
    map_entity(X, Y, 'P'),
    Y2 is Y-1,
    (\+ isPagar(X, Y2)), !,
    retract(map_entity(X, Y, 'P')),
    assertz(map_entity(X, Y2,'P')),
    chest_encounter,!.

w :-
    (\+game_start), !,
    write('Game is not started, use \"start.\" to play the game.').

w :-
    game_state(in_battle), !,
    write('You are in battle!! Use \"help.\" to display the commands that you can use.').

w :-
    \+game_state(travelling),!,
    write('Cannot travel now').

w :-
    game_state(shopactive),!,
    write('Exit the shop first!'),nl.

w :-
    write('Ouch, you hit a wall. Use \"map.\" to open the map!!').


a :-
    game_start,
    (\+ game_state(in_battle)),game_state(travelling),
    map_entity(X, Y, 'P'),
    X2 is X-1,
    (\+isPagar(X2, Y)), !,
    retract(map_entity(X, Y, 'P')),
    assertz(map_entity(X2, Y,'P')),
    chest_encounter,!.

a :-
    (\+game_start), !,
    write('Game is not started, use \"start.\" to play the game.').

a :-
    game_state(in_battle), !,
    write('You are in battle!! Use \"help.\" to display the commands that you can use.').

a :-
    game_state(shopactive),!,
    write('Exit the shop first!'),nl.

a :-
    \+game_state(travelling),!,
    write('Cannot travel now').

a :-
    write('Ouch, you hit a wall. Use \"map.\" to open the map!!').
    
s :-
    game_start,
    game_state(travelling),
    map_entity(X, Y, 'P'),
    Y2 is Y+1,
    (\+isPagar(X, Y2)), 
    (\+map_entity(X,Y2,'B')), !,
    retract(map_entity(X, Y, 'P')),
    assertz(map_entity(X, Y2,'P')),
    chest_encounter,!.

s :-
    game_start,
    game_state(travelling),
    map_entity(X, Y, 'P'),
    Y2 is Y+1,
    (\+isPagar(X, Y2)),
    map_entity(X,Y2,'B'), !, 
    trigger_boss.

s :-
    (\+game_start),!,
    write('Game is not started, use \"start.\" to play the game.').

s :-
    game_state(in_battle),!,
    write('You are in battle!! Use \"help.\" to display the commands that you can use.').

s :-
    game_state(shopactive),!,
    write('Exit the shop first!'),nl.

s :-
    \+game_state(travelling),!,
    write('Cannot travel now').

s :-
    write('Ouch, you hit a wall. Use \"map.\" to open the map!!').


d :-
    game_start,
    game_state(travelling),
    map_entity(X, Y, 'P'),
    X2 is X+1,
    (\+isPagar(X2, Y)),
    (\+map_entity(X2, Y, 'B')), !,
    retract(map_entity(X, Y, 'P')),
    assertz(map_entity(X2, Y,'P')),
    chest_encounter,!.

d :-
    game_start,
    game_state(travelling),
    map_entity(X, Y, 'P'),
    X2 is X+1,
    (\+isPagar(X2,Y)), !,
    map_entity(X2,Y,'B'), !,
    trigger_boss,!.

d :-
    (\+game_start), !,
    write('Game is not started, use \"start.\" to play the game.').

d :-
    game_state(in_battle), !,
    write('You are in battle!! Use \"help.\" to display the commands that you can use.').

d:-
    game_state(shopactive),!,
    write('Exit the shop first!'),nl.
    
d :-
    \+game_state(travelling),!,
    write('Cannot travel now').

d :-
    write('Ouch, you hit a wall. Use \"map.\" to open the map!!').


map :-
    retract(draw_done(_)),
    asserta(draw_done(false)),
    draw_map(0,0), !.

teleport :- 
    game_start,
    game_state(travelling),
    map_entity(X,Y,'P'),
    (\+map_entity(X,Y,'T')), !,
    write('You\'re not on teleport point!!'), nl,
    write('Use \"map.\" to open the map!!').

teleport :-
    game_start,
    map_entity(X, Y, 'P'),
    map_entity(X, Y, 'T'), 
    game_state(travelling), !,
    map, write('Where do you want to teleport??'), nl,
    write('Input the X coordinate : '), read(X2),
    write('Input the Y coordinate : '), read(Y2),
    execute_teleport(X2,Y2).
    
execute_teleport(X,Y) :-
    map_entity(X,Y,'T'), !,
    map_entity(OldX,OldY,'P'),
    write('You teleported to '), write(X), write(','), write(Y), nl,
    retract(map_entity(OldX,OldY,'P')),
    assertz(map_entity(X,Y,'P')).

execute_teleport(X,Y) :-
    (\+map_entity(X,Y,'T')), !,
    write('Invalid Location!!').