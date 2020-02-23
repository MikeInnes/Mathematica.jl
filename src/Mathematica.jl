module Mathematica

# This package is based on MathLink
import MathLink
import MathLink: WExpr, WSymbol
import IterTools: takewhile

export weval

weval(e) = MathLink.weval(buildexpr(e)) |> getexpr

include("types.jl")
include("operators.jl")
include("show.jl")

end # module
