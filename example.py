import cplex_c_api_wrapper as cplex

env = cplex.CPXopenCPLEX()

model = cplex.CPXcreateprob(env, "model")

numcols = 2;
types = ['I', 'I']
obj = [-1,-10]
lb = [0, 2]
ub = [cplex.CPX_INFBOUND, cplex.CPX_INFBOUND]
colnames = ["x", "y"]

cplex.CPXnewcols(env, model, numcols, obj, lb, ub, types, colnames)

cplex.CPXwriteprob(env, model, "test.lp")

cplex.CPXfreeprob(env, model)
cplex.CPXcloseCPLEX(env)