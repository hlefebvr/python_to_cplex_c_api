import cplex_c_api_wrapper.cplex_c_api_wrapper as wrapper

env = wrapper.c_CPXopenCPLEX()
model = wrapper.c_CPXcreateprob(env, "my_model")
wrapper.c_CPXwriteprob(env, model, "test.lp")