#!/bin/sh

query="上一页"

cat <<_END_
Content-type: text/plain
W3m-control: SEARCH $query
W3m-control: PREV
W3m-control: SEARCH_NEXT
W3m-control: GOTO_LINK
_END_
