# Mathematica.jl

[![Gitter chat](https://badges.gitter.im/one-more-minute/Mathematica.jl.png)](https://gitter.im/one-more-minute/Mathematica.jl)

The `Mathematica.jl` package provides an interface for using [Wolfram Mathematica™](http://www.wolfram.com/mathematica/) from the [Julia language](http://julialang.org). You cannot use `Mathematica.jl` without having purchased and installed a copy of Mathematica™ from [Wolfram Research](http://www.wolfram.com/). This package is available free of charge and in no way replaces or alters any functionality of Wolfram's Mathematica product.

The package provides is a no-hassle Julia interface to Mathematica. It aims to follow Julia's philosophy of combining high-level expressiveness without sacrificing low-level optimisation.

```julia
Pkg.add("Mathematica")
````
Provided Mathematica is installed, its usage is as simple as:

```julia
using Mathematica
weval(:Fibonacci(1000))
# => 43466557686937456435688527675040625802564660517371780402481729089536555417949051890403879840079255169295922593080322634775209689623239873322471161642996440906533187938298969649928516003704476137795166849228875
```
All Julia symbols are treated as Mathematica symbols.

```julia
weval(:Integrate(:x^2, :x))
# => W"Times"(W"Rational"(1, 3), W"Power"(W"x", 3))

weval(:Integrate(:Log(:x), [:x,0,2]))
# => W"Plus"(-2, W"Log"(4))

weval(:N(ans))
# => -0.6137056388801094
```

Including those that return Mathematica data:
```julia
weval(:Plot(x^2, [x,0,2]))
#=> Graphics[{{{},{},{Hue[0.67, 0.6, 0.6],Line[{{4.081632653061224e-8,1.6659725114535607e-15},...}]}}}, {:AspectRatio->Power[:GoldenRatio, -1],:Axes->true, ...}]
```

Julia compatible data (e.g. lists, complex numbers etc.) will all be converted automatically, and you can extend the conversion to other types.

Finally, of course:
```julia
weval(:WolframAlpha("hi")) #=>
2×2 Array{Any,2}:
 Any[Any["Input", 1], "Plaintext"]   "Hello."
 Any[Any["Result", 1], "Plaintext"]  "Hello, human."

```

## Extending to custom datatypes

The Mathematica data expression `Head[x,y,z,...]` is represented in Julia as `MExpr{:Head}(args = {x,y,z,...})`. We can extend `Mathematica.jl` to support custom types by overloading `MathLink.to_mma` and `MathLink.from_mma`.

For example, we can pass a Julia Dict straight through Mathematica with just two lines of definitions:
```julia
using MathLink; import MathLink: to_mma, from_mma
d = [:a => 1, :b => 2]

to_mma(d::Dict) = MExpr{:Dict}(map(x->MExpr(:Rule, x[1], x[2]),d))
Identity(d) #=> Dict[:b->2, :a->1]
from_mma(d::MExpr{:Dict}) = Dict(map(x->x.args[1], d.args), map(x->x.args[2], d.args))
Identity(d) #=> {:b=>2,:a=>1}
```

## Usage Issues

```julia
using Mathematica
```
This should work so long as either `math` is on the path (normally true on linux). `Mathematica.jl` will also look for `math.exe` on Windows, which should work for Mathematica versions 8 or 9 installed in default locations. If it doesn't work for you, open an issue (in particular I don't know how this will behave on Macs).

## Current Limitations / Planned Features
