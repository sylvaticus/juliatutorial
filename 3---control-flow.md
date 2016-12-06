# Control flow

All typical control flow `for`, `while`, `if`/`else`, `do` are supported, and parenthesis around the condition are not necessary. Multiple conditions can be specified in the for loop, e.g.:`

```
for i=1:2,j=2:4
 println(i*j)
end
```

`break` and `continue` are supported and works as expected

Julia support list comprehension:

`[myfunction(i) for i in [1,2,3]]`

`[mydict[i]=value  for (i, value) in enumerate(mylist)]`



