import cplex_c_api_wrapper as cplex

env = cplex.CPXopenCPLEX()

model = cplex.CPXcreateprob(env, "model")

# Add columns
numcols = 2;
ctypes = ['I', 'I']
obj = [-1,-10]
lb = [0, 0]
ub = [cplex.CPX_INFBOUND, cplex.CPX_INFBOUND]
colnames = ["x", "y"]

cplex.CPXnewcols(env, model, numcols, obj, lb, ub, ctypes, colnames)

# Add rows
rtypes = ['L', 'L', 'L', 'G']
rmatbeg = [0, 2, 4, 6]
rmatind = [
        0, 1,   # -25x + 20y
        0, 1,   #  x  + 2y
        0, 1,   #  2x -  y
        0, 1    #  2x + 10y
]
rmatval = [
        -25, 20,
        1,   2,
        2,  -1,
        -2,  -10
]
rhs = [30, 10, 15, -15]
rownames = ["c1", "c2", "c3", "c4"]

cplex.CPXaddrows(env, model, 0, 4, len(rmatval), rhs, rtypes, rmatbeg, rmatind, rmatval, None, rownames)

# Write problem to a file
cplex.CPXwriteprob(env, model, "test.lp")

cplex.CPXsetintparam(env, cplex.CPX_PARAM_SCRIND, cplex.CPX_ON)

# Solve problem
cplex.CPXmipopt(env, model)

cplex.CPXfreeprob(env, model)
cplex.CPXcloseCPLEX(env)