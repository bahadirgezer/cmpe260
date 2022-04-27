/*

(*) Find the last element of a list.
Example:
?- my_last(X,[a,b,c,d]).
X = d

*/

my_last([H|T], X) :-
    is_empty(T),
    X = H.

my_last([_|T], X) :-
    my_last(T, X).

is_empty([]).