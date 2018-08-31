# 10 - Performances \(parallelisation, debugging, profiling..\)

Julia is relatively fast when working with `Any` data, but when we restrict a variable to a specific type \(or a Union of a few types\)  it runs with the same order of magnitude of C.

This mean you can code quite quickly and then, only on the parts that constitute a bottleneck, you can concentrate and add specific typing.

## Type safety

**NOTE: This function in Julia 1.0 works very fast in both the two versions presented here \(with `s=0` or `s=0.0`. I leave this discussion to highlight the improvements made in the compiler subset in Julia 1.0, that allow to optimise also type unsafe functions when the set of possible types is limited, like in this case.**

Take this function \(from the [Performance tips](https://docs.julialang.org/en/stable/manual/performance-tips/) of the Julia documentation\).

```text
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

```text
function f2(n)
   s = 0.0
   for i = 1:n
       s += i/2
   end
   s
end
```

The improvements are huge:

```text
    @time f(1000000000) 38.316970 seconds (3.00 G allocations: 44.704 GB, 32.15% gc time)
    @time f2(1000000000) 0.869386 seconds (5 allocations: 176 bytes)
```

## Benchmarking

For comparison, the same function can be written in C++, Python and Julia,

### g++

```text
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

```text
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

```text
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

Julia provides core functionality to parallelise code using processes. These can be even in different machines, where connection is realised trough SSH.  
Threads instead \(that are limited to the same CPU but, contrary to processes, share the same memory\) are not yet implemented \(as it is much more difficult to "guarantee" safe multi-threads than safe multi-processes\).

The following notebook shows how to use several functions to facilitate code parallelism:

{% embed data="{\"url\":\"http://nbviewer.jupyter.org/github/sylvaticus/juliatutorial/blob/master/assets/Parallel%20computing.ipynb\",\"type\":\"link\",\"title\":\"Notebook on nbviewer\",\"description\":\"Check out this Jupyter notebook!\",\"icon\":{\"type\":\"icon\",\"url\":\"http://nbviewer.jupyter.org/static/ico/apple-touch-icon-144-precomposed.png?v=5a3c9ede93e2a8b8ea9e3f8f3da1a905\",\"width\":144,\"height\":144,\"aspectRatio\":1},\"thumbnail\":{\"type\":\"thumbnail\",\"url\":\"http://ipython.org/ipython-doc/dev/\_images/ipynb\_icon\_128x128.png\",\"width\":128,\"height\":128,\"aspectRatio\":1}}" %}

## Debugging

Unfortunately the availability of debugging capabilities like graphical step-by-step in a function or setting breackpoints depends on the versions of Julia. Julia evolved quickly, so many debugging tools previously available doesn't work \(yet\) in Julia 1.0 \(a promising package is [Rebugger](https://github.com/timholy/Rebugger.jl)\).

Still, this is somehow mitigated by Julia being a interactive environment, so you can still run your code piece-by-piece.

Here you can find some common operations concerning introspection and debugging:

* Retrieve function signatures: `methods(myfunction)`
* Discover which specific method is used \(within the several available, as Julia supports multiple-dispatch aka polymorfism\): `@which myfunction(myargs)`
* Discover which fields are part of an object: `fieldnames(myobj`
* Discover which type \(loosely a "class" in OO languages\) an object instance is: `typeof(a)`
* Get more information about an object: `dump(myobj)`

## Profiling

Profiling is the "art" of finding bottlenecks in the code.

A simple way to time a part of the code is to simply type `@time myFunc(args)` \(but be sure you ran that function at least once, or you will measure compile time rather than run-time\) or `@benchmark myFunc(args)` \(from package `BenchmarkTools`\)

For more extensive coverage, Julia comes with a integrated statistical profile, that is, it runs every x milliseconds and memorize in which line of code the program is at that moment.

Using this sampling method, at a cost of loosing some precision, profiling can be very efficient, in terms of very small overheads compared to run the code normally.

* Profile a function: `Profile.@profile myfunct()` \(best after the function has been already ran once for JIT-compilation\). 
* Print the profiling results: `Profile.print()` \(number of samples in corresponding line and all downstream code; file name:line number; function name;\)
* Explore a chart of the call graph with profiled data: `ProfileView.view()` \(from package `ProfileView`, not yet available to Julia 1 at time of writing\).
* Clear profile data: `Profile.clear()`

