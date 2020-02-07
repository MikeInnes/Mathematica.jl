using Test
using Mathematica: weval, buildexpr
using MathLink: @W_str

@testset "buildexpr" begin
    @test buildexpr(1) == 1
    @test buildexpr("s") == "s"
    @test buildexpr(:x) == W"x"
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
