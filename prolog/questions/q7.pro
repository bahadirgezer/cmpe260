/*

(**) Flatten a nested list structure.
Transform a list, possibly holding lists as elements into a `flat' list by 
replacing each list with its elements (recursively).

Example:
?- my_flatten([a, [b, [c, d], e]], X).
X = [a, b, c, d, e]

Hint: Use the predefined predicates is_list/1 and append/3

*/

my_flatten(L, F) :- my_flatten(L, [], F).


my_flatten([], F, F).

my_flatten([H|T], Temp, Fnew) :- 
    is_list(H), 
    my_flatten(H, Temp, F),
    my_flatten(T, F, Fnew). 

my_flatten([H|T], Temp, F) :-
    \+ is_list(H),
    append(Temp, [H], NewTemp),
    my_flatten(T, NewTemp, F).

append([], X, X).
append([X | Y], Z, [X | W]) :- append( Y, Z, W).

