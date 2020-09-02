import numpy as np
import scipy.optimize as op


def mcmc(func, start_point=0, niter=10, method="powell"):
    tol = 1e-10

    def callback_global(x, f, accepted):
        conclusion = "good!" if f < tol else "not good enough"
        print("MCMC Sampling:: At x=%.10f,  f=%g,  ==> %s" % (x, f, conclusion))

    op.basinhopping(
        func,
        start_point,
        callback=callback_global,
        minimizer_kwargs={"method": method},
        niter=niter,
        stepsize=20,
    )


def square(x):
    return x * x


def FOO(x):
    if x <= 1.0:
        x = x + 1

    y = square(x)
    if y == 4.0:
        x = x - 1


def weak_distance(x):
    r = 0
    r += 0 if x <= 1.0 else (x - 1.0) ** 2
    if x <= 1.0:
        x = x + 1

    y = square(x)
    r += (y - 4.0) ** 2
    if y == 4.0:
        x = x - 1

    return r


if __name__ == "__main__":
    mcmc(weak_distance)
