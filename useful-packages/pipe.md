# Pipe

The [`Pipe`](https://github.com/oxinabox/Pipe.jl) package allows you to improve the Pipe operator `|>` in Julia Base.

Chaining \(or "piping"\) allows to string together multiple function calls in a way that is at the same time compact and readable. It avoids saving intermediate results without having to embed function calls within one another.

With the chain operator `|>` instead, the code to the right of  `|>` operates on the result from the code to the left of it. In practice, what is on the left becomes the  argument of the function call\(s\) that is on the right.

Chaining is very useful in data manipulation. Let's assume that you want to use the following \(silly\) functions operate one after the other on some data and print the  final result:

`add6(a) = a+6; div4(a) = 4/a;`

You could either introduce temporary variables or embed the function calls:

`a = 2; b = add6(a); c = div4(b); println(c) # 0.5  
println(div4(add6(a)))`

With piping you can write instead:

`a |> add6 |> div4 |> println`

Pipes in Base are very limited, in the sense that support only functions with one argument and only a single function at a time.

Conversely,  the `Pipe` package together with the `@pipe` macro hoverrides the \|&gt; operator allowing you to use functions with multiple arguments \(and there you can use the underscore character "`_`" as placeholder for the value on the LHS\) and multiple functions, e.g.:

`addX(a,x) = a+x; divY(a,y) = a/y  
@pipe a |> addX(_,6) + divY(4,_) |> println # 10.0`

Note that, as in the basic pipe, functions that require a single argument and this is provided by the piped data, don't need parenthesis.

_While an updated, expanded and revised version of this chapter is available in "Chapter 11 - Utilities" of [Antonello Lobianco (2019), "Julia Quick Syntax Reference", Apress](https://julia-book.com), this tutorial remains in active development._
