express = require('express')
app = express()
 
app.set('views', './views')
app.set('view engine', 'ejs')
 
app.use('/public', express.static('public'))
app.use('/', require('./routes/index.coffee'))
 
app.listen(8080)
 
console.log('Server running at http://0.0.0.0:8080')

child_process = require('child_process')
exec = child_process.exec
execSync = child_process.execSync
http = require('http')

socket_app = http.createServer().listen(35730)
io = require('socket.io').listen(socket_app)

io.sockets.on('connection', (socket) ->
  console.log('connected')

  socket.on('msg send', (msg) ->
    socket.emit('msg push', msg)
    socket.broadcast.emit('msg push', msg)
    return
  )

  socket.on('update network', () ->
    console.log 'update network'

    data = {}

    nodes = []
    bgp_links = []

    veth_pare_map = {}
    bridge_map = {}
    iplink_show = execSync "ip link show | grep veth | awk '{print $2$9}'", {encoding: 'utf8'}
    for iplink in iplink_show.split('\n')
      if iplink.length == 0
        continue

      tmp = iplink.split('@')
      veth = tmp[0]
      tmp = tmp[1].split(':')
      veth_pare = tmp[0].split('if')[1]
      bridge = tmp[1]
      veth_pare_map[veth_pare] = bridge
      if bridge not of bridge_map
        bridge_map[bridge] = {}
        nodes.push({
          'id': bridge,
          'ips': [],
          'group': 1,
          'established_ips': [],
        })

    ip_id_map = {}
    node_group = 3
    ipnetns = execSync "ip netns | awk '{print $1}'", {encoding: 'utf8'}
    for netns in ipnetns.split('\n')
      console.log "netns: #{netns}"
      if netns.length == 0
        continue
      node_group += 1

      ips = []
      result = execSync "ip netns exec #{netns} ip a | grep ' inet ' | awk '{print $2}'", {encoding: 'utf8'}
      for ip in result.split('\n')
        if ip.length == 0 or ip == '127.0.0.1/8'
          continue
        ips.push(ip)

      result = execSync "ip netns exec #{netns} ip a | grep veth | grep @if | awk '{print $1$2}'", {encoding: 'utf8'}
      for veth in result.split('\n')
        console.log(veth)
        if veth.length == 0
          continue

        tmp = veth.split(':')
        veth_id = tmp[0]
        bgp_links.push({
          'source': netns,
          'target': veth_pare_map[veth_id],
          'value': 1,
        })


      established_ips = []
      result = execSync "ip netns exec #{netns} netstat -an | grep ESTABLISHED | awk '{print $5}'", {encoding: 'utf8'}
      for esta in result.split('\n')
        if esta.length == 0
          continue
        established_ips.push(esta)

      for ip in ips
        ip_id_map[ip.split('/')[0]] = netns

      nodes.push({
        'id': netns,
        'group': node_group,
        'ips': ips,
        'established_ips': established_ips,
      })

    for node in nodes
      for ip in node.established_ips
        splited_ip = ip.split(':')
        if splited_ip[1] == '179'
            bgp_links.push({
              'source': ip_id_map[splited_ip[0]],
              'target': node.id,
              'value': 10,
            })

    data = {'nodes': nodes, 'bgp_links': bgp_links}

    socket.emit('update network', JSON.stringify(data))
  )

  socket.on('disconnect', () ->
    console.log('disconnected')
    return
  )

  return
)

console.log('Server running at http://0.0.0.0:35730')
