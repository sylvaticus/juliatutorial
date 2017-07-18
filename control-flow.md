# Control flow

All typical control flow (`for`, `while`, `if`/`else`, `do`) are supported, and parenthesis around the condition are not necessary. Multiple conditions can be specified in the for loop, e.g.:`

```
for i=1:2,j=2:4
 println(i*j)
end
```

`break` and `continue` are supported and works as expected.


Julia support list comprehension and maps:

* `[myfunction(i) for i in [1,2,3]]`
* `[x + 2y for x in [10,20,30], y in [1,2,3]]`
* `mydict = Dict(); [mydict[i]=value  for (i, value) in enumerate(mylist)]` (`enumerate` returns an iterator to tuples with the index and the value of elements in an array)
* `[students[name] = sex for (name,sex) in zip(names,sexes)]` (`zip` returns an iterator of tuples pairing two or multiple lists, e.g. [("Marc","M"),("Anne","F")] )
* `map(x-> x*2,[1,2])` (`map` applies a function to a list of arguments)

Ternary operator is supported as `a ? b : c` (if a is true, then b, else c).

## Logical operators
* And: `&&`
* Or:  `||`
* Not: `!`

Not to be confused with the bitwise operators `&` and `|`.

A proposal is currently open to alias `and` and `or` with respectively `&&` and `||`, but it has not yet beeing committed.


## Do blocks

Do blocks allow to define anonymous functions that are passed as first argument to the outer functions.
For example, `find(x -> x == value, myarray)` expect the first argument to be a function. Everytime the first argument is a function, this can be written at posteriori with a do block:

```
find(smallprimes) do x
       x == 13
end
```
This defines x as a variable that is passed to the inner contend of the do block. It is the task of the outer function to where to apply this anonymous function (in this case to the smallprimes array) and what to do with its return values (in this case bolean values used for computing he indexes in the array).
More infos on the do blocks: https://en.wikibooks.org/wiki/Introducing_Julia/Controlling_the_flow#Do_block , http://docs.julialang.org/en/stable/manual/functions/#do-block-syntax-for-function-arguments








