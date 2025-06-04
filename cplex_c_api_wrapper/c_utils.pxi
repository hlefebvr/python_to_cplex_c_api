from libc.stdlib cimport malloc, free

cdef class ArrayOfDouble():
    cdef double* impl
    cdef Py_ssize_t size

    def __cinit__(self, values):

        self.size = len(values) if values is not None else 0
        
        if self.size == 0: 
            self.impl = NULL
            return
        
        self.impl = <double*> malloc(self.size * sizeof(double))
        for i in range(self.size): self.impl[i] = values[i]
    
    def __dealloc__(self):
        if self.impl != NULL:
            free(self.impl)

cdef class ArrayOfInt():
    cdef int* impl
    cdef Py_ssize_t size

    def __cinit__(self, values):

        self.size = len(values) if values is not None else 0
        
        if self.size == 0: 
            self.impl = NULL
            return
        
        self.impl = <int*> malloc(self.size * sizeof(int))
        for i in range(self.size): self.impl[i] = values[i]
    
    def __dealloc__(self):
        if self.impl != NULL:
            free(self.impl)

cdef class ArrayOfChar():
    cdef const char* impl
    cdef  Py_ssize_t size
    cdef bytes _xvalues

    def __cinit__(self, values):

        self.size = len(values) if values is not None else 0
        
        if self.size == 0:
            self.impl = NULL
            return

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

        self.size = len(values) if values is not None else 0
        
        if self.size == 0:
            self.impl = NULL
            return

        self.impl = <char**>malloc(self.size * sizeof(char*))

        self._chars = []

        for i in range(self.size):
            c = ArrayOfChar(values[i])
            self._chars.append(c)
            self.impl[i] = <char*>c.impl
          
    def __dealloc__(self):
        if self.impl != NULL:
            free(self.impl)
