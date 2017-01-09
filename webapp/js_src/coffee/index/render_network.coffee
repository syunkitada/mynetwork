render_network = (graph) ->
    $('#network-panel').html('<svg id="network-svg" width="1000" height="600"></svg>')

    svg = d3.select('#network-svg')
    width = svg.attr("width")
    height = svg.attr("height")

    color = d3.scaleOrdinal(d3.schemeCategory20)
    simulation = d3.forceSimulation()
                   .force("link", d3.forceLink().id((d) -> d.id).distance(200).strength(0.01))
                   .force("charge", d3.forceManyBody())
                   .force("center", d3.forceCenter(width / 2, height / 2))

    dragstarted = (d) ->
        if (!d3.event.active)
            simulation.alphaTarget(0.3).restart()

        d.fx = d.x
        d.fy = d.y

    dragged = (d) ->
        d.fx = d3.event.x
        d.fy = d3.event.y

    dragended = (d) ->
        if (!d3.event.active)
            simulation.alphaTarget(0)

        d.fx = null
        d.fy = null


    link = svg.append("g")
              .attr("class", "bgp-links")
              .selectAll("line")
              .data(graph.bgp_links)
              .enter().append("line")
              .attr("stroke-width", (d) -> Math.sqrt(d.value))

    node = svg.append("g")
              .attr("class", "nodes")
              .selectAll("circle")
              .data(graph.nodes)
              .enter().append("g")
              .call(d3.drag()
                      .on("start", dragstarted)
                      .on("drag", dragged)
                      .on("end", dragended))

    node.append("circle")
        .attr("r", 10)
        .attr("fill", (d) -> color(d.group))

    console.log(graph)

    node.append("title")
        .text((d) -> d.id)

    node.append("text")
        .attr("dx", 12)
        .attr("dy", ".35em")
        .text((d) -> d.id)

    node.append("text")
        .attr("dx", 12)
        .attr("dy", ".35em")
        .attr("y", 16)
        .text((d) -> "ip: #{d.ips}")

    ticked = () ->
        link.attr("x1", (d) -> d.source.x)
            .attr("y1", (d) -> d.source.y)
            .attr("x2", (d) -> d.target.x)
            .attr("y2", (d) -> d.target.y)

        node.attr("x1", (d) -> d.x)
            .attr("y1", (d) -> d.y)
            .attr("x2", (d) -> d.x)
            .attr("y2", (d) -> d.y)
            node.attr('transform', (d) -> "translate(#{d.x}, #{d.y})")

    simulation.nodes(graph.nodes).on("tick", ticked)

    simulation.force("link").links(graph.bgp_links)
