#!/bin/sh -l

export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/go/bin

# Установка EasyP указанной версии
go install github.com/easyp-tech/easyp/cmd/easyp@$1

# Проверка, что EasyP установлен
if! command -v easyp > /dev/null; then
  echo "EasyP installation failed or EasyP is not in the PATH"
  exit 1
fi

# Проверка, что указан каталог
if [ -z "$2" ]; then
  echo "Please provide the directory path to lint."
  exit 1
fi

# Запуск линтера
easyp lint -p $2 | while IFS=: read -r filepath line column code message; do
  echo "::error file=$filepath,line=$line,column=$column::$message"
done