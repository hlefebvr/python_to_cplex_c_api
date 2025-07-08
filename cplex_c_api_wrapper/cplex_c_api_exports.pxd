cdef extern from "cplex.h":
    ctypedef void* CPXENVptr
    ctypedef void* CPXCENVptr
    ctypedef void* CPXLPptr
    ctypedef void* CPXCLPptr
    ctypedef int (*LazyCallbackCFunc)(CPXENVptr env, void* cbdata, int wherefrom, void* cbhandle, int* useraction_p)

    # Create environment
    CPXENVptr CPXopenCPLEX(int *status_p)
    int CPXcloseCPLEX(CPXENVptr *env_p)
    
    # Create model
    CPXLPptr CPXcreateprob(CPXENVptr env, int *status_p, char *name)
    int CPXfreeprob(CPXENVptr env, CPXLPptr * lp_p)

    # Read model
    int CPXgetnumcols(CPXCENVptr env, CPXLPptr lp)
    int CPXgetnumrows(CPXCENVptr env, CPXLPptr lp)
    int CPXgetx (CPXCENVptr env, CPXCLPptr lp, double *x, int begin, int end)
    int CPXgetsense (CPXCENVptr env, CPXCLPptr lp, char *sense, int begin, int end)
    int CPXgetlb (CPXCENVptr env, CPXCLPptr lp, double *lb, int begin, int end)
    int CPXgetub (CPXCENVptr env, CPXCLPptr lp, double *ub, int begin, int end)
    int CPXgetbase (CPXCENVptr env, CPXCLPptr lp, int *cstat, int *rstat)
    int CPXgetbhead (CPXCENVptr env, CPXCLPptr lp, int *head, double *x)
    int CPXbinvacol (CPXCENVptr env, CPXCLPptr lp, int j, double *x)

    # Build model
    int CPXchgobjsen (CPXCENVptr env, CPXLPptr lp, int maxormin)
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
    int CPX_MIN
    int CPX_MAX
    int CPX_PARAM_TILIM
    int CPX_PARAM_THREADS
    int CPX_PARAM_EPINT