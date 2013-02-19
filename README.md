# Gump
A 3D automata that seems to do neat things.

Gump visualizes a particular example the computational concept called cellular
automata. A cellular automaton is just a set of rules that describe how
a system evolves. These systems are spatial lattices of cells that form
self-modifying environments, as characterized by the rules. One of the
simplest and most beautiful examples is also the earliest ever discovered,
called Conway's Game of Life (often abbreviated as Life). Life was inspired by
population dynamics of living organisms, and Gump was inpired by Life.


## Visualization

*CURRENTLY IMPLEMENTING GUI*

Runs on [Processing](http://processing.org/) - just download Processing
(tested on 1.51), open gump.pde, and hit the go button in the top left.

This was the first thing I constructed programmatically which I feel is
truly a composition of my own.  While the idea may be something I'm proud of, 
the software engineering practices are not.  This is a project that was undertaken
with very little programming experience.

## cGump

*UNDER CONSTRUCTION*

A library for expressing and iterating gump environments that is much more efficient
than the Processing visual environment.  The goal is to create a good serialization for a gump environment
so that seeds may be made visually and intuitively in Processing, saved to a file, and processed
by the cGump library.

### Public Abominations

My lack of experience at the time shows, so I published this as an example of some bad practices:

- Laziness-motivated global variables
- Little and/or meaningless commenting
- Unnecessary abstraction in places, not enough in others
- Inconsisent variable naming

Additionally, I do like the idea that underlies it.  The automata ruleset exhibits some pretty interesting
characteristics with some experimentation.

`#TODO cubic tendencies`
`#TODO population graphs`

