#!/bin/sh

#wiki='https://en.wikipedia.org/wiki'    #W3m-control: GOTO $wiki/$query
wiki='https://en.wikipedia.org/w/index.php?title=Special%3ASearch&fulltext=Search&search'

query=${QUERY_STRING#*:}

cat <<_END_
Content-type: text/plain
W3m-control: GOTO $wiki=$query
W3m-control: DELETE_PREVBUF
_END_
