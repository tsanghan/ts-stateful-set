#!/usr/bin/env bash

printf "Deleting book id %s\n\n" "$1"

xh delete $HOST:$PORT/book/"$1"
