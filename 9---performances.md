# Performances 

Julia is relativelly fast when working with `Any` data, but when we restrict a variable to a specific type of data it runs with the same order of magnitude of C.

This mean you can code quite quickly and then, only on the parts that constitute a bootleness, you can concentrate and add specific typing.

The following is a benchmark of the same function in Julia, Python, R and C++.

## Julia

```
function f(n)
   s = 0
   for i = 1:n
       s += i/2
   end
   s
end

function f2(n)
   s = 0.0
   for i = 1:n
       s += i/2
   end
   s
end
```

f (non optimised): 

    @time f(1000000000) 38.316970 seconds (3.00 G allocations: 44.704 GB, 32.15% gc time)

f2 ("optimised"):

    @time f2(1000000000) 0.869386 seconds (5 allocations: 176 bytes)


## g++

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

Optimised (compiled with -O3) : 0.83 seconds

## Python

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

Non optimised (wihtout using numba and the @jit decorator): 98 seconds

Optimised (using the just in time compilation):0.88 seconds

## R

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

Optimised (vectorised): the function return an error, as too much memory to build the arrays!

Of course the result is just n*(n+1)/4, so the best language is the human mind.. but still compilers are doing a pretty smart optimisation!

