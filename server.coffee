express = require 'express'
port = 3000
app = express()
server = app.listen port
io = require('socket.io').listen server
room = 'the one'

app.set 'views', (__dirname + '/views')
app.engine '.html', require('ejs').renderFile
app.use express.static(__dirname + '/static')

app.get('/', (req, res)=>
	res.render 'index.html'
)

io.sockets.on('connection', (socket)=>
	socket.join room
	socket.emit 'connected', {'hello': 'world'}

	socket.on 'set_name', (name)=>
		# set sockets player name as name
		# then broadcast name to to other players
)

console.log "Listening on port #{port}"