/** @jsx React.DOM */
var gameboard;

Gameboard = React.createClass({
	getInitialState: function () {
		return {username: null, gamestate: null}
	},
	render: function() {
		return (
			<div>
				<h1>Hello {this.state.username}!</h1>
				<div>gamestate is {this.state.gamestate}</div>
			</div>
		);
	}
});
gameboard = Gameboard()
React.renderComponent(
	gameboard,
	document.getElementById('gameboard')
	);
this.gameboard = gameboard
