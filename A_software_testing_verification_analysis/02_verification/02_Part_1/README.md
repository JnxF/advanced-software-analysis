# What

This document lists the exercises proposed for the ASA lecture on
31/08/20.

# Exercise 0 \[Concept of Satisfiability\]

Formally speaking, we say a constraint c is satisfiable in a theory T if
a model m for the constraint exists. Explain what is c, T, and m in the
following statements. Note that T is often implicit in such statements.

-   a + b = 5 is satisfiable, where a and b are two integers integers
    because, as an example, 2 + 3 = 5

    c: a + b = 5

    T: Integer arithmetic

    m: a = 2, b = 3

-   a \* a \< 0 is unsatisfiable, where a is a real number, because
    square of any real number must be nonnegative.

    C: a*a < 0

    T: Real arithmetic (cf. complex numbers)

    m: N/A


-   x \< 1 /\\ x + 1 == 2 is satisfiable, where x is a floating-point
    number, because the floating-point number 0.999 999 999 999 999 9
    can be a solution to the constraint.

    c: x < 1, x + 1 == 2

    T: Floating-point number arithmetic

    M: x = 0.999 999 999 999 999 9


# Exercise 1 \[Solving satisfiability with some common sense and math\]


-   Is x \* x \> 1 /\\ x \> 1 satisfiable, where x is a real number?

    Yes, for all x > 1. A model is x = 2.

-   Is 2 \* x = 101 satisfiable, where x is a integer?
	
    No, because 2 does not divide 101.

-   Is 2 \*\* x \<= 5 satisfiable, where x is an real ? (\*\* is for the
    power operator)

    Yes, for x <= log2(5) ≈ 2.32. A model is x = 2.


-   Is (p1 \\/ ¬p2) /\\ (¬p1 ∨ p2 ∨ p3) /\\ p3 satisfiable where p1, p2
    and p3 are boolean variables?


    There are two models: {p1 = true, p2 = true, p3 = true} and {p1 = true, p2 = false, p3 = true}.

# Exercise 2 \[Converting constraints to their conjunctive normal forms (CNF)\]


Determine whether the constraints below are already in CNF. If not, convert them to CNF.
1. (A ∨ B) ∧ C
2. C ∨ (A ∧ B) = (C ∨ A) ∧ (C ∨ B) (distributive law)
3. ¬ (A ∨ B ∨ C) = ¬ A ∧ ¬ B ∧ ¬ C (de morgans)
4. ¬ (A ∧ B ∧ C) = ¬ A ∨ ¬ B ∨ ¬ C (de morgans)
5. (A ∧ B) ∨ (C ∧ D) = (A ∨ (C ∧ D)) ∧ (B ∨ (C ∧ D)) = (A ∨ C) ∧ (A ∨ D) ∧ (B ∨ C) ∧ (B ∨ D) (distributive law)


# Exercise 3

Solve the following constraint with Microsoft Z3:
<https://rise4fun.com/z3/tutorial>.

    a * a = 3 and a >= 0

Some research is to be done to write a SMT-LIB specification of the
formula. You can get started with this one, which we used in the class:

    (declare-const x Real)
    (declare-const y Real)
    (declare-const z Real)
    (assert (=(-(+(* 3 x) (* 2 y)) z) 1))
    (assert (=(+(-(* 2 x) (* 2 y)) (* 4 z)) -2))
    (assert (=(-(+ (- 0 x) (* 0.5 y)) z) 0))
    (check-sat)
    (get-model)

Our code:

    (declare-const a Real)
    (assert (= 3 (* a a)))
    (assert (>= a 0))
    (check-sat)
    (get-model)

The model:

    sat
    (model 
    (define-fun a () Real
        (root-obj (+ (^ x 2) (- 3)) 2))
    )


# Exercise 4 \[Global Optimization (recall)\]

We use an exercise from previous session to get more experiences for
finding function minimum. Consider the artificial function g(x)= ((x -
1) \*\* 2 -4) \*\* 2 + f(x) where f(x) is defined to be (x - 1.5) \*\* 2
if x \> 1.5 or 0 otherwise.

Find the function\'s global minimum with Python\'s
scipy.optimize.basinhopping method. Its usage can be found at
<https://docs.scipy.org/doc/scipy-0.18.1/reference/generated/scipy.optimize.basinhopping.html>.

_Skipped_

# Exercise 5 \[Solving a non-trivial constraint with optimization tools\]


Consider the following constraint:

    2 ** x <= 5 /\ x ** 2 >= 5 /\ x >= 0

where x is considered to be a floating-point number.

-   First, derive a mathematical function R(x) such that R(x)=0 if and
    only if x is a model to the constraint.

    R(X) = R1(X) + R2(X) + R3(X) where
    
    R1(X) = 2^x <= 5 ? 0 : (2^x - 5)^2 

    R2(X) = x^2 >= 5 ? 0 : (5 - x^2)^2

    R3(X) = x >= 0 ? 0 : x**2. 

    The function is minimized iff sqrt(5) <= X <= log2(5).

    


-   Then, minimize R using scipy.optimize.basinhopping, which you should
    be familiar with through the previous exercise.

    ```python
    import numpy as np
    import scipy.optimize as op
    # Exercise 5
    
    def R(x):
        constraint_1_val = 0 if 2 ** x <= 5 else ((2 ** x) - 5)**2
        constraint_2_val = 0 if x ** 2 >= 5 else (5 - (x ** 2))**2
        constraint_3_val = 0 if x >= 0 else (0 - x**2)**2
        
        return constraint_1_val + constraint_2_val + constraint_3_val
    
    def mcmc(func, start_point=0, niter=500,method='powell'):
        tol=1e-16
        def callback_global(x,f,accepted):
            conclusion= 'good!' if f<tol else "not good enough"
            print("MCMC Sampling:: At x=%.10f,  f=%g,  ==> %s" % (x,f,  conclusion))
    op.basinhopping(func,start_point,callback=callback_global,minimizer_kwargs={'method':'powell'},niter=niter,stepsize=10) 
        
    mcmc(R)
    ```

    Some execution trace:

    ```
    MCMC Sampling:: At x=2.2584131207,  f=0,  ==> good!
    MCMC Sampling:: At x=2.2517777871,  f=0,  ==> good!
    MCMC Sampling:: At x=2.3016561119,  f=0,  ==> good!
    MCMC Sampling:: At x=2.2785524408,  f=0,  ==> good!
    MCMC Sampling:: At x=2.3024851929,  f=0,  ==> good!
    MCMC Sampling:: At x=2.2811635025,  f=0,  ==> good!
    MCMC Sampling:: At x=2.2649103589,  f=0,  ==> good!
    MCMC Sampling:: At x=-1.5811388092,  f=12.5,  ==> not good enough
    MCMC Sampling:: At x=2.2910585767,  f=0,  ==> good!
    MCMC Sampling:: At x=2.2492535283,  f=0,  ==> good!
    ```

    Analytically, R is 0 iff sqrt(5) <= X <= log2(5); or, approximately 2.2360 <= X <= 2.3219; so the program looks to work fine.


-   At last, try to solve it with Microsoft Z3. Compare the results with
    above.

We cannot solve it using Z3. With the following constraints:

```
(declare-const x Real)
(assert(>= (^ 2 x) 5))
(check-sat)
(get-model)
```

No model can be found:
```
unknown
(model 
)
```