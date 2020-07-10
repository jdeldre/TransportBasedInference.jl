import Base: size, show, @propagate_inbounds


# Define the concept of basis functions, where each function is indexed by an integer
# For instance, (1, x, ψ0, ψ1,..., ψn) defines a basis where the index:
# 0 corresponds to the constant function
# 1 corresponds to the linear function
# n+2 corresponds to the n-th order physicist Hermite function

export Basis, CstPhyHermite, CstProHermite,
       CstLinPhyHermite, CstLinProHermite,
       vander


struct Basis{m}
    f::Array{ParamFcn,1}
end


function CstPhyHermite(m::Int64; scaled::Bool = false)
    f = zeros(ParamFcn, m+2)
    # f[1] = 1.0
    f[1] = FamilyProPolyHermite[1]
    for i=0:m
        f[2+i] = PhyHermite(i; scaled = scaled)
    end
    return Basis{m+2}(f)
end

function CstProHermite(m::Int64; scaled::Bool = false)
    f = zeros(ParamFcn, m+2)
    # f[1] = 1.0
    f[1] = FamilyProPolyHermite[1]
    for i=0:m
        f[2+i] = ProHermite(i; scaled = scaled)
    end
    return Basis{m+2}(f)
end

function CstLinPhyHermite(m::Int64; scaled::Bool = false)
    f = zeros(ParamFcn, m+3)
    # f[1] = 1.0
    f[1] = FamilyProPolyHermite[1]
    # f[1] = x
    f[2] = FamilyProPolyHermite[2]
    for i=0:m
        f[3+i] = PhyHermite(i; scaled = scaled)
    end
    return Basis{m+3}(f)
end

function CstLinProHermite(m::Int64; scaled::Bool = false)
    f = zeros(ParamFcn, m+3)
    # f[1] = 1.0
    f[1] = FamilyProPolyHermite[1]
    # f[1] = x
    f[2] = FamilyProPolyHermite[2]
    for i=0:m
        f[3+i] = ProHermite(i; scaled = scaled)
    end
    return Basis{m+3}(f)
end

(F::Array{ParamFcn,1})(x::T) where {T <: Real} = map!(fi->fi(x), zeros(T, size(F,1)), F)
(B::Basis{m})(x::T) where {m, T<:Real} = B.f(x)

# (B::Basis{m})(x::T) where {m, T<:Real} = map!(fi->fi(x), zeros(T, m), B.f)



@propagate_inbounds Base.getindex(B::Basis{m},i::Int) where {m} = getindex(B.f,i)
@propagate_inbounds Base.setindex!(B::Basis{m}, v::ParamFcn, i::Int) where {m} = setindex!(B.f,v,i)

size(B::Basis{m},d::Int) where {m} = size(B.f,d)
size(B::Basis{m}) where {m} = size(B.f)

function Base.show(io::IO, B::Basis{m}) where {m}
    println(io,"Basis of "*string(m)*" functions:")
    for i=1:m
        println(io, B[i])
    end
end


function vander(B::Basis{m}, k::Int64, x::Array{Float64,1}) where {m}
    N = size(x,1)
    dV = zeros(N, m)

    # By definition, m is the number of basis functions

    @inbounds for i=1:m
        # col = view(dV, :, i)

        # Store the k-th derivative of the ith basis function
        if typeof(B[i]) <: Union{PhyPolyHermite, ProPolyHermite}
            Pik = derivative(B[i], k)
            dV[:,i] .= Pik.(x)
        elseif typeof(B[i]) <: Union{PhyHermite, ProHermite}
            dV[:,i] .= derivative(B[i], k , x)
        end
    end
    return dV
end

function vander(B::Basis{m}, max::Int64, k::Int64, x::Array{Float64,1}) where {m}
    N = size(x,1)
    dV = zeros(N, max+1)

    @assert 0 <= max <= m "The order is bigger than m"

    # By definition, m is the number of basis functions

    @inbounds for i=1:max+1
        # col = view(dV, :, i)

        # Store the k-th derivative of the ith basis function
        if typeof(B[i]) <: Union{PhyPolyHermite, ProPolyHermite}
            Pik = derivative(B[i], k)
            dV[:,i] .= Pik.(x)
        elseif typeof(B[i]) <: Union{PhyHermite, ProHermite}
            dV[:,i] .= derivative(B[i], k , x)
        end
    end
    return dV
end
