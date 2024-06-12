/*

(*) Find the last but one element of a list.
(zweitletztes Element, l'avant-dernier élément)

*/

my_second_to_last([H|T], X) :-
    is_one_element(T),
    X = H, 
    !.

my_second_to_last([_|T], X) :-
    my_last(T, X).

is_one_element([_]).