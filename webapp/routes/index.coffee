express = require('express')
router = express.Router()
 
router.get('/', (request, response) ->
    response.render('index', { title: 'Sample Node.js', message: 'Hello there!', host: '192.168.10.103' })
    return
)
 
module.exports = router
