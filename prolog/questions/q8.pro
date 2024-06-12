/*

(**) Eliminate consecutive duplicates of list elements.
If a list contains repeated elements they should be replaced with a single copy of the element. The order of the elements should not be changed.

Example:
?- compress([a,a,a,a,b,c,c,a,a,d,e,e,e,e],X).
X = [a,b,c,a,d,e]

*/

compress(L, X) :-
    compress(L, [], X).

compress([], X, X).

compress([H|T], S, X) :-
    \+ member(H, S),
    append(S, [H], Snew),
    compress(T, Snew, X).

compress([_|T], S, X) :-
    compress(T, S, X).