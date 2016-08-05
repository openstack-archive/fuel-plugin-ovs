#!/bin/bash

arch=$(dpkg --print-architecture)
case $arch in
    amd64|i386)
        echo "Architecture ${arch} supported, go on with test"
        ;;
    *)
        echo "Architecture ${arch} not supported, SKIP test"
        exit 0
        ;;
esac
