console.log 'hello9'

socket = io.connect("http://#{host}:35730")

socket.on('connect', () ->
  console.log('connected')

  socket.on('msg push', (msg) ->
    console.log(msg)
  )

  socket.on('update network', (data) ->
    console.log(data)
    data = JSON.parse(data)

    render_network(data)
  )

  socket.emit('msg send', 'hello')
  socket.emit('update network')
)

ping = () ->
  text = document.getElementById("text").value
  socket.emit('msg send', text)
