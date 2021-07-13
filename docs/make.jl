using Documenter, TransportBasedInference, Plots, PyPlot, ColorSchemes


ENV["GKSwstype"] = "nul"

makedocs(
    sitename = "TransportBasedInference.jl",
    doctest = true,
    clean = true,
    pages = [
        "Home" => "index.md",
        "Background" => "background.md",
        "Tutorials" => [
        #              # "tutorials/1.-Estimation-of-the-Banana-distribution.md",
        #              # "tutorials/2.-Basic-flow-with-a-stationary-body.md",
                      "tutorials/3.-Structure-discovery-of-the-Lorenz-96.md"
        #              # "tutorials/4.-Linear-ensemble-filtering-Lorenz-63.md",
        #              # "tutorials/5.-Linear-ensemble-filtering-Lorenz-96-with-localization.md",
        #              # "tutorials/6.-Radial-basis-nonlinear-ensemble-filtering-Lorenz-63.md",
        #              # "tutorials/7.-Radial-basis-nonlinear-ensemble-filtering-Lorenz-96.md"
                     ],
        "Manual" => ["manual/apidoc.md",
                     "manual/contribute.md",
                     "manual/LICENSE.md"]
    ],
    #format = Documenter.HTML(assets = ["assets/custom.css"])
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true",
        mathengine = MathJax(Dict(
            :TeX => Dict(
                :equationNumbers => Dict(:autoNumber => "AMS"),
                :Macros => Dict()
            )
        ))
    ),
    #assets = ["assets/custom.css"],
    #strict = true
)


#if "DOCUMENTER_KEY" in keys(ENV)
deploydocs(
     repo = "github.com/mleprovost/TransportBasedInference.jl.git",
     target = "build",
     deps = nothing,
     make = nothing
     #versions = "v^"
)
#end