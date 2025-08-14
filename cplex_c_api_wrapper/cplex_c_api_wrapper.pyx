include "c_utils.pxi"

cimport cplex_c_api_exports as cplex

# Constants
CPX_INFBOUND = cplex.CPX_INFBOUND

# Parameter Names
CPX_PARAM_SCRIND       = cplex.CPX_PARAM_SCRIND
CPX_PARAM_STARTALG     = cplex.CPX_PARAM_STARTALG
CPX_PARAM_SUBALG       = cplex.CPX_PARAM_SUBALG
CPX_PARAM_PREIND       = cplex.CPX_PARAM_PREIND
CPX_PARAM_TILIM        = cplex.CPX_PARAM_TILIM
CPX_PARAM_THREADS      = cplex.CPX_PARAM_THREADS
CPX_PARAM_EPINT        = cplex.CPX_PARAM_EPINT
CPX_PARAM_MIPCBREDLP   = cplex.CPX_PARAM_MIPCBREDLP
CPX_PARAM_HEURFREQ     = cplex.CPX_PARAM_HEURFREQ
CPX_PARAM_CUTPASS      = cplex.CPX_PARAM_CUTPASS
CPX_PARAM_MIPDISPLAY   = cplex.CPX_PARAM_MIPDISPLAY
CPX_PARAM_MIPSEARCH    = cplex.CPX_PARAM_MIPSEARCH
CPX_PARAM_PRELINEAR    = cplex.CPX_PARAM_PRELINEAR

# Parameter Values
CPX_ALG_DUAL            = cplex.CPX_ALG_DUAL
CPX_ALG_PRIMAL          = cplex.CPX_ALG_PRIMAL
CPX_ON                  = cplex.CPX_ON
CPX_OFF                 = cplex.CPX_OFF
CPX_MIPSEARCH_TRADITIONAL = cplex.CPX_MIPSEARCH_TRADITIONAL

# Objective Senses
CPX_MIN = cplex.CPX_MIN
CPX_MAX = cplex.CPX_MAX

# Cut Purgeability
CPX_USECUT_FORCE  = cplex.CPX_USECUT_FORCE
CPX_USECUT_PURGE  = cplex.CPX_USECUT_PURGE
CPX_USECUT_FILTER = cplex.CPX_USECUT_FILTER

# Callback Return codes
CPX_CALLBACK_DEFAULT = cplex.CPX_CALLBACK_DEFAULT
CPX_CALLBACK_FAIL = cplex.CPX_CALLBACK_FAIL
CPX_CALLBACK_SET = cplex.CPX_CALLBACK_SET
CPX_CALLBACK_ABORT_CUT_LOOP = cplex.CPX_CALLBACK_ABORT_CUT_LOOP

# Cut Types
CPX_CUT_COVER        = cplex.CPX_CUT_COVER
CPX_CUT_GUBCOVER     = cplex.CPX_CUT_GUBCOVER
CPX_CUT_FLOWCOVER    = cplex.CPX_CUT_FLOWCOVER
CPX_CUT_CLIQUE       = cplex.CPX_CUT_CLIQUE
CPX_CUT_FRAC         = cplex.CPX_CUT_FRAC
CPX_CUT_MIR          = cplex.CPX_CUT_MIR
CPX_CUT_FLOWPATH     = cplex.CPX_CUT_FLOWPATH
CPX_CUT_DISJ         = cplex.CPX_CUT_DISJ
CPX_CUT_IMPLBD       = cplex.CPX_CUT_IMPLBD
CPX_CUT_ZEROHALF     = cplex.CPX_CUT_ZEROHALF
CPX_CUT_MCF          = cplex.CPX_CUT_MCF
CPX_CUT_LANDP        = cplex.CPX_CUT_LANDP
CPX_CUT_USER         = cplex.CPX_CUT_USER
CPX_CUT_TABLE        = cplex.CPX_CUT_TABLE
CPX_CUT_SOLNPOOL     = cplex.CPX_CUT_SOLNPOOL
CPX_CUT_LOCALIMPLBD  = cplex.CPX_CUT_LOCALIMPLBD
CPX_CUT_BQP          = cplex.CPX_CUT_BQP
CPX_CUT_RLT          = cplex.CPX_CUT_RLT
CPX_CUT_BENDERS      = cplex.CPX_CUT_BENDERS

# MIP Status
CPXMIP_ABORT_FEAS                  = cplex.CPXMIP_ABORT_FEAS
CPXMIP_OPTIMAL                     = cplex.CPXMIP_OPTIMAL
CPXMIP_ABORT_INFEAS                = cplex.CPXMIP_ABORT_INFEAS
CPXMIP_ABORT_RELAXATION_UNBOUNDED = cplex.CPXMIP_ABORT_RELAXATION_UNBOUNDED
CPXMIP_ABORT_RELAXED               = cplex.CPXMIP_ABORT_RELAXED
CPXMIP_DETTIME_LIM_FEAS            = cplex.CPXMIP_DETTIME_LIM_FEAS
CPXMIP_DETTIME_LIM_INFEAS          = cplex.CPXMIP_DETTIME_LIM_INFEAS
CPXMIP_FAIL_FEAS                   = cplex.CPXMIP_FAIL_FEAS
CPXMIP_FAIL_FEAS_NO_TREE           = cplex.CPXMIP_FAIL_FEAS_NO_TREE
CPXMIP_FAIL_INFEAS                 = cplex.CPXMIP_FAIL_INFEAS
CPXMIP_FAIL_INFEAS_NO_TREE         = cplex.CPXMIP_FAIL_INFEAS_NO_TREE
CPXMIP_FEASIBLE                     = cplex.CPXMIP_FEASIBLE
CPXMIP_FEASIBLE_RELAXED_INF       = cplex.CPXMIP_FEASIBLE_RELAXED_INF
CPXMIP_FEASIBLE_RELAXED_QUAD      = cplex.CPXMIP_FEASIBLE_RELAXED_QUAD
CPXMIP_FEASIBLE_RELAXED_SUM       = cplex.CPXMIP_FEASIBLE_RELAXED_SUM
CPXMIP_INFEASIBLE                 = cplex.CPXMIP_INFEASIBLE
CPXMIP_INForUNBD                   = cplex.CPXMIP_INForUNBD
CPXMIP_MEM_LIM_FEAS               = cplex.CPXMIP_MEM_LIM_FEAS
CPXMIP_MEM_LIM_INFEAS             = cplex.CPXMIP_MEM_LIM_INFEAS
CPXMIP_NODE_LIM_FEAS              = cplex.CPXMIP_NODE_LIM_FEAS
CPXMIP_NODE_LIM_INFEAS            = cplex.CPXMIP_NODE_LIM_INFEAS
CPXMIP_OPTIMAL_INFEAS              = cplex.CPXMIP_OPTIMAL_INFEAS
CPXMIP_OPTIMAL_POPULATED           = cplex.CPXMIP_OPTIMAL_POPULATED
CPXMIP_OPTIMAL_POPULATED_TOL       = cplex.CPXMIP_OPTIMAL_POPULATED_TOL
CPXMIP_OPTIMAL_RELAXED_INF         = cplex.CPXMIP_OPTIMAL_RELAXED_INF
CPXMIP_OPTIMAL_RELAXED_QUAD        = cplex.CPXMIP_OPTIMAL_RELAXED_QUAD
CPXMIP_OPTIMAL_RELAXED_SUM         = cplex.CPXMIP_OPTIMAL_RELAXED_SUM
CPXMIP_OPTIMAL_TOL                  = cplex.CPXMIP_OPTIMAL_TOL
CPXMIP_POPULATESOL_LIM             = cplex.CPXMIP_POPULATESOL_LIM
CPXMIP_SOL_LIM                      = cplex.CPXMIP_SOL_LIM
CPXMIP_TIME_LIM_FEAS               = cplex.CPXMIP_TIME_LIM_FEAS
CPXMIP_TIME_LIM_INFEAS             = cplex.CPXMIP_TIME_LIM_INFEAS
CPXMIP_UNBOUNDED                   = cplex.CPXMIP_UNBOUNDED

# Error codes
CPXERR_NEGATIVE_SURPLUS             = cplex.CPXERR_NEGATIVE_SURPLUS

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

def CPXcopyorder(Env env, Model lp, int cnt, indices, priority, direction):
    CALL_CPLEX(cplex.CPXcopyorder(env.impl,
                                  lp.impl,
                                  cnt,
                                  ArrayOfInt(indices).impl,
                                  ArrayOfInt(priority).impl,
                                  ArrayOfInt(direction).impl
                                ))

def CPXmipopt(Env env, Model model):
    CALL_CPLEX(cplex.CPXmipopt(env.impl, model.impl))

def CPXsetintparam(Env env, whichparam, newvalue):
    CALL_CPLEX(cplex.CPXsetintparam(env.impl, whichparam, newvalue))

def CPXsetdblparam(Env env, whichparam, newvalue):
    CALL_CPLEX(cplex.CPXsetdblparam(env.impl, whichparam, newvalue))

def CPXgettime(Env env):
    cdef double result
    CALL_CPLEX(cplex.CPXgettime(env.impl, &result))
    return result

def CPXgetnumcuts(Env env, Model model, int cuttype):
    cdef int result
    CALL_CPLEX(cplex.CPXgetnumcuts(env.impl, model.impl, cuttype, &result))
    return result

def CPXgetnodecnt(Env env, Model model):
    return cplex.CPXgetnodecnt(env.impl, model.impl)

def CPXgetbestobjval(Env env, Model model):
    cdef double result
    CALL_CPLEX(cplex.CPXgetbestobjval(env.impl, model.impl, &result))
    return result

def CPXgetobjval(Env env, Model model):
    cdef double result
    CALL_CPLEX(cplex.CPXgetobjval(env.impl, model.impl, &result))
    return result

def CPXgetstat(Env env, Model model):
    return cplex.CPXgetstat(env.impl, model.impl)

def CPXgetmiprelgap(Env env, Model model):
    cdef double result
    CALL_CPLEX(cplex.CPXgetmiprelgap(env.impl, model.impl, &result))
    return result

def CPXgetrhs(Env env, Model model, int begin, int end):
    rhs = ArrayOfDouble([0.0] * (end - begin + 1))
    CALL_CPLEX(cplex.CPXgetrhs(env.impl, model.impl, rhs.impl, begin, end))
    return rhs.to_list()

def CPXgetrows(Env env, Model model, int begin, int end):
    cdef int surplus
    cdef int nzcnt
    status = cplex.CPXgetrows(env.impl, model.impl, &nzcnt, NULL, NULL, NULL, 0, &surplus, begin, end)
    if status != cplex.CPXERR_NEGATIVE_SURPLUS:
        CALL_CPLEX(status)
    n = -surplus
    rmatbeg = ArrayOfInt([0] * (end - begin + 1))
    rmatind  = ArrayOfInt([0] * n)
    rmatval = ArrayOfDouble([0.0] * n)
    CALL_CPLEX(cplex.CPXgetrows(env.impl,
                                model.impl,
                                &nzcnt,
                                rmatbeg.impl,
                                rmatind.impl,
                                rmatval.impl,
                                n,
                                &surplus,
                                begin,
                                end
                                ))
    return (rmatbeg.to_list(), rmatind.to_list(), rmatval.to_list())

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

#############
# Callbacks #
#############

# Lazy Constraint Callback

cdef class LazyConstraintCallback:
    cdef object python_callback

    env = None
    cbdata = None
    wherefrom = None

    def __cinit__(self):
        if not callable(self): raise TypeError("Callback must be callable")

cdef int lazy_constraint_callback_bridge(cplex.CPXCENVptr xenv, void *cbdata, int wherefrom, void *cbhandle, int *useraction_p) noexcept:
    cb = <LazyConstraintCallback>cbhandle
    
    cb.env = Env.from_ptr(<cplex.CPXENVptr>xenv)
    cb.cbdata = VoidPointer.from_ptr(<void*> cbdata)
    cb.wherefrom = wherefrom
    
    result = cb()

    cb.env = None
    cb.cbdata = None
    cb.wherefrom = None

    if result is None:
        raise ValueError("Expected return value to be CPX_CALLBACK_DEFAULT, CPX_CALLBACK_FAIL or CPX_CALLBACK_SET")
    
    useraction_p[0] = result

    if result == cplex.CPX_CALLBACK_FAIL: 
        return 1

    return 0

def CPXsetlazyconstraintcallbackfunc(Env env, LazyConstraintCallback cb):
    CALL_CPLEX(cplex.CPXsetlazyconstraintcallbackfunc(env.impl, lazy_constraint_callback_bridge, <void*>cb))

def CPXcutcallbackadd(Env env, VoidPointer cbdata, int wherefrom, int nzcnt, double rhs, sense, cutind, cutval, int purgeable):
    CALL_CPLEX(cplex.CPXcutcallbackadd(env.impl,
                                       cbdata.impl,
                                       wherefrom,
                                       nzcnt,
                                       rhs,
                                       ord(sense),
                                       ArrayOfInt(cutind).impl,
                                       ArrayOfDouble(cutval).impl,
                                       purgeable
    ))

def CPXcutcallbackaddlocal(Env env, VoidPointer cbdata, int wherefrom, int nzcnt, double rhs, sense, cutind, cutval):
    CALL_CPLEX(cplex.CPXcutcallbackaddlocal(env.impl,
                                       cbdata.impl,
                                       wherefrom,
                                       nzcnt,
                                       rhs,
                                       ord(sense),
                                       ArrayOfInt(cutind).impl,
                                       ArrayOfDouble(cutval).impl
    ))

# User Cut Callback

cdef class UserCutCallback:
    cdef object python_callback

    env = None
    cbdata = None
    wherefrom = None

    def __cinit__(self):
        if not callable(self): raise TypeError("Callback must be callable")

cdef int user_cut_callback_bridge(cplex.CPXCENVptr xenv, void *cbdata, int wherefrom, void *cbhandle, int *useraction_p) noexcept:
    cb = <UserCutCallback>cbhandle
    
    cb.env = Env.from_ptr(<cplex.CPXENVptr>xenv)
    cb.cbdata = VoidPointer.from_ptr(<void*> cbdata)
    cb.wherefrom = wherefrom
    
    result = cb()

    cb.env = None
    cb.cbdata = None
    cb.wherefrom = None

    if result is None:
        raise ValueError("Expected return value to be CPX_CALLBACK_DEFAULT, CPX_CALLBACK_FAIL or CPX_CALLBACK_SET")
    
    useraction_p[0] = result

    if result == cplex.CPX_CALLBACK_FAIL: 
        return 1

    return 0

def CPXsetusercutcallbackfunc(Env env, LazyConstraintCallback cb):
    CALL_CPLEX(cplex.CPXsetusercutcallbackfunc(env.impl, user_cut_callback_bridge, <void*>cb))

def CPXcutcallbackadd(Env env, VoidPointer cbdata, int wherefrom, int nzcnt, double rhs, sense, cutind, cutval, int purgeable):
    CALL_CPLEX(cplex.CPXcutcallbackadd(env.impl,
                                       cbdata.impl,
                                       wherefrom,
                                       nzcnt,
                                       rhs,
                                       ord(sense),
                                       ArrayOfInt(cutind).impl,
                                       ArrayOfDouble(cutval).impl,
                                       purgeable
    ))

def CPXcutcallbackaddlocal(Env env, VoidPointer cbdata, int wherefrom, int nzcnt, double rhs, sense, cutind, cutval):
    CALL_CPLEX(cplex.CPXcutcallbackaddlocal(env.impl,
                                       cbdata.impl,
                                       wherefrom,
                                       nzcnt,
                                       rhs,
                                       ord(sense),
                                       ArrayOfInt(cutind).impl,
                                       ArrayOfDouble(cutval).impl
    ))

# Incumbent Callback

cdef class IncumbentCallback:
    cdef object python_callback

    env = None
    cbdata = None
    wherefrom = None
    isfeas = True
    _x = None
    objval = None

    def __cinit__(self):
        if not callable(self): raise TypeError("Callback must be callable")
    
    def get_x(self, Model model):
        n_cols = CPXgetnumcols(self.env, model)
        self._x.set_size(n_cols)
        return self._x.to_list()

cdef int incumbent_callback_bridge(cplex.CPXCENVptr xenv, void *cbdata, int wherefrom, void *cbhandle, double objval, double *x, int *isfeas_p, int *useraction_p) noexcept:
    cb = <IncumbentCallback>cbhandle
    
    cb.env = Env.from_ptr(<cplex.CPXENVptr>xenv)
    cb.cbdata = VoidPointer.from_ptr(<void*> cbdata)
    cb.wherefrom = wherefrom
    cb.objval = objval
    cb._x = ArrayOfDouble.from_ptr(<double*> x, 0)
    
    result = cb()
    isfeas_p[0] = int(cb.isfeas)

    cb.env = None
    cb.cbdata = None
    cb.wherefrom = None
    cb.isfeas = True
    cb.x = None
    cb.objval = None

    if result is None:
        raise ValueError("Expected return value to be CPX_CALLBACK_DEFAULT, CPX_CALLBACK_FAIL or CPX_CALLBACK_SET")

    useraction_p[0] = result

    if result == cplex.CPX_CALLBACK_FAIL:
        return 1

    return 0

def CPXsetincumbentcallbackfunc(Env env, IncumbentCallback cb):
    CALL_CPLEX(cplex.CPXsetincumbentcallbackfunc(env.impl, incumbent_callback_bridge, <void*>cb))
