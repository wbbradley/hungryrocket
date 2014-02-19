(function() {
  var Gameboard, gameboard, test_update;

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
          position: {
            X: 0,
            Y: 0
          }
        }
      };
    },
    view_coord_len: function(x) {
      return x / (2.0 * this.state.arena.radius) * globals.viewport.width;
    },
    arenaViewBox: function() {
      var arena;
      arena = this.state.arena;
      return "" + (-arena.radius) + " " + (-arena.radius) + " " + (arena.radius * 2) + " " + (arena.radius * 2);
    },
    render: function() {
      var button, div, form, g, h1, input, li, rect, svg, ul, _ref;
      _ref = React.DOM, h1 = _ref.h1, div = _ref.div, svg = _ref.svg, rect = _ref.rect, g = _ref.g, ul = _ref.ul, li = _ref.li, form = _ref.form, input = _ref.input, button = _ref.button;
      return div({}, [
        h1({}, ['ello' + this.state.username]), svg({
          xmlns: "http://www.w3.org/2000/svg",
          width: Rocket.globals.viewport.width,
          height: Rocket.globals.viewport.height,
          viewBox: this.arenaViewBox()
        }, [
          rect({
            width: 100,
            height: 200,
            x: this.state.rocket.position.X,
            y: this.state.rocket.position.Y,
            fill: "#008d46"
          }), rect({
            width: 100,
            height: 200,
            x: 1,
            fill: "#fff"
          }), rect({
            width: 100,
            height: 200,
            x: 2,
            fill: "#d2232c"
          })
        ])
      ]);
    }
  });

  gameboard = Gameboard({
    globals: Rocket.globals
  });

  test_update = function() {
    var timestamp;
    timestamp = (new Date()).getTime() / 1000.0;
    return gameboard.setState({
      rocket: {
        position: {
          X: Math.cos(timestamp) * 200,
          Y: Math.sin(timestamp) * 200
        }
      }
    });
  };

  window.setInterval(test_update, 50);

  React.renderComponent(gameboard, document.getElementById('gameboard'));

  this.gameboard = gameboard;

}).call(this);
