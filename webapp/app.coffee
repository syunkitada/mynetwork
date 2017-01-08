express = require('express')
app = express()
 
app.set('views', './views')
app.set('view engine', 'ejs')
 
app.use('/public', express.static('public'))
app.use('/', require('./routes/index.coffee'))
 
app.listen(8080)
 
console.log('Server running at http://0.0.0.0:8080')


exec = require('child_process').exec
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
    exec 'ip netns', (err, stdout, stderr)->
      socket.emit('update network', stdout)
  )

  socket.on('disconnect', () ->
    console.log('disconnected')
    return
  )

  return
)

console.log('Server running at http://0.0.0.0:35730')
