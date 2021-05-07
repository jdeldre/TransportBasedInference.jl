
@testset "Test optimization for Nx=1 and p=0" begin
   Nx = 1
   Ne = 10
   p = 0
   γ = 2.0


   X = reshape([-1.5438
      -1.5518
       0.8671
      -0.1454
      -0.3862
       1.3162
      -0.7965
       0.1354
       0.4178
       0.8199],1,Ne)


   S = RadialMap(Nx, p; γ = γ);
   W = create_weights(S, X)
   center_std!(S, X);
   compute_weights(S, X, W)

   # With λ = δ = 0.0

   λ = 0.0
   δ = 0.0
   xopt = optimize(S.C[1], W, λ, δ);

   @test norm(xopt - [0.092087627168250; 1.061773632748180])<1e-10

   # With λ = 0.1 and δ = 1e-8

   λ = 0.1
   δ = 1e-8
   xopt = optimize(S.C[1], W, λ, δ);

   @test norm(xopt - [ 0.092087627168250; 1.061773632748180])<1e-10

end

@testset "Test optimization for Nx=2 and p=0" begin

    Nx = 2
    Ne = 10
    p = 0
    γ = 2.0
    λ = 0.0

    X = Matrix([-0.8544   -0.7938;0.3573    0.5410; 2.7485   -0.5591; -1.5130    1.9766; 0.4340    0.5447; -0.2298   -0.1379;-0.8271   0.6199;-0.8320   -0.0056;0.4979    1.1072;2.3156   -0.1856]')

    @time S = RadialMap(Nx, p; γ = γ)

    center_std!(S, X)
    W = create_weights(S, X)
   compute_weights(S, X, W)

    # With λ = δ = 0.0

    λ = 0.0
    δ = 0.0

    xopt = optimize(S.C[2], W, λ, δ)

    @test norm(xopt -[0.357284296467942; -0.513627363149479; 1.411806803694895 ])<1e-10

    # With λ = 0.1  & δ = 1e-8
    λ = 0.1
    δ = 1e-8

    xopt = optimize(S.C[2], W, λ, δ)

    @test norm(xopt -[0.353742957402480; -0.512879943932609; 1.411791355362390 ])<1e-10
end

@testset "Test optimization for Nx=3 and p=0" begin

   Nx = 3
   Ne = 10
   p = 0
   γ = 2.0

   X = Matrix([0.1733    0.2760    1.0093; 0.6163    0.4598  0.0510;0.8639   -0.2175   -0.4404;-1.4169    0.7961   -0.8485;0.2000   -1.5180   -0.2404;0.1958   -1.0749    0.6029;-0.1511   -3.0722   -1.5163;0.8928    0.5214   -0.0683;-0.3642   -0.9910    0.7824;-0.8262   -0.2531   -1.4207]')
   S = RadialMap(Nx, p; γ = γ)
   center_std!(S, X)
   W = create_weights(S, X)
  compute_weights(S, X, W)

   # With λ = δ = 0.0
   λ = 0.0
   δ = 0.0

   xopt = optimize(S.C[3], W, λ, δ)

   @test norm(xopt -[-0.609710825728394; -0.275729138896713; 0.156805424543943; 1.366651306860556])<1e-10

   # With λ = 0.1  & δ = 1e-8
   λ = 0.1
   δ = 1e-8

   xopt = optimize(S.C[3], W, λ, δ)

   @test norm(xopt -[-0.603717368357810; -0.273039744501052; 0.158055928017947; 1.366632953261741])<1e-10

end


@testset "Test optimization for Nx=1 and p=3" begin
   Nx = 1
   Ne = 10
   p = 3
   γ = 2.0

   X = reshape([-1.5438
      -1.5518
       0.8671
      -0.1454
      -0.3862
       1.3162
      -0.7965
       0.1354
       0.4178
       0.8199],1,Ne)


   S = RadialMap(Nx, p; γ = γ)
   W = create_weights(S, X)
   center_std!(S, X)
  compute_weights(S, X, W)

   # With λ = δ = 0.0
   λ = 0.0
   δ = 0.0
   xopt = optimize(S.C[1], W, λ, δ);

   @test norm(xopt - [0.453363732161572; 2.304194295945015; 0.0; 0.0; 0.0;2.552281803302206])<1e-10


   # With λ = 0.1 and δ = 1e-8
   λ = 0.1
   δ = 1e-8
   xopt = optimize(S.C[1], W, λ, δ);

   @test norm(xopt - [0.450882345511096; 2.295315495868833; 0.000000043115815; 0.000000032750391; 0.000000035316480; 2.547661799360081])<1e-10

end

@testset "Test optimization for Nx=2 and p=2" begin

    Nx = 2
    Ne = 10
    p = 2
    γ = 2.0
    λ = 0.0

    X = Matrix([-0.8544   -0.7938;0.3573    0.5410;
                2.7485   -0.5591; -1.5130    1.9766;
                0.4340    0.5447; -0.2298   -0.1379;
                 -0.8271   0.6199;-0.8320   -0.0056;
                  0.4979    1.1072;2.3156   -0.1856]')

    @time S = RadialMap(Nx, p; γ = γ)

    center_std!(S, X);

    W = create_weights(S, X)
   compute_weights(S, X, W)
    λ = 0.0
    δ = 0.0

    ψ_off, ψ_mono, dψ_mono = rearrange(W,2)

    @test norm(ψ_off -[-0.854400000000000   0.156738618846197   0.137603564500746;
       0.357300000000000   0.140640215047531   0.156654816189471;
       2.748500000000000   0.058401570295014   0.104057315307723;
      -1.513000000000000   0.151170210915668   0.116608188942393;
       0.434000000000000   0.138617339050529   0.156745732145583;
      -0.229800000000000   0.152477989231576   0.151338989275322;
      -0.827100000000000   0.156747096365829   0.138351021862248;
      -0.832000000000000   0.156746902701754   0.138217735507039;
       0.497900000000000   0.136859341544330   0.156712800799488;
       2.315600000000000   0.073104270826721   0.119634493493623])<1e-10


    @test norm(ψ_mono -[-0.507201580119279   0.215069670075122   0.076485784936572   0.000988033380379;
      -0.016861853328784   0.748419931509968   0.499210902664930   0.126296856325961;
      -0.344698250357007   0.297187601194573   0.119362800788456   0.002977317564677;
      -0.000006458746850   0.987394188705160   0.937353523618463   1.123806421603995;
      -0.016625169238807   0.749707195139661   0.500789097335070   0.127438446122333;
      -0.140628787073782   0.471189825582940   0.233355359282062   0.016320116571698;
      -0.012393614690139   0.775096387582616   0.532827724212160   0.152299949965802;
      -0.099762356857753   0.528810174417060   0.278806935049185   0.025944471088712;
      -0.001358786238840   0.901159801018090   0.726875126285091   0.395949949965802;
      -0.157948250357007   0.450499667316035   0.218036687265869   0.013696473624777])<1e-10

      @test norm(dψ_mono -[0.758353059754083   0.319323853074808   0.153626107072438   0.004883698987942
       0.064354624108671   0.348381106647456   0.426538543776643   0.307522804512740
       0.621958562984279   0.378284965307517   0.213076838459543   0.013276098094082
       0.000046704774842   0.035615595830791   0.131731605768779   0.958660103131430
       0.063583925230259   0.347436551236228   0.426538543776643   0.309553737400797
       0.348279343219786   0.434770043962370   0.327283964601450   0.059220575922185
       0.049425557686157   0.327622035258933   0.425094484357949   0.352020159021600
       0.270920987266371   0.434770043962370   0.359163756509705   0.087695615816903
       0.006927621078729   0.190131276118064   0.355549818399670   0.647979840978400
       0.378041437015721   0.432547368859386   0.314948152204838   0.050949232751226])<1e-10

    # Rescale variable

    ψ_off, ψ_mono, dψ_mono = rearrange(W,2)

    no = size(ψ_off,2)
    nd = size(ψ_mono,2)
    nx = size(ψ_off,2)+size(ψ_mono,2)+1
    nlog = size(dψ_mono,2)

    x = zeros(nx)

    μψ = deepcopy(mean(ψ_mono, dims=1)[1,:])
    σψ = deepcopy(std(ψ_mono, dims=1, corrected=false)[1,:])

    ψ_mono .-= μψ'
    ψ_mono ./= σψ'
    dψ_mono ./= σψ'

    A = ψ_mono'*ψ_mono
    rmul!(A,1/Ne)

    μψ_off = deepcopy(mean(ψ_off, dims = 1)[1,:])
    σψ_off = deepcopy(std(ψ_off, dims = 1, corrected = false)[1,:])
    ψ_off .-= μψ_off'
    ψ_off ./= σψ_off'

    # Verify that ψ_off, ψ_mono and dψ_mono are correctly rescaled
    @test norm(ψ_off -[ -0.804643054198426   0.720356396590189   0.000623052929297;
       0.111611046705843   0.248725359467419   1.070112263485765;
       1.919770497132754  -2.160600297987687  -1.882578752010958;
      -1.302658198917046   0.557220098094831  -1.178004367363986;
       0.169609470027917   0.189461651315464   1.075216055914641;
      -0.332337771187114   0.595533762677487   0.771695150386939;
      -0.783999547592264   0.720604760429600   0.042583423646065;
      -0.787704792367729   0.720599086700126   0.035101063896698;
       0.217928886589593   0.137958024156060   1.073367373218454;
       1.592423463806471  -1.729858841443491  -1.008115264102931])<1e-10

    @test norm(ψ_mono -[-2.326960601058417  -1.624755258466316  -1.277802709623370  -0.600690875072745;
       0.695935005892621   0.555916671737632   0.330653865772685  -0.219729086471929;
      -1.325143748753542  -1.289005413932899  -1.114656931934708  -0.594643086552582;
       0.799846835694096   1.532994011692314   1.997773585133276   2.812882817478138;
       0.697394139747648   0.561179816554494   0.336658849834394  -0.216258444258148;
      -0.067075820810003  -0.577574682660793  -0.680918616973539  -0.554078532076930;
       0.723481252328697   0.664986832870473   0.458564877903041  -0.140674915908932;
       0.184861653602686  -0.341986390319673  -0.507976714922384  -0.524818730374682;
       0.791509871317472   1.180413498950799   1.196909505920374   0.600065740739791;
      -0.173848587961260  -0.662169086426033  -0.739205711109769  -0.562054887501982])<1e-10

    @test norm(dψ_mono -[4.675171126462628   1.305597115808049   0.584542795566616   0.014847340017250;
       0.396739851731833   1.424401477250050   1.622966548768615   0.934925689100038;
       3.834312630667317   1.546667293731231   0.810751070876959   0.040361771475244;
       0.000287930287880   0.145618996973497   0.501234865401183   2.914502418618957;
       0.391988569862249   1.420539539569087   1.622966548768615   0.941100097313083;
       2.147107483013941   1.777613886251173   1.245305809396379   0.180041404866467;
       0.304703643285317   1.339525313221805   1.617471945373052   1.070205802369169;
       1.670200918858584   1.777613886251173   1.366607475104451   0.266610745107435;
       0.042708094370782   0.777376457581746   1.352856547439218   1.969977479587423;
       2.330587828729104   1.768526189933186   1.198368407926584   0.154895005638792])<1e-10


    # Verify that we get the same QR decomposition
    #Assemble reduced QR to solve least square problem
    F = qr(vcat(ψ_off, Matrix(√λ*I, no, no)))
    Q1 = F.Q[1:Ne,1:no]
    # Asqrt = ψ_mono - Q1*(Q1'*ψ_mono)
    Asqrt = ψ_mono - fast_mul(ψ_mono, F.Q, Ne, no)

    # A = (Asqrt*Asqrt')/Ne
    A = BLAS.gemm('T', 'N', 1/Ne, Asqrt, Asqrt)

    @test norm(Q1 - [ -0.254450475470134   0.038542438904502  -0.287807026572883;
       0.035294511962590  -0.342003510157944   0.197040760785064;
       0.607084735573325   0.334774229448390  -0.420694384780400;
      -0.411936692127055   0.650442320408613   0.454822398694172;
       0.053635223802228  -0.337693395873161   0.262404719972692;
      -0.105094430945516  -0.271842813033772  -0.232724768964479;
      -0.247922425493313   0.019468149870942  -0.298845707008466;
      -0.249094126771204   0.022854173498846  -0.296968816757815;
       0.068915164956764  -0.332045729496864   0.316658455434137;
       0.503568514512315   0.217504136430448   0.306114369197955])<1e-10

    @test norm(Asqrt - [ -1.950781401302997  -1.300838981851897  -0.991890513984422  -0.458060391024002;
       0.099892510115221   0.085352068075599   0.033990870033547  -0.016912053174583;
       0.149656589279390   0.450550985993256   0.548653802955680   0.551333139636105;
       0.144073370024957   0.204556328914631   0.251633283508030   0.327703732540707;
      -0.003122789715729  -0.027881050368865  -0.081782795321125  -0.121731102269892;
       0.083258235300422  -0.268551915835203  -0.230658522708182   0.178298456149084;
       1.110570901959247   1.016081154773970   0.783074186747397   0.062561590138456;
       0.570158295426148   0.004447219686410  -0.190152589533267  -0.332197943172162;
       0.005871968596686   0.493585572789772   0.676896851023931   0.601539422000769;
      -0.209577679683306  -0.657301382177627  -0.799764572721539  -0.792534850824440])<1e-10

    @test norm(A - [0.546802799943131   0.389242527702498   0.297060133111796   0.108653878210649;
       0.389242527702498   0.372531651490579   0.331069886098672   0.174530422370543;
       0.297060133111796   0.331069886098672   0.315641016351602   0.196073264491252;
       0.108653878210649   0.174530422370543   0.196073264491252   0.177230269927555])<1e-10


    # Solve nonlinear optimization problem for g_mono
    g_mono = ones(nd)
    # Construct loss function, the convention is flipped inside the solver
    lhd = LHD(A, dψ_mono, λ, δ)
    g_mono,_,_,_ = projected_newton(g_mono, lhd, "TrueHessian")

    g_mono .+= δ

    @test norm(g_mono - [0.586712518793935; 0.421099709077361; 0; 1.154877772114433] )<1e-10

    # Approximate off-diagonal components
    @test norm(F.R -[3.162277660168379  -2.987894843243091  -1.096427127338353;
                      0  -1.035608229844348  -2.909339089462357;
                      0                   0   0.577575637438866])<1e-10

    g_off = -F.R\(Q1'*(ψ_mono*g_mono))

    @test norm(g_off -   [18.950658982438039; 21.898788492005636;-7.359525277156965])<1e-10

    g_mono ./= σψ
    g_off ./= σψ_off

    @test norm(g_mono - [3.617024276646359; 1.721720943628389; 0; 3.511040095485572] )<1e-10

    @test norm(g_off - 100*[ 0.143299653441423; 6.415635026543544; -4.131451837044035])<1e-10

    x[no+1] = -dot(μψ, g_mono)-dot(μψ_off, g_off)

    @test norm(x[no+1] -(-32.224538086041441))<1e-10

    x[no+2:nx] .= deepcopy(g_mono)


    if Nx>1
    x[1:no] .= deepcopy(g_off)
    end


    @test norm(x - [  14.32996534414215; 641.5635026543499; -413.14518370440067; -32.22453808604119; 3.61702427664633; 1.721720943628398; 0.0; 3.511040095485544])<1e-10

     xopt = optimize(S.C[2], W, λ, δ);
     @test norm(xopt - [  14.32996534414215; 641.5635026543499; -413.14518370440067; -32.22453808604119; 3.61702427664633; 1.721720943628398; 0.0; 3.511040095485544])<1e-10



       # With λ=0.1 and δ =1e-8
       λ = 0.1
       δ = 1e-8
       xopt = optimize(S.C[2], W, λ, δ);
       @test norm(xopt - [  1.765903393601119; 67.455814562648044; -48.756672231027366;  -3.584068900212547; 2.685855024209524; 1.468924592466743; 0.477896050052401; 1.308323191869906])<1e-10


 end

 @testset "Test optimization for Nx=2 and p=3" begin
     Nx = 2
     Ne = 10
     p = 3
     γ = 2.0

     X = Matrix([ -0.8544   -0.7938;0.3573    0.5410;
       2.7485   -0.5591; -1.5130    1.9766;
       0.4340    0.5447; -0.2298   -0.1379;
        -0.8271   0.6199;-0.8320   -0.0056;
         0.4979    1.1072;2.3156   -0.1856]')

     S = RadialMap(Nx, p; γ = γ)

     center_std!(S, X);

     W = create_weights(S, X)
    compute_weights(S, X, W)


     # With λ = δ = 0.0
     λ = 0.0
     δ = 0.0

     xopt = optimize(S.C[2], W, λ, δ);
     @test norm(xopt - [100*0.090840649611966; 100*1.373434239444840; 100*0.414826633064425; 100*(-0.287690260374867); -29.015187078639887; 4.209897756012423; 0.108369156771108; 0; 0; 8.850495668947518])<1e-10


     # With λ = 0.1 and δ = 1e-8
     λ = 0.1
     δ = 1e-8

     xopt = optimize(S.C[2], W, λ, δ);
     @test norm(xopt - [3.855369324206674; 28.717863158966477; 49.828564728403187; -23.158217471101509; -12.460695228234130; 3.669743272444025; 0.000000038099920; 0.794735311810544; 0.486353838959244; 5.376840166095511])<1e-10
 end


 @testset "Test optimization for Nx=3 and p=3" begin

     Nx = 3
     Ne = 10
     p = 3
     γ = 2.0

     X = Matrix([0.1733    0.2760    1.0093;
                   0.6163    0.4598  0.0510;
                 0.8639   -0.2175   -0.4404;
                -1.4169    0.7961   -0.8485;
                 0.2000   -1.5180   -0.2404;
                 0.1958   -1.0749    0.6029;
                -0.1511   -3.0722   -1.5163;
                 0.8928    0.5214   -0.0683;
                -0.3642   -0.9910    0.7824;
                -0.8262   -0.2531   -1.4207]')

     @time S = RadialMap(Nx, p; γ = γ)

     center_std!(S, X);
     W = create_weights(S, X)
    compute_weights(S, X, W)


     # With λ = δ = 0.0
     λ = 0.0
     δ = 0.0

     xopt = optimize(S.C[3], W, λ, δ);
     x_matlab  = [0.002236347046586e5;
     0.825719944026571e5    ;
     -1.071956974125768e5    ;
     0.593296179017564e5    ;
     -0.011049031761152e5    ;
     0.833628110516284e5      ;
     -1.085535253851930e5       ;
     0.696061056463158e5      ;
     -1.562689086584463e+04 ;
           0.0             ;
           0.0             ;
           0.0             ;
           0.0             ;
           1000*2.263679644184734  ]
     @test norm(xopt - x_matlab)/norm(x_matlab)<1e-10


     # With λ = 0.1 and δ = 1e-8
     λ = 0.1
     δ = 1e-8
     #
     xopt = optimize(S.C[3], W, λ, δ);

     @test norm(xopt - [   1.051136807671425;
     0.638509720542414;
     -23.285653280072371;
     -0.955334980052370;
     -2.821327423813651;
     -15.674943048773969;
     5.749217387570198;
     13.386252213401695;
     6.134578583234069;
     5.778639058642066;
     0.000000041429348;
     0.000000029234255;
     0.000000036290793;
     3.914178426750072])<1e-10
 end


## Test optimization with SparseRadialMap

@testset "Test optimization with SparseRadialMap Nx=1 and p=0" begin

    Nx = 1
    Ne = 10
    γ = 2.0

    X  =  reshape([0.017374310426544
       0.735136768751132
      -0.984272698022620
       0.134246840483926
      -0.720332223266792
       0.570079159353393
      -0.178637174884214
      -0.567524930231864
       0.028803259857213
      -0.614918061442867],1,Ne)

      S = SparseRadialMap(Nx, [0]; γ = γ)
      center_std!(S, X)

      xopt = optimize(S.C[1], X, S.λ, S.δ)

    @test norm(xopt - [0.295725384806749; 1.871626642209824])<1e-14
end

@testset "Test optimization with SparseRadialMap Nx=1 and p=2" begin

    Nx = 1
    Ne = 10
    γ = 2.0


    X = reshape([0.017374310426544
       0.735136768751132
      -0.984272698022620
       0.134246840483926
      -0.720332223266792
       0.570079159353393
      -0.178637174884214
      -0.567524930231864
       0.028803259857213
      -0.614918061442867],1,Ne)

      S = SparseRadialMap(Nx, [2]; γ = γ)
      center_std!(S, X)

      xopt = optimize(S.C[1], X, S.λ, S.δ)


    @test norm(xopt - [0.033932167701879; 4.133761421140692; 0.000000039870398; 0.000000040266888; 3.328673620931276])<1e-14
end


@testset "Test optimization with SparseRadialMap Nx=2 and p=[0 0]" begin

    Nx = 2
    Ne = 10
    γ = 2.0

    X = Matrix([  -0.737609918489704   0.413557038884469
       0.602049917255313   2.288861842327617
       1.099780136322616   0.087381084349074
       0.200615477691937  -1.421682449747359
      -0.427674259885219  -2.022946349735899
      -0.087812697126117  -0.198683683159131
       0.135174851422381   0.384267545498855
       0.753036725634817   0.470902988284163
      -0.228309526653063   1.272982451997852
      -0.684323467801375   0.567990940582801]')

      S = SparseRadialMap(Nx, [[-1], [0; 0]])
      center_std!(S, X)

      xopt = optimize(S.C[2], X, S.λ, S.δ)


    @test norm(xopt - [-0.350857378599181; -0.139765206111085; 0.877501808357206])<1e-14
end

@testset "Test optimization with SparseRadialMap Nx=2 and p=[0 1]" begin
    Nx = 2
    Ne = 10
    γ = 2.0


    X = Matrix([  -0.737609918489704   0.413557038884469
           0.602049917255313   2.288861842327617
           1.099780136322616   0.087381084349074
           0.200615477691937  -1.421682449747359
          -0.427674259885219  -2.022946349735899
          -0.087812697126117  -0.198683683159131
           0.135174851422381   0.384267545498855
           0.753036725634817   0.470902988284163
          -0.228309526653063   1.272982451997852
          -0.684323467801375   0.567990940582801]')

    S = SparseRadialMap(Nx, [[-1], [0; 1]]; γ = γ)
    center_std!(S, X)

    xopt = optimize(S.C[2], X, S.λ, S.δ)


    @test norm(xopt - [-0.296920845324240; -0.450160011091217; 0.685091255311441;
    1.423017573574061;
    0.566245516556744])<1e-14
end


@testset "Test optimization with SparseRadialMap Nx=2 and p=[0 2]" begin

Nx = 2
Ne = 10
γ = 2.0



X = Matrix([  -0.737609918489704   0.413557038884469
   0.602049917255313   2.288861842327617
   1.099780136322616   0.087381084349074
   0.200615477691937  -1.421682449747359
  -0.427674259885219  -2.022946349735899
  -0.087812697126117  -0.198683683159131
   0.135174851422381   0.384267545498855
   0.753036725634817   0.470902988284163
  -0.228309526653063   1.272982451997852
  -0.684323467801375   0.567990940582801]')

  S = SparseRadialMap(Nx, [[-1], [0; 2]]; γ = γ)
  center_std!(S, X)

  xopt = optimize(S.C[2], X, S.λ, S.δ)


@test norm(xopt - [-0.290599917218335; -0.244106257901270; 0.928468014306679;
   0.000000037435467;
   1.275553022078607;
   0.695142104297181])<1e-14
end

@testset "Test optimization with SparseRadialMap Nx=2 and p=[2 2]" begin

Nx = 2
Ne = 10
γ = 2.0



X = Matrix([  -0.737609918489704   0.413557038884469
   0.602049917255313   2.288861842327617
   1.099780136322616   0.087381084349074
   0.200615477691937  -1.421682449747359
  -0.427674259885219  -2.022946349735899
  -0.087812697126117  -0.198683683159131
   0.135174851422381   0.384267545498855
   0.753036725634817   0.470902988284163
  -0.228309526653063   1.272982451997852
  -0.684323467801375   0.567990940582801]')

  S = SparseRadialMap(Nx, [[-1], [2; 2]]; γ = γ)
  center_std!(S, X)

  xopt = optimize(S.C[2], X, S.λ, S.δ)


@test norm(xopt - [   2.205922038593491;
  21.094127932392510;
 -15.821105702007772;
  -2.010486812456307;
   0.999304051913047;
   0.000000037435467;
   1.303627375210608;
   0.764098525416240])<1e-12
end


@testset "Test optimization with SparseRadialMap Nx=2 and p=[2 0]" begin

Nx = 2
Ne = 10
γ = 2.0



X = Matrix([  -0.737609918489704   0.413557038884469
   0.602049917255313   2.288861842327617
   1.099780136322616   0.087381084349074
   0.200615477691937  -1.421682449747359
  -0.427674259885219  -2.022946349735899
  -0.087812697126117  -0.198683683159131
   0.135174851422381   0.384267545498855
   0.753036725634817   0.470902988284163
  -0.228309526653063   1.272982451997852
  -0.684323467801375   0.567990940582801]')

  S = SparseRadialMap(Nx, [[-1], [2; 0]]; γ = γ)
  center_std!(S, X)

  xopt = optimize(S.C[2], X, S.λ, S.δ)

  @test norm(xopt - [ 2.175874123786137; 21.548828045380638; -15.447825995278832;
                     -2.188592622357425;
                      0.933194195948753])<1e-12
end


@testset "Test optimization with SparseRadialMap Nx=3 and p=[0 0 0]" begin

Nx = 3
Ne = 10
γ = 2.0



X = Matrix([  0.375413787969851  -0.991365932946799   2.278410854329425
   1.121729788801830   0.216910057645809   1.225483370520654
  -0.015678780143914  -0.433156720743754   0.831025086529337
  -0.674285107908432   0.572290138313797  -1.493962274420239
   2.973707136592813   0.264962909286999   0.967684185813051
  -0.369888286517882   0.515287247888629   0.671466599596567
   0.435525083368351  -1.123591346893271  -1.469294876880461
  -1.130590197154928  -0.559193704135775  -0.001325508177795
  -2.003193706192794  -0.846920007816157   0.559462142237872
   0.277688627801369   1.179218444917551   0.729724225819224]')

  S = SparseRadialMap(Nx, [[-1], [-1; -1], [0; 0; 0]]; γ = γ)
  center_std!(S, X)

  xopt = optimize(S.C[3], X, S.λ, S.δ)

  @test norm(xopt - [-0.238818177855404;  0.112131135966394; -0.369644592955786;  0.946375346756640])<1e-12

end

@testset "Test optimization with SparseRadialMap Nx=3 and p=[0 -1 0]" begin

Nx = 3
Ne = 10
γ = 2.0



X = Matrix([  0.375413787969851  -0.991365932946799   2.278410854329425
   1.121729788801830   0.216910057645809   1.225483370520654
  -0.015678780143914  -0.433156720743754   0.831025086529337
  -0.674285107908432   0.572290138313797  -1.493962274420239
   2.973707136592813   0.264962909286999   0.967684185813051
  -0.369888286517882   0.515287247888629   0.671466599596567
   0.435525083368351  -1.123591346893271  -1.469294876880461
  -1.130590197154928  -0.559193704135775  -0.001325508177795
  -2.003193706192794  -0.846920007816157   0.559462142237872
   0.277688627801369   1.179218444917551   0.729724225819224]')

  S = SparseRadialMap(Nx, [[-1], [-1; -1], [0; -1; 0]]; γ = γ)
  center_std!(S, X)

  xopt = optimize(S.C[3], X, S.λ, S.δ)

  @test norm(xopt - [-0.221895676794685; -0.383494876901790; 0.943249178908141])<1e-12

end

@testset "Test optimization with SparseRadialMap Nx=3 and p=[2 -1 0]" begin

Nx = 3
Ne = 10
γ = 2.0



X = Matrix([  0.375413787969851  -0.991365932946799   2.278410854329425
   1.121729788801830   0.216910057645809   1.225483370520654
  -0.015678780143914  -0.433156720743754   0.831025086529337
  -0.674285107908432   0.572290138313797  -1.493962274420239
   2.973707136592813   0.264962909286999   0.967684185813051
  -0.369888286517882   0.515287247888629   0.671466599596567
   0.435525083368351  -1.123591346893271  -1.469294876880461
  -1.130590197154928  -0.559193704135775  -0.001325508177795
  -2.003193706192794  -0.846920007816157   0.559462142237872
   0.277688627801369   1.179218444917551   0.729724225819224]')

  S = SparseRadialMap(Nx, [[-1], [-1; -1], [2; -1; 0]]; γ = γ)
  center_std!(S, X)

  xopt = optimize(S.C[3], X, S.λ, S.δ)

  @test norm(xopt - [   0.262639648863806;
                       16.549041782004032;
                      -11.747435767576015;
                       -1.410877218960467;
                        0.996852513304659])<1e-12

end

@testset "Test optimization with SparseRadialMap Nx=3 and p=[2 -1 2]" begin

Nx = 3
Ne = 10
γ = 2.0



X = Matrix([  0.375413787969851  -0.991365932946799   2.278410854329425
   1.121729788801830   0.216910057645809   1.225483370520654
  -0.015678780143914  -0.433156720743754   0.831025086529337
  -0.674285107908432   0.572290138313797  -1.493962274420239
   2.973707136592813   0.264962909286999   0.967684185813051
  -0.369888286517882   0.515287247888629   0.671466599596567
   0.435525083368351  -1.123591346893271  -1.469294876880461
  -1.130590197154928  -0.559193704135775  -0.001325508177795
  -2.003193706192794  -0.846920007816157   0.559462142237872
   0.277688627801369   1.179218444917551   0.729724225819224]')

  S = SparseRadialMap(Nx, [[-1], [-1; -1], [2; -1; 2]]; γ = γ)
  center_std!(S, X)

  xopt = optimize(S.C[3], X, S.λ, S.δ)

  @test norm(xopt - [     0.246247362219524;
                         20.601841748108630;
                        -16.322738975189164;
                         -1.294380861832026;
                          0.898035319369626;
                          0.000000043296784;
                          2.067302695773216;
                          0.631236879169851])<1e-12

end


@testset "Test optimization with SparseRadialMap Nx=3 and p=[-1 -1 2]" begin

Nx = 3
Ne = 10
γ = 2.0



X = Matrix([  0.375413787969851  -0.991365932946799   2.278410854329425
   1.121729788801830   0.216910057645809   1.225483370520654
  -0.015678780143914  -0.433156720743754   0.831025086529337
  -0.674285107908432   0.572290138313797  -1.493962274420239
   2.973707136592813   0.264962909286999   0.967684185813051
  -0.369888286517882   0.515287247888629   0.671466599596567
   0.435525083368351  -1.123591346893271  -1.469294876880461
  -1.130590197154928  -0.559193704135775  -0.001325508177795
  -2.003193706192794  -0.846920007816157   0.559462142237872
   0.277688627801369   1.179218444917551   0.729724225819224]')

  S = SparseRadialMap(Nx, [[-1], [-1; -1], [-1; -1; 2]]; γ = γ)
  center_std!(S, X)

  xopt = optimize(S.C[3], X, S.λ, S.δ)

  @test norm(xopt - [       -0.1178422702775955;
                             0.9302021941755624;
                          4.3296784157577845e-8;
                             1.4379052718065835;
                             0.6286862437766934])<1e-12

end


@testset "SparseRadialMap Test with optimization and evaluation of the resulting map" begin

      X = Matrix([6.831108232125667   6.831108465893829  10.748176564682273  17.220877261555913;
      7.341399771164814   7.341399033871628  11.440770534993137  18.015116463525178;
      6.877822405336048   6.877822863906546  10.793381797612751  17.379545045967195;
      6.971116690210811   6.971117274254750  10.941318835214862  17.571340756941474;
      7.800189373932513   7.800189247976281  11.929084958885008  18.852191934527564;
      6.706165535739543   6.706164938380805  10.596868885136731  17.100665224055952;
      7.162689725595848   7.162690676866085  11.236535720904731  17.691824497167673;
      7.700262639909202   7.700262776963255  11.870709137884843  18.589199307190668;
      6.941836510989174   6.941836045832242  10.822143995520504  17.705463568541791;
      7.284400905037024   7.284402833890172  11.438244192350945  17.713180862215779;
      6.114110264862537   6.114110399157427   9.744642327011279  16.427244631267527;
      6.884587321648968   6.884587349033709  10.880879551471059  17.360443337222691;
      6.964593674795581   6.964592742775720  11.015485574206627  17.379079978320874;
      7.174466645033212   7.174468203234895  11.165089908005559  17.802087293640490;
      7.625148752606352   7.625148374481078  11.784628799983244  18.470370177818385;
      7.878948627898106   7.878948112320454  12.118366730171301  18.770876038639738;
      7.406860218451342   7.406861450644357  11.470902695133232  18.293040279245396;
      7.308212626757207   7.308212927902813  11.381148951581917  17.962547003679237;
      7.519983057000856   7.519981781231936  11.597728250168640  18.407564589808729;
      7.813106349722561   7.813107415959238  11.973288464744240  18.802480702520111]')


      order = [[-1], [1; 1], [-1; 1; 0], [-1; 1; 1; 0]]
      T = SparseRadialMap(4, order; λ = 0.0)

      optimize(T, X; start = 2)

      @test norm(T(X[:,1]) -   [6.831108232125667;
                                         0.07966241537360474;
                                        -0.18141931240603526;
                                         -2.0970508045942893])<1e-8


end
