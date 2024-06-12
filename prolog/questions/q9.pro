/*

(**) Pack consecutive duplicates of list elements into sublists.
If a list contains repeated elements they should be placed in separate sublists.

Example:
?- pack([a,a,a,a,b,c,c,a,a,d,e,e,e,e],X).
X = [[a,a,a,a],[b],[c,c],[a,a],[d],[e,e,e,e]]

*/

pack(L, X) :- pack(L, [], [], X).

pack([], [], X, X).

pack([H|T], [], L, X) :-
    pack(T, [H], L, X).

pack([H|T1], [H|T2], L, X) :-
    append([H], [H|T2], Snew),
    pack(T1, Snew, L, X).

pack(I, S, L, X) :-
    append([S], L, Lnew),
    pack(I, [], Lnew, X).
