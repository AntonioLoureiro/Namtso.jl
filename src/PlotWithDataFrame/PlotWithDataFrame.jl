mutable struct PlotWithDataFrame <:Plot
   df::DataFrame
   options::Dict{String,Any} 
end

function EChart(df::DataFrame;series=nothing,kwargs...)
    
    chart_options=Dict{String,Any}()
    
    for (k,v) in kwargs
       k=string(k)
       chart_options[k]=v
    end
    
    SeriesWithDataFrame!(series,df,chart_options)
    chart_options["series"]=series
    chart_options["dataset"]=dataset(df)
    
    haskey(chart_options,"legend") ? nothing : chart_options["legend"]=Dict()
    haskey(chart_options,"tooltip") ? nothing : chart_options["tooltip"]=Dict()
    
    p=PlotWithDataFrame(df,chart_options)

    return EChart(p)
end

dict(p::PlotWithDataFrame)=p.options

SeriesWithDataFrame!(arr::Vector,df::DataFrame,chart_options::Dict)=map(x->SeriesWithDataFrame!(x,df,chart_options),arr)
seriestype(arr::Vector{T} where T<:Number)="value"
seriestype(arr::Vector{T} where T<:AbstractString)="category"
seriestype(arr::Vector{T} where T<:Dates.AbstractTime)="time"
get_chart_axys_type(arr::Vector)=get_chart_axys_type(arr[1])
get_chart_axys_type(d::Dict)=get(d,"type",nothing)

function SeriesWithDataFrame!(d::Dict,df::DataFrame,chart_options::Dict)
    
    @assert haskey(d,"type") "Series does not have type key!"
    @assert haskey(d,"encode") "Series does not have encode key!"
    @assert d["encode"] isa Dict "Series encode is not a Dict!"
    df_names=names(df)
    
    for k in ["x","y","z"]
        if haskey(d["encode"],k)
            @assert d["encode"][k] in df_names "Field $(d["encode"][k]) not present in DataFrame!"
            if k=="x" 
                if haskey(chart_options,"xAxis")
                   axys_type=get_chart_axys_type(chart_options["xAxis"]) 
                   @assert axys_type==nothing || axys_type==seriestype(df[!,Symbol(d["encode"][k])]) "X Axys inconsistent Types"
                else
                    chart_options["xAxis"]=[Dict("type"=>seriestype(df[!,Symbol(d["encode"][k])]))]
                end
            end
            
            if k=="y" 
                if haskey(chart_options,"yAxis")
                    axys_type=get_chart_axys_type(chart_options["yAxis"]) 
                    @assert axys_type==nothing || axys_type==seriestype(df[!,Symbol(d["encode"][k])]) "Y Axys inconsistent Types"
                else
                    chart_options["yAxis"]=[Dict("type"=>seriestype(df[!,Symbol(d["encode"][k])]))]
                end
            end
            
        end
    end
    
    haskey(chart_options,"xAxis") ? nothing : chart_options["xAxis"]=[Dict()]
    haskey(chart_options,"yAxis") ? nothing : chart_options["yAxis"]=[Dict()]
    
end


function dataset(df::DataFrame)
    d=Dict{String,Any}()
    d["dimensions"]=names(df)
    d["source"]=[Dict(k=>r[Symbol(k)] for k in d["dimensions"]) for r in eachrow(df)]
     
    return d
end
