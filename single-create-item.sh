#!/usr/bin/env bash

source book_data.rc

idx="$(($((10#$1)) - 1))"

IFS=":" read -r title author <<< "${books[$idx]}"

#printf "TITLE=[%s]\tAUTHOR=[%s]\n" "$title" "$title"

xh --ignore-stdin post $HOST:$PORT/book/ title="$title" author="$author" synopsis="..." | jq '.'
