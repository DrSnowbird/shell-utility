#!/bin/bash -x

wget --quiet \
  --method GET \
  --header 'accept: application/sparql-results+json' \
  --header 'cache-control: no-cache' \
  --header 'postman-token: 5cf017e0-db09-6272-de43-5ac5002e80c0' \
  --output-document \
  - 'http://192.168.0.160:9999/bigdata/sparql?query=select%20%3Fs%20%3Fp%20%3Fo%20%7B%20%3Fs%20%3Fp%20%3Fo%20.%20%7D'
