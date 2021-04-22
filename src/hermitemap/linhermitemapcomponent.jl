export  LinHermiteMapComponent,
        getcoeff,
        setcoeff!,
        getidx,
        evaluate!,
        evaluate

# LinHermiteMapComponent is a composition of a linear transformation that rescale
# the samples to get zero mean and unitary standard deviation component-wise
# and a nonlinear transport map described by a HermiteMapComponent element


struct LinHermiteMapComponent
    # Linear transformation
    L::LinearTransform

    # IntegratedFunction
    C::HermiteMapComponent

    function LinHermiteMapComponent(L::LinearTransform, C::HermiteMapComponent)
        return new(L, C)
    end
end

function LinHermiteMapComponent(X::Array{Float64,2}, C::HermiteMapComponent; diag::Bool=true)
    @assert size(X,1)==C.Nx "Wrong dimension of the input"
    L = LinearTransform(X; diag = diag)
    return LinHermiteMapComponent(L, C)
end


ncoeff(L::LinHermiteMapComponent) = L.C.Nψ
getcoeff(L::LinHermiteMapComponent) = L.C.I.f.coeff

function setcoeff!(L::LinHermiteMapComponent, coeff::Array{Float64,1})
        @assert size(coeff,1) == Nψ "Wrong dimension of coeff"
        L.C.I.f.coeff .= coeff
end

getidx(L::LinHermiteMapComponent) = L.C.I.f.idx


function evaluate!(out, L::LinHermiteMapComponent, X)
    @assert L.C.Nx==size(X,1) "Wrong dimension of the sample"
    @assert size(out,1) == size(X,2) "Dimensions of the output and the samples don't match"

    transform!(L.L, X)
    evaluate!(out, L.C.I, X)
    itransform!(L.L, X)
    return out
end

evaluate(L::LinHermiteMapComponent, X::Array{Float64,2}) = evaluate!(zeros(size(X,2)), L, X)
