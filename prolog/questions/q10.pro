/*

(*) Run-length encoding of a list.
Use the result of problem P09 to implement the so-called run-length encoding 
data compression method. Consecutive duplicates of elements are encoded as 
terms [N,E] where N is the number of duplicates of the element E.

Example:
?- encode([a,a,a,a,b,c,c,a,a,d,e,e,e,e],X).
X = [[4,a],[1,b],[2,c],[2,a],[1,d][4,e]]

*/

encode(L, E) :-
    pack(L, P),
    encode(P, [], E).

encode([], E, E).

encode([H|T], Temp, E) :-
    len(H, L),
    first_elem(H, C),
    append([[L, C]], Temp, NewTemp),
    encode(T, NewTemp, E).

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


first_elem([H|_], H).

len([] , 0).

len([_|T], N)  :-
    len( T , Nnew),
    N is Nnew + 1.
