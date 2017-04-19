# Developing Julia Packages

https://docs.julialang.org/en/release-0.5/manual/packages/#package-development

* Checkout the master branch of a package: `Pkg.checkout(pkg)`
* Checkout a specific branch: `Pkg.checkout(pkg,branch)`

Patching other people packages: 
* [patch & commit]
* using PkgDev
* PkgDev.submit("OdsIO")

Develp your own project and publish a new version
* `Pkg.add(pkg)`
* `Pkg.checkout(pkg)` to checkout master
* [...work on the project..]
* `PkgDev.tag(pkg, v"0.X.X")`
* `PkgDev.publish(pkg)`

In case of problems: http://stackoverflow.com/questions/9646167/clean-up-a-fork-and-restart-it-from-the-upstream


