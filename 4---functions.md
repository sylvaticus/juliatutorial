# Functions

Functions can be defined inline or using the `function keyword, e.g.:`

`f(x,y) = 2x+y`

```
function f(x)
  x+2
end
```

## Arguments

Arguments are specified by position. Arguments given after a semicolon are instead specified by name.

## Return value

Return value using the keywork `return is optional: by default is returned the last computed value.`

It can also be a turple \(so to return multiple values\):

```
myfunction(a,b) = a+1,b+1
x,y = myfunction(1,2)
```

## Multiple-dispatch \(aka polymorphism\)

The same function can be defined with different number and type of parameters \(useful when the same kind of logical operation must be performed on different types\).

When calling such functions, Julia will pick it up the correct one depending from the parameters in the call \(by default the stricter version\).

These different versions are named "methods" in Julia.

## Templates \(type parametrisation\)

Functions can be further specified with which type they works using templates:

`myfunction{T<:Number,T2}(x::T,y::T2,z::T2) = 5x + 5y + 5z`

The above function first defines two types, T \(a subset of Number\) and T2, and then specify each parameter of which of these two types must be.

## Default arguments

The last argument\(s\) can be specified together with a default value. Default parameters can \(but not have to\) be separated from mandatory parameter by a semicolumn instead of a comma.

`myfunction(a,b;c=1) = (2a+2b)*c`

At call time default argumens must be specified by name, while normal argument by position.

## Functions as objects

Functions themselves are objects and can be assigned to new variables, returned, or nested. E.g.:

```
f(x) = 2x # define a function f inlinea = f(2)  # call f and assign the return value to a
a = f     # bind f to a new variable name (it's not a deep copy)a(5)      # call again the function
```

## Call by reference / call by value

Parameters gived to functions are normally passed by reference.

Functions that do change their arguments have their name, BY CONVENCTION, postponed by a `!, e.g.:`

`myfunction!(ref_par, other_pars) (the parameter that will be changed is by convention the first one)`

