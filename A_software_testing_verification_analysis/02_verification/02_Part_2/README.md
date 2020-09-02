What
====

This document lists the exercises proposed for the ASA lecture on
02/09/20, the morning session.

Exercise 0 \[Problem Reduction\]
================================

Problem reduction is a common term in computability theory. Simply
speaking, a problem A reduces to a problem B if solving B allows for a
solving A.

-   Let f be a scalar function whose output is a real number. Suppose
    that we have a tool for finding the minimum of any function, can we
    use the same tool to find the maximum of \"f\"?

    minimize(-f)

-   Suppose that we have a local opitmization implementation that can
    precisely calculate a local minimum given a starting point, for any
    function f(double x). Can I use the one to also get the global
    minimum of any function? (this exo has a trap)

    It is not feasible, as you would have to run the local optimization over the entire input space (which happens to be 2^64).

-   Suppose that we have a solver that determines satisfiability for all
    floating-point constraints involving \<=, ==, logic AND, and logic
    OR. Can we use the same solver to solve an arbitrary floating-point
    constraint \"\<\", \"!=\", and \"\>\" ?

    Hint: Consider to use numpy.nextafter to deal with \"\<\".
    <https://numpy.org/doc/stable/reference/generated/numpy.nextafter.html>

    - If given an x < y constraint, use a x <= nextafter(b, -inf) constraint.
    - If given a x == y constraint, use a x < y OR x > y.
    - If given a x > y constraint, use a y < x (sic!) constraint, as implemented before.


Exercise 1 \[Principles for constructing a weak-distance\]
==========================================================

In the previous lecture, we explained how we would construct a
nonnegative program R (called weak distance in today\'s lecture)
corresponding to a conjunctive normal form (CNF), such that R\'s roots
are the models of the constraint. In particular, for an CNF in the form
of c~1~ AND c~2~, we can construct R as R~1~ + R~2~ where each R~i~
corresponds to c~i~.

As explained in today\'s lecture, there is not a standard weak distance.
An alternative way to construct R is R(x) = max (R1(x), R2(x)), where
\"max\" takes two inputs and returns the larger number. Please justify
this way of constructing R.

1. Property 1. R (x) >= 0. Is true because any positive input that is input into the max function will result in the max function returning a positive number. (If all the arguments of the max function are non-negative, so it is their maximum).

2. Property 2. R (x) = 0 if and only if x is a boundary input. This also holds as R(x) is 0 if and only all the R_i(x) are x, which means that all the constraints hold and thus x is a boundary input.


Exercise 2 \[An implicit condition for constructing the weak distance\]
=======================================================================

Consider the constraint x \* x = 4, and the two following weak distances
for the constraint:

-   R_try1 is abs (x \* x - 4)

-   R_try2 is 0 if x \* x == 4 or 1 otherwise.

Try to solve the constraints, using scipy.optimize.basinhopping with
R_try1 and R_try2.

R: it is going to work fine for R_try1 as it is convex, but it will not work for R_try2, as it has two discontinuity points at x = -2 and at x = 2. Those points cannot be found efficiently by minimization techniques, which rely on the smoothness of the analyzed function.

Exercise 3 \[Path reachability\]
================================

Try to solve the path reachability problem illustrated in our lecture by
constructing a weak distance. You can fill in \"put your implementation
here\" in the python code below and then run it.

```
import numpy as np
import scipy.optimize as op

def mcmc(func, start_point=0, niter=10,method='powell'):
    tol=1e-10
    def callback_global(x,f,accepted):
        conclusion= 'good!' if f<tol else "not good enough"
        print("MCMC Sampling:: At x=%.10f,  f=%g,  ==> %s" % (x,f,  conclusion))
    op.basinhopping(func,start_point,callback=callback_global,minimizer_kwargs={'method':method},niter=niter,stepsize=20)

def square(x): return x*x

def FOO(x):
    if x <= 1.0:
        x = x + 1

    y = square(x)
    if y == 4.0:
        x = x - 1

def weak_distance(x):
    # put your implementation here
    return 0

if __name__=="__main__":

    mcmc(weak_distance)
```

The trace reveals that -3 and 1 are faulty values.

```bash
➜  02_Part_2 git:(master) ✗ python3 reachability.py
```
```python
MCMC Sampling:: At x=-3.0000000000,  f=2.01948e-28,  ==> good!
MCMC Sampling:: At x=-3.0000000000,  f=0,  ==> good!
MCMC Sampling:: At x=-3.0000000000,  f=0,  ==> good!
MCMC Sampling:: At x=1.0000000000,  f=7.2138e-22,  ==> good!
MCMC Sampling:: At x=-3.0000000000,  f=0,  ==> good!
MCMC Sampling:: At x=1.9385369924,  f=0.939452,  ==> not good enough
MCMC Sampling:: At x=1.0000000000,  f=3.0876e-21,  ==> good!
MCMC Sampling:: At x=-3.0000000000,  f=1.96931e-26,  ==> good!
MCMC Sampling:: At x=-3.0000000000,  f=0,  ==> good!
MCMC Sampling:: At x=1.9385371912,  f=0.939452,  ==> not good enough
```

Exercise 4 \[Sanitizer\]
========================

This exercise aims to illustrate a simple and practical tool that you
may use directly in testing (which relates more to our previous
lectures).

Consider the following C program

    #include <stdio.h>
    int main(){
      int a[3]={0,1,2};
      for (int i=0; i<=3; i++)
        printf("value of a[%d] is %d\n",i, a[i]);
    }

-   What would be the output of this program? Will the code fail, or
    not? Try it.
    ```bash
    gcc small.c
    ```

    The result (by `./a.out`) is

        value of a[0] is 0
        value of a[1] is 1
        value of a[2] is 2
        value of a[3] is 1258946780

    It does not fail, but gives a wrong result.

-   If you are to develop a tool for detecting this kind of bug, how
    would you do it? This is an open question. Consider first, for
    example, whether you would like use static or run-time analysis.


-   Follow the instructions from
    <https://github.com/zhoulaifu/hello_sanitizer> to detect this bug
    automatically. Briefly speaking, you are to compile the program with
    a compiler option known as the address sanitizer; then you can
    detect the bug via running it.

    Compile with

    ```bash
    gcc small.c -fsanitize=address
    ```

    Result:
    ```python
    value of a[0] is 0
    value of a[1] is 1
    value of a[2] is 2
    =================================================================
    ==7644==ERROR: AddressSanitizer: stack-buffer-overflow on address 0x7ffeee31d88c at pc 0x0001018e2d2f bp 0x7ffeee31d850 sp 0x7ffeee31d848
    ```

Exercise 5 \[Construct a weak-distance for detecting overflow\]
===============================================================

Computing the average of two numbers x and y directly with (x+y)/2 can
have a floating-point overflow (which could be then exploited). Try to
reproduce such an overflow with a weak-distance.

You are to implement the function \"wd\" below. Running the code below,
with a well-defined \"wd\" function, should help you find a pair of
floating-point numbers such as (9e+307, 9e+307), noting that the largest
floating-point number is about 1.79e+308 (which can be produced by
\"sys.float_info.max\" in python\'s sys module).
```python
def average(X):
        x=X[0]
        y=X[1]
        ret = (x+y)/2.0
        return wd(ret)

if __name__=="__main__":

        print (op.basinhopping(average,[1,1], niter=100,stepsize=1e2, minimizer_kwargs={'method':'nelder-mead'}))
```

A simple wd function doesn't work:
```python
def wd(a): return 0 if a > MAX else np.abs(a - MAX)
```

The problem is that `wd` does not work for low values:

```python
>>> wd(0) == wd(100)
True
>>> wd(0) == wd(1e200)
True
>>> wd(0) == wd(1e300)
False
```

The logarithm comes to the rescue:

```python
def wd(a):
    return 0 if a == math.inf else np.log(MAX) - np.log(np.abs(a))
```

Trace:
 
```python
                        fun: 0.0
 lowest_optimization_result:  final_simplex: (array([[9.04808581e+307, 9.04808581e+307],
       [9.04808581e+307, 9.04808581e+307],
       [            inf,             inf]]), array([0., 0., 0.]))
           fun: 0.0
       message: 'Maximum number of function evaluations has been exceeded.'
          nfev: 402
           nit: 260
        status: 1
       success: False
             x: array([9.04808581e+307, 9.04808581e+307])
                    message: ['requested number of basinhopping iterations completed successfully']
      minimization_failures: 8
                       nfev: 21716
                        nit: 100
                          x: array([9.04808581e+307, 9.04808581e+307])
```