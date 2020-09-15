#/!/usr/bin/env bash

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Linux-GNU"
    sh Installation/Ubuntu/janus.sh
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Darwin"
    sh Installation/Macosx/janus.sh
elif [[ "$OSTYPE" == "cygwin" ]]; then
    echo "WIN"
    sh Installation/Ubuntu/janus.sh
elif [[ "$OSTYPE" == "freebsd"* ]]; then
    echo "Freebsd"
else
    echo "I Guess It is Linux"
    sh Installation/Ubuntu/janus.sh
fi
