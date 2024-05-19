#!/bin/sh -l

set -euo pipefail
IFS=$'\n\t'

export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/go/bin

# Install EasyP with the given version
go install github.com/easyp-tech/easyp/cmd/easyp@$1

# Check if EasyP installed successfully
if ! command -v easyp > /dev/null; then
  echo "EasyP installation failed or EasyP is not in the PATH"
  exit 1
fi

# Check if a directory was provided
if [ -z "$2" ]; then
  echo "Please provide the directory path to lint."
  exit 1
fi

# Run EasyP linter and format its output
output=$(easyp lint -p "$2")

# Emit GitHub Actions error logs
while IFS= read -r line; do
  if [[ "$line" =~ ^([^[:space:]]+)[[:space:]]*:([[:digit:]]+):([[:digit:]]+).* ]]; then
    file=${BASH_REMATCH[1]}
    line=${BASH_REMATCH[2]}
    col=${BASH_REMATCH[3]}
    issue=$(printf "%s:%s:%s Missing semicolon" "$file" "$line" "$col")
    echo "::error file=$file,line=$line,col=$col::$issue"
  fi
done <<< "$output"