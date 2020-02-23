function Base.show(io::IO, mime::Union{MIME"image/svg+xml", MIME"text/latex"}, x::WExpr)
    if mime == MIME"text/latex"()
        if x.head == WSymbol("Graphics")
            error()
        end
        type = "TeXFragment"
    elseif mime == MIME"image/svg+xml"()
        type = "SVG"
    end
    out = weval(:ExportString(:HoldForm(x), type))
    write(io, out)
end
