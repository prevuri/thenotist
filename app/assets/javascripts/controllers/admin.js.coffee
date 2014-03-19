@AdminCtrl = ($scope, $http) ->
    margin = {top: 20, right: 20, bottom: 30, left: 50}
    width = 960 - margin.left - margin.right
    height = 500 - margin.top - margin.bottom
    padding = 100

    data = [[Date(2014,2,1),1], [Date(2014,2,1),2], [Date(2014,2,1),3]]

    mindate = new Date(2014,2,1)
    maxdate = new Date(2014,2,28)

    xScale = d3.time.scale().range([0, width]).domain([mindate, maxdate])
    yScale = d3.scale.linear().range([height, 0]).domain(d3.extent(data, (d) -> d[1]))

    xAxis = d3.svg.axis()
        .scale(xScale)
        .orient("bottom")
    yAxis = d3.svg.axis()
        .scale(yScale)
        .orient("left")

    svg = d3.select(".graph-container").append("svg")
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom)
        .append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
    
    line = d3.svg.line()
        .x (d) ->
            (d[0])
        .y (d) ->
            (d[1])

    svg.append("g")
      .attr("class", "xaxis")
      .attr("transform", "translate(0," + height + ")")
      .call(xAxis)

    svg.append("g")
      .attr("class", "yaxis")
      .call(yAxis)

    svg.append("path")
      .data(data)
      .enter()
      .attr("class", "line")
      .attr("d", line)

    svg.selectAll(".xaxis text")  # select all the text elements for the xaxis
        .attr("transform", (d) ->
            return "translate(" + this.getBBox().height*-2 + "," + this.getBBox().height + ")rotate(-45)"
        )