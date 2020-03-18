mutable struct EChart
   id::String
   options::Dict{String,Any}
   width::Int64
   height::Int64
end


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


const BASE_OPTIONS=["title","legend","grid","xAxis","yAxis","radiusAxis","angleAxis","dataZoom","visualMap","tooltip","axisPointer","toolbox","brush","parallel","parallelAxis","singleAxis","timeline",
"graphic","aria","color","backgroundColor","textStyle","animation","width","height"]

function EChart(kind::String,args...;kwargs...)
    data=[]
    for r in args
       push!(data,DataAttrs(r))
    end
    
    series_options=Dict()
    chart_options=Dict()
    
    for (k,v) in kwargs
       k=string(k)
       if k in BASE_OPTIONS
           chart_options[k]=v
       else
           series_options[k]=v 
       end
    end
 
    series_name="Series1"
    series=Series(kind,series_name,data,series_options)    
    p=Plot([series],chart_options)
    
    return EChart(p)
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

function dict_any(d::Dict)
    d=convert(Dict{String,Any},d)
    for (k,v) in d
        v isa Dict ? d[k]=dict_any(v) : nothing
    end
    return d
end

function Base.setindex!(ec::EChart, v,i::String)
    if i=="width"
       ec.width=v
    elseif i=="height"
        ec.height=v
    else
        
      options=dict_any(ec.options)
      Base.setindex!(options, v,i)
      ec.options=options
    end
    return nothing
end
