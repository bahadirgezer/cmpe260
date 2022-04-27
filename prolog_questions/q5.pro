/*

(*) Reverse a list.

*/

rev(L, R) :-
    my_rev(L, [], R).

my_rev([], R, O) :-
    O = R.

my_rev([H|T], R, O) :-
    append([H], R, Rnew),
    my_rev(T, Rnew, O).

append([], X, X).
append([X | Y], Z, [X | W]) :- append( Y, Z, W).

