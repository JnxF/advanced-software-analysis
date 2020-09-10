What
====

This document lists the exercises proposed for the ASA lecture on
07/09/20.

Exercise 1.
===========

(CREDIT: exo adapted from
<https://moves.rwth-aachen.de/wp-content/uploads/WS1415/SPA14/ex/e9.pdf>)

Consider the Reaching Definitions Analysis (RDA). Given a labeled
WHILE-program, this analysis computes for every program location and
every variable all other program locations in which the variable might
have been most recently written (i.e. written without being re-written
in between). As an example, consider the following program.

    l1  x := 2;
    l2  x := 3;
    l3  while y < 10
    l4       y := y + 1;
    l5  x := y * 2;

(x, l2) is a reaching definition at label l4, because there is a path
reaching label l4 such that x is most recently written at label l2. On
the other hand (x, l1) is not a reaching definition at label l4. If the
most recent definition of a variable is “before the program”, this is
indicated by a question mark as the label information. For example, for
label 5 we have the reaching definitions {(y, l4), (y, ?), (x, l2)}.

Have understood this, try to manually analyze the program below:

    l1  x := 2;
    l2  y := x + 2;
    l3  while (x > 3)
            y := y + x;
    l4  x := y;

Your analysis should produce a table like this:

label | reaching definitions 
----- | ------------------
1     | `(x,?)`, `(y,?)`         
2     | `(x, `            
3     | to fill              
4     | to fill              
5     | to fill              

Hint: Try to first produce a sound analysis. Then try to refine it.

Exercise 2
==========

Consider the program

       int x = read_an_integer_from_stdin();
    l1 while (x < 100){
    l2    x++;
    l3 }
    l4 return x;}

Concrete Semantics:

1.  What would be the possible values of "x" at l4?

2.  Assume that x = 1 at l1, describe the trace of states that follow.
    Your output should be a (finite or infinite) sequence of (l,x) where
    l is the label, x is the value .

3.  Based your analysis from 2, what is the value of x when l3 is
    reached in the 30th time?

4.  Now, Assume the variable x can be any positive integer at l1.
    Calculate the set of all possible traces at l1-4. This task can be
    tedious (in particular because the way we express the trace is
    unclear).

    You may consider to illustrate a trace with a table below. It reads
    from up to down and then rightward.

| label |     |     |     |     |     |
|-------|-----|-----|-----|-----|-----|
| l1    | 1   | 2   | …   | 99  |     |
| l2    | 1   | 2   | …   | 99  |     |
| l3    | 2   | 3   |     | 100 |     |
| l4    |     |     |     |     | 100 |

Abstract Semantics:

1.  We now consider an abstract semantics. This one is called prefix
    trace semantics, meaning that we use a prefix of a trace to
    represent a set of traces (finite, or infinite).

    Consider a maximum bound of 3. What would be the possible prefix
    traces?

2.  We now consider another abstract semantics. This one is called
    collecting semantics. For each label l1-4, we collect the possible values of x for all its
possible traces. What is your collecting semantics? Your result should
be formulated as a tuple like (X1, X2, X3, X4) where each X<sub>i</sub>
is a set of integers.

1.  There is information lost in the result obtained in the collecting
    semantics, compared with that of the trace semantics. Please give a
    property that can be shown in the trace semantics, but not in the
    collecting semantics.

2.  Despite of the info loss, with what you get from \#6, can you prove
    absence of integer overflow in l1-l4?

3.  Let X1, X2, X3, and X4 denote the set representing the possible
    values of "x" when lines l1, l2, l3, and l4 respecively, are
    reached. Assuming that "x" can be any positive integer immediately
    before l1 is reached. Write an invariant equation involving X1, X2,
    X3 and X4.

4. Now, Assume the variable x can be any positive integer at l1.
   Calculate the set of all possible traces at l1-4. This task can be
   tedious (in particular because the way we express the trace is
   unclear).

   You may consider to illustrate a trace with a table below. It reads
   from up to down and then rightward.

| label |   |   |     |     |     |
|-------+---+---+-----+-----+-----|
| l1    | 1 | 2 | ... |  99 |     |
| l2    | 1 | 2 | ... |  99 |     |
| l3    | 2 | 3 |     | 100 |     |
| l4    |   |   |     |     | 100 |


Abstract Semantics:

5. We now consider an abstract semantics. This one is called prefix
   trace semantics, meaning that we use a prefix of a trace to
   represent a set of traces (finite, or infinite).

   Consider a maximum bound of 3. What would be the possible prefix
   traces?

6. We now consider another abstract semantics. This one is called
   collecting semantics. For each label l1-4, we collect the possible
   values of x for all its possible traces. What is your collecting
   semantics? Your result should be formulated as a tuple like (X1,
   X2, X3, X4) where each X_i is a set of integers.

7. There is information lost in the result obtained in the collecting
   semantics, compared with that of the trace semantics. Please give a
   property that can be shown in the trace semantics, but not in the
   collecting semantics.

8. Despite of the info loss, with what you get from #6, can you prove
   absence of integer overflow in l1-l4?

9. Let X1, X2, X3, and X4 denote the set representing the possible
   values of "x" when lines l1, l2, l3, and l4 respecively, are
   reached.  Assuming that "x" can be any positive integer immediately
   before l1 is reached. Write an invariant equation involving X1, X2,
   X3 and X4.


   #  X1 = X3 U {1,...max_int}
   #  X2 = X1 \cap {<100}
   #  X3 = X1 + 1
   #  X4 = X1 \cap {x >=100}


# My proposed solutions
# 1.    a value equal or larger than 100.
# 2.
#   (l1,1), (l2,1), (l3,2), (l1,2), (l2,2), (l2,3),...
#   When (l1) is reached the 30th time, we have (l1, 10), (l2, 10), and (l3, 11)
# 3.
#  When (l1) is reached the 30th time, we have (l1, 30), (l2, 30), and
#  (l3, 31)


# 5.
#+BEGIN_COMMENT
| l1 | n (for n<100) |   | ... |  99 |     |
| l2 | n             |   | ... |  99 |     |
| l3 | n plus 1      |   |     | 100 |     |
| l4 |               |   |     |     | 100 |

or

| l1 | 100 |
| l2 |     |
| l3 |     |
| l4 | 100 |
#+END_COMMENT
# 5.
#  (l1,1), (l2,1) (l3,2)
#  (l1,99), (l2,99), (l3,100)
#  (l1,100),(l4,100)
# 6.
# X1= 0,1,2,...; X2=0,...99;  X3=1,...100; X4=100,101...

# 8. or 9
#  (1) An integer overflow can only occur only at the x plus plus statement.
#  (2) An integer overflow occurs for the statement if and only if the value of x is max_int




# More to come
# - Solve the invariant equation manually by iteration.
# - Assuming that x is assigned to 1 immediately before l1. Do
#    exercises 2 and 3 again.