/*

(*) Modified run-length encoding.
Modify the result of problem P10 in such a way that if an element has no 
duplicates it is simply copied into the result list. Only elements with 
duplicates are transferred as [N,E] terms.

Example:
?- encode_modified([a,a,a,a,b,c,c,a,a,d,e,e,e,e],X).
X = [[4,a],b,[2,c],[2,a],d,[4,e]]

*/

encode(L, E) :-
    pack(L, P),
    encode(P, [], E).

encode([], E, E).

encode([H|T], Temp, E) :-
    len(H, L),
    (L =:= 1 ->
        append(H, Temp, NewTemp);
        first_elem(H, C),
        append([[L, C]], Temp, NewTemp)
    ),
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