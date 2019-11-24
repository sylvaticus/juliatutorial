# 10 - Performances \(parallelisation, debugging, profiling..\)

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

In general (see above for exceptions) type annotation is not necessary. Only in the few cases where the compiler can't determine the type it is useful for improving performances.

Some tips to improve performances are:

- avoid global variables and run your performance-critical code within functions rather than in the global scope;
- annotate the inner type of a container, so it can be stored in memory contiguously;
- annotate the fields of composite types (use eventually parametric types);
- loop matrices first by column and then by row, as Julia is column-mayor;

## Code parallelisation

Julia provides core functionality to parallelise code using processes. These can be even in different machines, where connection is realised trough SSH. Threads instead \(that are limited to the same CPU but, contrary to processes, share the same memory\) are not yet implemented \(as it is much more difficult to "guarantee" safe multi-threads than safe multi-processes\).

[This notebook](http://nbviewer.jupyter.org/github/sylvaticus/juliatutorial/blob/master/assets/Parallel%20computing.ipynb) shows how to use several functions to facilitate code parallelism:

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

For more extensive coverage, Julia comes with a integrated statistical profile, that is, it runs every x milliseconds and memorize in which line of code the program is at that moment.

Using this sampling method, at a cost of loosing some precision, profiling can be very efficient, in terms of very small overheads compared to run the code normally.

* Profile a function: `Profile.@profile myfunct()` \(best after the function has been already ran once for JIT-compilation\).
* Print the profiling results: `Profile.print()` \(number of samples in corresponding line and all downstream code; file name:line number; function name;\)
* Explore a chart of the call graph with profiled data: `ProfileView.view()` \(from package `ProfileView`\).
* Clear profile data: `Profile.clear()`

_While an updated, expanded and revised version of this chapter is available in "Chapter 8 - Effectively Write Efficient Code" of [Antonello Lobianco (2019), "Julia Quick Syntax Reference", Apress](https://julia-book.com), this tutorial remains in active development._
