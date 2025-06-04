from libc.stdlib cimport malloc, free
from libc.string cimport strcpy
cimport cplex_c_api_exports as cplex

CPX_INFBOUND = cplex.CPX_INFBOUND

def CALL_CPLEX(status):
    if status != 0: 
        raise RuntimeError("Error calling CPLEX.")

cdef class c_ArrayOfDouble():
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

cdef class c_ArrayOfChar():
    cdef const char* impl
    cdef  Py_ssize_t size
    cdef bytes _xvalues

    def __cinit__(self, values):

        if isinstance(values, list):
            self._xvalues = bytes("".join(values), "ascii")
        elif isinstance(values, str):
            self._xvalues = values.encode("ascii")

        self.impl = self._xvalues

cdef class CplexEnv:
    cdef cplex.CPXENVptr impl

    def __cinit__(self):
        cdef int status = 0
        self.impl = cplex.CPXopenCPLEX(&status)
        CALL_CPLEX(status)

    def __dealloc__(self):
        CALL_CPLEX(cplex.CPXcloseCPLEX(&self.impl))

def CPXopenCPLEX():
    return CplexEnv()

cdef class CplexModel:
    cdef cplex.CPXLPptr impl

    def __cinit__(self, CplexEnv env, name = "model"):
        cdef int status = 0
        cdef bytes name_bytes = name.encode()
        self.impl = cplex.CPXcreateprob(env.impl, &status, <char*>name_bytes)
        CALL_CPLEX(status)

def CPXcreateprob(CplexEnv env, name):
    return CplexModel(env, name)

cpdef CPXwriteprob(CplexEnv env, CplexModel model, filename_str, filetype_str = None):
    filename = filename_str + '.' + filetype_str if filetype_str is not None else filename_str
    cdef bytes filename_bytes = filename.encode()
    CALL_CPLEX(cplex.CPXwriteprob(env.impl, model.impl, filename_bytes, NULL))

cpdef CPXnewcols(CplexEnv t_env, CplexModel t_model, t_ccnt, t_obj, t_lb, t_ub, t_xctype, t_colname):
    cdef:
        int status = 0
        char** colname_ptr = NULL
        int i

    obj = c_ArrayOfDouble(t_obj)
    lb = c_ArrayOfDouble(t_lb)
    ub = c_ArrayOfDouble(t_ub)
    xtype = c_ArrayOfChar(t_xctype)

    if t_colname is not None:
        if len(t_colname) != t_ccnt:
            raise ValueError("Length of colname must be ccnt")
        colname_ptr = <char**> malloc(t_ccnt * sizeof(char*))
        for i in range(t_ccnt):
            b = t_colname[i].encode("ascii")
            colname_ptr[i] = <char*> malloc(len(b) + 1)
            strcpy(colname_ptr[i], b)

    CALL_CPLEX(cplex.CPXnewcols(t_env.impl, t_model.impl, t_ccnt, obj.impl, lb.impl, ub.impl, xtype.impl, colname_ptr))

    # Free all malloc'd memory
    for i in range(t_ccnt):
        free(<char*> colname_ptr[i])
    free(colname_ptr)
