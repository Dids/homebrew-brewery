#!/usr/bin/env bash

set -eux

FORMULA=${1:-*}

brew audit ./Formula/${FORMULA}.rb
