# Effective Floating-Point Analysis via Weak-Distance Minimization

Problems:
* Random testing
* Boundary input generation
* Solving numerical constraints
* All of them are reduced to search problems!

Today: weak-distance minimization:
* Do not analyze floating-point programs.
* Focus on how to run them efficently.
* Theoretical guarantee.

Weak distance S:
* Cannot make a _distance_ if S is unknown.
* Can be done if it is weak.
* Minimize W as a mathematical optimizaiton, looking for 0.
* Properties: W(x) is non-negative, W(x) = 0 iif x reaches S, W is continuous.
* Get the weak distance W from the syntax of Prog.

Key point:
* The semantic meaning of a floating-point program makes little sense.

Solving numerical constraints:
* Given an and, an or or an operation within expressions

Another problem:
* Path reachability: what makes this path triggers?

Finding overflows:
* Compute w = |t| < MAX ? MAX - |t| : 0