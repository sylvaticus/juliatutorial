# Developing Julia Packages

https://docs.julialang.org/en/release-0.5/manual/packages/#package-development

* Checkout the master branch of a package: `Pkg.checkout(pkg)`
* Checkout a specific branch: `Pkg.checkout(pkg,branch)`

Patching other people packages: 
* [patch & commit]
* using PkgDev
* PkgDev.submit("OdsIO")



checkout master
do work
tag
Pkg.update()
PkgDev.publish("OdsIO")

http://stackoverflow.com/questions/9646167/clean-up-a-fork-and-restart-it-from-the-upstream

cd v0.5/METADATA

git remote remove origin
git remote add origin git@github.com:sylvaticus/METADATA.jl
git remote add upstream https://github.com/JuliaLang/METADATA.jl
git fetch upstream
git checkout metadata-v2
git reset --hard upstream/metadata-v2
git push original metadata-v2 --force

