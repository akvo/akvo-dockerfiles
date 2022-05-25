#!/usr/bin/env bash

set -euo pipefail

apt-get update
apt-get install --no-install-recommends -y \
    graphviz=2.42.2-5 \
    imagemagick=8:6.9.11.60+dfsg-1.3 \
    make=4.3-4.1
apt-get autoremove
apt-get clean
rm -rf /var/lib/apt/lists/*
pip3 install --no-cache-dir -r requirements.txt
