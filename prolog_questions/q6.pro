/*

(*) Find out whether a list is a palindrome.
A palindrome can be read forward or backward; e.g. [x,a,m,a,x].

*/

is_palindrome(L):-
    rev(L,L).

rev(L, R) :-
    my_rev(L, [], R).

my_rev([], R, O) :-
    O = R.

my_rev([H|T], R, O) :-
    append([H], R, Rnew),
    my_rev(T, Rnew, O).

append([], X, X).
append([X | Y], Z, [X | W]) :- append( Y, Z, W).

