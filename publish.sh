#!/bin/bash

VERSION="${1}"
NOW=$(date +"%m-%d-%Y-%H-%M-%S")

if [ -n "$VERSION" ]; then
    docker image push daasllc/devcontainer:"$VERSION" 2>&1 | tee publish-"$NOW".log
else
    echo "[INFO] Please specify a version."
fi