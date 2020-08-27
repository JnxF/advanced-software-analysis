# A.1.2. Exercises

This document lists the exercises proposed for the ASA lecture on Day 2.

Exercise 0 \[Concept of Boundary Inputs\]
=========================================

-   Please list two boundary inputs for the following C program

```c
void FOO (double x){
    a = x * x;
    b = a * a
    if (a < b) ...;
}
```

When a == b, so x*x == (x\*x)\*(x\*x). So 0, 1 and -1.

-   Can you list more than one boundary inputs for the Python program
    FOO below, in which the input \"x\" is a 64-bit floating-point
    number.

```python
def FOO(x):
   if x < 1.0:
       y= x + 1
       if y>=2: raise Exception ("UNEXPECTED! Input %.17f" %x)
```
So x = 1 and x = 0.99999 with many nines.

Exercise 1. \[Local Optimization\]
==================================

Define the function f(x) as (x-1)\*\*2 \* (x-2)\*\*2, where \"x\" is a
double number, \"\*\*\" refers to the power operator.

-   What is the minimum of f? And, where on the x-axis does f reach its
    minimum? To get the intuition, one may observe a the graph of f using Google, by copying the expression to the search engine.

    The minima are x in {1, 2}.

-   Please provide a small proof on f\'s minimum. Hint: First, prove
    f(x)\>=0, and then prove that f(x) can actually reach 0 for
    certain x.

    The function is always positive or 0 as it is a product of two squares. It can also reach 0, with x = 1 or 2. So the minima are reached with x = 1 or 2.

-   Please also experiment with Python\'s scipy.optimize.minimize
    function to find the minimum of f automatically. The interface of
    the Python function can be found at
    <https://docs.scipy.org/doc/scipy/reference/generated/scipy.optimize.minimize.html>
    You probably need to install scipy. And, for your coding, you will
    need to provide an \"initial guess\" for the function\'s input.

    ```python
    >>> def f(x):
    ...     return (x-1)**2 * (x-2)**2
    ...
    >>> import scipy.optimize
    >>> scipy.optimize.minimize(f, 2)
          fun: array([0.])
     hess_inv: array([[1]])
          jac: array([1.49011616e-08])
      message: 'Optimization terminated successfully.'
         nfev: 3
          nit: 0
         njev: 1
       status: 0
      success: True
            x: array([2.])
    ```

Exercise 2 \[Global Optimization\]
==================================

Consider an artificial function g(x)= ((x - 1) \*\* 2 -4) \*\* 2 + f(x)
where f(x) is defined to be (x - 1.5) \*\* 2 if x \> 1.5 or 0 otherwise.

Find the function\'s global minimum with Python\'s
scipy.optimize.basinhopping method. Its usage can be found at
<https://docs.scipy.org/doc/scipy-0.18.1/reference/generated/scipy.optimize.basinhopping.html>
Your calculated minimum should be close to 0. If it is not the case, try
to augment your iteration numbers (which is the \"niter\" parameter of
scipy.optimize.basinhopping).

To visualize the function, which is not necessary but can help you get
some intuitions, you can also check the graph shown in Fig. 3 (a) of the
paper <http://zhoulaifu.com/wp-content/papercite-data/pdf/xsat.pdf>

```python
>>> def g(x):
...     return ((x - 1) ** 2 - 4) ** 2 + ((x-1.5)**2 if x > 1.5 else 0)
>>> import scipy.optimize
>>> scipy.optimize.basinhopping(g, 0, niter = 5000)
                        fun: 1.3492296857289115e-19
 lowest_optimization_result:       fun: 1.3492296857289115e-19
 hess_inv: array([[0.03122633]])
      jac: array([2.35480023e-07])
  message: 'Optimization terminated successfully.'
     nfev: 27
      nit: 5
     njev: 9
   status: 0
  success: True
        x: array([-1.])
                    message: ['requested number of basinhopping iterations completed successfully']
      minimization_failures: 0
                       nfev: 298929
                        nit: 5000
                       njev: 99643
                          x: array([-1.])
```

Exercise 3. \[Limitation of Local/Global Optimization\]
=======================================================

Consider a characteristic function f(x) = 0 if x == 100, else 1. What is
the minimum of the function?

-   First, do this manually.

The minimum is 0 at x = 100.

-   Then, try to get an answer using scipy.optimize.minimize (the local
    optimization tool), or scipy.optimize.basinhopping (the global
    optimization tool). You may use different starting points, e.g. 0,
    10, 100, 1000.

```python
def f(x): return 0 if x == 100 else 1
import scipy.optimize
N = 100
scipy.optimize.minimize(f, N)
```



Exercise 4. \[Finding bugs with Boundary Value Analysis\]
=========================================================

In this exercise, we will automatically uncover a bug through testing
boundary values. The bug is coded as the raised exception shown in the
code below.

```python
def FOO(x):
    if x < 1.0:
        y= x + 1
        if y>=2: raise Exception ("UNEXPECTED! Input %.17f" %x)
```

If we reason with traditional math, the program should never trigger the
exception. However, if we set the input to a number close to but
strictly smaller than 1, that is 0.999 999 999 999 999 9, the branch "if
(x \< 1)" will be taken, but after \"y = x + 1\", the subsequent "if (y
\>= 2)" will also be taken, which can be unexpected.

The aim of this exercise is to automatically cover such boundary inputs.
You are suggested to take the following step:

1.  First, transform the program FOO to another program, denoted by R,
    in which you insert r = r \* (x - 1) \*\* 2 and r = r \* (y-2) \*\*
    2 before the two branches, and return the value of r in the end.
2.  Then, retrieve the value of \"r\" through the following code

```python
def R(x):
    r=FOO_I(x)
    return r
```

1.  Minimize R with scipy.optimize.basinhopping. Probably you will need
    to provide an iteration number larger than the default one (the
    default iteration number of scipy.opitimize.basinhopping is
    niter=100 as shown in
    <https://docs.scipy.org/doc/scipy-0.18.1/reference/generated/scipy.optimize.basinhopping.html>)
    During the minimization procedure, you should see the exception
    raised

```python
def FOO_I(x):
    r = 1
    r *= (x - 1.0) ** 2
    if x <= 1.0:
        y= x + 1
        r = r * (y - 2)**2
        if y>=2: raise Exception ("UNEXPECTED! Input %.17f" %x)
    return r

def R(x):
    r=FOO_I(x)
    return r

import scipy.optimize
scipy.optimize.basinhopping(R, 0, niter=1000,minimizer_kwargs={'method': 'powell'})

```

Exercise 5. \[General Algorithm\]
=================================

Assume that a C function FOO has the interface

```c
void FOO(double x)
```

The body of the C code includes a set of 10 branches of the form

```c
if (a_i op_i b_i)
```

with i ranging from 1 to 10, and op~i~ being one of {\<, \<=, ==, !=,
\>=, \>}.

-   What is a boundary input of the function FOO?
-   Devise an algorithm for automatically building a function R so that
    one can find FOO\'s boundary input through minimizing R.