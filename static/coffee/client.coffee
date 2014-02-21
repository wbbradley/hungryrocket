globals =
	viewport:
		width: '320px'
		height: '320px'

class Server
  constructor: (props) ->
    @props = props

  connect: (host) =>
    console.log "Connecting..."
    @socket = io.connect()
    @setupSocket()

  setupSocket: =>
    @socket.on 'connected', @connected
    @socket.on 'update-game-state', @update_game_state

  connected: (data) =>
    console.log "Server connected"
    console.log data

  reset: =>
    game = gameboard.props?.game
    if game
      @socket.emit 'reset-game', {id: game.id}

  login: =>
    username = $('#username').val()
    @set_name username

  set_name: (name) =>
    gameboard.setProps({username: name})
    @socket.emit 'set-name', name

  update_game_state: (game_state) =>
    gameboard.setProps game_state

server = new Server()
server.connect()

@Rocket = {}
@Rocket.login = server.login
@Rocket.reset = server.reset
@Rocket.globals = globals

$ =>
  # one way
  center_line = $("<div id='center_line'></div>")
  center_line.css 'left', "50%"
  $('#slider').append center_line

  slider_interval = null
  angle = 0
  slide = false

  calcAngle = (offsetX, width)->
    middle = width / 2
    ((offsetX - middle) / middle)

  setInterval(()=>
    server.socket.emit 'update-input', angle
  , 35)

  $('#slider').on 'mousemove', (event)=>
    if slide and event.target.id == 'slider'
      indicator = $('#indicator')
      angle = calcAngle(event.offsetX, $(this).width())

      left = event.offsetX - (indicator.width() / 2)
      indicator.css 'left', "#{left}px"

  $('#slider').on 'mousedown', (event)=>
    if not slide
      $('#indicator').remove()
      slide = true
      angle = calcAngle(event.offsetX, $(this).width())

      indicator = $ "<div id='indicator'></div>"
      $('#slider').append indicator
      left = event.offsetX - (indicator.width() / 2)
      indicator.css 'left', "#{left}px"

  $('#slider').on 'mouseup', (event)=>
    slide = false
