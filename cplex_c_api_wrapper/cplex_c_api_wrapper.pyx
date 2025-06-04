from libc.stdlib cimport malloc, free
from libc.string cimport strcpy

cdef extern from "cplex.h":
    ctypedef void* CPXENVptr
    ctypedef void* CPXLPptr
    CPXENVptr CPXopenCPLEX(int *status_p)
    int CPXcloseCPLEX(CPXENVptr *env_p)
    CPXLPptr CPXcreateprob(CPXENVptr env, int *status_p, char *name)
    int CPXwriteprob(CPXENVptr env, CPXLPptr lp, const char *filename_str, const char *filetype)

def CALL_CPLEX(status):
    if status != 0: 
        raise RuntimeError("Error calling CPLEX.")

cdef class CplexEnv:
    cdef CPXENVptr impl

    def __cinit__(self):
        cdef int status = 0
        self.impl = CPXopenCPLEX(&status)
        CALL_CPLEX(status)

def c_CPXopenCPLEX():
    return CplexEnv()

cdef class CplexModel:
    cdef CPXLPptr impl

    def __cinit__(self, CplexEnv env, name = "model"):
        cdef int status = 0
        cdef bytes name_bytes = name.encode()
        self.impl = CPXcreateprob(env.impl, &status, <char*>name_bytes)
        CALL_CPLEX(status)

def c_CPXcreateprob(CplexEnv env, name):
    return CplexModel(env, name)

cpdef c_CPXwriteprob(CplexEnv env, CplexModel model, filename_str, filetype_str = None):
    filename = filename_str + '.' + filetype_str if filetype_str is not None else filename_str
    cdef bytes filename_bytes = filename.encode()
    CALL_CPLEX(CPXwriteprob(env.impl, model.impl, filename_bytes, NULL))
