using Test, Reexport
cd(@__DIR__)

module foo

export plusOne

struct Point
    x::Int64
    y::Int64
end

plusOne(x) = x+1
plusOne(x::Point) = (x.x+1, x.y+1)

end # end foo

@test  foo.plusOne(2) == 3

p = foo.Point(1,2)
out = foo.plusOne(foo.Point(1,2))
@test  out == (2,3)

using .foo

@test  plusOne(2) == 3

p = foo.Point(1,2)
out = plusOne(foo.Point(1,2))
@test  out == (2,3)

module Foo
export plusOne, Foo3, Foo4
plusOne(x) = x + 1
plusTen(x) = x + 10
module Foo3
    export plusThree
    plusThree(x) = x+3
end
module Foo4
    using Reexport
    export plusFour
    @reexport using ..Foo3 # note the two dots in front to go one level up, as these two modules are siblings
    plusFour(x) = x+4
end
end # end Foo

@test Foo.plusOne(2) == 3
@test Foo.plusTen(2) == 12
@test Foo.Foo4.plusThree(2) ==5
#plusOne(2) # Error, the objects of Foo are not into scope
using .Foo # We bring the exported objects into scope
@test plusOne(2) == 3
#plusTen(2)
import .Foo: plusTen
@test plusTen(2) == 12
#plusThree(2)
@test Foo4.plusThree(2) == 5

using .Foo.Foo4
@test plusThree(5) == 8
@test plusFour(5) == 9

include("11_-_Modules_and_packages-bis.jl")
@test  fee.plusFive(2) == 7
@test  Main.fee.plusFive(2) == 7

a = 5
@test a == 5
@test Main.a == 5

using MyAwesomePackage

@test MyAwesomePackage.plusTwo(2) == 4
@test Main.MyAwesomePackage.plusTwo(2) == 4

# When a package is loaded into memory I can access it without any import

module fii
export plusSix
plusSix(x)   = x+6
plusSeven(x) = x+7
println("I'm executed in fii")
end
fii.plusSix(1)
fii.plusSeven(1)
import .fii
