path(m(X1, Y1), m(X2, Y2), L, Mymoves)) :-
    permutate(L, P),
    solve(X, Y, P, Mymoves).



count_down(N, C) :-
    Nnew is N - 1,
    count_down(Nnew, N)
