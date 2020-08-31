# Satisfiability and floating-point Satisfiability solving

Satisfability solving useful for:
* Planning
* Scheduling
* Constraint Solving
* Systems Biology
* Invariant Generation
* Type checking
* Model based testing
* Termination

Z-3 can solve satisfactibility equations

Example:
* b+2 = c, f(read(write(a, b, 3), c-2)) != f(c-b+1)
* is UNSAT 

Floating-point satisfiability:
* Conjunctive Normal Form

Floating-point CNF:
* Solve sin(x) == x and x >= 10e-10
* Cannot solve sin(x) == x
* sin is not standarized

Approach:
* Create distance R from all the inputs that satisfy K to x.
* Minimize x.

Systematically:
* x == y is (x-y)**2
* x <= y is x <= y ? 0 : (x-y)**2
* k1 ^ k2 is R1 + R2
* k1 v k2 is R2 * R2