# Performances \(parallelisation, debugging, profiling..\)

Julia is relatively fast when working with `Any` data, but when we restrict a variable to a specific type it runs with the same order of magnitude of C.

This mean you can code quite quickly and then, only on the parts that constitute a bottleneck, you can concentrate and add specific typing.

## Type safety

Take this function \(from the [Performance tips](https://docs.julialang.org/en/stable/manual/performance-tips/) of the Julia documentation\).

```
function f(n)
   s = 0
   for i = 1:n
       s += i/2
   end
   s
end
```

This is not optimised code, as it is not type-safe.  
A function is said to be type-safe when its return type depends only from the type of the input, not from its values.  
Type-safe functions can be optimised by the compiler.  
In this case, if `n` is &lt;=0, the result is an `Int64` \(test it with `typeof(f(0))`\), while if `n` is &gt; 0, it is a `Float64`.

The simplest way to make type-safe the function is to declare `s` as `0.0` so to force the result to be always a `Float64`:

```
function f2(n)
   s = 0.0
   for i = 1:n
       s += i/2
   end
   s
end
```

The improvements are huge:

```
    @time f(1000000000) 38.316970 seconds (3.00 G allocations: 44.704 GB, 32.15% gc time)
    @time f2(1000000000) 0.869386 seconds (5 allocations: 176 bytes)
```

## Benchmarking

For comparison, the same function can be written in C++, Python and Julia,

### g++

```
#include <iostream>
#include <chrono>

using namespace std;
int main() {
    chrono::steady_clock::time_point begin = chrono::steady_clock::now();
    int steps=1000000000;
    double s = 0;
    for (int i=1;i<(steps+1);i++){
       s +=  (i/2.0) ; 
    }
    cout << s << endl;
    chrono::steady_clock::time_point end= chrono::steady_clock::now();

    cout << "Time difference (sec) = " << (chrono::duration_cast<std::chrono::microseconds>(end - begin).count()) /1000000.0  << endl;
}
```

Non optimised: 2.48 seconds  
Optimised \(compiled with the -O3 switch\) : 0.83 seconds

### Python

```
from numba import jit
import time

# jit decorator tells Numba to compile this function.
# The argument types will be inferred by Numba when function is called.
@jit
def main():
    steps=1000000000;
    s = 0;
    for i in range(1,steps+1):
       s +=  (i/2.0)
    print(s)

start_time = time.time()
main()
print("--- %s seconds ---" % (time.time() - start_time))
```

Non optimised \(wihtout using numba and the @jit decorator\): 98 seconds  
Optimised \(using the just in time compilation\):0.88 seconds

### R

```
f <- function(n){
  # Start the clock!
  ptm <- proc.time()
  s <- 0
  for (i in 1:n){
    s <- s + (i/2)
  }
  print(s)
  # Stop the clock
  proc.time() - ptm
}
```

Non optimised: 287 seconds  
Optimised \(vectorised\): the function returns an error \(on my 8GB laptop\), as too much memory is required to build the arrays!

### Human mind

Of course the result is just n\*\(n+1\)/4, so the best programming language is the human mind.. but still compilers are doing a pretty smart optimisation!

## Code parallelisation

Julia provides core funcionality to parallelise code using processes. These can be even in different machines, where connection is realised trough SSH.  
Threads instead \(that are limited to the same CPU but differently than processes share the same memory\) are not yet implemented \(as it is much more difficult to "guarantee" safe multi-threads than safe multi-processes\).

The following notebook shows how to use several functions to facilitate code parallelism:

[http://nbviewer.jupyter.org/github/sylvaticus/juliatutorial/blob/master/assets/Parallel computing.ipynb](http://nbviewer.jupyter.org/github/sylvaticus/juliatutorial/blob/master/assets/Parallel computing.ipynb)

## Debugging

In Juno to activate a graphical debugger just type in the console `Juno.@step myfunc()`. A hover toolbox will appear with buttons to go next line, enter sub-function or leave the current one.

Here you can find some common operations concerning introspection and debugging:

* Retrieve function signatures: `methods(myfunction)`
* Retrieve object properties: `fieldnames(myobject)`
* Discover which specific method is used \(within the several available, as Julia supports multiple-dispatch aka polymorfism\): `@which myfunction(myargs)`
* Discover which type \(loosely a "class" in OO languages\) an object instance is: `typeof(a)`
* Discover which fields are part of an object: `fieldnames(myobj)`
* Get more information about an object: `dump(myobj)`

## Profiling

Profiling is the "art" of finding boottlenecks in the code.

A simple way to time a part of the code is to simply type `@time myFunc()` or `@benchmark myFunc()` \(from package `BenchmarkTools`\)

For more extensive coverage, Julia comes with a integrated statistical profile, that is, it runs every x milliseconds and memorize in which line of code the program is at that moment.

Using this sampling method, at a cost of loosing some precision, profiling can be very efficient, in terms of very small hoverheads compared to run the code normally.

* Profile a function: `@profile myfunct()` \(best after the function has been already ran once for JIT-compilation\). 
* Print the profiling results: `Profile.print()` \(number of samples in corresponding line and all downstream code; file name:line number; function name;\)
* Explore a chart of the call graph with profiled data: `ProfileView.view()` \(from package `ProfileView`\)
* Clear profile data: `Profile.clear()`



