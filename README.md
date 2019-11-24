# Introduction

![](.gitbook/assets/julia_hello_world%20%281%29.png)

**Update November 2019: This tutorial (largely updated, expanded and revised) has evolved into a book thanks to Apress :-)**

➞ _Antonello Lobianco (2019), "Julia Quick Syntax Refererence", Apress_

➞ https://julia-book.com/ (includes community forum and link to code repository)

This tutorial itself is still updated and may include new stuff that will be the base of further editions of the book.

**Compatibilities table of this tutorial with Julia versions:**

* **Julia 1.2/1.3** From 24 November 2019. More than Julia itself (quite stable now), this version accounts for mayor API changes of the various packages, DataFrames, JuMP, PyCall..
* **Julia 1.0:** From 5 September 2018
* **Julia 0.6:** 19 July 2017 - 15 August 2018 versions
* **Julia 0.5:** Versions before 19 July 2017

The purposes of this tutorial are \(a\) to store things I learn myself about Julia and \(b\) to help those who want to start coding in Julia before reading the 982 pages of the \(outstanding\) [official documentation](https://docs.julialang.org/en/stable/).

This document started as a compendium of several tutorials \(plus the official documentation\), in particular Chris Rackauckas's [A Deep Introduction to Julia](http://ucidatascienceinitiative.github.io/IntroToJulia/), the [Quantecon tutorial](https://lectures.quantecon.org/jl/), the [WikiBook on Julia](https://en.wikibooks.org/wiki/Introducing_Julia) and [Learn X in Y minutes](https://learnxinyminutes.com/docs/julia/), from which I did borrow several examples.

The focus is on Julia as a generic programming language rather than on domain-specific issues \(but some domain-specific topics are covered in the "Useful packages" section\). The format is in the middle between a classical tutorial and a cheatsheet: the tutorial describes the elements of the language following the typical sections of a programming language tutorial \(_data types, control flows, functions.._\), but the information is given in a pretty concise way, suitable for people that already have some knowledge in other programming languages \(e.g. what a `for` loop does is not explained, but how it is implemented in Julia is\).

English is not my primary language, so please be understanding and report me of any errors, both in the language and in the content.

Happy coding with Julia !

Antonello Lobianco

## Latest version

* The latest version of this tutorial can be found online on GitBook, at [https://syl1.gitbook.io/julia-language-a-concise-tutorial](https://syl1.gitbook.io/julia-language-a-concise-tutorial)
* [PDF version](https://legacy.gitbook.com/download/pdf/book/sylvaticus/julia-language-a-concise-tutorial) \(if it works\)
* [A legacy interface](https://legacy.gitbook.com/book/sylvaticus/julia-language-a-concise-tutorial) \(if it works\)
* Corresponding [GIT repository](https://github.com/sylvaticus/juliatutorial)

I am considering migrating to other documentation systems, as the new GitBook is pretty limited. If so, I will nevertheless update the link here.

## Citations

Please cite this tutorial as:

`A. Lobianco, (2018), “Julia language: a concise tutorial", GitBook,` [`https://syl1.gitbook.io/julia-language-a-concise-tutorial`](https://syl1.gitbook.io/julia-language-a-concise-tutorial)`, retrieved xx/xx/xxxx`

## Acknowledgements

Development of this tutorial was supported by:

* the French National Research Agency through the [Laboratory of Excellence ARBRE](http://mycor.nancy.inra.fr/ARBRE/), a part of the “Investissements d'Avenir” Program \(ANR 11 – LABX-0002-01\).
