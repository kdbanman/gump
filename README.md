# Gump
A 3D automata that seems to do neat things.

To get it running, you need Java.  If you don't have it, google, "i need java please" and follow your nose.

If you want to play with gump, download the whole folder for your your operating system in the "executables" directory.  
For windows, run the .exe.  Mac OS, run the gump app.  Run gump from your favorite shell terminal or something.

If you want to muck around in the source, you need [Processing 1.51](http://processing.org/download/).

##Controls

After you start gump, you see a grid of orange cells.  You're currently in construction mode.
Your job is to construct a seed (initial configuration) of on and off cells.  Every change you
make to the seed changes how it will evolve.  Here's what you can do:

- **Click** on the cells to turn them on and off
- Press the **up** and **down** keys to switch between planes of cells
- Press the **left** and **right** to rotate the cube of cells
- Press the **number keys** to load different predesigned seeds
- Press **shift** to unlock the camera.  Now you can:
    - **Click and drag** to rotate the seed around
    - Press **+** to zoom in 
    - Press **-** to zoom out
    - Press **shift** again to go back to editing the seed

When you're happy with your seed, press **enter** to start its evolution.  Here's what you can do now:

- Press **up** and **down** keys to speed up or slow down time
- **Click and drag** to rotate the seed around
- Press **+** to zoom in 
- Press **-** to zoom out

Try shit.  Get one of the predesigned seeds up with the number keys and spell your name
in it.  Draw a happy face in it.  Turn off just the corners.  Click around like a maniac.
If something breaks horribly, then I guess I'm not a very good software engineer - 
restart gump if you want to try again.

##Predesigned Seeds

The odd number keys spawn asymmetrical seeds that evolve into a wierd flat thing with diagonals that will eventually 
collapse.  Number 5 looks *so sweet* when running really fast and looked at the side with all bright colors.

The even number keys spawn symmetrical seeds that have much shorter lifespans, but evolve with really neat structures until 
they collapse.  Number 8 turns into one of the most interesting stable structures I've seen gump produce.

The default seed that pops up when gump starts is symmetrical (it's a closed cube).  It makes a shape like an 8-
sided die that evolves with slowly collapsing structure for many thousands of generations until it collases.

Recurring theme:  They all grow, evolve stably, then collapse.  See if you can make one that doesn't.  ...Or don't.

## Visualization

Runs on [Processing](http://processing.org/) - just download Processing
(tested on 1.51), open gump.pde, and hit the go button in the top left.

Gump visualizes a particular example the computational concept called cellular
automata. A cellular automaton is just a set of rules that describe how
a system evolves. These systems are spatial lattices of cells that form
self-modifying environments, as characterized by the rules. One of the
simplest and most beautiful examples is also the earliest ever discovered,
called Conway's Game of Life (often abbreviated as Life). Life was inspired by
population dynamics of living organisms, and Gump was inpired by Life.

This was the first piece of software that I constructed which I feel is
truly a composition of my own.  While the idea may be something I'm proud of, 
the software engineering practices are not (see heading below).

The automata ruleset exhibits some pretty interesting
characteristics with some experimentation.  If you want a quick example of the
interesting characteristics, meander over to the cubic_init_results directory
and click around.  The seeds are much more interesting to look at as they
evolve, rather than as their run statistics.  See the readme in that directory
to get them going yourself.

#### On Public Abominations

This project has a distinctive workflow:

    1. Get sick of working on other stuff that I hate
    2. Remember that I have a working automaton that I find interesting
    3. Look through the source code and become horrified
    4. Refactor and abstract, testing to make sure I'm not breaking anything
    5. Use the gump's shiny new guts to implement features I want
    6. Continue adding features like a drunk cowboy until the slightest perturbation of code sets my computer on fire
    7. Pour frustrated hours into shoestring-and-duct-tape-fixes for things that the drunk cowboy broke until I hate gump
    8. Work on things that survived the neglegt caused by steps 1-7
    9. GOTO 1

As you'd imagine, this workflow means most of gump's life is spent held together by said shoesttrings and bits of tape, so be warned of:

- Laziness-motivated global variables
- Little and/or meaningless commenting
- Unnecessary abstraction in places, not enough in others
- Inconsisent variable naming

## cGump

*UNDER CONSTRUCTION (under requirements gathering, really)*

A library for expressing and iterating gump environments that is much more efficient
than the Processing visual environment.  Possible goals:
- algorithmically describe different sorts of seeds, ideally in ways that they may be combined,
so that high-level analysis may be done programmatically
- create a good serialization for a gump environment
so that seeds may be made visually and intuitively in Processing, saved to a file, and processed
by the cGump library
