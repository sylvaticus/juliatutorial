# 3 - Control flow

All typical control flow \(`for`, `while`, `if`/`else`, `do`\) are supported, and parenthesis around the condition are not necessary. Multiple conditions can be specified in the for loop, e.g.:\`

```text
for i = 1:2, j = 2:4
    println(i*j)
end
```

`break` and `continue` are supported and works as expected.

Julia support list comprehension and maps:

* `[myfunction(i) for i in [1, 2, 3]]`
* `[x + 2y for x in [10, 20, 30], y in [1, 2, 3]]`
* `mydict = Dict(); [mydict[i]=value  for (i, value) in enumerate(mylist)]` \(`enumerate` returns an iterator to tuples with the index and the value of elements in an array\)
* `[students[name] = sex for (name,sex) in zip(names,sexes)]` \(`zip` returns an iterator of tuples pairing two or multiple lists, e.g. \[\("Marc","M"\),\("Anne","F"\)\] \)
* `map((n,s) -> students[n] = s, names, sexes)` \(`map` applies a function to a list of arguments\) When mapping a function with a single parameter, the parameter can be omitted: `a = map(f, [1, 2, 3])` is equal to  `a = map(x->f(x), [1, 2, 3])`.

Ternary operator is supported as `a ? b : c` \(if `a` is true, then `b`, else `c`\). Put attenction to wrap the `?` and `:` operators with space.

## Logical operators

* And: `&&`
* Or:  `||`
* Not: `!`

Not to be confused with the bitwise operators `&` and `|`.

Currently `and` and `or` aliases to  respectively `&&` and `||`has not being imlemented.

## Do blocks

Do blocks allow to define anonymous functions that are passed as first argument to the outer functions. For example, `findall(x -> x == value, myarray)` expects the first argument to be a function. Every time the first argument is a function, this can be written at posteriori with a do block:

```text
findall(myarray) do x
    x == value
end
```

This defines `x` as a variable that is passed to the inner contend of the `do` block. It is the task of the outer function to where to apply this anonymous function \(in this case to the `myarray` array\) and what to do with its return values \(in this case boolean values used for computing the indexes in the array\). More infos on the do blocks: [https://en.wikibooks.org/wiki/Introducing\_Julia/Controlling\_the\_flow\#Do\_block](https://en.wikibooks.org/wiki/Introducing_Julia/Controlling_the_flow#Do_block) , [https://docs.julialang.org/en/stable/manual/functions/\#Do-Block-Syntax-for-Function-Arguments-1](https://docs.julialang.org/en/stable/manual/functions/#Do-Block-Syntax-for-Function-Arguments-1)

_While an updated, expanded and revised version of this chapter is available in "Chapter 3 - Control Flow and Functions" of [Antonello Lobianco (2019), "Julia Quick Syntax Reference", Apress](https://julia-book.com), this tutorial remains in active development._
