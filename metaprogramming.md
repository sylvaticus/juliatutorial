# Metaprogramming

Julia represents its own code as a data structure accessible from the language itself. Since code is represented by objects that can be created and manipulated from within the language, it is possible for a program to transform and generate its own code, that is to create powerful macros (the term "metaprogramming" refers to the possibility to write code that write codes that is then evaluated).

Note the difference with C or C++ macros. There, macros work performing textual manipulation and substitution before any actual parsing or interpretation occurs.

In Julia, macros works when the code has been already parsed and organised in a syntax tree, and hence the semantic is much richer and allows for much more powerful manipulations.


## Expressions

There are really many way to create an expression:

#### Colon prefix operator
The colon \`:\` prefix operator refers to an unevaluated expression. Such expression can be saved and then evaluated in a second moment using `eval(myexpression)`:

```
expr = :(1+2) # save the `1+2` expression in the `expr` expression
eval(expr)    # here the expression is evaluated and the code returns 3
```

Note that $ interpolation (like for strings) is supported:

```
a = 1
expr = :($a+2) # expr is now :(1+2)
```

#### Quote block
An alternative of the `:([...])` operator is to use the `quote [...] end` block.

#### Parse a string
Or also, starting from a string (that is, the original representation of source code for Julia):
```
expr = parse("1+2") # parses the string "1+2" and saves the `1+2` expression in the `expr` expression, same as expr = :(1+2)
eval(expr)          # here the expression is evaluated and the code returns 3
```

#### Use the Exp constructor with a tree
The expression can be also directly constructed from the tree: `
expr = Expr(:call, :+, 1, 2)` is equivalent to `expr = parse("1+2")` or `expr = :(1+2)`.



But what there is in an expression? Using `fiendnames(expr)` or `dump(expr)` we can find that `expr` is an `Expr` object made of three fields of type `Symbol`: `:head`, `:args` and `:typ` :

* `:head` defines the type of Expression, in this case `:call`
* `:args` is an array of elements that can be symbols, literal values or other expressions. In this case they are `[:+, 1, 1]`
* `typ`   specify the type of return value of the expression



## Symbols

The second meaning of the `:` operator is to create symbols, and it is equivalent to the `Symbol()` function that concatenate its arguments to form a symbol:

`a = :foo10` is equal to `a=Symbol("foo",10)`

A useful example to highlight what a symbol is:

```
a = 2;
ex = Expr(:call, :*, a, :b) # ex is equal to :(2 * b). Note that b doesn't even need to be defined
a = 0; b = 2;               # no matter what now happens to a, as a is evaluated at the moment of creating the expression and the expression stores its value, without any more reference to the variable
eval(ex)                    # returns 4, not 0
```

## Macros
The possibility to represent code into expressions is at the heart of the usage of macros.
Macros in Julia take one or more input expressions and return a modified expressions (at parse time).
This contrast with normal functions that, at runtime, take the input values (arguments) and return a computed value.

**Macro definition**
```
macro unless(test_expr, branch_expr)
  quote
    if !$test_expr
      $branch_expr
    end
  end
end
```
**Macro call**
```
array = [1, 2, 'b']
@unless 3 in array println("array does not contain 3") # here test_expr is "3 in array" and branch_expr is "println("array does not contain 3")"
```

Like for strings, the `$` interpolation operator will substitute the variable with its content, in this context the expression.
So the "expanded" macro will look in this case as:
```
if !(42 in arr)
println("arr does not contain 42)
end
```

Attention that the macro doesn't create a new scope, and variables declared or assigned within the macro may collide with variables in the scope of where the macro is actually called.
