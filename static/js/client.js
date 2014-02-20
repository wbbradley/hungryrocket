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
      this.reset = __bind(this.reset, this);
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

    Server.prototype.reset = function() {
      var _ref, _ref1;
      return this.socket.emit('reset-game', {
        id: ((_ref = gameboard.state) != null ? (_ref1 = _ref.game) != null ? _ref1.id : void 0 : void 0) != null
      });
    };

    Server.prototype.login = function() {
      var username;
      username = $('#username').val();
      return this.set_name(username);
    };

    Server.prototype.set_name = function(name) {
      gameboard.setState({
        username: name
      });
      return this.socket.emit('set-name', name);
    };

    Server.prototype.update_game_state = function(game_state) {
      return gameboard.setState(game_state);
    };

    return Server;

  })();

  server = new Server();

  server.connect();

  this.Rocket = {};

  this.Rocket.login = server.login;

  this.Rocket.reset = server.reset;

  this.Rocket.globals = globals;

  $((function(_this) {
    return function() {
      var center_line;
      center_line = $("<div id='center_line'></div>");
      center_line.css('left', "" + ($('#slider').width() / 2) + "px");
      $('#slider').append(center_line);
      return $('#slider').click(function(event) {
        var indicator, indicator_width, left, middle, new_angle, offsetX;
        offsetX = event.offsetX;
        middle = $(_this).width() / 2;
        new_angle = (offsetX - middle) / middle;
        indicator_width = 20;
        left = offsetX - (indicator_width / 2);
        indicator = $("<div id='indicator'></div>");
        indicator.css('left', "" + left + "px");
        if ($('#indicator').length) {
          $('#indicator').css('left', "" + left + "px");
        } else {
          $('#slider').append(indicator);
        }
        return server.socket.emit('update-input', new_angle);
      });
    };
  })(this));

}).call(this);
