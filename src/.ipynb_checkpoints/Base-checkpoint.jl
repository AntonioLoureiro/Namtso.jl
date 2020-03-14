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

mutable struct Plot
   series::Vector{Series} 
   options::Dict{String,Any} 
end
