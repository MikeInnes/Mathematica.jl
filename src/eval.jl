"""
    weval(e)

Evaluate a Wolfram expression in Mathematica.
"""
weval(e) = MathLink.weval(buildexpr(e)) |> getexpr

"""
    @importsymbol Get, N, Plot

Import Mathematica symbols as normal Julia functions.

Note: This will eagerly evaluate the function.
Some expressions involving evaluation control (like `Hold`) may not work as expected.
"""
macro importsymbol(arg)
    if arg isa Symbol
        list = [arg]
    elseif arg.head == :tuple
        list = arg.args
    else
        error("Not recgonized arg")
    end
    decls = []
    for sym in list
        e = :($(esc(sym))(args...) = weval($(Expr(:quote, sym))(args...)))
        push!(decls, e)
    end
    Expr(:block, decls...)
end
