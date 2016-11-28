# Functions

Functions can be defined inline or using the `function` keyword, e.g.:

`f(x,y) = 2x+y`

```
function f(x)
  x+2
end
```

Return value is optional: by default is returned the last computed value

## Multiple-dispatch (aka polymorphism)

The same function can be defined with different number and type of parameters (useful when the same kind of logical operation must be performed on different types).

When calling such functions, Julia will pick it up the correct one depending from the parameters in the call (by default the stricter version).

These different versions are named "methods" in Julia.

## Templates (type parametrisation)
Functions can be further specified with which type they works using templates:

`myfunction{T<:Number,T2}(x::T,y::T2,z::T2) = 5x + 5y + 5z`

The above function first defines two types, T (a subset of Number) and T2, and then specify each parameter of which of these two types must be.






## Call by reference / call by value

Parameters gived to functions are normally by value.

Functions that accept parameters by reference have their name, BY CONVENCTION, postponed by a `!`, e.g.:

`myfunction!(ref_par, other_pars)` (the parameter given by reference is usually the first one)










