#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Usage: $0 <commit hash>"
    echo "Example: $0 -h"
    exit 1
fi

cd "$HOME/fast-ebpftracing/ipftrace2/"
git checkout $1 || exit $?
./scripts/make.sh || exit $?
sudo cp src/ipft /usr/local/bin/ipft

echo "ipft attach successfully, commit hash: $1"
cd "$HOME/fast-ebpftracing/"
