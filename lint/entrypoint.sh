#!/bin/sh -l

export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/go/bin

# Установка EasyP указанной версии
go install github.com/easyp-tech/easyp/cmd/easyp@$1

# Проверка, что EasyP установлен
if ! command -v easyp > /dev/null; then
  echo "::error::EasyP installation failed or EasyP is not in the PATH"
  exit 1
fi

# Проверка, что указан каталог
if [ -z "$2" ]; then
  echo "::error::Please provide the directory path to lint."
  exit 1
fi

# Запуск линтера и обработка вывода
lint_output=$(easyp lint -p $2)

if [ $? -eq 0 ]; then
  echo "Linting passed with no errors."
else
  echo "Linting found issues."
  echo "$lint_output"

  # Пример обработки вывода линтера для предоставленного формата:
  echo "$lint_output" | while read -r line; do
    if echo "$line" | grep -qE '(.+):([0-9]+):([0-9]+):(.+): (.+)'; then
      filename=$(echo "$line" | cut -d ':' -f 1)
      linenumber=$(echo "$line" | cut -d ':' -f 2)
      columnnumber=$(echo "$line" | cut -d ':' -f 3)
      code=$(echo "$line" | cut -d ':' -f 4)
      message=$(echo "$line" | cut -d ':' -f 5-)
      echo "::error file=$filename,line=$linenumber,col=$columnnumber::$code - $message"
    fi
  done

  exit 1
fi