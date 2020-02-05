(s::Symbol)(args...) = WExpr(buildexpr(s), buildexpr.(args))

const WTypes = Union{WExpr, WSymbol, MathLink.WInteger, MathLink.WReal,
                     Symbol}
Base.:+(a::Union{WTypes, T}, b::Union{WTypes, T}) where T <: Number = plus(a, b)
function plus(a, b)::WExpr
    if isa(a, WExpr) && a.head == WSymbol("Plus")
        WExpr(WSymbol("Plus"), (a.args..., buildexpr(b)))
    else
        WExpr(WSymbol("Plus"), buildexpr.((a, b)))
    end
end
