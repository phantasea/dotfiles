#!/bin/sh
google='http://google.com/search?btnG=Google&q'
query=${QUERY_STRING#*:}

cat <<_END_
Content-type: text/plain
W3m-control: GOTO $google=$query
W3m-control: DELETE_PREVBUF
W3m-control: SEARCH 1\.
_END_
