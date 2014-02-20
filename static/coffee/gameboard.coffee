gameboard = null
Gameboard = React.createClass
  getInitialState: ->
    username: null
    gamestate: null
    arena:
      radius: 1000
    rocket:
      radius:
        75
      position:
        X: 0
        Y: 0

  arenaViewBox: ->
    arena = @state.arena
    return "#{-arena.radius} #{-arena.radius} #{arena.radius * 2} #{arena.radius * 2}"

  render: ->
    {h1, div, svg, rect, g, ul, li, form, input, button, img, circle} = React.DOM

    return (div {}, [
      (h1 {}, ['ello' + @state.username])
      (div {
        style: {position:'relative'},
        width: Rocket.globals.viewport.width,
        height: Rocket.globals.viewport.height}, [
        (svg {xmlns:"http://www.w3.org/2000/svg", width:'100%', height:'100%', viewBox:@arenaViewBox()}, [
          (circle {r:@state.arena.radius, cx:0, cy:0, fill:"#f0fdf6"})
          (circle {r:@state.rocket.radius, cx:@state.rocket.position.X - 50, cy:@state.rocket.position.Y - 50, fill:"#008d46"})
        ])
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
