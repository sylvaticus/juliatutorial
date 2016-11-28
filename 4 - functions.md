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



Parameters gived to functions are normally by value.

Functions that accept parameters by reference have their name, BY CONVENCTION, postponed by a `!`, e.g.:

`myfunction!(ref_par, other_pars)` (the parameter given by reference is usually the first one)










