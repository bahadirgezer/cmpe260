/*

(*) Find the number of elements of a list.

*/

len([] , N) :-
    N is 0.

len( [_|T] , N)  :-
    len( T , Nnew),
    N is Nnew + 1.

