export quantile_ricardo, center_std_diag, center_std_off, center_std

# Set ξ and σ for the diagonal entry, i.e. the last element of Vk
function center_std_diag(Vk::Uk, X::AbstractMatrix{Float64}, γ::Float64)
    @get Vk (k, p)
    @assert (p>0 && γ >0.0) || (p==0 && γ>=0.0) "Error scaling factor γ"

    # As long as he have p>1, we have in fact p+2 centers
    if p>0
    ξ′ = view(Vk.ξ[end],:)
    σ′ = view(Vk.σ[end],:)
    tmp = view(X,k,:)
    quant!(ξ′, tmp, collect(1:p+2)./(p+3), sorted=true, alpha=0.5, beta = 0.5)

    σ′[1] = ξ′[2]-ξ′[1]
    σ′[end] = ξ′[end]-ξ′[end-1]
    for j=2:p+1
    @inbounds σ′[j] = 0.5*(ξ′[j+1]-ξ′[j-1])
    end
    rmul!(σ′, γ)

    end
end

# Set ξ and σ for the off-diagonal entries, i.e. i=1:k-1 entries of Vk
function center_std_off(Vk::Uk, X::AbstractMatrix{Float64}, γ::Float64)
    @get Vk (k, p)
    @assert (p>0 && γ >0.0) || (p==0 && γ>=0.0) "Error scaling factor γ"

    if p==0

    elseif p==1 # only one rbf
        qq = zeros(3)
        p_range = [0.25;0.5;0.75]
        for i=1:k-1
            @inbounds begin
            ξ = view(Vk.ξ[i],:)
            σ = view(Vk.σ[i],:)
            tmp = view(X, i, :)
            quant!(qq, tmp, p_range, sorted=true, alpha=0.5, beta = 0.5)
            ξ .= qq[2]
            σ .= (qq[3]-qq[1])*0.5
            rmul!(σ, γ)
            end
        end
    elseif p==2
        p_range = collect(1.0:p)./(p+1.0)
        for i=1:k-1
            @inbounds begin
            ξ = view(Vk.ξ[i],:)
            σ = view(Vk.σ[i],:)
            tmp = view(X,i,:)
            quant!(ξ, tmp, p_range, sorted=true, alpha=0.5, beta = 0.5)
            σ[1:2] .= (ξ[2]-ξ[1])*ones(2)
            rmul!(σ, γ)
            end
        end

    else
        p_range = collect(1.0:p)./(p+1.0)
        for i=1:k-1
            @inbounds begin
            ξ = view(Vk.ξ[i],:)
            σ = view(Vk.σ[i],:)
            tmp = view(X,i,:)
            quant!(ξ, tmp, p_range, sorted=true, alpha=0.5, beta = 0.5)

            σ[1] = (ξ[2]-ξ[1])
            σ[end] = (ξ[end]-ξ[end-1])
            for j=2:p-1
            @inbounds σ[j] = 0.5*(ξ[j+1]-ξ[j-1])
            end
            rmul!(σ, γ)
            end
        end
    end
end

# Assume an unsorted array
function center_std(T::KRmap, X::AbstractMatrix{Float64};start::Int64=1)
    @get T (k, p, γ)
    if p>0
    Sens = deepcopy(X)
    sort!(Sens,2)
    if k==1
        center_std_diag(T.U[1], Sens, γ)
    else
        for i=start:k
            @inbounds begin
            center_std_diag(T.U[i], Sens, γ)
            center_std_off(T.U[i], Sens, γ)
            end
        end
    end
    end
end



## Define center_std for Sparse maps

# Set ξ and σ for the diagonal entry, i.e. the last element of SparseVk
function center_std_diag(Vk::SparseUk, X::AbstractMatrix{Float64}, γ::Float64)
    @get Vk (k, p)
    @assert (p[k]>0 && γ >0.0) || (p[k]==0 && γ>=0.0) "Error scaling factor γ"

    # As long as he have p>1, we have in fact p+2 centers
    if p[k]>0
    ξ′ = view(Vk.ξ[end],:)
    σ′ = view(Vk.σ[end],:)
    tmp = view(X,k,:)
    quant!(ξ′, tmp, collect(1:p[k]+2)./(p[k]+3), sorted=true, alpha=0.5, beta = 0.5)

    σ′[1] = ξ′[2]-ξ′[1]
    σ′[end] = ξ′[end]-ξ′[end-1]
    for j=2:p[k]+1
    @inbounds σ′[j] = 0.5*(ξ′[j+1]-ξ′[j-1])
    end
    rmul!(σ′, γ)

    end
end


# Set ξ and σ for the off-diagonal entries, i.e. i=1:k-1 entries of Vk
function center_std_off(Vk::SparseUk, X::AbstractMatrix{Float64}, γ::Float64)
    @get Vk (k, p)
    @assert γ>=0.0 "Error scaling factor γ"

    for i=1:k-1
        pidx = p[i]

        ξ = view(Vk.ξ[i],:)
        σ = view(Vk.σ[i],:)
        tmp = view(X, i, :)

        # Testcase according to pidx

        if pidx<1
            #There is no rbf
        elseif pidx ==1 #only one rbf
            qq = zeros(3)
            p_range = [0.25;0.5;0.75]
            quant!(qq, tmp, p_range, sorted=true, alpha=0.5, beta = 0.5)
            ξ .= qq[2]
            σ .= (qq[3]-qq[1])*0.5
            rmul!(σ, γ)

        elseif pidx ==2
            p_range = collect(1.0:pidx)./(pidx+1.0)
            quant!(ξ, tmp, p_range, sorted=true, alpha=0.5, beta = 0.5)
            σ[1:2] .= (ξ[2]-ξ[1])*ones(2)
            rmul!(σ, γ)

        else
            p_range = collect(1.0:pidx)./(pidx+1.0)
            quant!(ξ, tmp, p_range, sorted=true, alpha=0.5, beta = 0.5)

            σ[1] = (ξ[2]-ξ[1])
            σ[end] = (ξ[end]-ξ[end-1])
            for j=2:pidx-1
            @inbounds σ[j] = 0.5*(ξ[j+1]-ξ[j-1])
            end
            rmul!(σ, γ)
        end
    end
end

# Assume an unsorted array
function center_std(T::SparseKRmap, X::AbstractMatrix{Float64}; start::Int64=1)
    @get T (k, p, γ)
    Sens = deepcopy(X)
    sort!(Sens,2)
    if k==1 && !allequal(p[k], -1)
        center_std_diag(T.U[1], Sens, γ)
    else
        @inbounds for i=start:k
            if !allequal(p[i], -1)
            center_std_diag(T.U[i], Sens, γ)
            center_std_off(T.U[i], Sens, γ)
            end
        end
    end
end


## quantile_ricardo equivalent to quantile from Statistics with alpha = beta = 0.5



function quantile_ricardo(v::Array{Float64,1},p::Int64)
    # From Ricardo Baptista and Youssef Marzouk
    n= length(v)

    r = zeros(p)
    r .= collect(1:p)/(p+1)

    rmul!(r,n)
    k = zeros(Int64, size(r,1))
    kp1 = zeros(Int64, size(r,1))
    for (i, ri) in enumerate(r)
        k[i] = floor(ri + 0.5)
        kp1[i] = k[i] +1
    end
    # k = convert(Array{Int64,1},floor.(r .+ 0.5))
    # kp1 = k .+1
    r .-= k

    # Find indices that are out of the range 1 to n and cap them
    k[k .< 1] .=1
    kp1 .= min.(kp1, n)

    # Use simple linear interpolation for the valid percentages
    return @. (0.5 + r)*v[kp1] + (0.5 - r)*v[k]
end

function quantile_ricardo(v::Array{Float64,1},p::Array{Float64,1})
    # From Ricardo Baptista and Youssef Marzouk
    n= length(v)
    r = p
    rmul!(r,n)
    k = zeros(Int64, size(r,1))
    kp1 = zeros(Int64, size(r,1))
    for (i, ri) in enumerate(r)
        k[i] = floor(ri + 0.5)
        kp1[i] = k[i] + 1
    end
    # k = convert(Array{Int64,1},floor.(r .+ 0.5))

    # k = convert(Array{Int64,1},floor.(r .+ 0.5))
    # kp1 = k .+1
    r .-= k

    # Find indices that are out of the range 1 to n and cap them
    k[k .< 1] .=1
    kp1 .= min.(kp1, n)

    # Use simple linear interpolation for the valid percentages
    return @. (0.5 + r)*v[kp1] + (0.5 - r)*v[k]
end
