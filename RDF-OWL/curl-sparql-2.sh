#!/bin/bash -x

curl --request GET \
  --url 'http://192.168.0.160:9999/bigdata/sparql?query=select%20%3Fs%20%3Fp%20%3Fo%20%7B%20%3Fs%20%3Fp%20%3Fo%20.%20%7D' \
  --header 'accept: application/sparql-results+json' \
  --header 'cache-control: no-cache' \
  --header 'postman-token: 5abc3d06-d70b-c5ff-4307-bedc52e62c51'
