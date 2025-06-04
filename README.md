# Wrapper to C API from Cplex 

## Dependencies

- [cython](https://cython.readthedocs.io/en/latest/src/quickstart/install.html)
- [Cplex](https://www.ibm.com/products/ilog-cplex-optimization-studio)

## Compile the C Wrapper

The code uses the environment variables `CPLEX_LIBRARY` and `CPLEX_INCLUDE_DIR`. 
Be sure to have them set up. Here is an example:

```
export CPLEX_LIBRARY= /opt/ibm/ILOG/CPLEX_Studio2211/cplex/lib/x86-64_linux/static_pic/
export CPLEX_INCLUDE_DIR= /opt/ibm/ILOG/CPLEX_Studio2211/cplex/lib/x86-64_linux/static_pic/
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
