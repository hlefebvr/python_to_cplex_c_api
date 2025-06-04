from libc.stdlib cimport malloc, free
from libc.string cimport strcpy

cdef extern from "cplex.h":
    ctypedef void* CPXENVptr
    ctypedef void* CPXLPptr
    CPXENVptr CPXopenCPLEX(int *status_p)
    int CPXcloseCPLEX(CPXENVptr *env_p)
    CPXLPptr CPXcreateprob(CPXENVptr env, int *status_p, char *name)
    int CPXwriteprob(CPXENVptr env, CPXLPptr lp, const char *filename_str, const char *filetype)
    int CPXnewcols(CPXENVptr env, CPXLPptr lp, int ccnt, const double * obj, const double * lb, const double * ub, const char * xctype, char ** colname)
    double CPX_INFBOUND

c_CPX_INFBOUND = CPX_INFBOUND

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

cpdef c_CPXnewcols(CplexEnv env, CplexModel model, ccnt, obj, lb, ub, xctype, colname):
    cdef:
        int status = 0
        double* obj_ptr = NULL
        double* lb_ptr = NULL
        double* ub_ptr = NULL
        const char* xctype_ptr = NULL
        char** colname_ptr = NULL
        int i

    # Convert objective
    if obj is not None:
        if len(obj) != ccnt:
            raise ValueError("Length of obj must be ccnt")
        obj_ptr = <double*> malloc(ccnt * sizeof(double))
        for i in range(ccnt):
            obj_ptr[i] = obj[i]

    # Convert lower bounds
    if lb is not None:
        if len(lb) != ccnt:
            raise ValueError("Length of lb must be ccnt")
        lb_ptr = <double*> malloc(ccnt * sizeof(double))
        for i in range(ccnt):
            lb_ptr[i] = lb[i]

    # Convert upper bounds
    if ub is not None:
        if len(ub) != ccnt:
            raise ValueError("Length of ub must be ccnt")
        ub_ptr = <double*> malloc(ccnt * sizeof(double))
        for i in range(ccnt):
            ub_ptr[i] = ub[i]

    # Convert xctype (variable types)
    if xctype is not None:
        if isinstance(xctype, list):
            xctype = bytes("".join(xctype), "ascii")
        elif isinstance(xctype, str):
            xctype = xctype.encode("ascii")

        if len(xctype) != ccnt:
            raise ValueError("Length of xctype must be equal to ccnt")
        
        xctype_bytes = xctype  # prevent GC
        xctype_ptr = <const char*> xctype_bytes

    # Convert colname (list of strings)
    if colname is not None:
        if len(colname) != ccnt:
            raise ValueError("Length of colname must be ccnt")
        colname_ptr = <char**> malloc(ccnt * sizeof(char*))
        for i in range(ccnt):
            b = colname[i].encode("ascii")
            colname_ptr[i] = <char*> malloc(len(b) + 1)
            strcpy(colname_ptr[i], b)

    # Call CPLEX API
    status = CPXnewcols(env.impl, model.impl, ccnt, obj_ptr, lb_ptr, ub_ptr, xctype_ptr, colname_ptr)
    CALL_CPLEX(status)

    # Free all malloc'd memory
    if obj_ptr: free(obj_ptr)
    if lb_ptr: free(lb_ptr)
    if ub_ptr: free(ub_ptr)
    for i in range(ccnt):
        free(<char*> colname_ptr[i])
    free(colname_ptr)
