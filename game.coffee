_ = require 'lodash'
io = require 'socket.io'

pass = 'wtf?'


class Game

  constructor: ({@room, @rocket, @arena, @players}=opts or {})->
    @id = 'fuckleberry'
    @arena ?= new Arena
      radius: 1000
    @rocket ?= new Rocket
      angle: 0.0
      position:
        x: 0.0
        y: 0.0
    @players ?= []

    @maxPlayers = 4
    @inProgress = false
    @frameInterval = 35 # ms
    @frameTimer = null
    @state = null

  startGame: =>
    # initialize timer
    if @inProgress or @frameTimer
      throw 'Game has already started'

    @inProgress = true
    @frameTimer = setInterval(@publishFrameState, @frameInterval)

  calculateFrameState: =>
    # TODO: Sum player contributions
    # TODO: Apply to existing Rocket

    console.log 'Calculating frame state...'
    state =
      rocket:
        position:
          x: @rocket.position.X
          y: @rocket.position.Y
        angle: @rocket.angle
      players: []

    for player in @players
      state.players.push
        name: player.name
        score: player.score
        contribution: 0.0     # Current contribution delta
        rawContribution: 0.0  # Contribution input pre-scaling
        angle: 0.0            # Current intended angle
    return state
        
  publishFrameState: =>
    @state = @calculateFrameState()
    io.sockets.in(@id).emit(@state)

  registerPlayer: (player) =>
    if @players.length >= @maxPlayers
      throw 'Max number of players has already been reached'

    @players.push(player)
    player.score = 0.0

    # start game if we have enough players
    # if @players.length == @maxPlayers
    #   @startGame()


class Player
  constructor: ({@socket, @game, @name, @score}=opts) ->
    @score ?= 0

  updateContribution: (c) =>
    @contribution = c


class Rocket
  constructor: ({@position, @angle}=opts) ->


class Arena
  constructor: ({@radius}=opts) ->

  calculateSector: (x, y) ->
    # Return a player index for the play who owns the current sector


test = ->
  game = new Game()
  for player in ['Dave', 'Will', 'Andrew', 'Shlomo']
    p = new Player
      name: player
      game: game
    game.registerPlayer(p)
  return game


module.exports = {
    Game
    Player
    Rocket
    Arena
    test
}



