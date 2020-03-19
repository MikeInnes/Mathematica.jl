module Mathematica

# This package is based on MathLink
import MathLink
import MathLink: WExpr, WSymbol
import IterTools: takewhile

export weval, @importsymbol

include("types.jl")
include("operators.jl")
include("show.jl")
include("eval.jl")

end # module
