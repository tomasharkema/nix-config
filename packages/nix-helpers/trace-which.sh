#!/usr/bin/env sh
a=$(which "$1") && exec trace-symlink "$a"
