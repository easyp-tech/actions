#!/bin/sh -l

export PATH=$PATH:/usr/local/go/bin

go install github.com/easyp-tech/easyp/cmd/easyp@$1
