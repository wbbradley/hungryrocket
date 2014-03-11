(function() {
  var Gameboard, button, circle, div, form, g, gameboard, globalHeight, h1, img, input, li, line, rect, svg, text, ul, _ref;

  _ref = React.DOM, h1 = _ref.h1, div = _ref.div, svg = _ref.svg, rect = _ref.rect, text = _ref.text, g = _ref.g, ul = _ref.ul, li = _ref.li, form = _ref.form, input = _ref.input, button = _ref.button, img = _ref.img, circle = _ref.circle, line = _ref.line;

  globalHeight = '';

  gameboard = null;

  Gameboard = React.createClass({
    getDefaultProps: function() {
      return {
        username: null,
        players: [],
        arena: {
          radius: 1000
        },
        rocket: {
          angle: 0,
          radius: 75,
          position: {
            X: 0,
            Y: 0
          }
        }
      };
    },
    arenaViewBox: function() {
      var arena;
      arena = this.props.arena;
      return "" + (-arena.radius) + " " + (-arena.radius) + " " + (arena.radius * 2) + " " + (arena.radius * 2);
    },
    render: function() {
      var angle, idx, labels, player, timestamp, _i, _len, _ref1;
      labels = [];
      if (this.props.players != null) {
        _ref1 = this.props.players;
        for (idx = _i = 0, _len = _ref1.length; _i < _len; idx = ++_i) {
          player = _ref1[idx];
          angle = (idx + 0.5) * 2 * Math.PI / this.props.players.length;
          timestamp = (new Date()).getTime() / 1000.0;
          labels.push(text({
            key: idx,
            x: this.props.arena.radius * .75 * Math.cos(angle),
            y: this.props.arena.radius * .75 * Math.sin(angle),
            className: 'score'
          }, player.name));
        }
      }
      return div({}, [
        (typeof props !== "undefined" && props !== null ? props.username : void 0) != null ? h1({}, ["'ello guvna " + this.props.username]) : null, div({
          style: {
            position: 'relative',
            width: '100%',
            height: "" + globalHeight + "px",
            display: 'inline-block'
          }
        }, [
          svg({
            xmlns: "http://www.w3.org/2000/svg",
            width: '100%',
            height: '100%',
            viewBox: this.arenaViewBox()
          }, [
            circle({
              r: this.props.arena.radius,
              cx: 0,
              cy: 0,
              fill: "#f0fdf6"
            }), line({
              x1: this.props.rocket.position.X,
              y1: this.props.rocket.position.Y,
              x2: this.props.rocket.position.X + (Math.cos(this.props.rocket.angle + Math.PI) * this.props.rocket.radius * 1.5),
              y2: this.props.rocket.position.Y + (Math.sin(this.props.rocket.angle + Math.PI) * this.props.rocket.radius * 1.5),
              stroke: "orange",
              strokeWidth: 50,
              fill: "#008d46"
            }), circle({
              r: this.props.rocket.radius,
              cx: this.props.rocket.position.X,
              cy: this.props.rocket.position.Y,
              fill: "#008d46"
            })
          ].concat(labels))
        ])
      ]);
    }
  });

  gameboard = Gameboard({
    globals: Rocket.globals
  });

  "test_update = ->\n  timestamp = (new Date()).getTime() / 1000.0\n  gameboard.setprops\n    rocket:\n      position:\n        X: Math.cos(timestamp) * 200\n        Y: Math.sin(timestamp) * 200\n\nwindow.setInterval test_update, 50";

  $((function(_this) {
    return function() {
      globalHeight = $(document).height() - $('#slider').height() - $('#login').height() - 100;
      React.renderComponent(gameboard, document.getElementById('gameboard'));
      return _this.gameboard = gameboard;
    };
  })(this));

}).call(this);
