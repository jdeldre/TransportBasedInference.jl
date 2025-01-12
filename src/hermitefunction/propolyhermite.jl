
export  ProPolyHermite, Cpro, degree, ProPolyH, prohermite_coeffmatrix,
        FamilyProPolyHermite, FamilyScaledProPolyHermite,
        derivative,
        evaluate!, evaluate,
        vander!, vander

"""
ProPolyHermite <: Hermite

An immutable structure for probabilistic Hermite polynomials

## Fields
-  `m` : order of the polynomial
-  `P` : probabilistic Hermite polynomial of order m
- `scaled` : with rescaling to have unitary norm
"""
struct ProPolyHermite <: Hermite
    m::Int64
    P::ImmutablePolynomial{Float64}
    scaled::Bool
end

function Base.show(io::IO, P::ProPolyHermite)
    println(io, string(P.m)*"-th order probabilistic Hermite polynomial "*string(P.P)*", scaled = "*string(P.scaled))
end

# Hen(x)  = (-1)ⁿ*exp(x²/2)dⁿ/dxⁿ exp(-x²/2)
# Hen′(x) = n*Hen-1(x)
# Hen″(x) = n*(n-1)*Hen-1(x)

"""
$(TYPEDSIGNATURES)

Normalization constant of the m-th order probabilistic Hermite polynomial
"""
# Cpro(m::Int64) =sqrt(sqrt(2*π) * gamma(m+1))
Cpro(m::Int64) =sqrt(gamma(m+1)) #sqrt(2π) is already accounted for by sampling


"""
$(TYPEDSIGNATURES)

Normalization constant of the m-th order probabilistic Hermite polynomial
"""
Cpro(P::ProPolyHermite) = Cpro(P.m)


"""
$(TYPEDSIGNATURES)

Return the degree of the probabilistic Hermite polynomial `P`.
"""
degree(P::ProPolyHermite) = P.m

# Adapted https://people.sc.fsu.edu/~jburkardt/m_src/hermite_polynomial/h_polynomial_coefficients.m

#    Input, integer N, the highest order polynomial to compute.
#    Note that polynomials 0 through N will be computed.
#
#    Output, real C(1:N+1,1:N+1), the coefficients of the Hermite
#    polynomials.

# Recurrence relation:
# Hen+1 = x*Hen - n*Hen-1

"""
$(TYPEDSIGNATURES)

Computes the coefficients of the probabilistic Hermite polynomials up to order m.
"""
function prohermite_coeffmatrix(m::Int64)

    if m < 0
        return Float64[]
    end

    coeff = zeros(m+1, m+1)
    coeff[1, 1] = 1.0

    if m == 0
        return coeff
    end

    coeff[2, 2] = 1.0

    if m==1
        return coeff
    end

    for i  = 2:m
        coeff[i+1, 1]      =  -      (i - 1) * coeff[i-1, 1]
        coeff[i+1, 2:i-1]  =                   coeff[i  , 1:i-2] -
                                     (i - 1) * coeff[i-1, 2:i-1]
        coeff[i+1, i]      =                   coeff[i  , i-1]
        coeff[i+1, i+1]    =                   coeff[i  , i]
    end
    return coeff
end


const ProPolyH = prohermite_coeffmatrix(CstMaxDegree)

function ProPolyHermite(m::Int64;scaled::Bool= false)
    @assert m>=0 "The order of the polynomial should be >=0"
    if scaled ==false
        return ProPolyHermite(m, ImmutablePolynomial(view(ProPolyH,m+1,1:m+1)), scaled)
    else
        C = 1/Cpro(m)
        return ProPolyHermite(m, ImmutablePolynomial(C*view(ProPolyH,m+1,1:m+1)), scaled)
    end
end

"""
$(TYPEDSIGNATURES)

Evaluates the probabilistic Hermite polynomial `P`.
"""
(P::ProPolyHermite)(x) = P.P(x)

const FamilyProPolyHermite = ntuple(i->ProPolyHermite(i-1), CstMaxDegree+1)
const FamilyScaledProPolyHermite = ntuple(i->ProPolyHermite(i-1; scaled = true), CstMaxDegree+1)


"""
$(TYPEDSIGNATURES)

Computes the k-th derivative of the probabilistic Hermite polynomial `P`.
"""
function derivative(P::ProPolyHermite, k::Int64)
    m = P.m
    @assert k>=0 "This function doesn't compute anti-derivatives of Hermite polynomials"
    if m>=k
        factor = exp(loggamma(m+1) - loggamma(m+1-k))
        if P.scaled == false
            return ImmutablePolynomial(factor*ProPolyH[m-k+1,1:m-k+1])
        else
            C = 1/Cpro(m)
            return ImmutablePolynomial(factor*C*ProPolyH[m-k+1,1:m-k+1])
        end
    else
        return ImmutablePolynomial((0.0))
    end
end


"""
$(TYPEDSIGNATURES)

Evaluates in-place the probabilistic Hermite polynomial `P`.
"""
function evaluate!(dV, P::ProPolyHermite, x)
    m = P.m
    N = size(x,1)
    @assert size(dV) == (N, m+1) "Wrong dimension of the Vander matrix"

    # H_0(x) = 1, H_1(x) = x
    col = view(dV,:,1)
    @avx @. col = 1.0

    if P.scaled
        rmul!(col, 1/Cpro(0))
    end
    if m == 0
        return dV
    end

    col = view(dV,:,2)
    @avx @. col = x

    if P.scaled
        rmul!(col, 1/Cpro(1))
    end

    if m == 1
        return dV
    end

    if P.scaled
        @inbounds for i=2:m
            colp1 = view(dV,:,i+1)
            col   = view(dV,:,i)
            colm1 = view(dV,:,i-1)
            @avx @. colp1 = Cpro(i-1)* x * col - Cpro(i-2)*(i-1)*colm1
            # dV[:,i+1] = 2.0*Cphy(i-1)*x .* dV[:,i] - 2.0*Cphy(i-2)*i*dV[:,i-1]
            rmul!(colp1, 1/Cpro(i))
        end
    else
        @inbounds for i=2:m
            colp1 = view(dV,:,i+1)
            col   = view(dV,:,i)
            colm1 = view(dV,:,i-1)
            @avx @. colp1 = x * col - (i-1)*colm1
        end
    end
    return dV
end


"""
$(TYPEDSIGNATURES)

Evaluates the probabilistic Hermite polynomial `P`.
"""
evaluate(P::ProPolyHermite, x::Array{Float64,1}) = evaluate!(zeros(size(x,1), P.m+1), P, x)



# He_{n}^(k)(x) =  n!/(n-k)! H_{n-k}(x)

"""
$(TYPEDSIGNATURES)

Computes in-place the Vandermonde matrix of the k-th derivative of the probabilistic Hermite polynomial `P`.
"""
function vander!(dV, P::ProPolyHermite, k::Int64, x)
    m = P.m

    if k==0
        evaluate!(dV, P, x)
    # Derivative
    elseif k==1
        # Use recurrence relation H′_{n+1} = (1 + 1/n)*(x*H′_{n} - n*H′_{n-1})
        N = size(x,1)
        @assert size(dV) == (N, m+1) "Wrong dimension of the Vander matrix"

        col = view(dV,:,1)
        @avx @. col = 0.0
        if m==0
            return dV
        end

        col = view(dV,:,2)
        @avx @. col = 1.0

        if m==1
            return dV
        end

        col = view(dV,:,3)
        @avx @. col = 2.0*x

        if m==2
            return dV
        end

        @inbounds for i=3:m
            colp1 = view(dV,:,i+1)
            col   = view(dV,:,i)
            colm1 = view(dV,:,i-1)

            @avx @. colp1 = (1.0 + 1.0/(i-1.0))*(x * col - (i-1.0) * colm1)
        end

        if P.scaled
            @inbounds for i=1:m
                colp1 = view(dV,:,i+1)
                factor = exp(loggamma(i+1) - loggamma(i+1-k))
                rmul!(colp1, 1/(Cpro(i)*sqrt(factor)))
            end

        end
        return dV
    # Second Derivative
    elseif k==2
        # Use recurrence relation He″_{n+1} = (n+1)/(n-1)*(x*He″_{n} - 2*n*He″_{n-1})
        N = size(x,1)
        @assert size(dV) == (N, m+1) "Wrong dimension of the Vander matrix"

        col = view(dV,:,1)
        @avx @. col = 0.0
        if m==0
            return dV
        end

        col = view(dV,:,2)
        @avx @. col = 0.0

        if m==1
            return dV
        end

        col = view(dV,:,3)
        @avx @. col = 2.0

        if m==2
            return dV
        end

        col = view(dV,:,4)
        @avx @. col = 6.0 * x

        if m==3
            return dV
        end

        @inbounds for i=4:m
            colp1 = view(dV,:,i+1)
            col   = view(dV,:,i)
            colm1 = view(dV,:,i-1)

            @avx @. colp1 = ((i)/(i-2.0))*(x * col - (i-1.0) * colm1)
        end

        if P.scaled
            @inbounds for i=1:m
                colp1 = view(dV,:,i+1)
                factor = exp(loggamma(i+1.0) - loggamma(i+1.0-k))
                @avx rmul!(colp1, 1/(Cpro(i)*sqrt(factor)))
            end

        end
        return dV
    end
end

"""
$(TYPEDSIGNATURES)

Computes the Vandermonde matrix of the k-th derivative of the probabilistic Hermite polynomial `P`.
"""
vander(P::ProPolyHermite, k::Int64, x::Array{Float64,1}) = vander!(zeros(size(x,1), P.m+1), P, k, x)
