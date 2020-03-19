# Mathematica.jl

## Warning: Mathematica.jl is no longer actively maintained. Head over to [MathLink.jl](https://github.com/JuliaInterop/MathLink.jl) for similar functionality. 

[![Gitter chat](https://badges.gitter.im/one-more-minute/Mathematica.jl.png)](https://gitter.im/one-more-minute/Mathematica.jl)

The `Mathematica.jl` package provides an interface for using [Wolfram Mathematica™](http://www.wolfram.com/mathematica/) from the [Julia language](http://julialang.org). You cannot use `Mathematica.jl` without having purchased and installed a copy of Mathematica™ from [Wolfram Research](http://www.wolfram.com/). Alternatively, you can install [Free Wolfram Engine for Developers](https://www.wolfram.com/engine). This package is available free of charge and in no way replaces or alters any functionality of Wolfram's Mathematica product.

The package provides is a no-hassle Julia interface to Mathematica.

```julia
Pkg.add("Mathematica")
````
Provided Mathematica is installed, You can easily build a Mathematica expression in Julia and use `weval` to evaluate it in Mathematica, and get the converted Julia result.

```julia
julia> using Mathematica
julia> weval(:Fibonacci(1000))
43466557686937456435688527675040625802564660517371780402481729089536555417949051890403879840079255169295922593080322634775209689623239873322471161642996440906533187938298969649928516003704476137795166849228875
```
All Julia symbols are automatically converted to Mathematica symbols.

```julia
julia> weval(:Integrate(:x^2, :x))
W"Times"(W"Rational"(1, 3), W"Power"(W"x", 3))

julia> weval(:Integrate(:Log(:x), [:x,0,2]))
W"Plus"(-2, W"Log"(4))

julia> weval(:N(ans))
-0.6137056388801094
```

Some functions like `N` are often followed by `weval`. As a convenient method, `@importsymbol` can be used to reduce use of `weval`.

```julia
julia> @importsymbol N, Integrate

julia> Integrate(:Log(:x), [:x, 0, 2])
W"Plus"(-2, W"Log"(4))

julia> N(ans)
-0.6137056388801094
```

Returned Mathematica data can be displayed as SVG or LaTeX, in supported frontend like Juno and IJulia:

![screenshot](./img/display.png)

Julia compatible data (e.g. lists, complex numbers etc.) will all be converted automatically, and you can extend the conversion to other types.

Finally, of course:
```julia
julia> weval(:WolframAlpha("hi")) # =>
2×2 Array{Any,2}:
 Any[Any["Input", 1], "Plaintext"]   "Hello."
 Any[Any["Result", 1], "Plaintext"]  "Hello, human."

```

## Extending to custom datatypes

The Mathematica data expression `Head[x,y,z,...]` is represented in Julia as `WExpr(WSymbol(:Head), [x,y,z,...])`. To convert Julia types to `WExpr`, `Mathematica.buildexpr` should be implemented:

```julia
import Mathematica: buildexpr, WSymbol

struct Less
  lhs
  rhs
end

buildexpr(s::Less) = WSymbol("Less")(buildexpr(s.lhs), buildexpr(s.rhs))
```
To convert Mathematica expressions back, `Mathematica.getexpr` should be implemented.

```julia
import Mathematica
import Mathematica: getexpr

Mathematica.headstype["Less"] = Less
getexpr(::Type{Less}, e) = Less(getexpr(e.args[1]), getexpr(e.args[2]))
```

And then the custom type should work seamlessly with `weval` function.

## Current Limitations

- `Mathematica.jl` currently cannot handle internal errors. If an error happens, the only way to recover is to restart the Julia session.

## Planned Features

- [ ] Conversion between `Expr` and `WExpr`
