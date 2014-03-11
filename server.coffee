express = require 'express'
port = 3000
app = express()
server = app.listen(port, '0.0.0.0')
io = require('socket.io').listen server
games = require './game.coffee'

app.set 'views', (__dirname + '/views')
app.engine '.html', require('ejs').renderFile
app.use express.static(__dirname + '/static')

players = {}
gamesMap = {}

app.get('/', (req, res)=>
  roomID = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c)=>
    r = (Math.random() * 16|0)
    v = (if c == 'x' then r else (r & 0x3|0x8))
    v.toString 16
  )
  res.redirect "/game/#{roomID}"
)

app.get('/game/:gameID', (req, res)=>
  gameID = req.params.gameID
  gamesMap[gameID] ?= new games.Game(io.sockets, gameID)
  res.render 'index.html'
)

io.sockets.on 'connection', (socket) =>
  console.log "Connection established"

  player = new games.Player()
  player.socket = socket

  socket.on 'set-name', (name, gameID)=>
    # TODO: rework this, it sucks
    console.log "set name called with #{name}"
    if players[name]
      player = players[name]
    else
      player.name = name
      players[name] = player

    game = gamesMap[gameID]
    try
      game.registerPlayer(player)
    catch error
      console.log "Failed to register player: #{name}"
      return

    socket.join game.id
    socket.player = player
    player.socket = socket
    player.game = game
    game.publishFrameState()

  socket.on 'update-input', (input)=>
    player.updateContribution(input)

  socket.on 'reset-game', (opts)=>
    {id} = opts
    console.log "Resetting game: #{id}"
    gamesMap[id]?.reset()

  socket.emit 'connected', {'welcome': 'Hungry Rocket 0.1.0'}

console.log "Listening on port #{port}"
