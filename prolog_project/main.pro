% name surname
% studentid
% compiling: no
% complete: no
:- ['cmpecraft.pro'].

:- init_from_map.


t.
f.

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

not_inst(Var):-
    \+(\+(Var=0)),
    \+(\+(Var=1)).

object_type(ObjectType, Object) :-
    get_dict(type, Object, Type),
    Type = ObjectType.

get_nearest(_, _, [], _, K, O, L, K, O, L) :-
    (not_inst(O) -> !, fail; !).


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
            ).
/*
      1  2  3  4  5  6 
    1
    2
    3
    4
    5
    6
*/

% 10 points
% chop_nearest_tree(+State, -ActionList) :- .

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

mine_nearest_cobblestone(State, ActionList) :-
    (\+find_nearest_type(State, cobblestone, _, _, _), !, fail;
    find_nearest_type(State, cobblestone, _, Object, _),
    State = [Agent, _, _],
    manhattan_distance([Agent.x, Agent.y], [Object.x, Object.y], Distance),
    navigate_to(State, Object.x, Object.y, FirstActionList, Distance),
    mine_cobblestone(FirstActionList, ActionList)).


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

/*
gather_pickaxe(State, Actions, ActionList) :-
    State = [Agent, _, _],
    Inv = Agent.inventory,
    has(log, 3, Inv), 
    has(stick, 2, Inv),
    has(cobblestone, 3, Inv),
    ActionList = Actions, !.

gather_pickaxe(State, Actions, ActionList) :-
    State = [Agent, _, _],
    Inv = Agent.inventory,
    find_nearest(State, Object),
    Object.type = stone, 
    \+has(cobblestone, 3, Inv), 
    manhattan_distance([Object.x, Object.y], [Agent.x, Agent.y], Distance),
    navigate_to(State, Object.x, Object.y, Actions1, Distance),
    mine_stone(Actions1, Actions2),
    execute_print_actions(State, Actions2, State2),
    append(Actions, Actions2, Actions3),
    gather_pickaxe(State2, Actions3, ActionList), !.


gather_pickaxe(State, Actions, ActionList) :-
    State = [Agent, _, _],
    Inv = Agent.inventory,
    find_nearest(State, Object),
    Object.type = cobblestone,
    \+has(cobblestone, 3, Inv), 
    manhattan_distance([Object.x, Object.y], [Agent.x, Agent.y], Distance),
    navigate_to(State, Object.x, Object.y, Actions1, Distance),
    mine_cobblestone(Actions1, Actions2),
    execute_print_actions(State, Actions2, State2),
    append(Actions, Actions2, Actions3),
    gather_pickaxe(State2, Actions3, ActionList), !.

gather_pickaxe(State, Actions, ActionList) :-
    State = [Agent, _, _],
    Inv = Agent.inventory,
    \+has(stick, 2, Inv),
    has(log, 2, Inv),
    Actions1 = ['craft_stick'],
    execute_print_actions(State, Actions1, State2),
    append(Actions, Actions1, Actions2),
    gather_pickaxe(State2, Actions2, ActionList), !.

gather_pickaxe(State, Actions, ActionList) :-
    State = [Agent, _, _],
    Inv = Agent.inventory,
    find_nearest(State, Object),
    Object.type = tree,
    \+has(stick, 2, Inv),
    \+has(log, 3, Inv),
    manhattan_distance([Object.x, Object.y], [Agent.x, Agent.y], Distance),
    navigate_to(State, Object.x, Object.y, Actions1, Distance),
    chop_tree(Actions1, Actions2),
    execute_print_actions(State, Actions2, State2),
    append(Actions, Actions2, Actions3),
    gather_pickaxe(State2, Actions3, ActionList), !.
*/

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


gather_pickaxe(State, Actions, Actions) :-
    State = [Agent, _, _],
    Inv = Agent.inventory,
    has(stick, 2, Inv),
    has(log, 2, Inv),
    has(cobblestone, 3, Inv), !.

gather_pickaxe(State, Actions, ActionList) :-
    State = [Agent, _, _],
    Inv = Agent.inventory,
    \+has(stick, 2, Inv),
    has(log, 2, Inv),
    A = ['craft_stick'],
    execute_actions(State, A, NewState),
    append(Actions, A, NewActions),
    gather_pickaxe(NewState, NewActions, ActionList), !.

gather_pickaxe(State, Actions, ActionList) :-
    State = [Agent, _, _],
    Inv = Agent.inventory,
    \+has(cobblestone, 3, Inv),
    (find_nearest_type(State, stone, _, Object, _),
    collect_stone(State, Object, Actions, ActionList), !;
    find_nearest_type(State, cobblestone, _, Object, _), 
    collect_cobblestone(State, Object, Actions, ActionList), !), !.

% gather_pickaxe(State, Actions, ActionList) :-
%     State = [Agent, _, _],
%     Inv = Agent.inventory,
%     \+has(cobblestone, 3, Inv),
%     find_nearest_type(State, cobblestone, _, Object, _),
%     collect_cobblestone(State, Object, Actions, ActionList), !.

gather_pickaxe(State, Actions, ActionList) :-
    State = [Agent, _, _],
    Inv = Agent.inventory,
    \+has(stick, 2, Inv),
    find_nearest_type(State, tree, _, Object, _),
    collect_tree(State, Object, Actions, ActionList), !.

gather_pickaxe(State, Actions, ActionList) :-
    State = [Agent, _, _],
    Inv = Agent.inventory,
    \+has(log, 3, Inv),
    find_nearest_type(State, tree, _, Object, _),
    collect_tree(State, Object, Actions, ActionList), !.

gather_pickaxe(_, _, []).


check_failure_pickaxe(State) :-
    State = [Agent, _, _],
    Inv = Agent.inventory,
    \+has(stick, 2, Inv),
    \+has(log, 2, Inv),
    \+has(cobblestone, 3, Inv),
    \+has(tree, 3, Inv), !.

/*
gather_pickaxe(State, Actions, ActionList) :-
    State = [Agent, _, _],
    Inv = Agent.inventory,
    find_nearest(State, Object),
    (Object.type = tree, 
        \+has(stick, 2, Inv),
        collect_tree(State, Object, Actions, ActionList), !;
        Object.type = tree, 
        \+has(log, 3, Inv),
        collect_tree(State, Object, Actions, ActionList), !;
        Object.type = stone,
        \+has(cobblestone, 3, Inv),
        collect_stone(State, Object, Actions, ActionList), !;
        Object.type = cobblestone,
        \+has(cobblestone, 3, Inv),
        collect_cobblestone(State, Object, Actions, ActionList), !).
*/
/*
gather_pickaxe(State, Actions, ActionList) :-
    State = [Agent, _, _],
    Inv = Agent.inventory,
    find_nearest(State, Object),
    (Object.type = stone, 
        \+has(cobblestone, 3, Inv), 
        manhattan_distance([Object.x, Object.y], [Agent.x, Agent.y], Distance),
        navigate_to(State, Object.x, Object.y, Actions1, Distance),
        mine_stone(Actions1, Actions2),
        execute_print_actions(State, Actions2, State2),
        append(Actions, Actions2, Actions3),
        gather_pickaxe(State2, Actions3, ActionList), !;
        Object.type = cobblestone,
        \+has(cobblestone, 3, Inv), 
        manhattan_distance([Object.x, Object.y], [Agent.x, Agent.y], Distance),
        navigate_to(State, Object.x, Object.y, Actions1, Distance),
        mine_cobblestone(Actions1, Actions2),
        execute_print_actions(State, Actions2, State2),
        append(Actions, Actions2, Actions3),
        gather_pickaxe(State2, Actions3, ActionList), !;
        Object.type = tree, 
        (
            \+has(stick, 2, Inv),
            \+has(log, 2, Inv),
            manhattan_distance([Object.x, Object.y], [Agent.x, Agent.y], Distance),
            navigate_to(State, Object.x, Object.y, Actions1, Distance),
            chop_tree(Actions1, Actions2),
            execute_print_actions(State, Actions2, State2),
            append(Actions, Actions2, Actions3),
            gather_pickaxe(State2, Actions3, ActionList), !;
            has(stick, 2, Inv),
            \+has(log, 3, Inv), 
            manhattan_distance([Object.x, Object.y], [Agent.x, Agent.y], Distance),
            navigate_to(State, Object.x, Object.y, Actions1, Distance),
            chop_tree(Actions1, Actions2),
            execute_print_actions(State, Actions2, State2),
            append(Actions, Actions2, Actions3),
            gather_pickaxe(State2, Actions3, ActionList), !)
        ), !.

*/

/*
gather_pickaxe(State, ActionList) :-
    State = [Agent, _, _],
    Inv = Agent.inventory,
    has(log, 3, Inv), 
    has(stick, 2, Inv),
    has(cobblestone, 3, Inv), ActionList = [], !.


gather_pickaxe(State, ActionList) :-
    State = [Agent, _, _],
    Inv = Agent.inventory,
    \+has(cobblestone, 3, Inv),
    write('Mining stone'), nl,
    mine_nearest_stone(State, FirstActionList),
    execute_print_actions(State, FirstActionList, State2),
    gather_pickaxe(State2, SecondActionList),
    append(FirstActionList, SecondActionList, ActionList), !.

gather_pickaxe(State, ActionList) :-
    State = [Agent, _, _],
    Inv = Agent.inventory,
    \+has(cobblestone, 3, Inv),
    write('Mining cobblestone'), nl,
    mine_nearest_cobblestone(State, FirstActionList),
    execute_print_actions(State, FirstActionList, State2),
    gather_pickaxe(State2, SecondActionList),
    append(FirstActionList, SecondActionList, ActionList), !.

gather_pickaxe(State, ActionList) :-
    State = [Agent, _, _],
    Inv = Agent.inventory,
    \+has(stick, 2, Inv),
    \+has(log, 2, Inv),
    write('Chopping tree for stick'), nl,
    chop_nearest_tree(State, FirstActionList),
    execute_print_actions(State, FirstActionList, State2),
    gather_pickaxe(State2, SecondActionList),
    append(FirstActionList, SecondActionList, ActionList), !.

gather_pickaxe(State, ActionList) :-
    State = [Agent, _, _],
    Inv = Agent.inventory,
    \+has(stick, 2, Inv),
    has(log, 2, Inv),
    FirstActionList = ['craft_stick'],
    write('Crafting stick'), nl,
    execute_print_actions(State, FirstActionList, State2),
    gather_pickaxe(State2, SecondActionList),
    append(FirstActionList, SecondActionList, ActionList), !.

gather_pickaxe(State, ActionList) :-
    State = [Agent, _, _],
    Inv = Agent.inventory,
    \+has(log, 3, Inv),
    write('Chopping tree for log'), nl,
    chop_nearest_tree(State, FirstActionList),
    execute_print_actions(State, FirstActionList, State2),
    gather_pickaxe(State2, SecondActionList),
    append(FirstActionList, SecondActionList, ActionList), !.

gather_pickaxe(_, ActionList) :- ActionList = [], !, fail.

*/

/*
gather_pickaxe(State, ActionList) :-
    State = [Agent, _, _],
    Inv = Agent.inventory,
    (has(log, 3, Inv), 
        has(stick, 2, Inv),
        has(cobblestone, 3, Inv), !;
        \+has(cobblestone, 3, Inv),
        write('Mining stone'), nl,
        mine_nearest_stone(State, FirstActionList),
        execute_print_actions(State, FirstActionList, State2),
        gather_pickaxe(State2, SecondActionList),
        append(FirstActionList, SecondActionList, ActionList), !;
        \+has(cobblestone, 3, Inv),
        write('Mining cobblestone'), nl,
        mine_nearest_cobblestone(State, FirstActionList),
        execute_print_actions(State, FirstActionList, State2),
        gather_pickaxe(State2, SecondActionList),
        append(FirstActionList, SecondActionList, ActionList), !;
        \+has(stick, 2, Inv),
        \+has(log, 2, Inv),
        write('Chopping tree for stick'), nl,
        chop_nearest_tree(State, FirstActionList),
        execute_print_actions(State, FirstActionList, State2),
        gather_pickaxe(State2, SecondActionList),
        append(FirstActionList, SecondActionList, ActionList), !;
        \+has(stick, 2, Inv),
        has(log, 2, Inv),
        FirstActionList = ['craft_stick'],
        write('Crafting stick'), nl,
        execute_print_actions(State, FirstActionList, State2),
        gather_pickaxe(State2, SecondActionList),
        append(FirstActionList, SecondActionList, ActionList), !;
        \+has(log, 3, Inv),
        write('Chopping tree for log'), nl,
        chop_nearest_tree(State, FirstActionList),
        execute_print_actions(State, FirstActionList, State2),
        gather_pickaxe(State2, SecondActionList),
        append(FirstActionList, SecondActionList, ActionList), !;
        !, fail).
*/

collect_requirements(State, ItemType, ActionList) :-
    (ItemType = stick ->
        gather_stick(State, ActionList);
        ItemType = stone_pickaxe ->
        gather_pickaxe(State, [], ActionList);
        ItemType = stone_axe ->
        gather_axe(State, ActionList)).

% 5 points
% find_castle_location(+State, -XMin, -YMin, -XMax, -YMax) :- .

find_castle_location(State, XMin, YMin, XMax, YMax).

% 15 points
% make_castle(+State, -ActionList) :- .
