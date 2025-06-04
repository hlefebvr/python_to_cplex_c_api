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

cdef class ArrayOfDouble():
    cdef double* impl
    cdef Py_ssize_t size

    def __cinit__(self, values):
        self.size = len(values)
        if self.size == 0: raise ValueError("Length of array cannot be 0")
        self.impl = <double*> malloc(self.size * sizeof(double))
        if self.impl == NULL:
            raise MemoryError("Failed to allocate memory for ArrayOfDouble")
        for i in range(self.size): self.impl[i] = values[i]
    
    def __dealloc__(self):
        if self.impl != NULL:
            free(self.impl)

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

cpdef c_CPXnewcols(CplexEnv t_env, CplexModel t_model, t_ccnt, t_obj, t_lb, t_ub, t_xctype, t_colname):
    cdef:
        int status = 0
        const char* xctype_ptr = NULL
        char** colname_ptr = NULL
        int i

    obj = ArrayOfDouble(t_obj)
    lb = ArrayOfDouble(t_lb)
    ub = ArrayOfDouble(t_ub)

    # Convert xctype (variable types)
    if t_xctype is not None:
        if isinstance(t_xctype, list):
            xctype = bytes("".join(t_xctype), "ascii")
        elif isinstance(t_xctype, str):
            xctype = t_xctype.encode("ascii")

        if len(t_xctype) != t_ccnt:
            raise ValueError("Length of xctype must be equal to ccnt")
        
        xctype_bytes = xctype  # prevent GC
        xctype_ptr = <const char*> xctype_bytes

    # Convert colname (list of strings)
    if t_colname is not None:
        if len(t_colname) != t_ccnt:
            raise ValueError("Length of colname must be ccnt")
        colname_ptr = <char**> malloc(t_ccnt * sizeof(char*))
        for i in range(t_ccnt):
            b = t_colname[i].encode("ascii")
            colname_ptr[i] = <char*> malloc(len(b) + 1)
            strcpy(colname_ptr[i], b)

    # Call CPLEX API
    status = CPXnewcols(t_env.impl, t_model.impl, t_ccnt, obj.impl, lb.impl, ub.impl, xctype_ptr, colname_ptr)
    CALL_CPLEX(status)

    # Free all malloc'd memory
    for i in range(t_ccnt):
        free(<char*> colname_ptr[i])
    free(colname_ptr)
