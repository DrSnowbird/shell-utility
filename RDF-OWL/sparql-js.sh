var http = require("http");

var options = {
  "method": "GET",
  "hostname": "192.168.0.160",
  "port": "9999",
  "path": "/bigdata/sparql?query=select%20%3Fs%20%3Fp%20%3Fo%20%7B%20%3Fs%20%3Fp%20%3Fo%20.%20%7D",
  "headers": {
    "accept": "application/sparql-results+json",
    "cache-control": "no-cache",
    "postman-token": "43d11728-2d72-ca84-85f8-b8913dfd6610"
  }
};

var req = http.request(options, function (res) {
  var chunks = [];

  res.on("data", function (chunk) {
    chunks.push(chunk);
  });

  res.on("end", function () {
    var body = Buffer.concat(chunks);
    console.log(body.toString());
  });
});

req.end();
