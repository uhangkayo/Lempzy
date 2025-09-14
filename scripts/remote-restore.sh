#!/bin/bash

# Ensure required command is available
if ! command -v tar >/dev/null 2>&1; then
  echo "Error: tar is required but not installed." >&2
  exit 1
fi

# ... additional restore logic goes here ...
