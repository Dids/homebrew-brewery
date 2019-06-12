#!/usr/bin/env bash

set -eux

FORMULA=${1:-*}

brew install ./Formula/${FORMULA}.rb
brew test ./Formula/${FORMULA}.rb
