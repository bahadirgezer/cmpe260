/*

(**) Determine the greatest common divisor of two positive integer numbers.
Use Euclid's algorithm.
Example:
?- gcd(36, 63, G).
G = 9
Define gcd as an arithmetic function; so you can use it like this:
?- G is gcd(36,63).
G = 9

*/

/*
function gcd(a, b)
    while b ≠ 0
        t := b
        b := a mod b
        a := t
    return a
*/

:- arithmetic_function(gcd/2).

gcd(A, 0, G) :-
    G is A.

gcd(A, B, G) :-
    Temp is B,
    Bnew is (A mod B),
    Anew is Temp,    
    gcd2(Anew, Bnew, G).


