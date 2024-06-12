% bahadir gezer
% 2020400039
% compiling: yes
% complete: yes
:- ['cmpecraft.pro'].
:- init_from_map.

% 10 points
% manhattan_distance(+A, +B, -Distance) :- .
manhattan_distance(A, B, Distance) :-
    A = [X1, Y1],
    B = [X2, Y2],
    Distance is abs(X1 - X2) + abs(Y1 - Y2).

% 10 points
% minimum_of_list(+List, -Minimum) :- .
get_min([], CurrentMinimum, CurrentMinimum).

get_min(List, CurrentMin, Minimum) :-
    List = [Head|Tail],
    (Head < CurrentMin -> 
        get_min(Tail, Head, Minimum);
        get_min(Tail, CurrentMin, Minimum)).

minimum_of_list(List, Minimum) :- 
    List = [Head|Tail],
    get_min(Tail, Head, Minimum).


% 10 points
% find_nearest_type(+State, +ObjectType, -ObjKey, -Object, -Distance) :- .

%checks if Var is instantiated or not
not_inst(Var):-
    \+(\+(Var=0)),
    \+(\+(Var=1)).

object_type(ObjectType, Object) :-
    get_dict(type, Object, Type),
    Type = ObjectType.

get_nearest(_, _, [], _, K, O, L, K, O, L) :-
    (not_inst(O) -> !, fail; !).

%get nearest for a single type of object
get_nearest(Agent, Objects, ObjKeys, Type, K, O, L, ObjKey, Object, Distance) :-
    ObjKeys = [NewKey|NewObjectKeys],
    get_dict(NewKey, Objects, NewObject),
    (
        object_type(Type, NewObject),
        manhattan_distance([NewObject.x, NewObject.y], [Agent.x, Agent.y], NewL),
        (
            NewL < L -> 
                get_nearest(Agent, Objects, NewObjectKeys, Type, NewKey, NewObject, NewL, ObjKey, Object, Distance), !;
                get_nearest(Agent, Objects, NewObjectKeys, Type, K, O, L, ObjKey, Object, Distance), !
        );
        \+object_type(Type, NewObject),
        get_nearest(Agent, Objects, NewObjectKeys, Type, K, O, L, ObjKey, Object, Distance), !
    ).

%cover function for get nearest
find_nearest_type(State, ObjectType, ObjKey, Object, Distance) :-
    State = [Agent, Objects, _],
    dict_keys(Objects, ObjKeys),
    width(W), height(H),
    Size is 2 * (W + H),
    get_nearest(Agent, Objects, ObjKeys, ObjectType,  _, _, Size, ObjKey, Object, Distance).

% 10 points
% navigate_to(+State, +X, +Y, -ActionList, +DepthLimit) :- .

add_action(_, 0, CurrentActions, CurrentActions).
add_action(_, -1, CurrentActions, CurrentActions).

add_action(Action, Count, CurrentActions, NewActions) :-
    append([Action], CurrentActions, NewCurrentActions),
    NewCount is Count - 1,
    add_action(Action, NewCount, NewCurrentActions, NewActions).

%no search is done, just adds back to back up or down or left or right actions.
navigate_to(State, X, Y, ActionList, DepthLimit) :-
    State = [Agent, _, _],
    manhattan_distance([Agent.x, Agent.y], [X, Y], Distance),
    (Distance > DepthLimit -> ActionList = [], !, fail; 
        (Agent.y > Y ->
            Times2 is Agent.y - Y,
            add_action('go_up', Times2, [], FirstActionList);
            Times2 is Y - Agent.y,
            add_action('go_down', Times2, [], FirstActionList)),
        (Agent.x > X ->
            Times1 is Agent.x - X,
            add_action('go_left', Times1, FirstActionList, ActionList);
            Times1 is X - Agent.x,
            add_action('go_right', Times1, FirstActionList, ActionList))
            ), !.

% 10 points
% chop_nearest_tree(+State, -ActionList) :- .

%basically useless predicate, it's the same with mine_stone.
chop_tree(FirstActionList, ActionList) :-
    append(FirstActionList, 
        ['left_click_c', 'left_click_c', 'left_click_c', 'left_click_c'], 
        ActionList).

chop_nearest_tree(State, ActionList) :-
    (\+find_nearest_type(State, tree, _, _, _), !, fail;
    find_nearest_type(State, tree, _, Object, _),
    State = [Agent, _, _],
    manhattan_distance([Agent.x, Agent.y], [Object.x, Object.y], Distance),
    navigate_to(State, Object.x, Object.y, FirstActionList, Distance),
    chop_tree(FirstActionList, ActionList)).

% 10 points
% mine_nearest_stone(+State, -ActionList) :- .

mine_stone(FirstActionList, ActionList) :-
    append(FirstActionList, 
        ['left_click_c', 'left_click_c', 'left_click_c', 'left_click_c'], 
        ActionList).

mine_nearest_stone(State, ActionList) :-
    (\+find_nearest_type(State, stone, _, _, _), !, fail;
    find_nearest_type(State, stone, _, Object, _),
    State = [Agent, _, _],
    manhattan_distance([Agent.x, Agent.y], [Object.x, Object.y], Distance),
    navigate_to(State, Object.x, Object.y, FirstActionList, Distance),
    mine_stone(FirstActionList, ActionList)).


% 10 points
% gather_nearest_food(+State, -ActionList) :- .

gather_food(FirstActionList, ActionList) :-
    append(FirstActionList, 
        ['left_click_c'], 
        ActionList).

gather_nearest_food(State, ActionList) :-
    (\+find_nearest_type(State, food, _, _, _), !, fail;
    find_nearest_type(State, food, _, Object, _),
    State = [Agent, _, _],
    manhattan_distance([Agent.x, Agent.y], [Object.x, Object.y], Distance),
    navigate_to(State, Object.x, Object.y, FirstActionList, Distance),
    gather_food(FirstActionList, ActionList)).


% 10 points
% collect_requirements(+State, +ItemType, -ActionList) :- .

mine_cobblestone(FirstActionList, ActionList) :-
    append(FirstActionList, 
        ['left_click_c', 'left_click_c', 'left_click_c', 'left_click_c'], 
        ActionList).

%added the same mine predicate for cobblestone objects
mine_nearest_cobblestone(State, ActionList) :-
    (\+find_nearest_type(State, cobblestone, _, _, _), !, fail;
    find_nearest_type(State, cobblestone, _, Object, _),
    State = [Agent, _, _],
    manhattan_distance([Agent.x, Agent.y], [Object.x, Object.y], Distance),
    navigate_to(State, Object.x, Object.y, FirstActionList, Distance),
    mine_cobblestone(FirstActionList, ActionList)).

%if the agent doesn't have two logs in ints inventory, then it tries to collect the nearest tree.
gather_stick(State, ActionList) :-
    State = [Agent, _, _],
    Inv = Agent.inventory,
    (has(log, 2, Inv), !;
        \+has(log, 2, Inv), 
        \+chop_nearest_tree(State, ActionList), !, fail; 
        \+has(log, 2, Inv),
        chop_nearest_tree(State, ActionList)).

find_nearest_object(_, _, [], O, _, O) :-
    (not_inst(O) -> !, fail; !).

%finds the nearest non-food type object.
find_nearest_object(Agent, Objects, Keys, CurrentObject, CurrentDistance, Object) :-
    Keys = [Key|NewKeys],
    get_dict(Key, Objects, NewCurrentObject),
    (
        \+object_type(food, NewCurrentObject),
        manhattan_distance([NewCurrentObject.x, NewCurrentObject.y], [Agent.x, Agent.y], NewDistance),
        (NewDistance < CurrentDistance ->
            find_nearest_object(Agent, Objects, NewKeys, NewCurrentObject, NewDistance, Object), !;
            find_nearest_object(Agent, Objects, NewKeys, CurrentObject, CurrentDistance, Object), !);
        object_type(food, NewCurrentObject),
        find_nearest_object(Agent, Objects, NewKeys, CurrentObject, CurrentDistance, Object), !
    ).

find_nearest(State, Object) :- %can fail.
    State = [Agent, Objects, _],
    dict_keys(Objects, Keys),
    width(W), height(H),
    Size is 2 * (W + H),
    find_nearest_object(Agent, Objects, Keys, _, Size, Object), !.

%collects a tree, used in gather_pickaxe. It's tidier this way.
collect_tree(State, Object, Actions, ActionList) :-
    State = [Agent, _, _],
    manhattan_distance([Object.x, Object.y], [Agent.x, Agent.y], Distance),
    navigate_to(State, Object.x, Object.y, A1, Distance),
    chop_tree(A1, A2),
    execute_actions(State, A2, NewState),
    append(Actions, A2, NewActions),
    gather_pickaxe(NewState, NewActions, ActionList), !.

collect_stone(State, Object, Actions, ActionList) :-
    State = [Agent, _, _],
    manhattan_distance([Object.x, Object.y], [Agent.x, Agent.y], Distance),
    navigate_to(State, Object.x, Object.y, A1, Distance),
    mine_stone(A1, A2),
    execute_actions(State, A2, NewState),
    append(Actions, A2, NewActions),
    gather_pickaxe(NewState, NewActions, ActionList), !.

collect_cobblestone(State, Object, Actions, ActionList) :-
    State = [Agent, _, _],
    manhattan_distance([Object.x, Object.y], [Agent.x, Agent.y], Distance),
    navigate_to(State, Object.x, Object.y, A1, Distance),
    mine_cobblestone(A1, A2),
    execute_actions(State, A2, NewState),
    append(Actions, A2, NewActions),
    gather_pickaxe(NewState, NewActions, ActionList), !.

%ending predicate
gather_pickaxe(State, Actions, Actions) :-
    State = [Agent, _, _],
    Inv = Agent.inventory,
    has(stick, 2, Inv),
    has(log, 2, Inv),
    has(cobblestone, 3, Inv), !.

%if there isn't enough sticks but has enough logs to craft sticks. It crafts sticks.
gather_pickaxe(State, Actions, ActionList) :-
    State = [Agent, _, _],
    Inv = Agent.inventory,
    \+has(stick, 2, Inv),
    has(log, 2, Inv),
    A = ['craft_stick'],
    execute_actions(State, A, NewState),
    append(Actions, A, NewActions),
    gather_pickaxe(NewState, NewActions, ActionList), !.

%if there isn't enough cobblestone. checks for both stone and cobblestone to mine.
gather_pickaxe(State, Actions, ActionList) :-
    State = [Agent, _, _],
    Inv = Agent.inventory,
    \+has(cobblestone, 3, Inv),
    (find_nearest_type(State, stone, _, Object, _),
    collect_stone(State, Object, Actions, ActionList), !;
    find_nearest_type(State, cobblestone, _, Object, _), 
    collect_cobblestone(State, Object, Actions, ActionList), !), !.

%If there isn't enough sticks. Collects the nearest tree.
gather_pickaxe(State, Actions, ActionList) :-
    State = [Agent, _, _],
    Inv = Agent.inventory,
    \+has(stick, 2, Inv),
    find_nearest_type(State, tree, _, Object, _),
    collect_tree(State, Object, Actions, ActionList), !.

%If there isn't enough logs. Collects the nearest tree.
gather_pickaxe(State, Actions, ActionList) :-
    State = [Agent, _, _],
    Inv = Agent.inventory,
    \+has(log, 3, Inv),
    find_nearest_type(State, tree, _, Object, _),
    collect_tree(State, Object, Actions, ActionList), !.

gather_pickaxe(_, _, []).

%fails if it cannot bind to any of the predicates above.
check_failure_pickaxe(State) :-
    State = [Agent, _, _],
    Inv = Agent.inventory,
    \+has(stick, 2, Inv),
    \+has(log, 2, Inv),
    \+has(cobblestone, 3, Inv),
    \+has(tree, 3, Inv), !.

%cover predicate
collect_requirements(State, ItemType, ActionList) :-
    (ItemType = stick ->
        gather_stick(State, ActionList);
        ItemType = stone_pickaxe ->
        gather_pickaxe(State, [], ActionList);
        ItemType = stone_axe ->
        gather_pickaxe(State, [], ActionList)).

% 5 points
% find_castle_location(+State, -XMin, -YMin, -XMax, -YMax) :- .

%checks whether X, Y is occupied by an object
occupied(State, X, Y) :-
    State = [_, Objects, _],
    get_dict(_, Objects, Object),
    get_dict(x, Object, X),
    get_dict(y, Object, Y).

%finds X, Y in ListX, ListY such that X, Y is a suitable position for the center of a castle.
check_x_y(State, ListX, ListY, X, Y) :-
    member(X, ListX), member(Y, ListY),
    check_others(State, X, Y), !. %cut makes the predicate find just one point

%used for free space detection.
check_others(State, X, Y) :-
    Xl is X - 1, Xr is X + 1,
    Yu is Y - 1, Yd is Y + 1, 
    (
        occupied(State, Xl, Yu), !, fail;
        occupied(State, Xl, Y), !, fail;
        occupied(State, Xl, Yd), !, fail;
        occupied(State, X, Yu), !, fail;
        occupied(State, X, Y), !, fail;
        occupied(State, X, Yd), !, fail;
        occupied(State, Xr, Yu), !, fail;
        occupied(State, Xr, Y), !, fail;
        occupied(State, Xr, Yd), !, fail;
        !
    ).

%gets a single valid X, Y Point.
valid(State, Points) :-
    width(W), height(H),
    Rw is W - 3, Rh is H - 3,
    bagof(X, between(2, Rw, X), ListX),
    bagof(Y, between(2, Rh, Y), ListY),
    bagof([X, Y], check_x_y(State, ListX, ListY, X, Y), Points).

%cover predicate
find_castle_location(State, XMin, YMin, XMax, YMax) :-
    valid(State, Points),
    Points = [[X,Y]],
    XMin is X - 1, XMax is X + 1,
    YMin is Y - 1, YMax is Y + 1.

% didn't want to use empty list since it fails when used with cmpecraft, 
% added one left_click in case the actionlist is empty.
% first collects the requirements, then checks if there is a suitable location for the castle.
% if there is, it builds the castle.
% This way there can be situations where the castle is built in a place which was previously
% occupied by another object. 
make_castle(State, ActionList) :-
    collect_castle_requirements(State, ['left_click_c'], A1),
    execute_actions(State, A1, NewState),
    find_castle_location(NewState, XMin, YMin, XMax, YMax),
    X is (XMin + XMax) // 2,
    Y is (YMin + YMax) // 2,
    build_castle(NewState, X, Y, A1, ActionList).

% builds the castle.
build_castle(State, X, Y, Actions, ActionList) :-
    State = [Agent, _, _],
    manhattan_distance([X, Y], [Agent.x, Agent.y], Distance),
    navigate_to(State, X, Y, A1, Distance),
    A2 = ['place_ne', 'place_n', 'place_nw', 'place_w', 'place_sw', 
    'place_s', 'place_se', 'place_e', 'place_c'],
    append(A1, A2, A3),
    append(Actions, A3, ActionList), !.

%collect stone method for castle. Basically the same one above.
collect_stone_castle(State, Object, Actions, ActionList) :-
    State = [Agent, _, _],
    manhattan_distance([Object.x, Object.y], [Agent.x, Agent.y], Distance),
    navigate_to(State, Object.x, Object.y, A1, Distance),
    mine_stone(A1, A2),
    execute_actions(State, A2, NewState),
    append(Actions, A2, NewActions),
    collect_castle_requirements(NewState, NewActions, ActionList), !.

collect_cobblestone_castle(State, Object, Actions, ActionList) :-
    State = [Agent, _, _],
    manhattan_distance([Object.x, Object.y], [Agent.x, Agent.y], Distance),
    navigate_to(State, Object.x, Object.y, A1, Distance),
    mine_cobblestone(A1, A2),
    execute_actions(State, A2, NewState),
    append(Actions, A2, NewActions),
    collect_castle_requirements(NewState, NewActions, ActionList), !.

collect_castle_requirements(State, Actions, Actions) :-
    State = [Agent, _, _],
    Inv = Agent.inventory,
    has(cobblestone, 9, Inv), !.

collect_castle_requirements(State, Actions, ActionList) :-
    State = [Agent, _, _],
    Inv = Agent.inventory,
    \+has(cobblestone, 9, Inv),
    (find_nearest_type(State, stone, _, Object, _),
    collect_stone_castle(State, Object, Actions, ActionList), !;
    find_nearest_type(State, cobblestone, _, Object, _), 
    collect_cobblestone_castle(State, Object, Actions, ActionList), !), !.

collect_castle_requirements(_, _, []).

%extra predicates for fun.

% extra predicate for fun. Builds castles until it cannot build anymore.
make_castles(State, FinalState) :-
    make_castle(State, ActionList),
    execute_print_actions(State, ActionList, NewState), 
    make_castles(NewState, FinalState), !.

make_castles(State, State) :- !.

%collects every item on the map. Fun predicate.
collect_every_item(State, FinalState) :-
    State = [Agent, _, _],
    find_nearest_all(State, Object),
    manhattan_distance([Object.x, Object.y], [Agent.x, Agent.y], Distance),
    navigate_to(State, Object.x, Object.y, A1, Distance),
    A2 = ['left_click_c', 'left_click_c', 
    'left_click_c', 'left_click_c'],
    append(A1, A2, ActionList),
    execute_print_actions(State, ActionList, NewState),
    collect_every_item(NewState, FinalState), !.

collect_every_item(State, State) :- !.

find_nearest_object_all(_, _, [], O, _, O) :-
    (not_inst(O) -> !, fail; !).

find_nearest_object_all(Agent, Objects, Keys, CurrentObject, CurrentDistance, Object) :-
    Keys = [Key|NewKeys],
    get_dict(Key, Objects, NewCurrentObject),
    manhattan_distance([NewCurrentObject.x, NewCurrentObject.y], [Agent.x, Agent.y], NewDistance),
    (NewDistance < CurrentDistance ->
        find_nearest_object_all(Agent, Objects, NewKeys, NewCurrentObject, NewDistance, Object), !;
        find_nearest_object_all(Agent, Objects, NewKeys, CurrentObject, CurrentDistance, Object), !).

find_nearest_all(State, Object) :- %can fail.
    State = [Agent, Objects, _],
    dict_keys(Objects, Keys),
    width(W), height(H),
    Size is 2 * (W + H),
    find_nearest_object_all(Agent, Objects, Keys, _, Size, Object), !.
