(function() {
  var Server, globals, server,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  globals = {
    viewport: {
      width: '320px',
      height: '320px'
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
      game = (_ref = gameboard.props) != null ? _ref.game : void 0;
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
      gameboard.setProps({
        username: name
      });
      return this.socket.emit('set-name', name);
    };

    Server.prototype.update_game_state = function(game_state) {
      return gameboard.setProps(game_state);
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
      var angle, calcAngle, center_line, slide, slider_interval;
      center_line = $("<div id='center_line'></div>");
      center_line.css('left', "50%");
      $('#slider').append(center_line);
      slider_interval = null;
      angle = 0;
      slide = false;
      calcAngle = function(offsetX, width) {
        var middle;
        middle = width / 2;
        return (offsetX - middle) / middle;
      };
      setInterval(function() {
        return server.socket.emit('update-input', angle);
      }, 35);
      $('#slider').on('mousemove', function(event) {
        var indicator, left;
        if (slide && event.target.id === 'slider') {
          indicator = $('#indicator');
          angle = calcAngle(event.offsetX, $(_this).width());
          left = event.offsetX - (indicator.width() / 2);
          return indicator.css('left', "" + left + "px");
        }
      });
      $('#slider').on('mousedown', function(event) {
        var indicator, left;
        if (!slide) {
          $('#indicator').remove();
          slide = true;
          angle = calcAngle(event.offsetX, $(_this).width());
          indicator = $("<div id='indicator'></div>");
          $('#slider').append(indicator);
          left = event.offsetX - (indicator.width() / 2);
          return indicator.css('left', "" + left + "px");
        }
      });
      return $('#slider').on('mouseup', function(event) {
        return slide = false;
      });
    };
  })(this));

}).call(this);
