#!/bin/sh -l

# Check EasyP is installed
echo ls -l /usr/local/go/bin

export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin

# Check if the version is provided
if [ -z "$1" ]
then
  echo "Please provide the directory path to lint."
  exit 1
fi



# Run linter
easyp lint -p $1