# A.1.1. Exercises
This document lists the exercises proposed for the the ASA course,
lecture 1. There are no standard answers for most of exercises. As such,
you have much freedom to compose a \"good\" answer -- which should be
clearly-written, self-contained, and demonstrate some level of research
effort.

Exercise 0
==========

1.  Define correctness of a program P, in a way that is self-contained
    and ideally, understandable for a layperson.

    A program P is correct if it behaves according to the specification made by the programmer. The specification states how the program should behave. So a program is correct if it behaves as expected for every input. (semantics)

2.  Provide an small, probably artificial C program that is not correct,
    and argue why it is incorrect following your definition.

    ```cpp
    int add(int x, int y) {
        return x - y;
    }
    ```

    This program is semantically incorrect because the function name is sort of the specification which the implementation does not adhere to.

Exercise 1
==========

Dijkstra once put it (in \"J.N. Buxton and B. Randell, eds, Software
Engineering Techniques, April 1970, p. 16): \"Testing shows the
presence, not the absence of bugs\". Argue why (current) testing cannot
show absence of bugs.

A program can possibly have an infinite amount of different paths of execution (a loop for example). It is not possible to test an infinite number of execution paths in finite time. 


Exercise 2
==========

Consider the following program

```cpp
void foo(int x, int y) {
    if (x == y) abort();
    else printf("okay\n");
}
```

Assuming that \"x\" and \"y\" are 32-bit integers, what would be the
probability to trigger \"abort\"?

Up to 2^32 integers can be represented using a 32-bit integer representation. The probability of getting the same one twice is 1/(2^32 * 2^32) = 2^-64.

Correction: We have 2^32, possible combinations of x and y that satisfy the branch condition, making the correct result 2^32 / (2^32 * 2^32) = 2^-32


Exercise 3
==========

Consider a program with a small number of possible execution paths, and
a set of inputs that cover all the paths. All the tests pass without any
problem. Does it imply that the program is necessarily correct? If it is
not the case, make an example program to show argue why.

```java
if (x > y)
    print(x / y);
```
Operations that like I/O, pointer dereferencing, divide by zero, over/underflows.

Correction/Update: If all errors incl. those mentioned above are taken into account as possible paths, then yes, if all paths are explored, then the program should be considered correct. If the intention is thrown when expected the behaviour is correct.


Exercise 4
==========

Consider this program below:

```c
void foo (double x) {
    if (x <= 1.0) x++;
    double y = x * x;
    if (y < 4.0) x--;
}
```

1.  Draw a control flow graph from this program.
2.  Enumerate all its branches.
3.  Find a set of inputs that trigger all the branches.
4.  Enumerate all its paths.
5.  Find a set of inputs that trigger all the paths.

Exercise 5
==========

Suppose that we have a program P and a set of inputs that cover all
branches of P, would the same set of inputs necessarily cover all the
paths? If not, provide an example program and a set of inputs to argue
for your answer.

No. An example is given in the previous exercises.

Exercise 6
==========

In this exercise, we will set up and use the fuzzing tool AFL
(<https://github.com/google/AFL>) to automatically detect bugs in a
small yet nontrivial C program. The detailed instructions on how to
install or use AFL is deliberately left out.

-   First, set up and install AFL. You can either follow the
    instructions on AFL\'s official website shown above, or those I once
    gave on GitHub <https://github.com/zhoulaifu/hello_afl>
    (recommended).
-   Then, try AFL with the \"vulnerable.c\"\" program that you can
    download from
    <https://github.com/mykter/afl-training/blob/master/quickstart/vulnerable.c>
    Compile and play around with the program to see what it does.
-   The program above is known to be buggy. Use AFL to fuzz it.

In this exercise, you are to provide three different inputs for
vulnerable.c that can trigger crashes.

