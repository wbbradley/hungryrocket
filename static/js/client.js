(function() {
  var Server, server,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

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

  $((function(_this) {
    return function() {
      var angle, calcNumPx, center_line, indicator, setAngle, slide, slider, slider_interval;
      slider = $('#slider');
      center_line = $("<div id='center_line'></div>");
      center_line.css('left', "50%");
      slider.append(center_line);
      indicator = $("<div id='indicator'></div>");
      slider.append(indicator);
      indicator.css('left', "" + ((slider.width() - indicator.width()) / 2) + "px");
      slider_interval = slider.width() / 60;
      angle = 0;
      slide = false;
      calcNumPx = function(leftPx) {
        return Number(leftPx.slice(0, leftPx.length - 2));
      };
      setAngle = function(offsetX) {
        var middle;
        middle = (slider.width() - indicator.width()) / 2;
        return angle = (offsetX - middle) / middle;
      };
      setInterval(function() {
        return server.socket.emit('update-input', angle);
      }, 35);
      $(document).on('keydown', function(event) {
        var left;
        left = calcNumPx(indicator.css('left'));
        if (event.keyCode === 37) {
          indicator.css('left', "" + (left - slider_interval) + "px");
        } else if (event.keyCode === 39) {
          indicator.css('left', "" + (left + slider_interval) + "px");
        }
        return setAngle(calcNumPx(indicator.css('left')));
      });
      slider.on('mousemove', function(event) {
        var left;
        if (slide && event.target.id === 'slider') {
          setAngle(event.offsetX);
          left = event.offsetX - (indicator.width() / 2);
          return indicator.css('left', "" + left + "px");
        }
      });
      slider.on('mousedown', function(event) {
        var left;
        if (!slide) {
          slide = true;
          setAngle(event.offsetX);
          left = event.offsetX - (indicator.width() / 2);
          return indicator.css('left', "" + left + "px");
        }
      });
      return slider.on('mouseup', function() {
        return slide = false;
      });
    };
  })(this));

}).call(this);
