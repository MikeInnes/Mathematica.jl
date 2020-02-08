buildexpr(s::Symbol) = WSymbol(s)

function buildexpr(s::AbstractArray)
    colons = Iterators.repeated(:, ndims(s) - 1)
    nested = [s[i, colons...] for i in 1:size(s)[1]]
    WSymbol("List")(buildexpr.(nested)...)
end

buildexpr(s::Rational) = WSymbol("Rational")(s.num, s.den)

buildexpr(e::Any) = e
