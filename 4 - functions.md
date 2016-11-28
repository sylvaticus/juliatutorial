# Functions

Functions can be defined inline or trought the `function` keyword, e.g.:

`f(x,y) = 2x+y`

```
function f(x)
  x+2
end
```

Parameters gived to functions are normally by value.

Functions that accept parameters by reference have their name, BY CONVENCTION, postponed by a `!`, e.g.:

`myfunction!(ref_par, other_pars)` (the parameter given by reference is usually the first one)










