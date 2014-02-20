{h1, div, svg, rect, text, g, ul, li, form, input, button, img, circle, line} = React.DOM

gameboard = null
Gameboard = React.createClass
  getInitialState: ->
    username: null
    gamestate: null
    arena:
      radius: 1000
    rocket:
      angle: 0
      radius:
        75
      position:
        X: 0
        Y: 0

  arenaViewBox: ->
    arena = @state.arena
    return "#{-arena.radius} #{-arena.radius} #{arena.radius * 2} #{arena.radius * 2}"

  render: ->
    labels = []
    if @state.players?
      for player, idx in @state.players
        angle = (idx + 0.5) * 2 * Math.PI / @state.players.length
        labels.push(
          (text {
            x: @state.arena.radius * .75 * Math.cos(angle)
            y: @state.arena.radius * .75 * Math.sin(angle)
            className: 'score'
          }, "#{player.name}")
        )

    return (div {}, [
      (h1 {}, ['ello' + @state.username])
      (div {
        style: {position:'relative'},
        width: Rocket.globals.viewport.width,
        height: Rocket.globals.viewport.height}, [
        (svg {xmlns:"http://www.w3.org/2000/svg", width:'100%', height:'100%', viewBox:@arenaViewBox()}, [
          (circle {r:@state.arena.radius, cx:0, cy:0, fill:"#f0fdf6"})
          (line {
            x1:@state.rocket.position.X,
            y1:@state.rocket.position.Y,
            x2:@state.rocket.position.X + (Math.cos(@state.rocket.angle + Math.PI) * @state.rocket.radius * 1.5),
            y2:@state.rocket.position.Y + (Math.sin(@state.rocket.angle + Math.PI) * @state.rocket.radius * 1.5),
            stroke: "orange"
            strokeWidth:50
            fill:"#008d46"
          })
          (circle {r:@state.rocket.radius, cx:@state.rocket.position.X, cy:@state.rocket.position.Y, fill:"#008d46"})
        ].concat(labels)
        )
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
