#!/bin/sh

baidu="http://www.baidu.com/s?wd"

query=${QUERY_STRING#*:}

cat <<_END_
Content-type: text/plain
W3m-control: GOTO $baidu=$query
W3m-control: DELETE_PREVBUF
W3m-control: SEARCH $query
_END_
