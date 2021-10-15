#!/bin/bash

VERSION="${1}"

if [ -n "${VERSION}" ]; then
    docker build . --progress plain -t daasllc/devcontainer:${VERSION}
else
    echo "[INFO] Please specify a version."
fi