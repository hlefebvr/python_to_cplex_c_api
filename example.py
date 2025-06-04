import cplex_c_api_wrapper.cplex_c_api_wrapper as wrapper

env = wrapper.c_CPXopenCPLEX()

model = wrapper.c_CPXcreateprob(env, "my_model")

numcols = 2;
types = ['I', 'I']
obj = [-1,-10]
lb = [0, 0]
ub = [wrapper.c_CPX_INFBOUND, wrapper.c_CPX_INFBOUND]
colnames = ["x", "y"]

wrapper.c_CPXnewcols(env, model, numcols, obj, lb, ub, types, colnames)


wrapper.c_CPXwriteprob(env, model, "test.lp")