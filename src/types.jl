buildexpr(s::Symbol) = WSymbol(s)

function buildexpr(s::AbstractArray)
    colons = Iterators.repeated(:, ndims(s) - 1)
    nested = [s[i, colons...] for i in 1:size(s)[1]]
    WSymbol("List")(buildexpr.(nested)...)
end

buildexpr(s::Rational) = WSymbol("Rational")(buildexpr(s.num), buildexpr(s.den))
buildexpr(s::Pair) = WSymbol("Rule")(buildexpr(s.first), buildexpr(s.second))
buildexpr(e::Any) = e


getexpr(e::Any) = e
getexpr(e::WExpr) = getexpr(Any, e)
function getexpr(::Type{Any}, e::WExpr)
    if e.head == WSymbol("Rational")
        getexpr(Rational, e)
    elseif e.head == WSymbol("List")
        getexpr(Array, e)
    else
        e
    end
end

getexpr(::Type{Rational}, e) = Rational(getexpr.(e.args)...)
function getexpr(::Type{Array}, e)
    s, ty = getsize(e)
    arr = Array{ty}(undef, prod(s))
    fillarray(arr, e, s, 0, 1)
    reshape(arr, s)
end

# Auxiliary functions for getexpr(Array, .)
getsize(a::Any) = ((), typeof(a))
function getsize(a::WExpr) where T
    dims = getsize.(a.args)
    function reducer(x, y)
        if x[1] == y[1]
            return (x[1], typejoin(x[2], y[2]))
        end
        ((zip(x[1], y[1])
         |> xs -> takewhile(p -> p[1] == p[2], xs)
         |> xs -> map(p -> p[1], xs)), Any)
    end
    subdim, ty = reduce(reducer, dims)
    ((length(a.args), subdim...), ty)
end
function fillarray(arr, e, size, acc, coef)
    for i in 1:size[1]
        if length(size) == 1
            arr[acc + coef * (i - 1) + 1] = getexpr(e.args[i])
        else
            fillarray(arr, e.args[i], size[2:end], acc + coef * (i - 1), coef * size[1])
        end
    end
end
