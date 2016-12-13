# Performances

## Type safety
Take this function (from the [Performance tips](http://docs.julialang.org/en/release-0.5/manual/performance-tips/) of the Julia documentation).

```
function f(n)
   s = 0
   for i = 1:n
       s += i/2
   end
   s
end
```

```
function f2(n)
   s = 0.0
   for i = 1:n
       s += i/2
   end
   s
end
```

This is not optimised code, as it is not type-safe.  
A function is said to be type-safe when its return type depends only from the type of the input, not its values.  
type-safe functions can be optimised by the compiler.

In this case, if `n` is <=0, the result is an `Int64` (test it with `typeof(f(0))`), while if `n` is > 0 is a `Float64`.

The simplest way to make type-safe the function is to declare `s` as `0.0` so to force the result to be always a `Float64`:



The improvements are huge: 

```
    @time f(1000000000) 38.316970 seconds (3.00 G allocations: 44.704 GB, 32.15% gc time)

    @time f2(1000000000) 0.869386 seconds (5 allocations: 176 bytes)
```

For comparation, the same function can be written in C++, 


