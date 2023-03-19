function dict(data::Vector{DataAttrs})
    
    data_len=length(data[1].data)
    @assert unique(map(x->length(x.data),data))==[data_len] "All Axis should have the same length!"
    
    ret_data=[]
    axis_len=length(data)
    
    for i in 1:data_len
        dot=[]
        for j in 1:axis_len
            push!(dot,data[j].data[i])
        end
        push!(ret_data,dot)
    end
    
    xaxis=Dict()
    yaxis=Dict()
    for j in 1:axis_len
        
        if j==1
           el_type=eltype(data[j].data)
            
           if el_type<:Number
                xaxis["type"]="value"
           elseif el_type<:AbstractString
                xaxis["type"]="category"
           elseif el_type<:Date
                xaxis["type"]="time"
           end
        end
        
        if j==2
           el_type=eltype(data[j].data)
           if el_type<:Number
                yaxis["type"]="value"
           elseif el_type<:AbstractString
                yaxis["type"]="category"
           elseif el_type<:Date
                yaxis["type"]="time"
           end
        end

    end
    
    return (data=ret_data,xaxis=xaxis,yaxis=yaxis)
end

function dict(series::Series)
    
    nt=dict(series.data)
    xaxis=nt.xaxis
    yaxis=nt.yaxis
    
    series_options=Dict("type"=>series.plot_type,"name"=>series.name,"data"=>nt.data)
    merge!(series_options,series.options)
   return (xaxis=xaxis,yaxis=yaxis,series_options=series_options)
    
end

function dict_any(d::Dict)	
    d=convert(Dict{String,Any},d)	
    for (k,v) in d	
        v isa Dict ? d[k]=dict_any(v) : nothing	
    end	
    return d	
end

function dict(p::PlotWithVectors)
    
    options=p.options
    series_d=Dict("series"=>[])
    for s in p.series
        nt=dict(s)
        push!(series_d["series"],nt.series_options)
        
        if length(nt.xaxis)!=0
            options["xAxis"]=[nt.xaxis]
        end
        if length(nt.yaxis)!=0
            options["yAxis"]=[nt.yaxis]
        end
    end
    
    ## legend
    if length(p.series)>1
       options["legend"]=Dict("data"=>map(x->x.name,p.series)) 
    end
        
    merge!(options,series_d)
   
    
    return dict_any(options)
end
