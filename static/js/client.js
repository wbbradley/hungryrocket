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
      var game, _ref;
      game = (_ref = gameboard.state) != null ? _ref.game : void 0;
      if (game) {
        return this.socket.emit('reset-game', {
          id: game.id
        });
      }
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
      var center_line, left_degrees, left_interval, right_degrees, right_interval;
      center_line = $("<div id='center_line'></div>");
      center_line.css('left', "50%");
      $('#slider').append(center_line);
      $('#slider').click(function(event) {
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
      left_interval = null;
      left_degrees = 0;
      $('#go-left').on('mousedown', function() {
        if (!left_interval) {
          left_degrees += 0.1;
          left_interval = setInterval(function() {
            if (left_degrees < 1) {
              left_degrees += -0.1;
            }
            return server.socket.emit('update-input', left_degrees);
          }, 100);
          return server.socket.emit('update-input', left_degrees);
        }
      });
      $('#go-left').on('mouseup', function() {
        if (left_interval) {
          clearInterval(left_interval);
          left_interval = null;
          left_degrees = 0;
          return server.socket.emit('update-input', left_degrees);
        }
      });
      right_interval = null;
      right_degrees = 0;
      $('#go-right').on('mousedown', function() {
        if (!right_interval) {
          right_degrees -= 0.1;
          right_interval = setInterval(function() {
            if (right_degrees > -1) {
              right_degrees -= -0.1;
            }
            return server.socket.emit('update-input', right_degrees);
          }, 100);
          return server.socket.emit('update-input', right_degrees);
        }
      });
      return $('#go-right').on('mouseup', function() {
        if (right_interval) {
          clearInterval(right_interval);
          right_interval = null;
          right_degrees = 0;
          return server.socket.emit('update-input', right_degrees);
        }
      });
    };
  })(this));

}).call(this);
