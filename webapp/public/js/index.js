(function() {
  var ping, render_network, socket;

  console.log('hello9');

  socket = io.connect("http://" + host + ":35730");

  socket.on('connect', function() {
    console.log('connected');
    socket.on('msg push', function(msg) {
      return console.log(msg);
    });
    socket.on('update network', function(data) {
      console.log(data);
      data = JSON.parse(data);
      return render_network(data);
    });
    socket.emit('msg send', 'hello');
    return socket.emit('update network');
  });

  ping = function() {
    var text;
    text = document.getElementById("text").value;
    return socket.emit('msg send', text);
  };

  render_network = function(graph) {
    var color, dragended, dragged, dragstarted, height, link, node, simulation, svg, ticked, width;
    $('#network-panel').html('<svg id="network-svg" width="1000" height="600"></svg>');
    svg = d3.select('#network-svg');
    width = svg.attr("width");
    height = svg.attr("height");
    color = d3.scaleOrdinal(d3.schemeCategory20);
    simulation = d3.forceSimulation().force("link", d3.forceLink().id(function(d) {
      return d.id;
    }).distance(200).strength(0.01)).force("charge", d3.forceManyBody()).force("center", d3.forceCenter(width / 2, height / 2));
    dragstarted = function(d) {
      if (!d3.event.active) {
        simulation.alphaTarget(0.3).restart();
      }
      d.fx = d.x;
      return d.fy = d.y;
    };
    dragged = function(d) {
      d.fx = d3.event.x;
      return d.fy = d3.event.y;
    };
    dragended = function(d) {
      if (!d3.event.active) {
        simulation.alphaTarget(0);
      }
      d.fx = null;
      return d.fy = null;
    };
    link = svg.append("g").attr("class", "bgp-links").selectAll("line").data(graph.bgp_links).enter().append("line").attr("stroke-width", function(d) {
      return Math.sqrt(d.value);
    });
    node = svg.append("g").attr("class", "nodes").selectAll("circle").data(graph.nodes).enter().append("g").call(d3.drag().on("start", dragstarted).on("drag", dragged).on("end", dragended));
    node.append("circle").attr("r", 10).attr("fill", function(d) {
      return color(d.group);
    });
    console.log(graph);
    node.append("title").text(function(d) {
      return d.id;
    });
    node.append("text").attr("dx", 12).attr("dy", ".35em").text(function(d) {
      return d.id;
    });
    node.append("text").attr("dx", 12).attr("dy", ".35em").attr("y", 16).text(function(d) {
      return "ip: " + d.ips;
    });
    ticked = function() {
      link.attr("x1", function(d) {
        return d.source.x;
      }).attr("y1", function(d) {
        return d.source.y;
      }).attr("x2", function(d) {
        return d.target.x;
      }).attr("y2", function(d) {
        return d.target.y;
      });
      node.attr("x1", function(d) {
        return d.x;
      }).attr("y1", function(d) {
        return d.y;
      }).attr("x2", function(d) {
        return d.x;
      }).attr("y2", function(d) {
        return d.y;
      });
      return node.attr('transform', function(d) {
        return "translate(" + d.x + ", " + d.y + ")";
      });
    };
    simulation.nodes(graph.nodes).on("tick", ticked);
    return simulation.force("link").links(graph.bgp_links);
  };

}).call(this);
