abstract type Plot end

mutable struct EChart
   id::String
   options::Dict{String,Any}
   width::Int64
   height::Int64
end

const BASE_OPTIONS=["title","legend","grid","xAxis","yAxis","radiusAxis","angleAxis","dataZoom","visualMap","tooltip","axisPointer","toolbox","brush","parallel","parallelAxis","singleAxis","timeline",
"graphic","aria","color","backgroundColor","textStyle","animation","width","height"]

function EChart(p::Plot)
    
    id=randstring(10)
    width=800
    height=600
    
    options_d=dict(p)
    if haskey(options_d,"width")
      width=options_d["width"]
      delete!(options_d,"width")
    end
    if haskey(options_d,"height")
      height=options_d["height"]
      delete!(options_d,"height")
    end
      
    return EChart(id,options_d,width,height)
end

import Base.getindex
import Base.setindex!

function Base.getindex(ec::EChart, i::String)
    
    if i=="width"
       return ec.width 
    elseif i=="height"
        return ec.height
    else
        return Base.getindex(ec.options, i)
    end
end

function Base.setindex!(ec::EChart, v,i::String)
    if i=="width"
       ec.width=v
    elseif i=="height"
        ec.height=v
    else
        
      Base.setindex!(ec.options, v,i)
    end
    return nothing
end
