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
    return EChart(id,options_d,width,height)
end


function EChart(kind::String,x::Vector,y::Vector;kwargs...)
    
    data=[]
    push!(data,DataAttrs(x))
    push!(data,DataAttrs(y))
    series_name="Series1"
    series_options=Dict()
    chart_options=Dict()
    
    series=Series(kind,series_name,data,series_options)    
    
    p=Plot([series],chart_options)
    
    EChart(p)
end

