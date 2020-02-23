using Test
using Mathematica: weval, buildexpr, getexpr
using MathLink: @W_str

@testset "buildexpr" begin
    @test buildexpr(1) == 1
    @test buildexpr("s") == "s"
    @test buildexpr(:x) == W"x"
    @test buildexpr([1,2,3]) == W"List"(1,2,3)
    @test buildexpr([1 2; 3 4]) == W"List"(W"List"(1, 2), W"List"(3, 4))
    @test buildexpr(1//2) == W"Rational"(1, 2)
    @test buildexpr(:x=>1) == W"Rule"(W"x", 1)
    @test buildexpr(:f(:x, (1, 2))) == buildexpr(:f(:x, [1, 2])) == W"f"(W"x", W"List"(1, 2))
end

@testset "getexpr" begin
    @test getexpr(W"List"(1, 2, 3)) == [1, 2, 3]
    @test getexpr(W"List"(W"List"(1, 2), W"List"(3, 4))) == [1 2; 3 4]
    @test getexpr(W"List"(W"List"(1, 2, 3), W"List"(4, 5, 6))) == [1 2 3; 4 5 6]
    arr = reshape(1:12, 2, 3, 2)
    @test getexpr(buildexpr(arr)) == arr
    @test getexpr(W"Rule"(1, W"x")) == (1=>:x)
end

@testset "operators" begin
    @testset "call" begin
        @test :x(1, :x) == W"x"(1, W"x")
    end
    @testset "plus" begin
        @test :x + 1 == W"Plus"(W"x", 1)
        @test :x + 2 + 3.2 == W"Plus"(W"x", 2, 3.2)
        @test 1 + :Sin(:x) + 3.2 == W"Plus"(1, W"Sin"(W"x"), 3.2)
    end
    @testset "minus" begin
        @test -:x == W"Times"(-1, W"x")
        @test 1 - :x == W"Plus"(1, W"Times"(-1, W"x"))
        @test :x - 1 == W"Plus"(W"x", -1)
        @test :x - :y - 1 == W"Plus"(W"x", W"Times"(-1, W"y"), -1)
        @test 1 - (:x + 2) == W"Plus"(1, W"Times"(-1, W"Plus"(W"x", 2)))
    end
    @testset "times" begin
        @test 2 * :x * :y == W"Times"(2, W"x", W"y")
    end
    @testset "divide" begin
        @test 1 / :x == W"Times"(1, W"Power"(W"x", -1))
        @test :x / 3 == W"Times"(W"x", W"Power"(3, -1))
    end
    @testset "power" begin
        @test :a ^ :b ^ :c == W"Power"(W"a", W"Power"(W"b", W"c"))
    end
end

@testset "functions" begin
    @test (1 |> :Simplify) == W"Simplify"(1)
end
