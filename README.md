# CMPE260 - Principles of Programming Languages

## Course Information

**Instructor:** Başak Aydemir

**Term:** Spring 22


This course is designed to introduce the main paradigms of computation and the languages that represent these paradigms. We'll explore various programming language constructs, syntax and semantics, and basic programming paradigms, including functional and logic programming. The course does not focus on teaching a specific language but uses multiple languages to illustrate key concepts.

## Repository Overview

This repository contains the code for two projects based on logic (Prolog) and functional (Racket) programming languages, as well as practice code to get familiar with these languages. To run these projects, you need to have Prolog and Racket installed.

- **Racket Lang Reference:** [Racket Documentation](https://docs.racket-lang.org/reference/index.html)
- **SWI-Prolog Reference:** [SWI-Prolog Documentation](https://www.swi-prolog.org/pldoc/doc_for?object=root)

## Repository Structure

```
CMPE260/
├── LICENSE
├── prolog/
│   ├── project/
│   │   ├── main.pro
│   │   ├── cmpecraft.pro
│   │   ├── constants.pro
│   │   ├── map.txt
│   │   └── description.pdf
│   └── practice/
│       └── ...
├── scheme/
│   ├── project/
│   │   ├── main.rkt
│   │   └── description.pdf
│   └── practice/
│       └── ...
└── README.md
```

## First Project: Prolog (Logic Programming)

This project involves writing logic for an agent to perform various tasks in a miniature Minecraft-like environment. The mechanics of the game are pre-implemented in `cmpecraft.pro` and `constants.pro`. The map for the game is provided in `map.txt`, which you can modify to test your agent in different scenarios.

**Key Data Structure:**
- `state/3` predicate: Manages the game state, including the agent and objects in the environment.

**Predicates to Implement:**
1. **manhattan_distance/3:** Calculates the Manhattan distance between two points.
2. **minimum_of_list/2:** Finds the minimum value in a list.
3. **find_nearest_type/5:** Identifies the nearest object of a specified type.
4. **navigate_to/5:** Generates a list of actions to navigate the agent to a specified location.
5. **chop_nearest_tree/2:** Generates actions to locate and chop the nearest tree.
6. **mine_nearest_stone/2:** Generates actions to locate and mine the nearest stone.
7. **gather_nearest_food/2:** Generates actions to locate and gather the nearest food.
8. **collect_requirements/3:** Collects necessary items to craft a specified item.
9. **find_castle_location/5:** Identifies a suitable location to build a castle.
10. **make_castle/2:** Generates actions to gather resources and build a castle.

**Example Map (`map.txt`):**
```
##########
# S TT S #
# O TT C #
#  TT    #
#@     C #
#C     S #
##########
```

You can check the current state with the following query:
```prolog
?- state(AgentDict, ObjectDict, Time).
```

[Description](./prolog/project/description.pdf)

## Next Project: Racket (Functional Programming)

In this project, you'll implement an interpreter that translates infix notation statements in the Yerel-Hesap language to prefix notation (Polish notation). This involves defining a grammar and parsing expressions to make them executable in Racket.

**Functions to Implement:**
1. **(:= var value):** Creates a list with a variable and its assigned value.
2. **(-- assignment1 assignment2 ...):** Transforms multiple assignments into the binding part of a `let` function.
3. **(@ ParsedBinding Expr):** Creates a valid `let` statement from a parsed binding list and an expression.
4. **(split_at_delim delim args):** Splits a list of arguments by a delimiter.
5. **(parse_expr expr):** Converts Yerel-Hesap expressions to Racket expressions.

**Example Expressions:**
```racket
(parse_expr '(3 + 4 * 7))  ; => '(+ 3 (* 4 7))
(parse_expr '(3 * (4 + 7)))  ; => '(* 3 (+ 4 7))
```

[Description](./scheme/project/description.pdf)

## License

This repository is licensed under the MIT License. See the [LICENSE](./LICENSE) file for more information.

Feel free to explore the projects, tweak the code, and understand how different programming paradigms work. If you have any questions or feedback, please reach out. Happy coding!
