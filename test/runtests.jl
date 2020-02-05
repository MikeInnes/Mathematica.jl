using Test
using Mathematica: weval, buildexpr
using MathLink: @W_str

@testset "weval" begin
    @testset "identity" begin
        @test weval(1) == 1
        # @test weval(:x) == :x
    end
end

@testset "buildexpr" begin
    @test buildexpr(1) == 1
    @test buildexpr("s") == "s"
    @test buildexpr(:x) == W"x"
    @test :x(1, :x) == W"x"(1, W"x")
    @test :x + 1 == W"Plus"(W"x", 1)
    @test :x + 2 + 3.2 == W"Plus"(W"x", 2, 3.2)
    @test 1 + :Sin(:x) + 3.2 == W"Plus"(1, W"Sin"(W"x"), 3.2)
end
