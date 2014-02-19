express = require 'express'
port = 3000
app = express().listen port
io = require('socket.io').listen app

app.set 'views', (__dirname + '/views')
app.engine '.html', require('ejs').renderFile
app.use express.static(__dirname + '/static')

app.get('/', (req, res)->
	res.render 'index.html'
)

io.sockets.on('connection', (socket)->
	# DO STUFF
)

console.log "Listening on port #{port}"