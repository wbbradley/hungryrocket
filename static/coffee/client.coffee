globals =
	viewport:
		width: 400
		height: 400

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
    @socket.emit 'reset-game', {id: gameboard.state?.game?.id?}

  login: =>
    username = $('#username').val()
    @set_name username

  set_name: (name) =>
    gameboard.setState({username: name})
    @socket.emit 'set-name', name

  update_game_state: (game_state) =>
    gameboard.setState(game_state)

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

  $('#slider').click((event)=>
    offsetX = event.offsetX
    middle = $(this).width() / 2
    new_angle = ((offsetX - middle) / middle)

    indicator_width = 20
    left = offsetX - (indicator_width / 2)
    indicator = $ "<div id='indicator'></div>"
    indicator.css 'left', "#{left}px"

    if $('#indicator').length
      $('#indicator').css 'left', "#{left}px"
    else
      $('#slider').append indicator

    server.socket.emit 'update-input', new_angle
  )

  # another way
  left_interval = null
  left_degrees = 0

  $('#go-left').on 'mousedown', ()=>
    if not left_interval
      left_degrees += 0.1 
      left_interval = setInterval(()=>
        if left_degrees < 1
          left_degrees += -0.1
        server.socket.emit 'update-input', left_degrees
      , 100)
      server.socket.emit 'update-input', left_degrees

  $('#go-left').on 'mouseup', ()=>
    if left_interval
      clearInterval left_interval
      left_interval = null
      left_degrees = 0
      server.socket.emit 'update-input', left_degrees

  right_interval = null
  right_degrees = 0

  $('#go-right').on 'mousedown', ()=>
    if not right_interval
      right_degrees -= 0.1 
      right_interval = setInterval(()=>
        if right_degrees > -1
          right_degrees -= -0.1
        server.socket.emit 'update-input', right_degrees
      , 100)
      server.socket.emit 'update-input', right_degrees

  $('#go-right').on 'mouseup', ()=>
    if right_interval
      clearInterval right_interval
      right_interval = null
      right_degrees = 0
      server.socket.emit 'update-input', right_degrees
