# 11 - Developing Julia packages

[https://docs.julialang.org/en/latest/stdlib/Pkg](https://docs.julialang.org/en/latest/stdlib/Pkg)

You can enter "Pkg mode" typing `]` on a terminal,  and then running the desired command.  
Alternatively in a script you can run `pkg"cmd to run"` \(notice that there is no space between pkg and the command\). 

* Checkout the latest release of a registered package: `add pkgName`
* Checkout the master branch of a package: `add pkgName#master`
* Checkout a specific branch: `add pkgName#branchName` \(and `free pkgName` to return to the released version\)
* Checkout a non registered pkg: `add git@github.com:userName/pkgName.jl.git`

Patching other people packages:

* \[patch & commit\]
* using PkgDev
* PkgDev.submit\(pkg\)

Develp your own project and publish a new version

* `Pkg.add(pkg)`
* `Pkg.checkout(pkg)` to checkout master
* \[...work on the project..\]
* `PkgDev.tag(pkg, v"0.X.X")`
* `PkgDev.publish(pkg)`

or \(much better\) use the package [attobot](https://github.com/attobot/attobot) that automatise the workflow \(after you installed attobot on your GitHub repository, just create a new GitHub release in order to spread it to the Julia package ecosystem\).

In case of problems: [http://stackoverflow.com/questions/9646167/clean-up-a-fork-and-restart-it-from-the-upstream](http://stackoverflow.com/questions/9646167/clean-up-a-fork-and-restart-it-from-the-upstream)

* Testing a package: `Pkg.test("pkg")`

