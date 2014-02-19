express = require 'express'
port = 3000
app = express()

app.get('/', (res, req)->
	res.render 'index.html'
)

app.listen port
console.log "Listening on port #{port}"