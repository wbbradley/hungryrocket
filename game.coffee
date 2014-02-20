_ = require 'lodash'
Sylvester = require 'sylvester'
Vector = Sylvester.Vector


class Game

  constructor: (opts)->
    {@sockets, @rocket, @arena, @players} = opts ? {}
    @id = 'uuid'
    @arena ?= new Arena
      radius: 1000
    @rocket ?= new Rocket
      angle: 0.0
      position:
        X: 0.0
        Y: 0.0
    @players ?= []

    @maxPlayers = 1
    @inProgress = false
    @frameInterval = 35 # ms
    @frameTimer = null
    @state = null
    @pointsPerFrame = 100

  broadcast: (type, data) =>
    console.log "Broadcast: #{type}: #{JSON.stringify(data)}"
    @sockets.in(@id).emit(type, data)

  reset: =>
    @broadcast('game-reset')
    for client in @sockets.clients(@id)
      client.leave(@id)
    @players = []
    @inProgress = false
    @state = null 
    clearInterval(@frameTimer)
    @frameTimer = null

  startGame: =>
    # initialize timer
    if @inProgress or @frameTimer
      throw 'Game has already started'

    @inProgress = true
    @frameTimer = setInterval(@tick, @frameInterval)

    @broadcast('start-game')

  fetchFrameState: =>
    state =
      game:
        id: @id
        inProgress: @inProgress
      arena:
        radius: @arena.radius
      rocket:
        position:
          X: @rocket.position.X
          Y: @rocket.position.Y
        angle: @rocket.angle
        radius: @rocket.radius
      players: []

    for player in @players
      state.players.push
        name: player.name
        score: player.score
        contribution: player.contribution * player.power
        rawContribution: player.contribution
        angle: 0.0            # Current intended angle

    return state

  updateFrameState: =>
    # Move rocket along existing heading based on velocity
    xDelta = Math.cos(@rocket.angle) * @rocket.velocity
    yDelta = Math.sin(@rocket.angle) * @rocket.velocity
    @rocket.position.X = @rocket.position.X + xDelta
    @rocket.position.Y = @rocket.position.Y + yDelta

    # Sum player contributions
    maxAngle = Math.PI / 32
    angleDelta = 0.0
    for player in @players
      angleDelta += player.contribution * player.power * maxAngle

    # Update rocket angle based on summed player contributions
    @rocket.angle = (@rocket.angle + angleDelta) % (2 * Math.PI)

    # Calculate any bounces off the walls
    @rocket.angle = @arena.bounce(@rocket)

    # Find out which player's territory the rocket is over and award this
    # round's points to them
    scoringPlayerIdx = @arena.calculateSector(@rocket.position)
    scoringPlayer = @players[scoringPlayerIdx]
    if scoringPlayer
      scoringPlayer.score += @pointsPerFrame
        
  publishFrameState: =>
    @state = @fetchFrameState()
    @broadcast('update-game-state', @state)

  tick: =>
    @updateFrameState()
    @publishFrameState()

  registerPlayer: (player) =>
    if @players.length >= @maxPlayers
      throw 'Max number of players has already been reached'

    @players.push(player)
    player.score = 0.0

    # start game if we have enough players
    if @players.length == @maxPlayers
      @startGame()


class Player
  constructor: (opts) ->
    {@socket, @game, @name} = opts ? {}
    @contribution = 0.0
    @score = 0
    @power = 1.0

  updateContribution: (c) =>
    @contribution = c


class Rocket
  constructor: (opts) ->
    {@position, @angle, @velocity, @radius} = opts ? {}
    @position ?= {X: 0, Y: 0}
    @velocity ?= 10.0
    @radius ?= 50
    @angle = Math.random() * (2 * Math.PI)

  toString: =>
    JSON.stringify
      angle: @angle
      position: @position
      velocity: @velocity


class Arena
  constructor: (opts) ->
    {@radius} = opts ? {}

  calculateSector: (position) ->
    # Return a player index for the play who owns the current sector
    {X, Y} = position
    switch
      when X < 0 and Y >= 0 then 0
      when X >= 0 and Y >= 0 then 1
      when X < 0 and Y < 0 then 2
      when X >= 0 and Y < 0 then 3

  # IMPORTANT: Assumes rocket is a circle
  rocketOutOfBounds: (rocket)->
    return (Math.pow(rocket.position.X, 2) + Math.pow(rocket.position.Y, 2)) > Math.pow((@radius - rocket.radius), 2)

  bounce: (rocket) =>
    # Some vector calculations, based on http://stackoverflow.com/a/573206
    # Reversed rocket position is roughly perpendicular to the tangent vector
    # at the circle boundary as the rocket approaches
    n = Vector.create([-rocket.position.X, -rocket.position.Y])
    if not @rocketOutOfBounds(rocket)
       return rocket.angle  # No bounce, we're still in-bounds
    v = angleToVec(rocket.angle)
  
    # find reflection given vector n
    u = n.multiply(v.dot(n) / n.dot(n))
    w = v.subtract(u)
    vNext = w.subtract(u)
    angleNext = angleFromVec(vNext)
    return angleNext


# dot = (v1, v2) -> (v1.X * v2.X) + (v1.Y * v2.Y) */
# subtractVecs(v1, v2) -> {X: v1.X - v2.X, Y: v1.Y - v2.Y}
# scaleVec(v1, scale) -> {X: v1.X * scale, Y: v1.Y * scale}
dist = (v) -> Math.sqrt(Math.pow(v.e(1), 2) + Math.pow(v.e(2), 2))
angleToVec = (angle) -> Vector.create([Math.cos(angle), Math.sin(angle)])
angleFromVec = (v) -> Math.atan2(v.e(2), v.e(1))

test = ->
  express = require 'express'
  port = 3000
  app = express()
  server = app.listen(port)
  io = require('socket.io').listen(server)

  game = new Game
    sockets: io.sockets
  for player in ['Dave', 'Will', 'Andrew', 'Shlomo']
    p = new Player
      name: player
      game: game
    game.registerPlayer(p)
    # p.updateContribution(1.0)
  return game


module.exports = {
    Game
    Player
    Rocket
    Arena
    test
}



