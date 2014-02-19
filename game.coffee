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

  startGame: =>
    # initialize timer
    if @inProgress or @frameTimer
      throw 'Game has already started'

    @inProgress = true
    @frameTimer = setInterval(@tick, @frameInterval)

    @broadcast('startGame')

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

    # Test if rocket is out of bounds
    outOfBounds = @arena.rocketOutOfBounds(@rocket)

    # Sum player contributions
    maxAngle = Math.PI / 32
    angleDelta = 0.0
    for player in @players
      angleDelta += player.contribution * player.power * maxAngle

    # Update rocket angle based on summed player contributions
    @rocket.angle = (@rocket.angle + angleDelta) % (2 * Math.PI)

    # Calculate any bounces off the walls
    @rocket.angle = @arena.bounce(@rocket.position, @rocket.angle)

    # Find out which player's territory the rocket is over and award this
    # round's points to them
    scoringPlayerIdx = @arena.calculateSector(@rocket.position)
    scoringPlayer = @players[scoringPlayerIdx]
    if scoringPlayer
      scoringPlayer.score += @pointsPerFrame
        
  publishFrameState: =>
    @state = @fetchFrameState()
    @broadcast('updateGameState', @state)

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
    {@position, @angle, @velocity} = opts ? {}
    @position ?= {X: 0, Y: 0}
    @velocity ?= 1.0
    @angle = Math.random() * (2 * Math.PI)
    @radius ?= 2

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
    cos45 = sin45 = Math.cos(Math.PI/4)
    points = [
      [(rocket.X + rocket.radius), rocket.Y]
      [(rocket.X - rocket.radius), rocket.Y]
      [rocket.X, (rocket.Y + rocket.radius)]
      [rocket.X, (rocket.Y - rocket.radius)]
      [(rocket.X + rocket.radius*cos45), (rocket.Y + rocket.radius*sin45)]
      [(rocket.X - rocket.radius*cos45), (rocket.Y + rocket.radius*sin45)]
      [(rocket.X - rocket.radius*cos45), (rocket.Y - rocket.radius*sin45)]
      [(rocket.X + rocket.radius*cos45), (rocket.Y - rocket.radius*sin45)]
    ]

    outOfBounds = false
    for point in points:
      if (Math.pow(point[0], 2) + Math.pow(point[1], 2)) >= Math.pow(@radius, 2)
        outOfBounds = true
        break
    return outOfBounds     

  bounce: (position, angle) =>
    # Some vector calculations, based on http://stackoverflow.com/a/573206
    # Reversed rocket position is roughly perpendicular to the tangent vector
    # at the circle boundary as the rocket approaches
    n = Vector.create([-position.X, -position.Y])
    console.log "DIST: #{dist(n)}"
    if dist(n) < @radius
       return angle  # No bounce, we're still in-bounds
    console.log "n: #{n.e(1)}, #{n.e(2)}"
    v = angleToVec(angle)
    console.log "v: #{v.e(1)}, #{v.e(2)}"
  
    # find reflection given vector n
    u = n.multiply(v.dot(n) / n.dot(n))
    console.log "u: #{u.e(1)}, #{u.e(2)}"
    w = v.subtract(u)
    console.log "w: #{w.e(1)}, #{w.e(2)}"
    vNext = w.subtract(u)
    console.log "v': #{vNext.e(1)}, #{vNext.e(2)}"
    angleNext = angleFromVec(vNext)
    console.log('BOUNCE!')
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



