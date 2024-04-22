module Namtso

using Dates,JSON,Random,DataFrames

export EChart,series!,public_render!,JSFunc,@js_str


include("Base.jl")
include("JSON.jl")

include("PlotWithVectors/PlotWithVectors.jl")
include("PlotWithDataFrame/PlotWithDataFrame.jl")
include("Show.jl")


end # module
