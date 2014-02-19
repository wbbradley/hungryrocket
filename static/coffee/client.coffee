class Server
  constructor: (props) ->
    @props = props

  connect: (host) =>
    console.log "Connecting..."

    fake_props =
      motd: 'Welcome'
    window.setTimeout((=> @connected(fake_props)), 0)

  connected: (server_props) =>
    console.log "Server connected"
    console.dir server_props

  login: =>
    console.log $('#username').val()
    server.set_name $('#username').val()

  set_name: =>
    # TODO(mrjaeger): call the server

  update_game_state: (game_state) =>
    console.dir game_state

server = new Server()
server.connect()

@Rocket = {}
@Rocket.login = server.login
