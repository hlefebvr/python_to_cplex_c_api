import cplex_c_api_wrapper as cplex

print("**********************************************************")
print("**********************************************************")

class MyCallback(cplex.Callback):

    def __call__(self):

        print("Python callback called from event " + str(self.wherefrom))
        
        lp = cplex.CPXgetcallbacknodelp(self.env, self.cbdata, self.wherefrom)
        cplex.CPXwriteprob(self.env, lp, "test.lp")

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
        2,  10
]
rhs = [30, 10, 15, 15]
rownames = ["c1", "c2", "c3", "c4"]

cplex.CPXaddrows(env, model, 0, 4, len(rmatval), rhs, rtypes, rmatbeg, rmatind, rmatval, None, rownames)

# Set some parameters
cplex.CPXsetintparam(env, cplex.CPX_PARAM_SCRIND, cplex.CPX_ON)
#cplex.CPXsetintparam(env, cplex.CPX_PARAM_PREIND, cplex.CPX_OFF)
cplex.CPXsetintparam(env, cplex.CPX_PARAM_STARTALG, cplex.CPX_ALG_PRIMAL)
cplex.CPXsetintparam(env, cplex.CPX_PARAM_SUBALG, cplex.CPX_ALG_DUAL)

# Set callback
cb = MyCallback()
cplex.CPXsetlazyconstraintcallbackfunc(env, cb)

# Solve problem
cplex.CPXmipopt(env, model)

cplex.CPXfreeprob(env, model)
cplex.CPXcloseCPLEX(env)
