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

players = {}
gamesMap = {}
game = new games.Game
  sockets: io.sockets
  name: 'Test Game'
gamesMap[game.id] = game

io.sockets.on 'connection', (socket) =>
  console.log "Connection established"

  player = new games.Player()
  player.socket = socket

  socket.on 'set-name', (name) ->
    # TODO: rework this, it sucks
    console.log "set name called with #{name}"
    if players[name]
      player = players[name]
    else
      player.name = name
      player[name] = player

    # For now, immediately join a game
    try
      game.registerPlayer(player)
    catch error
      console.log "Failed to register player: #{name}"
      return
    socket.join(game.id)
    socket.player = player
    player.socket = socket
    player.game = game

  socket.on 'update-input', (input) ->
    player.updateContribution(input)


  socket.on 'reset-game', (opts) ->
    {id} = opts
    game = gamesMap[id]
    game.reset()
  socket.emit 'connected', {'hello': 'world'}

console.log "Listening on port #{port}"
