# Modern Software Techniques for Automated Testing (Part 2)

Sanitizer:
* Using -fsanitize=address to detect bug in a[i] access.
* Fully automated.

Boundary values:
* More valuable that regular values.
* E.g. values triggering == in if (x >= y) or something close.
* The problem is known as boundary value analysis.
* Considered extremely difficult problem.

Problems with float numbers:
* `if (x < 1) x++;` and then `assert(x < 2)` may not be correct.
* The example is 0.9999...9 with many 9s.

Why:
* Security hole.
* CS and maths related.

Boundary inputs:
* A(P): arithmetic conditions of program _P_ namely b: x OP y, where OP can be {<=, z, ==, >, >=}
* ^b is the boundary form of b, that denotes x == y.
* The boundary values are BV(P) = {^b | b in A(P)}

How random testing would work:
* Finding a needle in a haystack.

Boundary Value Analysis:
* Fundamentaly a math problem.
* Solve the matah problem
* Interpret the results.

The trick:
* Introducing a new variable that is 0 if boundary cases are detected.
* Then the function is (local) optimized.

Challenges:
* With many local minimum.
* 