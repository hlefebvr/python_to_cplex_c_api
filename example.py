import cplex_c_api_wrapper as cplex

print("**********************************************************")
print("**********************************************************")

class MyCallback(cplex.Callback):

    def __init__(self, model):
        self.model = model

    def __call__(self):

        print("Python callback called from event " + str(self.wherefrom))

        # Get node's problem
        lp = cplex.CPXgetcallbacknodelp(self.env, self.cbdata, self.wherefrom)

        # Get number of columns and constraints
        n_cols = cplex.CPXgetnumcols(self.env, lp)
        n_rows = cplex.CPXgetnumrows(self.env, lp)

        # Get current solution
        x = cplex.CPXgetx(self.env, lp, 0, n_cols - 1)
        print("Node solution = ", x)

        # Get current bounds
        lb = cplex.CPXgetlb(self.env, lp, 0, n_cols - 1)
        ub = cplex.CPXgetub(self.env, lp, 0, n_cols - 1)
        print("LB = ", lb)
        print("UB = ", ub)

        # Get row sense
        sense = cplex.CPXgetsense(self.env, lp, 0, n_rows - 1)
        print("sense = ", sense)

        # Get basis
        (rstat, cstat) = cplex.CPXgetbase(self.env, lp)
        print("rstat = ", rstat)
        print("cstat = ", cstat)

        # Get basis head 
        (head, x) = cplex.CPXgetbhead(self.env, lp)
        print("head = ", head)
        print("x = ", x)

        # Get Binvacol
        print("Binvacol[0] = ", cplex.CPXbinvacol(self.env, lp, 0))

        # Add cut
        cplex.CPXcutcallbackadd(self.env, self.cbdata, self.wherefrom, 1, 5, 'G', [0],[1],0)
        print("Added cut")

        # Write problen to a file
        cplex.CPXwriteprob(self.env, lp, "test.lp")
        print("Exiting callback")


# Create environment
env = cplex.CPXopenCPLEX()

# Create model
model = cplex.CPXcreateprob(env, "model")

# Change objective sense
cplex.CPXchgobjsen(env, model, cplex.CPX_MIN)

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
cb = MyCallback(model)
cplex.CPXsetlazyconstraintcallbackfunc(env, cb)

# Solve problem
cplex.CPXmipopt(env, model)

# Free model
cplex.CPXfreeprob(env, model)

# Free environment
cplex.CPXcloseCPLEX(env)
