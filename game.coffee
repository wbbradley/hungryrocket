_ = require 'lodash'

pass = 'wtf?'


class Game

  constructor: ->
    @arena = new Arena
      radius: 1000
    @rocket = new Rocket
      position: @initialRocketPosition()
      angle: @initialRocketAngle()
    @players = []

    @maxPlayers = 4
    @inProgress = false
    @frameInterval = 35 # ms
    @frameTimer = null
    @state = null
    @playerContributions = {}

  initialRocketPosition: -> [0.0, 0.0]
  initialRocketAngle: -> 0.0

  startGame: =>
    # initialize timer
    if @inProgress or @frameTimer
      throw 'Game has already started'

    @inProgress = true
    @frameTimer = setInterval(@publishFrameState, @frameInterval)

  calculateFrameState: =>
    # Sum player contributions
    # Apply to existing Rocket
    console.log 'Calculating frame state...'

  publishFrameState: =>
    @state = @calculateFrameState()
    # TODO: push to socket for each player

  updatePlayerContribution: (player, contribution) =>
    @playerContributions[player.name] = contribution

  registerPlayer: (player) =>
    if @players.length >= @maxPlayers
      throw 'Max number of players has already been reached'

    @players.push(player)
    @updatePlayerContribution(player, 0.0)

    # start game if we have enough players
    # if @players.length == @maxPlayers
    #   @startGame()


class Player
  constructor: ({@connection, @game, @name}=opts) ->

  updateContribution: (c) =>
    @game.updatePlayerContribution(@, c)


class Rocket
  constructor: ({@position, @angle}=opts) ->


class Arena
  constructor: ({@radius}=opts) ->


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



