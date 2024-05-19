#!/bin/sh -l

set -euo pipefail

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

# for format 'echo "::error file=app.js,line=1,col=5::Missing semicolon"'
# example currency/v1/currency.proto:321:3:CODE_ZWR: enum value comment is empty
# will be converted to
# echo "::error file=currency/v1/currency.proto,line=321,col=3::CODE_ZWR: enum value comment is empty"
# must ignore not matching lines

# Process each line of the output
echo "$output" | while IFS= read -r line; do
  echo "Processing line: $line"
  if [[ $line =~ ^(.+):([0-9]+):([0-9]+):(.+)$ ]]; then
    # If the line matches the format file:line:column:message, format it for GitHub Actions
    echo "::error file=${BASH_REMATCH[1]},line=${BASH_REMATCH[2]},col=${BASH_REMATCH[3]}::${BASH_REMATCH[4]}"
  else
    # If the line does not match the expected format, print it as is
    echo "$line"
  fi
done