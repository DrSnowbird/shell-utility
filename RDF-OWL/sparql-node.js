var request = require("request");

var options = { method: 'GET',
  url: 'http://192.168.0.160:9999/bigdata/sparql',
  qs: { query: 'select ?s ?p ?o { ?s ?p ?o . }' },
  headers: 
   { 'postman-token': '288bfb82-fedc-dc6a-b39a-fe0573695ec8',
     'cache-control': 'no-cache',
     accept: 'application/sparql-results+json' } };

request(options, function (error, response, body) {
  if (error) throw new Error(error);

  console.log(body);
});

