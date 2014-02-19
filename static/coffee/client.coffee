class Server
  constructor: (props) ->
    @props = props

  connect: (host) =>
    console.log "Connecting..."
    @socket = io.connect()
    @setupSocket()

  setupSocket: =>
    @socket.on 'connected', @connected

  connected: (data) =>
    console.log "Server connected"
    console.log data

  login: =>
    console.log $('#username').val()
    @set_name $('#username').val()

  set_name: (name) =>
    # optimistically set the local name
    console.log "calling server set-name with #{name}"
    gameboard.setState({username: name})
    console.log "calling server set-name with #{name}"
    @socket.emit 'set-name', name

  update_game_state: (game_state) =>
    console.dir game_state
    gameboard.setState({gamestate: name})

server = new Server()
server.connect()

@Rocket = {}
@Rocket.login = server.login
