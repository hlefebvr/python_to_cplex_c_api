cdef extern from "cplex.h":
    ctypedef void* CPXENVptr
    ctypedef void* CPXLPptr

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
    int CPX_PARAM_SCRIND
    int CPX_ON
    int CPX_OFF

    # Solve
    int CPXmipopt(CPXENVptr env, CPXLPptr lp)

    # Constants
    double CPX_INFBOUND
