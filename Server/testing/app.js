const express = require("express");
const app = express();
let http = require("http").Server(app);

const port = process.env.PORT || 3000;

let io = require("socket.io")(http);

app.use(express.static("public"));

http.listen(port, function () {
  console.log("Listening on, ", port);
},);
