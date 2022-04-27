/*

(**) Determine whether a given integer number is prime.

*/

is_prime(X) :-
    X > 1, 
    is_prime(X, 2).

is_prime(1, D) :- 
    !, fail.

is_prime(X, D) :-
    X < D * D, !.

is_prime(X, D) :-
    X mod D =\= 0,
    D1 is D + 1,
    is_prime(X, D1).
