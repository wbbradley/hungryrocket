express = require 'express'
port = 3000
app = express()

app.set 'views', (__dirname + '/views')
app.engine '.html', require('ejs').renderFile
app.use express.static(__dirname + '/static')

app.get('/', (req, res)->
	res.render 'index.html'
)

app.listen port
console.log "Listening on port #{port}"