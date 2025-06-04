cdef extern from "cplex.h":
    ctypedef void* CPXENVptr
    ctypedef void* CPXCENVptr
    ctypedef void* CPXLPptr
    ctypedef int (*LazyCallbackCFunc)(CPXENVptr env, void* cbdata, int wherefrom, void* cbhandle, int* useraction_p)

    # Create environment
    CPXENVptr CPXopenCPLEX(int *status_p)
    int CPXcloseCPLEX(CPXENVptr *env_p)
    
    # Create model
    CPXLPptr CPXcreateprob(CPXENVptr env, int *status_p, char *name)
    int CPXfreeprob(CPXENVptr env, CPXLPptr * lp_p)
    
    # Build model
    int CPXnewcols(CPXENVptr env, CPXLPptr lp, int ccnt, const double * obj, const double * lb, const double * ub, const char * xctype, char ** colname)
    int CPXaddrows(CPXENVptr env, CPXLPptr lp, int ccnt, int rcnt, int nzcnt, const double * rhs, const char * sense, const int * rmatbeg, const int * rmatind, const double * rmatval, char ** colname, char ** rowname)
    
    # I/O functions
    int CPXwriteprob(CPXENVptr env, CPXLPptr lp, const char *filename_str, const char *filetype)

    # Parameters
    int CPXsetintparam(CPXENVptr env, int whichparam, int newvalue)

    # Solve
    int CPXmipopt(CPXENVptr env, CPXLPptr lp)

    # Callbacks
    int CPXsetlazyconstraintcallbackfunc(CPXENVptr env, LazyCallbackCFunc lazyconcallback, void* cbhandle)
    int CPXgetcallbacknodelp (CPXCENVptr env, void *cbdata, int wherefrom, CPXLPptr *nodelp_p)

    # Constants
    double CPX_INFBOUND
    int CPX_PARAM_SCRIND
    int CPX_PARAM_STARTALG
    int CPX_PARAM_SUBALG
    int CPX_ALG_DUAL
    int CPX_ALG_PRIMAL
    int CPX_PARAM_PREIND
    int CPX_ON
    int CPX_OFF
