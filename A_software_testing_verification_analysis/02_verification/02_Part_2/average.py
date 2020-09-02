import sys
import numpy as np
import scipy.optimize as op
import math

MAX = sys.float_info.max

# def wd(a): return 0 if a > MAX else np.abs(a - MAX)
def wd(a):
    return 0 if a == math.inf else np.log(MAX) - np.log(np.abs(a))


def average(X):
    x = X[0]
    y = X[1]
    ret = (x + y) / 2.0
    return wd(ret)


if __name__ == "__main__":
    print(
        op.basinhopping(
            average,
            [1, 1],
            niter=100,
            stepsize=1e2,
            minimizer_kwargs={"method": "nelder-mead"},
        )
    )
