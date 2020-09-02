# 10 - Performance \(parallelisation, debugging, profiling..\)

Julia is relatively fast when working with `Any` data, but when the JIT compiler is able to infer the exact type of an object \(or a Union of a few types\) Julia runs with the same order of magnitude of C.

As example, here is how a typical loop-based function compare with the same function written using  other programming languages (to be fair: these other programming languages can greatly improve the way they compute this function, e.g. using vectorised code):

**Julia:**

```julia
function f(n)
   s = 0
   for i = 1:n
       s += i/2
   end
   s
end

@time f(1000000000) # 0.869386 seconds (5 allocations: 176 bytes)
```

**g++:**

```C
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

Non optimised: 2.48 seconds Optimised \(compiled with the -O3 switch\) : 0.83 seconds

**Python:**

```python
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

Non optimised \(wihtout using numba and the @jit decorator\): 98 seconds Optimised \(using the just in time compilation\):0.88 seconds

**R:**

```R
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

Non optimised: 287 seconds Optimised \(vectorised\): the function returns an error \(on my 8GB laptop\), as too much memory is required to build the arrays!

**Human mind:**

Of course the result is just n\*\(n+1\)/4, so the best programming language is the human mind.. but still compilers are doing a pretty smart optimisation!


### Type annotation

In general (see above for exceptions) type annotation is not necessary. Only in the few cases where the compiler can't determine the type it is useful for improving performance.

Some tips to improve performance are:

- avoid global variables and run your performance-critical code within functions rather than in the global scope;
- annotate the inner type of a container, so it can be stored in memory contiguously;
- annotate the fields of composite types (use eventually parametric types);
- loop matrices first by column and then by row, as Julia is column-mayor;

## Code parallelisation

Julia provides core functionality to parallelise code using processes. These can be even in different machines, where connection is realised trough SSH. Threads instead are limited to the same CPU but, contrary to processes, share the same memory. An high-level API for multithreadding has been introduces in Julia 1.3

### Paralellisation using multiple processes

[This notebook](http://nbviewer.jupyter.org/github/sylvaticus/juliatutorial/blob/master/assets/Parallel%20computing.ipynb) shows how to use several functions to facilitate code parallelism:

### Paralellisation using multiple threads

Here is an example on how to use the new @spawn macro in Julia >= 1.3threads on a function that produces something, saving the results to a vector where order doesn't matter and the computational process of any record is independent from those of any other record.


```
import Base.Threads.@spawn

struct myobj
    o
end

singleOp(obj,x,y) = (x .+ y) .* obj.o

function multipleOps(obj,xbatch,ybatch)
    out = Array{Array{Float64,1},1}(undef,size(xbatch,1))
    for i in 1:size(xbatch,1)
        out[i] = singleOp(obj,xbatch[i,:],ybatch[i,:])
    end
    return out
end

obj = myobj(2)
xbatch = [1 2 3; 4 5 6]
ybatch = [10 20 30; 40 50 60]

results = @spawn multipleOps(obj,xbatch,ybatch)
finalres = sum(fetch(results))
```

Consider however the advantage in terms of computational time became interesting only for relatively computationally expensive operations:

```
using BenchmarkTools

xbatch = rand(32,50)
ybatch = rand(32,50)
@benchmark sum(fetch(@spawn multipleOps(obj,xbatch,ybatch))) #60 μs
@benchmark sum(multipleOps(obj,xbatch,ybatch)) #24 μs

xbatch = rand(32,50000)
ybatch = rand(32,50000)
@benchmark sum(fetch(@spawn multipleOps(obj,xbatch,ybatch))) # 58 ms
@benchmark sum(multipleOps(obj,xbatch,ybatch)) # 66 ms
```

## Debugging

Full debugger (both text based and graphical) is now available in Julia. The base functionality is provided by the https://github.com/JuliaDebug/JuliaInterpreter.jl[JuliaInterpreter.jl] package, while the user interface is provided by the command-line packages https://github.com/JuliaDebug/Debugger.jl[Debugger.jl] and https://github.com/timholy/Rebugger.jl[Rebugger.jl] or the https://junolab.org/[Juno IDE] itself: just type `Juno.@enter myFunction(args)` in Juno to start its graphical debugger.

Some other common operations concerning introspection and debugging:

* Retrieve function signatures: `methods(myfunction)`
* Discover which specific method is used \(within the several available, as Julia supports multiple-dispatch aka polymorfism\): `@which myfunction(myargs)`
* Discover which fields are part of an object: `fieldnames(myobj`
* Discover which type \(loosely a "class" in OO languages\) an object instance is: `typeof(a)`
* Get more information about an object: `dump(myobj)`

## Profiling

Profiling is the "art" of finding bottlenecks in the code.

A simple way to time a part of the code is to simply type `@time myFunc(args)` \(but be sure you ran that function at least once, or you will measure compile time rather than run-time\) or `@benchmark myFunc(args)` \(from package `BenchmarkTools`\)

For more extensive coverage, Julia comes with a integrated statistical profiler, that is, it runs every x milliseconds and memorizes in which line of code the program is at that moment.

Using this sampling method, at a cost of loosing some precision, profiling can be very efficient, in terms of very small overheads compared to the code being run normally.

* Profile a function: `Profile.@profile myfunct()` \(best after the function has been already run once for JIT-compilation\).
* Print the profiling results: `Profile.print()` \(number of samples in corresponding line and all downstream code; file name:line number; function name;\)
* Explore a chart of the call graph with profiled data: `ProfileView.view()` \(from package `ProfileView`\).
* Clear profile data: `Profile.clear()`

_While an updated, expanded and revised version of this chapter is available in "Chapter 8 - Effectively Write Efficient Code" of [Antonello Lobianco (2019), "Julia Quick Syntax Reference", Apress](https://julia-book.com), this tutorial remains in active development._
