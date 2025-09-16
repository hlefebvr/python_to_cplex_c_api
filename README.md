# Wrapper to C API from Cplex 

Python wrapper to the Cplex C API. This may be useful in case one wants to use
funcitonallities of Cplex which are not available through the [official python
API](https://www.ibm.com/docs/en/icos/22.1.1?topic=tutorials-python-tutorial)
but still code in Python.  

## Dependencies

- [cython](https://cython.readthedocs.io/en/latest/src/quickstart/install.html)
- [Cplex](https://www.ibm.com/products/ilog-cplex-optimization-studio)

## Compile the C Wrapper

The code uses the environment variables `CPLEX_LIBRARY` and `CPLEX_INCLUDE_DIR`. 
Be sure to have them set up. Here is an example:

```
export CPLEX_LIBRARY=/opt/ibm/ILOG/CPLEX_Studio2211/cplex/lib/x86-64_linux/static_pic/
export CPLEX_INCLUDE_DIR=//opt/ibm/ILOG/CPLEX_Studio2211/cplex/include/ilcplex/
```

On the HPC, run:
```
export CPLEX_LIBRARY=/software/ilog/22.1.1/cplex/lib/x86-64_linux/static_pic/
export CPLEX_INCLUDE_DIR=/software/ilog/22.1.1/cplex/include/ilcplex/
```

Then, run the following commands.

```
cd cplex_c_api_wrapper
python3 setup.py build_ext --inplace
```

## Run Example

```
python3 example.py
```
