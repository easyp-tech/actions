#!/bin/sh -l

export PATH=$PATH:/usr/local/go/bin

go install github.com/easyp-tech/easyp/cmd/easyp@$1

# Check if the version is provided
if [ -z "$2" ]
then
  echo "Please provide the directory path to lint."
  exit 1
fi

# Run linter
easyp lint -p $2