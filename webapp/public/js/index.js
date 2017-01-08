(function() {
  var ping, socket;

  console.log('hello9');

  socket = io.connect("http://" + host + ":35730");

  socket.on('connect', function() {
    console.log('connected');
    socket.on('msg push', function(msg) {
      return console.log(msg);
    });
    socket.on('update network', function(data) {
      return console.log(data);
    });
    socket.emit('msg send', 'hello');
    return socket.emit('update network');
  });

  ping = function() {
    var text;
    text = document.getElementById("text").value;
    return socket.emit('msg send', text);
  };

}).call(this);
