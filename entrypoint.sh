#!/bin/sh

# `$*` expands the `args` supplied in an `array` individually 
# or splits `args` in a string separated by whitespace.
export K6_CLOUD_TOKEN=$INPUT_TOKEN
if [ "$INPUT_CLOUD" = "true" ]; then
  K6_COMMAND="cloud"
else
  K6_COMMAND="run"
fi

# Build the argument list safely to prevent shell injection.
# INPUT_FLAGS is a space-separated list of flags; use set -- to tokenize.
set -- "$K6_COMMAND" "$INPUT_FILENAME"
if [ -n "$INPUT_FLAGS" ]; then
  # shellcheck disable=SC2086
  set -- "$@" $INPUT_FLAGS
fi
k6 "$@"
