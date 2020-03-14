
const echarts_js_str="<script>$(read(joinpath(@__DIR__, "Assets", "echarts.min.js"), String))</script>"

import Base.show

function Base.show(io::IO, mm::MIME"text/html", ec::EChart)

     options = echart_json(ec.options)
    
     dom_str="""
        <div id=\"$(ec.id)\" style=\"height:$(ec.height)px;width:$(ec.width)px;\"></div>
        <script type=\"text/javascript\">

                var myChart = echarts.init(document.getElementById(\"$(ec.id)\"));
                myChart.setOption($options);
        </script>
      """
    println(io,echarts_js_str*dom_str)
end
