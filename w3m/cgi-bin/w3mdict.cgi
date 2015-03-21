#!/bin/sh

google='http://google.com/search?btnG=Google&q'

cat <<_END_
Content-type: text/plain
W3m-control: TAB_GOTO $google=$QUERY_STRING
W3m-control: SEARCH 1\.
_END_
