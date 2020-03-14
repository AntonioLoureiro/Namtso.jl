function series!(ec::EChart,kind::String,args...;kwargs...)
    data=[]
    for r in args
       push!(data,DataAttrs(r))
    end
    
    series_options=Dict()
    series_name="Series"*string(length(ec["series"])+1)
    
    for (k,v) in kwargs
       k=string(k)
       if k=="name"
          series_name=v
       else
         series_options[k]=v 
       end
    end
    
    nt=Namtso.dict(Series(kind,series_name,data,series_options))
    
    push!(ec["series"],nt.series_options)
    len_x=length(ec.options["xAxis"])
    len_y=length(ec.options["yAxis"])
        
    if len_x==1
        if ec.options["xAxis"][1]["type"]!=nt.xaxis["type"]
            push!(ec.options["xAxis"],nt.xaxis)
            ec["series"][end]["xAxisIndex"]=1
        end
    elseif len_x==2
        @assert nt.xaxis["type"] in map(x->x["type"],ec.options["xAxis"]) "X Axis type must be one of the two existent"
    end
    
    if len_y==1
        if ec.options["yAxis"][1]["type"]!=nt.yaxis["type"]
            push!(ec.options["yAxis"],nt.yaxis)
            ec["series"][end]["yAxisIndex"]=1
        end
    elseif len_y==2
        @assert nt.yaxis["type"] in map(x->x["type"],ec.options["yAxis"]) "Y Axis type must be one of the two existent"
    end
    
    ## legend
    if length(ec["series"])>1
       ec.options["legend"]=Dict("data"=>map(x->x["name"],ec["series"])) 
    end
        
    return nothing
end
