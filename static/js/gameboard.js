/** @jsx React.DOM */
var gameboard;

Gameboard = React.createClass({
	getInitialState: function () {
		return {
			username: null,
		   	gamestate: null,
			flag: {
				width: 1
			}
		}
	},
	render: function() {
		return (
			<div>
				<h1>Hello {this.state.username}!</h1>
				<div>gamestate is {this.state.gamestate}</div>
				<svg xmlns="http://www.w3.org/2000/svg" 
					 width="150" height="100" viewBox="0 0 3 2">

					<rect width={this.state.flag.width} height="2" x={this.state.flag.x} fill="#008d46" />
					<rect width="1" height="2" x="1" fill="#ffffff" />
					<rect width="1" height="2" x="2" fill="#d2232c" />
				</svg>
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
