var express = require("express"),
    app = express()

var router = express.Router();

router.get('/', function(req, res) {
   res.send(process.env);
});

app.use(router);

app.listen(process.env.NODEJS_PORT, function() {

  var port = process.env.NODEJS_PORT
  var host = "localhost"

  console.log("GlobalPaaS nodejs-test server running on http://%s:%s",host,port);
});

