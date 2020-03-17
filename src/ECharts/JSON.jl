ECHART_FUNCTION_ATTRS=["formatter"]

function echart_json(v,f_mode)
    if f_mode
        return v
    else
        return JSON.json(v)
    end
end

echart_json(a::Array,f_mode)="[$(join(echart_json.(a,f_mode),","))]"

function echart_json(d::Dict,f_mode::Bool=false)
    els=[]
    for (k,v) in d
        if k in ECHART_FUNCTION_ATTRS
            j="\"$k\": $(vue_json(v,true))"
        else
            j="\"$k\":"*echart_json(v,f_mode==false ? false : true)
        end
        push!(els,j)
    end
    return "{$(join(els,","))}"
end
