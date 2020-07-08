
@testset "Verify evaluation of Probabilistic hermite functions" begin

    # Unscaled

    x = randn(100)
    m = 5
    dV = vander(ProHermite(m; scaled = false), 0, x)

    for i=0:5
        @test norm(dV[:,i+1] - FamilyProPolyHermite[i+1].(x) .* exp.(-x.^2/4))<1e-8
    end

    # Scaled
    dV = vander(ProHermite(m; scaled = true), 0, x)


    for i=0:5
        @test dV[:,i+1] == FamilyScaledProPolyHermite[i+1].(x).*exp.(-x.^2/4)
    end
end

@testset "Verify 1st derivative of Probabilistic hermite functions" begin
    # Unscaled
    x = randn(100)
    m = 5
    dV = vander(ProHermite(m; scaled = false), 1, x)

    for i=0:5
        @test norm(dV[:,i+1] - (FamilyProPolyHermite[i+1].(x) .* (-0.5*x) .* exp.(-x.^2/4) +
            derivative(FamilyProPolyHermite[i+1],1).(x) .* exp.(-x.^2/4)))<1e-8
    end

    # Scaled
    x = randn(100)
    m = 5
    dV = vander(ProHermite(m; scaled = true), 1, x)

    for i=0:5
        @test norm(dV[:,i+1] - (1/Cpro(i))*(FamilyProPolyHermite[i+1].(x) .* (-0.5*x) .* exp.(-x.^2/4) +
            derivative(FamilyProPolyHermite[i+1],1).(x) .* exp.(-x.^2/4)))<1e-8
    end
end


@testset "Verify second derivative of Probabilistic hermite functions" begin
    # Unscaled
    x = randn(100)
    m = 5
    dV = vander(ProHermite(m; scaled = false), 2, x)

    for i=0:5
        Hen = FamilyProPolyHermite[i+1].(x)
        Henp = derivative(FamilyProPolyHermite[i+1],1).(x)
        Henpp = derivative(FamilyProPolyHermite[i+1],2).(x)
        E = exp.(-x.^2/4)

        @test norm(dV[:,i+1] - (Henpp .*E - x .* Henp.*E + 0.5*Hen .* (0.5*x.^2 .- 1.0) .* E))<1e-8
    end

    # Scaled
    x = randn(100)
    m = 5
    dV = vander(ProHermite(m; scaled = true), 2, x)

    for i=0:5
        Hen = FamilyProPolyHermite[i+1].(x)
        Henp = derivative(FamilyProPolyHermite[i+1],1).(x)
        Henpp = derivative(FamilyProPolyHermite[i+1],2).(x)
        E = exp.(-x.^2/4)

        @test norm(dV[:,i+1] - (1/Cpro(i))*(Henpp .*E - x .* Henp.*E + 0.5*Hen .* (0.5*x.^2 .- 1.0) .* E))<1e-8
    end
end


# Need to write test for Hermite functionintegration 
