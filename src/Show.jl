import Base.show

function Base.show(io::IO, mm::MIME"text/html", ec::EChart)

     id=ec.id*randstring(5)
     options = Namtso.echart_json(ec.options)
    
     dom_str="""
        <div id=\"$(id)\" style=\"height:$(ec.height)px;width:$(ec.width)px;\"></div>
        <script type=\"text/javascript\">
                var myChart = echarts.init(document.getElementById(\"$(id)\"));
                myChart.setOption($options);
        </script>
      """
    public_script="""<script src="https://cdnjs.cloudflare.com/ajax/libs/echarts/5.4.1/echarts.min.js"></script>"""
    str=public_script*dom_str
    println(io,str)
end
