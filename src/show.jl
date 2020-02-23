function Base.show(io::IO, mime::Union{MIME"image/svg+xml", MIME"text/latex"}, x::WExpr)
    if mime == MIME"text/latex"() && x.head != WSymbol("Graphics")
        type = "TeXFragment"
    elseif mime == MIME"image/svg+xml"() && x.head == WSymbol("Graphics")
        type = "SVG"
    else
        throw(MethodError(Base.show, (io, mime, x)))
    end
    out = weval(:ExportString(:HoldForm(x), type))
    write(io, out)
end
