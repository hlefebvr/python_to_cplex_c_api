include "c_utils.pxi"

cimport cplex_c_api_exports as cplex

CPX_INFBOUND = cplex.CPX_INFBOUND
CPX_PARAM_SCRIND = cplex.CPX_PARAM_SCRIND
CPX_PARAM_STARTALG = cplex.CPX_PARAM_STARTALG
CPX_PARAM_SUBALG = cplex.CPX_PARAM_SUBALG
CPX_PARAM_PREIND = cplex.CPX_PARAM_PREIND
CPX_ALG_PRIMAL = cplex.CPX_ALG_PRIMAL
CPX_ALG_DUAL = cplex.CPX_ALG_DUAL
CPX_ON = cplex.CPX_ON
CPX_OFF = cplex.CPX_OFF
CPX_MIN = cplex.CPX_MIN
CPX_MAX = cplex.CPX_MAX
CPX_PARAM_TILIM = cplex.CPX_PARAM_TILIM
CPX_PARAM_THREADS = cplex.CPX_PARAM_THREADS
CPX_PARAM_EPINT = cplex.CPX_PARAM_EPINT

def CALL_CPLEX(status): 
    if status > 0: raise RuntimeError("Error calling CPLEX: returned status " + str(status))

cdef class Env:
    cdef cplex.CPXENVptr impl

    @staticmethod
    cdef from_ptr(cplex.CPXENVptr impl):
        cdef Env env = Env.__new__(Env)
        env.impl = impl
        return env

cdef class Model:
    cdef cplex.CPXLPptr impl

    @staticmethod
    cdef from_ptr(cplex.CPXLPptr impl):
        cdef Model model = Model.__new__(Model)
        model.impl = impl
        return model

def CPXopenCPLEX():
    cdef int status = 0
    result = Env.from_ptr(cplex.CPXopenCPLEX(&status))
    CALL_CPLEX(status)
    return result

def CPXcreateprob(Env env, name): 
    cdef int status = 0
    result = Model.from_ptr(cplex.CPXcreateprob(env.impl, &status, ArrayOfChar(name).impl))
    CALL_CPLEX(status)
    return result

def CPXcloseCPLEX(Env env):
    CALL_CPLEX(cplex.CPXcloseCPLEX(&env.impl))

def CPXfreeprob(Env env, Model model): 
    CALL_CPLEX(cplex.CPXfreeprob(env.impl, &model.impl))

def CPXwriteprob(Env env, Model model, filename_str, filetype_str = None):
    CALL_CPLEX(cplex.CPXwriteprob(env.impl,
                                  model.impl,
                                  ArrayOfChar(filename_str).impl,
                                  ArrayOfChar(filetype_str).impl
                ))

def CPXnewcols(Env env, Model model, ccnt, obj, lb, ub, xctype, colname):
    CALL_CPLEX(cplex.CPXnewcols(env.impl,
                                model.impl,
                                ccnt,
                                ArrayOfDouble(obj).impl,
                                ArrayOfDouble(lb).impl,
                                ArrayOfDouble(ub).impl,
                                ArrayOfChar(xctype).impl,
                                ArrayOfString(colname).impl
                ))

def CPXaddrows(Env env, Model model, ccnt, rcnt, nzcnt, rhs, rtypes, rmatbeg, rmatind, rmatval, colname, rowname):
    CALL_CPLEX(cplex.CPXaddrows(env.impl,
                                model.impl,
                                ccnt, 
                                rcnt,
                                nzcnt,
                                ArrayOfDouble(rhs).impl,
                                ArrayOfChar(rtypes).impl,
                                ArrayOfInt(rmatbeg).impl,
                                ArrayOfInt(rmatind).impl,
                                ArrayOfDouble(rmatval).impl,
                                ArrayOfString(colname).impl,
                                ArrayOfString(rowname).impl
               ))

def CPXmipopt(Env env, Model model):
    CALL_CPLEX(cplex.CPXmipopt(env.impl, model.impl))

def CPXsetintparam(Env env, whichparam, newvalue):
    CALL_CPLEX(cplex.CPXsetintparam(env.impl, whichparam, newvalue))

def CPXsetdblparam(Env env, whichparam, newvalue):
    CALL_CPLEX(cplex.CPXsetdblparam(env.impl, whichparam, newvalue))

def CPXaddlazyconstraints(Env env, Model lp, rcnt, nzcnt,  rhs, sense, rmatbeg, rmatind, rmatval, rowname):
    CALL_CPLEX(cplex.CPXaddlazyconstraints(env.impl,
                                           lp.impl,
                                           rcnt,
                                           nzcnt,
                                           ArrayOfDouble(rhs).impl,
                                           ArrayOfChar(sense).impl,
                                           ArrayOfInt(rmatbeg).impl,
                                           ArrayOfInt(rmatind).impl,
                                           ArrayOfDouble(rmatval).impl,
                                           ArrayOfString(rowname).impl
    ))

cdef class Callback:
    cdef object python_callback

    env = None
    cbdata = None
    wherefrom = None

    def __cinit__(self):
        if not callable(self): raise TypeError("Callback must be callable")

cdef int callback_bridge(cplex.CPXCENVptr xenv, void *cbdata, int wherefrom, void *cbhandle, int *useraction_p) noexcept:
    cb = <Callback>cbhandle
    
    cb.env = Env.from_ptr(<cplex.CPXENVptr>xenv)
    cb.cbdata = VoidPointer.from_ptr(<void*> cbdata)
    cb.wherefrom = wherefrom
    
    cb()

    cb.env = None
    cb.cbdata = None
    cb.wherefrom = None
    
    useraction_p[0] = 0

    return 0

def CPXsetlazyconstraintcallbackfunc(Env env, Callback cb):
    CALL_CPLEX(cplex.CPXsetlazyconstraintcallbackfunc(env.impl, callback_bridge, <void*>cb))

def CPXgetcallbacknodelp(Env env, VoidPointer cbdata, wherefrom):
    cdef cplex.CPXLPptr lp
    CALL_CPLEX(cplex.CPXgetcallbacknodelp(env.impl, cbdata.impl, wherefrom, &lp))
    result = Model.from_ptr(<cplex.CPXLPptr> lp)
    return result

def CPXgetnumcols(Env env, Model lp):
    return cplex.CPXgetnumcols(env.impl, lp.impl)

def CPXgetnumrows(Env env, Model lp):
    return cplex.CPXgetnumrows(env.impl, lp.impl)

def CPXgetx(Env env, Model lp, begin, end):
    n = end - begin + 1
    result = ArrayOfDouble(n)
    CALL_CPLEX(cplex.CPXgetx(env.impl, lp.impl, result.impl, begin, end))
    return result.to_list()

def CPXgetlb(Env env, Model lp, begin, end):
    n = end - begin + 1
    result = ArrayOfDouble(n)
    CALL_CPLEX(cplex.CPXgetlb(env.impl, lp.impl, result.impl, begin, end))
    return result.to_list()

def CPXgetub(Env env, Model lp, begin, end):
    n = end - begin + 1
    result = ArrayOfDouble(n)
    CALL_CPLEX(cplex.CPXgetub(env.impl, lp.impl, result.impl, begin, end))
    return result.to_list()

def CPXgetsense(Env env, Model lp, begin, end):
    n = end - begin + 1
    result = ArrayOfChar(n)
    CALL_CPLEX(cplex.CPXgetsense(env.impl, lp.impl, result.impl, begin, end))
    return result.to_list()

def CPXgetbase(Env env, Model lp):
    cstat = ArrayOfInt(CPXgetnumcols(env, lp))
    rstat = ArrayOfInt(CPXgetnumrows(env, lp))
    CALL_CPLEX(cplex.CPXgetbase(env.impl, lp.impl, cstat.impl, rstat.impl))
    return (cstat.to_list(), rstat.to_list())

def CPXgetbhead(Env env, Model lp):
    n_rows = CPXgetnumrows(env, lp)
    head = ArrayOfInt(n_rows)
    x = ArrayOfDouble(n_rows)
    CALL_CPLEX(cplex.CPXgetbhead(env.impl, lp.impl, head.impl, x.impl))
    return (head.to_list(), x.to_list())

def CPXbinvacol(Env env, Model lp, int j):
    n_rows = CPXgetnumrows(env, lp)
    result = ArrayOfDouble(n_rows)
    CALL_CPLEX(cplex.CPXbinvacol(env.impl, lp.impl, j, result.impl))
    return result.to_list()

def CPXchgobjsen(Env env, Model lp, sense):
    CALL_CPLEX(cplex.CPXchgobjsen(env.impl, lp.impl, sense))
