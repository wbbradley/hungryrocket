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
    @socket.emit 'set-name', name, @props.gameID

  update_game_state: (game_state) =>
    gameboard.setProps game_state

server = new Server
  gameID: window.location.pathname.split('/')[2]
server.connect()

@Rocket = {}
@Rocket.login = server.login
@Rocket.reset = server.reset

$ =>
  slider = $('#slider')

  center_line = $("<div id='center_line'></div>")
  center_line.css 'left', "50%"
  slider.append center_line

  indicator = $ "<div id='indicator'></div>"
  slider.append indicator
  indicator.css 'left', "#{(slider.width() - indicator.width())/2}px"

  slider_interval = slider.width() / 60
  angle = 0
  slide = false

  calcNumPx = (leftPx)=>
    Number(leftPx.slice(0, (leftPx.length - 2)))

  setAngle = (offsetX)=>
    middle = (slider.width() - indicator.width()) / 2
    angle = ((offsetX - middle) / middle)

  setInterval(=>
    server.socket.emit 'update-input', angle
  , 35)

  $(document).on 'keydown', (event)=>
    left = calcNumPx indicator.css('left')
    if event.keyCode == 37
      indicator.css 'left', "#{(left - slider_interval)}px"
    else if event.keyCode == 39
      indicator.css 'left', "#{(left + slider_interval)}px"
    setAngle calcNumPx indicator.css('left')

  slider.on 'mousemove', (event)=>
    if slide and event.target.id == 'slider'
      setAngle event.offsetX
      left = event.offsetX - (indicator.width() / 2)
      indicator.css 'left', "#{left}px"

  slider.on 'mousedown', (event)=>
    if not slide
      slide = true
      setAngle event.offsetX
      left = event.offsetX - (indicator.width() / 2)
      indicator.css 'left', "#{left}px"

  slider.on 'mouseup', =>
    slide = false
