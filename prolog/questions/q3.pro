/*

(*) Find the K'th element of a list.
The first element in the list is number 1.
Example:
?- element_at(X,[a,b,c,d,e],3).
X = c

*/

findKth([X|_], 1, A) :-
    A is X, 
    !.


findKth([_|T], X, A) :-
    Xnew is X - 1,
    findKth(T, Xnew, A).
