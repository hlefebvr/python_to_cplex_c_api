include "c_utils.pxi"

cimport cplex_c_api_exports as cplex

CPX_INFBOUND = cplex.CPX_INFBOUND

def CALL_CPLEX(status): 
    if status > 0: raise RuntimeError("Error calling CPLEX: returned status " + str(status))

cdef class CplexEnv:
    cdef cplex.CPXENVptr impl

    def __cinit__(self):
        cdef int status = 0
        self.impl = cplex.CPXopenCPLEX(&status)
        CALL_CPLEX(status)

cdef class CplexModel:
    cdef cplex.CPXLPptr impl

    def __cinit__(self, CplexEnv env, name):
        cdef int status = 0
        self.impl = cplex.CPXcreateprob(env.impl, &status, ArrayOfChar(name).impl)
        CALL_CPLEX(status)

def CPXopenCPLEX():
    return CplexEnv()

def CPXcreateprob(CplexEnv env, name): 
    return CplexModel(env, name)

def CPXcloseCPLEX(CplexEnv env):
    CALL_CPLEX(cplex.CPXcloseCPLEX(&env.impl))

def CPXfreeprob(CplexEnv env, CplexModel model): 
    CALL_CPLEX(cplex.CPXfreeprob(env.impl, &model.impl))

cpdef CPXwriteprob(CplexEnv env, CplexModel model, filename_str, filetype_str = None):
    CALL_CPLEX(cplex.CPXwriteprob(env.impl,
                                  model.impl,
                                  ArrayOfChar(filename_str).impl,
                                  ArrayOfChar(filetype_str).impl
                ))

cpdef CPXnewcols(CplexEnv env, CplexModel model, ccnt, obj, lb, ub, xctype, colname):
    CALL_CPLEX(cplex.CPXnewcols(env.impl,
                                model.impl,
                                ccnt,
                                ArrayOfDouble(obj).impl,
                                ArrayOfDouble(lb).impl,
                                ArrayOfDouble(ub).impl,
                                ArrayOfChar(xctype).impl,
                                ArrayOfString(colname).impl
                ))
