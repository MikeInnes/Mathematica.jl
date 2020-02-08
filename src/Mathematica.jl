module Mathematica

# This package is based on MathLink
import MathLink
import MathLink: WExpr, WSymbol

export weval

weval(e) = MathLink.weval(buildexpr(e))

include("types.jl")
include("operators.jl")

end # module
