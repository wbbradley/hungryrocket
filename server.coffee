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

game = new games.Game
  sockets: io.sockets

io.sockets.on('connection', (socket) =>
    player = new games.Player()
    player.socket = socket

    socket.on 'join game', (data) ->
      game = '' # TODO: get game based on data
      game.registerPlayer(player)
      socket.join(game.id)
      socket.player = player
      player.game = game

    socket.on 'set name', (name) ->
      player.name = name
	  # TODO: broadcast name to to other players?

    socket.on 'update input', (input) ->
      player.updateContribution(input)

	socket.emit 'connected', {'hello': 'world'}
)

console.log "Listening on port #{port}"
