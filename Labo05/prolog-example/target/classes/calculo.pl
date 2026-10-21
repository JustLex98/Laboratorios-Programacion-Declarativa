% DERIVADAS PLENAMENTE SIMBOLICS:

% Derivada de una constante:

d(Var, Exp1, 0):-
    atomic(Var), number(Exp1),  !.


% Derivara de una variable respecto a sí misma:

d(Var, Exp1, 1):-
    atomic(Var), Exp1 == Var, !.


% Derivada de una constante por una variable:

d(Var, N*Var, N):-
    atomic(Var),  !.


% Derivada de una variable elevada a la N:

d(Var, Var^N, N*Var^Nm1):-
    atomic(Var),  Nm1 is N - 1, !.


% Derivada de una constante por una variable elevada a la N:

d(Var, K*Var^N, C*Var^Nm1):-
    atomic(Var), number(N), is(C, K*N), Nm1 is N - 1, !.


% Derivada del logaritmo natural de una variable:

d(Var, log(Var), 1/Var):-
    atomic(Var), !.


% Drivada del seno de una varable:

d(Var, sen(Var), cos(Var)):-
    atomic(Var), !.


% Drivada del coseno de una varable:

d(Var, cos(Var), -sen(Var)):-
    atomic(Var), !.


% Drivada de la tagente de una varable:

d(Var, tan(Var), (sec(Var))^2):-
    atomic(Var), !.


% Derivada de la suma de pos funcione:

d(Var, F+G, DF+DG):-
    atomic(Var), d(Var, F, DF), d(Var, G, DG).


% DERIVADAS PARA SU POSTERIOR EVALUACION:

% Derivada de una constante:

d(Var, N, 0):-
    var(Var), number(N),  !.


% Derivara de una variable respecto a sí misma:

d(Var, Var, 1):-
    var(Var), !.


% Derivada de una constante por una variable:

d(Var, N*Var, N):-
    var(Var),  !.


% Derivada de una variable elevada a la N:

d(Var, Var^N, N*Var^Nm1):-
    var(Var),  Nm1 is N - 1, !.


% Derivada de una constante por una variable elevada a la N:

d(Var, K*Var^N, C*Var^Nm1):-
    var(Var), number(N), is(C, K*N), Nm1 is N - 1, !.


% Derivada del logaritmo natural de una variable:

d(Var, log(Var), 1/Var):-
    var(Var), !.


% Drivada del seno de una varable:

d(Var, sen(Var), cos(Var)):-
    var(Var), !.


% Drivada del coseno de una varable:

d(Var, cos(Var), -sen(Var)):-
    var(Var), !.


% Drivada de la tagente de una varable:

d(Var, tan(Var), (sec(Var))^2):-
    var(Var), !.


% Derivada de la suma de pos funcione:

d(Var, F+G, DF+DG):-
    var(Var), d(Var, F, DF), d(Var, G, DG).

% Integral de una constante:

s(Var, K, K*Var):-
    atomic(Var), number(K), !.


% Integral de una variable respecto a sí misma:

s(Var, Var, 1/2*Var^2):-
    atomic(Var), !.



% Integral de una variable elevada a la N:

s(Var, Var^N, 1/M*Var^M):-
    atomic(Var), number(N), M is N + 1, !.


% Integral de una constante por una variable elevada a la N:

s(Var, K*Var^N, K/M*Var^M):-
    atomic(Var), number(K), number(N), M is N + 1, !.


% INTEGRALES PARA EVALUACION:

% Integral de una variable elevada a la N:

s(Var, Var^N, 1/M*Var^M):-
    var(Var), number(N), M is N + 1, !.

% ============================================================
%  SUMA Y RESTA DE EXPRESIONES ALGEBRAICAS (terminos semejantes)
% ============================================================

% sumar(Var, Expresion, Resultado)
% La expresion debe tener un + en la raiz:  x^2 + 5*x^2
sumar(Var, A+B, R) :-
    atomic(Var),
    terminos(Var, A+B, 1, [], Lista),
    construir(Var, Lista, R).

% restar(Var, Expresion, Resultado)
% La expresion debe tener un - en la raiz:  8*x^2 - 5*x^2
restar(Var, A-B, R) :-
    atomic(Var),
    terminos(Var, A-B, 1, [], Lista),
    construir(Var, Lista, R).

% ---- terminos(Var, Expr, Signo, Acumulado, Resultado) ----
% Recorre la expresion y va juntando los terminos en una lista de
% pares t(Exponente, Coeficiente). El signo se invierte en lo que
% esta a la derecha de un menos.

terminos(Var, A+B, S, Acc, R) :- !,
    terminos(Var, A, S, Acc, Acc1),
    terminos(Var, B, S, Acc1, R).
terminos(Var, A-B, S, Acc, R) :- !,
    S2 is -S,
    terminos(Var, A, S, Acc, Acc1),
    terminos(Var, B, S2, Acc1, R).
terminos(Var, -A, S, Acc, R) :- !,
    S2 is -S,
    terminos(Var, A, S2, Acc, R).
terminos(Var, T, S, Acc, R) :-
    termino(Var, T, C, N),
    C2 is S*C,
    agregar(C2, N, Acc, R).

% ---- termino(Var, Termino, Coeficiente, Exponente) ----
termino(_, T, T, 0) :- number(T), !.
termino(Var, T, 1, 1) :- T == Var, !.
termino(Var, Var^N, 1, N) :- number(N), !.
termino(Var, K*Var, K, 1) :- number(K), !.
termino(Var, K*Var^N, K, N) :- number(K), number(N), !.

% ---- agregar(Coef, Exp, ListaActual, ListaNueva) ----
% Si ya existe un termino con el mismo exponente suma los coeficientes
% (terminos semejantes). Si no, lo inserta ordenado de mayor a menor exponente.
agregar(C, N, [], [t(N,C)]).
agregar(C, N, [t(N,C0)|T], [t(N,C1)|T]) :- !,
    C1 is C0 + C.
agregar(C, N, [t(M,C0)|T], [t(N,C),t(M,C0)|T]) :-
    N > M, !.
agregar(C, N, [X|T], [X|T1]) :-
    agregar(C, N, T, T1).

% ---- construir(Var, Lista, Resultado) ----
construir(Var, Lista, R) :-
    quitar_ceros(Lista, Lista1),
    armar(Var, Lista1, R).

quitar_ceros([], []).
quitar_ceros([t(_,C)|T], R) :-
    C =:= 0, !,
    quitar_ceros(T, R).
quitar_ceros([X|T], [X|R]) :-
    quitar_ceros(T, R).

armar(_, [], 0).
armar(Var, [t(N,C)|T], R) :-
    mono(Var, C, N, M),
    unir(Var, T, M, R).

unir(_, [], R, R).
unir(Var, [t(N,C)|T], Acc, R) :-
    C < 0, !,
    C1 is -C,
    mono(Var, C1, N, M),
    unir(Var, T, Acc - M, R).
unir(Var, [t(N,C)|T], Acc, R) :-
    mono(Var, C, N, M),
    unir(Var, T, Acc + M, R).

% ---- mono(Var, Coeficiente, Exponente, Termino) ----
mono(_, C, 0, C) :- !.
mono(Var, 1, 1, Var) :- !.
mono(Var, -1, 1, -Var) :- !.
mono(Var, C, 1, C*Var) :- !.
mono(Var, 1, N, Var^N) :- !.
mono(Var, -1, N, -(Var^N)) :- !.
mono(Var, C, N, C*Var^N).
