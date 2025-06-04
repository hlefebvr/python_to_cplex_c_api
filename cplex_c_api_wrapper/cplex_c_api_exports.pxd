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
    
    # I/O functions
    int CPXwriteprob(CPXENVptr env, CPXLPptr lp, const char *filename_str, const char *filetype)

    # Constants
    double CPX_INFBOUND
