from libc.stdlib cimport malloc, free
from libc.string cimport strcpy
cimport cplex_c_api_exports as cplex

CPX_INFBOUND = cplex.CPX_INFBOUND

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

cdef class ArrayOfChar():
    cdef const char* impl
    cdef  Py_ssize_t size
    cdef bytes _xvalues

    def __cinit__(self, values):

        if isinstance(values, list):
            self._xvalues = bytes("".join(values), "ascii")
        elif isinstance(values, str):
            self._xvalues = values.encode("ascii")

        self.impl = self._xvalues

cdef class ArrayOfString:
    cdef char** impl
    cdef int size
    cdef list _chars

    def __cinit__(self, values):
        if not isinstance(values, list):
            raise TypeError("Expected a list of strings")
        self.size = len(values)
        if self.size == 0:
            raise ValueError("Empty list")

        self.impl = <char**>malloc(self.size * sizeof(char*))
        if self.impl == NULL:
            raise MemoryError("Failed to allocate char** array")

        self._chars = []

        for i in range(self.size):
            c = ArrayOfChar(values[i])
            self._chars.append(c)
            self.impl[i] = <char*>c.impl
          
    def __dealloc__(self):
        if self.impl != NULL:
            free(self.impl)

cdef class CplexEnv:
    cdef cplex.CPXENVptr impl

    def __cinit__(self):
        cdef int status = 0
        self.impl = cplex.CPXopenCPLEX(&status)
        CALL_CPLEX(status)

def CPXopenCPLEX():
    return CplexEnv()

def CPXcloseCPLEX(CplexEnv env):
    CALL_CPLEX(cplex.CPXcloseCPLEX(&env.impl))

cdef class CplexModel:
    cdef cplex.CPXLPptr impl

    def __cinit__(self, CplexEnv env, name = "model"):
        cdef int status = 0
        cdef bytes name_bytes = name.encode()
        self.impl = cplex.CPXcreateprob(env.impl, &status, <char*>name_bytes)
        CALL_CPLEX(status)

def CPXcreateprob(CplexEnv env, name):
    return CplexModel(env, name)

def CPXfreeprob(CplexEnv env, CplexModel model):
    CALL_CPLEX(cplex.CPXfreeprob(env.impl, &model.impl))

cpdef CPXwriteprob(CplexEnv env, CplexModel model, filename_str, filetype_str = None):
    filename = filename_str + '.' + filetype_str if filetype_str is not None else filename_str
    cdef bytes filename_bytes = filename.encode()
    CALL_CPLEX(cplex.CPXwriteprob(env.impl, model.impl, filename_bytes, NULL))

cpdef CPXnewcols(CplexEnv t_env, CplexModel t_model, t_ccnt, t_obj, t_lb, t_ub, t_xctype, t_colname):
    
    obj = ArrayOfDouble(t_obj)
    lb = ArrayOfDouble(t_lb)
    ub = ArrayOfDouble(t_ub)
    xtype = ArrayOfChar(t_xctype)
    colnames = ArrayOfString(t_colname)

    CALL_CPLEX(cplex.CPXnewcols(t_env.impl, t_model.impl, t_ccnt, obj.impl, lb.impl, ub.impl, xtype.impl, colnames.impl))
