#!/bin/sh

wiki='http://en.wikipedia.org/wiki'
query=${QUERY_STRING#*:}

cat <<_END_
Content-type: text/plain
W3m-control: GOTO $wiki/$query
W3m-control: DELETE_PREVBUF
_END_
