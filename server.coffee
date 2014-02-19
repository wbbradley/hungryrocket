express = require 'express'
port = 3000
app = express()
server = app.listen port
io = require('socket.io').listen server
games = require './game.coffee'

app.set 'views', (__dirname + '/views')
app.engine '.html', require('ejs').renderFile
app.use express.static(__dirname + '/static')

app.get('/', (req, res)=>
	res.render 'index.html'
)

game = new games.Game()

io.sockets.on('connection', (socket) =>
    player = new games.Player()
    socket.on 'join game', (data) ->
      game = '' # TODO: get game based on data
      socket.join game.id
      player.game = game
    socket.on 'set name', (data) ->
      # TODO: set player name
    player = new games.Player
      socket: socket
      game: game
    game.registerPlayer(player)
	socket.emit 'connected', {'hello': 'world'}

	socket.on 'set_name', (name)=>
		# set sockets player name as name
		# then broadcast name to to other players
)

console.log "Listening on port #{port}"
