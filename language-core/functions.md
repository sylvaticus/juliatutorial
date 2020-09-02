# 4 - Functions

Functions can be defined inline or using the `function` keyword, e.g.:

`f(x,y) = 2x+y`

```text
function f(x)
  x+2
end
```

\(a third way is to create an anonymous function and assign it to a nameplace, see later\)

## Arguments

Arguments are normally specified by position, while arguments given after a semicolon are instead specified by name.  
The call of the function must respect this distinction, calling positional argument by position and keyword arguments by name \(e.g., it is not possible to call positional arguments by name\).  
The last argument\(s\) \(whatever positional or keyword\) can be specified together with a default value.

`myfunction(a,b=1;c=2) = (a+b)*3 # definition with 2 position arguments and one keyword argument  
myfunction(10,c=13) # calling (10+1)*3` 

To declare a function parameter as being either a scalar type `T` or a vector `T` you can use an Union:`function f(par::Union{Float64, Vector{Float64}} = Float64[]) [...] end`

The ellipsis \(splat `...` \) can be uses in order to both specify a variable number of arguments and "splicing" a list or array in the parameters of a function call:

```text
values = [1,2,3]
function average(init, args...) #The parameter that uses the ellipsis must be the last one
  s = 0
  for arg in args 
    s += arg 
  end
  return init + s/length(args)
end
a = average(10,1,2,3)        # 12.0
a = average(10, values ...)  # 12.0
```

## Return value

Return value using the keyword `return` is optional: by default it is returned the last computed value.  
The return value can also be a tuple \(so returning effectively multiple values\):

```text
myfunction(a,b) = a*2,b+2
x,y = myfunction(1,2)
```

## Multiple-dispatch \(aka polymorphism\)

The same function can be defined with different number and type of parameters \(this is useful when the same kind of logical operation must be performed on different types\).  
When calling such functions, Julia will pick up the correct one depending from the parameters in the call \(by default the stricter version\).  
These different versions are named "methods" in Julia and, if the function is type-safe, dispatch is implemented at compile time and very fast.  
You can inspect the methods of a function with `methods(f)`.

The multiple-dispatch polymorphism is a generalisation of object-oriented run-time polymorphism where the same function name can perform different tasks depending on which is the owner's object's class, i.e. the polymorphism is applied only to a single parameter \(it remains true however that OO languages have usually multiple-parameters polymorphism at compile-time\).

## Templates \(type parametrisation\)

Functions can be further specified regarding on which types they work with, using templates:

`myfunction(x::T, y::T2, z::T2) where {T <: Number, T2} = 5x + 5y + 5z`

The above function first defines two types, T \(a subset of Number\) and T2, and then specifies each parameter of which of these two types must be.  
You can call it  with `(1,2,3)` or `(1,2.5,3.5)` as parameter, but not with `(1,2,3.5)` as the definition of `myfunction` constrains that the second and third parameter must be the same type \(whatever it is\).

## Functions as objects

Functions themselves are objects and can be assigned to new variables, returned, or nested. E.g.:

```text
f(x) = 2x # define a function f inline
a = f(2)  # call f and assign the return value to a
a = f     # bind f to a new variable name (it's not a deep copy)
a(5)      # call again the (same) function
```

## Call by reference / call by value

Parameters given to functions are normally passed by reference.  
Functions that do change their arguments have their name, BY CONVENTION, postponed by a `!`, e.g.:

`myfunction!(ref_par, other_pars)` \(the parameter that will be changed is by convention the first one\)

## Anonymous functions

Sometimes we don't need to give a name to a function \(e.g. within the `map` function\). To define anonymous \(nameless\) functions we can use the `->` syntax, like this:

```text
x -> x^2 + 2x - 1
```

This defines a nameless function that takes an argument, calls it `x`, and produces `x^2 + 2x - 1`. Multiple arguments can be provided using tuples: `(x,y,z) -> x + y + z`

You can still assign an anonymous function to a variable: `f = (x,y) -> x+y`

## Broadcast

You can "broadcast" a function to work over each elements of an array \(singleton\): `myArray = broadcast(i -> replace(i, "x" => "y"), myArray)`. This is equivalent to \(note the dot\): `myArray = replace.(myArray, Ref("x" => "y"))` \(`Ref()` is needed to protect the pair \(x,y\) from trying to be broadcasted itself as well\).

While in the past broadcast was available on a limited number of core functions only, the `f.()` syntax is now  automatically available for any function, including the ones you define.

_While an updated, expanded and revised version of this chapter is available in "Chapter 3 - Control Flow and Functions" of [Antonello Lobianco (2019), "Julia Quick Syntax Reference", Apress](https://julia-book.com), this tutorial remains in active development._
