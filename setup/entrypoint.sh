#!/bin/sh -l

export PATH=$PATH:/usr/local/go/bin

# Установка EasyP
go install github.com/easyp-tech/easyp/cmd/easyp@v0.2
