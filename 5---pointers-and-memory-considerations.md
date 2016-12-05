
# Memory and copy issues

Equal sign \(a=b\)

* simple types are deep copied
* containers of simple types \(or other containers\) are shadow copied \(their internal is only referenced, not copied\)

copy\(x\)

* simple types are deep copy
* containers of simple types are deep copied
* containers of containers: the content is shadow copied \(the content of the content is only referenced, not copied\)

deepcopy\(x\)

* everything is deepcopy recursively

# Metaprogramming

Julia represents its own code as a data structure accessible from the language itself. Since code is represented by objects that can be created and manipulated from within the language, it is possible for a program to transform and generate its own code, that is to create powerful macros (the term "metaprogramming" refers to the possibility to write code that write codes that is then evalueted)

Note the difference with C or C++ macros. There, macros work performing textual manipulation and substitution before any actual parsing or interpretation occurs.

In Julia, macros works when the code has been already parsed and organised in a syntax tree, and hence the semantic is much riched and allows for much more powerful manipulations. 

The colon \`:\` prefix operator refers to an unevalueted expression. Such expression can be saved and then evalueted in a second moment using `eval(myexpression)`:

```
expr = :(1+2)  # save the `1+2` expression in the `expr` expression
eval(expr)     # here the expression is evalueted and the code returns 3    
```

An alternative of the `:([...])` operator is to use the `quote [...] end` block.

Or also, starting from a string (that is, the original representation of source code for Julia):
```
expr = parse("1+2")  # parses the string "1+2" and saves the `1+2` expression in the `expr` expression, same as expr = :(1+2)
eval(expr)           # here the expression is evalueted and the code returns 3    
```

What's in an expression? Using `fiendnames(expr)` or `dump(expr)` we found that `expr` is an `Expr` object made of three fields of type `Symbol`: `:head`, `:args` and `:typ` :

* `:head` defines the type of Expression, in this case `:call`
* `:args` is an array of elements that can be symbols, literal values or other expressions. In this case they are `[:+, 1, 3]`
* `typ` specify the type of return value of the expression

The expression can be also directly constructed from the tree: `
expr = Expr(:call, :+, 1, 2)` is equivalent to `expr = parse("1+2")` or `expr = :(1+2)`.
 



