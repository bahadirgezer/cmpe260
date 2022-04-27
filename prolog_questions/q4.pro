/*

(*) Find the number of elements of a list.

*/

len([] , N) :-
    N is 0.

len( [_|T] , N)  :-
    list_length( T , Nnew),
    N is Nnew + 1.

