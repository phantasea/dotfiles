#!/bin/sh

#google='http://google.com/search?btnG=Google&q'
#google='https://search.yahoo.com/search?p'
google='http://www.webcrawler.com/search/web?fcoid=417&q'

query=${QUERY_STRING#*:}

cat <<_END_
Content-type: text/plain
W3m-control: GOTO $google=$query
W3m-control: DELETE_PREVBUF
W3m-control: SEARCH $query
_END_
