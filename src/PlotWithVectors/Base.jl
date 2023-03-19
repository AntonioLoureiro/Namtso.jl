axisTypes=Union{Number,Date,AbstractString}
struct DataAttrs
    data::Vector{T} where T<:axisTypes
end

mutable struct Series
   plot_type::String
   name::String
   data::Vector{DataAttrs} 
   options::Dict{String,Any} 
end

mutable struct PlotWithVectors <:Plot
   series::Vector{Series} 
   options::Dict{String,Any} 
end


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
    p=PlotWithVectors([series],chart_options)
    
    return EChart(p)
end

