%Ejercicio Evaluado: Implementar el calculo del n-esimo numero de Fibonacci

%Casos base
fib(0, 0).
fib(1, 1).

%Caso recursivo
fib(M, R) :-
    M > 1,
    S1 is M - 1,
    S2 is M - 2,
    fib(S1, R1),
    fib(S2, R2),
    R is R1 + R2.