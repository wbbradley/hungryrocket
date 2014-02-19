(function() {
  var Server, globals, server,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  globals = {
    viewport: {
      width: 400,
      height: 400
    }
  };

  Server = (function() {
    function Server(props) {
      this.update_game_state = __bind(this.update_game_state, this);
      this.set_name = __bind(this.set_name, this);
      this.login = __bind(this.login, this);
      this.connected = __bind(this.connected, this);
      this.setupSocket = __bind(this.setupSocket, this);
      this.connect = __bind(this.connect, this);
      this.props = props;
    }

    Server.prototype.connect = function(host) {
      console.log("Connecting...");
      this.socket = io.connect();
      return this.setupSocket();
    };

    Server.prototype.setupSocket = function() {
      this.socket.on('connected', this.connected);
      return this.socket.on('update-game-state', this.update_game_state);
    };

    Server.prototype.connected = function(data) {
      console.log("Server connected");
      return console.log(data);
    };

    Server.prototype.login = function() {
      var username;
      username = $('#username').val();
      return this.set_name(username);
    };

    Server.prototype.set_name = function(name) {
      console.log("calling server set-name with " + name);
      gameboard.setState({
        username: name
      });
      console.log("calling server set-name with " + name);
      return this.socket.emit('set-name', name);
    };

    Server.prototype.update_game_state = function(game_state) {
      console.dir(game_state);
      return gameboard.setState(game_state);
    };

    return Server;

  })();

  server = new Server();

  server.connect();

  this.Rocket = {};

  this.Rocket.login = server.login;

  this.Rocket.globals = globals;

}).call(this);
