import cplex_c_api_wrapper as cplex

class MyBranchCallback(cplex.BranchCallback):
     
     def __init__(self):
          pass
     
     def __call__(self):

        print("*************************************")
        print("        BranchCallback Begin         ")
        print("*************************************")

        print("Python branch callback called with event " + str(self.wherefrom) + '.')

        print("*************************************")
        print("         BranchCallback End          ")
        print("*************************************")

        return cplex.CPX_CALLBACK_DEFAULT


class MyLazyConstraintCallback(cplex.LazyConstraintCallback):

    def __init__(self, model):
        self.model = model
        self.cut_has_been_added = False

    def __call__(self):

        print("*********************************************")
        print("        LazyConstraintCallback Begin         ")
        print("*********************************************")

        print("Python lazy constraint callback called with event " + str(self.wherefrom) + '.')

        if self.cut_has_been_added:
            
                print("Cut has already been added, exiting.")


                print("*********************************************")
                print("         LazyConstraintCallback End          ")
                print("*********************************************")

                return

        # Get Node's Problem
        lp = cplex.CPXgetcallbacknodelp(self.env, self.cbdata, self.wherefrom)

        # Get Number of Columns and Constraints
        n_cols = cplex.CPXgetnumcols(self.env, lp)
        n_rows = cplex.CPXgetnumrows(self.env, lp)

        # Get Current Solution
        x = cplex.CPXgetx(self.env, lp, 0, n_cols - 1)
        print("Node solution = ", x)

        # Get Current Bounds
        lb = cplex.CPXgetlb(self.env, lp, 0, n_cols - 1)
        ub = cplex.CPXgetub(self.env, lp, 0, n_cols - 1)
        print("LB = ", lb)
        print("UB = ", ub)

        # Get Row Sense
        sense = cplex.CPXgetsense(self.env, lp, 0, n_rows - 1)
        print("sense = ", sense)

        # Get Basis
        (rstat, cstat) = cplex.CPXgetbase(self.env, lp)
        print("rstat = ", rstat)
        print("cstat = ", cstat)

        # Get Basis Head 
        (head, x) = cplex.CPXgetbhead(self.env, lp)
        print("head = ", head)
        print("x = ", x)

        # Get Binvacol
        print("Binvacol[0] = ", cplex.CPXbinvacol(self.env, lp, 0))

        # Get Rows
        print("First two rows: ", cplex.CPXgetrows(self.env, lp, 0, 1))

        # Get RHS
        print("Fisrt two rhs: ", cplex.CPXgetrhs(self.env, lp, 0, 1))

        # Add Cut
        cplex.CPXcutcallbackadd(self.env, self.cbdata, self.wherefrom, 1, 5, 'G', [0],[1],0)
        self.cut_has_been_added = True
        print("Added cut")

        # Write Model to a File
        cplex.CPXwriteprob(self.env, lp, "test.lp")
        print("Exiting callback")

        print("*********************************************")
        print("         LazyConstraintCallback End          ")
        print("*********************************************")



# Create Environment
env = cplex.CPXopenCPLEX()

# Create Model
model = cplex.CPXcreateprob(env, "model")

# Change Objective Sense
cplex.CPXchgobjsen(env, model, cplex.CPX_MIN)

# Add Columns
numcols = 2;
ctypes = ['I', 'I']
obj = [-1,-10]
lb = [0, 0]
ub = [cplex.CPX_INFBOUND, cplex.CPX_INFBOUND]
colnames = ["x", "y"]

cplex.CPXnewcols(env, model, numcols, obj, lb, ub, ctypes, colnames)

# Add Rows
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

# Set Parameters
cplex.CPXsetintparam(env, cplex.CPX_PARAM_SCRIND, cplex.CPX_ON)
cplex.CPXsetintparam(env, cplex.CPX_PARAM_MIPDISPLAY, 5)
cplex.CPXsetintparam(env, cplex.CPX_PARAM_MIPCBREDLP, cplex.CPX_OFF)
cplex.CPXsetintparam(env, cplex.CPX_PARAM_PREIND, cplex.CPX_OFF)
cplex.CPXsetintparam(env, cplex.CPX_PARAM_STARTALG, cplex.CPX_ALG_PRIMAL)
cplex.CPXsetintparam(env, cplex.CPX_PARAM_SUBALG, cplex.CPX_ALG_DUAL)
cplex.CPXsetintparam(env, cplex.CPX_PARAM_HEURFREQ, -1)
cplex.CPXsetintparam(env, cplex.CPX_PARAM_CUTPASS, -1)

# Set Lazy Constraint Callback
lazyconcb = MyLazyConstraintCallback(model)
#cplex.CPXsetlazyconstraintcallbackfunc(env, lazyconcb)

# Set Branch Callback
branchcb = MyBranchCallback()
cplex.CPXsetbranchcallbackfunc(env, branchcb)

# Solve Problem
cplex.CPXmipopt(env, model)

# Free Model
cplex.CPXfreeprob(env, model)

# Free Environment
cplex.CPXcloseCPLEX(env)
