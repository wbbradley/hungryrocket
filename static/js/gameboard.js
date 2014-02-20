(function() {
  var Gameboard, button, circle, div, form, g, gameboard, h1, img, input, li, line, rect, svg, text, ul, _ref;

  _ref = React.DOM, h1 = _ref.h1, div = _ref.div, svg = _ref.svg, rect = _ref.rect, text = _ref.text, g = _ref.g, ul = _ref.ul, li = _ref.li, form = _ref.form, input = _ref.input, button = _ref.button, img = _ref.img, circle = _ref.circle, line = _ref.line;

  gameboard = null;

  Gameboard = React.createClass({
    getInitialState: function() {
      return {
        username: null,
        gamestate: null,
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
      arena = this.state.arena;
      return "" + (-arena.radius) + " " + (-arena.radius) + " " + (arena.radius * 2) + " " + (arena.radius * 2);
    },
    render: function() {
      var angle, idx, labels, player, _i, _len, _ref1;
      labels = [];
      if (this.state.players != null) {
        _ref1 = this.state.players;
        for (idx = _i = 0, _len = _ref1.length; _i < _len; idx = ++_i) {
          player = _ref1[idx];
          angle = (idx + 0.5) * 2 * Math.PI / this.state.players.length;
          labels.push(text({
            x: this.state.arena.radius * .75 * Math.cos(angle),
            y: this.state.arena.radius * .75 * Math.sin(angle),
            className: 'score'
          }, "" + player.name + ": " + (player != null ? player.score : void 0)));
        }
      }
      return div({}, [
        h1({}, ['ello' + this.state.username]), div({
          style: {
            position: 'relative'
          },
          width: Rocket.globals.viewport.width,
          height: Rocket.globals.viewport.height
        }, [
          svg({
            xmlns: "http://www.w3.org/2000/svg",
            width: '100%',
            height: '100%',
            viewBox: this.arenaViewBox()
          }, [
            circle({
              r: this.state.arena.radius,
              cx: 0,
              cy: 0,
              fill: "#f0fdf6"
            }), line({
              x1: this.state.rocket.position.X,
              y1: this.state.rocket.position.Y,
              x2: this.state.rocket.position.X + (Math.cos(this.state.rocket.angle + Math.PI) * this.state.rocket.radius * 1.5),
              y2: this.state.rocket.position.Y + (Math.sin(this.state.rocket.angle + Math.PI) * this.state.rocket.radius * 1.5),
              stroke: "orange",
              strokeWidth: 50,
              fill: "#008d46"
            }), circle({
              r: this.state.rocket.radius,
              cx: this.state.rocket.position.X,
              cy: this.state.rocket.position.Y,
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

  "test_update = ->\n  timestamp = (new Date()).getTime() / 1000.0\n  gameboard.setState\n    rocket:\n      position:\n        X: Math.cos(timestamp) * 200\n        Y: Math.sin(timestamp) * 200\n\nwindow.setInterval test_update, 50";

  React.renderComponent(gameboard, document.getElementById('gameboard'));

  this.gameboard = gameboard;

}).call(this);
