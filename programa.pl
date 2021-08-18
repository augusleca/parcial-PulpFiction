personaje(pumkin,     ladron([licorerias, estacionesDeServicio])).
personaje(honeyBunny, ladron([licorerias, estacionesDeServicio])).
personaje(vincent,    mafioso(maton)).
personaje(jules,      mafioso(maton)).
personaje(marsellus,  mafioso(capo)).
personaje(winston,    mafioso(resuelveProblemas)).
personaje(mia,        actriz([foxForceFive])).
personaje(butch,      boxeador).

%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).

% 1)
esPeligroso(Personaje):-
    realizaActividadPeligrosa(Personaje).

esPeligroso(Personaje):-
    tieneEmpleadosPeligrosos(Personaje).

realizaActividadPeligrosa(Personaje):-
    personaje(Personaje, mafioso(maton)).

realizaActividadPeligrosa(Personaje):-
    personaje(Personaje, ladron(Lista)),
    member(licorerias,Lista).

tieneEmpleadosPeligrosos(Personaje):-
    trabajaPara(Personaje,Empleado),
    esPeligroso(Empleado).

% 2)
sonPareja(X,Y):- pareja(X,Y).
sonPareja(X,Y):- pareja(Y,X).
pareja(marsellus,mia).
pareja(pumkin,honeyBunny).

sonAmigos(X,Y):- amigo(X,Y).
sonAmigos(X,Y):- amigo(Y,X).
amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).

duoTemible(Personaje,OtroPersonaje):-
    ambosPeligrosos(Personaje,OtroPersonaje),
    sonAmigos(Personaje,OtroPersonaje).

duoTemible(Personaje,OtroPersonaje):-
    ambosPeligrosos(Personaje,OtroPersonaje),
    sonPareja(Personaje,OtroPersonaje).

ambosPeligrosos(Personaje,OtroPersonaje):-
    esPeligroso(Personaje),
    esPeligroso(OtroPersonaje).

% 3)
%encargo(Solicitante, Encargado, Tarea). 
%las tareas pueden ser cuidar(Protegido), ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent,   cuidar(mia)).
encargo(vincent,  elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).

estaEnProblemas(Personaje):-
    trabajaPara(Jefe,Personaje),
    esPeligroso(Jefe),
    encargaCuidarPareja(Jefe,Personaje).

estaEnProblemas(Personaje):-
    encargo(_,Personaje, buscar(Buscado,_)),
    esBoxeador(Buscado).

encargaCuidarPareja(Jefe,Personaje):-
    encargo(Jefe,Personaje,cuidar(Pareja)),
    sonPareja(Jefe,Pareja).

esBoxeador(Personaje):- personaje(Personaje, boxeador).

% 4)
sanCayetano(Personaje):-
    encargo(Personaje,_,_),
    forall(tieneCerca(Personaje,Cercano),
        encargo(Personaje,Cercano,_)).

tieneCerca(Personaje,Cercano):- sonAmigos(Personaje,Cercano).
tieneCerca(Personaje,Cercano):- trabajaPara(Personaje,Cercano).

% 5)
masAtareado(Personaje):-
    cantidadDeEncargos(Personaje,Cantidad),
    forall(cantidadDeEncargos(_,OtraCantidad),
        Cantidad >= OtraCantidad).

cantidadDeEncargos(Personaje,Cantidad):-
    personaje(Personaje,_),
    findall(Encargo,encargo(_,Personaje,Encargo),Encargos),
    length(Encargos, Cantidad).
    
% 6)
personajesRespetables(Personajes):-
    findall(Personaje,esRespetable(Personaje),PersonajesRespetables),
    list_to_set(PersonajesRespetables,Personajes).

esRespetable(Personaje):-
    nivelRespeto(Personaje,Nivel),
    Nivel > 9.

nivelRespeto(Personaje,Nivel):-
    personaje(Personaje,actriz(ListaPeliculas)),
    length(ListaPeliculas, CantidadPeliculas),
    Nivel is CantidadPeliculas/10.

nivelRespeto(Personaje,10):- personaje(Personaje,mafioso(resuelveProblemas)).
nivelRespeto(Personaje,1):- personaje(Personaje,mafioso(maton)).
nivelRespeto(Personaje,20):- personaje(Personaje,mafioso(capo)).
    
% 7)
hartoDe(Personaje,Odiado):-
    personaje(Personaje,_),
    personaje(Odiado,_),
    not(hacenTareaSeparados(Personaje,Odiado)).

hartoDe(Personaje,Odiado):-
    personaje(Personaje,_),
    personaje(Odiado,_),
    sonAmigos(Odiado,AmigoOdiado),
    not(hacenTareaSeparados(Personaje,AmigoOdiado)).

hacenTareaSeparados(Personaje,OtroPersonaje):-
    personaje(Personaje,_),
    personaje(OtroPersonaje,_),
    not(interactuan(Personaje,OtroPersonaje)).

interactuan(Personaje,OtroPersonaje):- encargo(_,Personaje,cuidar(OtroPersonaje)).
interactuan(Personaje,OtroPersonaje):- encargo(_,Personaje,ayudar(OtroPersonaje)).
interactuan(Personaje,OtroPersonaje):- encargo(_,Personaje,buscar(OtroPersonaje,_)).

% 8)
caracteristicas(vincent,  [negro, muchoPelo, tieneCabeza]).
caracteristicas(jules,    [tieneCabeza, muchoPelo]).
caracteristicas(marvin,   [negro]).

duoDiferenciable(Personaje,DuoPersonaje):-
    duo(Personaje,DuoPersonaje),
    difierenCaracteristica(Personaje,DuoPersonaje).

difierenCaracteristica(Personaje,OtroPersonaje):-
    caracteristicas(Personaje,Caracteristicas1),
    caracteristicas(OtroPersonaje,Caracteristicas2),
    nth1(_,Caracteristicas1,Elemento),
    not(nth1(_,Caracteristicas2,Elemento)).

duo(Personaje,DuoPersonaje):- sonAmigos(Personaje,DuoPersonaje).
duo(Personaje,DuoPersonaje):- sonPareja(Personaje,DuoPersonaje).

