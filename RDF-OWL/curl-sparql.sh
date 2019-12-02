#/bin/bash -x

#curl can also do the URL encoding for you:

if [ $# -lt 2 ]; then
    echo "*** ERROR: Need SPARQL server URL, e.g.,"
    echo " http://192.168.0.160:9999/bigdata/sparql?query=select ?s ?p ?o { ?s ?p ?o . }"
    exit 1
fi

SPARQL_URL=${1:-http://192.168.0.160:9999/bigdata/sparql}
QUERY=${2:-"select ?s ?p ?o { ?s ?p ?o . } limit 20"}

QUERY_EXAMPLE="select distinct ?type where { ?thing a ?type } limit 20"

curl -G --data-urlencode query="${SPARQL_URL}?query=${QUERY}"
