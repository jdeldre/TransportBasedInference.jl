using Test

using LinearAlgebra, Statistics
using SpecialFunctions, ForwardDiff
using TransportMap


@testset "Function quartile from Ricardo Baptista" begin

@test quantile_ricardo(sort([0.5377;    1.8339;
   -2.2588;    0.8622;    0.3188;
      -1.3077;   -0.4336;    0.3426;
          3.5784;    2.7694]),3) ==  [-0.4336; 0.44015; 1.8339]

@test norm(quantile_ricardo(sort([0.5377;    1.8339;
             -2.2588;    0.8622;    0.3188;
                -1.3077;   -0.4336;    0.3426;
                    3.5784;    2.7694]),11) - [-1.9417666666666666;
 -1.162016666666667;
 -0.4336 ;
  0.19339999999999974;
  0.33466666666666667;
  0.44015   ;
  0.6458666666666668 ;
  1.0241499999999994;
  1.8339    ;
  2.6134833333333343 ;
  3.308733333333333])<1e-10
end


@testset "Center and standard deviations of a sample for diagonal component I" begin

    k = 1
    Ne = 10
    p = 3
    γ = 3.0

    ens = EnsembleState(k, Ne)
    ens.S .=     reshape([-1.5438
       -1.5518
        0.8671
       -0.1454
       -0.3862
        1.3162
       -0.7965
        0.1354
        0.4178
        0.8199],1,Ne)

    S = Uk(k, p);
    TransportMap.sort!(ens, 2)
    center_std_diag(S, ens, γ)

    @test norm(S.ξ[1]-[-1.4192500000000001, -0.45458333333333345, -0.0050000000000000044, 0.48481666666666645, 0.8592333333333333])<1e-10
    @test norm(S.σ[1]-[2.894, 2.121375, 1.4090999999999998, 1.29635, 1.1232500000000005])<1e-10

end

@testset "Center and standard deviations of a sample for diagonal component II" begin

    k = 1
    Ne = 10
    p = 6
    γ = 1.5

    ens = EnsembleState(k, Ne)
    ens.S .=     reshape([-1.5438
       -1.5518
        0.8671
       -0.1454
       -0.3862
        1.3162
       -0.7965
        0.1354
        0.4178
        0.8199],1,Ne)

    S = Uk(k, p);
    TransportMap.sort!(ens, 2)
    center_std_diag(S, ens, γ)

    @test norm(S.ξ[1]-[-1.5469111111111111, -1.0040833333333332, -0.45458333333333345, -0.15877777777777774, 0.15108888888888883, 0.48481666666666645, 0.8330111111111111, 1.0417500000000002])<1e-10
    @test norm(S.σ[1]-[0.8142416666666669, 0.8192458333333333, 0.6339791666666666, 0.45425416666666674, 0.4826958333333331, 0.5114416666666668, 0.4177000000000003, 0.31310833333333354])<1e-10

end

@testset "Center and standard deviations of a sample for diagonal component III" begin
    k = 2
    Ne = 10
    p = 1
    γ = 3.0
    λ = 0.0

    ens = EnsembleState(k, Ne)
    ens.S .= [-0.8544   -0.7938;0.3573    0.5410; 2.7485   -0.5591; -1.5130    1.9766; 0.4340    0.5447; -0.2298   -0.1379;-0.8271   0.6199;-0.8320   -0.0056;0.4979    1.1072;2.3156   -0.1856]'

    S = Uk(k, p)
    TransportMap.sort!(ens,2)

    center_std_diag(S, ens, γ)

    @test norm(S.ξ[2] -  [ -0.1856,0.2677, 0.6199])<1e-10
    @test norm(S.σ[2] -  [1.3598999999999999, 1.20825, 1.0566])<1e-10
end



@testset "Center and standard deviations of a sample for off-diagonal component" begin

k = 2
Ne = 10
p = 2
γ = 3.0
λ = 0.0

ens = EnsembleState(k, Ne)
ens.S .= [-0.8544   -0.7938;0.3573    0.5410; 2.7485   -0.5591; -1.5130    1.9766; 0.4340    0.5447; -0.2298   -0.1379;-0.8271   0.6199;-0.8320   -0.0056;0.4979    1.1072;2.3156   -0.1856]'

S = Uk(k, p)
TransportMap.sort!(ens, 2)
center_std_diag(S, ens, γ)
center_std_off(S, ens, γ)

@test norm(S.ξ[1] - [-0.8279166666666666, 0.44464999999999993])<1e-10
@test norm(S.ξ[2] - [-0.37235, -0.07175, 0.54285, 0.86355])<1e-10


@test norm(S.σ[1] - [3.8177, 3.8177])<1e-10
@test norm(S.σ[2] - [0.9018000000000002, 1.3728, 1.4029500000000001, 0.9621])<1e-10

end


@testset "Center and standard deviations of a sample" begin

k = 2
Ne = 10
p = 2
γ = 3.0
λ = 0.0

ens = EnsembleState(k, Ne)
ens.S .= [-0.8544   -0.7938;0.3573    0.5410; 2.7485   -0.5591; -1.5130    1.9766; 0.4340    0.5447; -0.2298   -0.1379;-0.8271   0.6199;-0.8320   -0.0056;0.4979    1.1072;2.3156   -0.1856]'

S = KRmap(k, p; γ = γ)

center_std(S, ens)

@test norm(ens.S - [-0.8544   -0.7938;0.3573    0.5410; 2.7485   -0.5591; -1.5130    1.9766; 0.4340    0.5447; -0.2298   -0.1379;-0.8271   0.6199;-0.8320   -0.0056;0.4979    1.1072;2.3156   -0.1856]')<1e-10


@test norm(S.U[1].ξ[1] - [-0.8432, -0.52845, 0.39565, 1.40675])<1e-10
@test norm(S.U[2].ξ[1] - [-0.8279166666666666, 0.44464999999999993])<1e-10
@test norm(S.U[2].ξ[2] - [-0.37235, -0.07175, 0.54285, 0.86355])<1e-10



@test norm(S.U[1].σ[1] -  [0.9442499999999999, 1.858275, 2.9028, 3.0332999999999997])<1e-10
@test norm(S.U[2].σ[1] - [3.8177, 3.8177])<1e-10
@test norm(S.U[2].σ[2] - [0.9018000000000002, 1.3728, 1.4029500000000001, 0.9621])<1e-10
end

## Perform the same validation with a Sparse structure

@testset "SparseUk: Center and standard deviations of a sample for diagonal component I" begin

    k = 1
    Ne = 10
    p = 3
    γ = 3.0

    ens = EnsembleState(k, Ne)
    ens.S .=     reshape([-1.5438
       -1.5518
        0.8671
       -0.1454
       -0.3862
        1.3162
       -0.7965
        0.1354
        0.4178
        0.8199],1,Ne)

    S = SparseUk(k, p);
    TransportMap.sort!(ens, 2)
    center_std_diag(S, ens, γ)

    @test norm(S.ξ[1]-[-1.4192500000000001, -0.45458333333333345, -0.0050000000000000044, 0.48481666666666645, 0.8592333333333333])<1e-10
    @test norm(S.σ[1]-[2.894, 2.121375, 1.4090999999999998, 1.29635, 1.1232500000000005])<1e-10

end


@testset "SparseUk Center and standard deviations of a sample for diagonal component II" begin

    k = 1
    Ne = 10
    p = 6
    γ = 1.5

    ens = EnsembleState(k, Ne)
    ens.S .=     reshape([-1.5438
       -1.5518
        0.8671
       -0.1454
       -0.3862
        1.3162
       -0.7965
        0.1354
        0.4178
        0.8199],1,Ne)

    S = SparseUk(k, p);
    TransportMap.sort!(ens, 2)
    center_std_diag(S, ens, γ)

    @test norm(S.ξ[1]-[-1.5469111111111111, -1.0040833333333332, -0.45458333333333345, -0.15877777777777774, 0.15108888888888883, 0.48481666666666645, 0.8330111111111111, 1.0417500000000002])<1e-10
    @test norm(S.σ[1]-[0.8142416666666669, 0.8192458333333333, 0.6339791666666666, 0.45425416666666674, 0.4826958333333331, 0.5114416666666668, 0.4177000000000003, 0.31310833333333354])<1e-10

end

@testset "SparseUk Center and standard deviations of a sample for diagonal component III" begin
    k = 2
    Ne = 10
    p = 1
    γ = 3.0
    λ = 0.0

    ens = EnsembleState(k, Ne)
    ens.S .= [-0.8544   -0.7938;0.3573    0.5410; 2.7485   -0.5591; -1.5130    1.9766; 0.4340    0.5447; -0.2298   -0.1379;-0.8271   0.6199;-0.8320   -0.0056;0.4979    1.1072;2.3156   -0.1856]'

    S = SparseUk(k, p)
    TransportMap.sort!(ens,2)

    center_std_diag(S, ens, γ)

    @test norm(S.ξ[2] -  [ -0.1856,0.2677, 0.6199])<1e-10
    @test norm(S.σ[2] -  [1.3598999999999999, 1.20825, 1.0566])<1e-10
end



@testset "SparseUk Center and standard deviations of a sample for off-diagonal component" begin

k = 2
Ne = 10
p = 2
γ = 3.0
λ = 0.0

ens = EnsembleState(k, Ne)
ens.S .= [-0.8544   -0.7938;0.3573    0.5410; 2.7485   -0.5591; -1.5130    1.9766; 0.4340    0.5447; -0.2298   -0.1379;-0.8271   0.6199;-0.8320   -0.0056;0.4979    1.1072;2.3156   -0.1856]'

S = SparseUk(k, p)
TransportMap.sort!(ens, 2)
center_std_diag(S, ens, γ)
center_std_off(S, ens, γ)

@test norm(S.ξ[1] - [-0.8279166666666666, 0.44464999999999993])<1e-10
@test norm(S.ξ[2] - [-0.37235, -0.07175, 0.54285, 0.86355])<1e-10


@test norm(S.σ[1] - [3.8177, 3.8177])<1e-10
@test norm(S.σ[2] - [0.9018000000000002, 1.3728, 1.4029500000000001, 0.9621])<1e-10

end


@testset "Center and standard deviations of a sample" begin

k = 2
Ne = 10
p = 2
γ = 3.0
λ = 0.0

ens = EnsembleState(k, Ne)
ens.S .= [-0.8544   -0.7938;0.3573    0.5410; 2.7485   -0.5591; -1.5130    1.9766; 0.4340    0.5447; -0.2298   -0.1379;-0.8271   0.6199;-0.8320   -0.0056;0.4979    1.1072;2.3156   -0.1856]'

S = SparseKRmap(k, [p; p]; γ = γ, λ = λ)

center_std(S, ens)

@test norm(ens.S - [-0.8544   -0.7938;0.3573    0.5410; 2.7485   -0.5591; -1.5130    1.9766; 0.4340    0.5447; -0.2298   -0.1379;-0.8271   0.6199;-0.8320   -0.0056;0.4979    1.1072;2.3156   -0.1856]')<1e-10


@test norm(S.U[1].ξ[1] - [-0.8432, -0.52845, 0.39565, 1.40675])<1e-10
@test norm(S.U[2].ξ[1] - [-0.8279166666666666, 0.44464999999999993])<1e-10
@test norm(S.U[2].ξ[2] - [-0.37235, -0.07175, 0.54285, 0.86355])<1e-10



@test norm(S.U[1].σ[1] -  [0.9442499999999999, 1.858275, 2.9028, 3.0332999999999997])<1e-10
@test norm(S.U[2].σ[1] - [3.8177, 3.8177])<1e-10
@test norm(S.U[2].σ[2] - [0.9018000000000002, 1.3728, 1.4029500000000001, 0.9621])<1e-10
end
