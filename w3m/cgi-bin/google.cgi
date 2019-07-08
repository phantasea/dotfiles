#!/bin/sh

google='https://www.google.com/search?btnG=Google&lr=lang_en&hl=en&q'
#google='https://search.yahoo.com/search?p'
#google='http://www.webcrawler.com/search/web?fcoid=417&q'
#google='https://duckduckgo.com/?q'

query=${QUERY_STRING#*:}

cat <<_END_
Content-type: text/plain
W3m-control: GOTO $google=$query
W3m-control: DELETE_PREVBUF
W3m-control: SEARCH $query
_END_
