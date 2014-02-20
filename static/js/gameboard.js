(function() {
  var Gameboard, gameboard;

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
      var button, circle, div, form, g, h1, img, input, li, rect, svg, ul, _ref;
      _ref = React.DOM, h1 = _ref.h1, div = _ref.div, svg = _ref.svg, rect = _ref.rect, g = _ref.g, ul = _ref.ul, li = _ref.li, form = _ref.form, input = _ref.input, button = _ref.button, img = _ref.img, circle = _ref.circle;
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
            }), circle({
              r: this.state.rocket.radius,
              cx: this.state.rocket.position.X - 50,
              cy: this.state.rocket.position.Y - 50,
              fill: "#008d46"
            })
          ])
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
