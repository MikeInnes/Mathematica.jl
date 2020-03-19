(s::Symbol)(args...) = WExpr(buildexpr(s), buildexpr.(args))

function buildwith(head, a, b)
    if isa(a, WExpr) && a.head == WSymbol(head)
        WExpr(WSymbol(head), (a.args..., buildexpr(b)))
    else
        WExpr(WSymbol(head), buildexpr.((a, b)))
    end
end

const WTypes = Union{WExpr, WSymbol, MathLink.WInteger, MathLink.WReal, Symbol}

#
# Arithematic operators
#

Base.:+(a::Union{WTypes, T}, b::Union{WTypes, T}) where T <: Number =
    buildwith("Plus", a, b)

Base.:-(a::WTypes) =
    WSymbol("Times")(-1, buildexpr(a))

Base.:-(a::Union{WTypes, T}, b::Union{WTypes, T}) where T <: Number =
    a + (-b)

Base.:*(a::Union{WTypes, T}, b::Union{WTypes, T}) where T <: Number =
    buildwith("Times", a, b)

Base.:/(a::Union{WTypes, T}, b::Union{WTypes, T}) where T <: Number =
    a * WSymbol("Power")(buildexpr(b), -1)

Base.:^(a::Union{WTypes, T}, b::Union{WTypes, T}) where T <: Number =
    WSymbol("Power")(buildexpr(a), buildexpr(b))

#
# Functions
#

Base.:|>(x, f::Symbol) = buildexpr(f)(buildexpr(x))
Base.inv(x::WTypes) = WSymbol("Inverse")(buildexpr(x))
