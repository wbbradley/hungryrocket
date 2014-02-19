(function() {
  var Server, server,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

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
      return this.socket.on('connected', this.connected);
    };

    Server.prototype.connected = function(data) {
      console.log("Server connected");
      return console.log(data);
    };

    Server.prototype.login = function() {
      console.log($('#username').val());
      return this.set_name($('#username').val());
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
      return gameboard.setState({
        gamestate: name
      });
    };

    return Server;

  })();

  server = new Server();

  server.connect();

  this.Rocket = {};

  this.Rocket.login = server.login;

}).call(this);
