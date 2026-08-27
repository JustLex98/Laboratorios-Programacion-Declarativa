% ---------- HECHOS ----------

% Personajes
personaje(leon).
personaje(ashley).
personaje(ada).
personaje(luis).

% Rol de cada personaje
rol(leon, agente).
rol(ashley, estudiante).
rol(ada, espia).
rol(luis, investigador).

% Edad de cada personaje
edad(leon, 27).
edad(ashley, 20).
edad(ada, 26).
edad(luis, 32).

% Armas de cada personaje
arma(leon, pistola).
arma(leon, cuchillo).
arma(ada, pistola).
arma(luis, cuchillo).
% Ashley no tiene armas(va desarmada)

% Enemigos
enemigo(ganados).
enemigo(regeneradores).

infectado_por(ganados, las_plagas).
infectado_por(regeneradores, las_plagas).

% Zonas donde aparecen enemigos
aparece_en(ganados, pueblo).
aparece_en(ganados, castillo).
aparece_en(regeneradores, isla).

% Zonas del juego
zona(pueblo).
zona(castillo).
zona(isla).

% Dificultad de cada zona
dificultad(pueblo, alta).
dificultad(castillo, alta).
dificultad(isla, muy_alta).

% Ubicacion de cada personaje
ubicacion(leon, pueblo).
ubicacion(luis, pueblo).
ubicacion(ada, pueblo).
ubicacion(ada, castillo).


% ---------- REGLAS ----------

% Regla 1: compañeros/2

companeros(X, Y) :-
    personaje(X),
    personaje(Y),
    X \= Y,
    ubicacion(X, L),
    ubicacion(Y, L).


% Regla 2: desprotegido/1

desprotegido(X) :-
    personaje(X),
    \+ arma(X, pistola).


% Regla 3: zona_alto_riesgo/1

zona_alto_riesgo(Z) :-
    dificultad(Z, alta) ; dificultad(Z, muy_alta).


% Regla 4: en_peligro/1

en_peligro(X) :-
    personaje(X),
    ubicacion(X, Z),
    zona_alto_riesgo(Z),
    desprotegido(X).


% Regla 5: mayor_que/2

mayor_que(X, Y) :-
    edad(X, EX),
    edad(Y, EY),
    EX > EY.
