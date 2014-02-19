gameboard = null
Gameboard = React.createClass
  getInitialState: ->
    username: null
    gamestate: null
    arena:
      radius: 1000
    rocket:
      position:
        X: 0
        Y: 0

  arenaViewBox: ->
    arena = @state.arena
    return "#{-arena.radius} #{-arena.radius} #{arena.radius * 2} #{arena.radius * 2}"

  render: ->
    {h1, div, svg, rect, g, ul, li, form, input, button} = React.DOM

    return (div {}, [
      (h1 {}, ['ello' + @state.username])
      (svg {xmlns:"http://www.w3.org/2000/svg", width:Rocket.globals.viewport.width, height:Rocket.globals.viewport.height, viewBox:@arenaViewBox()}, [
        (rect {width:100, height:200, x:@state.rocket.position.X, y:@state.rocket.position.Y, fill:"#008d46"})
        (rect {width:100, height:200, x:1, fill:"#fff"})
        (rect {width:100, height:200, x:2, fill:"#d2232c"})
      ])
    ])


gameboard = Gameboard({globals: Rocket.globals})
"""
test_update = ->
  timestamp = (new Date()).getTime() / 1000.0
  gameboard.setState
    rocket:
      position:
        X: Math.cos(timestamp) * 200
        Y: Math.sin(timestamp) * 200

window.setInterval test_update, 50
"""
React.renderComponent(gameboard, document.getElementById('gameboard'))

this.gameboard = gameboard
