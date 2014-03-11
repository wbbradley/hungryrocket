{h1, div, svg, rect, text, g, ul, li, form, input, button, img, circle, line} = React.DOM

globalHeight = ''
gameboard = null
Gameboard = React.createClass
  getDefaultProps: ->
    username: null
    players: []
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
    arena = @props.arena
    return "#{-arena.radius} #{-arena.radius} #{arena.radius * 2} #{arena.radius * 2}"

  render: ->
    labels = []
    if @props.players?
      for player, idx in @props.players
        angle = (idx + 0.5) * 2 * Math.PI / @props.players.length
        timestamp = (new Date()).getTime() / 1000.0
        labels.push(
          (text {
            key: idx
            x: @props.arena.radius * .75 * Math.cos(angle)
            y: @props.arena.radius * .75 * Math.sin(angle)
            className: 'score'
          }, player.name)
        )
    return (div {}, [
      if props?.username? then (h1 {}, ["'ello guvna #{@props.username}"]) else null
      (div {
        style:
          position: 'relative'
          width: '100%'
          height: "#{globalHeight}px"
          display: 'inline-block'
        }, [
        (svg {xmlns:"http://www.w3.org/2000/svg", width:'100%', height:'100%', viewBox:@arenaViewBox()}, [
          (circle {r:@props.arena.radius, cx:0, cy:0, fill:"#f0fdf6"})
          (line {
            x1: @props.rocket.position.X,
            y1: @props.rocket.position.Y,
            x2: @props.rocket.position.X + (Math.cos(@props.rocket.angle + Math.PI) * @props.rocket.radius * 1.5),
            y2: @props.rocket.position.Y + (Math.sin(@props.rocket.angle + Math.PI) * @props.rocket.radius * 1.5),
            stroke: "orange"
            strokeWidth: 50
            fill:"#008d46"
          })
          (circle {
            r: @props.rocket.radius
            cx: @props.rocket.position.X
            cy: @props.rocket.position.Y
            fill: "#008d46"
          })
        ].concat(labels)
        )
      ])
    ])


gameboard = Gameboard({globals: Rocket.globals})
"""
test_update = ->
  timestamp = (new Date()).getTime() / 1000.0
  gameboard.setprops
    rocket:
      position:
        X: Math.cos(timestamp) * 200
        Y: Math.sin(timestamp) * 200

window.setInterval test_update, 50
"""
$ =>
  globalHeight = $(document).height() - $('#slider').height() - $('#login').height() - 100
  React.renderComponent(gameboard, document.getElementById('gameboard'))
  this.gameboard = gameboard
