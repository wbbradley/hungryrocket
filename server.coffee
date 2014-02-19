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

players = {}

io.sockets.on('connection', (socket) =>
  console.log "Connection established"

  player = new games.Player()
  player.socket = socket

  socket.on 'set-name', (name) ->
    console.log "set name called with #{name}"
    if players[name]
      player = players[name]
      player.socket = socket
    else
      player.name = name

    # For now, immediately join a game
    game.registerPlayer(player)
    socket.join(game.id)
    socket.player = player
    player.socket = socket
    player.game = game

  socket.on 'update-input', (input) ->
    player.updateContribution(input)

  socket.emit 'connected', {'hello': 'world'}
)

console.log "Listening on port #{port}"
