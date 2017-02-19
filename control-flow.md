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
* `[mydict[i]=value  for (i, value) in enumerate(mylist)]` (`enumerate` returns an iterator to tuples with the index and the value of elements in an array)
* `[students[name] = sex for (name,sex) in zip(names,sexes)]` (`zip` returns an iterator of tuples pairing two or multiple lists, e.g. [("Marc","M"),("Anne","F")] )
* `map(x-> x*2,[1,2])` (`map` applies a function to a list of arguments)

Ternary operator is supported as `a ? b : c` (if a is true, then b, else c).

## Do blocks




