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

  login: =>
    username = $('#username').val()
    @set_name username

  set_name: (name) =>
    # optimistically set the local name
    console.log "calling server set-name with #{name}"
    gameboard.setState({username: name})
    console.log "calling server set-name with #{name}"
    @socket.emit 'set-name', name

  update_game_state: (game_state) =>
    # console.dir game_state
    gameboard.setState(game_state)

server = new Server()
server.connect()

@Rocket = {}
@Rocket.login = server.login
@Rocket.globals = globals

$ =>
  center_line = $("<div id='center_line'></div>")
  center_line.css 'left', "#{($('#slider').width() / 2)}px"
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
