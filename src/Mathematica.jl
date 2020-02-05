module Mathematica

# This package is based on MathLink
import MathLink
import MathLink: WExpr, WSymbol

export weval

weval(e) = MathLink.weval(buildexpr(e))

buildexpr(s::Symbol) = WSymbol(s)
buildexpr(e::Any) = e

include("operators.jl")

end # module
